Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06361BB695
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgD1Gb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:31:29 -0400
Received: from mx.socionext.com ([202.248.49.38]:22277 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgD1Gb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 02:31:27 -0400
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 28 Apr 2020 15:31:25 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id C9C4060057;
        Tue, 28 Apr 2020 15:31:25 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Tue, 28 Apr 2020 15:31:25 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan.css.socionext.com (Postfix) with ESMTP id 8D37D1A01BB;
        Tue, 28 Apr 2020 15:31:25 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] dt-bindings: net: Convert UniPhier AVE4 controller to json-schema
Date:   Tue, 28 Apr 2020 15:31:22 +0900
Message-Id: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the UniPhier AVE4 controller binding to DT schema format.
This changes phy-handle property to required.

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 .../bindings/net/socionext,uniphier-ave4.txt       |  64 ------------
 .../bindings/net/socionext,uniphier-ave4.yaml      | 109 +++++++++++++++++++++
 MAINTAINERS                                        |   2 +-
 3 files changed, 110 insertions(+), 65 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
 create mode 100644 Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml

diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
deleted file mode 100644
index 4e85fc4..0000000
--- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
+++ /dev/null
@@ -1,64 +0,0 @@
-* Socionext AVE ethernet controller
-
-This describes the devicetree bindings for AVE ethernet controller
-implemented on Socionext UniPhier SoCs.
-
-Required properties:
- - compatible: Should be
-	- "socionext,uniphier-pro4-ave4" : for Pro4 SoC
-	- "socionext,uniphier-pxs2-ave4" : for PXs2 SoC
-	- "socionext,uniphier-ld11-ave4" : for LD11 SoC
-	- "socionext,uniphier-ld20-ave4" : for LD20 SoC
-	- "socionext,uniphier-pxs3-ave4" : for PXs3 SoC
- - reg: Address where registers are mapped and size of region.
- - interrupts: Should contain the MAC interrupt.
- - phy-mode: See ethernet.txt in the same directory. Allow to choose
-	"rgmii", "rmii", "mii", or "internal" according to the PHY.
-	The acceptable mode is SoC-dependent.
- - phy-handle: Should point to the external phy device.
-	See ethernet.txt file in the same directory.
- - clocks: A phandle to the clock for the MAC.
-	For Pro4 SoC, that is "socionext,uniphier-pro4-ave4",
-	another MAC clock, GIO bus clock and PHY clock are also required.
- - clock-names: Should contain
-	- "ether", "ether-gb", "gio", "ether-phy" for Pro4 SoC
-	- "ether" for others
- - resets: A phandle to the reset control for the MAC. For Pro4 SoC,
-	GIO bus reset is also required.
- - reset-names: Should contain
-	- "ether", "gio" for Pro4 SoC
-	- "ether" for others
- - socionext,syscon-phy-mode: A phandle to syscon with one argument
-	that configures phy mode. The argument is the ID of MAC instance.
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt.
-
-Required subnode:
- - mdio: A container for child nodes representing phy nodes.
-         See phy.txt in the same directory.
-
-Example:
-
-	ether: ethernet@65000000 {
-		compatible = "socionext,uniphier-ld20-ave4";
-		reg = <0x65000000 0x8500>;
-		interrupts = <0 66 4>;
-		phy-mode = "rgmii";
-		phy-handle = <&ethphy>;
-		clock-names = "ether";
-		clocks = <&sys_clk 6>;
-		reset-names = "ether";
-		resets = <&sys_rst 6>;
-		socionext,syscon-phy-mode = <&soc_glue 0>;
-		local-mac-address = [00 00 00 00 00 00];
-
-		mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			ethphy: ethphy@1 {
-				reg = <1>;
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
new file mode 100644
index 0000000..fd31e87
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
@@ -0,0 +1,109 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/socionext,uniphier-ave4.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Socionext AVE ethernet controller
+
+maintainers:
+  - Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
+
+description: |
+  This describes the devicetree bindings for AVE ethernet controller
+  implemented on Socionext UniPhier SoCs.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - socionext,uniphier-pro4-ave4
+      - socionext,uniphier-pxs2-ave4
+      - socionext,uniphier-ld11-ave4
+      - socionext,uniphier-ld20-ave4
+      - socionext,uniphier-pxs3-ave4
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  phy-mode:
+    $ref: ethernet-controller.yaml#/properties/phy-mode
+
+  phy-handle:
+    $ref: ethernet-controller.yaml#/properties/phy-handle
+
+  clocks:
+    minItems: 1
+    maxItems: 4
+
+  clock-names:
+    oneOf:
+      - items:          # for Pro4
+        - const: gio
+        - const: ether
+        - const: ether-gb
+        - const: ether-phy
+      - const: ether    # for others
+
+  resets:
+    minItems: 1
+    maxItems: 2
+
+  reset-names:
+    oneOf:
+      - items:          # for Pro4
+        - const: gio
+        - const: ether
+      - const: ether    # for others
+
+  socionext,syscon-phy-mode:
+    $ref: /schemas/types.yaml#definitions/phandle-array
+    description:
+      A phandle to syscon with one argument that configures phy mode.
+      The argument is the ID of MAC instance.
+
+  mdio:
+    $ref: mdio.yaml#
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phy-mode
+  - phy-handle
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - mdio
+
+additionalProperties: false
+
+examples:
+  - |
+    ether: ethernet@65000000 {
+        compatible = "socionext,uniphier-ld20-ave4";
+                reg = <0x65000000 0x8500>;
+                interrupts = <0 66 4>;
+                phy-mode = "rgmii";
+                phy-handle = <&ethphy>;
+                clock-names = "ether";
+                clocks = <&sys_clk 6>;
+                reset-names = "ether";
+                resets = <&sys_rst 6>;
+                socionext,syscon-phy-mode = <&soc_glue 0>;
+
+                mdio {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        ethphy: ethernet-phy@1 {
+                                reg = <1>;
+                        };
+                };
+        };
diff --git a/MAINTAINERS b/MAINTAINERS
index a1558eb..0ee65e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15590,7 +15590,7 @@ SOCIONEXT (SNI) AVE NETWORK DRIVER
 M:	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/socionext,uniphier-ave4.txt
+F:	Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
 F:	drivers/net/ethernet/socionext/sni_ave.c
 
 SOCIONEXT (SNI) NETSEC NETWORK DRIVER
-- 
2.7.4

