Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E61686950
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjBAO7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjBAO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADD46B986
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:05 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002s6-Sa; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-001w2B-Ng; Wed, 01 Feb 2023 15:58:51 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hXt-Ko; Wed, 01 Feb 2023 15:58:47 +0100
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
Subject: [PATCH net-next v4 23/23] net: mdio: drop EEE ethtool helpers in favor to linkmode variants
Date:   Wed,  1 Feb 2023 15:58:45 +0100
Message-Id: <20230201145845.2312060-24-o.rempel@pengutronix.de>
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

IEEE 802.3 specification provides more EEE capable link modes as this helpers
will be able to handle. So, remove them in favor of:
mii_eee_100_10000_adv_mod_linkmode_t
linkmode_adv_to_mii_eee_100_10000_adv_t

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/mdio.h | 83 --------------------------------------------
 1 file changed, 83 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index fcd5492e4993..492ec2de24ac 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -205,89 +205,6 @@ mdio45_ethtool_ksettings_get(const struct mdio_if_info *mdio,
 extern int mdio_mii_ioctl(const struct mdio_if_info *mdio,
 			  struct mii_ioctl_data *mii_data, int cmd);
 
-/**
- * mmd_eee_cap_to_ethtool_sup_t
- * @eee_cap: value of the MMD EEE Capability register
- *
- * A small helper function that translates MMD EEE Capability (3.20) bits
- * to ethtool supported settings.
- */
-static inline u32 mmd_eee_cap_to_ethtool_sup_t(u16 eee_cap)
-{
-	u32 supported = 0;
-
-	if (eee_cap & MDIO_EEE_100TX)
-		supported |= SUPPORTED_100baseT_Full;
-	if (eee_cap & MDIO_EEE_1000T)
-		supported |= SUPPORTED_1000baseT_Full;
-	if (eee_cap & MDIO_EEE_10GT)
-		supported |= SUPPORTED_10000baseT_Full;
-	if (eee_cap & MDIO_EEE_1000KX)
-		supported |= SUPPORTED_1000baseKX_Full;
-	if (eee_cap & MDIO_EEE_10GKX4)
-		supported |= SUPPORTED_10000baseKX4_Full;
-	if (eee_cap & MDIO_EEE_10GKR)
-		supported |= SUPPORTED_10000baseKR_Full;
-
-	return supported;
-}
-
-/**
- * mmd_eee_adv_to_ethtool_adv_t
- * @eee_adv: value of the MMD EEE Advertisement/Link Partner Ability registers
- *
- * A small helper function that translates the MMD EEE Advertisment (7.60)
- * and MMD EEE Link Partner Ability (7.61) bits to ethtool advertisement
- * settings.
- */
-static inline u32 mmd_eee_adv_to_ethtool_adv_t(u16 eee_adv)
-{
-	u32 adv = 0;
-
-	if (eee_adv & MDIO_EEE_100TX)
-		adv |= ADVERTISED_100baseT_Full;
-	if (eee_adv & MDIO_EEE_1000T)
-		adv |= ADVERTISED_1000baseT_Full;
-	if (eee_adv & MDIO_EEE_10GT)
-		adv |= ADVERTISED_10000baseT_Full;
-	if (eee_adv & MDIO_EEE_1000KX)
-		adv |= ADVERTISED_1000baseKX_Full;
-	if (eee_adv & MDIO_EEE_10GKX4)
-		adv |= ADVERTISED_10000baseKX4_Full;
-	if (eee_adv & MDIO_EEE_10GKR)
-		adv |= ADVERTISED_10000baseKR_Full;
-
-	return adv;
-}
-
-/**
- * ethtool_adv_to_mmd_eee_adv_t
- * @adv: the ethtool advertisement settings
- *
- * A small helper function that translates ethtool advertisement settings
- * to EEE advertisements for the MMD EEE Advertisement (7.60) and
- * MMD EEE Link Partner Ability (7.61) registers.
- */
-static inline u16 ethtool_adv_to_mmd_eee_adv_t(u32 adv)
-{
-	u16 reg = 0;
-
-	if (adv & ADVERTISED_100baseT_Full)
-		reg |= MDIO_EEE_100TX;
-	if (adv & ADVERTISED_1000baseT_Full)
-		reg |= MDIO_EEE_1000T;
-	if (adv & ADVERTISED_10000baseT_Full)
-		reg |= MDIO_EEE_10GT;
-	if (adv & ADVERTISED_1000baseKX_Full)
-		reg |= MDIO_EEE_1000KX;
-	if (adv & ADVERTISED_10000baseKX4_Full)
-		reg |= MDIO_EEE_10GKX4;
-	if (adv & ADVERTISED_10000baseKR_Full)
-		reg |= MDIO_EEE_10GKR;
-
-	return reg;
-}
-
 /**
  * linkmode_adv_to_mii_10gbt_adv_t
  * @advertising: the linkmode advertisement settings
-- 
2.30.2

