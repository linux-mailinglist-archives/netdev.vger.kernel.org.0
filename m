Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B890745CB70
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349935AbhKXR4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349929AbhKXR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255C3C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MdtncVqr/mHKhbd53T+ZvB42sQYh6wsBg6wKf6/pVSQ=; b=NQrJq7hD8Mdw0ajOdjQHFFFQYF
        hycBuh0Go/XnjzIuItIFXnKDTvHyEvrreAN9rpCPqeAd/oVc6n4DjF+gx28/uLU06OJ8Sc4kA0MJg
        yWaQWMvfdc9sR+EX1FRsScRoYswhWMub1cB7W7K1m3hAIAlMpId+qOmziHgkmwxiwQcw3yo+39D3Y
        kRGB/UxKrSfDOqBrVaO/VLTBrUlGy/6u4H5uGidWEkz5nlykcsBlPXZAOKzkoI3umQRY0efrqJHE8
        PWI0Cbo4K97tJrXt4vrl818+NDBrI2GoxYA6uCWBUHAmCVjciPbWr0hsU7G1La0XPRG6ekJ9Yw2Ge
        rK+WCMZw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49532 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwS8-0000y2-Iv; Wed, 24 Nov 2021 17:53:04 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwS8-00D8Lh-49; Wed, 24 Nov 2021 17:53:04 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 08/12] net: dsa: lantiq: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwS8-00D8Lh-49@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:53:04 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the Lantiq
DSA switches and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

The exclusion of Gigabit linkmodes for MII, Reverse MII and Reduced MII
links is handled within phylink_generic_validate() in phylink, so there
is no need to make them conditional on the interface mode in the driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/lantiq_gswip.c | 120 +++++++++++----------------------
 1 file changed, 38 insertions(+), 82 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 7056d98d8177..583af774e1bd 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1438,114 +1438,70 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void gswip_phylink_set_capab(unsigned long *supported,
-				    struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	/* With the exclusion of MII, Reverse MII and Reduced MII, we
-	 * support Gigabit, including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
-	}
-
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
-static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
-					  unsigned long *supported,
-					  struct phylink_link_state *state)
+static void gswip_xrx200_phylink_get_caps(struct dsa_switch *ds, int port,
+					  struct phylink_config *config)
 {
 	switch (port) {
 	case 0:
 	case 1:
-		if (!phy_interface_mode_is_rgmii(state->interface) &&
-		    state->interface != PHY_INTERFACE_MODE_MII &&
-		    state->interface != PHY_INTERFACE_MODE_REVMII &&
-		    state->interface != PHY_INTERFACE_MODE_RMII)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_REVMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
 		break;
+
 	case 2:
 	case 3:
 	case 4:
-		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 		break;
+
 	case 5:
-		if (!phy_interface_mode_is_rgmii(state->interface) &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 		break;
-	default:
-		linkmode_zero(supported);
-		dev_err(ds->dev, "Unsupported port: %i\n", port);
-		return;
 	}
 
-	gswip_phylink_set_capab(supported, state);
-
-	return;
-
-unsupported:
-	linkmode_zero(supported);
-	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
-		phy_modes(state->interface), port);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000;
 }
 
-static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
-					  unsigned long *supported,
-					  struct phylink_link_state *state)
+static void gswip_xrx300_phylink_get_caps(struct dsa_switch *ds, int port,
+					  struct phylink_config *config)
 {
 	switch (port) {
 	case 0:
-		if (!phy_interface_mode_is_rgmii(state->interface) &&
-		    state->interface != PHY_INTERFACE_MODE_GMII &&
-		    state->interface != PHY_INTERFACE_MODE_RMII)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
 		break;
+
 	case 1:
 	case 2:
 	case 3:
 	case 4:
-		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 		break;
+
 	case 5:
-		if (!phy_interface_mode_is_rgmii(state->interface) &&
-		    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
-		    state->interface != PHY_INTERFACE_MODE_RMII)
-			goto unsupported;
+		phy_interface_set_rgmii(config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
 		break;
-	default:
-		linkmode_zero(supported);
-		dev_err(ds->dev, "Unsupported port: %i\n", port);
-		return;
 	}
 
-	gswip_phylink_set_capab(supported, state);
-
-	return;
-
-unsupported:
-	linkmode_zero(supported);
-	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
-		phy_modes(state->interface), port);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000;
 }
 
 static void gswip_port_set_link(struct gswip_priv *priv, int port, bool link)
@@ -1827,7 +1783,7 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.port_fdb_add		= gswip_port_fdb_add,
 	.port_fdb_del		= gswip_port_fdb_del,
 	.port_fdb_dump		= gswip_port_fdb_dump,
-	.phylink_validate	= gswip_xrx200_phylink_validate,
+	.phylink_get_caps	= gswip_xrx200_phylink_get_caps,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
 	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
@@ -1851,7 +1807,7 @@ static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
 	.port_fdb_add		= gswip_port_fdb_add,
 	.port_fdb_del		= gswip_port_fdb_del,
 	.port_fdb_dump		= gswip_port_fdb_dump,
-	.phylink_validate	= gswip_xrx300_phylink_validate,
+	.phylink_get_caps	= gswip_xrx300_phylink_get_caps,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
 	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
-- 
2.30.2

