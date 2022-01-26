Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583349C769
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiAZK0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiAZK0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:26:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BFDC061744
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SxV6MEidsNrDqxVFztSU3MTwCS6TFyU1H74j+sCqsMs=; b=rNwW55X6tOdTiiMcNBYLGq+I2y
        vb+ge4DhkspSfwKNfq2mFq39bOIoBOhyUljXW8mrGXjG7yP1F9ys861/VDWNJ8dOrwkC6vaPk7wdm
        xXsT98eOpX8Gb6Qxg+ZLmlGahCU8sVdV2/rIXgVn4cbwHLxYUJ0x3JHvqjdUI/W0vfD7sqqMMLWu1
        RsHX2o3MlTwGHzCs77Kf6l7pfi2yAeRhUBDptZAp+SFD3v/zbX2BSkZJsvl7W8iiEMHNS8d7eLIjP
        sqt/L/xLUlVMNtkvsemFn5fEZLXN19kdsqUZWHnT1tdSlionVpbUMsPZqfvS9B4yo4W5ONfUib5bC
        u6LVB+XQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35154 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCfV2-00038Q-Rj; Wed, 26 Jan 2022 10:26:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCfV2-005Rd0-8V; Wed, 26 Jan 2022 10:26:00 +0000
In-Reply-To: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
References: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: stmmac: convert to
 phylink_get_linkmodes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCfV2-005Rd0-8V@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 26 Jan 2022 10:26:00 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the MAC speed, duplex and pause capabilities to the phylink_config
structure, and switch stmmac_validate() to use phylink_get_linkmodes()
to generate the mask of supported ethtool link modes.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 125 ++++++------------
 1 file changed, 42 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6708ca2aa4f7..e85ca75d394d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -942,95 +942,22 @@ static void stmmac_validate(struct phylink_config *config,
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mac_supported) = { 0, };
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	int tx_cnt = priv->plat->tx_queues_to_use;
-	int max_speed = priv->plat->max_speed;
-
-	phylink_set(mac_supported, 10baseT_Half);
-	phylink_set(mac_supported, 10baseT_Full);
-	phylink_set(mac_supported, 100baseT_Half);
-	phylink_set(mac_supported, 100baseT_Full);
-	phylink_set(mac_supported, 1000baseT_Half);
-	phylink_set(mac_supported, 1000baseT_Full);
-	phylink_set(mac_supported, 1000baseKX_Full);
 
+	/* This is very similar to phylink_generic_validate() except that
+	 * we always use PHY_INTERFACE_MODE_INTERNAL to get all capabilities.
+	 * This is because we don't always have config->supported_interfaces
+	 * populated (only when we have the XPCS.)
+	 *
+	 * When we do have an XPCS, we could pass state->interface, as XPCS
+	 * limits to a subset of the ethtool link modes allowed here.
+	 */
 	phylink_set(mac_supported, Autoneg);
-	phylink_set(mac_supported, Pause);
-	phylink_set(mac_supported, Asym_Pause);
 	phylink_set_port_modes(mac_supported);
-
-	/* Cut down 1G if asked to */
-	if ((max_speed > 0) && (max_speed < 1000)) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-	} else if (priv->plat->has_gmac4) {
-		if (!max_speed || max_speed >= 2500) {
-			phylink_set(mac_supported, 2500baseT_Full);
-			phylink_set(mac_supported, 2500baseX_Full);
-		}
-	} else if (priv->plat->has_xgmac) {
-		if (!max_speed || (max_speed >= 2500)) {
-			phylink_set(mac_supported, 2500baseT_Full);
-			phylink_set(mac_supported, 2500baseX_Full);
-		}
-		if (!max_speed || (max_speed >= 5000)) {
-			phylink_set(mac_supported, 5000baseT_Full);
-		}
-		if (!max_speed || (max_speed >= 10000)) {
-			phylink_set(mac_supported, 10000baseSR_Full);
-			phylink_set(mac_supported, 10000baseLR_Full);
-			phylink_set(mac_supported, 10000baseER_Full);
-			phylink_set(mac_supported, 10000baseLRM_Full);
-			phylink_set(mac_supported, 10000baseT_Full);
-			phylink_set(mac_supported, 10000baseKX4_Full);
-			phylink_set(mac_supported, 10000baseKR_Full);
-		}
-		if (!max_speed || (max_speed >= 25000)) {
-			phylink_set(mac_supported, 25000baseCR_Full);
-			phylink_set(mac_supported, 25000baseKR_Full);
-			phylink_set(mac_supported, 25000baseSR_Full);
-		}
-		if (!max_speed || (max_speed >= 40000)) {
-			phylink_set(mac_supported, 40000baseKR4_Full);
-			phylink_set(mac_supported, 40000baseCR4_Full);
-			phylink_set(mac_supported, 40000baseSR4_Full);
-			phylink_set(mac_supported, 40000baseLR4_Full);
-		}
-		if (!max_speed || (max_speed >= 50000)) {
-			phylink_set(mac_supported, 50000baseCR2_Full);
-			phylink_set(mac_supported, 50000baseKR2_Full);
-			phylink_set(mac_supported, 50000baseSR2_Full);
-			phylink_set(mac_supported, 50000baseKR_Full);
-			phylink_set(mac_supported, 50000baseSR_Full);
-			phylink_set(mac_supported, 50000baseCR_Full);
-			phylink_set(mac_supported, 50000baseLR_ER_FR_Full);
-			phylink_set(mac_supported, 50000baseDR_Full);
-		}
-		if (!max_speed || (max_speed >= 100000)) {
-			phylink_set(mac_supported, 100000baseKR4_Full);
-			phylink_set(mac_supported, 100000baseSR4_Full);
-			phylink_set(mac_supported, 100000baseCR4_Full);
-			phylink_set(mac_supported, 100000baseLR4_ER4_Full);
-			phylink_set(mac_supported, 100000baseKR2_Full);
-			phylink_set(mac_supported, 100000baseSR2_Full);
-			phylink_set(mac_supported, 100000baseCR2_Full);
-			phylink_set(mac_supported, 100000baseLR2_ER2_FR2_Full);
-			phylink_set(mac_supported, 100000baseDR2_Full);
-		}
-	}
-
-	/* Half-Duplex can only work with single queue */
-	if (tx_cnt > 1) {
-		phylink_set(mask, 10baseT_Half);
-		phylink_set(mask, 100baseT_Half);
-		phylink_set(mask, 1000baseT_Half);
-	}
+	phylink_get_linkmodes(mac_supported, PHY_INTERFACE_MODE_INTERNAL,
+			      config->mac_capabilities);
 
 	linkmode_and(supported, supported, mac_supported);
-	linkmode_andnot(supported, supported, mask);
-
 	linkmode_and(state->advertising, state->advertising, mac_supported);
-	linkmode_andnot(state->advertising, state->advertising, mask);
 
 	/* If PCS is supported, check which modes it supports. */
 	if (priv->hw->xpcs)
@@ -1253,6 +1180,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
+	int max_speed = priv->plat->max_speed;
 	int mode = priv->plat->phy_interface;
 	struct phylink *phylink;
 
@@ -1266,6 +1194,37 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
+	priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100;
+
+	if (!max_speed || max_speed >= 1000)
+		priv->phylink_config.mac_capabilities |= MAC_1000;
+
+	if (priv->plat->has_gmac4) {
+		if (!max_speed || max_speed >= 2500)
+			priv->phylink_config.mac_capabilities |= MAC_2500FD;
+	} else if (priv->plat->has_xgmac) {
+		if (!max_speed || max_speed >= 2500)
+			priv->phylink_config.mac_capabilities |= MAC_2500FD;
+		if (!max_speed || max_speed >= 5000)
+			priv->phylink_config.mac_capabilities |= MAC_5000FD;
+		if (!max_speed || max_speed >= 10000)
+			priv->phylink_config.mac_capabilities |= MAC_10000FD;
+		if (!max_speed || max_speed >= 25000)
+			priv->phylink_config.mac_capabilities |= MAC_25000FD;
+		if (!max_speed || max_speed >= 40000)
+			priv->phylink_config.mac_capabilities |= MAC_40000FD;
+		if (!max_speed || max_speed >= 50000)
+			priv->phylink_config.mac_capabilities |= MAC_50000FD;
+		if (!max_speed || max_speed >= 100000)
+			priv->phylink_config.mac_capabilities |= MAC_100000FD;
+	}
+
+	/* Half-Duplex can only work with single queue */
+	if (priv->plat->tx_queues_to_use > 1)
+		priv->phylink_config.mac_capabilities &=
+			~(MAC_10HD | MAC_100HD | MAC_1000HD);
+
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
 	if (IS_ERR(phylink))
-- 
2.30.2

