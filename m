Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AD45EDE3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377352AbhKZMd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbhKZMb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:31:27 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E985C08E886
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 03:57:07 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed10:97b:45b9:deec:78a4])
        by laurent.telenet-ops.be with bizsmtp
        id Nzx32600F2ipgwy01zx3dj; Fri, 26 Nov 2021 12:57:05 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mqZqg-000R9L-Rh; Fri, 26 Nov 2021 12:57:02 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mqZqg-001ZuC-BM; Fri, 26 Nov 2021 12:57:02 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
Date:   Fri, 26 Nov 2021 12:57:00 +0100
Message-Id: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Cadence MACB/GEM Ethernet controller Device Tree binding
documentation to json-schema.

Re-add "cdns,gem" (removed in commit a217d8711da5c87f ("dt-bindings:
Remove PicoXcell bindings")) as there are active users on non-PicoXcell
platforms.
Add missing "ether_clk" clock.
Add missing properties.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 .../devicetree/bindings/net/cdns,macb.yaml    | 162 ++++++++++++++++++
 .../devicetree/bindings/net/macb.txt          |  60 -------
 2 files changed, 162 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/cdns,macb.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/macb.txt

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
new file mode 100644
index 0000000000000000..c7d00350430aa503
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -0,0 +1,162 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/cdns,macb.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Cadence MACB/GEM Ethernet controller
+
+maintainers:
+  - Nicolas Ferre <nicolas.ferre@microchip.com>
+  - Claudiu Beznea <claudiu.beznea@microchip.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - cdns,at91rm9200-emac  # Atmel at91rm9200 SoC
+          - const: cdns,emac          # Generic
+
+      - items:
+          - enum:
+              - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
+              - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
+          - const: cdns,gem           # Generic
+
+      - items:
+          - enum:
+              - cdns,at91sam9260-macb # Atmel at91sam9 SoCs
+              - cdns,sam9x60-macb     # Microchip sam9x60 SoC
+          - const: cdns,macb          # Generic
+
+      - items:
+          - enum:
+              - atmel,sama5d3-macb    # 10/100Mbit IP on Atmel sama5d3 SoCs
+          - enum:
+              - cdns,at91sam9260-macb # Atmel at91sam9 SoCs.
+          - const: cdns,macb          # Generic
+
+      - enum:
+          - atmel,sama5d29-gem        # GEM XL IP (10/100) on Atmel sama5d29 SoCs
+          - atmel,sama5d2-gem         # GEM IP (10/100) on Atmel sama5d2 SoCs
+          - atmel,sama5d3-gem         # Gigabit IP on Atmel sama5d3 SoCs
+          - atmel,sama5d4-gem         # GEM IP (10/100) on Atmel sama5d4 SoCs
+          - cdns,at32ap7000-macb      # Other 10/100 usage or use the generic form
+          - cdns,np4-macb             # NP4 SoC devices
+          - microchip,sama7g5-emac    # Microchip SAMA7G5 ethernet interface
+          - microchip,sama7g5-gem     # Microchip SAMA7G5 gigabit ethernet interface
+          - sifive,fu540-c000-gem     # SiFive FU540-C000 SoC
+          - cdns,emac                 # Generic
+          - cdns,gem                  # Generic
+          - cdns,macb                 # Generic
+
+  reg:
+    minItems: 1
+    items:
+      - description: Basic register set
+      - description: GEMGXL Management block registers on SiFive FU540-C000 SoC
+
+  interrupts:
+    minItems: 1
+    maxItems: 8
+    description: One interrupt per available hardware queue
+
+  clocks:
+    minItems: 1
+    maxItems: 5
+
+  clock-names:
+    minItems: 1
+    items:
+      - enum: [ ether_clk, hclk, pclk ]
+      - enum: [ hclk, pclk ]
+      - const: tx_clk
+      - enum: [ rx_clk, tsu_clk ]
+      - const: tsu_clk
+
+  local-mac-address: true
+
+  phy-mode: true
+
+  phy-handle: true
+
+  fixed-link: true
+
+  iommus:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+  '#stream-id-cells':
+    const: 1
+
+  mdio:
+    type: object
+    description:
+      Node containing PHY children. If this node is not present, then PHYs will
+      be direct children.
+
+patternProperties:
+  "^ethernet-phy@[0-9a-f]$":
+    type: object
+    $ref: ethernet-phy.yaml#
+
+    properties:
+      reset-gpios: true
+
+      magic-packet:
+        description:
+          Indicates that the hardware supports waking up via magic packet.
+
+    unevaluatedProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - phy-mode
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: sifive,fu540-c000-gem
+    then:
+      properties:
+        reg:
+          maxItems: 1
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    macb0: ethernet@fffc4000 {
+            compatible = "cdns,at32ap7000-macb";
+            reg = <0xfffc4000 0x4000>;
+            interrupts = <21>;
+            phy-mode = "rmii";
+            local-mac-address = [3a 0e 03 04 05 06];
+            clock-names = "pclk", "hclk", "tx_clk";
+            clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            ethernet-phy@1 {
+                    reg = <0x1>;
+                    reset-gpios = <&pioE 6 1>;
+            };
+    };
diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
deleted file mode 100644
index a1b06fd1962e4d93..0000000000000000
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ /dev/null
@@ -1,60 +0,0 @@
-* Cadence MACB/GEM Ethernet controller
-
-Required properties:
-- compatible: Should be "cdns,[<chip>-]{macb|gem}"
-  Use "cdns,at91rm9200-emac" Atmel at91rm9200 SoC.
-  Use "cdns,at91sam9260-macb" for Atmel at91sam9 SoCs.
-  Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
-  Use "cdns,np4-macb" for NP4 SoC devices.
-  Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
-  Use "atmel,sama5d2-gem" for the GEM IP (10/100) available on Atmel sama5d2 SoCs.
-  Use "atmel,sama5d29-gem" for GEM XL IP (10/100) available on Atmel sama5d29 SoCs.
-  Use "atmel,sama5d3-macb" for the 10/100Mbit IP available on Atmel sama5d3 SoCs.
-  Use "atmel,sama5d3-gem" for the Gigabit IP available on Atmel sama5d3 SoCs.
-  Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sama5d4 SoCs.
-  Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
-  Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
-  Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
-  Use "microchip,sama7g5-emac" for Microchip SAMA7G5 ethernet interface.
-  Use "microchip,sama7g5-gem" for Microchip SAMA7G5 gigabit ethernet interface.
-  Or the generic form: "cdns,emac".
-- reg: Address and length of the register set for the device
-	For "sifive,fu540-c000-gem", second range is required to specify the
-	address and length of the registers for GEMGXL Management block.
-- interrupts: Should contain macb interrupt
-- phy-mode: See ethernet.txt file in the same directory.
-- clock-names: Tuple listing input clock names.
-	Required elements: 'pclk', 'hclk'
-	Optional elements: 'tx_clk'
-	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
-	Optional elements: 'tsu_clk'
-- clocks: Phandles to input clocks.
-
-Optional properties:
-- mdio: node containing PHY children. If this node is not present, then PHYs
-        will be direct children.
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt.
-
-Optional properties for PHY child node:
-- reset-gpios : Should specify the gpio for phy reset
-- magic-packet : If present, indicates that the hardware supports waking
-  up via magic packet.
-- phy-handle : see ethernet.txt file in the same directory
-
-Examples:
-
-	macb0: ethernet@fffc4000 {
-		compatible = "cdns,at32ap7000-macb";
-		reg = <0xfffc4000 0x4000>;
-		interrupts = <21>;
-		phy-mode = "rmii";
-		local-mac-address = [3a 0e 03 04 05 06];
-		clock-names = "pclk", "hclk", "tx_clk";
-		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
-		ethernet-phy@1 {
-			reg = <0x1>;
-			reset-gpios = <&pioE 6 1>;
-		};
-	};
-- 
2.25.1

