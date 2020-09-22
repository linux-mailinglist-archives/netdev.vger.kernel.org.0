Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686D1273BDB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgIVH3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbgIVH3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:29:42 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4279EC0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:29:42 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id WvVc2300C4C55Sk01vVcpx; Tue, 22 Sep 2020 09:29:39 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kKck4-0005Uv-8l; Tue, 22 Sep 2020 09:29:36 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kKck4-0000Zg-6j; Tue, 22 Sep 2020 09:29:36 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org
Subject: [PATCH net] Revert "ravb: Fixed to be able to unload modules"
Date:   Tue, 22 Sep 2020 09:29:31 +0200
Message-Id: <20200922072931.2148-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1838d6c62f57836639bd3d83e7855e0ee4f6defc.

This commit moved the ravb_mdio_init() call (and thus the
of_mdiobus_register() call) from the ravb_probe() to the ravb_open()
call.  This causes a regression during system resume (s2idle/s2ram), as
new PHY devices cannot be bound while suspended.

During boot, the Micrel PHY is detected like this:

    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=228)
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

During system suspend, (A) defer_all_probes is set to true, and (B)
usermodehelper_disabled is set to UMH_DISABLED, to avoid drivers being
probed while suspended.

  A. If CONFIG_MODULES=n, phy_device_register() calling device_add()
     merely adds the device, but does not probe it yet, as
     really_probe() returns early due to defer_all_probes being set:

       dpm_resume+0x128/0x4f8
	 device_resume+0xcc/0x1b0
	   dpm_run_callback+0x74/0x340
	     ravb_resume+0x190/0x1b8
	       ravb_open+0x84/0x770
		 of_mdiobus_register+0x1e0/0x468
		   of_mdiobus_register_phy+0x1b8/0x250
		     of_mdiobus_phy_device_register+0x178/0x1e8
		       phy_device_register+0x114/0x1b8
			 device_add+0x3d4/0x798
			   bus_probe_device+0x98/0xa0
			     device_initial_probe+0x10/0x18
			       __device_attach+0xe4/0x140
				 bus_for_each_drv+0x64/0xc8
				   __device_attach_driver+0xb8/0xe0
				     driver_probe_device.part.11+0xc4/0xd8
				       really_probe+0x32c/0x3b8

     Later, phy_attach_direct() notices no PHY driver has been bound,
     and falls back to the Generic PHY, leading to degraded operation:

       Generic PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=POLL)
       ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

  B. If CONFIG_MODULES=y, request_module() returns early with -EBUSY due
     to UMH_DISABLED, and MDIO initialization fails completely:

       mdio_bus e6800000.ethernet-ffffffff:00: error -16 loading PHY driver module for ID 0x00221622
       ravb e6800000.ethernet eth0: failed to initialize MDIO
       PM: dpm_run_callback(): ravb_resume+0x0/0x1b8 returns -16
       PM: Device e6800000.ethernet failed to resume: error -16

     Ignoring -EBUSY in phy_request_driver_module(), like was done for
     -ENOENT in commit 21e194425abd65b5 ("net: phy: fix issue with loading
     PHY driver w/o initramfs"), would makes it fall back to the Generic
     PHY, like in the CONFIG_MODULES=n case.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
---
Commit 1838d6c62f578366 ("ravb: Fixed to be able to unload modules") was
already backported to stable v4.4, v4.9, v4.14, v4.19, v5.4, and v5.8),
and thus needs to be reverted there, too.
---
 drivers/net/ethernet/renesas/ravb_main.c | 110 +++++++++++------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5082c16bf9c060b2..9c4df4ede0111eae 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1339,51 +1339,6 @@ static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
 	return error;
 }
 
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
 /* Network device open function for Ethernet AVB */
 static int ravb_open(struct net_device *ndev)
 {
@@ -1392,13 +1347,6 @@ static int ravb_open(struct net_device *ndev)
 	struct device *dev = &pdev->dev;
 	int error;
 
-	/* MDIO bus init */
-	error = ravb_mdio_init(priv);
-	if (error) {
-		netdev_err(ndev, "failed to initialize MDIO\n");
-		return error;
-	}
-
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
@@ -1476,7 +1424,6 @@ static int ravb_open(struct net_device *ndev)
 out_napi_off:
 	napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
 	return error;
 }
 
@@ -1786,8 +1733,6 @@ static int ravb_close(struct net_device *ndev)
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
-	ravb_mdio_release(priv);
-
 	return 0;
 }
 
@@ -1939,6 +1884,51 @@ static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_set_features	= ravb_set_features,
 };
 
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
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
@@ -2213,6 +2203,13 @@ static int ravb_probe(struct platform_device *pdev)
 		eth_hw_addr_random(ndev);
 	}
 
+	/* MDIO bus init */
+	error = ravb_mdio_init(priv);
+	if (error) {
+		dev_err(&pdev->dev, "failed to initialize MDIO\n");
+		goto out_dma_free;
+	}
+
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
 	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
@@ -2234,6 +2231,8 @@ static int ravb_probe(struct platform_device *pdev)
 out_napi_del:
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
+out_dma_free:
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 
@@ -2265,6 +2264,7 @@ static int ravb_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);
-- 
2.17.1

