Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55BE4C1167
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbiBWLfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239967AbiBWLfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:35:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25892854
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Rx1j11AzCBRyRfycGOlPR8D02DXsIdS/CJYgaoAIxR4=; b=j3HGJlEaW8nxReIrVVaguehgFV
        ml4zk3iBbZe0hIK/Kni43XzpwdSDqyHSPCT6T17cRdfjKNNeB9JX3l0Xb/8la3Z442uxpW16CoRko
        KNdfcsGmVApu0YS9XuNI6rSMDxkOeYR9Y3Y8Ku9v+lRE+u1n/YLGz5TVNdY6fakjf0G740FwwFMX5
        XfhTtu1nFWT+aJBdyj6s8Yh4Jnhy5SwTF/og+zHivQ6las6fXg9xgLhw54ln4Mks65vn4HtM+DUQN
        IVwM08LsmM6LOTqm8lt2vIvqIjKD3sKnJqLbmElUNhjJGsGW8JuZzZ6UqHXJV89X3bJggiUY6moYh
        /FoG+M7g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57386 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMpuz-0002kR-19; Wed, 23 Feb 2022 11:34:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMpuy-00AJp6-3m; Wed, 23 Feb 2022 11:34:48 +0000
In-Reply-To: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
References: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next v2 07/10] net: dsa: mt7530: switch to use
 phylink_get_linkmodes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMpuy-00AJp6-3m@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 23 Feb 2022 11:34:48 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch mt7530 to use phylink_get_linkmodes() to generate the ethtool
linkmodes that can be supported. We are unable to use the generic
helper for this as pause modes are dependent on the interface as
the Autoneg bit depends on the interface mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 58 ++++------------------------------------
 1 file changed, 5 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index db1d13718ff1..8e96bcd44cbb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2516,20 +2516,6 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 	return 0;
 }
 
-static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
-				  phy_interface_t interface,
-				  unsigned long *supported)
-{
-	/* Port5 supports ethier RGMII or SGMII.
-	 * Port6 supports SGMII only.
-	 */
-	if ((port == 5 || port == 6) &&
-	    interface == PHY_INTERFACE_MODE_2500BASEX) {
-		phylink_set(supported, 2500baseX_Full);
-		phylink_set(supported, 2500baseT_Full);
-	}
-}
-
 static void
 mt7531_sgmii_link_up_force(struct dsa_switch *ds, int port,
 			   unsigned int mode, phy_interface_t interface,
@@ -2897,52 +2883,22 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
 	priv->info->mac_port_get_caps(ds, port, config);
 }
 
-static void
-mt7530_mac_port_validate(struct dsa_switch *ds, int port,
-			 phy_interface_t interface,
-			 unsigned long *supported)
-{
-}
-
-static void mt7531_mac_port_validate(struct dsa_switch *ds, int port,
-				     phy_interface_t interface,
-				     unsigned long *supported)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	mt7531_sgmii_validate(priv, port, interface, supported);
-}
-
 static void
 mt753x_phylink_validate(struct dsa_switch *ds, int port,
 			unsigned long *supported,
 			struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct mt7530_priv *priv = ds->priv;
+	u32 caps;
+
+	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
 
 	phylink_set_port_modes(mask);
+	phylink_get_linkmodes(mask, state->interface, caps);
 
 	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
-	    !phy_interface_mode_is_8023z(state->interface)) {
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 100baseT_Full);
+	    !phy_interface_mode_is_8023z(state->interface))
 		phylink_set(mask, Autoneg);
-	}
-
-	/* This switch only supports 1G full-duplex. */
-	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_2500BASEX)
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-	}
-
-	priv->info->mac_port_validate(ds, port, state->interface, mask);
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
@@ -3143,7 +3099,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3154,7 +3109,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3166,7 +3120,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
-		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
 		.mac_port_config = mt7531_mac_config,
 		.mac_pcs_an_restart = mt7531_sgmii_restart_an,
@@ -3228,7 +3181,6 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
 	    !priv->info->phy_read || !priv->info->phy_write ||
 	    !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_validate ||
 	    !priv->info->mac_port_get_state || !priv->info->mac_port_config)
 		return -EINVAL;
 
-- 
2.30.2

