Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A4E4C3144
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiBXQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBXQaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:30:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CDB1A39FA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cgnxRvxAr25UyLKUfOhTDeie2ydSHIXffnwqxjdk484=; b=hOjLGXklFNNtJoORqd3fqXEcbC
        Z1QF/oZ8+aa+oDpxlzLjoNV+MVkka9eDmVV5T+L6MMdvY3vndUFXp0YH2GKXIBWQMxo4F2QVG8pRP
        1TGK1yI9uQ3g8nx0lceAiJdMwMgJbUUaQkdtJ+ChvT6yGLai2Bp6qblk7dCZaoKI7DkDhtC0Lc+Hb
        Qr6t7f9Jq0QdvE6yOvuIYrWP6mocxCYXPMXcqHvwEIcgLlAEqHmXsMDNQkDDDX9J6+VRKHg+V5Xp1
        9O66WPF8WmxTescveZ9+aiReDD9Ytl/JLuACj18OYVdUbspbFU5wC+Z5OZRiPDBHHh4sHV2J768Ti
        uRG2IC5g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39186 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNGmH-0004Cn-0N; Thu, 24 Feb 2022 16:15:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNGmG-00AOj6-Dl; Thu, 24 Feb 2022 16:15:36 +0000
In-Reply-To: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 5/6] net: dsa: sja1105: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNGmG-00AOj6-Dl@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 24 Feb 2022 16:15:36 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the MAC capabilities for the SJA1105 DSA switch using the same
decision making which sja1105_phylink_validate() uses. Remove the now
obsolete sja1105_phylink_validate() implementation to allow DSA to use
phylink_generic_validate() for this switch driver.

As noted by Vladimir, this fixes an inconsequential bug which allowed
gigabit and lower interface modes to be indicated when operating in
2500base-X mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 35 ++++++--------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8f061cce77f0..5beef06d8ff7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1395,6 +1395,7 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 				     struct phylink_config *config)
 {
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_xmii_params_entry *mii;
 
 	/* This driver does not make use of the speed, duplex, pause or the
 	 * advertisement in its mac_config, so it is safe to mark this driver
@@ -1407,40 +1408,19 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 	 * we have to program that early.
 	 */
 	__set_bit(priv->phy_mode[port], config->supported_interfaces);
-}
-
-static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
-{
-	/* Construct a new mask which exhaustively contains all link features
-	 * supported by the MAC, and then apply that (logical AND) to what will
-	 * be sent to the PHY for "marketing".
-	 */
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct sja1105_private *priv = ds->priv;
-	struct sja1105_xmii_params_entry *mii;
-
-	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
 	 */
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, MII);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT1_Full);
+	config->mac_capabilities = MAC_10FD | MAC_100FD;
+
+	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
 	    mii->xmii_mode[port] == XMII_MODE_SGMII)
-		phylink_set(mask, 1000baseT_Full);
-	if (priv->info->supports_2500basex[port]) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
+		config->mac_capabilities |= MAC_1000FD;
 
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	if (priv->info->supports_2500basex[port])
+		config->mac_capabilities |= MAC_2500FD;
 }
 
 static int
@@ -3140,7 +3120,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_change_mtu	= sja1105_change_mtu,
 	.port_max_mtu		= sja1105_get_max_mtu,
 	.phylink_get_caps	= sja1105_phylink_get_caps,
-	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_select_pcs	= sja1105_mac_select_pcs,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
 	.phylink_mac_link_down	= sja1105_mac_link_down,
-- 
2.30.2

