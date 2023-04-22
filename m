Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81036EB8EF
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDVLto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDVLth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:49:37 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323C12D58;
        Sat, 22 Apr 2023 04:49:16 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBju-000863-19;
        Sat, 22 Apr 2023 13:49:14 +0200
Date:   Sat, 22 Apr 2023 12:49:10 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [RFC PATCH net-next 6/8] net: phy: realtek: use inline functions for
 10GbE advertisement
Message-ID: <9aec1a609fe9e67b43826537aab37081635292f2.1682163424.git.daniel@makrotopia.org>
References: <cover.1682163424.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1682163424.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use existing generic inline functions to encode local advertisement
of 10GbE link modes as well as to decode link-partner advertisement.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 62fb965b6d338..078f45447ddad 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -68,10 +68,6 @@
 #define RTL_SUPPORTS_5000FULL			BIT(14)
 #define RTL_SUPPORTS_2500FULL			BIT(13)
 #define RTL_SUPPORTS_10000FULL			BIT(0)
-#define RTL_ADV_2500FULL			BIT(7)
-#define RTL_LPADV_10000FULL			BIT(11)
-#define RTL_LPADV_5000FULL			BIT(6)
-#define RTL_LPADV_2500FULL			BIT(5)
 
 #define RTL9000A_GINMR				0x14
 #define RTL9000A_GINMR_LINK_STATUS		BIT(4)
@@ -669,14 +665,11 @@ static int rtl822x_config_aneg(struct phy_device *phydev)
 	int ret = 0;
 
 	if (phydev->autoneg == AUTONEG_ENABLE) {
-		u16 adv2500 = 0;
-
-		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
-				      phydev->advertising))
-			adv2500 = RTL_ADV_2500FULL;
-
 		ret = phy_modify_paged_changed(phydev, 0xa5d, 0x12,
-					       RTL_ADV_2500FULL, adv2500);
+					       MDIO_AN_10GBT_CTRL_ADV10G |
+					       MDIO_AN_10GBT_CTRL_ADV5G |
+					       MDIO_AN_10GBT_CTRL_ADV2_5G,
+			linkmode_adv_to_mii_10gbt_adv_t(phydev->advertising));
 		if (ret < 0)
 			return ret;
 	}
@@ -713,12 +706,7 @@ static int rtl822x_read_status(struct phy_device *phydev)
 		if (lpadv < 0)
 			return lpadv;
 
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-			phydev->lp_advertising, lpadv & RTL_LPADV_10000FULL);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
-			phydev->lp_advertising, lpadv & RTL_LPADV_5000FULL);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
-			phydev->lp_advertising, lpadv & RTL_LPADV_2500FULL);
+		mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, lpadv);
 	}
 
 	ret = rtlgen_read_status(phydev);
-- 
2.40.0

