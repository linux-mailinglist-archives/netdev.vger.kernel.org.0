Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA556EB8F3
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDVLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDVLuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:50:20 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2262139;
        Sat, 22 Apr 2023 04:49:54 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBkT-00086z-1p;
        Sat, 22 Apr 2023 13:49:49 +0200
Date:   Sat, 22 Apr 2023 12:49:45 +0100
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
Subject: [RFC PATCH net-next 8/8] net: phy: realtek: setup ALDPS on RTL822x
Message-ID: <19f9db255a1ca4afaab5701a6a829697c48ef0e1.1682163424.git.daniel@makrotopia.org>
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

Setup Link Down Power Saving Mode according the DTS property
just like for RTL821x 1GE PHYs.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index de73049037891..a2324918c42db 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -62,6 +62,10 @@
 #define RTL8221B_SERDES_OPTION_MODE_2500BASEX		2
 #define RTL8221B_SERDES_OPTION_MODE_HISGMII		3
 
+#define RTL8221B_PHYCR1				0xa430
+#define RTL8221B_PHYCR1_ALDPS_EN		BIT(2)
+#define RTL8221B_PHYCR1_ALDPS_XTAL_OFF_EN	BIT(12)
+
 #define RTL8366RB_POWER_SAVE			0x15
 #define RTL8366RB_POWER_SAVE_ON			BIT(12)
 
@@ -744,6 +748,25 @@ static int rtl8226_match_phy_device(struct phy_device *phydev)
 	       rtlgen_supports_2_5gbps(phydev);
 }
 
+static int rtl822x_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int val;
+
+	val = phy_read_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, RTL8221B_PHYCR1);
+	if (val < 0)
+		return val;
+
+	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
+		val |= RTL8221B_PHYCR1_ALDPS_EN | RTL8221B_PHYCR1_ALDPS_XTAL_OFF_EN;
+	else
+		val &= ~(RTL8221B_PHYCR1_ALDPS_EN | RTL8221B_PHYCR1_ALDPS_XTAL_OFF_EN);
+
+	phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, RTL8221B_PHYCR1, val);
+
+	return 0;
+}
+
 static int rtlgen_resume(struct phy_device *phydev)
 {
 	int ret = genphy_resume(phydev);
@@ -1029,6 +1052,7 @@ static struct phy_driver realtek_drvs[] = {
 		.match_phy_device = rtl8226_match_phy_device,
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
+		.probe          = rtl822x_probe,
 		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
@@ -1042,6 +1066,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
+		.probe          = rtl822x_probe,
 		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
@@ -1055,6 +1080,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8226-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.probe          = rtl822x_probe,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
@@ -1066,6 +1092,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.probe          = rtl822x_probe,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
@@ -1078,6 +1105,7 @@ static struct phy_driver realtek_drvs[] = {
 		.get_features   = rtl822x_get_features,
 		.config_init    = rtl8221b_config_init,
 		.config_aneg    = rtl822x_config_aneg,
+		.probe          = rtl822x_probe,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
@@ -1090,6 +1118,7 @@ static struct phy_driver realtek_drvs[] = {
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
 		.config_init    = rtl8221b_config_init,
+		.probe          = rtl822x_probe,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
-- 
2.40.0

