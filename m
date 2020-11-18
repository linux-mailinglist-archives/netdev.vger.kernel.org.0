Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867D12B786D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKRIWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:22:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45156 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727160AbgKRIV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:21:58 -0500
X-UUID: 70b1653d36024ba481b71f32e96cc61b-20201118
X-UUID: 70b1653d36024ba481b71f32e96cc61b-20201118
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1619215649; Wed, 18 Nov 2020 16:21:46 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Nov 2020 16:21:46 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 16:21:45 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v3 04/11] dt-bindings: phy: convert phy-mtk-tphy.txt to YAML schema
Date:   Wed, 18 Nov 2020 16:21:19 +0800
Message-ID: <20201118082126.42701-4-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert phy-mtk-tphy.txt to YAML schema mediatek,tphy.yaml

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
v3:
  1. fix dt_binding_check error in example after add mtu3.yaml
  Changes suggested by Rob:
  2. fix wrong indentation
  3. remove '|' due to no formatting to preserve
  4. add a space after '#'
  5. drop unused labels and status in examples
  6. modify file mode

v2:
  1. modify description and compatible
---
 .../bindings/phy/mediatek,tphy.yaml           | 260 ++++++++++++++++++
 .../devicetree/bindings/phy/phy-mtk-tphy.txt  | 162 -----------
 2 files changed, 260 insertions(+), 162 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
 delete mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-tphy.txt

diff --git a/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml b/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
new file mode 100644
index 000000000000..602e6ff45785
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
@@ -0,0 +1,260 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2020 MediaTek
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/mediatek,tphy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek T-PHY Controller Device Tree Bindings
+
+maintainers:
+  - Chunfeng Yun <chunfeng.yun@mediatek.com>
+
+description: |
+  The T-PHY controller supports physical layer functionality for a number of
+  controllers on MediaTek SoCs, includes USB2.0, USB3.0, PCIe and SATA.
+
+  Layout differences of banks between T-PHY V1 (mt8173/mt2701) and
+  T-PHY V2 (mt2712) when works on USB mode:
+  -----------------------------------
+  Version 1:
+  port        offset    bank
+  shared      0x0000    SPLLC
+              0x0100    FMREG
+  u2 port0    0x0800    U2PHY_COM
+  u3 port0    0x0900    U3PHYD
+              0x0a00    U3PHYD_BANK2
+              0x0b00    U3PHYA
+              0x0c00    U3PHYA_DA
+  u2 port1    0x1000    U2PHY_COM
+  u3 port1    0x1100    U3PHYD
+              0x1200    U3PHYD_BANK2
+              0x1300    U3PHYA
+              0x1400    U3PHYA_DA
+  u2 port2    0x1800    U2PHY_COM
+              ...
+
+  Version 2:
+  port        offset    bank
+  u2 port0    0x0000    MISC
+              0x0100    FMREG
+              0x0300    U2PHY_COM
+  u3 port0    0x0700    SPLLC
+              0x0800    CHIP
+              0x0900    U3PHYD
+              0x0a00    U3PHYD_BANK2
+              0x0b00    U3PHYA
+              0x0c00    U3PHYA_DA
+  u2 port1    0x1000    MISC
+              0x1100    FMREG
+              0x1300    U2PHY_COM
+  u3 port1    0x1700    SPLLC
+              0x1800    CHIP
+              0x1900    U3PHYD
+              0x1a00    U3PHYD_BANK2
+              0x1b00    U3PHYA
+              0x1c00    U3PHYA_DA
+  u2 port2    0x2000    MISC
+              ...
+
+  SPLLC shared by u3 ports and FMREG shared by u2 ports on V1 are put back
+  into each port; a new bank MISC for u2 ports and CHIP for u3 ports are
+  added on V2.
+
+properties:
+  $nodename:
+    pattern: "^t-phy@[0-9a-f]+$"
+
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - mediatek,mt2701-tphy
+              - mediatek,mt7623-tphy
+              - mediatek,mt7622-tphy
+              - mediatek,mt8516-tphy
+          - const: mediatek,generic-tphy-v1
+      - items:
+          - enum:
+              - mediatek,mt2712-tphy
+              - mediatek,mt7629-tphy
+              - mediatek,mt8183-tphy
+          - const: mediatek,generic-tphy-v2
+      - const: mediatek,mt2701-u3phy
+        deprecated: true
+      - const: mediatek,mt2712-u3phy
+        deprecated: true
+      - const: mediatek,mt8173-u3phy
+
+  reg:
+    description:
+      Register shared by multiple ports, exclude port's private register.
+      It is needed for T-PHY V1, such as mt2701 and mt8173, but not for
+      T-PHY V2, such as mt2712.
+    maxItems: 1
+
+  "#address-cells":
+    enum: [1, 2]
+
+  "#size-cells":
+    enum: [1, 2]
+
+  # Used with non-empty value if optional 'reg' is not provided.
+  # The format of the value is an arbitrary number of triplets of
+  # (child-bus-address, parent-bus-address, length).
+  ranges: true
+
+  mediatek,src-ref-clk-mhz:
+    description:
+      Frequency of reference clock for slew rate calibrate
+    default: 26
+
+  mediatek,src-coef:
+    description:
+      Coefficient for slew rate calibrate, depends on SoC process
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 28
+
+# Required child node:
+patternProperties:
+  "^usb-phy@[0-9a-f]+$":
+    type: object
+    description:
+      A sub-node is required for each port the controller provides.
+      Address range information including the usual 'reg' property
+      is used inside these nodes to describe the controller's topology.
+
+    properties:
+      reg:
+        maxItems: 1
+
+      clocks:
+        minItems: 1
+        maxItems: 2
+        items:
+          - description: Reference clock, (HS is 48Mhz, SS/P is 24~27Mhz)
+          - description: Reference clock of analog phy
+        description:
+          Uses both clocks if the clock of analog and digital phys are
+          separated, otherwise uses "ref" clock only if needed.
+
+      clock-names:
+        minItems: 1
+        maxItems: 2
+        items:
+          - const: ref
+          - const: da_ref
+
+      "#phy-cells":
+        const: 1
+        description: |
+          The cells contain the following arguments.
+
+          - description: The PHY type
+              enum:
+                - PHY_TYPE_USB2
+                - PHY_TYPE_USB3
+                - PHY_TYPE_PCIE
+                - PHY_TYPE_SATA
+
+      # The following optional vendor properties are only for debug or HQA test
+      mediatek,eye-src:
+        description:
+          The value of slew rate calibrate (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,eye-vrt:
+        description:
+          The selection of VRT reference voltage (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,eye-term:
+        description:
+          The selection of HS_TX TERM reference voltage (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 7
+
+      mediatek,intr:
+        description:
+          The selection of internal resistor (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 31
+
+      mediatek,discth:
+        description:
+          The selection of disconnect threshold (U2 phy)
+        $ref: /schemas/types.yaml#/definitions/uint32
+        minimum: 1
+        maximum: 15
+
+      mediatek,bc12:
+        description:
+          Specify the flag to enable BC1.2 if support it
+        type: boolean
+
+    required:
+      - reg
+      - "#phy-cells"
+
+    additionalProperties: false
+
+required:
+  - compatible
+  - "#address-cells"
+  - "#size-cells"
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/mt8173-clk.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/phy/phy.h>
+    usb@11271000 {
+        compatible = "mediatek,mt8173-mtu3", "mediatek,mtu3";
+        reg = <0x11271000 0x3000>, <0x11280700 0x0100>;
+        reg-names = "mac", "ippc";
+        phys = <&u2port0 PHY_TYPE_USB2>,
+               <&u3port0 PHY_TYPE_USB3>,
+               <&u2port1 PHY_TYPE_USB2>;
+        interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_LOW>;
+        clocks = <&topckgen CLK_TOP_USB30_SEL>;
+        clock-names = "sys_ck";
+    };
+
+    t-phy@11290000 {
+        compatible = "mediatek,mt8173-u3phy";
+        reg = <0x11290000 0x800>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+        ranges;
+
+        u2port0: usb-phy@11290800 {
+            reg = <0x11290800 0x100>;
+            clocks = <&apmixedsys CLK_APMIXED_REF2USB_TX>, <&clk48m>;
+            clock-names = "ref", "da_ref";
+            #phy-cells = <1>;
+        };
+
+        u3port0: usb-phy@11290900 {
+            reg = <0x11290900 0x700>;
+            clocks = <&clk26m>;
+            clock-names = "ref";
+            #phy-cells = <1>;
+        };
+
+        u2port1: usb-phy@11291000 {
+            reg = <0x11291000 0x100>;
+            #phy-cells = <1>;
+        };
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-tphy.txt b/Documentation/devicetree/bindings/phy/phy-mtk-tphy.txt
deleted file mode 100644
index dd75b676b71d..000000000000
--- a/Documentation/devicetree/bindings/phy/phy-mtk-tphy.txt
+++ /dev/null
@@ -1,162 +0,0 @@
-MediaTek T-PHY binding
---------------------------
-
-T-phy controller supports physical layer functionality for a number of
-controllers on MediaTek SoCs, such as, USB2.0, USB3.0, PCIe, and SATA.
-
-Required properties (controller (parent) node):
- - compatible	: should be one of
-		  "mediatek,generic-tphy-v1"
-		  "mediatek,generic-tphy-v2"
-		  "mediatek,mt2701-u3phy" (deprecated)
-		  "mediatek,mt2712-u3phy" (deprecated)
-		  "mediatek,mt8173-u3phy";
-		  make use of "mediatek,generic-tphy-v1" on mt2701 instead and
-		  "mediatek,generic-tphy-v2" on mt2712 instead.
-
-- #address-cells:	the number of cells used to represent physical
-		base addresses.
-- #size-cells:	the number of cells used to represent the size of an address.
-- ranges:	the address mapping relationship to the parent, defined with
-		- empty value: if optional 'reg' is used.
-		- non-empty value: if optional 'reg' is not used. should set
-			the child's base address to 0, the physical address
-			within parent's address space, and the length of
-			the address map.
-
-Required nodes	: a sub-node is required for each port the controller
-		  provides. Address range information including the usual
-		  'reg' property is used inside these nodes to describe
-		  the controller's topology.
-
-Optional properties (controller (parent) node):
- - reg		: offset and length of register shared by multiple ports,
-		  exclude port's private register. It is needed on mt2701
-		  and mt8173, but not on mt2712.
- - mediatek,src-ref-clk-mhz	: frequency of reference clock for slew rate
-		  calibrate
- - mediatek,src-coef	: coefficient for slew rate calibrate, depends on
-		  SoC process
-
-Required properties (port (child) node):
-- reg		: address and length of the register set for the port.
-- #phy-cells	: should be 1 (See second example)
-		  cell after port phandle is phy type from:
-			- PHY_TYPE_USB2
-			- PHY_TYPE_USB3
-			- PHY_TYPE_PCIE
-			- PHY_TYPE_SATA
-
-Optional properties (PHY_TYPE_USB2 port (child) node):
-- clocks	: a list of phandle + clock-specifier pairs, one for each
-		  entry in clock-names
-- clock-names	: may contain
-		  "ref": 48M reference clock for HighSpeed (digital) phy; and 26M
-			reference clock for SuperSpeed (digital) phy, sometimes is
-			24M, 25M or 27M, depended on platform.
-		  "da_ref": the reference clock of analog phy, used if the clocks
-			of analog and digital phys are separated, otherwise uses
-			"ref" clock only if needed.
-
-- mediatek,eye-src	: u32, the value of slew rate calibrate
-- mediatek,eye-vrt	: u32, the selection of VRT reference voltage
-- mediatek,eye-term	: u32, the selection of HS_TX TERM reference voltage
-- mediatek,bc12	: bool, enable BC12 of u2phy if support it
-- mediatek,discth	: u32, the selection of disconnect threshold
-- mediatek,intr	: u32, the selection of internal R (resistance)
-
-Example:
-
-u3phy: usb-phy@11290000 {
-	compatible = "mediatek,mt8173-u3phy";
-	reg = <0 0x11290000 0 0x800>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-	ranges;
-
-	u2port0: usb-phy@11290800 {
-		reg = <0 0x11290800 0 0x100>;
-		clocks = <&apmixedsys CLK_APMIXED_REF2USB_TX>;
-		clock-names = "ref";
-		#phy-cells = <1>;
-	};
-
-	u3port0: usb-phy@11290900 {
-		reg = <0 0x11290800 0 0x700>;
-		clocks = <&clk26m>;
-		clock-names = "ref";
-		#phy-cells = <1>;
-	};
-
-	u2port1: usb-phy@11291000 {
-		reg = <0 0x11291000 0 0x100>;
-		clocks = <&apmixedsys CLK_APMIXED_REF2USB_TX>;
-		clock-names = "ref";
-		#phy-cells = <1>;
-	};
-};
-
-Specifying phy control of devices
----------------------------------
-
-Device nodes should specify the configuration required in their "phys"
-property, containing a phandle to the phy port node and a device type;
-phy-names for each port are optional.
-
-Example:
-
-#include <dt-bindings/phy/phy.h>
-
-usb30: usb@11270000 {
-	...
-	phys = <&u2port0 PHY_TYPE_USB2>, <&u3port0 PHY_TYPE_USB3>;
-	phy-names = "usb2-0", "usb3-0";
-	...
-};
-
-
-Layout differences of banks between mt8173/mt2701 and mt2712
--------------------------------------------------------------
-mt8173 and mt2701:
-port        offset    bank
-shared      0x0000    SPLLC
-            0x0100    FMREG
-u2 port0    0x0800    U2PHY_COM
-u3 port0    0x0900    U3PHYD
-            0x0a00    U3PHYD_BANK2
-            0x0b00    U3PHYA
-            0x0c00    U3PHYA_DA
-u2 port1    0x1000    U2PHY_COM
-u3 port1    0x1100    U3PHYD
-            0x1200    U3PHYD_BANK2
-            0x1300    U3PHYA
-            0x1400    U3PHYA_DA
-u2 port2    0x1800    U2PHY_COM
-            ...
-
-mt2712:
-port        offset    bank
-u2 port0    0x0000    MISC
-            0x0100    FMREG
-            0x0300    U2PHY_COM
-u3 port0    0x0700    SPLLC
-            0x0800    CHIP
-            0x0900    U3PHYD
-            0x0a00    U3PHYD_BANK2
-            0x0b00    U3PHYA
-            0x0c00    U3PHYA_DA
-u2 port1    0x1000    MISC
-            0x1100    FMREG
-            0x1300    U2PHY_COM
-u3 port1    0x1700    SPLLC
-            0x1800    CHIP
-            0x1900    U3PHYD
-            0x1a00    U3PHYD_BANK2
-            0x1b00    U3PHYA
-            0x1c00    U3PHYA_DA
-u2 port2    0x2000    MISC
-            ...
-
-    SPLLC shared by u3 ports and FMREG shared by u2 ports on
-mt8173/mt2701 are put back into each port; a new bank MISC for
-u2 ports and CHIP for u3 ports are added on mt2712.
-- 
2.18.0

