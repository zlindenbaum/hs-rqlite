# file: flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    systems.url = "github:nix-systems/default";
    ekg-json.url = "github:aravindgopall/ekg-json";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.haskell-flake.flakeModule
      ];
      perSystem = { self', system, lib, config, pkgs, ... }: {
        haskellProjects.default = {
           #basePackages = pkgs.haskellPackages;
          basePackages = pkgs.haskell.packages.ghc96;

          # Packages to add on top of `basePackages`, e.g. from Hackage
          packages = {
            #aeson.source = "1.5.0.0" # Hackage version
          };

          # my-haskell-package development shell configuration
          devShell = {
            hlsCheck.enable = false;
          };

          settings = {

          };

          # What should haskell-flake add to flake outputs?
          autoWire = [ "packages" "apps" "checks" ]; # Wire all but the devShell
        };
        packages.default = self'.packages.hs-rqlite;

        devShells.default = pkgs.mkShell {
          name = "hs-rqlite";
          inputsFrom = [
            config.haskellProjects.default.outputs.devShell
          ];
          nativeBuildInputs = with pkgs; [
            # other development tools.
          ];
        };
      };
    };
}
