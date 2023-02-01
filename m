Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0216568695A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjBAPAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjBAO7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE8E6B991
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002rp-6Q; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-001w21-Du; Wed, 01 Feb 2023 15:58:51 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hXj-KI; Wed, 01 Feb 2023 15:58:47 +0100
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
Subject: [PATCH net-next v4 22/23] net: usb: ax88179_178a: replace EEE ethtool helpers to linkmode variants
Date:   Wed,  1 Feb 2023 15:58:44 +0100
Message-Id: <20230201145845.2312060-23-o.rempel@pengutronix.de>
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

Replace EEE ethtool helpers with linkmode variants. This will
reduce similar code snippets and prepare ethtool EEE interface to linkmode
migration.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/ax88179_178a.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index aff39bf3161d..7e8b5f174184 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -652,6 +652,9 @@ static int ax88179_set_link_ksettings(struct net_device *net,
 static int
 ax88179_ethtool_get_eee(struct usbnet *dev, struct ethtool_eee *data)
 {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_able) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_lp) = {};
 	int val;
 
 	/* Get Supported EEE */
@@ -659,21 +662,24 @@ ax88179_ethtool_get_eee(struct usbnet *dev, struct ethtool_eee *data)
 					    MDIO_MMD_PCS);
 	if (val < 0)
 		return val;
-	data->supported = mmd_eee_cap_to_ethtool_sup_t(val);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_able, val);
+	ethtool_convert_link_mode_to_legacy_u32(&data->supported, lm_able);
 
 	/* Get advertisement EEE */
 	val = ax88179_phy_read_mmd_indirect(dev, MDIO_AN_EEE_ADV,
 					    MDIO_MMD_AN);
 	if (val < 0)
 		return val;
-	data->advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_adv, val);
+	ethtool_convert_link_mode_to_legacy_u32(&data->advertised, lm_adv);
 
 	/* Get LP advertisement EEE */
 	val = ax88179_phy_read_mmd_indirect(dev, MDIO_AN_EEE_LPABLE,
 					    MDIO_MMD_AN);
 	if (val < 0)
 		return val;
-	data->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_lp, val);
+	ethtool_convert_link_mode_to_legacy_u32(&data->lp_advertised, lm_lp);
 
 	return 0;
 }
@@ -681,7 +687,11 @@ ax88179_ethtool_get_eee(struct usbnet *dev, struct ethtool_eee *data)
 static int
 ax88179_ethtool_set_eee(struct usbnet *dev, struct ethtool_eee *data)
 {
-	u16 tmp16 = ethtool_adv_to_mmd_eee_adv_t(data->advertised);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+	u16 tmp16;
+
+	adv[0] = data->advertised;
+	tmp16 = linkmode_adv_to_mii_eee_100_10000_adv_t(adv);
 
 	return ax88179_phy_write_mmd_indirect(dev, MDIO_AN_EEE_ADV,
 					      MDIO_MMD_AN, tmp16);
@@ -706,7 +716,7 @@ static int ax88179_chk_eee(struct usbnet *dev)
 			return false;
 		}
 
-		cap = mmd_eee_cap_to_ethtool_sup_t(eee_cap);
+		cap = eee_cap & (MDIO_EEE_100TX | MDIO_EEE_1000T);
 		if (!cap) {
 			priv->eee_active = 0;
 			return false;
@@ -729,8 +739,8 @@ static int ax88179_chk_eee(struct usbnet *dev)
 			return false;
 		}
 
-		adv = mmd_eee_adv_to_ethtool_adv_t(eee_adv);
-		lp = mmd_eee_adv_to_ethtool_adv_t(eee_lp);
+		adv = eee_adv & (MDIO_EEE_100TX | MDIO_EEE_1000T);
+		lp = eee_lp & (MDIO_EEE_100TX | MDIO_EEE_1000T);
 		supported = (ecmd.speed == SPEED_1000) ?
 			     SUPPORTED_1000baseT_Full :
 			     SUPPORTED_100baseT_Full;
-- 
2.30.2

