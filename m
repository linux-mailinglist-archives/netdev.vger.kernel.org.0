Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C952B35C61A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhDLMVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:21:31 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:50837 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240434AbhDLMV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=XmQZwzG+bGgfx9OYVnQAZ/LvVz36gZRVbLw6sZ6ix1E=;
        b=D58qmRFbACV/V7/Xa+Aj070y/IOT1JurPYhf/+3Gwnzv+fKU0a7KHYjG+BEaShcXjkleP0ab9fO/p
         5Q3N/Y8dpnA6vALcOCiGWcV24lvgoJwm/EU9U2fj8MpGlhkJUz+1yUE+jPdsajK9RKMuq+Z62liVEd
         +TvyKxGMAUWbGxivwgwmmdPzUwsxuqNQAmVAkAmV4/mLpgIxVcMQOTu3PoPNGPkWjSSBbJGmqe8SRU
         8VLrnV5xRXjTdWWijXqqObxZYdcYQByz5kxHHZEIZYdjBqrfwi6AZ4M1SreBKPFahZwnnYZM7QypiX
         x5czSkAR4ToKOaO9qEdwfqrxa8VvATw==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 12 Apr 2021 15:20:58 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: marvell-88x2222: swap 1G/10G modes on autoneg
Date:   Mon, 12 Apr 2021 15:17:00 +0300
Message-Id: <aa07ff108d57a2769877c560b9e4d298e7c7a7fc.1618227910.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618227910.git.i.bornyakov@metrotek.ru>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting 10G without autonegotiation is invalid according to
phy_ethtool_ksettings_set(). Thus, if autonegotiation can't complete for
quite a time, but there is signal in line, switch line interface type to
10GBase-R, if supported, in hope for link to be established. And vice
versa.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 276 ++++++++++++++++++------------
 1 file changed, 168 insertions(+), 108 deletions(-)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index fb285ac741b2..d16c81f08334 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -48,6 +48,8 @@
 #define	MV_1GBX_PHY_STAT_SPEED100	BIT(14)
 #define	MV_1GBX_PHY_STAT_SPEED1000	BIT(15)
 
+#define	AUTONEG_TIMEOUT	3
+
 struct mv2222_data {
 	phy_interface_t line_interface;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
@@ -82,89 +84,6 @@ static int mv2222_soft_reset(struct phy_device *phydev)
 					 5000, 1000000, true);
 }
 
-/* Returns negative on error, 0 if link is down, 1 if link is up */
-static int mv2222_read_status_10g(struct phy_device *phydev)
-{
-	int val, link = 0;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
-	if (val < 0)
-		return val;
-
-	if (val & MDIO_STAT1_LSTATUS) {
-		link = 1;
-
-		/* 10GBASE-R do not support auto-negotiation */
-		phydev->autoneg = AUTONEG_DISABLE;
-		phydev->speed = SPEED_10000;
-		phydev->duplex = DUPLEX_FULL;
-	}
-
-	return link;
-}
-
-/* Returns negative on error, 0 if link is down, 1 if link is up */
-static int mv2222_read_status_1g(struct phy_device *phydev)
-{
-	int val, link = 0;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
-	if (val < 0)
-		return val;
-
-	if (!(val & BMSR_LSTATUS) ||
-	    (phydev->autoneg == AUTONEG_ENABLE &&
-	     !(val & BMSR_ANEGCOMPLETE)))
-		return 0;
-
-	link = 1;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_PHY_STAT);
-	if (val < 0)
-		return val;
-
-	if (val & MV_1GBX_PHY_STAT_AN_RESOLVED) {
-		if (val & MV_1GBX_PHY_STAT_DUPLEX)
-			phydev->duplex = DUPLEX_FULL;
-		else
-			phydev->duplex = DUPLEX_HALF;
-
-		if (val & MV_1GBX_PHY_STAT_SPEED1000)
-			phydev->speed = SPEED_1000;
-		else if (val & MV_1GBX_PHY_STAT_SPEED100)
-			phydev->speed = SPEED_100;
-		else
-			phydev->speed = SPEED_10;
-	}
-
-	return link;
-}
-
-static int mv2222_read_status(struct phy_device *phydev)
-{
-	struct mv2222_data *priv = phydev->priv;
-	int link;
-
-	phydev->link = 0;
-	phydev->speed = SPEED_UNKNOWN;
-	phydev->duplex = DUPLEX_UNKNOWN;
-
-	if (!priv->sfp_link)
-		return 0;
-
-	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
-		link = mv2222_read_status_10g(phydev);
-	else
-		link = mv2222_read_status_1g(phydev);
-
-	if (link < 0)
-		return link;
-
-	phydev->link = link;
-
-	return 0;
-}
-
 static int mv2222_disable_aneg(struct phy_device *phydev)
 {
 	int ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
@@ -252,6 +171,24 @@ static bool mv2222_is_1gbx_capable(struct phy_device *phydev)
 				 priv->supported);
 }
 
+static bool mv2222_is_sgmii_capable(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+
+	return (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+				  priv->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+				  priv->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+				  priv->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+				  priv->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+				  priv->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+				  priv->supported));
+}
+
 static int mv2222_config_line(struct phy_device *phydev)
 {
 	struct mv2222_data *priv = phydev->priv;
@@ -271,7 +208,7 @@ static int mv2222_config_line(struct phy_device *phydev)
 	}
 }
 
-static int mv2222_setup_forced(struct phy_device *phydev)
+static int mv2222_swap_line_type(struct phy_device *phydev)
 {
 	struct mv2222_data *priv = phydev->priv;
 	bool changed = false;
@@ -279,25 +216,23 @@ static int mv2222_setup_forced(struct phy_device *phydev)
 
 	switch (priv->line_interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
-		if (phydev->speed == SPEED_1000 &&
-		    mv2222_is_1gbx_capable(phydev)) {
+		if (mv2222_is_1gbx_capable(phydev)) {
 			priv->line_interface = PHY_INTERFACE_MODE_1000BASEX;
 			changed = true;
 		}
 
-		break;
-	case PHY_INTERFACE_MODE_1000BASEX:
-		if (phydev->speed == SPEED_10000 &&
-		    mv2222_is_10g_capable(phydev)) {
-			priv->line_interface = PHY_INTERFACE_MODE_10GBASER;
+		if (mv2222_is_sgmii_capable(phydev)) {
+			priv->line_interface = PHY_INTERFACE_MODE_SGMII;
 			changed = true;
 		}
 
 		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
-		ret = mv2222_set_sgmii_speed(phydev);
-		if (ret < 0)
-			return ret;
+		if (mv2222_is_10g_capable(phydev)) {
+			priv->line_interface = PHY_INTERFACE_MODE_10GBASER;
+			changed = true;
+		}
 
 		break;
 	default:
@@ -310,6 +245,29 @@ static int mv2222_setup_forced(struct phy_device *phydev)
 			return ret;
 	}
 
+	return 0;
+}
+
+static int mv2222_setup_forced(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+	int ret;
+
+	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER) {
+		if (phydev->speed < SPEED_10000 &&
+		    phydev->speed != SPEED_UNKNOWN) {
+			ret = mv2222_swap_line_type(phydev);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	if (priv->line_interface == PHY_INTERFACE_MODE_SGMII) {
+		ret = mv2222_set_sgmii_speed(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	return mv2222_disable_aneg(phydev);
 }
 
@@ -323,17 +281,9 @@ static int mv2222_config_aneg(struct phy_device *phydev)
 		return 0;
 
 	if (phydev->autoneg == AUTONEG_DISABLE ||
-	    phydev->speed == SPEED_10000)
+	    priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
 		return mv2222_setup_forced(phydev);
 
-	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER &&
-	    mv2222_is_1gbx_capable(phydev)) {
-		priv->line_interface = PHY_INTERFACE_MODE_1000BASEX;
-		ret = mv2222_config_line(phydev);
-		if (ret < 0)
-			return ret;
-	}
-
 	adv = linkmode_adv_to_mii_adv_x(priv->supported,
 					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 
@@ -367,6 +317,120 @@ static int mv2222_aneg_done(struct phy_device *phydev)
 	return (ret & BMSR_ANEGCOMPLETE);
 }
 
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_10g(struct phy_device *phydev)
+{
+	static int timeout;
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_STAT1_LSTATUS) {
+		link = 1;
+
+		/* 10GBASE-R do not support auto-negotiation */
+		phydev->autoneg = AUTONEG_DISABLE;
+		phydev->speed = SPEED_10000;
+		phydev->duplex = DUPLEX_FULL;
+	} else {
+		if (phydev->autoneg == AUTONEG_ENABLE) {
+			timeout++;
+
+			if (timeout > AUTONEG_TIMEOUT) {
+				timeout = 0;
+
+				val = mv2222_swap_line_type(phydev);
+				if (val < 0)
+					return val;
+
+				return mv2222_config_aneg(phydev);
+			}
+		}
+	}
+
+	return link;
+}
+
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_1g(struct phy_device *phydev)
+{
+	static int timeout;
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
+	if (val < 0)
+		return val;
+
+	if ((phydev->autoneg == AUTONEG_ENABLE &&
+	     !(val & BMSR_ANEGCOMPLETE))) {
+		timeout++;
+
+		if (timeout > AUTONEG_TIMEOUT) {
+			timeout = 0;
+
+			val = mv2222_swap_line_type(phydev);
+			if (val < 0)
+				return val;
+
+			return mv2222_config_aneg(phydev);
+		}
+
+		return 0;
+	}
+
+	if (!(val & BMSR_LSTATUS))
+		return 0;
+
+	link = 1;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_PHY_STAT);
+	if (val < 0)
+		return val;
+
+	if (val & MV_1GBX_PHY_STAT_AN_RESOLVED) {
+		if (val & MV_1GBX_PHY_STAT_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+
+		if (val & MV_1GBX_PHY_STAT_SPEED1000)
+			phydev->speed = SPEED_1000;
+		else if (val & MV_1GBX_PHY_STAT_SPEED100)
+			phydev->speed = SPEED_100;
+		else
+			phydev->speed = SPEED_10;
+	}
+
+	return link;
+}
+
+static int mv2222_read_status(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+	int link;
+
+	phydev->link = 0;
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+
+	if (!priv->sfp_link)
+		return 0;
+
+	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
+		link = mv2222_read_status_10g(phydev);
+	else
+		link = mv2222_read_status_1g(phydev);
+
+	if (link < 0)
+		return link;
+
+	phydev->link = link;
+
+	return 0;
+}
+
 static int mv2222_resume(struct phy_device *phydev)
 {
 	return mv2222_tx_enable(phydev);
@@ -428,11 +492,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 		return ret;
 
 	if (mutex_trylock(&phydev->lock)) {
-		if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
-			ret = mv2222_setup_forced(phydev);
-		else
-			ret = mv2222_config_aneg(phydev);
-
+		ret = mv2222_config_aneg(phydev);
 		mutex_unlock(&phydev->lock);
 	}
 
-- 
2.26.3


