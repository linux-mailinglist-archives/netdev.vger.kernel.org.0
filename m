Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665584550D8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbhKQWy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241488AbhKQWyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:54:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC3C461BCF;
        Wed, 17 Nov 2021 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637189470;
        bh=GyCY08s0Brp5i/xVSdvC3xXsX4BvDeO4gHsWneeh5cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5bsagck3HXz6EptfxjY6t13DRb0ZLML5sNtFHersJoYS8nWQ/BUlVGPIThie7Xkr
         WoR+UnATcmu6sTJBVN/c4mlop6adUQ+etdgH50ldmKG2Qf5VUCUM+2Z5EzeO+Jc4lL
         EJLALjm2gNvB8y2x0vNXeNFby/7u1abx3rnHs+ioJbucKOhAEEM6PF95egEg2ao0Hz
         g+5/0Mkn/Nqa2SnN64Q3z9kz4R48px3aG3JKTywNhmSwEGcMI0RfOvkxOun0jGr52h
         NKnchGqSBoqM6vbcYws0Tmwl+7VpDbiPZXjs9qZuLyJzM5puwRmoCb49g3tzQ+kXXl
         TbR14HsR+4HQg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 8/8] net: phy: marvell10g: select host interface configuration
Date:   Wed, 17 Nov 2021 23:50:50 +0100
Message-Id: <20211117225050.18395-9-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117225050.18395-1-kabel@kernel.org>
References: <20211117225050.18395-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Select the host interface configuration according to the capabilities of
the host.

This allows the kernel to:
- support SFP modules with 88X33X0 or 88E21X0 inside them
- switch interface modes when the PHY is used with the mvpp2 MAC
  (e.g. on MacchiatoBIN)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[ rebase, updated, also added support for 88E21X0 ]
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 120 +++++++++++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 0cb9b4ef09c7..94bea1bade6f 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -96,6 +96,11 @@ enum {
 	MV_PCS_PORT_INFO_NPORTS_MASK	= 0x0380,
 	MV_PCS_PORT_INFO_NPORTS_SHIFT	= 7,
 
+	/* SerDes reinitialization 88E21X0 */
+	MV_AN_21X0_SERDES_CTRL2	= 0x800f,
+	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
+	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -140,6 +145,8 @@ struct mv3310_chip {
 	bool (*has_downshift)(struct phy_device *phydev);
 	void (*init_supported_interfaces)(unsigned long *mask);
 	int (*get_mactype)(struct phy_device *phydev);
+	int (*set_mactype)(struct phy_device *phydev, int mactype);
+	int (*select_mactype)(unsigned long *interfaces);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
 
 #ifdef CONFIG_HWMON
@@ -593,6 +600,49 @@ static int mv2110_get_mactype(struct phy_device *phydev)
 	return mactype & MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
 }
 
+static int mv2110_set_mactype(struct phy_device *phydev, int mactype)
+{
+	int err, val;
+
+	mactype &= MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
+	err = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL,
+			     MV_PMA_21X0_PORT_CTRL_SWRST |
+			     MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK,
+			     MV_PMA_21X0_PORT_CTRL_SWRST | mactype);
+	if (err)
+		return err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
+			       MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS |
+			       MV_AN_21X0_SERDES_CTRL2_RUN_INIT);
+	if (err)
+		return err;
+
+	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_AN,
+					MV_AN_21X0_SERDES_CTRL2, val,
+					!(val &
+					  MV_AN_21X0_SERDES_CTRL2_RUN_INIT),
+					5000, 100000, true);
+	if (err)
+		return err;
+
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
+				  MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS);
+}
+
+static int mv2110_select_mactype(unsigned long *interfaces)
+{
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 !test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
+	else
+		return -1;
+}
+
 static int mv3310_get_mactype(struct phy_device *phydev)
 {
 	int mactype;
@@ -604,6 +654,46 @@ static int mv3310_get_mactype(struct phy_device *phydev)
 	return mactype & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
 }
 
+static int mv3310_set_mactype(struct phy_device *phydev, int mactype)
+{
+	int ret;
+
+	mactype &= MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				     MV_V2_33X0_PORT_CTRL_MACTYPE_MASK,
+				     mactype);
+	if (ret <= 0)
+		return ret;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				MV_V2_33X0_PORT_CTRL_SWRST);
+}
+
+static int mv3310_select_mactype(unsigned long *interfaces)
+{
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
+		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
+		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
+	else
+		return -1;
+}
+
 static int mv2110_init_interface(struct phy_device *phydev, int mactype)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
@@ -674,10 +764,16 @@ static int mv3310_config_init(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
 	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	int err, mactype;
 
-	/* Check that the PHY interface type is compatible */
-	if (!test_bit(phydev->interface, priv->supported_interfaces))
+	/* In case host didn't provide supported interfaces */
+	__set_bit(phydev->interface, phydev->host_interfaces);
+
+	/* Check that there is at least one compatible PHY interface type */
+	phy_interface_and(interfaces, phydev->host_interfaces,
+			  priv->supported_interfaces);
+	if (phy_interface_empty(interfaces))
 		return -ENODEV;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
@@ -687,9 +783,15 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	mactype = chip->get_mactype(phydev);
-	if (mactype < 0)
-		return mactype;
+	mactype = chip->select_mactype(interfaces);
+	if (mactype < 0) {
+		mactype = chip->get_mactype(phydev);
+	} else {
+		phydev_info(phydev, "Changing MACTYPE to %i\n", mactype);
+		err = chip->set_mactype(phydev, mactype);
+		if (err)
+			return err;
+	}
 
 	err = chip->init_interface(phydev, mactype);
 	if (err) {
@@ -1049,6 +1151,8 @@ static const struct mv3310_chip mv3310_type = {
 	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
+	.set_mactype = mv3310_set_mactype,
+	.select_mactype = mv3310_select_mactype,
 	.init_interface = mv3310_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1060,6 +1164,8 @@ static const struct mv3310_chip mv3340_type = {
 	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3340_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
+	.set_mactype = mv3310_set_mactype,
+	.select_mactype = mv3310_select_mactype,
 	.init_interface = mv3340_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1070,6 +1176,8 @@ static const struct mv3310_chip mv3340_type = {
 static const struct mv3310_chip mv2110_type = {
 	.init_supported_interfaces = mv2110_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
+	.set_mactype = mv2110_set_mactype,
+	.select_mactype = mv2110_select_mactype,
 	.init_interface = mv2110_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1080,6 +1188,8 @@ static const struct mv3310_chip mv2110_type = {
 static const struct mv3310_chip mv2111_type = {
 	.init_supported_interfaces = mv2111_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
+	.set_mactype = mv2110_set_mactype,
+	.select_mactype = mv2110_select_mactype,
 	.init_interface = mv2110_init_interface,
 
 #ifdef CONFIG_HWMON
-- 
2.32.0

