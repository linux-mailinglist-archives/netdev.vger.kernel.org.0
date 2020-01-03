Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E9812F7D7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgACLwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:52:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40044 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgACLwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:52:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wrkXre3RB2c8lZLiX8hGv7W7WHPd2d4YoiltVqbubhc=; b=pgeyOYxYuKlLsIjyVBTnCfRoAj
        wdnIO575LrpqHG7l5U4r+1l4nXWVmLgFJ9FmPr00DUETKLipOilYyFCNhQgtnBaoZhXHetrX8O6cF
        2mmlQPq8yqlwlSmF8AphM9LGRJsgwjMa1V7Ei+e4k3NjK05i+LXBvvOKRMW1B9TvUMWqiD8Fefz8C
        MKXJzYl8CD2xJdrrp/7ejVqHj+DCJ/CixyGTI8M4/Pi7Ggh16CaKAiHkdFWg/E9pvMzXqvLycYSSS
        b9ELWDSOLbyJWWJB4KOVDANdvbL80ACbXYEdldwS9wkMHxFgX5Q3Fc2wXTsdxAOXfPjW5uXgWwXmR
        0xqKFL1A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49140 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inLVF-0001sG-Ao; Fri, 03 Jan 2020 11:52:29 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inLVE-0006gO-0S; Fri, 03 Jan 2020 11:52:28 +0000
In-Reply-To: <20200103115125.GC25745@shell.armlinux.org.uk>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: switch to using PHY_INTERFACE_MODE_10GBASER
 rather than 10GKR
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1inLVE-0006gO-0S@rmk-PC.armlinux.org.uk>
Date:   Fri, 03 Jan 2020 11:52:28 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch network drivers, phy drivers, and SFP/phylink over to use the
more correct 10GBASE-R, rather than 10GBASE-KR. 10GBASE-KR is backplane
ethernet, which is 10GBASE-R with autonegotiation on top, which our
current usage on the affected platforms does not have.

The only remaining user of PHY_INTERFACE_MODE_10GKR is the Aquantia
PHY, which has a separate mode for 10GBASE-KR.

For Marvell mvpp2, we detect 10GBASE-KR, and rewrite it to 10GBASE-R
for compatibility with existing DT - this is the only network driver
at present that makes use of PHY_INTERFACE_MODE_10GKR.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++++-----
 drivers/net/phy/aquantia_main.c               |  7 +++++--
 drivers/net/phy/bcm84881.c                    |  4 ++--
 drivers/net/phy/marvell10g.c                  | 11 +++++-----
 drivers/net/phy/phylink.c                     |  1 +
 drivers/net/phy/sfp-bus.c                     |  2 +-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c  | 20 +++++++++----------
 7 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cd32c7196a7f..5113dae11906 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1114,7 +1114,7 @@ mvpp2_shared_interrupt_mask_unmask(struct mvpp2_port *port, bool mask)
 /* Port configuration routines */
 static bool mvpp2_is_xlg(phy_interface_t interface)
 {
-	return interface == PHY_INTERFACE_MODE_10GKR ||
+	return interface == PHY_INTERFACE_MODE_10GBASER ||
 	       interface == PHY_INTERFACE_MODE_XAUI;
 }
 
@@ -1200,7 +1200,7 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	case PHY_INTERFACE_MODE_2500BASEX:
 		mvpp22_gop_init_sgmii(port);
 		break;
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 		if (port->gop_id != 0)
 			goto invalid_conf;
 		mvpp22_gop_init_10gkr(port);
@@ -1649,7 +1649,7 @@ static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port)
 	xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
 
 	switch (port->phy_interface) {
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 		val = readl(mpcs + MVPP22_MPCS_CLK_RESET);
 		val |= MAC_CLK_RESET_MAC | MAC_CLK_RESET_SD_RX |
 		       MAC_CLK_RESET_SD_TX;
@@ -4758,7 +4758,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 
 	/* Invalid combinations */
 	switch (state->interface) {
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
 		if (port->gop_id != 0)
 			goto empty_set;
@@ -4780,7 +4780,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_NA:
 		if (port->gop_id == 0) {
@@ -5247,6 +5247,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		goto err_free_netdev;
 	}
 
+	if (phy_mode == PHY_INTERFACE_MODE_10GKR)
+		phy_mode = PHY_INTERFACE_MODE_10GBASER;
+
 	if (port_node) {
 		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
 		if (IS_ERR(comphy)) {
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 975789d9349d..31927b2c7d5a 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -358,9 +358,11 @@ static int aqr107_read_status(struct phy_device *phydev)
 
 	switch (FIELD_GET(MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK, val)) {
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
-	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
@@ -493,7 +495,8 @@ static int aqr107_config_init(struct phy_device *phydev)
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
+	    phydev->interface != PHY_INTERFACE_MODE_10GKR &&
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
 		return -ENODEV;
 
 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index db59911b9b3c..14d55a77eb28 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -53,7 +53,7 @@ static int bcm84881_config_init(struct phy_device *phydev)
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_2500BASEX:
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 		break;
 	default:
 		return -ENODEV;
@@ -218,7 +218,7 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	if (mode == 1 || mode == 2)
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 	else if (mode == 3)
-		phydev->interface = PHY_INTERFACE_MODE_10GKR;
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 	else if (mode == 4)
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 	switch (mode & 7) {
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 512f27b0b5cd..64c9f3bba2cd 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -216,7 +216,7 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	sfp_parse_support(phydev->sfp_bus, id, support);
 	iface = sfp_select_interface(phydev->sfp_bus, support);
 
-	if (iface != PHY_INTERFACE_MODE_10GKR) {
+	if (iface != PHY_INTERFACE_MODE_10GBASER) {
 		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
 		return -EINVAL;
 	}
@@ -304,7 +304,7 @@ static int mv3310_config_init(struct phy_device *phydev)
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
 	    phydev->interface != PHY_INTERFACE_MODE_RXAUI &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
 		return -ENODEV;
 
 	return 0;
@@ -386,16 +386,17 @@ static void mv3310_update_interface(struct phy_device *phydev)
 {
 	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
 	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	     phydev->interface == PHY_INTERFACE_MODE_10GKR) && phydev->link) {
+	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
+	    phydev->link) {
 		/* The PHY automatically switches its serdes interface (and
-		 * active PHYXS instance) between Cisco SGMII, 10GBase-KR and
+		 * active PHYXS instance) between Cisco SGMII, 10GBase-R and
 		 * 2500BaseX modes according to the speed.  Florian suggests
 		 * setting phydev->interface to communicate this to the MAC.
 		 * Only do this if we are already in one of the above modes.
 		 */
 		switch (phydev->speed) {
 		case SPEED_10000:
-			phydev->interface = PHY_INTERFACE_MODE_10GKR;
+			phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 			break;
 		case SPEED_2500:
 			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ba9468cc8e13..cf9ce4b67826 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -298,6 +298,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			break;
 
 		case PHY_INTERFACE_MODE_10GKR:
+		case PHY_INTERFACE_MODE_10GBASER:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 06e6429b8b71..d949ea7b4f8c 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -373,7 +373,7 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	    phylink_test(link_modes, 10000baseLRM_Full) ||
 	    phylink_test(link_modes, 10000baseER_Full) ||
 	    phylink_test(link_modes, 10000baseT_Full))
-		return PHY_INTERFACE_MODE_10GKR;
+		return PHY_INTERFACE_MODE_10GBASER;
 
 	if (phylink_test(link_modes, 2500baseX_Full))
 		return PHY_INTERFACE_MODE_2500BASEX;
diff --git a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
index e3b87c94aaf6..e41367f36ee1 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
@@ -221,7 +221,7 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_HS_SGMII),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_RXAUI, 0x1, COMPHY_FW_MODE_RXAUI),
-	ETH_CONF(2, 0, PHY_INTERFACE_MODE_10GKR, 0x1, COMPHY_FW_MODE_XFI),
+	ETH_CONF(2, 0, PHY_INTERFACE_MODE_10GBASER, 0x1, COMPHY_FW_MODE_XFI),
 	GEN_CONF(2, 0, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
 	GEN_CONF(2, 0, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
 	GEN_CONF(2, 0, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
@@ -235,14 +235,14 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	/* lane 4 */
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_SGMII, 0x2, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_HS_SGMII),
-	ETH_CONF(4, 0, PHY_INTERFACE_MODE_10GKR, 0x2, COMPHY_FW_MODE_XFI),
+	ETH_CONF(4, 0, PHY_INTERFACE_MODE_10GBASER, 0x2, COMPHY_FW_MODE_XFI),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(4, 0, PHY_MODE_USB_DEVICE_SS, COMPHY_FW_MODE_USB3D),
 	GEN_CONF(4, 1, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
 	GEN_CONF(4, 1, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_2500BASEX, -1, COMPHY_FW_MODE_HS_SGMII),
-	ETH_CONF(4, 1, PHY_INTERFACE_MODE_10GKR, -1, COMPHY_FW_MODE_XFI),
+	ETH_CONF(4, 1, PHY_INTERFACE_MODE_10GBASER, -1, COMPHY_FW_MODE_XFI),
 	/* lane 5 */
 	ETH_CONF(5, 1, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(5, 1, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
@@ -342,7 +342,7 @@ static int mvebu_comphy_ethernet_init_reset(struct mvebu_comphy_lane *lane)
 		 MVEBU_COMPHY_SERDES_CFG0_RXAUI_MODE);
 
 	switch (lane->submode) {
-	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
 		val |= MVEBU_COMPHY_SERDES_CFG0_GEN_RX(0xe) |
 		       MVEBU_COMPHY_SERDES_CFG0_GEN_TX(0xe);
 		break;
@@ -417,7 +417,7 @@ static int mvebu_comphy_ethernet_init_reset(struct mvebu_comphy_lane *lane)
 	/* refclk selection */
 	val = readl(priv->base + MVEBU_COMPHY_MISC_CTRL0(lane->id));
 	val &= ~MVEBU_COMPHY_MISC_CTRL0_REFCLK_SEL;
-	if (lane->submode == PHY_INTERFACE_MODE_10GKR)
+	if (lane->submode == PHY_INTERFACE_MODE_10GBASER)
 		val |= MVEBU_COMPHY_MISC_CTRL0_ICP_FORCE;
 	writel(val, priv->base + MVEBU_COMPHY_MISC_CTRL0(lane->id));
 
@@ -564,7 +564,7 @@ static int mvebu_comphy_set_mode_rxaui(struct phy *phy)
 	return mvebu_comphy_init_plls(lane);
 }
 
-static int mvebu_comphy_set_mode_10gkr(struct phy *phy)
+static int mvebu_comphy_set_mode_10gbaser(struct phy *phy)
 {
 	struct mvebu_comphy_lane *lane = phy_get_drvdata(phy);
 	struct mvebu_comphy_priv *priv = lane->priv;
@@ -735,8 +735,8 @@ static int mvebu_comphy_power_on_legacy(struct phy *phy)
 	case PHY_INTERFACE_MODE_RXAUI:
 		ret = mvebu_comphy_set_mode_rxaui(phy);
 		break;
-	case PHY_INTERFACE_MODE_10GKR:
-		ret = mvebu_comphy_set_mode_10gkr(phy);
+	case PHY_INTERFACE_MODE_10GBASER:
+		ret = mvebu_comphy_set_mode_10gbaser(phy);
 		break;
 	default:
 		return -ENOTSUPP;
@@ -782,8 +782,8 @@ static int mvebu_comphy_power_on(struct phy *phy)
 				lane->id);
 			fw_speed = COMPHY_FW_SPEED_3125;
 			break;
-		case PHY_INTERFACE_MODE_10GKR:
-			dev_dbg(priv->dev, "set lane %d to 10G-KR mode\n",
+		case PHY_INTERFACE_MODE_10GBASER:
+			dev_dbg(priv->dev, "set lane %d to 10GBASE-R mode\n",
 				lane->id);
 			fw_speed = COMPHY_FW_SPEED_103125;
 			break;
-- 
2.20.1

