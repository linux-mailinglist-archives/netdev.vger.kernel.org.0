Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163B1C4919
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEDVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 17:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727903AbgEDVcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 17:32:03 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1850AC061A0F;
        Mon,  4 May 2020 14:32:03 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0023323E8A;
        Mon,  4 May 2020 23:31:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588627919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+2vClgmqktJR4JRY6SeJrOincYU8j3t+OLW9KGZ8XeE=;
        b=vk+t7rwWVyhj915f/LfKMRCHoSvoXkCmPJx9tNlADboWGP334D9MG2xDJ7Gy39IjFqYIkb
        O2ADK82LhpN4Z+ATJ3XcCWGqo0/h2t3tCvei+evAlOc2yOiWnJeEl8ocekBueLAoar36iy
        AKeHzzoPFvIaOenB9YI6McCCysalCXE=
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
Subject: [PATCH net-next v2 2/3] net: phy: bcm54140: use phy_package_shared
Date:   Mon,  4 May 2020 23:31:35 +0200
Message-Id: <20200504213136.26458-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504213136.26458-1-michael@walle.cc>
References: <20200504213136.26458-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 0023323E8A
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.863];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,bootlin.com,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new phy_package_shared common storage to ease the package
initialization and to access the global registers.

Signed-off-by: Michael Walle <michael@walle.cc>
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

