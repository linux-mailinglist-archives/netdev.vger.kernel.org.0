Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C5380B0
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfFFW31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:27 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:33564 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFFW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:25 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHUl024215
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:21 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAP6028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 07/20] net: axienet: Re-initialize MDIO registers properly after reset
Date:   Thu,  6 Jun 2019 16:28:11 -0600
Message-Id: <1559860104-927-8-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
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

Also, lock the MDIO bus lock around the device reset process, to avoid
MDIO accesses from occurring while the MDIO is disabled during the reset.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 38 +++++++---------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 54 +++++++++++++++++------
 3 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f240ff1..4a135ed 100644
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
index 5cb39de..e735ca7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -914,27 +914,23 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
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
+	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
-		    (mdio_mcreg & (~XAE_MDIO_MC_MDIOEN_MASK)));
+	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_mdio_disable(lp);
 	axienet_device_reset(ndev);
-	/* Enable the MDIO */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, mdio_mcreg);
-	ret = axienet_mdio_wait_until_ready(lp);
+	ret = axienet_mdio_enable(lp);
+	mutex_unlock(&lp->mii_bus->mdio_lock);
 	if (ret < 0)
 		return ret;
 
@@ -1316,28 +1312,24 @@ static void axienet_dma_err_handler(unsigned long data)
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
+	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, (mdio_mcreg &
-		    ~XAE_MDIO_MC_MDIOEN_MASK));
-
+	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_mdio_disable(lp);
 	__axienet_device_reset(lp, XAXIDMA_TX_CR_OFFSET);
 	__axienet_device_reset(lp, XAXIDMA_RX_CR_OFFSET);
-
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, mdio_mcreg);
-	axienet_mdio_wait_until_ready(lp);
+	axienet_mdio_enable(lp);
+	mutex_unlock(&lp->mii_bus->mdio_lock);
 
 	for (i = 0; i < TX_BD_NUM; i++) {
 		cur_p = &lp->tx_bd_v[i];
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index cce0dc4..7106810 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2009 Secret Lab Technologies, Ltd.
  * Copyright (c) 2010 - 2011 Michal Simek <monstr@monstr.eu>
  * Copyright (c) 2010 - 2011 PetaLogix
+ * Copyright (c) 2019 SED Systems, a division of Calian Ltd.
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  */
 
@@ -20,7 +21,7 @@
 #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
-int axienet_mdio_wait_until_ready(struct axienet_local *lp)
+static int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 {
 	u32 val;
 
@@ -113,21 +114,17 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
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
-	int ret;
 	u32 clk_div, host_clock;
-	struct mii_bus *bus;
-	struct device_node *mdio_node;
 
 	if (lp->clk) {
 		host_clock = clk_get_rate(lp->clk);
@@ -142,8 +139,8 @@ int axienet_mdio_setup(struct axienet_local *lp)
 			netdev_warn(lp->ndev, "Could not find CPU device node.\n");
 			host_clock = DEFAULT_HOST_CLOCK;
 		} else {
-			ret = of_property_read_u32(np1, "clock-frequency",
-						   &host_clock);
+			int ret = of_property_read_u32(np1, "clock-frequency",
+						       &host_clock);
 			if (ret) {
 				netdev_warn(lp->ndev, "CPU clock-frequency property not found.\n");
 				host_clock = DEFAULT_HOST_CLOCK;
@@ -191,10 +188,39 @@ int axienet_mdio_setup(struct axienet_local *lp)
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
 		   clk_div, host_clock);
 
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
+	struct device_node *mdio_node;
+	struct mii_bus *bus;
+	int ret;
+
+	ret = axienet_mdio_enable(lp);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

