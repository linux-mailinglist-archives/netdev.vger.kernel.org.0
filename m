Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C774E380BB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfFFW3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:29:42 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:40120 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfFFW30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:29:26 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56MTHZE031404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 16:29:22 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56MTAPJ028001
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 16:29:17 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        davem@davemloft.net, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v5 20/20] net: axienet: convert to phylink API
Date:   Thu,  6 Jun 2019 16:28:24 -0600
Message-Id: <1559860104-927-21-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert this driver to use the phylink API rather than the legacy PHY
API. This allows for better support for SFP modules connected using a
1000BaseX or SGMII interface.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/Kconfig               |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |   5 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 286 ++++++++++++++--------
 3 files changed, 192 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 5f50764..8d994ce 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -27,7 +27,7 @@ config XILINX_EMACLITE
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
 	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
-	select PHYLIB
+	select PHYLINK
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
 	  AXI bus interface used in Xilinx Virtex FPGAs.
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 8e605a8..2dacfc8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/if_vlan.h>
+#include <linux/phylink.h>
 
 /* Packet size info */
 #define XAE_HDR_SIZE			14 /* Size of Ethernet header */
@@ -420,6 +421,9 @@ struct axienet_local {
 	/* Connection to PHY device */
 	struct device_node *phy_node;
 
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
+
 	/* Clock for AXI bus */
 	struct clk *clk;
 
@@ -439,7 +443,6 @@ struct axienet_local {
 	phy_interface_t phy_mode;
 
 	u32 options;			/* Current options word */
-	u32 last_link;
 	u32 features;
 
 	/* Buffer descriptors */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 898eabf..da420c8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2008-2009 Secret Lab Technologies Ltd.
  * Copyright (c) 2010 - 2011 Michal Simek <monstr@monstr.eu>
  * Copyright (c) 2010 - 2011 PetaLogix
+ * Copyright (c) 2019 SED Systems, a division of Calian Ltd.
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  *
  * This is a driver for the Xilinx Axi Ethernet which is used in the Virtex6
@@ -520,63 +521,6 @@ static void axienet_device_reset(struct net_device *ndev)
 }
 
 /**
- * axienet_adjust_link - Adjust the PHY link speed/duplex.
- * @ndev:	Pointer to the net_device structure
- *
- * This function is called to change the speed and duplex setting after
- * auto negotiation is done by the PHY. This is the function that gets
- * registered with the PHY interface through the "of_phy_connect" call.
- */
-static void axienet_adjust_link(struct net_device *ndev)
-{
-	u32 emmc_reg;
-	u32 link_state;
-	u32 setspeed = 1;
-	struct axienet_local *lp = netdev_priv(ndev);
-	struct phy_device *phy = ndev->phydev;
-
-	link_state = phy->speed | (phy->duplex << 1) | phy->link;
-	if (lp->last_link != link_state) {
-		if ((phy->speed == SPEED_10) || (phy->speed == SPEED_100)) {
-			if (lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX)
-				setspeed = 0;
-		} else {
-			if ((phy->speed == SPEED_1000) &&
-			    (lp->phy_mode == PHY_INTERFACE_MODE_MII))
-				setspeed = 0;
-		}
-
-		if (setspeed == 1) {
-			emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
-			emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
-
-			switch (phy->speed) {
-			case SPEED_1000:
-				emmc_reg |= XAE_EMMC_LINKSPD_1000;
-				break;
-			case SPEED_100:
-				emmc_reg |= XAE_EMMC_LINKSPD_100;
-				break;
-			case SPEED_10:
-				emmc_reg |= XAE_EMMC_LINKSPD_10;
-				break;
-			default:
-				dev_err(&ndev->dev, "Speed other than 10, 100 "
-					"or 1Gbps is not supported\n");
-				break;
-			}
-
-			axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
-			lp->last_link = link_state;
-			phy_print_status(phy);
-		} else {
-			netdev_err(ndev,
-				   "Error setting Axi Ethernet mac speed\n");
-		}
-	}
-}
-
-/**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
  * @ndev:	Pointer to the net_device structure
@@ -956,7 +900,8 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
  * Return: 0, on success.
  *	    non-zero error value on failure
  *
- * This is the driver open routine. It calls phy_start to start the PHY device.
+ * This is the driver open routine. It calls phylink_start to start the
+ * PHY device.
  * It also allocates interrupt service routines, enables the interrupt lines
  * and ISR handling. Axi Ethernet core is reset through Axi DMA core. Buffer
  * descriptors are initialized.
@@ -965,7 +910,6 @@ static int axienet_open(struct net_device *ndev)
 {
 	int ret;
 	struct axienet_local *lp = netdev_priv(ndev);
-	struct phy_device *phydev = NULL;
 
 	dev_dbg(&ndev->dev, "axienet_open()\n");
 
@@ -983,16 +927,14 @@ static int axienet_open(struct net_device *ndev)
 	if (ret < 0)
 		return ret;
 
-	if (lp->phy_node) {
-		phydev = of_phy_connect(lp->ndev, lp->phy_node,
-					axienet_adjust_link, 0, lp->phy_mode);
-
-		if (!phydev)
-			dev_err(lp->dev, "of_phy_connect() failed\n");
-		else
-			phy_start(phydev);
+	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
+	if (ret) {
+		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
+		return ret;
 	}
 
+	phylink_start(lp->phylink);
+
 	/* Enable tasklets for Axi DMA error handling */
 	tasklet_init(&lp->dma_err_tasklet, axienet_dma_err_handler,
 		     (unsigned long) lp);
@@ -1022,8 +964,8 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
-	if (phydev)
-		phy_disconnect(phydev);
+	phylink_stop(lp->phylink);
+	phylink_disconnect_phy(lp->phylink);
 	tasklet_kill(&lp->dma_err_tasklet);
 	dev_err(lp->dev, "request_irq() failed\n");
 	return ret;
@@ -1035,7 +977,7 @@ static int axienet_open(struct net_device *ndev)
  *
  * Return: 0, on success.
  *
- * This is the driver stop routine. It calls phy_disconnect to stop the PHY
+ * This is the driver stop routine. It calls phylink_disconnect to stop the PHY
  * device. It also removes the interrupt handlers and disables the interrupts.
  * The Axi DMA Tx/Rx BDs are released.
  */
@@ -1047,6 +989,9 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
+	phylink_stop(lp->phylink);
+	phylink_disconnect_phy(lp->phylink);
+
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
@@ -1087,9 +1032,6 @@ static int axienet_stop(struct net_device *ndev)
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
-	if (ndev->phydev)
-		phy_disconnect(ndev->phydev);
-
 	axienet_dma_bd_release(ndev);
 	return 0;
 }
@@ -1294,12 +1236,9 @@ static int axienet_ethtools_set_ringparam(struct net_device *ndev,
 axienet_ethtools_get_pauseparam(struct net_device *ndev,
 				struct ethtool_pauseparam *epauseparm)
 {
-	u32 regval;
 	struct axienet_local *lp = netdev_priv(ndev);
-	epauseparm->autoneg  = 0;
-	regval = axienet_ior(lp, XAE_FCC_OFFSET);
-	epauseparm->tx_pause = regval & XAE_FCC_FCTX_MASK;
-	epauseparm->rx_pause = regval & XAE_FCC_FCRX_MASK;
+
+	phylink_ethtool_get_pauseparam(lp->phylink, epauseparm);
 }
 
 /**
@@ -1318,27 +1257,9 @@ static int axienet_ethtools_set_ringparam(struct net_device *ndev,
 axienet_ethtools_set_pauseparam(struct net_device *ndev,
 				struct ethtool_pauseparam *epauseparm)
 {
-	u32 regval = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	if (netif_running(ndev)) {
-		netdev_err(ndev,
-			   "Please stop netif before applying configuration\n");
-		return -EFAULT;
-	}
-
-	regval = axienet_ior(lp, XAE_FCC_OFFSET);
-	if (epauseparm->tx_pause)
-		regval |= XAE_FCC_FCTX_MASK;
-	else
-		regval &= ~XAE_FCC_FCTX_MASK;
-	if (epauseparm->rx_pause)
-		regval |= XAE_FCC_FCRX_MASK;
-	else
-		regval &= ~XAE_FCC_FCRX_MASK;
-	axienet_iow(lp, XAE_FCC_OFFSET, regval);
-
-	return 0;
+	return phylink_ethtool_set_pauseparam(lp->phylink, epauseparm);
 }
 
 /**
@@ -1417,6 +1338,24 @@ static int axienet_ethtools_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
+static int
+axienet_ethtools_get_link_ksettings(struct net_device *ndev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(lp->phylink, cmd);
+}
+
+static int
+axienet_ethtools_set_link_ksettings(struct net_device *ndev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(lp->phylink, cmd);
+}
+
 static const struct ethtool_ops axienet_ethtool_ops = {
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
@@ -1428,8 +1367,141 @@ static int axienet_ethtools_set_coalesce(struct net_device *ndev,
 	.set_pauseparam = axienet_ethtools_set_pauseparam,
 	.get_coalesce   = axienet_ethtools_get_coalesce,
 	.set_coalesce   = axienet_ethtools_set_coalesce,
-	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings = axienet_ethtools_get_link_ksettings,
+	.set_link_ksettings = axienet_ethtools_set_link_ksettings,
+};
+
+static void axienet_validate(struct phylink_config *config,
+			     unsigned long *supported,
+			     struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	/* Only support the mode we are configured for */
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != lp->phy_mode) {
+		netdev_warn(ndev, "Cannot use PHY mode %s, supported: %s\n",
+			    phy_modes(state->interface),
+			    phy_modes(lp->phy_mode));
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, Pause);
+	phylink_set(mask, 1000baseX_Full);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int axienet_mac_link_state(struct phylink_config *config,
+				  struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	u32 emmc_reg, fcc_reg;
+
+	state->interface = lp->phy_mode;
+
+	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
+	if (emmc_reg & XAE_EMMC_LINKSPD_1000)
+		state->speed = SPEED_1000;
+	else if (emmc_reg & XAE_EMMC_LINKSPD_100)
+		state->speed = SPEED_100;
+	else
+		state->speed = SPEED_10;
+
+	state->pause = 0;
+	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
+	if (fcc_reg & XAE_FCC_FCTX_MASK)
+		state->pause |= MLO_PAUSE_TX;
+	if (fcc_reg & XAE_FCC_FCRX_MASK)
+		state->pause |= MLO_PAUSE_RX;
+
+	state->an_complete = 0;
+	state->duplex = 1;
+
+	return 1;
+}
+
+static void axienet_mac_an_restart(struct phylink_config *config)
+{
+	/* Unsupported, do nothing */
+}
+
+static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
+			       const struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	u32 emmc_reg, fcc_reg;
+
+	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
+	emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
+
+	switch (state->speed) {
+	case SPEED_1000:
+		emmc_reg |= XAE_EMMC_LINKSPD_1000;
+		break;
+	case SPEED_100:
+		emmc_reg |= XAE_EMMC_LINKSPD_100;
+		break;
+	case SPEED_10:
+		emmc_reg |= XAE_EMMC_LINKSPD_10;
+		break;
+	default:
+		dev_err(&ndev->dev,
+			"Speed other than 10, 100 or 1Gbps is not supported\n");
+		break;
+	}
+
+	axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
+
+	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
+	if (state->pause & MLO_PAUSE_TX)
+		fcc_reg |= XAE_FCC_FCTX_MASK;
+	else
+		fcc_reg &= ~XAE_FCC_FCTX_MASK;
+	if (state->pause & MLO_PAUSE_RX)
+		fcc_reg |= XAE_FCC_FCRX_MASK;
+	else
+		fcc_reg &= ~XAE_FCC_FCRX_MASK;
+	axienet_iow(lp, XAE_FCC_OFFSET, fcc_reg);
+}
+
+static void axienet_mac_link_down(struct phylink_config *config,
+				  unsigned int mode,
+				  phy_interface_t interface)
+{
+	/* nothing meaningful to do */
+}
+
+static void axienet_mac_link_up(struct phylink_config *config,
+				unsigned int mode,
+				phy_interface_t interface,
+				struct phy_device *phy)
+{
+	/* nothing meaningful to do */
+}
+
+static const struct phylink_mac_ops axienet_phylink_ops = {
+	.validate = axienet_validate,
+	.mac_link_state = axienet_mac_link_state,
+	.mac_an_restart = axienet_mac_an_restart,
+	.mac_config = axienet_mac_config,
+	.mac_link_down = axienet_mac_link_down,
+	.mac_link_up = axienet_mac_link_up,
 };
 
 /**
@@ -1777,6 +1849,18 @@ static int axienet_probe(struct platform_device *pdev)
 				 "error registering MDIO bus: %d\n", ret);
 	}
 
+	lp->phylink_config.dev = &ndev->dev;
+	lp->phylink_config.type = PHYLINK_NETDEV;
+
+	lp->phylink = phylink_create(&lp->phylink_config, pdev->dev.fwnode,
+				     lp->phy_mode,
+				     &axienet_phylink_ops);
+	if (IS_ERR(lp->phylink)) {
+		ret = PTR_ERR(lp->phylink);
+		dev_err(&pdev->dev, "phylink_create error (%i)\n", ret);
+		goto free_netdev;
+	}
+
 	ret = register_netdev(lp->ndev);
 	if (ret) {
 		dev_err(lp->dev, "register_netdev() error (%i)\n", ret);
@@ -1797,6 +1881,10 @@ static int axienet_remove(struct platform_device *pdev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+
+	if (lp->phylink)
+		phylink_destroy(lp->phylink);
+
 	axienet_mdio_teardown(lp);
 
 	if (lp->clk)
-- 
1.8.3.1

