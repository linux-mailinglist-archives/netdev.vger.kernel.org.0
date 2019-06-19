Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8C4B54C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfFSJsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:48:15 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:47495 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfFSJsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:48:14 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D8E18200005;
        Wed, 19 Jun 2019 09:48:10 +0000 (UTC)
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
Subject: [PATCH v3 08/16] dt-bindings: net: stmmac: Convert the binding to a schemas
Date:   Wed, 19 Jun 2019 11:47:17 +0200
Message-Id: <60569c4326437aeb1c13b3da4d00bcf6202e9e6b.1560937626.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
schema to enable the DT validation.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

---

Changes from v2:
  - Switch to phy-connection-type instead of phy-mode
  - Fix the snps,*pbl properties type

Changes from v1:
  - Restrict snps,tso to only a couple of compatibles
  - Use an enum for the compatibles
  - Add a custom select statement with the compatibles of all the generic
    compatibles, including the deprecated ones. Remove the deprecated ones
    from the valid compatible values to issue a warning when used.
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 389 +++++++++++-
 Documentation/devicetree/bindings/net/stmmac.txt      | 179 +-----
 2 files changed, 390 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
new file mode 100644
index 000000000000..30e2ff7a2dcb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -0,0 +1,389 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/snps,dwmac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare MAC Device Tree Bindings
+
+maintainers:
+  - Alexandre Torgue <alexandre.torgue@st.com>
+  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
+  - Jose Abreu <joabreu@synopsys.com>
+
+# Select every compatible, including the deprecated ones. This way, we
+# will be able to report a warning when we have that compatible, since
+# we will validate the node thanks to the select, but won't report it
+# as a valid value in the compatible property description
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - snps,dwmac
+          - snps,dwmac-3.50a
+          - snps,dwmac-3.610
+          - snps,dwmac-3.70a
+          - snps,dwmac-3.710
+          - snps,dwmac-4.00
+          - snps,dwmac-4.10a
+          - snps,dwxgmac
+          - snps,dwxgmac-2.10
+
+          # Deprecated
+          - st,spear600-gmac
+
+  required:
+    - compatible
+
+properties:
+
+  # We need to include all the compatibles from schemas that will
+  # include that schemas, otherwise compatible won't validate for
+  # those.
+  compatible:
+    contains:
+      enum:
+        - snps,dwmac
+        - snps,dwmac-3.50a
+        - snps,dwmac-3.610
+        - snps,dwmac-3.70a
+        - snps,dwmac-3.710
+        - snps,dwmac-4.00
+        - snps,dwmac-4.10a
+        - snps,dwxgmac
+        - snps,dwxgmac-2.10
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 3
+    items:
+      - description: Combined signal for various interrupt events
+      - description: The interrupt to manage the remote wake-up packet detection
+      - description: The interrupt that occurs when Rx exits the LPI state
+
+  interrupt-names:
+    minItems: 1
+    maxItems: 3
+    items:
+      - const: macirq
+      - const: eth_wake_irq
+      - const: eth_lpi
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+    items:
+      - description: GMAC main clock
+      - description: Peripheral registers interface clock
+      - description:
+          PTP reference clock. This clock is used for programming the
+          Timestamp Addend Register. If not passed then the system
+          clock will be used and this is fine on some platforms.
+
+  clock-names:
+    additionalItems: true
+    contains:
+      enum:
+        - stmmaceth
+        - pclk
+        - ptp_ref
+
+  resets:
+    maxItems: 1
+    description:
+      MAC Reset signal.
+
+  reset-names:
+    const: stmmaceth
+
+  snps,axi-config:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      AXI BUS Mode parameters. Phandle to a node that can contain the
+      following properties
+        * snps,lpi_en, enable Low Power Interface
+        * snps,xit_frm, unlock on WoL
+        * snps,wr_osr_lmt, max write outstanding req. limit
+        * snps,rd_osr_lmt, max read outstanding req. limit
+        * snps,kbbe, do not cross 1KiB boundary.
+        * snps,blen, this is a vector of supported burst length.
+        * snps,fb, fixed-burst
+        * snps,mb, mixed-burst
+        * snps,rb, rebuild INCRx Burst
+
+  snps,mtl-rx-config:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Multiple RX Queues parameters. Phandle to a node that can
+      contain the following properties
+        * snps,rx-queues-to-use, number of RX queues to be used in the
+          driver
+        * Choose one of these RX scheduling algorithms
+          * snps,rx-sched-sp, Strict priority
+          * snps,rx-sched-wsp, Weighted Strict priority
+        * For each RX queue
+          * Choose one of these modes
+            * snps,dcb-algorithm, Queue to be enabled as DCB
+            * snps,avb-algorithm, Queue to be enabled as AVB
+          * snps,map-to-dma-channel, Channel to map
+          * Specifiy specific packet routing
+            * snps,route-avcp, AV Untagged Control packets
+            * snps,route-ptp, PTP Packets
+            * snps,route-dcbcp, DCB Control Packets
+            * snps,route-up, Untagged Packets
+            * snps,route-multi-broad, Multicast & Broadcast Packets
+          * snps,priority, RX queue priority (Range 0x0 to 0xF)
+
+  snps,mtl-tx-config:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Multiple TX Queues parameters. Phandle to a node that can
+      contain the following properties
+        * snps,tx-queues-to-use, number of TX queues to be used in the
+          driver
+        * Choose one of these TX scheduling algorithms
+          * snps,tx-sched-wrr, Weighted Round Robin
+          * snps,tx-sched-wfq, Weighted Fair Queuing
+          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
+          * snps,tx-sched-sp, Strict priority
+        * For each TX queue
+          * snps,weight, TX queue weight (if using a DCB weight
+            algorithm)
+          * Choose one of these modes
+            * snps,dcb-algorithm, TX queue will be working in DCB
+            * snps,avb-algorithm, TX queue will be working in AVB
+              [Attention] Queue 0 is reserved for legacy traffic
+                          and so no AVB is available in this queue.
+          * Configure Credit Base Shaper (if AVB Mode selected)
+            * snps,send_slope, enable Low Power Interface
+            * snps,idle_slope, unlock on WoL
+            * snps,high_credit, max write outstanding req. limit
+            * snps,low_credit, max read outstanding req. limit
+          * snps,priority, TX queue priority (Range 0x0 to 0xF)
+
+  snps,reset-gpio:
+    maxItems: 1
+    description:
+      PHY Reset GPIO
+
+  snps,reset-active-low:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Indicates that the PHY Reset is active low
+
+  snps,reset-delays-us:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint32-array
+      - minItems: 3
+        maxItems: 3
+    description:
+      Triplet of delays. The 1st cell is reset pre-delay in micro
+      seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
+      cell is reset post-delay in micro seconds.
+
+  snps,aal:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Use Address-Aligned Beats
+
+  snps,fixed-burst:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Program the DMA to use the fixed burst mode
+
+  snps,mixed-burst:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Program the DMA to use the mixed burst mode
+
+  snps,force_thresh_dma_mode:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Force DMA to use the threshold mode for both tx and rx
+
+  snps,force_sf_dma_mode:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Force DMA to use the Store and Forward mode for both tx and
+      rx. This flag is ignored if force_thresh_dma_mode is set.
+
+  snps,en-tx-lpi-clockgating:
+    $ref: /schemas/types.yaml#definitions/flag
+    description:
+      Enable gating of the MAC TX clock during TX low-power mode
+
+  snps,multicast-filter-bins:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Number of multicast filter hash bins supported by this device
+      instance
+
+  snps,perfect-filter-entries:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Number of perfect filter entries supported by this device
+      instance
+
+  snps,ps-speed:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description:
+      Port selection speed that can be passed to the core when PCS
+      is supported. For example, this is used in case of SGMII and
+      MAC2MAC connection.
+
+  mdio:
+    type: object
+    description:
+      Creates and registers an MDIO bus.
+
+    properties:
+      compatible:
+        const: snps,dwmac-mdio
+
+    required:
+      - compatible
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - phy-connection-type
+
+dependencies:
+  snps,reset-active-low: ["snps,reset-gpio"]
+  snps,reset-delay-us: ["snps,reset-gpio"]
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - snps,dwxgmac
+              - snps,dwxgmac-2.10
+              - st,spear600-gmac
+
+    then:
+      properties:
+        snps,pbl:
+          allOf:
+            - $ref: /schemas/types.yaml#definitions/uint32
+            - enum: [2, 4, 8]
+          description:
+            Programmable Burst Length (tx and rx)
+
+        snps,txpbl:
+          allOf:
+            - $ref: /schemas/types.yaml#definitions/uint32
+            - enum: [2, 4, 8]
+          description:
+            Tx Programmable Burst Length. If set, DMA tx will use this
+            value rather than snps,pbl.
+
+        snps,rxpbl:
+          allOf:
+            - $ref: /schemas/types.yaml#definitions/uint32
+            - enum: [2, 4, 8]
+          description:
+            Rx Programmable Burst Length. If set, DMA rx will use this
+            value rather than snps,pbl.
+
+        snps,no-pbl-x8:
+          $ref: /schemas/types.yaml#definitions/flag
+          description:
+            Don\'t multiply the pbl/txpbl/rxpbl values by 8. For core
+            rev < 3.50, don\'t multiply the values by 4.
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - snps,dwmac-4.00
+              - snps,dwmac-4.10a
+              - snps,dwxgmac
+              - snps,dwxgmac-2.10
+              - st,spear600-gmac
+
+    then:
+        snps,tso:
+          $ref: /schemas/types.yaml#definitions/flag
+          description:
+            Enables the TSO feature otherwise it will be managed by
+            MAC HW capability register.
+
+examples:
+  - |
+    stmmac_axi_setup: stmmac-axi-config {
+        snps,wr_osr_lmt = <0xf>;
+        snps,rd_osr_lmt = <0xf>;
+        snps,blen = <256 128 64 32 0 0 0>;
+    };
+
+    mtl_rx_setup: rx-queues-config {
+        snps,rx-queues-to-use = <1>;
+        snps,rx-sched-sp;
+        queue0 {
+            snps,dcb-algorithm;
+            snps,map-to-dma-channel = <0x0>;
+            snps,priority = <0x0>;
+        };
+    };
+
+    mtl_tx_setup: tx-queues-config {
+        snps,tx-queues-to-use = <2>;
+        snps,tx-sched-wrr;
+        queue0 {
+            snps,weight = <0x10>;
+            snps,dcb-algorithm;
+            snps,priority = <0x0>;
+        };
+
+        queue1 {
+            snps,avb-algorithm;
+            snps,send_slope = <0x1000>;
+            snps,idle_slope = <0x1000>;
+            snps,high_credit = <0x3E800>;
+            snps,low_credit = <0xFFC18000>;
+            snps,priority = <0x1>;
+        };
+    };
+
+    gmac0: ethernet@e0800000 {
+        compatible = "st,spear600-gmac";
+        reg = <0xe0800000 0x8000>;
+        interrupt-parent = <&vic1>;
+        interrupts = <24 23 22>;
+        interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+        mac-address = [000000000000]; /* Filled in by U-Boot */
+        max-frame-size = <3800>;
+        phy-connection-type = "gmii";
+        snps,multicast-filter-bins = <256>;
+        snps,perfect-filter-entries = <128>;
+        rx-fifo-depth = <16384>;
+        tx-fifo-depth = <16384>;
+        clocks = <&clock>;
+        clock-names = "stmmaceth";
+        snps,axi-config = <&stmmac_axi_setup>;
+        snps,mtl-rx-config = <&mtl_rx_setup>;
+        snps,mtl-tx-config = <&mtl_tx_setup>;
+        mdio0 {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "snps,dwmac-mdio";
+            phy1: ethernet-phy@0 {
+            };
+        };
+    };
+
+# FIXME: We should set it, but it would report all the generic
+# properties as additional properties.
+# additionalProperties: false
+
+...
diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
index cb694062afff..7d48782767cb 100644
--- a/Documentation/devicetree/bindings/net/stmmac.txt
+++ b/Documentation/devicetree/bindings/net/stmmac.txt
@@ -1,178 +1 @@
-* STMicroelectronics 10/100/1000/2500/10000 Ethernet (GMAC/XGMAC)
-
-Required properties:
-- compatible: Should be "snps,dwmac-<ip_version>", "snps,dwmac" or
-	"snps,dwxgmac-<ip_version>", "snps,dwxgmac".
-	For backwards compatibility: "st,spear600-gmac" is also supported.
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the STMMAC interrupts
-- interrupt-names: Should contain a list of interrupt names corresponding to
-	the interrupts in the interrupts property, if available.
-	Valid interrupt names are:
-  - "macirq" (combined signal for various interrupt events)
-  - "eth_wake_irq" (the interrupt to manage the remote wake-up packet detection)
-  - "eth_lpi" (the interrupt that occurs when Rx exits the LPI state)
-- phy-mode: See ethernet.txt file in the same directory.
-- snps,reset-gpio 	gpio number for phy reset.
-- snps,reset-active-low boolean flag to indicate if phy reset is active low.
-- snps,reset-delays-us  is triplet of delays
-	The 1st cell is reset pre-delay in micro seconds.
-	The 2nd cell is reset pulse in micro seconds.
-	The 3rd cell is reset post-delay in micro seconds.
-
-Optional properties:
-- resets: Should contain a phandle to the STMMAC reset signal, if any
-- reset-names: Should contain the reset signal name "stmmaceth", if a
-	reset phandle is given
-- max-frame-size: See ethernet.txt file in the same directory
-- clocks: If present, the first clock should be the GMAC main clock and
-  the second clock should be peripheral's register interface clock. Further
-  clocks may be specified in derived bindings.
-- clock-names: One name for each entry in the clocks property, the
-  first one should be "stmmaceth" and the second one should be "pclk".
-- ptp_ref: this is the PTP reference clock; in case of the PTP is available
-  this clock is used for programming the Timestamp Addend Register. If not
-  passed then the system clock will be used and this is fine on some
-  platforms.
-- tx-fifo-depth: See ethernet.txt file in the same directory
-- rx-fifo-depth: See ethernet.txt file in the same directory
-- snps,pbl		Programmable Burst Length (tx and rx)
-- snps,txpbl		Tx Programmable Burst Length. Only for GMAC and newer.
-			If set, DMA tx will use this value rather than snps,pbl.
-- snps,rxpbl		Rx Programmable Burst Length. Only for GMAC and newer.
-			If set, DMA rx will use this value rather than snps,pbl.
-- snps,no-pbl-x8	Don't multiply the pbl/txpbl/rxpbl values by 8.
-			For core rev < 3.50, don't multiply the values by 4.
-- snps,aal		Address-Aligned Beats
-- snps,fixed-burst	Program the DMA to use the fixed burst mode
-- snps,mixed-burst	Program the DMA to use the mixed burst mode
-- snps,force_thresh_dma_mode	Force DMA to use the threshold mode for
-				both tx and rx
-- snps,force_sf_dma_mode	Force DMA to use the Store and Forward
-				mode for both tx and rx. This flag is
-				ignored if force_thresh_dma_mode is set.
-- snps,en-tx-lpi-clockgating	Enable gating of the MAC TX clock during
-				TX low-power mode
-- snps,multicast-filter-bins:	Number of multicast filter hash bins
-				supported by this device instance
-- snps,perfect-filter-entries:	Number of perfect filter entries supported
-				by this device instance
-- snps,ps-speed: port selection speed that can be passed to the core when
-		 PCS is supported. For example, this is used in case of SGMII
-		 and MAC2MAC connection.
-- snps,tso: this enables the TSO feature otherwise it will be managed by
-		 MAC HW capability register. Only for GMAC4 and newer.
-- AXI BUS Mode parameters: below the list of all the parameters to program the
-			   AXI register inside the DMA module:
-	- snps,lpi_en: enable Low Power Interface
-	- snps,xit_frm: unlock on WoL
-	- snps,wr_osr_lmt: max write outstanding req. limit
-	- snps,rd_osr_lmt: max read outstanding req. limit
-	- snps,kbbe: do not cross 1KiB boundary.
-	- snps,blen: this is a vector of supported burst length.
-	- snps,fb: fixed-burst
-	- snps,mb: mixed-burst
-	- snps,rb: rebuild INCRx Burst
-- mdio: with compatible = "snps,dwmac-mdio", create and register mdio bus.
-- Multiple RX Queues parameters: below the list of all the parameters to
-				 configure the multiple RX queues:
-	- snps,rx-queues-to-use: number of RX queues to be used in the driver
-	- Choose one of these RX scheduling algorithms:
-		- snps,rx-sched-sp: Strict priority
-		- snps,rx-sched-wsp: Weighted Strict priority
-	- For each RX queue
-		- Choose one of these modes:
-			- snps,dcb-algorithm: Queue to be enabled as DCB
-			- snps,avb-algorithm: Queue to be enabled as AVB
-		- snps,map-to-dma-channel: Channel to map
-		- Specifiy specific packet routing:
-			- snps,route-avcp: AV Untagged Control packets
-			- snps,route-ptp: PTP Packets
-			- snps,route-dcbcp: DCB Control Packets
-			- snps,route-up: Untagged Packets
-			- snps,route-multi-broad: Multicast & Broadcast Packets
-		- snps,priority: RX queue priority (Range: 0x0 to 0xF)
-- Multiple TX Queues parameters: below the list of all the parameters to
-				 configure the multiple TX queues:
-	- snps,tx-queues-to-use: number of TX queues to be used in the driver
-	- Choose one of these TX scheduling algorithms:
-		- snps,tx-sched-wrr: Weighted Round Robin
-		- snps,tx-sched-wfq: Weighted Fair Queuing
-		- snps,tx-sched-dwrr: Deficit Weighted Round Robin
-		- snps,tx-sched-sp: Strict priority
-	- For each TX queue
-		- snps,weight: TX queue weight (if using a DCB weight algorithm)
-		- Choose one of these modes:
-			- snps,dcb-algorithm: TX queue will be working in DCB
-			- snps,avb-algorithm: TX queue will be working in AVB
-			  [Attention] Queue 0 is reserved for legacy traffic
-			  and so no AVB is available in this queue.
-		- Configure Credit Base Shaper (if AVB Mode selected):
-			- snps,send_slope: enable Low Power Interface
-			- snps,idle_slope: unlock on WoL
-			- snps,high_credit: max write outstanding req. limit
-			- snps,low_credit: max read outstanding req. limit
-		- snps,priority: TX queue priority (Range: 0x0 to 0xF)
-Examples:
-
-	stmmac_axi_setup: stmmac-axi-config {
-		snps,wr_osr_lmt = <0xf>;
-		snps,rd_osr_lmt = <0xf>;
-		snps,blen = <256 128 64 32 0 0 0>;
-	};
-
-	mtl_rx_setup: rx-queues-config {
-		snps,rx-queues-to-use = <1>;
-		snps,rx-sched-sp;
-		queue0 {
-			snps,dcb-algorithm;
-			snps,map-to-dma-channel = <0x0>;
-			snps,priority = <0x0>;
-		};
-	};
-
-	mtl_tx_setup: tx-queues-config {
-		snps,tx-queues-to-use = <2>;
-		snps,tx-sched-wrr;
-		queue0 {
-			snps,weight = <0x10>;
-			snps,dcb-algorithm;
-			snps,priority = <0x0>;
-		};
-
-		queue1 {
-			snps,avb-algorithm;
-			snps,send_slope = <0x1000>;
-			snps,idle_slope = <0x1000>;
-			snps,high_credit = <0x3E800>;
-			snps,low_credit = <0xFFC18000>;
-			snps,priority = <0x1>;
-		};
-	};
-
-	gmac0: ethernet@e0800000 {
-		compatible = "st,spear600-gmac";
-		reg = <0xe0800000 0x8000>;
-		interrupt-parent = <&vic1>;
-		interrupts = <24 23 22>;
-		interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
-		mac-address = [000000000000]; /* Filled in by U-Boot */
-		max-frame-size = <3800>;
-		phy-mode = "gmii";
-		snps,multicast-filter-bins = <256>;
-		snps,perfect-filter-entries = <128>;
-		rx-fifo-depth = <16384>;
-		tx-fifo-depth = <16384>;
-		clocks = <&clock>;
-		clock-names = "stmmaceth";
-		snps,axi-config = <&stmmac_axi_setup>;
-		mdio0 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "snps,dwmac-mdio";
-			phy1: ethernet-phy@0 {
-			};
-		};
-		snps,mtl-rx-config = <&mtl_rx_setup>;
-		snps,mtl-tx-config = <&mtl_tx_setup>;
-	};
+This file has moved to snps,dwmac.yaml.
-- 
git-series 0.9.1
