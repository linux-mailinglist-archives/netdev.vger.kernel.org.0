Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78274B552
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbfFSJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:48:29 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:46295 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbfFSJs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:48:29 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id F094C20001B;
        Wed, 19 Jun 2019 09:48:22 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 10/16] dt-bindings: net: sun8i-emac: Convert the binding to a schemas
Date:   Wed, 19 Jun 2019 11:47:19 +0200
Message-Id: <a9c556114ab21793d100f31361da01a579bae84e.1560937626.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch our Allwinner H3 EMAC controller binding to a YAML schema to enable
the DT validation. Since that controller is based on a Synopsys IP, let's
add the validation to that schemas with a bunch of conditionals.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

---

Changes from v2:
  - Switch to phy-connection-type instead of phy-mode
  - Change the delay enum to using multipleOf

Changes from v1:
  - Add specific binding document
---
 Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml | 321 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 Documentation/devicetree/bindings/net/dwmac-sun8i.txt                | 201 +---------------------------------------------
 Documentation/devicetree/bindings/net/snps,dwmac.yaml                |  15 +++-
 3 files changed, 336 insertions(+), 201 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dwmac-sun8i.txt

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
new file mode 100644
index 000000000000..6f68c7f5fc34
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -0,0 +1,321 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/allwinner,sun8i-a83t-gmac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A83t EMAC Device Tree Bindings
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: allwinner,sun8i-a83t-emac
+      - const: allwinner,sun8i-h3-emac
+      - const: allwinner,sun8i-r40-emac
+      - const: allwinner,sun8i-v3s-emac
+      - const: allwinner,sun50i-a64-emac
+      - items:
+        - const: allwinner,sun50i-h6-emac
+        - const: allwinner,sun50i-a64-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  interrupt-names:
+    const: macirq
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: stmmaceth
+
+  syscon:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Phandle to the device containing the EMAC or GMAC clock
+      register
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - phy-connection-type
+  - phy-handle
+  - syscon
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - allwinner,sun8i-a83t-emac
+              - allwinner,sun8i-h3-emac
+              - allwinner,sun8i-v3s-emac
+              - allwinner,sun50i-a64-emac
+
+    then:
+      properties:
+        allwinner,tx-delay-ps:
+          default: 0
+          minimum: 0
+          maximum: 700
+          multipleOf: 100
+          description:
+            External RGMII PHY TX clock delay chain value in ps.
+
+        allwinner,rx-delay-ps:
+          default: 0
+          minimum: 0
+          maximum: 3100
+          multipleOf: 100
+          description:
+            External RGMII PHY TX clock delay chain value in ps.
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - allwinner,sun8i-r40-emac
+
+    then:
+      properties:
+        allwinner,rx-delay-ps:
+          default: 0
+          minimum: 0
+          maximum: 700
+          multipleOf: 100
+          description:
+            External RGMII PHY TX clock delay chain value in ps.
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - allwinner,sun8i-h3-emac
+              - allwinner,sun8i-v3s-emac
+
+    then:
+      properties:
+        allwinner,leds-active-low:
+          $ref: /schemas/types.yaml#definitions/flag
+          description:
+            EPHY LEDs are active low.
+
+        mdio-mux:
+          type: object
+
+          properties:
+            compatible:
+              const: allwinner,sun8i-h3-mdio-mux
+
+            mdio-parent-bus:
+              $ref: /schemas/types.yaml#definitions/phandle
+              description:
+                Phandle to EMAC MDIO.
+
+            mdio@1:
+              type: object
+              description: Internal MDIO Bus
+
+              properties:
+                "#address-cells":
+                  const: 1
+
+                "#size-cells":
+                  const: 0
+
+                compatible:
+                  const: allwinner,sun8i-h3-mdio-internal
+
+                reg:
+                  const: 1
+
+              patternProperties:
+                "^ethernet-phy@[0-9a-f]$":
+                  type: object
+                  description:
+                    Integrated PHY node
+
+                  properties:
+                    clocks:
+                      maxItems: 1
+
+                    resets:
+                      maxItems: 1
+
+                  required:
+                    - clocks
+                    - resets
+
+
+            mdio@2:
+              type: object
+              description: External MDIO Bus (H3 only)
+
+              properties:
+                "#address-cells":
+                  const: 1
+
+                "#size-cells":
+                  const: 0
+
+                reg:
+                  const: 2
+
+          required:
+            - compatible
+            - mdio-parent-bus
+            - mdio@1
+
+examples:
+  - |
+    ethernet@1c0b000 {
+        compatible = "allwinner,sun8i-h3-emac";
+        syscon = <&syscon>;
+        reg = <0x01c0b000 0x104>;
+        interrupts = <0 82 1>;
+        interrupt-names = "macirq";
+        resets = <&ccu 12>;
+        reset-names = "stmmaceth";
+        clocks = <&ccu 27>;
+        clock-names = "stmmaceth";
+
+        phy-handle = <&int_mii_phy>;
+        phy-connection-type = "mii";
+        allwinner,leds-active-low;
+
+        mdio1: mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "snps,dwmac-mdio";
+        };
+
+        mdio-mux {
+            compatible = "allwinner,sun8i-h3-mdio-mux";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            mdio-parent-bus = <&mdio1>;
+
+            int_mii_phy: mdio@1 {
+                compatible = "allwinner,sun8i-h3-mdio-internal";
+                reg = <1>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                ethernet-phy@1 {
+                    reg = <1>;
+                    clocks = <&ccu 67>;
+                    resets = <&ccu 39>;
+                    phy-is-integrated;
+                };
+            };
+
+            mdio@2 {
+                reg = <2>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+            };
+        };
+    };
+
+  - |
+    ethernet@1c0b000 {
+        compatible = "allwinner,sun8i-h3-emac";
+        syscon = <&syscon>;
+        reg = <0x01c0b000 0x104>;
+        interrupts = <0 82 1>;
+        interrupt-names = "macirq";
+        resets = <&ccu 12>;
+        reset-names = "stmmaceth";
+        clocks = <&ccu 27>;
+        clock-names = "stmmaceth";
+
+        phy-handle = <&ext_rgmii_phy>;
+        phy-connection-type = "rgmii";
+        allwinner,leds-active-low;
+
+        mdio2: mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "snps,dwmac-mdio";
+        };
+
+        mdio-mux {
+            compatible = "allwinner,sun8i-h3-mdio-mux";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            mdio-parent-bus = <&mdio2>;
+
+            mdio@1 {
+                compatible = "allwinner,sun8i-h3-mdio-internal";
+                reg = <1>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                ethernet-phy@1 {
+                    reg = <1>;
+                    clocks = <&ccu 67>;
+                    resets = <&ccu 39>;
+                };
+            };
+
+            mdio@2 {
+                reg = <2>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                ext_rgmii_phy: ethernet-phy@1 {
+                    reg = <1>;
+                };
+            };
+        };
+    };
+
+  - |
+    ethernet@1c0b000 {
+        compatible = "allwinner,sun8i-a83t-emac";
+        syscon = <&syscon>;
+        reg = <0x01c0b000 0x104>;
+        interrupts = <0 82 1>;
+        interrupt-names = "macirq";
+        resets = <&ccu 13>;
+        reset-names = "stmmaceth";
+        clocks = <&ccu 27>;
+        clock-names = "stmmaceth";
+        phy-handle = <&ext_rgmii_phy1>;
+        phy-connection-type = "rgmii";
+
+        mdio {
+            compatible = "snps,dwmac-mdio";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ext_rgmii_phy1: ethernet-phy@1 {
+                reg = <1>;
+            };
+        };
+    };
+
+# FIXME: We should set it, but it would report all the generic
+# properties as additional properties.
+# additionalProperties: false
+
+...
diff --git a/Documentation/devicetree/bindings/net/dwmac-sun8i.txt b/Documentation/devicetree/bindings/net/dwmac-sun8i.txt
deleted file mode 100644
index 54c66d0611cb..000000000000
--- a/Documentation/devicetree/bindings/net/dwmac-sun8i.txt
+++ /dev/null
@@ -1,201 +0,0 @@
-* Allwinner sun8i GMAC ethernet controller
-
-This device is a platform glue layer for stmmac.
-Please see stmmac.txt for the other unchanged properties.
-
-Required properties:
-- compatible: must be one of the following string:
-		"allwinner,sun8i-a83t-emac"
-		"allwinner,sun8i-h3-emac"
-		"allwinner,sun8i-r40-gmac"
-		"allwinner,sun8i-v3s-emac"
-		"allwinner,sun50i-a64-emac"
-		"allwinner,sun50i-h6-emac", "allwinner-sun50i-a64-emac"
-- reg: address and length of the register for the device.
-- interrupts: interrupt for the device
-- interrupt-names: must be "macirq"
-- clocks: A phandle to the reference clock for this device
-- clock-names: must be "stmmaceth"
-- resets: A phandle to the reset control for this device
-- reset-names: must be "stmmaceth"
-- phy-mode: See ethernet.txt
-- phy-handle: See ethernet.txt
-- syscon: A phandle to the device containing the EMAC or GMAC clock register
-
-Optional properties:
-- allwinner,tx-delay-ps: TX clock delay chain value in ps.
-			 Range is 0-700. Default is 0.
-			 Unavailable for allwinner,sun8i-r40-gmac
-- allwinner,rx-delay-ps: RX clock delay chain value in ps.
-			 Range is 0-3100. Default is 0.
-			 Range is 0-700 for allwinner,sun8i-r40-gmac
-Both delay properties need to be a multiple of 100. They control the
-clock delay for external RGMII PHY. They do not apply to the internal
-PHY or external non-RGMII PHYs.
-
-Optional properties for the following compatibles:
-  - "allwinner,sun8i-h3-emac",
-  - "allwinner,sun8i-v3s-emac":
-- allwinner,leds-active-low: EPHY LEDs are active low
-
-Required child node of emac:
-- mdio bus node: should be named mdio with compatible "snps,dwmac-mdio"
-
-Required properties of the mdio node:
-- #address-cells: shall be 1
-- #size-cells: shall be 0
-
-The device node referenced by "phy" or "phy-handle" must be a child node
-of the mdio node. See phy.txt for the generic PHY bindings.
-
-The following compatibles require that the emac node have a mdio-mux child
-node called "mdio-mux":
-  - "allwinner,sun8i-h3-emac"
-  - "allwinner,sun8i-v3s-emac":
-Required properties for the mdio-mux node:
-  - compatible = "allwinner,sun8i-h3-mdio-mux"
-  - mdio-parent-bus: a phandle to EMAC mdio
-  - one child mdio for the integrated mdio with the compatible
-    "allwinner,sun8i-h3-mdio-internal"
-  - one child mdio for the external mdio if present (V3s have none)
-Required properties for the mdio-mux children node:
-  - reg: 1 for internal MDIO bus, 2 for external MDIO bus
-
-The following compatibles require a PHY node representing the integrated
-PHY, under the integrated MDIO bus node if an mdio-mux node is used:
-  - "allwinner,sun8i-h3-emac",
-  - "allwinner,sun8i-v3s-emac":
-
-Additional information regarding generic multiplexer properties can be found
-at Documentation/devicetree/bindings/net/mdio-mux.txt
-
-Required properties of the integrated phy node:
-- clocks: a phandle to the reference clock for the EPHY
-- resets: a phandle to the reset control for the EPHY
-- Must be a child of the integrated mdio
-
-Example with integrated PHY:
-emac: ethernet@1c0b000 {
-	compatible = "allwinner,sun8i-h3-emac";
-	syscon = <&syscon>;
-	reg = <0x01c0b000 0x104>;
-	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq";
-	resets = <&ccu RST_BUS_EMAC>;
-	reset-names = "stmmaceth";
-	clocks = <&ccu CLK_BUS_EMAC>;
-	clock-names = "stmmaceth";
-
-	phy-handle = <&int_mii_phy>;
-	phy-mode = "mii";
-	allwinner,leds-active-low;
-
-	mdio: mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "snps,dwmac-mdio";
-	};
-
-	mdio-mux {
-		compatible = "mdio-mux", "allwinner,sun8i-h3-mdio-mux";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		mdio-parent-bus = <&mdio>;
-
-		int_mdio: mdio@1 {
-			compatible = "allwinner,sun8i-h3-mdio-internal";
-			reg = <1>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			int_mii_phy: ethernet-phy@1 {
-				reg = <1>;
-				clocks = <&ccu CLK_BUS_EPHY>;
-				resets = <&ccu RST_BUS_EPHY>;
-				phy-is-integrated;
-			};
-		};
-		ext_mdio: mdio@2 {
-			reg = <2>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-		};
-	};
-};
-
-Example with external PHY:
-emac: ethernet@1c0b000 {
-	compatible = "allwinner,sun8i-h3-emac";
-	syscon = <&syscon>;
-	reg = <0x01c0b000 0x104>;
-	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq";
-	resets = <&ccu RST_BUS_EMAC>;
-	reset-names = "stmmaceth";
-	clocks = <&ccu CLK_BUS_EMAC>;
-	clock-names = "stmmaceth";
-
-	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
-	allwinner,leds-active-low;
-
-	mdio: mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "snps,dwmac-mdio";
-	};
-
-	mdio-mux {
-		compatible = "allwinner,sun8i-h3-mdio-mux";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		mdio-parent-bus = <&mdio>;
-
-		int_mdio: mdio@1 {
-			compatible = "allwinner,sun8i-h3-mdio-internal";
-			reg = <1>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			int_mii_phy: ethernet-phy@1 {
-				reg = <1>;
-				clocks = <&ccu CLK_BUS_EPHY>;
-				resets = <&ccu RST_BUS_EPHY>;
-			};
-		};
-		ext_mdio: mdio@2 {
-			reg = <2>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			ext_rgmii_phy: ethernet-phy@1 {
-				reg = <1>;
-			};
-		}:
-	};
-};
-
-Example with SoC without integrated PHY
-
-emac: ethernet@1c0b000 {
-	compatible = "allwinner,sun8i-a83t-emac";
-	syscon = <&syscon>;
-	reg = <0x01c0b000 0x104>;
-	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq";
-	resets = <&ccu RST_BUS_EMAC>;
-	reset-names = "stmmaceth";
-	clocks = <&ccu CLK_BUS_EMAC>;
-	clock-names = "stmmaceth";
-
-	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
-
-	mdio: mdio {
-		compatible = "snps,dwmac-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-		ext_rgmii_phy: ethernet-phy@1 {
-			reg = <1>;
-		};
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index fed623a81dcd..956308806c33 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -45,6 +45,11 @@ properties:
     contains:
       enum:
         - allwinner,sun7i-a20-gmac
+        - allwinner,sun8i-a83t-emac
+        - allwinner,sun8i-h3-emac
+        - allwinner,sun8i-r40-emac
+        - allwinner,sun8i-v3s-emac
+        - allwinner,sun50i-a64-emac
         - snps,dwmac
         - snps,dwmac-3.50a
         - snps,dwmac-3.610
@@ -267,6 +272,11 @@ allOf:
           contains:
             enum:
               - allwinner,sun7i-a20-gmac
+              - allwinner,sun8i-a83t-emac
+              - allwinner,sun8i-h3-emac
+              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-v3s-emac
+              - allwinner,sun50i-a64-emac
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
@@ -308,6 +318,11 @@ allOf:
           contains:
             enum:
               - allwinner,sun7i-a20-gmac
+              - allwinner,sun8i-a83t-emac
+              - allwinner,sun8i-h3-emac
+              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-v3s-emac
+              - allwinner,sun50i-a64-emac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwxgmac
-- 
git-series 0.9.1
