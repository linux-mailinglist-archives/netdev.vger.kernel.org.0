Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E028686949
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjBAO75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjBAO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A3C6AC97
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002rh-0E; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZX-001w1d-Fq; Wed, 01 Feb 2023 15:58:50 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hX1-Hg; Wed, 01 Feb 2023 15:58:47 +0100
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
Subject: [PATCH net-next v4 17/23] e1000e: replace EEE ethtool helpers to linkmode variants
Date:   Wed,  1 Feb 2023 15:58:39 +0100
Message-Id: <20230201145845.2312060-18-o.rempel@pengutronix.de>
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
 drivers/net/ethernet/intel/e1000e/ethtool.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 721f86fd5802..7285e93b34ce 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2188,6 +2188,9 @@ static int e1000_get_rxnfc(struct net_device *netdev,
 static int e1000e_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_able) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lm_lp) = {};
 	struct e1000_hw *hw = &adapter->hw;
 	u16 cap_addr, lpa_addr, pcs_stat_addr, phy_data;
 	u32 ret_val;
@@ -2222,16 +2225,19 @@ static int e1000e_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 	ret_val = e1000_read_emi_reg_locked(hw, cap_addr, &phy_data);
 	if (ret_val)
 		goto release;
-	edata->supported = mmd_eee_cap_to_ethtool_sup_t(phy_data);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_able, phy_data);
+	ethtool_convert_link_mode_to_legacy_u32(&edata->supported, lm_able);
 
 	/* EEE Advertised */
-	edata->advertised = mmd_eee_adv_to_ethtool_adv_t(adapter->eee_advert);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_adv, adapter->eee_advert);
+	ethtool_convert_link_mode_to_legacy_u32(&edata->advertised, lm_adv);
 
 	/* EEE Link Partner Advertised */
 	ret_val = e1000_read_emi_reg_locked(hw, lpa_addr, &phy_data);
 	if (ret_val)
 		goto release;
-	edata->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(phy_data);
+	mii_eee_100_10000_adv_mod_linkmode_t(lm_lp, phy_data);
+	ethtool_convert_link_mode_to_legacy_u32(&edata->lp_advertised, lm_lp);
 
 	/* EEE PCS Status */
 	ret_val = e1000_read_emi_reg_locked(hw, pcs_stat_addr, &phy_data);
@@ -2264,6 +2270,7 @@ static int e1000e_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 static int e1000e_set_eee(struct net_device *netdev, struct ethtool_eee *edata)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
 	struct e1000_hw *hw = &adapter->hw;
 	struct ethtool_eee eee_curr;
 	s32 ret_val;
@@ -2287,7 +2294,8 @@ static int e1000e_set_eee(struct net_device *netdev, struct ethtool_eee *edata)
 		return -EINVAL;
 	}
 
-	adapter->eee_advert = ethtool_adv_to_mmd_eee_adv_t(edata->advertised);
+	adv[0] = edata->advertised;
+	adapter->eee_advert = linkmode_adv_to_mii_eee_100_10000_adv_t(adv);
 
 	hw->dev_spec.ich8lan.eee_disable = !edata->eee_enabled;
 
-- 
2.30.2

