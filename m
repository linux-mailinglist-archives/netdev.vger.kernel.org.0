Return-Path: <netdev+bounces-1608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C93B6FE7D5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7E71C20E7F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585611E520;
	Wed, 10 May 2023 23:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D24F21CED
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:01:19 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200DB40EB;
	Wed, 10 May 2023 16:01:07 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pwsny-0004VH-0l;
	Wed, 10 May 2023 23:01:06 +0000
Date: Thu, 11 May 2023 00:59:12 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH net-next 6/8] net: phy: realtek: use inline functions for
 10GbE advertisement
Message-ID: <fdce4e1cfb7c975bf72257baf393b3af53266c3d.1683756691.git.daniel@makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683756691.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use existing generic inline functions to encode local advertisement
of 10GbE link modes as well as to decode link-partner advertisement.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index e6a46c4d97b1..cde61a30ac4c 100644
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
 	int val, ret = 0;
 
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
@@ -722,12 +715,7 @@ static int rtl822x_read_status(struct phy_device *phydev)
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


