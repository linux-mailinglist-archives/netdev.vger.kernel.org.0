Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112E468696E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjBAPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjBAO7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4593F6B9B3
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002rW-0C; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZV-001w15-Se; Wed, 01 Feb 2023 15:58:48 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hVi-Ct; Wed, 01 Feb 2023 15:58:47 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v4 08/23] net: phy: migrate phy_init_eee() to genphy_c45_eee_is_active()
Date:   Wed,  1 Feb 2023 15:58:30 +0100
Message-Id: <20230201145845.2312060-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201145845.2312060-1-o.rempel@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce code duplicated by migrating phy_init_eee() to
genphy_c45_eee_is_active().

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy.c | 89 +++++++------------------------------------
 1 file changed, 14 insertions(+), 75 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 41cfb24c48c1..36533746630e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1457,30 +1457,6 @@ void phy_mac_interrupt(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_mac_interrupt);
 
-static void mmd_eee_adv_to_linkmode(unsigned long *advertising, u16 eee_adv)
-{
-	linkmode_zero(advertising);
-
-	if (eee_adv & MDIO_EEE_100TX)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				 advertising);
-	if (eee_adv & MDIO_EEE_1000T)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				 advertising);
-	if (eee_adv & MDIO_EEE_10GT)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-				 advertising);
-	if (eee_adv & MDIO_EEE_1000KX)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-				 advertising);
-	if (eee_adv & MDIO_EEE_10GKX4)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-				 advertising);
-	if (eee_adv & MDIO_EEE_10GKR)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-				 advertising);
-}
-
 /**
  * phy_init_eee - init and check the EEE feature
  * @phydev: target phy_device struct
@@ -1493,62 +1469,25 @@ static void mmd_eee_adv_to_linkmode(unsigned long *advertising, u16 eee_adv)
  */
 int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 {
+	int ret;
+
 	if (!phydev->drv)
 		return -EIO;
 
-	/* According to 802.3az,the EEE is supported only in full duplex-mode.
-	 */
-	if (phydev->duplex == DUPLEX_FULL) {
-		__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
-		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp);
-		__ETHTOOL_DECLARE_LINK_MODE_MASK(adv);
-		int eee_lp, eee_cap, eee_adv;
-		int status;
-		u32 cap;
-
-		/* Read phy status to properly get the right settings */
-		status = phy_read_status(phydev);
-		if (status)
-			return status;
-
-		/* First check if the EEE ability is supported */
-		eee_cap = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
-		if (eee_cap <= 0)
-			goto eee_exit_err;
-
-		cap = mmd_eee_cap_to_ethtool_sup_t(eee_cap);
-		if (!cap)
-			goto eee_exit_err;
-
-		/* Check which link settings negotiated and verify it in
-		 * the EEE advertising registers.
-		 */
-		eee_lp = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
-		if (eee_lp <= 0)
-			goto eee_exit_err;
-
-		eee_adv = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
-		if (eee_adv <= 0)
-			goto eee_exit_err;
-
-		mmd_eee_adv_to_linkmode(adv, eee_adv);
-		mmd_eee_adv_to_linkmode(lp, eee_lp);
-		linkmode_and(common, adv, lp);
-
-		if (!phy_check_valid(phydev->speed, phydev->duplex, common))
-			goto eee_exit_err;
+	ret = genphy_c45_eee_is_active(phydev, NULL, NULL, NULL);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EPROTONOSUPPORT;
 
-		if (clk_stop_enable)
-			/* Configure the PHY to stop receiving xMII
-			 * clock while it is signaling LPI.
-			 */
-			phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
-					 MDIO_PCS_CTRL1_CLKSTOP_EN);
+	if (clk_stop_enable)
+		/* Configure the PHY to stop receiving xMII
+		 * clock while it is signaling LPI.
+		 */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
+				       MDIO_PCS_CTRL1_CLKSTOP_EN);
 
-		return 0; /* EEE supported */
-	}
-eee_exit_err:
-	return -EPROTONOSUPPORT;
+	return ret < 0 ? ret : 0;
 }
 EXPORT_SYMBOL(phy_init_eee);
 
-- 
2.30.2

