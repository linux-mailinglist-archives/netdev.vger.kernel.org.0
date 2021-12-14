Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4611F474E90
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbhLNX3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbhLNX3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:29:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DB2C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 15:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OUaYmfK3e6emXI/QF7xFCey7AfSxASdhwImkSRwcsTQ=; b=s1dGf0510JgzgdQuAPWGig1szT
        9zHYduw7za+yq4FrYoy/g3umniRdvt992SfEkV8OqEebdKDACji58C7fXiT5Y4ss7heM7/7BTf7kO
        XNYCkOS6AMMyRRmFg6v5QlNlRo//SC/YSQVrhmXWtoabBGWX7h0y3sWgJh1WuKVXrcLMiBdtPcLDJ
        AeLIdDoAid6MY4RonLPat8IXEWbaIgw7aRJJukPE0tlKnZ+5ZclNVp6qsOWGDaKH8PH0AVfu6CLID
        sGRWj+Wbb3bOAgTYhYIxo6aWhKorZPT5qnEG3YWd1OVS37IA0z0yJi1FXU8RwBLvEdUHxTcfFFRiZ
        ByOrSw/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56286)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxHEJ-0005Xb-04; Tue, 14 Dec 2021 23:29:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxHEI-0003uj-Ae; Tue, 14 Dec 2021 23:29:06 +0000
Date:   Tue, 14 Dec 2021 23:29:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
Message-ID: <Ybkowi4KJpL+gIsk@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
 <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:27:22PM +0000, Russell King (Oracle) wrote:
> I already have a conversion for axienet in my tree, and it doesn't
> need a pcs_validate() implementation. I'll provide it below.

Forgot to do so... this is obviously untested on real hardware.

8<===
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: axienet: convert to phylink_pcs

Convert axienet to use the phylink_pcs layer, resulting in it no longer
being a legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   1 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 109 +++++++++---------
 2 files changed, 53 insertions(+), 57 deletions(-)

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
index 25082ff3794b..8d90e887c3e5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1503,78 +1503,75 @@ static const struct ethtool_ops axienet_ethtool_ops = {
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
+static int axienet_pcs_config(struct phylink_config *pcs, unsigned int mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising,
+			      bool permit_pause_to_mac)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct axienet_local *lp = netdev_priv(ndev);
+	struct net_device *ndev = pcs_to_axienet_local(pcs)->ndev;
+	struct mdio_device *pcs_phy = pcs_to_axienet_local(pcs)->pcs_phy;
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
+	ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
+			    XLNX_MII_STD_SELECT_REG,
+			    iface == PHY_INTERFACE_MODE_SGMII ?
+				XLNX_MII_STD_SELECT_SGMII : 0);
+	if (ret < 0) {
+		netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
+			    ret);
 		return ret;
-	default:
-		return 0;
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
@@ -1629,9 +1626,7 @@ static void axienet_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = phylink_generic_validate,
-	.mac_pcs_get_state = axienet_mac_pcs_get_state,
-	.mac_an_restart = axienet_mac_an_restart,
-	.mac_prepare = axienet_mac_prepare,
+	.mac_select_pcs = axienet_mac_select_pcs,
 	.mac_config = axienet_mac_config,
 	.mac_link_down = axienet_mac_link_down,
 	.mac_link_up = axienet_mac_link_up,
@@ -2040,12 +2035,12 @@ static int axienet_probe(struct platform_device *pdev)
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

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
