Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4EF33A6C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFCV5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:50 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:45218 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFCV5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:40 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53Lvdme009803
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:40 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMK008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:31 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 03/18] net: axienet: fix MDIO bus naming
Date:   Mon,  3 Jun 2019 15:57:02 -0600
Message-Id: <1559599037-8514-4-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO bus for this driver was being named using the result of
of_address_to_resource on a node which may not have any resource on it,
but the return value of that call was not checked so it was using some
random value in the bus name. Change to name the MDIO bus based on the
resource start of the actual Ethernet register block.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 11 +++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d82e3b6..f9078bd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -380,6 +380,7 @@ struct axidma_bd {
  * @dev:	Pointer to device structure
  * @phy_node:	Pointer to device node structure
  * @mii_bus:	Pointer to MII bus structure
+ * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
  * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
@@ -421,6 +422,7 @@ struct axienet_local {
 	struct mii_bus *mii_bus;	/* MII bus reference */
 
 	/* IO registers, dma functions and IRQs */
+	resource_size_t regs_start;
 	void __iomem *regs;
 	void __iomem *dma_regs;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 55beca1..ffbd4d7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1480,6 +1480,7 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->options = XAE_OPTION_DEFAULTS;
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lp->regs_start = ethres->start;
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 704babd..665ae1d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -127,7 +127,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	int ret;
 	u32 clk_div, host_clock;
 	struct mii_bus *bus;
-	struct resource res;
+	struct device_node *mdio_node;
 	struct device_node *np1;
 
 	/* clk_div can be calculated by deriving it from the equation:
@@ -199,10 +199,9 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	if (!bus)
 		return -ENOMEM;
 
-	np1 = of_get_parent(lp->phy_node);
-	of_address_to_resource(np1, 0, &res);
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
-		 (unsigned long long) res.start);
+	mdio_node = of_get_parent(lp->phy_node);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "axienet-%.8llx",
+		 (unsigned long long)lp->regs_start);
 
 	bus->priv = lp;
 	bus->name = "Xilinx Axi Ethernet MDIO";
@@ -211,7 +210,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 	bus->parent = lp->dev;
 	lp->mii_bus = bus;
 
-	ret = of_mdiobus_register(bus, np1);
+	ret = of_mdiobus_register(bus, mdio_node);
 	if (ret) {
 		mdiobus_free(bus);
 		lp->mii_bus = NULL;
-- 
1.8.3.1

