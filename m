Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E41258F6E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgIANtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgIANsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B782C061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Mkob9LxJ9xLvslCikBMyGEL9jXvanBYCq2O1rlFEIB8=; b=Mc5W6FYoTCEIAsn0soEGcTIjrX
        u1f2XtuQfUF8PhGVChq4WbOi7a5T8ZFda2ZA3WImoVgs7IyMcDCZ9lt3cBHD0X7fP/jHwTjSj0nHu
        eBE7V1Yyr22ulhK92ua0F1ei2b8mw+t5vYPtwvcUQmIFUKNdRWLtLkUyV8PL6V6wsIv07KXkwft6l
        imkH+SQaVOZ/7GvvHIW+R0QNxl/v1uZkyREAKFuHVH+GEzKaLnvvdc8Biur9gGFP4V0u1/Irr/d09
        wjavhPTRDLz1j+9WCXt4rHSrlOHmagB8jxsyg3VUFiexOri8dsVVKgLwOuA1vHV+j8FkPqSzeMEQL
        bXq5IjNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36088 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eH-0002Yy-1l; Tue, 01 Sep 2020 14:48:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eG-0007LY-QN; Tue, 01 Sep 2020 14:48:32 +0100
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/6] net: mvpp2: convert to phylink pcs operations
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6eG-0007LY-QN@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:32 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 to phylink's new pcs support.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 292 +++++++++++-------
 2 files changed, 177 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 32753cc771bf..ecb5f4616a36 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -967,6 +967,7 @@ struct mvpp2_port {
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
+	struct phylink_pcs phylink_pcs;
 	struct phy *comphy;
 
 	struct mvpp2_bm_pool *pool_long;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 58df72088fba..6d3d84dc6d84 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1479,8 +1479,8 @@ static void mvpp2_port_loopback_set(struct mvpp2_port *port,
 	else
 		val &= ~MVPP2_GMAC_GMII_LB_EN_MASK;
 
-	if (phy_interface_mode_is_8023z(port->phy_interface) ||
-	    port->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (phy_interface_mode_is_8023z(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII)
 		val |= MVPP2_GMAC_PCS_LB_EN_MASK;
 	else
 		val &= ~MVPP2_GMAC_PCS_LB_EN_MASK;
@@ -5376,6 +5376,174 @@ static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
 	return container_of(config, struct mvpp2_port, phylink_config);
 }
 
+static struct mvpp2_port *mvpp2_pcs_to_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mvpp2_port, phylink_pcs);
+}
+
+static void mvpp22_xlg_pcs_get_state(struct mvpp2_port *port,
+				     struct phylink_link_state *state)
+{
+	u32 val;
+
+	state->speed = SPEED_10000;
+	state->duplex = 1;
+	state->an_complete = 1;
+
+	val = readl(port->base + MVPP22_XLG_STATUS);
+	state->link = !!(val & MVPP22_XLG_STATUS_LINK_UP);
+
+	state->pause = 0;
+	val = readl(port->base + MVPP22_XLG_CTRL0_REG);
+	if (val & MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN)
+		state->pause |= MLO_PAUSE_TX;
+	if (val & MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN)
+		state->pause |= MLO_PAUSE_RX;
+}
+
+static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
+				     struct phylink_link_state *state)
+{
+	u32 val;
+
+	val = readl(port->base + MVPP2_GMAC_STATUS0);
+
+	state->an_complete = !!(val & MVPP2_GMAC_STATUS0_AN_COMPLETE);
+	state->link = !!(val & MVPP2_GMAC_STATUS0_LINK_UP);
+	state->duplex = !!(val & MVPP2_GMAC_STATUS0_FULL_DUPLEX);
+
+	switch (port->phy_interface) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		state->speed = SPEED_1000;
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		state->speed = SPEED_2500;
+		break;
+	default:
+		if (val & MVPP2_GMAC_STATUS0_GMII_SPEED)
+			state->speed = SPEED_1000;
+		else if (val & MVPP2_GMAC_STATUS0_MII_SPEED)
+			state->speed = SPEED_100;
+		else
+			state->speed = SPEED_10;
+	}
+
+	state->pause = 0;
+	if (val & MVPP2_GMAC_STATUS0_RX_PAUSE)
+		state->pause |= MLO_PAUSE_RX;
+	if (val & MVPP2_GMAC_STATUS0_TX_PAUSE)
+		state->pause |= MLO_PAUSE_TX;
+}
+
+static void mvpp2_phylink_pcs_get_state(struct phylink_pcs *pcs,
+					struct phylink_link_state *state)
+{
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+
+	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
+		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
+		mode &= MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
+
+		if (mode == MVPP22_XLG_CTRL3_MACMODESELECT_10G) {
+			mvpp22_xlg_pcs_get_state(port, state);
+			return;
+		}
+	}
+
+	mvpp2_gmac_pcs_get_state(port, state);
+}
+
+static int mvpp2_gmac_pcs_config(struct mvpp2_port *port, unsigned int mode,
+				 phy_interface_t interface,
+				 const unsigned long *advertising,
+				 bool permit_pause_to_mac)
+{
+	u32 mask, val, an, old_an, changed;
+
+	mask = MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS |
+	       MVPP2_GMAC_IN_BAND_AUTONEG |
+	       MVPP2_GMAC_AN_SPEED_EN |
+	       MVPP2_GMAC_FLOW_CTRL_AUTONEG |
+	       MVPP2_GMAC_AN_DUPLEX_EN;
+
+	if (phylink_autoneg_inband(mode)) {
+		mask |= MVPP2_GMAC_CONFIG_MII_SPEED |
+			MVPP2_GMAC_CONFIG_GMII_SPEED |
+			MVPP2_GMAC_CONFIG_FULL_DUPLEX;
+		val = MVPP2_GMAC_IN_BAND_AUTONEG;
+
+		if (interface == PHY_INTERFACE_MODE_SGMII) {
+			/* SGMII mode receives the speed and duplex from PHY */
+			val |= MVPP2_GMAC_AN_SPEED_EN |
+			       MVPP2_GMAC_AN_DUPLEX_EN;
+		} else {
+			/* 802.3z mode has fixed speed and duplex */
+			val |= MVPP2_GMAC_CONFIG_GMII_SPEED |
+			       MVPP2_GMAC_CONFIG_FULL_DUPLEX;
+
+			/* The FLOW_CTRL_AUTONEG bit selects either the hardware
+			 * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
+			 * manually controls the GMAC pause modes.
+			 */
+			if (permit_pause_to_mac)
+				val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
+
+			/* Configure advertisement bits */
+			mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
+			if (phylink_test(advertising, Pause))
+				val |= MVPP2_GMAC_FC_ADV_EN;
+			if (phylink_test(advertising, Asym_Pause))
+				val |= MVPP2_GMAC_FC_ADV_ASM_EN;
+		}
+	} else {
+		val = 0;
+	}
+
+	old_an = an = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+	an = (an & ~mask) | val;
+	changed = an ^ old_an;
+	if (changed)
+		writel(an, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+
+	/* We are only interested in the advertisement bits changing */
+	return changed & (MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN);
+}
+
+static int mvpp2_phylink_pcs_config(struct phylink_pcs *pcs,
+				    unsigned int mode,
+		                    phy_interface_t interface,
+				    const unsigned long *advertising,
+				    bool permit_pause_to_mac)
+{
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	int ret;
+
+	if (mvpp2_is_xlg(interface))
+		ret = 0;
+	else
+		ret = mvpp2_gmac_pcs_config(port, mode, interface, advertising,
+					    permit_pause_to_mac);
+
+	return ret;
+}
+
+static void mvpp2_phylink_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+
+	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
+	       port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+	writel(val & ~MVPP2_GMAC_IN_BAND_RESTART_AN,
+	       port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+}
+
+static const struct phylink_pcs_ops mvpp2_phylink_pcs_ops = {
+	.pcs_get_state = mvpp2_phylink_pcs_get_state,
+	.pcs_config = mvpp2_phylink_pcs_config,
+	.pcs_an_restart = mvpp2_phylink_pcs_an_restart,
+};
+
 static void mvpp2_phylink_validate(struct phylink_config *config,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -5464,89 +5632,6 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static void mvpp22_xlg_pcs_get_state(struct mvpp2_port *port,
-				     struct phylink_link_state *state)
-{
-	u32 val;
-
-	state->speed = SPEED_10000;
-	state->duplex = 1;
-	state->an_complete = 1;
-
-	val = readl(port->base + MVPP22_XLG_STATUS);
-	state->link = !!(val & MVPP22_XLG_STATUS_LINK_UP);
-
-	state->pause = 0;
-	val = readl(port->base + MVPP22_XLG_CTRL0_REG);
-	if (val & MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN)
-		state->pause |= MLO_PAUSE_TX;
-	if (val & MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN)
-		state->pause |= MLO_PAUSE_RX;
-}
-
-static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
-				     struct phylink_link_state *state)
-{
-	u32 val;
-
-	val = readl(port->base + MVPP2_GMAC_STATUS0);
-
-	state->an_complete = !!(val & MVPP2_GMAC_STATUS0_AN_COMPLETE);
-	state->link = !!(val & MVPP2_GMAC_STATUS0_LINK_UP);
-	state->duplex = !!(val & MVPP2_GMAC_STATUS0_FULL_DUPLEX);
-
-	switch (port->phy_interface) {
-	case PHY_INTERFACE_MODE_1000BASEX:
-		state->speed = SPEED_1000;
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		state->speed = SPEED_2500;
-		break;
-	default:
-		if (val & MVPP2_GMAC_STATUS0_GMII_SPEED)
-			state->speed = SPEED_1000;
-		else if (val & MVPP2_GMAC_STATUS0_MII_SPEED)
-			state->speed = SPEED_100;
-		else
-			state->speed = SPEED_10;
-	}
-
-	state->pause = 0;
-	if (val & MVPP2_GMAC_STATUS0_RX_PAUSE)
-		state->pause |= MLO_PAUSE_RX;
-	if (val & MVPP2_GMAC_STATUS0_TX_PAUSE)
-		state->pause |= MLO_PAUSE_TX;
-}
-
-static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
-					    struct phylink_link_state *state)
-{
-	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-
-	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
-		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
-		mode &= MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
-
-		if (mode == MVPP22_XLG_CTRL3_MACMODESELECT_10G) {
-			mvpp22_xlg_pcs_get_state(port, state);
-			return;
-		}
-	}
-
-	mvpp2_gmac_pcs_get_state(port, state);
-}
-
-static void mvpp2_mac_an_restart(struct phylink_config *config)
-{
-	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-
-	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
-	       port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-	writel(val & ~MVPP2_GMAC_IN_BAND_RESTART_AN,
-	       port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-}
-
 static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -5570,20 +5655,14 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 			      const struct phylink_link_state *state)
 {
-	u32 old_an, an;
 	u32 old_ctrl0, ctrl0;
 	u32 old_ctrl2, ctrl2;
 	u32 old_ctrl4, ctrl4;
 
-	old_an = an = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 	old_ctrl0 = ctrl0 = readl(port->base + MVPP2_GMAC_CTRL_0_REG);
 	old_ctrl2 = ctrl2 = readl(port->base + MVPP2_GMAC_CTRL_2_REG);
 	old_ctrl4 = ctrl4 = readl(port->base + MVPP22_GMAC_CTRL_4_REG);
 
-	an &= ~(MVPP2_GMAC_AN_SPEED_EN | MVPP2_GMAC_FC_ADV_EN |
-		MVPP2_GMAC_FC_ADV_ASM_EN | MVPP2_GMAC_FLOW_CTRL_AUTONEG |
-		MVPP2_GMAC_AN_DUPLEX_EN | MVPP2_GMAC_IN_BAND_AUTONEG |
-		MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS);
 	ctrl0 &= ~MVPP2_GMAC_PORT_TYPE_MASK;
 	ctrl2 &= ~(MVPP2_GMAC_INBAND_AN_MASK | MVPP2_GMAC_PCS_ENABLE_MASK);
 
@@ -5607,12 +5686,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 			 MVPP22_CTRL4_QSGMII_BYPASS_ACTIVE;
 	}
 
-	/* Configure advertisement bits */
-	if (phylink_test(state->advertising, Pause))
-		an |= MVPP2_GMAC_FC_ADV_EN;
-	if (phylink_test(state->advertising, Asym_Pause))
-		an |= MVPP2_GMAC_FC_ADV_ASM_EN;
-
 	/* Configure negotiation style */
 	if (!phylink_autoneg_inband(mode)) {
 		/* Phy or fixed speed - no in-band AN, nothing to do, leave the
@@ -5621,12 +5694,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII in-band mode receives the speed and duplex from
 		 * the PHY. Flow control information is not received. */
-		an &= ~(MVPP2_GMAC_CONFIG_MII_SPEED |
-			MVPP2_GMAC_CONFIG_GMII_SPEED |
-			MVPP2_GMAC_CONFIG_FULL_DUPLEX);
-		an |= MVPP2_GMAC_IN_BAND_AUTONEG |
-		      MVPP2_GMAC_AN_SPEED_EN |
-		      MVPP2_GMAC_AN_DUPLEX_EN;
 	} else if (phy_interface_mode_is_8023z(state->interface)) {
 		/* 1000BaseX and 2500BaseX ports cannot negotiate speed nor can
 		 * they negotiate duplex: they are always operating with a fixed
@@ -5634,15 +5701,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		 * speed and full duplex here.
 		 */
 		ctrl0 |= MVPP2_GMAC_PORT_TYPE_MASK;
-		an &= ~(MVPP2_GMAC_CONFIG_MII_SPEED |
-			MVPP2_GMAC_CONFIG_GMII_SPEED |
-			MVPP2_GMAC_CONFIG_FULL_DUPLEX);
-		an |= MVPP2_GMAC_IN_BAND_AUTONEG |
-		      MVPP2_GMAC_CONFIG_GMII_SPEED |
-		      MVPP2_GMAC_CONFIG_FULL_DUPLEX;
-
-		if (state->pause & MLO_PAUSE_AN && state->an_enabled)
-			an |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
 	}
 
 	if (old_ctrl0 != ctrl0)
@@ -5651,8 +5709,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		writel(ctrl2, port->base + MVPP2_GMAC_CTRL_2_REG);
 	if (old_ctrl4 != ctrl4)
 		writel(ctrl4, port->base + MVPP22_GMAC_CTRL_4_REG);
-	if (old_an != an)
-		writel(an, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 }
 
 static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
@@ -5861,8 +5917,6 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.validate = mvpp2_phylink_validate,
-	.mac_pcs_get_state = mvpp2_phylink_mac_pcs_get_state,
-	.mac_an_restart = mvpp2_mac_an_restart,
 	.mac_prepare = mvpp2_mac_prepare,
 	.mac_config = mvpp2_mac_config,
 	.mac_finish = mvpp2_mac_finish,
@@ -5883,6 +5937,9 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
 			  port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
+	mvpp2_phylink_pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
+				 port->phy_interface, state.advertising,
+				 false);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
@@ -6114,6 +6171,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			goto err_free_port_pcpu;
 		}
 		port->phylink = phylink;
+
+		port->phylink_pcs.ops = &mvpp2_phylink_pcs_ops;
+		phylink_set_pcs(phylink, &port->phylink_pcs);
 	} else {
 		port->phylink = NULL;
 	}
-- 
2.20.1

