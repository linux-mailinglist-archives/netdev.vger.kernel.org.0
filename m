Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51F35DEE
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfFENan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:30:43 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:55080 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbfFENam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:30:42 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 81AD5C017A;
        Wed,  5 Jun 2019 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559741421; bh=uZE9cHnxsxNz8RvY8IHxgSwCvz85coVuY0Roy+L3bSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Wyy0K8N22R2UzDNdAhTaNyqEJWdZqArRYwIc+j8p5EHm1KlzuOfbSD480FV4d2RgG
         5b1sB9LfS31tyJLIfhk0nQfcsGxs1bUofimFcY/WAEE9bPBRB1bPmOqZ1oVU1vsELp
         DpJ2eCQzfm5Kaolm+ZFuZ96Ap+OSMhh1Gg8D1wBe2dV6IfFfnPBKO9HdUkfu+DM7Si
         Z9LYCyodLhE2Qkp0TsLqT0xKVjv0c3zy5ymFfVhv3Gzbs+EZhefMNXCBnWdDzKnxe/
         E4SIp85F61RZ9RoRr1S2mJiExErftteDGXQ7LkV9b3hX7DvtDYZLT+t0KUnbeTCaZR
         x+ZOegJ9zGevA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 45821A0234;
        Wed,  5 Jun 2019 13:30:39 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 0CCF83FECC;
        Wed,  5 Jun 2019 15:30:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [RFC net-next 2/2] net: stmmac: Convert to phylink
Date:   Wed,  5 Jun 2019 15:30:29 +0200
Message-Id: <2528141fcc644205dc1c0a0f2640da1a0e7d5935.1559741195.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559741195.git.joabreu@synopsys.com>
References: <cover.1559741195.git.joabreu@synopsys.com>
In-Reply-To: <cover.1559741195.git.joabreu@synopsys.com>
References: <cover.1559741195.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stmmac driver to phylink.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  72 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 392 ++++++++-------------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  21 +-
 5 files changed, 175 insertions(+), 317 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 0b5c8d74c683..c43e2da4e7e3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -3,7 +3,7 @@ config STMMAC_ETH
 	tristate "STMicroelectronics 10/100/1000/EQOS Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
-	select PHYLIB
+	select PHYLINK
 	select CRC32
 	imply PTP_1588_CLOCK
 	select RESET_CONTROLLER
@@ -41,7 +41,6 @@ if STMMAC_PLATFORM
 
 config DWMAC_DWC_QOS_ETH
 	tristate "Support for snps,dwc-qos-ethernet.txt DT binding."
-	select PHYLIB
 	select CRC32
 	select MII
 	depends on OF && HAS_DMA
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index a16ada8b8507..9d5cf10f48f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -24,7 +24,7 @@
 
 #include <linux/clk.h>
 #include <linux/stmmac.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/pci.h>
 #include "common.h"
 #include <linux/ptp_clock_kernel.h>
@@ -154,6 +154,8 @@ struct stmmac_priv {
 	unsigned int pause;
 	struct mii_bus *mii;
 	int mii_irq[PHY_MAX_ADDR];
+	struct phylink_config phylink_config;
+	struct phylink *phylink;
 
 	struct stmmac_extra_stats xstats ____cacheline_aligned_in_smp;
 	struct stmmac_safety_stats sstats;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index cec51ba34296..09b08c14da90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -22,7 +22,7 @@
 #include <linux/ethtool.h>
 #include <linux/interrupt.h>
 #include <linux/mii.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/net_tstamp.h>
 #include <asm/io.h>
 
@@ -274,7 +274,6 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 					     struct ethtool_link_ksettings *cmd)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	struct phy_device *phy = dev->phydev;
 
 	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
 	    priv->hw->pcs & STMMAC_PCS_SGMII) {
@@ -353,17 +352,7 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 		return 0;
 	}
 
-	if (phy == NULL) {
-		pr_err("%s: %s: PHY is not registered\n",
-		       __func__, dev->name);
-		return -ENODEV;
-	}
-	if (!netif_running(dev)) {
-		pr_err("%s: interface is disabled: we cannot track "
-		"link speed / duplex setting\n", dev->name);
-		return -EBUSY;
-	}
-	phy_ethtool_ksettings_get(phy, cmd);
+	phylink_ethtool_ksettings_get(priv->phylink, cmd);
 	return 0;
 }
 
@@ -372,8 +361,6 @@ stmmac_ethtool_set_link_ksettings(struct net_device *dev,
 				  const struct ethtool_link_ksettings *cmd)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	struct phy_device *phy = dev->phydev;
-	int rc;
 
 	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
 	    priv->hw->pcs & STMMAC_PCS_SGMII) {
@@ -397,9 +384,7 @@ stmmac_ethtool_set_link_ksettings(struct net_device *dev,
 		return 0;
 	}
 
-	rc = phy_ethtool_ksettings_set(phy, cmd);
-
-	return rc;
+	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
 }
 
 static u32 stmmac_ethtool_getmsglevel(struct net_device *dev)
@@ -443,6 +428,13 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	       NUM_DWMAC1000_DMA_REGS * 4);
 }
 
+static int stmmac_nway_reset(struct net_device *netdev)
+{
+	struct stmmac_priv *priv = netdev_priv(netdev);
+
+	return phylink_ethtool_nway_reset(priv->phylink);
+}
+
 static void
 stmmac_get_pauseparam(struct net_device *netdev,
 		      struct ethtool_pauseparam *pause)
@@ -450,28 +442,18 @@ stmmac_get_pauseparam(struct net_device *netdev,
 	struct stmmac_priv *priv = netdev_priv(netdev);
 	struct rgmii_adv adv_lp;
 
-	pause->rx_pause = 0;
-	pause->tx_pause = 0;
-
 	if (priv->hw->pcs && !stmmac_pcs_get_adv_lp(priv, priv->ioaddr, &adv_lp)) {
 		pause->autoneg = 1;
 		if (!adv_lp.pause)
 			return;
 	} else {
-		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				       netdev->phydev->supported) ||
-		    !linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				      netdev->phydev->supported))
-			return;
+		phylink_ethtool_get_pauseparam(priv->phylink, pause);
 	}
 
-	pause->autoneg = netdev->phydev->autoneg;
-
 	if (priv->flow_ctrl & FLOW_RX)
 		pause->rx_pause = 1;
 	if (priv->flow_ctrl & FLOW_TX)
 		pause->tx_pause = 1;
-
 }
 
 static int
@@ -479,9 +461,6 @@ stmmac_set_pauseparam(struct net_device *netdev,
 		      struct ethtool_pauseparam *pause)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
-	u32 tx_cnt = priv->plat->tx_queues_to_use;
-	struct phy_device *phy = netdev->phydev;
-	int new_pause = FLOW_OFF;
 	struct rgmii_adv adv_lp;
 
 	if (priv->hw->pcs && !stmmac_pcs_get_adv_lp(priv, priv->ioaddr, &adv_lp)) {
@@ -489,28 +468,9 @@ stmmac_set_pauseparam(struct net_device *netdev,
 		if (!adv_lp.pause)
 			return -EOPNOTSUPP;
 	} else {
-		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				       phy->supported) ||
-		    !linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				      phy->supported))
-			return -EOPNOTSUPP;
-	}
-
-	if (pause->rx_pause)
-		new_pause |= FLOW_RX;
-	if (pause->tx_pause)
-		new_pause |= FLOW_TX;
-
-	priv->flow_ctrl = new_pause;
-	phy->autoneg = pause->autoneg;
-
-	if (phy->autoneg) {
-		if (netif_running(netdev))
-			return phy_start_aneg(phy);
+		return phylink_ethtool_set_pauseparam(priv->phylink, pause);
 	}
 
-	stmmac_flow_ctrl(priv, priv->hw, phy->duplex, priv->flow_ctrl,
-			priv->pause, tx_cnt);
 	return 0;
 }
 
@@ -549,7 +509,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 			}
 		}
 		if (priv->eee_enabled) {
-			int val = phy_get_eee_err(dev->phydev);
+			int val = phylink_get_eee_err(priv->phylink);
 			if (val)
 				priv->xstats.phy_eee_wakeup_error_n = val;
 		}
@@ -694,7 +654,7 @@ static int stmmac_ethtool_op_get_eee(struct net_device *dev,
 	edata->eee_active = priv->eee_active;
 	edata->tx_lpi_timer = priv->tx_lpi_timer;
 
-	return phy_ethtool_get_eee(dev->phydev, edata);
+	return phylink_ethtool_get_eee(priv->phylink, edata);
 }
 
 static int stmmac_ethtool_op_set_eee(struct net_device *dev,
@@ -715,7 +675,7 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 			return -EOPNOTSUPP;
 	}
 
-	ret = phy_ethtool_set_eee(dev->phydev, edata);
+	ret = phylink_ethtool_set_eee(priv->phylink, edata);
 	if (ret)
 		return ret;
 
@@ -892,7 +852,7 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.get_regs = stmmac_ethtool_gregs,
 	.get_regs_len = stmmac_ethtool_get_regs_len,
 	.get_link = ethtool_op_get_link,
-	.nway_reset = phy_ethtool_nway_reset,
+	.nway_reset = stmmac_nway_reset,
 	.get_pauseparam = stmmac_get_pauseparam,
 	.set_pauseparam = stmmac_set_pauseparam,
 	.self_test = stmmac_selftest_run,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6a2f072c0ce3..94ebb165f3f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -45,6 +45,7 @@
 #include <linux/seq_file.h>
 #endif /* CONFIG_DEBUG_FS */
 #include <linux/net_tstamp.h>
+#include <linux/phylink.h>
 #include <net/pkt_cls.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
@@ -328,21 +329,6 @@ static inline u32 stmmac_rx_dirty(struct stmmac_priv *priv, u32 queue)
 }
 
 /**
- * stmmac_hw_fix_mac_speed - callback for speed selection
- * @priv: driver private structure
- * Description: on some platforms (e.g. ST), some HW system configuration
- * registers have to be set according to the link speed negotiated.
- */
-static inline void stmmac_hw_fix_mac_speed(struct stmmac_priv *priv)
-{
-	struct net_device *ndev = priv->dev;
-	struct phy_device *phydev = ndev->phydev;
-
-	if (likely(priv->plat->fix_mac_speed))
-		priv->plat->fix_mac_speed(priv->plat->bsp_priv, phydev->speed);
-}
-
-/**
  * stmmac_enable_eee_mode - check and enter in LPI mode
  * @priv: driver private structure
  * Description: this function is to verify and enter in LPI mode in case of
@@ -405,14 +391,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
  */
 bool stmmac_eee_init(struct stmmac_priv *priv)
 {
-	struct net_device *ndev = priv->dev;
-	int interface = priv->plat->interface;
-	bool ret = false;
-
-	if ((interface != PHY_INTERFACE_MODE_MII) &&
-	    (interface != PHY_INTERFACE_MODE_GMII) &&
-	    !phy_interface_mode_is_rgmii(interface))
-		goto out;
+	int tx_lpi_timer = priv->tx_lpi_timer;
 
 	/* Using PCS we cannot dial with the phy registers at this stage
 	 * so we do not support extra feature like EEE.
@@ -420,52 +399,33 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	if ((priv->hw->pcs == STMMAC_PCS_RGMII) ||
 	    (priv->hw->pcs == STMMAC_PCS_TBI) ||
 	    (priv->hw->pcs == STMMAC_PCS_RTBI))
-		goto out;
+		return false;
 
 	/* MAC core supports the EEE feature. */
-	if (priv->dma_cap.eee) {
-		int tx_lpi_timer = priv->tx_lpi_timer;
-
-		/* Check if the PHY supports EEE */
-		if (phy_init_eee(ndev->phydev, 1)) {
-			/* To manage at run-time if the EEE cannot be supported
-			 * anymore (for example because the lp caps have been
-			 * changed).
-			 * In that case the driver disable own timers.
-			 */
-			mutex_lock(&priv->lock);
-			if (priv->eee_active) {
-				netdev_dbg(priv->dev, "disable EEE\n");
-				del_timer_sync(&priv->eee_ctrl_timer);
-				stmmac_set_eee_timer(priv, priv->hw, 0,
-						tx_lpi_timer);
-			}
-			priv->eee_active = 0;
-			mutex_unlock(&priv->lock);
-			goto out;
-		}
-		/* Activate the EEE and start timers */
-		mutex_lock(&priv->lock);
-		if (!priv->eee_active) {
-			priv->eee_active = 1;
-			timer_setup(&priv->eee_ctrl_timer,
-				    stmmac_eee_ctrl_timer, 0);
-			mod_timer(&priv->eee_ctrl_timer,
-				  STMMAC_LPI_T(eee_timer));
-
-			stmmac_set_eee_timer(priv, priv->hw,
-					STMMAC_DEFAULT_LIT_LS, tx_lpi_timer);
-		}
-		/* Set HW EEE according to the speed */
-		stmmac_set_eee_pls(priv, priv->hw, ndev->phydev->link);
+	if (!priv->dma_cap.eee)
+		return false;
 
-		ret = true;
-		mutex_unlock(&priv->lock);
+	mutex_lock(&priv->lock);
 
-		netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
+	/* Check if it needs to be deactivated */
+	if (!priv->eee_active && priv->eee_enabled) {
+		netdev_dbg(priv->dev, "disable EEE\n");
+		del_timer_sync(&priv->eee_ctrl_timer);
+		stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+		return false;
 	}
-out:
-	return ret;
+
+	if (priv->eee_active && !priv->eee_enabled) {
+		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
+				     tx_lpi_timer);
+	}
+
+	mutex_unlock(&priv->lock);
+
+	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
+	return true;
 }
 
 /* stmmac_get_tx_hwtstamp - get HW TX timestamps
@@ -848,126 +808,108 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
 			priv->pause, tx_cnt);
 }
 
-static void stmmac_mac_config(struct net_device *dev)
+static void stmmac_validate(struct phylink_config *config,
+			    unsigned long *supported,
+			    struct phylink_link_state *state)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
-	u32 ctrl;
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	int tx_cnt = priv->plat->tx_queues_to_use;
+	int max_speed = priv->plat->max_speed;
 
-	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+	if ((max_speed > 0) && (max_speed < 1000)) {
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+	}
 
-	if (phydev->speed != priv->speed) {
-		ctrl &= ~priv->hw->link.speed_mask;
+	/* Half-Duplex can only work with single queue */
+	if (tx_cnt > 1) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 1000baseT_Half);
+	}
 
-		switch (phydev->speed) {
-		case SPEED_1000:
-			ctrl |= priv->hw->link.speed1000;
-			break;
-		case SPEED_100:
-			ctrl |= priv->hw->link.speed100;
-			break;
-		case SPEED_10:
-			ctrl |= priv->hw->link.speed10;
-			break;
-		default:
-			netif_warn(priv, link, priv->dev,
-				   "broken speed: %d\n", phydev->speed);
-			phydev->speed = SPEED_UNKNOWN;
-			break;
-		}
+	bitmap_andnot(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_andnot(state->advertising, state->advertising, mask,
+		      __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
 
-		if (phydev->speed != SPEED_UNKNOWN)
-			stmmac_hw_fix_mac_speed(priv);
+static int stmmac_mac_link_state(struct phylink_config *config,
+				 struct phylink_link_state *state)
+{
+	return -EOPNOTSUPP;
+}
 
-		priv->speed = phydev->speed;
+static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
+			      const struct phylink_link_state *state)
+{
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+	u32 ctrl;
+
+	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+	ctrl &= ~priv->hw->link.speed_mask;
+
+	switch (state->speed) {
+	case SPEED_1000:
+		ctrl |= priv->hw->link.speed1000;
+		break;
+	case SPEED_100:
+		ctrl |= priv->hw->link.speed100;
+		break;
+	case SPEED_10:
+		ctrl |= priv->hw->link.speed10;
+		break;
+	default:
+		return;
 	}
 
+	if (priv->plat->fix_mac_speed)
+		priv->plat->fix_mac_speed(priv->plat->bsp_priv, state->speed);
+
 	/* Now we make sure that we can be in full duplex mode.
 	 * If not, we operate in half-duplex mode. */
-	if (phydev->duplex != priv->oldduplex) {
-		if (!phydev->duplex)
-			ctrl &= ~priv->hw->link.duplex;
-		else
-			ctrl |= priv->hw->link.duplex;
+	if (!state->duplex)
+		ctrl &= ~priv->hw->link.duplex;
+	else
+		ctrl |= priv->hw->link.duplex;
 
-		priv->oldduplex = phydev->duplex;
-	}
+	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
 	/* Flow Control operation */
-	if (phydev->pause)
-		stmmac_mac_flow_ctrl(priv, phydev->duplex);
-
-	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+	if (state->pause)
+		stmmac_mac_flow_ctrl(priv, state->duplex);
 }
 
-static void stmmac_mac_link_down(struct net_device *dev, bool autoneg)
+static void stmmac_mac_an_restart(struct phylink_config *config)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
-
-	stmmac_mac_set(priv, priv->ioaddr, false);
+	/* Not Supported */
 }
 
-static void stmmac_mac_link_up(struct net_device *dev, bool autoneg)
+static void stmmac_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
-	stmmac_mac_set(priv, priv->ioaddr, true);
+	stmmac_mac_set(priv, priv->ioaddr, false);
+
+	priv->eee_active = false;
+	stmmac_eee_init(priv);
+	stmmac_set_eee_pls(priv, priv->hw, false);
 }
 
-/**
- * stmmac_adjust_link - adjusts the link parameters
- * @dev: net device structure
- * Description: this is the helper called by the physical abstraction layer
- * drivers to communicate the phy link status. According the speed and duplex
- * this driver can invoke registered glue-logic as well.
- * It also invoke the eee initialization because it could happen when switch
- * on different networks (that are eee capable).
- */
-static void stmmac_adjust_link(struct net_device *dev)
+static void stmmac_mac_link_up(struct phylink_config *config,
+			       unsigned int mode, phy_interface_t interface,
+			       struct phy_device *phy)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
-	bool new_state = false;
-
-	if (!phydev)
-		return;
-
-	mutex_lock(&priv->lock);
-
-	if (phydev->link) {
-		stmmac_mac_config(dev);
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
-		if (!priv->oldlink) {
-			new_state = true;
-			priv->oldlink = true;
-		}
-	} else if (priv->oldlink) {
-		new_state = true;
-		priv->oldlink = false;
-		priv->speed = SPEED_UNKNOWN;
-		priv->oldduplex = DUPLEX_UNKNOWN;
-	}
-
-	if (phydev->link)
-		stmmac_mac_link_up(dev, false);
-	else
-		stmmac_mac_link_down(dev, false);
-
-	if (new_state && netif_msg_link(priv))
-		phy_print_status(phydev);
-
-	mutex_unlock(&priv->lock);
+	stmmac_mac_set(priv, priv->ioaddr, true);
 
-	if (phydev->is_pseudo_fixed_link)
-		/* Stop PHY layer to call the hook to adjust the link in case
-		 * of a switch is attached to the stmmac driver.
-		 */
-		phydev->irq = PHY_IGNORE_INTERRUPT;
-	else
-		/* At this stage, init the EEE if supported.
-		 * Never called in case of fixed_link.
-		 */
+	if (phy) {
+		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
+		stmmac_set_eee_pls(priv, priv->hw, true);
+	}
 }
 
 /**
@@ -1006,79 +948,53 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 tx_cnt = priv->plat->tx_queues_to_use;
-	struct phy_device *phydev;
-	char phy_id_fmt[MII_BUS_ID_SIZE + 3];
-	char bus_id[MII_BUS_ID_SIZE];
-	int interface = priv->plat->interface;
-	int max_speed = priv->plat->max_speed;
-	priv->oldlink = false;
-	priv->speed = SPEED_UNKNOWN;
-	priv->oldduplex = DUPLEX_UNKNOWN;
-
-	if (priv->plat->phy_node) {
-		phydev = of_phy_connect(dev, priv->plat->phy_node,
-					&stmmac_adjust_link, 0, interface);
-	} else {
-		snprintf(bus_id, MII_BUS_ID_SIZE, "stmmac-%x",
-			 priv->plat->bus_id);
+	struct device_node *node;
+	int ret;
 
-		snprintf(phy_id_fmt, MII_BUS_ID_SIZE + 3, PHY_ID_FMT, bus_id,
-			 priv->plat->phy_addr);
-		netdev_dbg(priv->dev, "%s: trying to attach to %s\n", __func__,
-			   phy_id_fmt);
+	node = priv->plat->phy_node;
 
-		phydev = phy_connect(dev, phy_id_fmt, &stmmac_adjust_link,
-				     interface);
-	}
+	if (node) {
+		ret = phylink_of_phy_connect(priv->phylink, node, 0);
+	} else {
+		int addr = priv->plat->phy_addr;
+		struct phy_device *phydev;
 
-	if (IS_ERR_OR_NULL(phydev)) {
-		netdev_err(priv->dev, "Could not attach to PHY\n");
-		if (!phydev)
+		phydev = mdiobus_get_phy(priv->mii, addr);
+		if (!phydev) {
+			netdev_err(priv->dev, "no phy at addr %d\n", addr);
 			return -ENODEV;
+		}
 
-		return PTR_ERR(phydev);
+		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	/* Stop Advertising 1000BASE Capability if interface is not GMII */
-	if ((interface == PHY_INTERFACE_MODE_MII) ||
-	    (interface == PHY_INTERFACE_MODE_RMII) ||
-		(max_speed < 1000 && max_speed > 0))
-		phy_set_max_speed(phydev, SPEED_100);
+	return ret;
+}
 
-	/*
-	 * Half-duplex mode not supported with multiqueue
-	 * half-duplex can only works with single queue
-	 */
-	if (tx_cnt > 1) {
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_100baseT_Half_BIT);
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	}
+static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
+	.validate = stmmac_validate,
+	.mac_link_state = stmmac_mac_link_state,
+	.mac_config = stmmac_mac_config,
+	.mac_an_restart = stmmac_mac_an_restart,
+	.mac_link_down = stmmac_mac_link_down,
+	.mac_link_up = stmmac_mac_link_up,
+};
 
-	/*
-	 * Broken HW is sometimes missing the pull-up resistor on the
-	 * MDIO line, which results in reads to non-existent devices returning
-	 * 0 rather than 0xffff. Catch this here and treat 0 as a non-existent
-	 * device as well.
-	 * Note: phydev->phy_id is the result of reading the UID PHY registers.
-	 */
-	if (!priv->plat->phy_node && phydev->phy_id == 0) {
-		phy_disconnect(phydev);
-		return -ENODEV;
-	}
+static int stmmac_phy_setup(struct stmmac_priv *priv)
+{
+	struct device_node *node = priv->plat->phy_node;
+	int mode = priv->plat->interface;
+	struct phylink *phylink;
 
-	/* stmmac_adjust_link will change this to PHY_IGNORE_INTERRUPT to avoid
-	 * subsequent PHY polling, make sure we force a link transition if
-	 * we have a UP/DOWN/UP transition
-	 */
-	if (phydev->is_pseudo_fixed_link)
-		phydev->irq = PHY_POLL;
+	priv->phylink_config.dev = &priv->dev->dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
 
-	phy_attached_info(phydev);
+	phylink = phylink_create(&priv->phylink_config, of_fwnode_handle(node),
+				 mode, &stmmac_phylink_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	priv->phylink = phylink;
 	return 0;
 }
 
@@ -2691,8 +2607,7 @@ static int stmmac_open(struct net_device *dev)
 
 	stmmac_init_tx_coalesce(priv);
 
-	if (dev->phydev)
-		phy_start(dev->phydev);
+	phylink_start(priv->phylink);
 
 	/* Request the IRQ lines */
 	ret = request_irq(dev->irq, stmmac_interrupt,
@@ -2739,8 +2654,7 @@ static int stmmac_open(struct net_device *dev)
 wolirq_error:
 	free_irq(dev->irq, dev);
 irq_error:
-	if (dev->phydev)
-		phy_stop(dev->phydev);
+	phylink_stop(priv->phylink);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		del_timer_sync(&priv->tx_queue[chan].txtimer);
@@ -2749,9 +2663,7 @@ static int stmmac_open(struct net_device *dev)
 init_error:
 	free_dma_desc_resources(priv);
 dma_desc_error:
-	if (dev->phydev)
-		phy_disconnect(dev->phydev);
-
+	phylink_disconnect_phy(priv->phylink);
 	return ret;
 }
 
@@ -2770,10 +2682,8 @@ static int stmmac_release(struct net_device *dev)
 		del_timer_sync(&priv->eee_ctrl_timer);
 
 	/* Stop and disconnect the PHY */
-	if (dev->phydev) {
-		phy_stop(dev->phydev);
-		phy_disconnect(dev->phydev);
-	}
+	phylink_stop(priv->phylink);
+	phylink_disconnect_phy(priv->phylink);
 
 	stmmac_stop_all_queues(priv);
 
@@ -3830,6 +3740,7 @@ static void stmmac_poll_controller(struct net_device *dev)
  */
 static int stmmac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
+	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
 	if (!netif_running(dev))
@@ -3839,9 +3750,7 @@ static int stmmac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-		if (!dev->phydev)
-			return -EINVAL;
-		ret = phy_mii_ioctl(dev->phydev, rq, cmd);
+		ret = phylink_mii_ioctl(priv->phylink, rq, cmd);
 		break;
 	case SIOCSHWTSTAMP:
 		ret = stmmac_hwtstamp_set(dev, rq);
@@ -4432,6 +4341,12 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
+	ret = stmmac_phy_setup(priv);
+	if (ret) {
+		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
+		goto error_phy_setup;
+	}
+
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(priv->device, "%s: ERROR %i registering the device\n",
@@ -4449,6 +4364,8 @@ int stmmac_dvr_probe(struct device *device,
 	return ret;
 
 error_netdev_register:
+	phylink_destroy(priv->phylink);
+error_phy_setup:
 	if (priv->hw->pcs != STMMAC_PCS_RGMII &&
 	    priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
@@ -4490,6 +4407,7 @@ int stmmac_dvr_remove(struct device *dev)
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
 	clk_disable_unprepare(priv->plat->pclk);
@@ -4520,8 +4438,7 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
+	phylink_stop(priv->phylink);
 
 	mutex_lock(&priv->lock);
 
@@ -4632,8 +4549,7 @@ int stmmac_resume(struct device *dev)
 
 	mutex_unlock(&priv->lock);
 
-	if (ndev->phydev)
-		phy_start(ndev->phydev);
+	phylink_start(priv->phylink);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index f45bfbef97d0..898f94aced53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -333,21 +333,6 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 		{},
 	};
 
-	/* If phy-handle property is passed from DT, use it as the PHY */
-	plat->phy_node = of_parse_phandle(np, "phy-handle", 0);
-	if (plat->phy_node)
-		dev_dbg(dev, "Found phy-handle subnode\n");
-
-	/* If phy-handle is not specified, check if we have a fixed-phy */
-	if (!plat->phy_node && of_phy_is_fixed_link(np)) {
-		if ((of_phy_register_fixed_link(np) < 0))
-			return -ENODEV;
-
-		dev_dbg(dev, "Found fixed-link subnode\n");
-		plat->phy_node = of_node_get(np);
-		mdio = false;
-	}
-
 	if (of_match_node(need_mdio_ids, np)) {
 		plat->mdio_node = of_get_child_by_name(np, "mdio");
 	} else {
@@ -396,6 +381,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	*mac = of_get_mac_address(np);
 	plat->interface = of_get_phy_mode(np);
+	plat->phy_node = np;
 
 	/* Get max speed of operation from device tree */
 	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
@@ -591,11 +577,6 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 void stmmac_remove_config_dt(struct platform_device *pdev,
 			     struct plat_stmmacenet_data *plat)
 {
-	struct device_node *np = pdev->dev.of_node;
-
-	if (of_phy_is_fixed_link(np))
-		of_phy_deregister_fixed_link(np);
-	of_node_put(plat->phy_node);
 	of_node_put(plat->mdio_node);
 }
 #else
-- 
2.7.4

