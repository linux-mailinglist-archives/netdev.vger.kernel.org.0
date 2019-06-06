Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C56380C0
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbfFFW3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:49 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:18689 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfFFW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:25 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHY8018363
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:20 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAP4028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 05/20] net: axienet: Use clock framework to get device clock rate
Date:   Thu,  6 Jun 2019 16:28:09 -0600
Message-Id: <1559860104-927-6-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was previously always calculating the MDIO clock divisor
(from AXI bus clock to MDIO bus clock) based on the CPU clock frequency,
assuming that it is the same as the AXI bus frequency, but that
simplistic method only works on the MicroBlaze platform.

Add support for specifying the clock used for the device in the device
tree using the clock framework. If the clock is specified then it will
be used when calculating the clock divisor. The previous CPU clock
detection method is left for backward compatibility if no clock is
specified.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |  6 +++
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  5 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 23 +++++++++-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 53 ++++++++++++----------
 4 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 38f9ec0..2dea903 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -31,6 +31,11 @@ Optional properties:
 		  1 to enable partial TX checksum offload,
 		  2 to enable full TX checksum offload
 - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
+- clocks	: AXI bus clock for the device. Refer to common clock bindings.
+		  Used to calculate MDIO clock divisor. If not specified, it is
+		  auto-detected from the CPU clock (but only on platforms where
+		  this is possible). New device trees should specify this - the
+		  auto detection is only for backward compatibility.
 
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
@@ -38,6 +43,7 @@ Example:
 		device_type = "network";
 		interrupt-parent = <&microblaze_0_axi_intc>;
 		interrupts = <2 0>;
+		clocks = <&axi_clk>;
 		phy-mode = "mii";
 		reg = <0x40c00000 0x40000>;
 		xlnx,rxcsum = <0x2>;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f9078bd..f240ff1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -418,6 +418,9 @@ struct axienet_local {
 	/* Connection to PHY device */
 	struct device_node *phy_node;
 
+	/* Clock for AXI bus */
+	struct clk *clk;
+
 	/* MDIO bus data */
 	struct mii_bus *mii_bus;	/* MII bus reference */
 
@@ -502,7 +505,7 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np);
+int axienet_mdio_setup(struct axienet_local *lp);
 int axienet_mdio_wait_until_ready(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ffbd4d7..42b343c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -21,6 +21,7 @@
  *  - Add support for extended VLAN support.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
@@ -1611,9 +1612,24 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp, pdev->dev.of_node);
+		lp->clk = devm_clk_get(&pdev->dev, NULL);
+		if (IS_ERR(lp->clk)) {
+			dev_warn(&pdev->dev, "Failed to get clock: %ld\n",
+				 PTR_ERR(lp->clk));
+			lp->clk = NULL;
+		} else {
+			ret = clk_prepare_enable(lp->clk);
+			if (ret) {
+				dev_err(&pdev->dev, "Unable to enable clock: %d\n",
+					ret);
+				goto free_netdev;
+			}
+		}
+
+		ret = axienet_mdio_setup(lp);
 		if (ret)
-			dev_warn(&pdev->dev, "error registering MDIO bus\n");
+			dev_warn(&pdev->dev,
+				 "error registering MDIO bus: %d\n", ret);
 	}
 
 	ret = register_netdev(lp->ndev);
@@ -1638,6 +1654,9 @@ static int axienet_remove(struct platform_device *pdev)
 	axienet_mdio_teardown(lp);
 	unregister_netdev(ndev);
 
+	if (lp->clk)
+		clk_disable_unprepare(lp->clk);
+
 	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 665ae1d..cce0dc4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  */
 
+#include <linux/clk.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/jiffies.h>
@@ -16,7 +17,7 @@
 #include "xilinx_axienet.h"
 
 #define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
-#define DEFAULT_CLOCK_DIVISOR	XAE_MDIO_DIV_DFT
+#define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
 int axienet_mdio_wait_until_ready(struct axienet_local *lp)
@@ -114,7 +115,6 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
- * @np:		Pointer to device node
  *
  * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
  *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
@@ -122,13 +122,37 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware. Register the MDIO interface.
  **/
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
+int axienet_mdio_setup(struct axienet_local *lp)
 {
 	int ret;
 	u32 clk_div, host_clock;
 	struct mii_bus *bus;
 	struct device_node *mdio_node;
-	struct device_node *np1;
+
+	if (lp->clk) {
+		host_clock = clk_get_rate(lp->clk);
+	} else {
+		struct device_node *np1;
+
+		/* Legacy fallback: detect CPU clock frequency and use as AXI
+		 * bus clock frequency. This only works on certain platforms.
+		 */
+		np1 = of_find_node_by_name(NULL, "cpu");
+		if (!np1) {
+			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
+			host_clock = DEFAULT_HOST_CLOCK;
+		} else {
+			ret = of_property_read_u32(np1, "clock-frequency",
+						   &host_clock);
+			if (ret) {
+				netdev_warn(lp->ndev, "CPU clock-frequency property not found.\n");
+				host_clock = DEFAULT_HOST_CLOCK;
+			}
+			of_node_put(np1);
+		}
+		netdev_info(lp->ndev, "Setting assumed host clock to %u\n",
+			    host_clock);
+	}
 
 	/* clk_div can be calculated by deriving it from the equation:
 	 * fMDIO = fHOST / ((1 + clk_div) * 2)
@@ -155,25 +179,6 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	 * "clock-frequency" from the CPU
 	 */
 
-	np1 = of_find_node_by_name(NULL, "cpu");
-	if (!np1) {
-		netdev_warn(lp->ndev, "Could not find CPU device node.\n");
-		netdev_warn(lp->ndev,
-			    "Setting MDIO clock divisor to default %d\n",
-			    DEFAULT_CLOCK_DIVISOR);
-		clk_div = DEFAULT_CLOCK_DIVISOR;
-		goto issue;
-	}
-	if (of_property_read_u32(np1, "clock-frequency", &host_clock)) {
-		netdev_warn(lp->ndev, "clock-frequency property not found.\n");
-		netdev_warn(lp->ndev,
-			    "Setting MDIO clock divisor to default %d\n",
-			    DEFAULT_CLOCK_DIVISOR);
-		clk_div = DEFAULT_CLOCK_DIVISOR;
-		of_node_put(np1);
-		goto issue;
-	}
-
 	clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
 	/* If there is any remainder from the division of
 	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
@@ -186,8 +191,6 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
 		   clk_div, host_clock);
 
-	of_node_put(np1);
-issue:
 	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
 		    (((u32) clk_div) | XAE_MDIO_MC_MDIOEN_MASK));
 
-- 
1.8.3.1

