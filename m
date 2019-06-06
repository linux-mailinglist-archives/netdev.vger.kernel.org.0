Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE91380BF
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfFFW3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:49 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:4039 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfFFW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:25 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHSK019524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:21 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAPH028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 18/20] net: axienet: document axistream-connected attribute
Date:   Thu,  6 Jun 2019 16:28:22 -0600
Message-Id: <1559860104-927-19-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
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
index a8be67b..7360617 100644
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
@@ -37,6 +43,11 @@ Optional properties:
 		  auto-detected from the CPU clock (but only on platforms where
 		  this is possible). New device trees should specify this - the
 		  auto detection is only for backward compatibility.
+- axistream-connected: Reference to another node which contains the resources
+		       for the AXI DMA controller used by this device.
+		       If this is specified, the DMA-related resources from that
+		       device (DMA registers and DMA TX/RX interrupts) rather
+		       than this one will be used.
  - mdio		: Child node for MDIO bus. Must be defined if PHY access is
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
@@ -46,10 +57,10 @@ Example:
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

