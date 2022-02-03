Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3FE4A852A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350817AbiBCNat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350812AbiBCNas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:30:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FF5C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BoDNX+rJT9DilqrEibV8VlZnGtF6abLhxYeJWEnUr8s=; b=eaHhtZCJX2FWaKywkgzwc814Ri
        jDLu2RhY6d6CI12Z9jIQQ0gh8kjF7vHoDDzdih3BAR9EbmHDP/WEyR8iM1XUGQP3R2pyxqTyt0WU7
        Hco6YVNUa+9McZti8QA4QKjs2DTg95p03Q7YVTMjbBO/pH4lFlpjd1t4q5BZvvdu/99J7bhH3Xeq/
        JHgE6UwQf5Cq5scJDHMRROP5AZJBIxaneKqmCGOwdGmQtivrpto4N7kLa08iKbzOzzcvuvT8SdBLl
        sha2Ly1tlWTXmlKw2JpBfBfl4vmOVULgiC8cxT77xMHJSsJaw5EwTsLyk804pXqVPtHVqw5MCgT8h
        z6hc/rCQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53934 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFcCA-0002g4-P0; Thu, 03 Feb 2022 13:30:42 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFcCA-006WMo-5e; Thu, 03 Feb 2022 13:30:42 +0000
In-Reply-To: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: mv88e6xxx: populate
 supported_interfaces and mac_capabilities
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFcCA-006WMo-5e@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 13:30:42 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the
Marvell MV88E6xxx DSA switches in preparation to using these for the
validation functionality.

Patch co-authored by Marek.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org> [ fixed 6341 and 6393x ]
---
 drivers/net/dsa/mv88e6xxx/chip.c | 275 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |   2 +
 drivers/net/dsa/mv88e6xxx/port.h |   5 +
 3 files changed, 279 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1023e4549359..251f733ab83f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -692,11 +692,251 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
+}
+
+static const u8 mv88e6185_phy_interface_modes[] = {
+	[MV88E6185_PORT_STS_CMODE_GMII_FD]	 = PHY_INTERFACE_MODE_GMII,
+	[MV88E6185_PORT_STS_CMODE_MII_100_FD_PS] = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_MII_100]	 = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_MII_10]	 = PHY_INTERFACE_MODE_MII,
+	[MV88E6185_PORT_STS_CMODE_SERDES]	 = PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6185_PORT_STS_CMODE_1000BASE_X]	 = PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6185_PORT_STS_CMODE_PHY]		 = PHY_INTERFACE_MODE_SGMII,
+};
+
+static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (cmode <= ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
+	    mv88e6185_phy_interface_modes[cmode])
+		__set_bit(mv88e6185_phy_interface_modes[cmode],
+			  config->supported_interfaces);
 
-	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
-	 * to advertise both, only report advertising at 2500BaseX.
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+}
+
+static const u8 mv88e6xxx_phy_interface_modes[] = {
+	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
+	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
+	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
+	[MV88E6XXX_PORT_STS_CMODE_SGMII]	= PHY_INTERFACE_MODE_SGMII,
+	/* higher interface modes are not needed here, since ports supporting
+	 * them are writable, and so the supported interfaces are filled in the
+	 * corresponding .phylink_set_interfaces() implementation below
 	 */
-	phylink_helper_basex_speed(state);
+};
+
+static void mv88e6xxx_translate_cmode(u8 cmode, unsigned long *supported)
+{
+	if (cmode < ARRAY_SIZE(mv88e6xxx_phy_interface_modes) &&
+	    mv88e6xxx_phy_interface_modes[cmode])
+		__set_bit(mv88e6xxx_phy_interface_modes[cmode], supported);
+	else if (cmode == MV88E6XXX_PORT_STS_CMODE_RGMII)
+		phy_interface_set_rgmii(supported);
+}
+
+static void mv88e6250_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
+}
+
+static int mv88e6352_get_port4_serdes_cmode(struct mv88e6xxx_chip *chip)
+{
+	u16 reg, val;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, 4, MV88E6XXX_PORT_STS, &reg);
+	if (err)
+		return err;
+
+	/* If PHY_DETECT is zero, then we are not in auto-media mode */
+	if (!(reg & MV88E6XXX_PORT_STS_PHY_DETECT))
+		return 0xf;
+
+	val = reg & ~MV88E6XXX_PORT_STS_PHY_DETECT;
+	err = mv88e6xxx_port_write(chip, 4, MV88E6XXX_PORT_STS, val);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_read(chip, 4, MV88E6XXX_PORT_STS, &val);
+	if (err)
+		return err;
+
+	/* Restore PHY_DETECT value */
+	err = mv88e6xxx_port_write(chip, 4, MV88E6XXX_PORT_STS, reg);
+	if (err)
+		return err;
+
+	return val & MV88E6XXX_PORT_STS_CMODE_MASK;
+}
+
+static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+	int err, cmode;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+
+	/* Port 4 supports automedia if the serdes is associated with it. */
+	if (port == 4) {
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+		if (err < 0)
+			dev_err(chip->dev, "p%d: failed to read scratch\n",
+				port);
+		if (err <= 0)
+			goto unlock;
+
+		cmode = mv88e6352_get_port4_serdes_cmode(chip);
+		if (cmode < 0)
+			dev_err(chip->dev, "p%d: failed to read serdes cmode\n",
+				port);
+		else
+			mv88e6xxx_translate_cmode(cmode, supported);
+unlock:
+		mv88e6xxx_reg_unlock(chip);
+	}
+}
+
+static void mv88e6341_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	/* No ethtool bits for 200Mbps */
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+
+	/* The C_Mode field is programmable on port 5 */
+	if (port == 5) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+
+		config->mac_capabilities |= MAC_2500FD;
+	}
+}
+
+static void mv88e6390_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	/* Translate the default cmode */
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	/* No ethtool bits for 200Mbps */
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+
+	/* The C_Mode field is programmable on ports 9 and 10 */
+	if (port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+
+		config->mac_capabilities |= MAC_2500FD;
+	}
+}
+
+static void mv88e6390x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+					struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+
+	mv88e6390_phylink_get_caps(chip, port, config);
+
+	/* For the 6x90X, ports 2-7 can be in automedia mode.
+	 * (Note that 6x90 doesn't support RXAUI nor XAUI).
+	 *
+	 * Port 2 can also support 1000BASE-X in automedia mode if port 9 is
+	 * configured for 1000BASE-X, SGMII or 2500BASE-X.
+	 * Port 3-4 can also support 1000BASE-X in automedia mode if port 9 is
+	 * configured for RXAUI, 1000BASE-X, SGMII or 2500BASE-X.
+	 *
+	 * Port 5 can also support 1000BASE-X in automedia mode if port 10 is
+	 * configured for 1000BASE-X, SGMII or 2500BASE-X.
+	 * Port 6-7 can also support 1000BASE-X in automedia mode if port 10 is
+	 * configured for RXAUI, 1000BASE-X, SGMII or 2500BASE-X.
+	 *
+	 * For now, be permissive (as the old code was) and allow 1000BASE-X
+	 * on ports 2..7.
+	 */
+	if (port >= 2 && port <= 7)
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+
+	/* The C_Mode field can also be programmed for 10G speeds */
+	if (port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_XAUI, supported);
+		__set_bit(PHY_INTERFACE_MODE_RXAUI, supported);
+
+		config->mac_capabilities |= MAC_10000FD;
+	}
+}
+
+static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+					struct phylink_config *config)
+{
+	unsigned long *supported = config->supported_interfaces;
+	bool is_6191x =
+		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
+
+	mv88e6xxx_translate_cmode(chip->ports[port].cmode, supported);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+				   MAC_1000FD;
+
+	/* The C_Mode field can be programmed for ports 0, 9 and 10 */
+	if (port == 0 || port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+
+		/* 6191X supports >1G modes only on port 10 */
+		if (!is_6191x || port == 10) {
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+			__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+			/* FIXME: USXGMII is not supported yet */
+			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
+
+			config->mac_capabilities |= MAC_2500FD | MAC_5000FD |
+				MAC_10000FD;
+		}
+	}
+}
+
+static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
+			       struct phylink_config *config)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	chip->info->ops->phylink_get_caps(chip, port, config);
+
+	/* Internal ports need GMII for PHYLIB */
+	if (mv88e6xxx_phy_is_internal(ds, port))
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
@@ -3584,6 +3824,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.rmu_disable = mv88e6085_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -3618,6 +3859,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -3664,6 +3906,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.rmu_disable = mv88e6085_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -3701,6 +3944,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -3742,6 +3986,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -3806,6 +4051,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_caps = mv88e6341_phylink_get_caps,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -3848,6 +4094,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -3884,6 +4131,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -3926,6 +4174,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -3981,6 +4230,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4023,6 +4273,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -4081,6 +4332,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4120,6 +4372,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
@@ -4182,6 +4435,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_caps = mv88e6390_phylink_get_caps,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4243,6 +4497,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_caps = mv88e6390x_phylink_get_caps,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -4303,6 +4558,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6390_phylink_get_caps,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4363,6 +4619,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4403,6 +4660,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
+	.phylink_get_caps = mv88e6250_phylink_get_caps,
 	.phylink_validate = mv88e6065_phylink_validate,
 };
 
@@ -4465,6 +4723,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6390_phylink_get_caps,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4509,6 +4768,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -4551,6 +4811,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -4617,6 +4878,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_caps = mv88e6341_phylink_get_caps,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4659,6 +4921,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -4703,6 +4966,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6185_phylink_get_caps,
 	.phylink_validate = mv88e6185_phylink_validate,
 };
 
@@ -4766,6 +5030,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4831,6 +5096,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_caps = mv88e6390_phylink_get_caps,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4895,6 +5161,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6390x_phylink_get_caps,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -4959,6 +5226,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_caps = mv88e6393x_phylink_get_caps,
 	.phylink_validate = mv88e6393x_phylink_validate,
 };
 
@@ -6228,6 +6496,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.teardown		= mv88e6xxx_teardown,
 	.port_setup		= mv88e6xxx_port_setup,
 	.port_teardown		= mv88e6xxx_port_teardown,
+	.phylink_get_caps	= mv88e6xxx_get_caps,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 438cee853d07..ee1dc58b3bcb 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -610,6 +610,8 @@ struct mv88e6xxx_ops {
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
 
 	/* Phylink */
+	void (*phylink_get_caps)(struct mv88e6xxx_chip *chip, int port,
+				 struct phylink_config *config);
 	void (*phylink_validate)(struct mv88e6xxx_chip *chip, int port,
 				 unsigned long *mask,
 				 struct phylink_link_state *state);
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03382b66f800..ea6adfcfb42c 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -42,6 +42,11 @@
 #define MV88E6XXX_PORT_STS_TX_PAUSED		0x0020
 #define MV88E6XXX_PORT_STS_FLOW_CTL		0x0010
 #define MV88E6XXX_PORT_STS_CMODE_MASK		0x000f
+#define MV88E6XXX_PORT_STS_CMODE_MII_PHY	0x0001
+#define MV88E6XXX_PORT_STS_CMODE_MII		0x0002
+#define MV88E6XXX_PORT_STS_CMODE_GMII		0x0003
+#define MV88E6XXX_PORT_STS_CMODE_RMII_PHY	0x0004
+#define MV88E6XXX_PORT_STS_CMODE_RMII		0x0005
 #define MV88E6XXX_PORT_STS_CMODE_RGMII		0x0007
 #define MV88E6XXX_PORT_STS_CMODE_100BASEX	0x0008
 #define MV88E6XXX_PORT_STS_CMODE_1000BASEX	0x0009
-- 
2.30.2

