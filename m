Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34B7355E9C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbhDFWMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243715AbhDFWMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86B3C613D3;
        Tue,  6 Apr 2021 22:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747126;
        bh=Oxbky1DjlPg/IjygOXE6GbsGm7VjkphnlDIUjY5SVsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kjf9rNl8drEgY2SpH5xfdDL1yIv3wYIjh3JNe2Mb2AJtyt+3oD0qOmsGhTzW3vyfG
         FgYRfLFMmGjpGLll4H5DXA1qhEEEsXSLcapBx3my75EoLK3/OltR0wTg7BM95cPHvy
         xcg8E7UiwyZfyj2frdgu36dj7XrZuDcvxCrwwo5RIe6FG+itaAqmc16EYDxMsB5KEi
         /9db4sQyHlzA3fWn64RYY+2XFfIJx9wVlFOfg/eobSiRulhRYD/y+QSO26rkYRIBWp
         HwywmxLyvOA6VyPWbbzb5Bp5hxaRUeO2HnwILly6Q4kwZVhDHTz8yLt3nAlL09rUmw
         +w8WXZmu1lXhA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 13/18] net: phy: marvell10g: add separate structure for 88X3340
Date:   Wed,  7 Apr 2021 00:11:02 +0200
Message-Id: <20210406221107.1004-14-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88X3340 contains 4 cores similar to 88X3310, but there is a
difference: it does not support xaui host mode. Instead the
corresponding MACTYPE means
  rxaui / 5gbase-r / 2500base-x / sgmii without AN

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 55 ++++++++++++++++++++++++++++++++++--
 include/linux/marvell_phy.h  |  6 +++-
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 2fd823318de8..74a91853ef46 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -553,6 +553,21 @@ static int mv3310_init_interface(struct phy_device *phydev, int mactype)
 	return 0;
 }
 
+static int mv3340_init_interface(struct phy_device *phydev, int mactype)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int err = 0;
+
+	priv->rate_match = false;
+
+	if (mactype == MV_V2_3340_PORT_CTRL_MACTYPE_RXAUI_NO_SGMII_AN)
+		priv->const_interface = PHY_INTERFACE_MODE_RXAUI;
+	else
+		err = mv3310_init_interface(phydev, mactype);
+
+	return err;
+}
+
 static int mv3310_config_init(struct phy_device *phydev)
 {
 	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
@@ -886,6 +901,23 @@ static const struct mv3310_chip mv3310_type = {
 #endif
 };
 
+static const struct mv3310_chip mv3340_type = {
+	.supported_interfaces =
+		INITIALIZE_BITMAP(PHY_INTERFACE_MODE_MAX,
+				  PHY_INTERFACE_MODE_SGMII,
+				  PHY_INTERFACE_MODE_2500BASEX,
+				  PHY_INTERFACE_MODE_5GBASER,
+				  PHY_INTERFACE_MODE_RXAUI,
+				  PHY_INTERFACE_MODE_10GBASER,
+				  PHY_INTERFACE_MODE_USXGMII),
+	.get_mactype = mv3310_get_mactype,
+	.init_interface = mv3340_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv3310_hwmon_read_temp_reg,
+#endif
+};
+
 static const struct mv3310_chip mv2110_type = {
 	.supported_interfaces =
 		INITIALIZE_BITMAP(PHY_INTERFACE_MODE_MAX,
@@ -905,7 +937,7 @@ static const struct mv3310_chip mv2110_type = {
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
-		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
 		.name		= "mv88x3310",
 		.driver_data	= &mv3310_type,
 		.get_features	= mv3310_get_features,
@@ -921,6 +953,24 @@ static struct phy_driver mv3310_drivers[] = {
 		.remove		= mv3310_remove,
 		.set_loopback	= genphy_c45_loopback,
 	},
+	{
+		.phy_id		= MARVELL_PHY_ID_88X3340,
+		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
+		.name		= "mv88x3340",
+		.driver_data	= &mv3340_type,
+		.get_features	= mv3310_get_features,
+		.config_init	= mv3310_config_init,
+		.probe		= mv3310_probe,
+		.suspend	= mv3310_suspend,
+		.resume		= mv3310_resume,
+		.config_aneg	= mv3310_config_aneg,
+		.aneg_done	= mv3310_aneg_done,
+		.read_status	= mv3310_read_status,
+		.get_tunable	= mv3310_get_tunable,
+		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
+		.set_loopback	= genphy_c45_loopback,
+	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
@@ -943,7 +993,8 @@ static struct phy_driver mv3310_drivers[] = {
 module_phy_driver(mv3310_drivers);
 
 static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
-	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_88X33X0_MASK },
+	{ MARVELL_PHY_ID_88X3340, MARVELL_PHY_ID_88X33X0_MASK },
 	{ MARVELL_PHY_ID_88E2110, MARVELL_PHY_ID_MASK },
 	{ },
 };
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 274abd5fbac3..6b11a5411082 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -22,10 +22,14 @@
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
 #define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
-#define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 #define MARVELL_PHY_ID_88X2222		0x01410f10
 
+/* PHY IDs and mask for Alaska 10G PHYs */
+#define MARVELL_PHY_ID_88X33X0_MASK	0xfffffff8
+#define MARVELL_PHY_ID_88X3310		0x002b09a0
+#define MARVELL_PHY_ID_88X3340		0x002b09a8
+
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
 
-- 
2.26.2

