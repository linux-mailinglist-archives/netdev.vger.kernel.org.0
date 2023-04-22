Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988E06EB8E5
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDVLs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDVLsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:48:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9111FDE;
        Sat, 22 Apr 2023 04:48:23 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBj3-00084E-29;
        Sat, 22 Apr 2023 13:48:21 +0200
Date:   Sat, 22 Apr 2023 12:48:17 +0100
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
Subject: [RFC PATCH net-next 1/8] net: phy: realtek: rtl8221: allow to
 configure SERDES mode
Message-ID: <30e4fb909f5fac1734562c9822e5d72b5c0497cf.1682163424.git.daniel@makrotopia.org>
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

From: Alexander Couzens <lynxis@fe80.eu>

The rtl8221 supports multiple SERDES modes:
- SGMII
- 2500base-x
- HiSGMII

Further it supports rate adaption on SERDES links to allow
slow ethernet speeds (10/100/1000mbit) to work on 2500base-x/HiSGMII
links without reducing the SERDES speed.

When operating without rate adapters the SERDES link will follow the
ethernet speed.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/phy/realtek.c | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7a..6389abaab6d5a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -53,6 +53,15 @@
 						 RTL8201F_ISR_LINK)
 #define RTL8201F_IER				0x13
 
+#define RTL8221B_MMD_SERDES_CTRL		MDIO_MMD_VEND1
+#define RTL8221B_MMD_PHY_CTRL			MDIO_MMD_VEND2
+#define RTL8221B_SERDES_OPTION			0x697a
+#define RTL8221B_SERDES_OPTION_MODE_MASK	GENMASK(5, 0)
+#define RTL8221B_SERDES_OPTION_MODE_2500BASEX_SGMII	0
+#define RTL8221B_SERDES_OPTION_MODE_HISGMII_SGMII	1
+#define RTL8221B_SERDES_OPTION_MODE_2500BASEX		2
+#define RTL8221B_SERDES_OPTION_MODE_HISGMII		3
+
 #define RTL8366RB_POWER_SAVE			0x15
 #define RTL8366RB_POWER_SAVE_ON			BIT(12)
 
@@ -849,6 +858,48 @@ static irqreturn_t rtl9000a_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int rtl8221b_config_init(struct phy_device *phydev)
+{
+	u16 option_mode;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_2500BASEX:
+		if (!phydev->is_c45) {
+			option_mode = RTL8221B_SERDES_OPTION_MODE_2500BASEX;
+			break;
+		}
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+		option_mode = RTL8221B_SERDES_OPTION_MODE_2500BASEX_SGMII;
+		break;
+	default:
+		return 0;
+	}
+
+	phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL,
+		      0x75f3, 0);
+
+	phy_modify_mmd_changed(phydev, RTL8221B_MMD_SERDES_CTRL,
+			       RTL8221B_SERDES_OPTION,
+			       RTL8221B_SERDES_OPTION_MODE_MASK, option_mode);
+	switch (option_mode) {
+	case RTL8221B_SERDES_OPTION_MODE_2500BASEX_SGMII:
+	case RTL8221B_SERDES_OPTION_MODE_2500BASEX:
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6a04, 0x0503);
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f10, 0xd455);
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f11, 0x8020);
+		break;
+	case RTL8221B_SERDES_OPTION_MODE_HISGMII_SGMII:
+	case RTL8221B_SERDES_OPTION_MODE_HISGMII:
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6a04, 0x0503);
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f10, 0xd433);
+		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f11, 0x8020);
+		break;
+	}
+
+	return 0;
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -1001,6 +1052,7 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc849),
 		.name           = "RTL8221B-VB-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
+		.config_init    = rtl8221b_config_init,
 		.config_aneg    = rtl822x_config_aneg,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
@@ -1012,6 +1064,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8221B-VM-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.config_init    = rtl8221b_config_init,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
-- 
2.40.0

