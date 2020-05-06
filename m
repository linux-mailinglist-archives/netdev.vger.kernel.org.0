Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229001C7360
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgEFOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729288AbgEFOzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:55:02 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5EEC061A0F;
        Wed,  6 May 2020 07:55:02 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A17F022F00;
        Wed,  6 May 2020 16:54:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588776899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v65YpQjXv8ixYvbqkF+UtAu+AM5zVM0FCCZEgkI+UNo=;
        b=HC/cbNONyO/xVJqk1BDUw/yaP4Kv1hDjj4ZwrTCljmPo+dC6Z1DkfFzy/Q2y+9fSU+LJVA
        AIlcENtV19IXYfoTT6I4gpRAZ8ml4KDlt9R1OKQQCqPN9JwQHzIUgaqaWjv+qehpGNKvrq
        apas/ZQJOMgRtMRtOBoVw24CkE5JQXc=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 2/3] net: phy: bcm54140: use phy_package_shared
Date:   Wed,  6 May 2020 16:53:14 +0200
Message-Id: <20200506145315.13967-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200506145315.13967-1-michael@walle.cc>
References: <20200506145315.13967-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new phy_package_shared common storage to ease the package
initialization and to access the global registers.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm54140.c | 57 ++++++++------------------------------
 1 file changed, 11 insertions(+), 46 deletions(-)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 400d7c3c405a..9ef37a3bc2bb 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -132,7 +132,6 @@ struct bcm54140_priv {
 	int port;
 	int base_addr;
 #if IS_ENABLED(CONFIG_HWMON)
-	bool pkg_init;
 	/* protect the alarm bits */
 	struct mutex alarm_lock;
 	u16 alarm;
@@ -407,36 +406,6 @@ static int bcm54140_enable_monitoring(struct phy_device *phydev)
 	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_MON_CTRL, mask, set);
 }
 
-/* Check if one PHY has already done the init of the parts common to all PHYs
- * in the Quad PHY package.
- */
-static bool bcm54140_is_pkg_init(struct phy_device *phydev)
-{
-	struct bcm54140_priv *priv = phydev->priv;
-	struct mii_bus *bus = phydev->mdio.bus;
-	int base_addr = priv->base_addr;
-	struct phy_device *phy;
-	int i;
-
-	/* Quad PHY */
-	for (i = 0; i < 4; i++) {
-		phy = mdiobus_get_phy(bus, base_addr + i);
-		if (!phy)
-			continue;
-
-		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
-		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
-			continue;
-
-		priv = phy->priv;
-
-		if (priv && priv->pkg_init)
-			return true;
-	}
-
-	return false;
-}
-
 static int bcm54140_probe_once(struct phy_device *phydev)
 {
 	struct device *hwmon;
@@ -457,38 +426,34 @@ static int bcm54140_probe_once(struct phy_device *phydev)
 
 static int bcm54140_base_read_rdb(struct phy_device *phydev, u16 rdb)
 {
-	struct bcm54140_priv *priv = phydev->priv;
-	struct mii_bus *bus = phydev->mdio.bus;
 	int ret;
 
-	mutex_lock(&bus->mdio_lock);
-	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_ADDR, rdb);
+	phy_lock_mdio_bus(phydev);
+	ret = __phy_package_write(phydev, MII_BCM54XX_RDB_ADDR, rdb);
 	if (ret < 0)
 		goto out;
 
-	ret = __mdiobus_read(bus, priv->base_addr, MII_BCM54XX_RDB_DATA);
+	ret = __phy_package_read(phydev, MII_BCM54XX_RDB_DATA);
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 	return ret;
 }
 
 static int bcm54140_base_write_rdb(struct phy_device *phydev,
 				   u16 rdb, u16 val)
 {
-	struct bcm54140_priv *priv = phydev->priv;
-	struct mii_bus *bus = phydev->mdio.bus;
 	int ret;
 
-	mutex_lock(&bus->mdio_lock);
-	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_ADDR, rdb);
+	phy_lock_mdio_bus(phydev);
+	ret = __phy_package_write(phydev, MII_BCM54XX_RDB_ADDR, rdb);
 	if (ret < 0)
 		goto out;
 
-	ret = __mdiobus_write(bus, priv->base_addr, MII_BCM54XX_RDB_DATA, val);
+	ret = __phy_package_write(phydev, MII_BCM54XX_RDB_DATA, val);
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 	return ret;
 }
 
@@ -618,16 +583,16 @@ static int bcm54140_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	devm_phy_package_join(&phydev->mdio.dev, phydev, priv->base_addr, 0);
+
 #if IS_ENABLED(CONFIG_HWMON)
 	mutex_init(&priv->alarm_lock);
 
-	if (!bcm54140_is_pkg_init(phydev)) {
+	if (phy_package_init_once(phydev)) {
 		ret = bcm54140_probe_once(phydev);
 		if (ret)
 			return ret;
 	}
-
-	priv->pkg_init = true;
 #endif
 
 	phydev_dbg(phydev, "probed (port %d, base PHY address %d)\n",
-- 
2.20.1

