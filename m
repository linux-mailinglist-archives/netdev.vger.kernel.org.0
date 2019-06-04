Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C904935215
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFDVoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:44:10 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:27011 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfFDVoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:44:08 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x54Li2jL006543
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 Jun 2019 15:44:05 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x54Lhw3p020053
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Jun 2019 15:44:02 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v3 17/19] net: axienet: document axistream-connected attribute
Date:   Tue,  4 Jun 2019 15:43:44 -0600
Message-Id: <1559684626-24775-18-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axienet driver requires the use of an axistream-connected attribute,
but this isn't documented in the devicetree bindings. Document how this
attribute is supposed to be used, including the upcoming change to make
the usage of this attribute optional.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 .../devicetree/bindings/net/xilinx_axienet.txt        | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 0be335c..06d2e42 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -17,9 +17,15 @@ For more details about mdio please refer phy.txt file in the same directory.
 Required properties:
 - compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
 		  "xlnx,axi-ethernet-1.01.a", "xlnx,axi-ethernet-2.01.a"
-- reg		: Address and length of the IO space.
+- reg		: Address and length of the IO space, as well as the address
+                  and length of the AXI DMA controller IO space, unless
+                  axistream-connected is specified, in which case the reg
+                  attribute of the node referenced by it is used.
 - interrupts	: Should be a list of 2 or 3 interrupts: TX DMA, RX DMA,
-		  and optionally Ethernet core.
+		  and optionally Ethernet core. If axistream-connected is
+		  specified, the TX/RX DMA interrupts should be on that node
+		  instead, and only the Ethernet core interrupt is optionally
+		  specified here.
 - phy-handle	: Should point to the external phy device.
 		  See ethernet.txt file in the same directory.
 - xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
@@ -37,16 +43,21 @@ Optional properties:
 		  auto-detected from the CPU clock (but only on platforms where
 		  this is possible). New device trees should specify this - the
 		  auto detection is only for backward compatibility.
+- axistream-connected: Reference to another node which contains the resources
+		       for the AXI DMA controller used by this device.
+		       If this is specified, the DMA-related resources from that
+		       device (DMA registers and DMA TX/RX interrupts) rather
+		       than this one will be used.
 
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
 		compatible = "xlnx,axi-ethernet-1.00.a";
 		device_type = "network";
 		interrupt-parent = <&microblaze_0_axi_intc>;
-		interrupts = <2 0>;
+		interrupts = <2 0 1>;
 		clocks = <&axi_clk>;
 		phy-mode = "mii";
-		reg = <0x40c00000 0x40000>;
+		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
 		xlnx,rxcsum = <0x2>;
 		xlnx,rxmem = <0x800>;
 		xlnx,txcsum = <0x2>;
-- 
1.8.3.1

