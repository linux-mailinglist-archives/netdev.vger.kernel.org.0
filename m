Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75864233019
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgG3KOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:14:03 -0400
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:19537 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgG3KOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:14:02 -0400
X-Greylist: delayed 684 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2020 06:14:01 EDT
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [192.168.231.130]) by mgwkm02.jp.fujitsu.com with smtp
         id 2fbe_258b_68736195_7b85_4dec_89a5_b6c345b7e1ee;
        Thu, 30 Jul 2020 19:02:35 +0900
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 756B3AC00B4;
        Thu, 30 Jul 2020 19:02:34 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1006)
        id 5159B1FF2DC; Thu, 30 Jul 2020 19:02:34 +0900 (JST)
From:   Yuusuke Ashizuka <ashiduka@fujitsu.com>
To:     sergei.shtylyov@gmail.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        ashiduka@fujitsu.com
Subject: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Date:   Thu, 30 Jul 2020 19:01:51 +0900
Message-Id: <20200730100151.7490-1-ashiduka@fujitsu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730035649.5940-1-ashiduka@fujitsu.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
X-TM-AS-GCONF: 00
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ravb is a module driver, but I cannot rmmod it after insmod it.
ravb does mdio_init() at the time of probe, and module->refcnt is incremented
by alloc_mdio_bitbang() called after that.
Therefore, even if ifup is not performed, the driver is in use and rmmod cannot
be performed.

$ lsmod
Module                  Size  Used by
ravb                   40960  1
$ rmmod ravb
rmmod: ERROR: Module ravb is in use

Fixed to execute mdio_init() at open and free_mdio() at close, thereby rmmod is
possible in the ifdown state.

Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
---
Changes in v2:
 - Fix build error

 drivers/net/ethernet/renesas/ravb_main.c | 110 +++++++++++------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 99f7aae102ce..df89d09b253e 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1342,6 +1342,51 @@ static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
 	return error;
 }
 
+/* MDIO bus init function */
+static int ravb_mdio_init(struct ravb_private *priv)
+{
+	struct platform_device *pdev = priv->pdev;
+	struct device *dev = &pdev->dev;
+	int error;
+
+	/* Bitbang init */
+	priv->mdiobb.ops = &bb_ops;
+
+	/* MII controller setting */
+	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
+	if (!priv->mii_bus)
+		return -ENOMEM;
+
+	/* Hook up MII support for ethtool */
+	priv->mii_bus->name = "ravb_mii";
+	priv->mii_bus->parent = dev;
+	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		 pdev->name, pdev->id);
+
+	/* Register MDIO bus */
+	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
+	if (error)
+		goto out_free_bus;
+
+	return 0;
+
+out_free_bus:
+	free_mdio_bitbang(priv->mii_bus);
+	return error;
+}
+
+/* MDIO bus release function */
+static int ravb_mdio_release(struct ravb_private *priv)
+{
+	/* Unregister mdio bus */
+	mdiobus_unregister(priv->mii_bus);
+
+	/* Free bitbang info */
+	free_mdio_bitbang(priv->mii_bus);
+
+	return 0;
+}
+
 /* Network device open function for Ethernet AVB */
 static int ravb_open(struct net_device *ndev)
 {
@@ -1350,6 +1395,13 @@ static int ravb_open(struct net_device *ndev)
 	struct device *dev = &pdev->dev;
 	int error;
 
+	/* MDIO bus init */
+	error = ravb_mdio_init(priv);
+	if (error) {
+		netdev_err(ndev, "failed to initialize MDIO\n");
+		return error;
+	}
+
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
@@ -1427,6 +1479,7 @@ static int ravb_open(struct net_device *ndev)
 out_napi_off:
 	napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
 	return error;
 }
 
@@ -1736,6 +1789,8 @@ static int ravb_close(struct net_device *ndev)
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
+	ravb_mdio_release(priv);
+
 	return 0;
 }
 
@@ -1887,51 +1942,6 @@ static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_set_features	= ravb_set_features,
 };
 
-/* MDIO bus init function */
-static int ravb_mdio_init(struct ravb_private *priv)
-{
-	struct platform_device *pdev = priv->pdev;
-	struct device *dev = &pdev->dev;
-	int error;
-
-	/* Bitbang init */
-	priv->mdiobb.ops = &bb_ops;
-
-	/* MII controller setting */
-	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
-	if (!priv->mii_bus)
-		return -ENOMEM;
-
-	/* Hook up MII support for ethtool */
-	priv->mii_bus->name = "ravb_mii";
-	priv->mii_bus->parent = dev;
-	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
-		 pdev->name, pdev->id);
-
-	/* Register MDIO bus */
-	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
-	if (error)
-		goto out_free_bus;
-
-	return 0;
-
-out_free_bus:
-	free_mdio_bitbang(priv->mii_bus);
-	return error;
-}
-
-/* MDIO bus release function */
-static int ravb_mdio_release(struct ravb_private *priv)
-{
-	/* Unregister mdio bus */
-	mdiobus_unregister(priv->mii_bus);
-
-	/* Free bitbang info */
-	free_mdio_bitbang(priv->mii_bus);
-
-	return 0;
-}
-
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
@@ -2174,13 +2184,6 @@ static int ravb_probe(struct platform_device *pdev)
 		eth_hw_addr_random(ndev);
 	}
 
-	/* MDIO bus init */
-	error = ravb_mdio_init(priv);
-	if (error) {
-		dev_err(&pdev->dev, "failed to initialize MDIO\n");
-		goto out_dma_free;
-	}
-
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
 	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
@@ -2202,8 +2205,6 @@ static int ravb_probe(struct platform_device *pdev)
 out_napi_del:
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
-out_dma_free:
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 
@@ -2235,7 +2236,6 @@ static int ravb_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);
-- 
2.17.1

