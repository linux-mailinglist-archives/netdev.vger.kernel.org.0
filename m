Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472F26EB8E7
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDVLsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDVLsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:48:38 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92B71FEC;
        Sat, 22 Apr 2023 04:48:33 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBjE-00084X-0q;
        Sat, 22 Apr 2023 13:48:32 +0200
Date:   Sat, 22 Apr 2023 12:48:28 +0100
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
Subject: [RFC PATCH net-next 2/8] net: phy: realtek: switch interface mode
 for RTL822x series
Message-ID: <e515f652c5bf00a0262ebb28bf9a06e77484e80b.1682163424.git.daniel@makrotopia.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

The RTL822x phy can work in Cisco SGMII and 2500BASE-X modes respectively.
Add interface automatic switching MAC-side interface mode for RTL822x
phy to match various wire speeds when using Clause-45 MDIO.

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 6389abaab6d5a..34fd86b8ecf7d 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -684,6 +684,25 @@ static int rtl822x_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, ret);
 }
 
+static void rtl822x_update_interface(struct phy_device *phydev)
+{
+	/* Automatically switch SERDES interface between
+	 * SGMII and 2500-BaseX according to speed.
+	 */
+	switch (phydev->speed) {
+	case SPEED_2500:
+		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+		break;
+	case SPEED_1000:
+	case SPEED_100:
+	case SPEED_10:
+		phydev->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	default:
+		break;
+	}
+}
+
 static int rtl822x_read_status(struct phy_device *phydev)
 {
 	int ret;
@@ -702,11 +721,14 @@ static int rtl822x_read_status(struct phy_device *phydev)
 			phydev->lp_advertising, lpadv & RTL_LPADV_2500FULL);
 	}
 
-	ret = genphy_read_status(phydev);
+	ret = rtlgen_read_status(phydev);
 	if (ret < 0)
 		return ret;
 
-	return rtlgen_get_speed(phydev);
+	if (phydev->is_c45 && phydev->link)
+		rtl822x_update_interface(phydev);
+
+	return 0;
 }
 
 static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
-- 
2.40.0

