Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FDE3575DA
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356147AbhDGUYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356092AbhDGUXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8397D61184;
        Wed,  7 Apr 2021 20:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827025;
        bh=v1rvm3GmcERUJsNcXwqjjTt4y6wZDUDZDnGRj8Ktdm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+SkEMcMOBjZBoUuVFIYcXJE6sCpMBPeXlS4AeSdbuXu8q1H0477x0zag0XAztWpQ
         TwmijqCKC57+C30AG8T+vezDbqOvWNfVZay553msrLbJ4GR6bw6gU8eO5ozUU4c0Eh
         DjecYgbh0O0MJ73N9y9myv02ZGAW5OPXPgmpAs92W65u5wI7e+FR51v1JnZuaTdv8y
         sRwyTJfhARYSr0mExOfIpMyt7wXizdt8O8ePu6vV7fIHipgiF4CjYj0dBpnYkwAkTW
         nXOXfFIFeyKc/M6DBqumS5N3D+AuZrFCguohSkalYu1i6tObJtsk5zovF4ooCHvRNB
         V59koJMHNTMbA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 07/16] net: phy: marvell10g: support all rate matching modes
Date:   Wed,  7 Apr 2021 22:22:45 +0200
Message-Id: <20210407202254.29417-8-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for all rate matching modes for 88X3310 (currently only
10gbase-r is supported, but xaui and rxaui can also be used).

Add support for rate matching for 88E2110 (on 88E2110 the MACTYPE
register is at a different place).

Currently rate matching mode is selected by strapping pins (by setting
the MACTYPE register). There is work in progress to enable this driver
to deduce the best MACTYPE from the knowledge of which interface modes
are supported by the host, but this work is not finished yet.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 103 +++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 556c9b43860e..b0b3fccac65f 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -108,14 +108,25 @@ enum {
 	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
 };
 
+struct mv3310_chip {
+	int (*get_mactype)(struct phy_device *phydev);
+	int (*init_interface)(struct phy_device *phydev, int mactype);
+};
+
 struct mv3310_priv {
 	u32 firmware_ver;
 	bool rate_match;
+	phy_interface_t const_interface;
 
 	struct device *hwmon_dev;
 	char *hwmon_name;
 };
 
+static const struct mv3310_chip *to_mv3310_chip(struct phy_device *phydev)
+{
+	return phydev->drv->driver_data;
+}
+
 #ifdef CONFIG_HWMON
 static umode_t mv3310_hwmon_is_visible(const void *data,
 				       enum hwmon_sensor_types type,
@@ -470,11 +481,67 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 		MV_PHY_ALASKA_NBT_QUIRK_MASK) == MV_PHY_ALASKA_NBT_QUIRK_REV;
 }
 
-static int mv3310_config_init(struct phy_device *phydev)
+static int mv2110_get_mactype(struct phy_device *phydev)
+{
+	int mactype;
+
+	mactype = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL);
+	if (mactype < 0)
+		return mactype;
+
+	return mactype & MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
+}
+
+static int mv3310_get_mactype(struct phy_device *phydev)
+{
+	int mactype;
+
+	mactype = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
+	if (mactype < 0)
+		return mactype;
+
+	return mactype & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
+}
+
+static int mv2110_init_interface(struct phy_device *phydev, int mactype)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
-	int err;
-	int val;
+
+	priv->rate_match = false;
+
+	if (mactype == MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
+		priv->rate_match = true;
+		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
+	}
+
+	return 0;
+}
+
+static int mv3310_init_interface(struct phy_device *phydev, int mactype)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+
+	priv->rate_match = false;
+
+	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH ||
+	    mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH ||
+	    mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
+		priv->rate_match = true;
+
+	if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_10GBASER;
+	else if (mactype == MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_RXAUI;
+	else if (mactype == MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH)
+		priv->const_interface = PHY_INTERFACE_MODE_XAUI;
+
+	return 0;
+}
+
+static int mv3310_config_init(struct phy_device *phydev)
+{
+	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
+	int err, mactype;
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
@@ -493,11 +560,13 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
-	if (val < 0)
-		return val;
-	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH);
+	mactype = chip->get_mactype(phydev);
+	if (mactype < 0)
+		return mactype;
+
+	err = chip->init_interface(phydev, mactype);
+	if (err)
+		return err;
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
@@ -607,12 +676,12 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 
-	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
-	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
+	/* In all of the "* with Rate Matching" modes the PHY interface is fixed
+	 * at 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
 	 */
 	if (priv->rate_match) {
-		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		phydev->interface = priv->const_interface;
 		return;
 	}
 
@@ -788,11 +857,22 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static const struct mv3310_chip mv3310_type = {
+	.get_mactype = mv3310_get_mactype,
+	.init_interface = mv3310_init_interface,
+};
+
+static const struct mv3310_chip mv2110_type = {
+	.get_mactype = mv2110_get_mactype,
+	.init_interface = mv2110_init_interface,
+};
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
 		.name		= "mv88x3310",
+		.driver_data	= &mv3310_type,
 		.get_features	= mv3310_get_features,
 		.config_init	= mv3310_config_init,
 		.probe		= mv3310_probe,
@@ -810,6 +890,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.phy_id		= MARVELL_PHY_ID_88E2110,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
 		.name		= "mv88x2110",
+		.driver_data	= &mv2110_type,
 		.probe		= mv3310_probe,
 		.suspend	= mv3310_suspend,
 		.resume		= mv3310_resume,
-- 
2.26.2

