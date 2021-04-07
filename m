Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E243575DE
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356134AbhDGUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356074AbhDGUYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B727861184;
        Wed,  7 Apr 2021 20:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827031;
        bh=73osR7QFEQrPF5ItVECP08mtVAZVW7tuqBnie1Tz9zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWUj1fePDjUQu4XmFxI+JGlFbHD3oAGCaoCvnkeXHiNrDyPE878V9onoyKxpVp6CE
         m7FDCOfb2++kXbyEV+R7+hg15/U8H5HnF+6CCXQyeP/wLv6msG0bhU8IByutu+wO0o
         MXz1YHJAA9oTVdz5OKtJ8bGrkSc/9YNA+pHc6LPiawpNAPEpNf7VqaQxkS9Z5WJNUz
         DTi7m0Oi3hNhwNnA4Ke7fuPKDXPfGF5LTxVxrMESyGwV8jxgAC6qxRly2TTeYh3mxZ
         l1sck8PLOZAkzhJoEXxvuZynokpmIeQu8uDo+Kpnl8CEEl2IKjUt9zIkeaU9Rvrk88
         0Szk1tqF4w6ZA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 11/16] net: phy: marvell10g: add separate structure for 88X3340
Date:   Wed,  7 Apr 2021 22:22:49 +0200
Message-Id: <20210407202254.29417-12-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
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
 drivers/net/phy/marvell10g.c | 58 ++++++++++++++++++++++++++++++++++--
 include/linux/marvell_phy.h  |  6 +++-
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 2dc1317e601e..f74dfd993d8b 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -557,6 +557,21 @@ static int mv3310_init_interface(struct phy_device *phydev, int mactype)
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
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
@@ -884,6 +899,16 @@ static void mv3310_init_supported_interfaces(unsigned long *mask)
 	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
 }
 
+static void mv3340_init_supported_interfaces(unsigned long *mask)
+{
+	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
+	__set_bit(PHY_INTERFACE_MODE_5GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_RXAUI, mask);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
+}
+
 static void mv2110_init_supported_interfaces(unsigned long *mask)
 {
 	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
@@ -903,6 +928,16 @@ static const struct mv3310_chip mv3310_type = {
 #endif
 };
 
+static const struct mv3310_chip mv3340_type = {
+	.init_supported_interfaces = mv3340_init_supported_interfaces,
+	.get_mactype = mv3310_get_mactype,
+	.init_interface = mv3340_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv3310_hwmon_read_temp_reg,
+#endif
+};
+
 static const struct mv3310_chip mv2110_type = {
 	.init_supported_interfaces = mv2110_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
@@ -916,7 +951,7 @@ static const struct mv3310_chip mv2110_type = {
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
-		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
 		.name		= "mv88x3310",
 		.driver_data	= &mv3310_type,
 		.get_features	= mv3310_get_features,
@@ -932,6 +967,24 @@ static struct phy_driver mv3310_drivers[] = {
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
@@ -954,7 +1007,8 @@ static struct phy_driver mv3310_drivers[] = {
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

