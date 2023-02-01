Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC09B686952
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjBAO70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjBAO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448F469B36
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:05 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002rj-0F; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-001w1l-12; Wed, 01 Feb 2023 15:58:51 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hXA-ID; Wed, 01 Feb 2023 15:58:47 +0100
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
Subject: [PATCH net-next v4 18/23] igb: replace EEE ethtool helpers to linkmode variants
Date:   Wed,  1 Feb 2023 15:58:40 +0100
Message-Id: <20230201145845.2312060-19-o.rempel@pengutronix.de>
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
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 23 +++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7d60da1b7bf4..f7a633f0d6a6 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -3026,6 +3026,8 @@ static int igb_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 static int igb_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp) = {};
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ret_val;
 	u16 phy_data;
@@ -3036,9 +3038,12 @@ static int igb_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 
 	edata->supported = (SUPPORTED_1000baseT_Full |
 			    SUPPORTED_100baseT_Full);
-	if (!hw->dev_spec._82575.eee_disable)
-		edata->advertised =
-			mmd_eee_adv_to_ethtool_adv_t(adapter->eee_advert);
+
+	if (!hw->dev_spec._82575.eee_disable) {
+		mii_eee_100_10000_adv_mod_linkmode_t(adv, adapter->eee_advert);
+		ethtool_convert_link_mode_to_legacy_u32(&edata->advertised,
+							adv);
+	}
 
 	/* The IPCNFG and EEER registers are not supported on I354. */
 	if (hw->mac.type == e1000_i354) {
@@ -3064,7 +3069,9 @@ static int igb_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 		if (ret_val)
 			return -ENODATA;
 
-		edata->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(phy_data);
+		mii_eee_100_10000_adv_mod_linkmode_t(lp, phy_data);
+		ethtool_convert_link_mode_to_legacy_u32(&edata->lp_advertised,
+							lp);
 		break;
 	case e1000_i354:
 	case e1000_i210:
@@ -3075,7 +3082,9 @@ static int igb_get_eee(struct net_device *netdev, struct ethtool_eee *edata)
 		if (ret_val)
 			return -ENODATA;
 
-		edata->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(phy_data);
+		mii_eee_100_10000_adv_mod_linkmode_t(lp, phy_data);
+		ethtool_convert_link_mode_to_legacy_u32(&edata->lp_advertised,
+							lp);
 
 		break;
 	default:
@@ -3105,6 +3114,7 @@ static int igb_set_eee(struct net_device *netdev,
 		       struct ethtool_eee *edata)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
 	struct e1000_hw *hw = &adapter->hw;
 	struct ethtool_eee eee_curr;
 	bool adv1g_eee = true, adv100m_eee = true;
@@ -3149,7 +3159,8 @@ static int igb_set_eee(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	adapter->eee_advert = ethtool_adv_to_mmd_eee_adv_t(edata->advertised);
+	adv[0] = edata->advertised;
+	adapter->eee_advert = linkmode_adv_to_mii_eee_100_10000_adv_t(adv);
 	if (hw->dev_spec._82575.eee_disable != !edata->eee_enabled) {
 		hw->dev_spec._82575.eee_disable = !edata->eee_enabled;
 		adapter->flags |= IGB_FLAG_EEE;
-- 
2.30.2

