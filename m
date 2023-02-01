Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2C686942
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjBAO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjBAO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653806ACB2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:04 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002ro-6K; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-001w1z-CZ; Wed, 01 Feb 2023 15:58:51 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hXS-JG; Wed, 01 Feb 2023 15:58:47 +0100
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
Subject: [PATCH net-next v4 20/23] tg3: replace EEE ethtool helpers to linkmode variants
Date:   Wed,  1 Feb 2023 15:58:42 +0100
Message-Id: <20230201145845.2312060-21-o.rempel@pengutronix.de>
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
 drivers/net/ethernet/broadcom/tg3.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 58747292521d..a3764e360d23 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2339,6 +2339,8 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 
 static void tg3_eee_pull_config(struct tg3 *tp, struct ethtool_eee *eee)
 {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp) = {};
 	u32 val;
 	struct ethtool_eee *dest = &tp->eee;
 
@@ -2361,13 +2363,16 @@ static void tg3_eee_pull_config(struct tg3 *tp, struct ethtool_eee *eee)
 	/* Pull lp advertised settings */
 	if (tg3_phy_cl45_read(tp, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE, &val))
 		return;
-	dest->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+	mii_eee_100_10000_adv_mod_linkmode_t(lp, val);
+	ethtool_convert_link_mode_to_legacy_u32(&dest->lp_advertised, lp);
+
 
 	/* Pull advertised and eee_enabled settings */
 	if (tg3_phy_cl45_read(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, &val))
 		return;
 	dest->eee_enabled = !!val;
-	dest->advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+	mii_eee_100_10000_adv_mod_linkmode_t(adv, val);
+	ethtool_convert_link_mode_to_legacy_u32(&dest->advertised, adv);
 
 	/* Pull tx_lpi_enabled */
 	val = tr32(TG3_CPMU_EEE_MODE);
-- 
2.30.2

