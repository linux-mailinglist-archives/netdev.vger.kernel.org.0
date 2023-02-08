Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8268ECEE
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjBHKc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjBHKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:32:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4E46D45
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:32:24 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkN-00047c-KL; Wed, 08 Feb 2023 11:32:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkL-003Uhp-OH; Wed, 08 Feb 2023 11:32:14 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkK-00Aa5b-VK; Wed, 08 Feb 2023 11:32:12 +0100
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
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v6 9/9] net: phy: start using genphy_c45_ethtool_get/set_eee()
Date:   Wed,  8 Feb 2023 11:32:11 +0100
Message-Id: <20230208103211.2521836-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208103211.2521836-1-o.rempel@pengutronix.de>
References: <20230208103211.2521836-1-o.rempel@pengutronix.de>
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

All preparations are done. Now we can start using new functions and remove
the old code.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 60 ++-----------------------------------------
 1 file changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 36533746630e..2f1041a7211e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1517,33 +1517,10 @@ EXPORT_SYMBOL(phy_get_eee_err);
  */
 int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 {
-	int val;
-
 	if (!phydev->drv)
 		return -EIO;
 
-	/* Get Supported EEE */
-	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
-	if (val < 0)
-		return val;
-	data->supported = mmd_eee_cap_to_ethtool_sup_t(val);
-
-	/* Get advertisement EEE */
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
-	if (val < 0)
-		return val;
-	data->advertised = mmd_eee_adv_to_ethtool_adv_t(val);
-	data->eee_enabled = !!data->advertised;
-
-	/* Get LP advertisement EEE */
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
-	if (val < 0)
-		return val;
-	data->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(val);
-
-	data->eee_active = !!(data->advertised & data->lp_advertised);
-
-	return 0;
+	return genphy_c45_ethtool_get_eee(phydev, data);
 }
 EXPORT_SYMBOL(phy_ethtool_get_eee);
 
@@ -1556,43 +1533,10 @@ EXPORT_SYMBOL(phy_ethtool_get_eee);
  */
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 {
-	int cap, old_adv, adv = 0, ret;
-
 	if (!phydev->drv)
 		return -EIO;
 
-	/* Get Supported EEE */
-	cap = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
-	if (cap < 0)
-		return cap;
-
-	old_adv = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
-	if (old_adv < 0)
-		return old_adv;
-
-	if (data->eee_enabled) {
-		adv = !data->advertised ? cap :
-		      ethtool_adv_to_mmd_eee_adv_t(data->advertised) & cap;
-		/* Mask prohibited EEE modes */
-		adv &= ~phydev->eee_broken_modes;
-	}
-
-	if (old_adv != adv) {
-		ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
-		if (ret < 0)
-			return ret;
-
-		/* Restart autonegotiation so the new modes get sent to the
-		 * link partner.
-		 */
-		if (phydev->autoneg == AUTONEG_ENABLE) {
-			ret = phy_restart_aneg(phydev);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	return 0;
+	return genphy_c45_ethtool_set_eee(phydev, data);
 }
 EXPORT_SYMBOL(phy_ethtool_set_eee);
 
-- 
2.30.2

