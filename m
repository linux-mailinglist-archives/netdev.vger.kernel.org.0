Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73B49B858
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353316AbiAYQOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583336AbiAYQKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:10:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C2C061751
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kZAucxWme1YLxQcY4VUTnY4v48zSYEh8OPpmbYcTVZw=; b=WFDjKj1kFHkO4/0PwkAa9CxPyR
        XVD/JZA8THD8+1dlVH3r+KJ5XK+AZdIWTJ0hzz7PcwiGsicEZHCAHS3c6yzjE/gvqw2ODQjevfvNA
        2/JNSP888FLbHIAtzt1QPMilxF7Nl8g869T2/4tUmK9oQoTx6pwq/qYabvQ1oc0AMHhnS5Rjl874G
        RfECgQBB51ULYrPGJ6jAzNatFg6SJmbX9H1UhYkJrEBLVOKcDqbvJ6+koiizR10Sp5XBp0nEoBrhC
        zM4fQjd86vkeHfHYxtlpWbX8amfLLXruBgEVbMbsNH248cG+gHxQr4LxEze/Kl/2YXpdZ2AN74Pji
        s7+Y+q6Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57222 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOOa-000280-4D; Tue, 25 Jan 2022 16:10:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOOZ-005L8t-F1; Tue, 25 Jan 2022 16:10:11 +0000
In-Reply-To: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
References: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/2] net: axienet: convert to phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOOZ-005L8t-F1@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:10:11 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert axienet to use the phylink_pcs layer, resulting in it no longer
being a legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   2 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 107 +++++++++---------
 2 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 5b4d153b1492..40108968b350 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -386,6 +386,7 @@ struct axidma_bd {
  * @phylink:	Pointer to phylink instance
  * @phylink_config: phylink configuration settings
  * @pcs_phy:	Reference to PCS/PMA PHY if used
+ * @pcs:	phylink pcs structure for PCS PHY
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
  * @axi_clk:	AXI4-Lite bus clock
  * @misc_clks:	Misc ethernet clocks (AXI4-Stream, Ref, MGT clocks)
@@ -434,6 +435,7 @@ struct axienet_local {
 	struct phylink_config phylink_config;
 
 	struct mdio_device *pcs_phy;
+	struct phylink_pcs pcs;
 
 	bool switch_x_sgmii;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 377c94ec2486..1ebdf1c62db8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1537,78 +1537,79 @@ static const struct ethtool_ops axienet_ethtool_ops = {
 	.nway_reset	= axienet_ethtools_nway_reset,
 };
 
-static void axienet_mac_pcs_get_state(struct phylink_config *config,
-				      struct phylink_link_state *state)
+static struct axienet_local *pcs_to_axienet_local(struct phylink_pcs *pcs)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct axienet_local *lp = netdev_priv(ndev);
+	return container_of(pcs, struct axienet_local, pcs);
+}
 
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-		phylink_mii_c22_pcs_get_state(lp->pcs_phy, state);
-		break;
-	default:
-		break;
-	}
+static void axienet_pcs_get_state(struct phylink_pcs *pcs,
+				  struct phylink_link_state *state)
+{
+	struct mdio_device *pcs_phy = pcs_to_axienet_local(pcs)->pcs_phy;
+
+	phylink_mii_c22_pcs_get_state(pcs_phy, state);
 }
 
-static void axienet_mac_an_restart(struct phylink_config *config)
+static void axienet_pcs_an_restart(struct phylink_pcs *pcs)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct axienet_local *lp = netdev_priv(ndev);
+	struct mdio_device *pcs_phy = pcs_to_axienet_local(pcs)->pcs_phy;
 
-	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);
+	phylink_mii_c22_pcs_an_restart(pcs_phy);
 }
 
-static int axienet_mac_prepare(struct phylink_config *config, unsigned int mode,
-			       phy_interface_t iface)
+static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising,
+			      bool permit_pause_to_mac)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
+	struct mdio_device *pcs_phy = pcs_to_axienet_local(pcs)->pcs_phy;
+	struct net_device *ndev = pcs_to_axienet_local(pcs)->ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
 	int ret;
 
-	switch (iface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-		if (!lp->switch_x_sgmii)
-			return 0;
-
-		ret = mdiobus_write(lp->pcs_phy->bus,
-				    lp->pcs_phy->addr,
+	if (lp->switch_x_sgmii) {
+		ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
 				    XLNX_MII_STD_SELECT_REG,
-				    iface == PHY_INTERFACE_MODE_SGMII ?
+				    interface == PHY_INTERFACE_MODE_SGMII ?
 					XLNX_MII_STD_SELECT_SGMII : 0);
-		if (ret < 0)
-			netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
+		if (ret < 0) {
+			netdev_warn(ndev,
+				    "Failed to switch PHY interface: %d\n",
 				    ret);
-		return ret;
-	default:
-		return 0;
+			return ret;
+		}
 	}
+
+	ret = phylink_mii_c22_pcs_config(pcs_phy, mode, interface, advertising);
+	if (ret < 0)
+		netdev_warn(ndev, "Failed to configure PCS: %d\n", ret);
+
+	return ret;
 }
 
-static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
-			       const struct phylink_link_state *state)
+static const struct phylink_pcs_ops axienet_pcs_ops = {
+	.pcs_get_state = axienet_pcs_get_state,
+	.pcs_config = axienet_pcs_config,
+	.pcs_an_restart = axienet_pcs_an_restart,
+};
+
+static struct phylink_pcs *axienet_mac_select_pcs(struct phylink_config *config,
+						  phy_interface_t interface)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
-	int ret;
 
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-		ret = phylink_mii_c22_pcs_config(lp->pcs_phy, mode,
-						 state->interface,
-						 state->advertising);
-		if (ret < 0)
-			netdev_warn(ndev, "Failed to configure PCS: %d\n",
-				    ret);
-		break;
+	if (interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    interface ==  PHY_INTERFACE_MODE_SGMII)
+		return &lp->pcs;
 
-	default:
-		break;
-	}
+	return NULL;
+}
+
+static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
+			       const struct phylink_link_state *state)
+{
+	/* nothing meaningful to do */
 }
 
 static void axienet_mac_link_down(struct phylink_config *config,
@@ -1663,9 +1664,7 @@ static void axienet_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = phylink_generic_validate,
-	.mac_pcs_get_state = axienet_mac_pcs_get_state,
-	.mac_an_restart = axienet_mac_an_restart,
-	.mac_prepare = axienet_mac_prepare,
+	.mac_select_pcs = axienet_mac_select_pcs,
 	.mac_config = axienet_mac_config,
 	.mac_link_down = axienet_mac_link_down,
 	.mac_link_up = axienet_mac_link_up,
@@ -2079,12 +2078,12 @@ static int axienet_probe(struct platform_device *pdev)
 			ret = -EPROBE_DEFER;
 			goto cleanup_mdio;
 		}
-		lp->phylink_config.pcs_poll = true;
+		lp->pcs.ops = &axienet_pcs_ops;
+		lp->pcs.poll = true;
 	}
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
-	lp->phylink_config.legacy_pre_march2020 = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.30.2

