Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC61A35E7E6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344276AbhDMU7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:59:17 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:59155 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhDMU7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=/aTBJVFX50k+S1wGyOU3fkdhg0U1Mrm97VtsE/Bpsqw=;
        b=cZv9dDYtt7o8UwFCZPgNEfRq9+rknxd+MyqT3V1VyMSti9f9Es15HCA8ENkfaUi9v6N2i/eb1dYeQ
         t5JdnfdqosQOvtmTtp9lHOl1TFleF04voHUZqeAILYBlGotfC6kRVZrn3JTwC4u5g+Wg1ILuZOr3Yd
         YVJkhc+kxvMdlXdcIL/ZlVt1SzQc8z+lmcOTd94Wwa+hLNdI0M5JVEKgSdcfxP51bCLuyA9T6ziYML
         B2QqVqzZtYYydC9SellyMxwpb5oNUGXkO3qLlS5gECjRdS/fq3U5uhe5VMdLfbaBD/ttXpLYsa36n2
         /e/tuiRDbcAS/IMFIJLTG0zreXpYvxQ==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 23:58:36 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/3] net: phy: marvell-88x2222: swap 1G/10G modes on autoneg
Date:   Tue, 13 Apr 2021 23:54:52 +0300
Message-Id: <8ae07fb62f1c81d3e6e016d16065f842912f40a0.1618347034.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618347034.git.i.bornyakov@metrotek.ru>
References: <cover.1618347034.git.i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting 10G without autonegotiation is invalid according to
phy_ethtool_ksettings_set(). Thus, we need to set it during
autonegotiation.

If 1G autonegotiation can't complete for quite a time, but there is
signal in line, switch line interface type to 10GBase-R, if supported,
in hope for link to be established.

And vice versa. If 10GBase-R link can't be established for quite a time,
and autonegotiation is enabled, and there is signal in line, switch line
interface type to appropriate 1G mode, i.e. 1000Base-X or SGMII, if
supported.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 117 +++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index 640b133f1371..9b9ac3ef735d 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -52,6 +52,8 @@
 #define	MV_1GBX_PHY_STAT_SPEED100	BIT(14)
 #define	MV_1GBX_PHY_STAT_SPEED1000	BIT(15)
 
+#define	AUTONEG_TIMEOUT	3
+
 struct mv2222_data {
 	phy_interface_t line_interface;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
@@ -173,6 +175,24 @@ static bool mv2222_is_1gbx_capable(struct phy_device *phydev)
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
@@ -192,7 +212,8 @@ static int mv2222_config_line(struct phy_device *phydev)
 	}
 }
 
-static int mv2222_setup_forced(struct phy_device *phydev)
+/* Switch between 1G (1000Base-X/SGMII) and 10G (10GBase-R) modes */
+static int mv2222_swap_line_type(struct phy_device *phydev)
 {
 	struct mv2222_data *priv = phydev->priv;
 	bool changed = false;
@@ -200,25 +221,23 @@ static int mv2222_setup_forced(struct phy_device *phydev)
 
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
@@ -231,6 +250,29 @@ static int mv2222_setup_forced(struct phy_device *phydev)
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
 
@@ -244,17 +286,9 @@ static int mv2222_config_aneg(struct phy_device *phydev)
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
 
@@ -291,6 +325,7 @@ static int mv2222_aneg_done(struct phy_device *phydev)
 /* Returns negative on error, 0 if link is down, 1 if link is up */
 static int mv2222_read_status_10g(struct phy_device *phydev)
 {
+	static int timeout;
 	int val, link = 0;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
@@ -304,6 +339,20 @@ static int mv2222_read_status_10g(struct phy_device *phydev)
 		phydev->autoneg = AUTONEG_DISABLE;
 		phydev->speed = SPEED_10000;
 		phydev->duplex = DUPLEX_FULL;
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
 	}
 
 	return link;
@@ -312,15 +361,31 @@ static int mv2222_read_status_10g(struct phy_device *phydev)
 /* Returns negative on error, 0 if link is down, 1 if link is up */
 static int mv2222_read_status_1g(struct phy_device *phydev)
 {
+	static int timeout;
 	int val, link = 0;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
 	if (val < 0)
 		return val;
 
-	if (!(val & BMSR_LSTATUS) ||
-	    (phydev->autoneg == AUTONEG_ENABLE &&
-	     !(val & BMSR_ANEGCOMPLETE)))
+	if (phydev->autoneg == AUTONEG_ENABLE &&
+	    !(val & BMSR_ANEGCOMPLETE)) {
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
 		return 0;
 
 	link = 1;
@@ -447,11 +512,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
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


