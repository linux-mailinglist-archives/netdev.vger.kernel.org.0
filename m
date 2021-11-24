Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F745CB6C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349915AbhKXR4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349918AbhKXR4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82752C06173E
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eBPmib6tt7puWBnyRsxmoUJAJRxLlAQLT7RNfSdCkDU=; b=NHYWCjijl8fvoYtUgFaY/HjCRc
        efNTEPYwx77DbEQ0QO0SsFVPlTGgM6ehLUTLb7C2zHCnbhOZz/zUF3z4+EcXfqO04sckgDw/yNBe5
        REP6EQiv2ko9bXgpQhKi1VBe5GCfN/MnNxlRg5ZL3d3Ejpba3sFowBq9cZSJmIN4BxYVMs4GCBVHS
        ctI/FEM105jSsz5wkGQK1VYJJ7+hIv/gIWhUNpAoY3Aq8KAQjKjojQRLYLlOXqDQl7x1x1s+4iWWx
        //af5vccpmfeFc6upXvwLIc/V8g6/QADpJTBFJH0xHl/rltFZOKtyosKHkjyGUsgfhQjc3lZDGpIp
        p5M3NVpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49524 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRt-0000xB-6Q; Wed, 24 Nov 2021 17:52:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRs-00D8LK-N3; Wed, 24 Nov 2021 17:52:48 +0000
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
Subject: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:52:48 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the bcm_sf2
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

The exclusion of Gigabit linkmodes for MII and Reverse MII links is
handled within phylink_generic_validate() in phylink, so there is no
need to make them conditional on the interface mode in the driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 55 +++++++++------------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 13aa43b5cffd..d6ef0fb0d943 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -672,49 +672,18 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 		       PHY_BRCM_IDDQ_SUSPEND;
 }
 
-static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
-				unsigned long *supported,
-				struct phylink_link_state *state)
+static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
+				struct phylink_config *config)
 {
-	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
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
-
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
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
+	__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_INTERNAL, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_MOCA, config->supported_interfaces);
+	phy_interface_set_rgmii(config->supported_interfaces);
+
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000;
 }
 
 static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
@@ -1181,7 +1150,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
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

