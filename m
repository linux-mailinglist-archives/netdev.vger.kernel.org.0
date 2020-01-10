Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729A0136C68
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgAJLyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:54:44 -0500
Received: from foss.arm.com ([217.140.110.172]:43228 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgAJLyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C452D1474;
        Fri, 10 Jan 2020 03:54:42 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48F7D3F534;
        Fri, 10 Jan 2020 03:54:41 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH 14/14] net: axienet: Update devicetree binding documentation
Date:   Fri, 10 Jan 2020 11:54:15 +0000
Message-Id: <20200110115415.75683-15-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110115415.75683-1-andre.przywara@arm.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds documentation about the newly introduced, optional
"xlnx,addrwidth" property to the binding documentation.

While at it, clarify the wording on some properties, replace obsolete
.txt file references with their new .yaml counterparts, and add a more
modern example, using the axistream-connected property.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../bindings/net/xilinx_axienet.txt           | 57 ++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 7360617cdedb..78c278c5200f 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -12,7 +12,8 @@ sent and received through means of an AXI DMA controller. This driver
 includes the DMA driver code, so this driver is incompatible with AXI DMA
 driver.
 
-For more details about mdio please refer phy.txt file in the same directory.
+For more details about mdio please refer to the ethernet-phy.yaml file in
+the same directory.
 
 Required properties:
 - compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
@@ -27,14 +28,14 @@ Required properties:
 		  instead, and only the Ethernet core interrupt is optionally
 		  specified here.
 - phy-handle	: Should point to the external phy device.
-		  See ethernet.txt file in the same directory.
-- xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
+		  See the ethernet-controller.yaml file in the same directory.
+- xlnx,rxmem	: Size of the RXMEM buffer in the hardware, in bytes.
 
 Optional properties:
-- phy-mode	: See ethernet.txt
+- phy-mode	: See ethernet-controller.yaml.
 - xlnx,phy-type	: Deprecated, do not use, but still accepted in preference
 		  to phy-mode.
-- xlnx,txcsum	: 0 or empty for disabling TX checksum offload,
+- xlnx,txcsum	: 0 for disabling TX checksum offload (default if omitted),
 		  1 to enable partial TX checksum offload,
 		  2 to enable full TX checksum offload
 - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
@@ -48,10 +49,20 @@ Optional properties:
 		       If this is specified, the DMA-related resources from that
 		       device (DMA registers and DMA TX/RX interrupts) rather
 		       than this one will be used.
- - mdio		: Child node for MDIO bus. Must be defined if PHY access is
+- mdio		: Child node for MDIO bus. Must be defined if PHY access is
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
 
+Required properties for axistream-connected subnode:
+- reg		: Address and length of the AXI DMA controller MMIO space.
+- interrupts	: A list of 2 interrupts: TX DMA and RX DMA, in that order.
+
+Optional properties for axistream-connected subnode:
+- xlnx,addrwidth: Specifies the configured address width of the DMA. Newer
+		  versions of the IP allow setting this to a value between
+		  32 and 64. Defaults to 32 bits if not specified.
+
+
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
 		compatible = "xlnx,axi-ethernet-1.00.a";
@@ -60,7 +71,7 @@ Example:
 		interrupts = <2 0 1>;
 		clocks = <&axi_clk>;
 		phy-mode = "mii";
-		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
+		reg = <0x40c00000 0x40000>, <0x50c00000 0x40000>;
 		xlnx,rxcsum = <0x2>;
 		xlnx,rxmem = <0x800>;
 		xlnx,txcsum = <0x2>;
@@ -74,3 +85,35 @@ Example:
 			};
 		};
 	};
+    -----------------
+	axi_ethernet_eth: ethernet@7fe00000 {
+		compatible = "acme,fpga-ethernet", "xlnx,axi-ethernet-1.00.a";
+		reg = <0 0x7fe00000 0 0x40000>;
+		interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&soc_refclk100mhz>;
+
+		phy-mode = "sgmii";
+		phy-handle = <&phy0>;
+
+		xlnx,rxmem = <4096>;
+		axistream-connected = <&axi_dma_eth>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		axi_dma_eth: axi_dma_ethernet@7fe40000 {
+			reg = <0 0x7fe40000 0 0x10000>;
+			interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
+			xlnx,addrwidth = <40>;
+		};
+
+		axi_ethernetlite_0_mdio: mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy0: phy@1 {
+				compatible = "ethernet-phy-ieee802.3-c22";
+				reg = <1>;
+			};
+		};
+	};
-- 
2.17.1

