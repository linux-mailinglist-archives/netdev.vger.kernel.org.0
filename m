Return-Path: <netdev+bounces-1603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ADD6FE7C7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DA13280E38
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE3C1E518;
	Wed, 10 May 2023 22:58:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E9221CED
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 22:58:31 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B63E73;
	Wed, 10 May 2023 15:58:30 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pwslQ-0004Rm-1g;
	Wed, 10 May 2023 22:58:28 +0000
Date: Thu, 11 May 2023 00:56:12 +0200
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
Subject: [PATCH 1/8] net: phy: realtek: rtl8221: allow to configure SERDES
 mode
Message-ID: <302d982c5550f10d589735fc2e46cf27386c39f4.1683756691.git.daniel@makrotopia.org>
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
 drivers/net/phy/realtek.c | 55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..a7dd5a075135 100644
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
@@ -970,6 +1021,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
+		.config_init	= rtl8221b_config_init,
 		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
@@ -992,6 +1044,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.config_init    = rtl8221b_config_init,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
@@ -1002,6 +1055,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8221B-VB-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.config_init    = rtl8221b_config_init,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
@@ -1012,6 +1066,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name           = "RTL8221B-VM-CG 2.5Gbps PHY",
 		.get_features   = rtl822x_get_features,
 		.config_aneg    = rtl822x_config_aneg,
+		.config_init    = rtl8221b_config_init,
 		.read_status    = rtl822x_read_status,
 		.suspend        = genphy_suspend,
 		.resume         = rtlgen_resume,
-- 
2.40.0


