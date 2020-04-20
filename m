Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487AC1B1A1C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDTX0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726284AbgDTX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:26:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51026C061A10;
        Mon, 20 Apr 2020 16:26:46 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 13BB823060;
        Tue, 21 Apr 2020 01:26:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587425203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wLWOyP1I2tWnY2IR6t6FjjJdnvvvumjYh8frBI9+P8=;
        b=Eru9Vi242ap3yP5+EIiADPBdjPC8lmG3eJaiZrzgGEkzBSvQm+pgRXJ7hpJ26e1NZKS5T1
        Qd9bQgjjyrsjZQhZdR0Ju9GrzSS7gdrr9IYlx6d83a1zfZ8zLoblOLxEPLINmr6EeWws1v
        kuFuXiJXYQnh+1Jqe9+YOEKS0XaUv44=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH net-next 2/3] net: phy: bcm54140: use phy_package_shared
Date:   Tue, 21 Apr 2020 01:26:23 +0200
Message-Id: <20200420232624.9127-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200420232624.9127-1-michael@walle.cc>
References: <20200420232624.9127-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 13BB823060
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.862];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,walle.cc];
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
index aa854477e06a..97b9e1c763da 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -122,7 +122,6 @@ struct bcm54140_priv {
 	int port;
 	int base_addr;
 #if IS_ENABLED(CONFIG_HWMON)
-	bool pkg_init;
 	/* protect the alarm bits */
 	struct mutex alarm_lock;
 	u16 alarm;
@@ -395,36 +394,6 @@ static int bcm54140_enable_monitoring(struct phy_device *phydev)
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
@@ -445,38 +414,34 @@ static int bcm54140_probe_once(struct phy_device *phydev)
 
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
 
@@ -606,16 +571,16 @@ static int bcm54140_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	devm_phy_package_join(&phydev->mdio.dev, phydev, priv->base_addr);
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

