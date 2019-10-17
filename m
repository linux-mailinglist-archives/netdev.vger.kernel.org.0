Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD37FDB9AE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438455AbfJQWWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:22:38 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35307 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406984AbfJQWWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:22:37 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 10D491C0008;
        Thu, 17 Oct 2019 22:22:36 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH net-next v3 2/2] net: lpc_eth: parse phy nodes from device tree
Date:   Fri, 18 Oct 2019 00:22:31 +0200
Message-Id: <20191017222231.29122-3-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
References: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When connected to a micrel phy, phy_find_first doesn't work properly
because the first phy found is on address 0, the broadcast address but, the
first thing the phy driver is doing is disabling this broadcast address.
The phy is then available only on address 1 but the mdio driver doesn't
know about it.

Instead, register the mdio bus using of_mdiobus_register and try to find
the phy description in device tree before falling back to phy_find_first.

This ultimately also allows to describe the interrupt the phy is connected
to.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 141571e2ec11..501782e233b3 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -15,6 +15,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
@@ -391,6 +392,7 @@ struct rx_status_t {
 struct netdata_local {
 	struct platform_device	*pdev;
 	struct net_device	*ndev;
+	struct device_node	*phy_node;
 	spinlock_t		lock;
 	void __iomem		*net_base;
 	u32			msg_enable;
@@ -749,22 +751,26 @@ static void lpc_handle_link_change(struct net_device *ndev)
 static int lpc_mii_probe(struct net_device *ndev)
 {
 	struct netdata_local *pldat = netdev_priv(ndev);
-	struct phy_device *phydev = phy_find_first(pldat->mii_bus);
-
-	if (!phydev) {
-		netdev_err(ndev, "no PHY found\n");
-		return -ENODEV;
-	}
+	struct phy_device *phydev;
 
 	/* Attach to the PHY */
 	if (lpc_phy_interface_mode(&pldat->pdev->dev) == PHY_INTERFACE_MODE_MII)
 		netdev_info(ndev, "using MII interface\n");
 	else
 		netdev_info(ndev, "using RMII interface\n");
+
+	if (pldat->phy_node)
+		phydev =  of_phy_find_device(pldat->phy_node);
+	else
+		phydev = phy_find_first(pldat->mii_bus);
+	if (!phydev) {
+		netdev_err(ndev, "no PHY found\n");
+		return -ENODEV;
+	}
+
 	phydev = phy_connect(ndev, phydev_name(phydev),
 			     &lpc_handle_link_change,
 			     lpc_phy_interface_mode(&pldat->pdev->dev));
-
 	if (IS_ERR(phydev)) {
 		netdev_err(ndev, "Could not attach to PHY\n");
 		return PTR_ERR(phydev);
@@ -783,6 +789,7 @@ static int lpc_mii_probe(struct net_device *ndev)
 
 static int lpc_mii_init(struct netdata_local *pldat)
 {
+	struct device_node *node;
 	int err = -ENXIO;
 
 	pldat->mii_bus = mdiobus_alloc();
@@ -812,7 +819,10 @@ static int lpc_mii_init(struct netdata_local *pldat)
 
 	platform_set_drvdata(pldat->pdev, pldat->mii_bus);
 
-	if (mdiobus_register(pldat->mii_bus))
+	node = of_get_child_by_name(pldat->pdev->dev.of_node, "mdio");
+	err = of_mdiobus_register(pldat->mii_bus, node);
+	of_node_put(node);
+	if (err)
 		goto err_out_unregister_bus;
 
 	if (lpc_mii_probe(pldat->ndev) != 0)
@@ -1345,6 +1355,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	netdev_dbg(ndev, "DMA buffer V address :0x%p\n",
 			pldat->dma_buff_base_v);
 
+	pldat->phy_node = of_parse_phandle(np, "phy-handle", 0);
+
 	/* Get MAC address from current HW setting (POR state is all zeros) */
 	__lpc_get_mac(pldat, ndev->dev_addr);
 
-- 
2.21.0

