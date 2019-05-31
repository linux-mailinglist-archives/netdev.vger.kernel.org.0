Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5F314AE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfEaSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:32 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:25532 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfEaSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:30:32 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 14:30:19 EDT
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VIGDsD027607
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 12:16:13 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VIG5Dk043766
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 12:16:12 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 02/13] net: axienet: clean up MDIO handling
Date:   Fri, 31 May 2019 12:15:34 -0600
Message-Id: <1559326545-28825-3-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-Allow specifying the MDIO clock divisor explicitly in the device tree,
rather than always detecting it from the CPU clock which only works on
the MicroBlaze platform.

-Centralize all MDIO handling in xilinx_axienet_mdio.c

-Ensure that MDIO clock divisor is always re-set after resetting the
device, since it will be cleared.

-Fixed ordering of MDIO teardown vs. netdev teardown

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |   4 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  36 ++---
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  | 160 ++++++++++++---------
 4 files changed, 117 insertions(+), 91 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 38f9ec0..708722e 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -31,6 +31,10 @@ Optional properties:
 		  1 to enable partial TX checksum offload,
 		  2 to enable full TX checksum offload
 - xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
+- xlnx,mdio-clock-divisor: Explicitly set clock divisor from AXI bus clock
+                           to MDIO bus. If not specified, it is auto-detected
+                           from the CPU clock (but only on platforms where this
+                           is possible).
 
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 0d89ebc..dfe0e4c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -418,6 +418,9 @@ struct axienet_local {
 	/* Connection to PHY device */
 	struct device_node *phy_node;
 
+	/* MDIO clock divisor (0=detected from CPU clock) */
+	u32 mdio_clock_divisor;
+
 	/* MDIO bus data */
 	struct mii_bus *mii_bus;	/* MII bus reference */
 
@@ -510,8 +513,9 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np);
-int axienet_mdio_wait_until_ready(struct axienet_local *lp);
+int axienet_mdio_enable(struct axienet_local *lp);
+void axienet_mdio_disable(struct axienet_local *lp);
+int axienet_mdio_setup(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
 #endif /* XILINX_AXI_ENET_H */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c0a8861..2e69755 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -921,27 +921,20 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
  */
 static int axienet_open(struct net_device *ndev)
 {
-	int ret, mdio_mcreg;
+	int ret;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct phy_device *phydev = NULL;
 
 	dev_dbg(&ndev->dev, "axienet_open()\n");
 
-	mdio_mcreg = axienet_ior(lp, XAE_MDIO_MC_OFFSET);
-	ret = axienet_mdio_wait_until_ready(lp);
-	if (ret < 0)
-		return ret;
 	/* Disable the MDIO interface till Axi Ethernet Reset is completed.
 	 * When we do an Axi Ethernet reset, it resets the complete core
 	 * including the MDIO. If MDIO is not disabled when the reset
 	 * process is started, MDIO will be broken afterwards.
 	 */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
-		    (mdio_mcreg & (~XAE_MDIO_MC_MDIOEN_MASK)));
+	axienet_mdio_disable(lp);
 	axienet_device_reset(ndev);
-	/* Enable the MDIO */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, mdio_mcreg);
-	ret = axienet_mdio_wait_until_ready(lp);
+	ret = axienet_mdio_enable(lp);
 	if (ret < 0)
 		return ret;
 
@@ -1323,28 +1316,21 @@ static void axienet_dma_err_handler(unsigned long data)
 {
 	u32 axienet_status;
 	u32 cr, i;
-	int mdio_mcreg;
 	struct axienet_local *lp = (struct axienet_local *) data;
 	struct net_device *ndev = lp->ndev;
 	struct axidma_bd *cur_p;
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	mdio_mcreg = axienet_ior(lp, XAE_MDIO_MC_OFFSET);
-	axienet_mdio_wait_until_ready(lp);
 	/* Disable the MDIO interface till Axi Ethernet Reset is completed.
 	 * When we do an Axi Ethernet reset, it resets the complete core
 	 * including the MDIO. So if MDIO is not disabled when the reset
 	 * process is started, MDIO will be broken afterwards.
 	 */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, (mdio_mcreg &
-		    ~XAE_MDIO_MC_MDIOEN_MASK));
-
+	axienet_mdio_disable(lp);
 	__axienet_device_reset(lp, XAXIDMA_TX_CR_OFFSET);
 	__axienet_device_reset(lp, XAXIDMA_RX_CR_OFFSET);
-
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, mdio_mcreg);
-	axienet_mdio_wait_until_ready(lp);
+	axienet_mdio_enable(lp);
 
 	for (i = 0; i < TX_BD_NUM; i++) {
 		cur_p = &lp->tx_bd_v[i];
@@ -1619,9 +1605,15 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp, pdev->dev.of_node);
+		/* Defaults to 0 if not present */
+		of_property_read_u32(pdev->dev.of_node,
+				     "xlnx,mdio-clock-divisor",
+				     &lp->mdio_clock_divisor);
+
+		ret = axienet_mdio_setup(lp);
 		if (ret)
-			dev_warn(&pdev->dev, "error registering MDIO bus\n");
+			dev_warn(&pdev->dev,
+				 "error registering MDIO bus: %d\n", ret);
 	}
 
 	ret = register_netdev(lp->ndev);
@@ -1643,8 +1635,8 @@ static int axienet_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	axienet_mdio_teardown(lp);
 	unregister_netdev(ndev);
+	axienet_mdio_teardown(lp);
 
 	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 665ae1d..662e005 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2009 Secret Lab Technologies, Ltd.
  * Copyright (c) 2010 - 2011 Michal Simek <monstr@monstr.eu>
  * Copyright (c) 2010 - 2011 PetaLogix
+ * Copyright (c) 2019 SED Systems, a division of Calian Ltd.
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  */
 
@@ -19,7 +20,7 @@
 #define DEFAULT_CLOCK_DIVISOR	XAE_MDIO_DIV_DFT
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
-int axienet_mdio_wait_until_ready(struct axienet_local *lp)
+static int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 {
 	u32 val;
 
@@ -112,9 +113,97 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 }
 
 /**
+ * axienet_mdio_enable - MDIO hardware setup function
+ * @lp:		Pointer to axienet local data structure.
+ *
+ * Return:	0 on success, -ETIMEDOUT on a timeout.
+ *
+ * Sets up the MDIO interface by initializing the MDIO clock and enabling the
+ * MDIO interface in hardware.
+ **/
+int axienet_mdio_enable(struct axienet_local *lp)
+{
+	u32 clk_div = lp->mdio_clock_divisor, host_clock;
+
+	if (!clk_div) {
+		/* clk_div can be calculated by deriving it from the equation:
+		 * fMDIO = fHOST / ((1 + clk_div) * 2)
+		 *
+		 * Where fMDIO <= 2500000, so we get:
+		 * fHOST / ((1 + clk_div) * 2) <= 2500000
+		 *
+		 * Then we get:
+		 * 1 / ((1 + clk_div) * 2) <= (2500000 / fHOST)
+		 *
+		 * Then we get:
+		 * 1 / (1 + clk_div) <= ((2500000 * 2) / fHOST)
+		 *
+		 * Then we get:
+		 * 1 / (1 + clk_div) <= (5000000 / fHOST)
+		 *
+		 * So:
+		 * (1 + clk_div) >= (fHOST / 5000000)
+		 *
+		 * And finally:
+		 * clk_div >= (fHOST / 5000000) - 1
+		 *
+		 * fHOST can be read from the flattened device tree as property
+		 * "clock-frequency" from the CPU
+		 */
+		struct device_node *np1 = of_find_node_by_name(NULL, "cpu");
+
+		if (!np1) {
+			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
+			netdev_warn(lp->ndev,
+				    "Setting MDIO clock divisor to default %d\n",
+				    DEFAULT_CLOCK_DIVISOR);
+			clk_div = DEFAULT_CLOCK_DIVISOR;
+			goto issue;
+		}
+		if (of_property_read_u32(np1, "clock-frequency", &host_clock)) {
+			netdev_warn(lp->ndev, "clock-frequency property not found.\n");
+			netdev_warn(lp->ndev,
+				    "Setting MDIO clock divisor to default %d\n",
+				    DEFAULT_CLOCK_DIVISOR);
+			clk_div = DEFAULT_CLOCK_DIVISOR;
+			of_node_put(np1);
+			goto issue;
+		}
+
+		clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+		/* If there is any remainder from the division of
+		 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
+		 * 1 to the clock divisor or we will surely be above 2.5 MHz
+		 */
+		if (host_clock % (MAX_MDIO_FREQ * 2))
+			clk_div++;
+
+		netdev_dbg(lp->ndev,
+			   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
+			   clk_div, host_clock);
+
+		of_node_put(np1);
+	}
+issue:
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET, clk_div | XAE_MDIO_MC_MDIOEN_MASK);
+
+	return axienet_mdio_wait_until_ready(lp);
+}
+
+/**
+ * axienet_mdio_disable - MDIO hardware disable function
+ * @lp:		Pointer to axienet local data structure.
+ *
+ * Disable the MDIO interface in hardware.
+ **/
+void axienet_mdio_disable(struct axienet_local *lp)
+{
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET, 0);
+}
+
+/**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
- * @np:		Pointer to device node
  *
  * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
  *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
@@ -122,76 +211,13 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware. Register the MDIO interface.
  **/
-int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
+int axienet_mdio_setup(struct axienet_local *lp)
 {
 	int ret;
-	u32 clk_div, host_clock;
 	struct mii_bus *bus;
 	struct device_node *mdio_node;
-	struct device_node *np1;
-
-	/* clk_div can be calculated by deriving it from the equation:
-	 * fMDIO = fHOST / ((1 + clk_div) * 2)
-	 *
-	 * Where fMDIO <= 2500000, so we get:
-	 * fHOST / ((1 + clk_div) * 2) <= 2500000
-	 *
-	 * Then we get:
-	 * 1 / ((1 + clk_div) * 2) <= (2500000 / fHOST)
-	 *
-	 * Then we get:
-	 * 1 / (1 + clk_div) <= ((2500000 * 2) / fHOST)
-	 *
-	 * Then we get:
-	 * 1 / (1 + clk_div) <= (5000000 / fHOST)
-	 *
-	 * So:
-	 * (1 + clk_div) >= (fHOST / 5000000)
-	 *
-	 * And finally:
-	 * clk_div >= (fHOST / 5000000) - 1
-	 *
-	 * fHOST can be read from the flattened device tree as property
-	 * "clock-frequency" from the CPU
-	 */
-
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
-	clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
-	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
-	 * 1 to the clock divisor or we will surely be above 2.5 MHz
-	 */
-	if (host_clock % (MAX_MDIO_FREQ * 2))
-		clk_div++;
 
-	netdev_dbg(lp->ndev,
-		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
-		   clk_div, host_clock);
-
-	of_node_put(np1);
-issue:
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
-		    (((u32) clk_div) | XAE_MDIO_MC_MDIOEN_MASK));
-
-	ret = axienet_mdio_wait_until_ready(lp);
+	ret = axienet_mdio_enable(lp);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

