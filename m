Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B4433A68
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFCV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:43 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:7227 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfFCV5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:42 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53Lvfcm007329
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:41 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMO008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:33 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 07/18] net: axienet: Re-initialize MDIO registers properly after reset
Date:   Mon,  3 Jun 2019 15:57:06 -0600
Message-Id: <1559599037-8514-8-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO clock divisor register setting was only applied on the initial
startup when the driver was loaded. However, this setting is cleared
when the device is reset, such as would occur when the interface was
taken down and brought up again, and so the MDIO bus would be
non-functional afterwards.

Split up the MDIO bus setup and enable into separate functions and
re-enable the bus after a device reset, to ensure that the MDIO
registers are set properly. This also allows us to remove direct access
to MDIO registers in xilinx_axienet_main.c and centralize them all in
xilinx_axienet_mdio.c.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 32 ++++---------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 55 ++++++++++++++++-------
 3 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1b3d8a4..7048468 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -505,8 +505,9 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
+int axienet_mdio_enable(struct axienet_local *lp);
+void axienet_mdio_disable(struct axienet_local *lp);
 int axienet_mdio_setup(struct axienet_local *lp);
-int axienet_mdio_wait_until_ready(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
 #endif /* XILINX_AXI_ENET_H */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0c13261..6f0ce17 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -913,27 +913,20 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
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
-	 * including the MDIO. If MDIO is not disabled when the reset
-	 * process is started, MDIO will be broken afterwards.
+	 * including the MDIO. MDIO must be disabled before resetting
+	 * and re-enabled afterwards.
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
 
@@ -1315,28 +1308,21 @@ static void axienet_dma_err_handler(unsigned long data)
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
-	 * including the MDIO. So if MDIO is not disabled when the reset
-	 * process is started, MDIO will be broken afterwards.
+	 * including the MDIO. MDIO must be disabled before resetting
+	 * and re-enabled afterwards.
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
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 0bba9bb..3833e89 100644
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
 
@@ -112,25 +113,20 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 }
 
 /**
- * axienet_mdio_setup - MDIO setup function
+ * axienet_mdio_enable - MDIO hardware setup function
  * @lp:		Pointer to axienet local data structure.
  *
- * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
- *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
+ * Return:	0 on success, -ETIMEDOUT on a timeout.
  *
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
- * MDIO interface in hardware. Register the MDIO interface.
+ * MDIO interface in hardware.
  **/
-int axienet_mdio_setup(struct axienet_local *lp)
+int axienet_mdio_enable(struct axienet_local *lp)
 {
 	u32 clk_div = lp->mdio_clock_divisor;
-	int ret;
-	struct mii_bus *bus;
-	struct device_node *mdio_node;
 
 	if (!clk_div) {
-		u32 clk_div, host_clock;
-		struct device_node *np1;
+		u32 host_clock;
 
 		/* clk_div can be calculated by deriving it from the equation:
 		 * fMDIO = fHOST / ((1 + clk_div) * 2)
@@ -156,8 +152,8 @@ int axienet_mdio_setup(struct axienet_local *lp)
 		 * fHOST can be read from the flattened device tree as property
 		 * "clock-frequency" from the CPU
 		 */
+		struct device_node *np1 = of_find_node_by_name(NULL, "cpu");
 
-		np1 = of_find_node_by_name(NULL, "cpu");
 		if (!np1) {
 			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
 			netdev_warn(lp->ndev,
@@ -191,10 +187,39 @@ int axienet_mdio_setup(struct axienet_local *lp)
 		of_node_put(np1);
 	}
 issue:
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
-		    (((u32) clk_div) | XAE_MDIO_MC_MDIOEN_MASK));
+	axienet_iow(lp, XAE_MDIO_MC_OFFSET, clk_div | XAE_MDIO_MC_MDIOEN_MASK);
 
-	ret = axienet_mdio_wait_until_ready(lp);
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
+ * axienet_mdio_setup - MDIO setup function
+ * @lp:		Pointer to axienet local data structure.
+ *
+ * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
+ *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
+ *
+ * Sets up the MDIO interface by initializing the MDIO clock and enabling the
+ * MDIO interface in hardware. Register the MDIO interface.
+ **/
+int axienet_mdio_setup(struct axienet_local *lp)
+{
+	int ret;
+	struct mii_bus *bus;
+	struct device_node *mdio_node;
+
+	ret = axienet_mdio_enable(lp);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

