Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B854302E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbiFHMXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbiFHMXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:23:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45991C9250
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:23:40 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuid-0005zS-Sp; Wed, 08 Jun 2022 14:23:27 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuid-007BL4-GG; Wed, 08 Jun 2022 14:23:26 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nyuib-003F60-Ee; Wed, 08 Jun 2022 14:23:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: phy: move common code to separate genphy_c45_aneg_done_lp_clean() function
Date:   Wed,  8 Jun 2022 14:23:21 +0200
Message-Id: <20220608122322.772950-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608122322.772950-1-o.rempel@pengutronix.de>
References: <20220608122322.772950-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already have genphy_c45_aneg_done(), so make use of it and introduce
new function to clean up variables in case aneg is not done.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 29b1df03f3e8..c67bf3060173 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -452,6 +452,28 @@ int genphy_c45_read_link(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_link);
 
+/* Read the Clause 45 AN status register to check if autoneg is complete.
+ * If not, clean link mode flags.
+ */
+static int genphy_c45_aneg_done_lp_clean(struct phy_device *phydev)
+{
+	int val;
+
+	val = genphy_c45_aneg_done(phydev);
+	/* If < 0, there is an error. If > 0 aneg is done*/
+	if (val)
+		return val;
+
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising);
+	mii_t1_adv_l_mod_linkmode_t(phydev->lp_advertising, 0);
+	mii_t1_adv_m_mod_linkmode_t(phydev->lp_advertising, 0);
+
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	return 0;
+}
+
 /* Read the Clause 45 defined BASE-T1 AN (7.513) status register to check
  * if autoneg is complete. If so read the BASE-T1 Autonegotiation
  * Advertisement registers filling in the link partner advertisement,
@@ -461,21 +483,10 @@ static int genphy_c45_baset1_read_lpa(struct phy_device *phydev)
 {
 	int val;
 
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_STAT);
-	if (val < 0)
+	val = genphy_c45_aneg_done_lp_clean(phydev);
+	if (val <= 0)
 		return val;
 
-	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising);
-		mii_t1_adv_l_mod_linkmode_t(phydev->lp_advertising, 0);
-		mii_t1_adv_m_mod_linkmode_t(phydev->lp_advertising, 0);
-
-		phydev->pause = 0;
-		phydev->asym_pause = 0;
-
-		return 0;
-	}
-
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising, 1);
 
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_L);
@@ -512,21 +523,10 @@ int genphy_c45_read_lpa(struct phy_device *phydev)
 	if (genphy_c45_baset1_able(phydev))
 		return genphy_c45_baset1_read_lpa(phydev);
 
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
-	if (val < 0)
+	val = genphy_c45_aneg_done_lp_clean(phydev);
+	if (val <= 0)
 		return val;
 
-	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				   phydev->lp_advertising);
-		mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
-		mii_adv_mod_linkmode_adv_t(phydev->lp_advertising, 0);
-		phydev->pause = 0;
-		phydev->asym_pause = 0;
-
-		return 0;
-	}
-
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising,
 			 val & MDIO_AN_STAT1_LPABLE);
 
-- 
2.30.2

