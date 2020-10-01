Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88827FCE8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgJAKKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731931AbgJAKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:10:22 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30883C0613E9
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:10:21 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id aaAA230014C55Sk06aAAAL; Thu, 01 Oct 2020 12:10:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0001Ma-W8; Thu, 01 Oct 2020 12:10:10 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0003ke-Vp; Thu, 01 Oct 2020 12:10:09 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next v4 resend 3/5] dt-bindings: net: renesas,etheravb: Convert to json-schema
Date:   Thu,  1 Oct 2020 12:10:06 +0200
Message-Id: <20201001101008.14365-4-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001101008.14365-1-geert+renesas@glider.be>
References: <20201001101008.14365-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Renesas Ethernet AVB (EthernetAVB-IF) Device Tree binding
documentation to json-schema.

Add missing properties.
Update the example to match reality.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v4:
  - Add Reviewed-by,

v3:
  - Add Reviewed-by,

v2:
  - Add Reviewed-by,
  - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps", for
    which the base definition is imported from ethernet-controller.yaml.
---
 .../bindings/net/renesas,etheravb.yaml        | 261 ++++++++++++++++++
 .../devicetree/bindings/net/renesas,ravb.txt  | 137 ---------
 2 files changed, 261 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etheravb.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/renesas,ravb.txt

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
new file mode 100644
index 0000000000000000..e13653051b23d5f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -0,0 +1,261 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/renesas,etheravb.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas Ethernet AVB
+
+maintainers:
+  - Sergei Shtylyov <sergei.shtylyov@gmail.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - renesas,etheravb-r8a7742      # RZ/G1H
+              - renesas,etheravb-r8a7743      # RZ/G1M
+              - renesas,etheravb-r8a7744      # RZ/G1N
+              - renesas,etheravb-r8a7745      # RZ/G1E
+              - renesas,etheravb-r8a77470     # RZ/G1C
+              - renesas,etheravb-r8a7790      # R-Car H2
+              - renesas,etheravb-r8a7791      # R-Car M2-W
+              - renesas,etheravb-r8a7792      # R-Car V2H
+              - renesas,etheravb-r8a7793      # R-Car M2-N
+              - renesas,etheravb-r8a7794      # R-Car E2
+          - const: renesas,etheravb-rcar-gen2 # R-Car Gen2 and RZ/G1
+
+      - items:
+          - enum:
+              - renesas,etheravb-r8a774a1     # RZ/G2M
+              - renesas,etheravb-r8a774b1     # RZ/G2N
+              - renesas,etheravb-r8a774c0     # RZ/G2E
+              - renesas,etheravb-r8a7795      # R-Car H3
+              - renesas,etheravb-r8a7796      # R-Car M3-W
+              - renesas,etheravb-r8a77961     # R-Car M3-W+
+              - renesas,etheravb-r8a77965     # R-Car M3-N
+              - renesas,etheravb-r8a77970     # R-Car V3M
+              - renesas,etheravb-r8a77980     # R-Car V3H
+              - renesas,etheravb-r8a77990     # R-Car E3
+              - renesas,etheravb-r8a77995     # R-Car D3
+          - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
+
+  reg: true
+
+  interrupts: true
+
+  interrupt-names: true
+
+  clocks:
+    maxItems: 1
+
+  iommus:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  phy-mode: true
+
+  phy-handle: true
+
+  '#address-cells':
+    description: Number of address cells for the MDIO bus.
+    const: 1
+
+  '#size-cells':
+    description: Number of size cells on the MDIO bus.
+    const: 0
+
+  renesas,no-ether-link:
+    type: boolean
+    description:
+      Specify when a board does not provide a proper AVB_LINK signal.
+
+  renesas,ether-link-active-low:
+    type: boolean
+    description:
+      Specify when the AVB_LINK signal is active-low instead of normal
+      active-high.
+
+  rx-internal-delay-ps:
+    enum: [0, 1800]
+
+  tx-internal-delay-ps:
+    enum: [0, 2000]
+
+patternProperties:
+  "^ethernet-phy@[0-9a-f]$":
+    type: object
+    $ref: ethernet-phy.yaml#
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - power-domains
+  - resets
+  - phy-mode
+  - phy-handle
+  - '#address-cells'
+  - '#size-cells'
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - renesas,etheravb-rcar-gen2
+              - renesas,etheravb-r8a7795
+              - renesas,etheravb-r8a7796
+              - renesas,etheravb-r8a77961
+              - renesas,etheravb-r8a77965
+    then:
+      properties:
+        reg:
+          items:
+            - description: MAC register block
+            - description: Stream buffer
+    else:
+      properties:
+        reg:
+          items:
+            - description: MAC register block
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,etheravb-rcar-gen2
+    then:
+      properties:
+        interrupts:
+          maxItems: 1
+        interrupt-names:
+          items:
+            - const: mux
+        rx-internal-delay-ps: false
+    else:
+      properties:
+        interrupts:
+          minItems: 25
+          maxItems: 25
+        interrupt-names:
+          items:
+            pattern: '^ch[0-9]+$'
+      required:
+        - interrupt-names
+        - rx-internal-delay-ps
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - renesas,etheravb-r8a774a1
+              - renesas,etheravb-r8a774b1
+              - renesas,etheravb-r8a7795
+              - renesas,etheravb-r8a7796
+              - renesas,etheravb-r8a77961
+              - renesas,etheravb-r8a77965
+              - renesas,etheravb-r8a77970
+              - renesas,etheravb-r8a77980
+    then:
+      required:
+        - tx-internal-delay-ps
+    else:
+      properties:
+        tx-internal-delay-ps: false
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,etheravb-r8a77995
+    then:
+      properties:
+        rx-internal-delay-ps:
+          const: 1800
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: renesas,etheravb-r8a77980
+    then:
+      properties:
+        tx-internal-delay-ps:
+          const: 2000
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r8a7795-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a7795-sysc.h>
+    #include <dt-bindings/gpio/gpio.h>
+    aliases {
+            ethernet0 = &avb;
+    };
+
+    avb: ethernet@e6800000 {
+            compatible = "renesas,etheravb-r8a7795",
+                         "renesas,etheravb-rcar-gen3";
+            reg = <0xe6800000 0x800>, <0xe6a00000 0x10000>;
+            interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "ch0", "ch1", "ch2", "ch3", "ch4", "ch5", "ch6",
+                              "ch7", "ch8", "ch9", "ch10", "ch11", "ch12",
+                              "ch13", "ch14", "ch15", "ch16", "ch17", "ch18",
+                              "ch19", "ch20", "ch21", "ch22", "ch23", "ch24";
+            clocks = <&cpg CPG_MOD 812>;
+            iommus = <&ipmmu_ds0 16>;
+            power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+            resets = <&cpg 812>;
+            phy-mode = "rgmii";
+            phy-handle = <&phy0>;
+            rx-internal-delay-ps = <0>;
+            tx-internal-delay-ps = <2000>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            phy0: ethernet-phy@0 {
+                    rxc-skew-ps = <1500>;
+                    reg = <0>;
+                    interrupt-parent = <&gpio2>;
+                    interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+                    reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
+            };
+    };
diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Documentation/devicetree/bindings/net/renesas,ravb.txt
deleted file mode 100644
index 4a62dd11d5c488f4..0000000000000000
--- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
+++ /dev/null
@@ -1,137 +0,0 @@
-* Renesas Electronics Ethernet AVB
-
-This file provides information on what the device node for the Ethernet AVB
-interface contains.
-
-Required properties:
-- compatible: Must contain one or more of the following:
-      - "renesas,etheravb-r8a7742" for the R8A7742 SoC.
-      - "renesas,etheravb-r8a7743" for the R8A7743 SoC.
-      - "renesas,etheravb-r8a7744" for the R8A7744 SoC.
-      - "renesas,etheravb-r8a7745" for the R8A7745 SoC.
-      - "renesas,etheravb-r8a77470" for the R8A77470 SoC.
-      - "renesas,etheravb-r8a7790" for the R8A7790 SoC.
-      - "renesas,etheravb-r8a7791" for the R8A7791 SoC.
-      - "renesas,etheravb-r8a7792" for the R8A7792 SoC.
-      - "renesas,etheravb-r8a7793" for the R8A7793 SoC.
-      - "renesas,etheravb-r8a7794" for the R8A7794 SoC.
-      - "renesas,etheravb-rcar-gen2" as a fallback for the above
-		R-Car Gen2 and RZ/G1 devices.
-
-      - "renesas,etheravb-r8a774a1" for the R8A774A1 SoC.
-      - "renesas,etheravb-r8a774b1" for the R8A774B1 SoC.
-      - "renesas,etheravb-r8a774c0" for the R8A774C0 SoC.
-      - "renesas,etheravb-r8a7795" for the R8A7795 SoC.
-      - "renesas,etheravb-r8a7796" for the R8A77960 SoC.
-      - "renesas,etheravb-r8a77961" for the R8A77961 SoC.
-      - "renesas,etheravb-r8a77965" for the R8A77965 SoC.
-      - "renesas,etheravb-r8a77970" for the R8A77970 SoC.
-      - "renesas,etheravb-r8a77980" for the R8A77980 SoC.
-      - "renesas,etheravb-r8a77990" for the R8A77990 SoC.
-      - "renesas,etheravb-r8a77995" for the R8A77995 SoC.
-      - "renesas,etheravb-rcar-gen3" as a fallback for the above
-		R-Car Gen3 and RZ/G2 devices.
-
-	When compatible with the generic version, nodes must list the
-	SoC-specific version corresponding to the platform first followed by
-	the generic version.
-
-- reg: Offset and length of (1) the register block and (2) the stream buffer.
-       The region for the register block is mandatory.
-       The region for the stream buffer is optional, as it is only present on
-       R-Car Gen2 and RZ/G1 SoCs, and on R-Car H3 (R8A7795), M3-W (R8A77960),
-       M3-W+ (R8A77961), and M3-N (R8A77965).
-- interrupts: A list of interrupt-specifiers, one for each entry in
-	      interrupt-names.
-	      If interrupt-names is not present, an interrupt specifier
-	      for a single muxed interrupt.
-- phy-mode: see ethernet.txt file in the same directory.
-- phy-handle: see ethernet.txt file in the same directory.
-- #address-cells: number of address cells for the MDIO bus, must be equal to 1.
-- #size-cells: number of size cells on the MDIO bus, must be equal to 0.
-- clocks: clock phandle and specifier pair.
-- pinctrl-0: phandle, referring to a default pin configuration node.
-
-Optional properties:
-- interrupt-names: A list of interrupt names.
-		   For the R-Car Gen 3 SoCs this property is mandatory;
-		   it should include one entry per channel, named "ch%u",
-		   where %u is the channel number ranging from 0 to 24.
-		   For other SoCs this property is optional; if present
-		   it should contain "mux" for a single muxed interrupt.
-- pinctrl-names: pin configuration state name ("default").
-- renesas,no-ether-link: boolean, specify when a board does not provide a proper
-			 AVB_LINK signal.
-- renesas,ether-link-active-low: boolean, specify when the AVB_LINK signal is
-				 active-low instead of normal active-high.
-- rx-internal-delay-ps: Internal RX clock delay.
-			This property is mandatory and valid only on R-Car Gen3
-			and RZ/G2 SoCs.
-			Valid values are 0 and 1800.
-			A non-zero value is allowed only if phy-mode = "rgmii".
-			Zero is not supported on R-Car D3.
-- tx-internal-delay-ps: Internal TX clock delay.
-			This property is mandatory and valid only on R-Car H3,
-			M3-W, M3-W+, M3-N, V3M, and V3H, and RZ/G2M and RZ/G2N.
-			Valid values are 0 and 2000.
-			A non-zero value is allowed only if phy-mode = "rgmii".
-			Zero is not supported on R-Car V3H.
-
-Example:
-
-	ethernet@e6800000 {
-		compatible = "renesas,etheravb-r8a7795", "renesas,etheravb-rcar-gen3";
-		reg = <0 0xe6800000 0 0x800>, <0 0xe6a00000 0 0x10000>;
-		interrupt-parent = <&gic>;
-		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "ch0", "ch1", "ch2", "ch3",
-				  "ch4", "ch5", "ch6", "ch7",
-				  "ch8", "ch9", "ch10", "ch11",
-				  "ch12", "ch13", "ch14", "ch15",
-				  "ch16", "ch17", "ch18", "ch19",
-				  "ch20", "ch21", "ch22", "ch23",
-				  "ch24";
-		clocks = <&cpg CPG_MOD 812>;
-		power-domains = <&cpg>;
-		phy-mode = "rgmii";
-		phy-handle = <&phy0>;
-		rx-internal-delay-ps = <0>;
-		tx-internal-delay-ps = <2000>;
-
-		pinctrl-0 = <&ether_pins>;
-		pinctrl-names = "default";
-		renesas,no-ether-link;
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		phy0: ethernet-phy@0 {
-			rxc-skew-ps = <1500>;
-			reg = <0>;
-			interrupt-parent = <&gpio2>;
-			interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
-		};
-	};
-- 
2.17.1

