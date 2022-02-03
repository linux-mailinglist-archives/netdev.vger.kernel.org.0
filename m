Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A804A852B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350821AbiBCNaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350822AbiBCNaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:30:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DB8C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pMQHLeK1uUOVuNIiZoaq/UQbND8xuWzVpiEK/G94MiM=; b=Rj4hj6rrAULg1bwZlViBEG3/Ca
        Rh3nwov9qAztVTOVPHfOd7LUbOx2H2VPMe/c9G0p6HF/cgG4hNU1OfTUzlyGqoqiEoPNMJda3/UxG
        UqJ9BMZOLmEzcSWPd52Mmf7rZA4pgBscLYqFkYkGsOC4WUT+Q+z0DR4z5VC3y2hTUtn/7tNq9qSZj
        dFwK+CoLXFWKxmxDnGZI6SnHKeWHbCBxHN1XGOpgM+0eL1/mGEbIRQ5tjmg1zso2abcDno3/RuXwI
        j/4k4U0z0IOwq+6KZUskK0oUmjdCnmd8lrUAo+2fmPGVjDEdgNBAuxfPib17Om6J8heecDGSQLNi4
        Q/THWVDA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53936 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFcCF-0002gF-T4; Thu, 03 Feb 2022 13:30:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFcCF-006WMu-9k; Thu, 03 Feb 2022 13:30:47 +0000
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
Subject: [PATCH net-next 3/4] net: dsa: mv88e6xxx: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFcCF-006WMu-9k@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 13:30:47 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the mv88e6xxx chip drivers are supplying the supported
interfaces and MAC capabilities, switch the driver to use the generic
phylink validation implementation by removing our own validation
implementations. This causes DSA to call phylink_generic_validate()
on our behalf.

Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 153 -------------------------------
 drivers/net/dsa/mv88e6xxx/chip.h |   3 -
 2 files changed, 156 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 251f733ab83f..c45e0768bccc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -570,130 +570,6 @@ static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-static void mv88e6065_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-				       unsigned long *mask,
-				       struct phylink_link_state *state)
-{
-	if (!phy_interface_mode_is_8023z(state->interface)) {
-		/* 10M and 100M are only supported in non-802.3z mode */
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
-	}
-}
-
-static void mv88e6185_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-				       unsigned long *mask,
-				       struct phylink_link_state *state)
-{
-	/* FIXME: if the port is in 1000Base-X mode, then it only supports
-	 * 1000M FD speeds.  In this case, CMODE will indicate 5.
-	 */
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	mv88e6065_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6341_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-				       unsigned long *mask,
-				       struct phylink_link_state *state)
-{
-	if (port >= 5)
-		phylink_set(mask, 2500baseX_Full);
-
-	/* No ethtool bits for 200Mbps */
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	mv88e6065_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6352_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-				       unsigned long *mask,
-				       struct phylink_link_state *state)
-{
-	/* No ethtool bits for 200Mbps */
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	mv88e6065_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6390_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-				       unsigned long *mask,
-				       struct phylink_link_state *state)
-{
-	if (port >= 9) {
-		phylink_set(mask, 2500baseX_Full);
-		phylink_set(mask, 2500baseT_Full);
-	}
-
-	/* No ethtool bits for 200Mbps */
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	mv88e6065_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6390x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-					unsigned long *mask,
-					struct phylink_link_state *state)
-{
-	if (port >= 9) {
-		phylink_set(mask, 10000baseT_Full);
-		phylink_set(mask, 10000baseKR_Full);
-	}
-
-	mv88e6390_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
-					unsigned long *mask,
-					struct phylink_link_state *state)
-{
-	bool is_6191x =
-		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6191X;
-
-	if (((port == 0 || port == 9) && !is_6191x) || port == 10) {
-		phylink_set(mask, 10000baseT_Full);
-		phylink_set(mask, 10000baseKR_Full);
-		phylink_set(mask, 10000baseCR_Full);
-		phylink_set(mask, 10000baseSR_Full);
-		phylink_set(mask, 10000baseLR_Full);
-		phylink_set(mask, 10000baseLRM_Full);
-		phylink_set(mask, 10000baseER_Full);
-		phylink_set(mask, 5000baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-		phylink_set(mask, 2500baseT_Full);
-	}
-
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	mv88e6065_phylink_validate(chip, port, mask, state);
-}
-
-static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
-			       unsigned long *supported,
-			       struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct mv88e6xxx_chip *chip = ds->priv;
-
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set_port_modes(mask);
-
-	if (chip->info->ops->phylink_validate)
-		chip->info->ops->phylink_validate(chip, port, mask, state);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static const u8 mv88e6185_phy_interface_modes[] = {
 	[MV88E6185_PORT_STS_CMODE_GMII_FD]	 = PHY_INTERFACE_MODE_GMII,
 	[MV88E6185_PORT_STS_CMODE_MII_100_FD_PS] = PHY_INTERFACE_MODE_MII,
@@ -3825,7 +3701,6 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3860,7 +3735,6 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3907,7 +3781,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3945,7 +3818,6 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3987,7 +3859,6 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6141_ops = {
@@ -4052,7 +3923,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_get_caps = mv88e6341_phylink_get_caps,
-	.phylink_validate = mv88e6341_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6161_ops = {
@@ -4095,7 +3965,6 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -4132,7 +4001,6 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.avb_ops = &mv88e6165_avb_ops,
 	.ptp_ops = &mv88e6165_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6171_ops = {
@@ -4175,7 +4043,6 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6172_ops = {
@@ -4231,7 +4098,6 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
-	.phylink_validate = mv88e6352_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6175_ops = {
@@ -4274,7 +4140,6 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6176_ops = {
@@ -4333,7 +4198,6 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
-	.phylink_validate = mv88e6352_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6185_ops = {
@@ -4373,7 +4237,6 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -4436,7 +4299,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6390_phylink_get_caps,
-	.phylink_validate = mv88e6390_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6190x_ops = {
@@ -4498,7 +4360,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6390x_phylink_get_caps,
-	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6191_ops = {
@@ -4559,7 +4420,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6390_phylink_get_caps,
-	.phylink_validate = mv88e6390_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6240_ops = {
@@ -4620,7 +4480,6 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
-	.phylink_validate = mv88e6352_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6250_ops = {
@@ -4661,7 +4520,6 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
-	.phylink_validate = mv88e6065_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
@@ -4724,7 +4582,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6390_phylink_get_caps,
-	.phylink_validate = mv88e6390_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6320_ops = {
@@ -4769,7 +4626,6 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
@@ -4812,7 +4668,6 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6341_ops = {
@@ -4879,7 +4734,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_get_caps = mv88e6341_phylink_get_caps,
-	.phylink_validate = mv88e6341_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6350_ops = {
@@ -4922,7 +4776,6 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6351_ops = {
@@ -4967,7 +4820,6 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6185_phylink_get_caps,
-	.phylink_validate = mv88e6185_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6352_ops = {
@@ -5031,7 +4883,6 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
-	.phylink_validate = mv88e6352_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6390_ops = {
@@ -5097,7 +4948,6 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_get_caps = mv88e6390_phylink_get_caps,
-	.phylink_validate = mv88e6390_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6390x_ops = {
@@ -5162,7 +5012,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6390x_phylink_get_caps,
-	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
 static const struct mv88e6xxx_ops mv88e6393x_ops = {
@@ -5227,7 +5076,6 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_get_caps = mv88e6393x_phylink_get_caps,
-	.phylink_validate = mv88e6393x_phylink_validate,
 };
 
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
@@ -6497,7 +6345,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_setup		= mv88e6xxx_port_setup,
 	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
-	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
 	.phylink_mac_an_restart	= mv88e6xxx_serdes_pcs_an_restart,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index ee1dc58b3bcb..3440287b096f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -612,9 +612,6 @@ struct mv88e6xxx_ops {
 	/* Phylink */
 	void (*phylink_get_caps)(struct mv88e6xxx_chip *chip, int port,
 				 struct phylink_config *config);
-	void (*phylink_validate)(struct mv88e6xxx_chip *chip, int port,
-				 unsigned long *mask,
-				 struct phylink_link_state *state);
 
 	/* Max Frame Size */
 	int (*set_max_frame_size)(struct mv88e6xxx_chip *chip, int mtu);
-- 
2.30.2

