Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3493A475BE9
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhLOPeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbhLOPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:34:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD277C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gXHifOV5ynHm71yDXdUpAEg3jH/dKn0gNS6Jc0OtM94=; b=MyhLUGUR7llgIxnGcXAx3TuDLd
        UDRJ0R6EQAVft47Fm3E6EdusE4+BFK9+ihcX76i55+DmwkADMkRmzi8H0q909HvQlgbjFOqDqMpvY
        kDrBo446rMSfBD6ys8rNHkWvofa9BSfa/JmfjQOgSZNph5ZTfSjhIUD4IJhEIRsVuoFrKApZY2+hF
        /XF0FBD44oAnj4RqywBQoZM5ehsM3wE7Gv7dF6uPSDTN0K+irV8USEMvnd/iB64Yqbd/55RO4Y5jW
        iTUtB20MqQqQngobeE4CZbmdXr17LhojFfJUfD2S4sjaa4XmlCspf4omTe3qKB91+lKnHz0/QZWP9
        cBe9okbA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIj-0006aE-46; Wed, 15 Dec 2021 15:34:41 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIi-00GPih-Mm; Wed, 15 Dec 2021 15:34:40 +0000
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 6/7] net: mvneta: convert to phylink pcs
 operations
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxWIi-00GPih-Mm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Dec 2021 15:34:40 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An initial stab at converting mvneta to PCS operations.  There's a few
FIXMEs to be solved.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 143 ++++++++++++++++----------
 1 file changed, 91 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e59952c65a3c..f40eb282c522 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -526,6 +526,7 @@ struct mvneta_port {
 	unsigned int tx_csum_limit;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
+	struct phylink_pcs phylink_pcs;
 	struct phy *comphy;
 
 	struct mvneta_bm *bm_priv;
@@ -3846,29 +3847,15 @@ static int mvneta_set_mac_addr(struct net_device *dev, void *addr)
 	return 0;
 }
 
-static void mvneta_validate(struct phylink_config *config,
-			    unsigned long *supported,
-			    struct phylink_link_state *state)
+static struct mvneta_port *mvneta_pcs_to_port(struct phylink_pcs *pcs)
 {
-	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
-	 * When in 802.3z mode, we must have AN enabled:
-	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
-	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
-	 */
-	if (phy_interface_mode_is_8023z(state->interface) &&
-	    !phylink_test(state->advertising, Autoneg)) {
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_generic_validate(config, supported, state);
+	return container_of(pcs, struct mvneta_port, phylink_pcs);
 }
 
-static void mvneta_mac_pcs_get_state(struct phylink_config *config,
-				     struct phylink_link_state *state)
+static void mvneta_pcs_get_state(struct phylink_pcs *pcs,
+				 struct phylink_link_state *state)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct mvneta_port *pp = netdev_priv(ndev);
+	struct mvneta_port *pp = mvneta_pcs_to_port(pcs);
 	u32 gmac_stat;
 
 	gmac_stat = mvreg_read(pp, MVNETA_GMAC_STATUS);
@@ -3886,17 +3873,71 @@ static void mvneta_mac_pcs_get_state(struct phylink_config *config,
 	state->link = !!(gmac_stat & MVNETA_GMAC_LINK_UP);
 	state->duplex = !!(gmac_stat & MVNETA_GMAC_FULL_DUPLEX);
 
-	state->pause = 0;
 	if (gmac_stat & MVNETA_GMAC_RX_FLOW_CTRL_ENABLE)
 		state->pause |= MLO_PAUSE_RX;
 	if (gmac_stat & MVNETA_GMAC_TX_FLOW_CTRL_ENABLE)
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static void mvneta_mac_an_restart(struct phylink_config *config)
+static int mvneta_pcs_config(struct phylink_pcs *pcs,
+			     unsigned int mode, phy_interface_t interface,
+			     const unsigned long *advertising,
+			     bool permit_pause_to_mac)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct mvneta_port *pp = netdev_priv(ndev);
+	struct mvneta_port *pp = mvneta_pcs_to_port(pcs);
+	u32 mask, val, an, old_an, changed;
+
+	mask = MVNETA_GMAC_INBAND_AN_ENABLE |
+	       MVNETA_GMAC_INBAND_RESTART_AN |
+	       MVNETA_GMAC_AN_SPEED_EN |
+	       MVNETA_GMAC_AN_FLOW_CTRL_EN |
+	       MVNETA_GMAC_AN_DUPLEX_EN;
+
+	if (phylink_autoneg_inband(mode)) {
+		mask |= MVNETA_GMAC_CONFIG_MII_SPEED |
+			MVNETA_GMAC_CONFIG_GMII_SPEED |
+			MVNETA_GMAC_CONFIG_FULL_DUPLEX;
+		val = MVNETA_GMAC_INBAND_AN_ENABLE;
+
+		if (interface == PHY_INTERFACE_MODE_SGMII) {
+			/* SGMII mode receives the speed and duplex from PHY */
+			val |= MVNETA_GMAC_AN_SPEED_EN |
+			       MVNETA_GMAC_AN_DUPLEX_EN;
+		} else {
+			/* 802.3z mode has fixed speed and duplex */
+			val |= MVNETA_GMAC_CONFIG_GMII_SPEED |
+			       MVNETA_GMAC_CONFIG_FULL_DUPLEX;
+
+			/* The FLOW_CTRL_EN bit selects either the hardware
+			 * automatically or the CONFIG_FLOW_CTRL manually
+			 * controls the GMAC pause mode.
+			 */
+			if (permit_pause_to_mac)
+				val |= MVNETA_GMAC_AN_FLOW_CTRL_EN;
+
+			/* Update the advertisement bits */
+			mask |= MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL;
+			if (phylink_test(advertising, Pause))
+				val |= MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL;
+		}
+	} else {
+		/* Phy or fixed speed - disable in-band AN modes */
+		val = 0;
+	}
+
+	old_an = an = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
+	an = (an & ~mask) | val;
+	changed = old_an ^ an;
+	if (changed)
+		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, an);
+
+	/* We are only interested in the advertisement bits changing */
+	return !!(changed & MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL);
+}
+
+static void mvneta_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct mvneta_port *pp = mvneta_pcs_to_port(pcs);
 	u32 gmac_an = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
 
 	mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG,
@@ -3905,6 +3946,30 @@ static void mvneta_mac_an_restart(struct phylink_config *config)
 		    gmac_an & ~MVNETA_GMAC_INBAND_RESTART_AN);
 }
 
+static const struct phylink_pcs_ops mvneta_phylink_pcs_ops = {
+	.pcs_get_state = mvneta_pcs_get_state,
+	.pcs_config = mvneta_pcs_config,
+	.pcs_an_restart = mvneta_pcs_an_restart,
+};
+
+static void mvneta_validate(struct phylink_config *config,
+			    unsigned long *supported,
+			    struct phylink_link_state *state)
+{
+	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
+	 * When in 802.3z mode, we must have AN enabled:
+	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
+	 */
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg)) {
+		linkmode_zero(supported);
+		return;
+	}
+
+	phylink_generic_validate(config, supported, state);
+}
+
 static int mvneta_mac_prepare(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface)
 {
@@ -3947,18 +4012,11 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	u32 new_ctrl0, gmac_ctrl0 = mvreg_read(pp, MVNETA_GMAC_CTRL_0);
 	u32 new_ctrl2, gmac_ctrl2 = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
 	u32 new_ctrl4, gmac_ctrl4 = mvreg_read(pp, MVNETA_GMAC_CTRL_4);
-	u32 new_an, gmac_an = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
 
 	new_ctrl0 = gmac_ctrl0 & ~MVNETA_GMAC0_PORT_1000BASE_X;
 	new_ctrl2 = gmac_ctrl2 & ~(MVNETA_GMAC2_INBAND_AN_ENABLE |
 				   MVNETA_GMAC2_PORT_RESET);
 	new_ctrl4 = gmac_ctrl4 & ~(MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE);
-	new_an = gmac_an & ~(MVNETA_GMAC_INBAND_AN_ENABLE |
-			     MVNETA_GMAC_INBAND_RESTART_AN |
-			     MVNETA_GMAC_AN_SPEED_EN |
-			     MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL |
-			     MVNETA_GMAC_AN_FLOW_CTRL_EN |
-			     MVNETA_GMAC_AN_DUPLEX_EN);
 
 	/* Even though it might look weird, when we're configured in
 	 * SGMII or QSGMII mode, the RGMII bit needs to be set.
@@ -3970,9 +4028,6 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	    phy_interface_mode_is_8023z(state->interface))
 		new_ctrl2 |= MVNETA_GMAC2_PCS_ENABLE;
 
-	if (phylink_test(state->advertising, Pause))
-		new_an |= MVNETA_GMAC_ADVERT_SYM_FLOW_CTRL;
-
 	if (!phylink_autoneg_inband(mode)) {
 		/* Phy or fixed speed - nothing to do, leave the
 		 * configured speed, duplex and flow control as-is.
@@ -3980,23 +4035,9 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII mode receives the state from the PHY */
 		new_ctrl2 |= MVNETA_GMAC2_INBAND_AN_ENABLE;
-		new_an = (new_an & ~(MVNETA_GMAC_CONFIG_MII_SPEED |
-				     MVNETA_GMAC_CONFIG_GMII_SPEED |
-				     MVNETA_GMAC_CONFIG_FULL_DUPLEX)) |
-			 MVNETA_GMAC_INBAND_AN_ENABLE |
-			 MVNETA_GMAC_AN_SPEED_EN |
-			 MVNETA_GMAC_AN_DUPLEX_EN;
 	} else {
 		/* 802.3z negotiation - only 1000base-X */
 		new_ctrl0 |= MVNETA_GMAC0_PORT_1000BASE_X;
-		new_an = (new_an & ~MVNETA_GMAC_CONFIG_MII_SPEED) |
-			 MVNETA_GMAC_INBAND_AN_ENABLE |
-			 MVNETA_GMAC_CONFIG_GMII_SPEED |
-			 /* The MAC only supports FD mode */
-			 MVNETA_GMAC_CONFIG_FULL_DUPLEX;
-
-		if (state->pause & MLO_PAUSE_AN && state->an_enabled)
-			new_an |= MVNETA_GMAC_AN_FLOW_CTRL_EN;
 	}
 
 	/* When at 2.5G, the link partner can send frames with shortened
@@ -4011,8 +4052,6 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 		mvreg_write(pp, MVNETA_GMAC_CTRL_2, new_ctrl2);
 	if (new_ctrl4 != gmac_ctrl4)
 		mvreg_write(pp, MVNETA_GMAC_CTRL_4, new_ctrl4);
-	if (new_an != gmac_an)
-		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, new_an);
 
 	if (gmac_ctrl2 & MVNETA_GMAC2_PORT_RESET) {
 		while ((mvreg_read(pp, MVNETA_GMAC_CTRL_2) &
@@ -4138,8 +4177,6 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.validate = mvneta_validate,
-	.mac_pcs_get_state = mvneta_mac_pcs_get_state,
-	.mac_an_restart = mvneta_mac_an_restart,
 	.mac_prepare = mvneta_mac_prepare,
 	.mac_config = mvneta_mac_config,
 	.mac_finish = mvneta_mac_finish,
@@ -5308,7 +5345,6 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
-	pp->phylink_config.legacy_pre_march2020 = true;
 	pp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
 		MAC_100 | MAC_1000FD | MAC_2500FD;
 
@@ -5383,6 +5419,9 @@ static int mvneta_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
+	pp->phylink_pcs.ops = &mvneta_phylink_pcs_ops;
+	phylink_set_pcs(phylink, &pp->phylink_pcs);
+
 	/* Alloc per-cpu port structure */
 	pp->ports = alloc_percpu(struct mvneta_pcpu_port);
 	if (!pp->ports) {
-- 
2.30.2

