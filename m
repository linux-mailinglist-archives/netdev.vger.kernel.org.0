Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1836AABB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhDZCmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:42:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37606 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhDZCmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:42:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8B7671F41F95
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH 3/3] dt-bindings: net: convert rockchip-dwmac to json-schema
Date:   Sun, 25 Apr 2021 23:41:18 -0300
Message-Id: <20210426024118.18717-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210426024118.18717-1-ezequiel@collabora.com>
References: <20210426024118.18717-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Rockchip dwmac controller dt-bindings to YAML.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../bindings/net/rockchip-dwmac.txt           |  76 -----------
 .../bindings/net/rockchip-dwmac.yaml          | 120 ++++++++++++++++++
 2 files changed, 120 insertions(+), 76 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
deleted file mode 100644
index 3b71da7e8742..000000000000
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
+++ /dev/null
@@ -1,76 +0,0 @@
-Rockchip SoC RK3288 10/100/1000 Ethernet driver(GMAC)
-
-The device node has following properties.
-
-Required properties:
- - compatible: should be "rockchip,<name>-gamc"
-   "rockchip,px30-gmac":   found on PX30 SoCs
-   "rockchip,rk3128-gmac": found on RK312x SoCs
-   "rockchip,rk3228-gmac": found on RK322x SoCs
-   "rockchip,rk3288-gmac": found on RK3288 SoCs
-   "rockchip,rk3328-gmac": found on RK3328 SoCs
-   "rockchip,rk3366-gmac": found on RK3366 SoCs
-   "rockchip,rk3368-gmac": found on RK3368 SoCs
-   "rockchip,rk3399-gmac": found on RK3399 SoCs
-   "rockchip,rv1108-gmac": found on RV1108 SoCs
- - reg: addresses and length of the register sets for the device.
- - interrupts: Should contain the GMAC interrupts.
- - interrupt-names: Should contain the interrupt names "macirq".
- - rockchip,grf: phandle to the syscon grf used to control speed and mode.
- - clocks: <&cru SCLK_MAC>: clock selector for main clock, from PLL or PHY.
-	   <&cru SCLK_MAC_PLL>: PLL clock for SCLK_MAC
-	   <&cru SCLK_MAC_RX>: clock gate for RX
-	   <&cru SCLK_MAC_TX>: clock gate for TX
-	   <&cru SCLK_MACREF>: clock gate for RMII referce clock
-	   <&cru SCLK_MACREF_OUT> clock gate for RMII reference clock output
-	   <&cru ACLK_GMAC>: AXI clock gate for GMAC
-	   <&cru PCLK_GMAC>: APB clock gate for GMAC
- - clock-names: One name for each entry in the clocks property.
- - phy-mode: See ethernet.txt file in the same directory.
- - pinctrl-names: Names corresponding to the numbered pinctrl states.
- - pinctrl-0: pin-control mode. can be <&rgmii_pins> or <&rmii_pins>.
- - clock_in_out: For RGMII, it must be "input", means main clock(125MHz)
-   is not sourced from SoC's PLL, but input from PHY; For RMII, "input" means
-   PHY provides the reference clock(50MHz), "output" means GMAC provides the
-   reference clock.
- - snps,reset-gpio       gpio number for phy reset.
- - snps,reset-active-low boolean flag to indicate if phy reset is active low.
- - assigned-clocks: main clock, should be <&cru SCLK_MAC>;
- - assigned-clock-parents = parent of main clock.
-   can be <&ext_gmac> or <&cru SCLK_MAC_PLL>.
-
-Optional properties:
- - tx_delay: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
- - rx_delay: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.
- - phy-supply: phandle to a regulator if the PHY needs one
-
-Example:
-
-gmac: ethernet@ff290000 {
-	compatible = "rockchip,rk3288-gmac";
-	reg = <0xff290000 0x10000>;
-	interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq";
-	rockchip,grf = <&grf>;
-	clocks = <&cru SCLK_MAC>,
-		<&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
-		<&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
-		<&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
-	clock-names = "stmmaceth",
-		"mac_clk_rx", "mac_clk_tx",
-		"clk_mac_ref", "clk_mac_refout",
-		"aclk_mac", "pclk_mac";
-	phy-mode = "rgmii";
-	pinctrl-names = "default";
-	pinctrl-0 = <&rgmii_pins /*&rmii_pins*/>;
-
-	clock_in_out = "input";
-	snps,reset-gpio = <&gpio4 7 0>;
-	snps,reset-active-low;
-
-	assigned-clocks = <&cru SCLK_MAC>;
-	assigned-clock-parents = <&ext_gmac>;
-	tx_delay = <0x30>;
-	rx_delay = <0x10>;
-
-};
diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
new file mode 100644
index 000000000000..5acddb6171bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -0,0 +1,120 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/rockchip-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Rockchip 10/100/1000 Ethernet driver(GMAC)
+
+maintainers:
+  - David Wu <david.wu@rock-chips.com>
+
+# We need a select here so we don't match all nodes with 'snps,dwmac'
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - rockchip,px30-gmac
+          - rockchip,rk3128-gmac
+          - rockchip,rk3228-gmac
+          - rockchip,rk3288-gmac
+          - rockchip,rk3328-gmac
+          - rockchip,rk3366-gmac
+          - rockchip,rk3368-gmac
+          - rockchip,rk3399-gmac
+          - rockchip,rv1108-gmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - rockchip,px30-gmac
+          - rockchip,rk3128-gmac
+          - rockchip,rk3228-gmac
+          - rockchip,rk3288-gmac
+          - rockchip,rk3328-gmac
+          - rockchip,rk3366-gmac
+          - rockchip,rk3368-gmac
+          - rockchip,rk3399-gmac
+          - rockchip,rv1108-gmac
+
+  clocks:
+    minItems: 5
+    maxItems: 8
+
+  clock-names:
+    contains:
+      enum:
+        - stmmaceth
+        - mac_clk_tx
+        - mac_clk_rx
+        - aclk_mac
+        - pclk_mac
+        - clk_mac_ref
+        - clk_mac_refout
+        - clk_mac_speed
+
+  clock_in_out:
+    description:
+      For RGMII, it must be "input", means main clock(125MHz)
+      is not sourced from SoC's PLL, but input from PHY.
+      For RMII, "input" means PHY provides the reference clock(50MHz),
+      "output" means GMAC provides the reference clock.
+    $ref: /schemas/types.yaml#/definitions/string
+    enum: [input, output]
+
+  rockchip,grf:
+    description: The phandle of the syscon node for the general register file.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+  tx_delay:
+    description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  rx_delay:
+    description: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  phy-supply:
+    description: PHY regulator
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/rk3288-cru.h>
+
+    gmac: ethernet@ff290000 {
+        compatible = "rockchip,rk3288-gmac";
+        reg = <0xff290000 0x10000>;
+        interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "macirq";
+        clocks = <&cru SCLK_MAC>,
+                 <&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
+                 <&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
+                 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
+        clock-names = "stmmaceth",
+                      "mac_clk_rx", "mac_clk_tx",
+                      "clk_mac_ref", "clk_mac_refout",
+                      "aclk_mac", "pclk_mac";
+        assigned-clocks = <&cru SCLK_MAC>;
+        assigned-clock-parents = <&ext_gmac>;
+
+        rockchip,grf = <&grf>;
+        phy-mode = "rgmii";
+        clock_in_out = "input";
+        tx_delay = <0x30>;
+        rx_delay = <0x10>;
+    };
-- 
2.30.0

