Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8E4FB7FC
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbiDKJss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344717AbiDKJsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:48:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFDC40E4D
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WUM6eN8Sebq2C6LLAbV4fHi0LzbUd7CQJ/pB51j0pbk=; b=YsZOA6PVRICUOBd72VthmulVnP
        j7QgLSu1l8VRzNT9np1IISBMstTNzO9csO+y4vxvXDlYIcay5PKie9hjmsZnwiTwAWexwHt9AWqnE
        0qB5ZQVHqHKIUQ3Gz3BqD70RLDGqRSDT8l3w9s1dweqrDyLKBAJ880gvNeqnNq800Gir3dp1vmiBm
        YJQQEMG/Lg9QB8gLv1xgRujkjfXkE+gGgh8G/BgyaEYwtQBlkj2tgiFFrtHp/n2cu9VOjjMozDPrw
        9+cIqCU5K5stNm/yRHOaXS4qZenHgCabF25ObofEZR/tlXLq4M10Wx/Qpu97ActcGi0IKoWWcJoJ9
        FQERzrBw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52868 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ndqcp-0000HI-6F; Mon, 11 Apr 2022 10:46:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ndqco-0055RI-AJ; Mon, 11 Apr 2022 10:46:22 +0100
In-Reply-To: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
References: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
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
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v2 6/9] net: dsa: mt7530: switch to use
 phylink_get_linkmodes()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ndqco-0055RI-AJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 11 Apr 2022 10:46:22 +0100
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

Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 57 ++++------------------------------------
 1 file changed, 5 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index dfe3cd6d6b56..aa7f21683a07 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2521,19 +2521,6 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
 	return 0;
 }
 
-static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
-				  phy_interface_t interface,
-				  unsigned long *supported)
-{
-	/* Port5 supports ethier RGMII or SGMII.
-	 * Port6 supports SGMII only.
-	 */
-	if (port == 6 && interface == PHY_INTERFACE_MODE_2500BASEX) {
-		phylink_set(supported, 2500baseX_Full);
-		phylink_set(supported, 2500baseT_Full);
-	}
-}
-
 static void
 mt7531_sgmii_link_up_force(struct dsa_switch *ds, int port,
 			   unsigned int mode, phy_interface_t interface,
@@ -2901,52 +2888,22 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
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
-	    state->interface != PHY_INTERFACE_MODE_2500BASEX) {
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
@@ -3147,7 +3104,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3158,7 +3114,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.phy_write = mt7530_phy_write,
 		.pad_setup = mt7530_pad_clk_setup,
 		.mac_port_get_caps = mt7530_mac_port_get_caps,
-		.mac_port_validate = mt7530_mac_port_validate,
 		.mac_port_get_state = mt7530_phylink_mac_link_state,
 		.mac_port_config = mt7530_mac_config,
 	},
@@ -3170,7 +3125,6 @@ static const struct mt753x_info mt753x_table[] = {
 		.pad_setup = mt7531_pad_setup,
 		.cpu_port_config = mt7531_cpu_port_config,
 		.mac_port_get_caps = mt7531_mac_port_get_caps,
-		.mac_port_validate = mt7531_mac_port_validate,
 		.mac_port_get_state = mt7531_phylink_mac_link_state,
 		.mac_port_config = mt7531_mac_config,
 		.mac_pcs_an_restart = mt7531_sgmii_restart_an,
@@ -3232,7 +3186,6 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv->info->sw_setup || !priv->info->pad_setup ||
 	    !priv->info->phy_read || !priv->info->phy_write ||
 	    !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_validate ||
 	    !priv->info->mac_port_get_state || !priv->info->mac_port_config)
 		return -EINVAL;
 
-- 
2.30.2

