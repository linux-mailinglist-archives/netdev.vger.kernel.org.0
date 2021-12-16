Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D471E477227
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbhLPMst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhLPMst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:48:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA716C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WqfNmX9B59OERrWahqLWG+GXehGcMVWOc6HreW6Jnk4=; b=VYAWb90CwHerUANLO2uTzJ1kRV
        WluD95DEN1H8SaSe+P+x4CHzkpkV1iIbp1a5YqZ8Vh/dq5aA2p0956/ggmqlebmU87+ckzw3A4PH5
        4TUzkBKBpiRk/ZHgecGn0gy/tKe9VJ1v2wXCuiFRJHz00MAeE2GmmxHmHbgC2O0iP4Qk1pAJEQpDR
        oVialIdesfCI2tt/baSp1HmRB5KBhRR9JUl7YA1/H1SrZ9KKrYx3hwbtsJhEKUzaPRi63q03Ezvst
        211OPxT1j+qz10oS29Wm8Erl20glYl7R1B0R4WJcX2jMLTCw1/3iCJV2INuxz1Ucr5x5un6DswGuA
        oXxmS2bQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqBh-0007p8-Ip; Thu, 16 Dec 2021 12:48:45 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqBh-00GWxo-51; Thu, 16 Dec 2021 12:48:45 +0000
In-Reply-To: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 12:48:45 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert axienet to use the phylink_pcs layer, resulting in it no longer
being a legacy driver.

One oddity in this driver is that lp->switch_x_sgmii controls whether
we support switching between SGMII and 1000baseX. However, when clear,
this also blocks updating the 1000baseX advertisement, which it
probably should not be doing. Nevertheless, this behaviour is preserved
but a comment is added.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   1 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 112 +++++++++---------
 2 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 5b4d153b1492..81f09bd8f11c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -434,6 +434,7 @@ struct axienet_local {
 	struct phylink_config phylink_config;
 
 	struct mdio_device *pcs_phy;
+	struct phylink_pcs pcs;
 
 	bool switch_x_sgmii;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 23ac353b35fe..5edc8ec72317 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1509,78 +1509,80 @@ static const struct ethtool_ops axienet_ethtool_ops = {
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
-				    XLNX_MII_STD_SELECT_REG,
-				    iface == PHY_INTERFACE_MODE_SGMII ?
-					XLNX_MII_STD_SELECT_SGMII : 0);
-		if (ret < 0)
-			netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
-				    ret);
-		return ret;
-	default:
+	/* We don't support changing the advertisement in 1000base-X? --rmk */
+	if (!lp->switch_x_sgmii)
 		return 0;
+
+	ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
+			    XLNX_MII_STD_SELECT_REG,
+			    interface == PHY_INTERFACE_MODE_SGMII ?
+				XLNX_MII_STD_SELECT_SGMII : 0);
+	if (ret < 0) {
+		netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
+			    ret);
+		return ret;
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
@@ -1635,9 +1637,7 @@ static void axienet_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = phylink_generic_validate,
-	.mac_pcs_get_state = axienet_mac_pcs_get_state,
-	.mac_an_restart = axienet_mac_an_restart,
-	.mac_prepare = axienet_mac_prepare,
+	.mac_select_pcs = axienet_mac_select_pcs,
 	.mac_config = axienet_mac_config,
 	.mac_link_down = axienet_mac_link_down,
 	.mac_link_up = axienet_mac_link_up,
@@ -2046,12 +2046,12 @@ static int axienet_probe(struct platform_device *pdev)
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

