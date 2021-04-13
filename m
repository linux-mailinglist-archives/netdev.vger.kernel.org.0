Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1035E7E1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhDMU7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:59:13 -0400
Received: from mail.pr-group.ru ([178.18.215.3]:59153 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232412AbhDMU7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=IceLHSRciLCsiWE8JEpawrwuHE84WPulPSs3kLGn14I=;
        b=SkxpCzNt+/Gd3mldY5KIo1a+1q76w1YOmBLPn8Z5CXmF6bL4wUjHyymTH4mQLKBf9BU2n/TcUF0Bo
         Pndc4unRhdOlGd3AYZBYWXdR/s7yzPkt9l9CHHLD4qaz5WI/xUwordu/RDnh67wi1J7tIQqnx5ziqS
         dssaszmbE16kCCdsTkYBVT3LexjFE+rNo902GnifEy64Ty8mUeP4q9CbABr1561fGupw4X9F3Iy74J
         UA/CkB93+N/xxXiYXxGlQXVlWBDDaOj1tekTCWuc9tT4+wfJLVnJtVdwpGts/bafL6b13y2YeSl46l
         QFtvLuztB4r4+CbzvUdn57mBk6ndtqw==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.223.189])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 13 Apr 2021 23:58:35 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: phy: marvell-88x2222: move read_status after config_aneg
Date:   Tue, 13 Apr 2021 23:54:51 +0300
Message-Id: <088186566508e52bf3c4e8fea568eebea023fd3a.1618347034.git.i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1618347034.git.i.bornyakov@metrotek.ru>
References: <cover.1618347034.git.i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes, just move read link status routines below
autonegotiation configuration to make future functional changes more
distinct.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 196 +++++++++++++++---------------
 1 file changed, 98 insertions(+), 98 deletions(-)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index 28fe520228a4..640b133f1371 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -86,104 +86,6 @@ static int mv2222_soft_reset(struct phy_device *phydev)
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
-static bool mv2222_link_is_operational(struct phy_device *phydev)
-{
-	struct mv2222_data *priv = phydev->priv;
-	int val;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_RX_SIGNAL_DETECT);
-	if (val < 0 || !(val & MV_RX_SIGNAL_DETECT_GLOBAL))
-		return false;
-
-	if (phydev->sfp_bus && !priv->sfp_link)
-		return false;
-
-	return true;
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
-	if (!mv2222_link_is_operational(phydev))
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
@@ -386,6 +288,104 @@ static int mv2222_aneg_done(struct phy_device *phydev)
 	return (ret & BMSR_ANEGCOMPLETE);
 }
 
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_10g(struct phy_device *phydev)
+{
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
+	}
+
+	return link;
+}
+
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_1g(struct phy_device *phydev)
+{
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
+	if (val < 0)
+		return val;
+
+	if (!(val & BMSR_LSTATUS) ||
+	    (phydev->autoneg == AUTONEG_ENABLE &&
+	     !(val & BMSR_ANEGCOMPLETE)))
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
+static bool mv2222_link_is_operational(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_RX_SIGNAL_DETECT);
+	if (val < 0 || !(val & MV_RX_SIGNAL_DETECT_GLOBAL))
+		return false;
+
+	if (phydev->sfp_bus && !priv->sfp_link)
+		return false;
+
+	return true;
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
+	if (!mv2222_link_is_operational(phydev))
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
-- 
2.26.3


