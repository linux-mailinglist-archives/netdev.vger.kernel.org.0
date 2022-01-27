Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C549E015
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiA0LCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiA0LCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:02:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FE3C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vLz6RWDaGmgWpHQfltZoK7epD68Jwim8EgSU4r2nlUY=; b=FQu3AqTMayGZ2aAQsJ989CZGhb
        Vm39jAu6NHG2/TcoQxh5UGJOFEbNEBK4Ys0aek3ar7jhHz5S28Yv4rOsdXGLg6f0P/dasmis4p6In
        MjrzLtBV4G581458Atb/04ahnE6az11nrn+sS5KVlrU0QfLAxfmZB6AU3R0dZ9M8LuKaHKsCwpKoB
        iVTaJjAajinvpIKy88zTf6Kn7RLD5IJl6Fw+2Mphgz9eB2OQGK/XF6YetLDD+p5xpvGAwa3k7SJAC
        XBueLGw43g6cl5txpK49je70qjQsXEcl2u6P+ANVT+JGrtzvzTQ1UaaYVVRXHS3EtaKuZVRD30XOr
        608ZLAdA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43572 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nD2Xk-0004ME-0P; Thu, 27 Jan 2022 11:02:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nD2Xj-005UcL-D2; Thu, 27 Jan 2022 11:02:19 +0000
In-Reply-To: <YfJ7omKUSF6BY+CL@shell.armlinux.org.uk>
References: <YfJ7omKUSF6BY+CL@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH CFT net-next 2/5] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nD2Xj-005UcL-D2@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Jan 2022 11:02:19 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the bcm_sf2
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

The exclusion of Gigabit linkmodes for MII and Reverse MII links is
handled within phylink_generic_validate() in phylink, so there is no
need to make them conditional on the interface mode in the driver.

Thanks to Florian Fainelli for suggesting how to populate the supported
interfaces.

Link: https://lore.kernel.org/r/3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 54 +++++++++++----------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 33499fcd8848..9161ce4ca352 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -709,49 +709,25 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 		       PHY_BRCM_IDDQ_SUSPEND;
 }
 
-static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
-				unsigned long *supported,
-				struct phylink_link_state *state)
+static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
+				struct phylink_config *config)
 {
+	unsigned long *interfaces = config->supported_interfaces;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	if (!phy_interface_mode_is_rgmii(state->interface) &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
-	    state->interface != PHY_INTERFACE_MODE_MOCA) {
-		linkmode_zero(supported);
-		if (port != core_readl(priv, CORE_IMP0_PRT_ID))
-			dev_err(ds->dev,
-				"Unsupported interface: %d for port %d\n",
-				state->interface, port);
-		return;
-	}
-
-	/* Allow all the expected bits */
-	phylink_set(mask, Autoneg);
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
+	if (priv->int_phy_mask & BIT(port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL, interfaces);
+	} else if (priv->moca_port == port) {
+		__set_bit(PHY_INTERFACE_MODE_MOCA, interfaces);
+	} else {
+		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
+		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
+		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
+		phy_interface_set_rgmii(interfaces);
 	}
 
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000;
 }
 
 static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
@@ -1218,7 +1194,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.get_sset_count		= bcm_sf2_sw_get_sset_count,
 	.get_ethtool_phy_stats	= b53_get_ethtool_phy_stats,
 	.get_phy_flags		= bcm_sf2_sw_get_phy_flags,
-	.phylink_validate	= bcm_sf2_sw_validate,
+	.phylink_get_caps	= bcm_sf2_sw_get_caps,
 	.phylink_mac_config	= bcm_sf2_sw_mac_config,
 	.phylink_mac_link_down	= bcm_sf2_sw_mac_link_down,
 	.phylink_mac_link_up	= bcm_sf2_sw_mac_link_up,
-- 
2.30.2

