Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80852BBAF
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfE0VWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:22:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50762 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbfE0VWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A536F200C5B;
        Mon, 27 May 2019 23:22:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 977F1200C59;
        Mon, 27 May 2019 23:22:48 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 030032061C;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 02/11] net: phy: Guard against the presence of a netdev
Date:   Tue, 28 May 2019 00:21:58 +0300
Message-Id: <1558992127-26008-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A prerequisite for PHYLIB to work in the absence of a struct net_device
is to not access pointers to it.

Changes are needed in the following areas:

 - Printing: In some places netdev_err was replaced with phydev_err.

 - Incrementing reference count to the parent MDIO bus driver: If there
   is no net device, then the reference count should definitely be
   incremented since there is no chance that it was an Ethernet driver
   who registered the MDIO bus.

 - Sysfs links are not created in case there is no attached_dev.

 - No netif_carrier_off is done if there is no attached_dev.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8fd1bf37718b..da3bf3f70d63 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1138,6 +1138,9 @@ static void phy_sysfs_create_links(struct phy_device *phydev)
 	struct net_device *dev = phydev->attached_dev;
 	int err;
 
+	if (!dev)
+		return;
+
 	err = sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
 				"attached_dev");
 	if (err)
@@ -1176,9 +1179,9 @@ static void phy_sysfs_create_links(struct phy_device *phydev)
 int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 		      u32 flags, phy_interface_t interface)
 {
-	struct module *ndev_owner = dev->dev.parent->driver->owner;
 	struct mii_bus *bus = phydev->mdio.bus;
 	struct device *d = &phydev->mdio.dev;
+	struct module *ndev_owner = NULL;
 	bool using_genphy = false;
 	int err;
 
@@ -1187,8 +1190,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	 * our own module->refcnt here, otherwise we would not be able to
 	 * unload later on.
 	 */
+	if (dev)
+		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
-		dev_err(&dev->dev, "failed to get the bus module\n");
+		phydev_err(phydev, "failed to get the bus module\n");
 		return -EIO;
 	}
 
@@ -1207,7 +1212,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	}
 
 	if (!try_module_get(d->driver->owner)) {
-		dev_err(&dev->dev, "failed to get the device driver module\n");
+		phydev_err(phydev, "failed to get the device driver module\n");
 		err = -EIO;
 		goto error_put_device;
 	}
@@ -1228,8 +1233,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	}
 
 	phydev->phy_link_change = phy_link_change;
-	phydev->attached_dev = dev;
-	dev->phydev = phydev;
+	if (dev) {
+		phydev->attached_dev = dev;
+		dev->phydev = phydev;
+	}
 
 	/* Some Ethernet drivers try to connect to a PHY device before
 	 * calling register_netdevice() -> netdev_register_kobject() and
@@ -1252,7 +1259,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	/* Initial carrier state is off as the phy is about to be
 	 * (re)initialized.
 	 */
-	netif_carrier_off(phydev->attached_dev);
+	if (dev)
+		netif_carrier_off(phydev->attached_dev);
 
 	/* Do initial configuration here, now that
 	 * we have certain key parameters
@@ -1358,16 +1366,19 @@ EXPORT_SYMBOL_GPL(phy_driver_is_genphy_10g);
 void phy_detach(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
-	struct module *ndev_owner = dev->dev.parent->driver->owner;
+	struct module *ndev_owner = NULL;
 	struct mii_bus *bus;
 
 	if (phydev->sysfs_links) {
-		sysfs_remove_link(&dev->dev.kobj, "phydev");
+		if (dev)
+			sysfs_remove_link(&dev->dev.kobj, "phydev");
 		sysfs_remove_link(&phydev->mdio.dev.kobj, "attached_dev");
 	}
 	phy_suspend(phydev);
-	phydev->attached_dev->phydev = NULL;
-	phydev->attached_dev = NULL;
+	if (dev) {
+		phydev->attached_dev->phydev = NULL;
+		phydev->attached_dev = NULL;
+	}
 	phydev->phylink = NULL;
 
 	phy_led_triggers_unregister(phydev);
@@ -1390,6 +1401,8 @@ void phy_detach(struct phy_device *phydev)
 	bus = phydev->mdio.bus;
 
 	put_device(&phydev->mdio.dev);
+	if (dev)
+		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);
 
-- 
2.21.0

