Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92F45CB78
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349984AbhKXR4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350037AbhKXR4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585C5C061748
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M0E0m37ajR+YRLSBnZstU8Ms3/K8KbrZU4qMneYQtRI=; b=f1mN9TvZgev0woAMOexu9ANzO0
        NGuv8cZlyy1DDtgA85xch/sg/RqdqDskPOg03Jg5TY+JoqIdLKoTTu1QijqB5FrKSNOUtnmI7TBkh
        NYDt6rF8ec423U9aK6JXu83GkD+FSyQEGw2zcarRSDP99cCnTQV7kGLaY0j8ZdQAt+YWmmxl7LOEK
        sFHngtpGMnUQYkbsBZlMZ5QeERhuneiIJF8AtzM/DlJnzwqZw9DelPMeKoJ1zYLE0lXez0ys6Cwjq
        zGwhZR2rDuL6289SL7LwHJbJpHST7GKXIq7XSD1tnGiwTNIMFWricSPLnqmZozZOoGMcGfZWLVxnq
        RlVDWrnw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49538 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSN-0000yq-Uz; Wed, 24 Nov 2021 17:53:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSN-00D8Lz-GB; Wed, 24 Nov 2021 17:53:19 +0000
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
Subject: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:53:19 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the SJA1105
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

This switch only supports a static model of configuration, so we
restrict the interface modes to the configured setting, and pass the
MAC capabilities. As it is unclear which interface modes support 1G
speeds, we keep the setting of MAC_1000FD conditional on the configured
interface mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 45 ++++++++------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c343effe2e96..6d763f2f63b7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1411,48 +1411,29 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
-static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
+static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
 {
-	/* Construct a new mask which exhaustively contains all link features
-	 * supported by the MAC, and then apply that (logical AND) to what will
-	 * be sent to the PHY for "marketing".
-	 */
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_xmii_params_entry *mii;
 
 	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 
-	/* include/linux/phylink.h says:
-	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
-	 *     expects the MAC driver to return all supported link modes.
+	/* The SJA1105 MAC programming model is through the static config
+	 * (the xMII Mode table cannot be dynamically reconfigured), and
+	 * we have to program that early.
 	 */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		linkmode_zero(supported);
-		return;
-	}
+	__set_bit(priv->phy_mode[port], config->supported_interfaces);
+
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10FD | MAC_100FD;
 
-	/* The MAC does not support pause frames, and also doesn't
-	 * support half-duplex traffic modes.
-	 */
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, MII);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT1_Full);
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
@@ -3189,7 +3170,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.port_change_mtu	= sja1105_change_mtu,
 	.port_max_mtu		= sja1105_get_max_mtu,
-	.phylink_validate	= sja1105_phylink_validate,
+	.phylink_get_caps	= sja1105_phylink_get_caps,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
 	.phylink_mac_link_down	= sja1105_mac_link_down,
-- 
2.30.2

