Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E8276FA
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfEWHc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:32:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:36471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfEWHcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:32:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 00:32:24 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by fmsmga005.fm.intel.com with ESMTP; 23 May 2019 00:32:20 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH net-next v2 3/5] net: stmmac: add xpcs function hooks into main driver and ethtool
Date:   Thu, 23 May 2019 23:32:45 +0800
Message-Id: <1558625567-21653-4-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
References: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

With xPCS functions now ready, we add them into the main driver and
ethtool logics. To differentiate from EQoS MAC PCS and DWC Ethernet
xPCS, we introduce 'has_xpcs' in platform data as a mean to indicate
whether GBE controller includes xPCS or not.

To support platform-specific C37 AN PCS mode selection for MII MMD,
we introduce 'pcs_mode' in platform data.

The basic framework for xPCS interrupt handling is implemented too.

Reviewed-by: Chuah Kim Tatt <kim.tatt.chuah@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Reviewed-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
Reviewed-by: Baoli Zhang <baoli.zhang@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  50 +++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 152 ++++++++++++++++-----
 include/linux/stmmac.h                             |   2 +
 4 files changed, 158 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index dd95d959c1ce..0b8460a4a220 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -36,6 +36,7 @@ struct stmmac_resources {
 	const char *mac;
 	int wol_irq;
 	int lpi_irq;
+	int xpcs_irq;
 	int irq;
 };
 
@@ -168,6 +169,7 @@ struct stmmac_priv {
 	int clk_csr;
 	struct timer_list eee_ctrl_timer;
 	int lpi_irq;
+	int xpcs_irq;
 	int eee_enabled;
 	int eee_active;
 	int tx_lpi_timer;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index e09522c5509a..f0815d196147 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -28,6 +28,7 @@
 
 #include "stmmac.h"
 #include "dwmac_dma.h"
+#include "dwxpcs.h"
 
 #define REG_SPACE_SIZE	0x1060
 #define MAC100_ETHTOOL_NAME	"st_mac100"
@@ -277,7 +278,8 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 	struct phy_device *phy = dev->phydev;
 
 	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
-	    priv->hw->pcs & STMMAC_PCS_SGMII) {
+	    priv->hw->pcs & STMMAC_PCS_SGMII ||
+	    priv->plat->pcs_mode == AN_CTRL_PCS_MD_C37_1000BASEX) {
 		struct rgmii_adv adv;
 		u32 supported, advertising, lp_advertising;
 
@@ -294,6 +296,11 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 		if (stmmac_pcs_get_adv_lp(priv, priv->ioaddr, &adv))
 			return -EOPNOTSUPP;	/* should never happen indeed */
 
+		/* Get ADV & LPA is only application for 1000BASE-X C37.
+		 * For MAC side SGMII AN, get ADV & LPA from PHY.
+		 */
+		stmmac_xpcs_get_adv_lp(priv, dev, &adv, priv->plat->pcs_mode);
+
 		/* Encoding of PSE bits is defined in 802.3z, 37.2.1.4 */
 
 		ethtool_convert_link_mode_to_legacy_u32(
@@ -376,22 +383,23 @@ static int stmmac_ethtool_get_link_ksettings(struct net_device *dev,
 	int rc;
 
 	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
-	    priv->hw->pcs & STMMAC_PCS_SGMII) {
-		u32 mask = ADVERTISED_Autoneg | ADVERTISED_Pause;
-
+	    priv->hw->pcs & STMMAC_PCS_SGMII ||
+	    priv->plat->pcs_mode == AN_CTRL_PCS_MD_C37_1000BASEX) {
 		/* Only support ANE */
 		if (cmd->base.autoneg != AUTONEG_ENABLE)
 			return -EINVAL;
 
-		mask &= (ADVERTISED_1000baseT_Half |
-			ADVERTISED_1000baseT_Full |
-			ADVERTISED_100baseT_Half |
-			ADVERTISED_100baseT_Full |
-			ADVERTISED_10baseT_Half |
-			ADVERTISED_10baseT_Full);
-
 		mutex_lock(&priv->lock);
 		stmmac_pcs_ctrl_ane(priv, priv->ioaddr, 1, priv->hw->ps, 0);
+
+		/* For 1000BASE-X C37 AN, it is always 1000Mbps. And, we only
+		 * support FD which is set by default in SR_MII_AN_ADV
+		 * during XPCS init. So, we don't need to set FD again.
+		 * For SGMII C37 AN, we let user to change link settings
+		 * through PHY since it is MAC side SGMII.
+		 */
+		stmmac_xpcs_ctrl_ane(priv, dev, 1, 0);
+
 		mutex_unlock(&priv->lock);
 
 		return 0;
@@ -457,6 +465,16 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 		pause->autoneg = 1;
 		if (!adv_lp.pause)
 			return;
+	} else if (priv->plat->pcs_mode == AN_CTRL_PCS_MD_C37_1000BASEX &&
+		   !stmmac_xpcs_get_adv_lp(priv, netdev, &adv_lp,
+					   priv->plat->pcs_mode)) {
+		/* DW xPCS 1000BASE-X C37 AN mode only because for MAC side
+		 * SGMII C37 AN, xPCS AN ADV is not set. See more comment in
+		 * dw_xpcs_init()
+		 */
+		pause->autoneg = 1;
+		if (!adv_lp.pause)
+			return;
 	} else {
 		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				       netdev->phydev->supported) ||
@@ -488,6 +506,16 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 		pause->autoneg = 1;
 		if (!adv_lp.pause)
 			return -EOPNOTSUPP;
+	} else if (priv->plat->pcs_mode == AN_CTRL_PCS_MD_C37_1000BASEX &&
+		   !stmmac_xpcs_get_adv_lp(priv, netdev, &adv_lp,
+					   priv->plat->pcs_mode)) {
+		/* DW xPCS 1000BASE-X C37 AN mode only because for MAC side
+		 * SGMII C37 AN, xPCS AN ADV is not set. See more comment in
+		 * dw_xpcs_init()
+		 */
+		pause->autoneg = 1;
+		if (!adv_lp.pause)
+			return -EOPNOTSUPP;
 	} else {
 		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				       phy->supported) ||
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2a1052704885..f6e3b1282079 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -112,6 +112,7 @@
 MODULE_PARM_DESC(chain_mode, "To use chain instead of ring mode");
 
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id);
+static irqreturn_t xpcs_interrupt(int irq, void *dev_id);
 
 #ifdef CONFIG_DEBUG_FS
 static int stmmac_init_fs(struct net_device *dev);
@@ -848,6 +849,55 @@ static void stmmac_mac_flow_ctrl(struct stmmac_priv *priv, u32 duplex)
 			priv->pause, tx_cnt);
 }
 
+static bool mac_adjust_link(struct stmmac_priv *priv,
+			    int *speed, int *duplex)
+{
+	bool new_state = false;
+
+	u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+
+	/* Now we make sure that we can be in full duplex mode.
+	 * If not, we operate in half-duplex mode.
+	 */
+	if (*duplex != priv->oldduplex) {
+		new_state = true;
+		if (!*duplex)
+			ctrl &= ~priv->hw->link.duplex;
+		else
+			ctrl |= priv->hw->link.duplex;
+		priv->oldduplex = *duplex;
+	}
+
+	if (*speed != priv->speed) {
+		new_state = true;
+		ctrl &= ~priv->hw->link.speed_mask;
+		switch (*speed) {
+		case SPEED_1000:
+			ctrl |= priv->hw->link.speed1000;
+			break;
+		case SPEED_100:
+			ctrl |= priv->hw->link.speed100;
+			break;
+		case SPEED_10:
+			ctrl |= priv->hw->link.speed10;
+			break;
+		default:
+			netif_warn(priv, link, priv->dev,
+				   "broken speed: %d\n", *speed);
+			*speed = SPEED_UNKNOWN;
+			break;
+		}
+		if (*speed != SPEED_UNKNOWN)
+			stmmac_hw_fix_mac_speed(priv);
+
+		priv->speed = *speed;
+	}
+
+	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+
+	return new_state;
+}
+
 /**
  * stmmac_adjust_link - adjusts the link parameters
  * @dev: net device structure
@@ -869,47 +919,12 @@ static void stmmac_adjust_link(struct net_device *dev)
 	mutex_lock(&priv->lock);
 
 	if (phydev->link) {
-		u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
-
-		/* Now we make sure that we can be in full duplex mode.
-		 * If not, we operate in half-duplex mode. */
-		if (phydev->duplex != priv->oldduplex) {
-			new_state = true;
-			if (!phydev->duplex)
-				ctrl &= ~priv->hw->link.duplex;
-			else
-				ctrl |= priv->hw->link.duplex;
-			priv->oldduplex = phydev->duplex;
-		}
 		/* Flow Control operation */
 		if (phydev->pause)
 			stmmac_mac_flow_ctrl(priv, phydev->duplex);
 
-		if (phydev->speed != priv->speed) {
-			new_state = true;
-			ctrl &= ~priv->hw->link.speed_mask;
-			switch (phydev->speed) {
-			case SPEED_1000:
-				ctrl |= priv->hw->link.speed1000;
-				break;
-			case SPEED_100:
-				ctrl |= priv->hw->link.speed100;
-				break;
-			case SPEED_10:
-				ctrl |= priv->hw->link.speed10;
-				break;
-			default:
-				netif_warn(priv, link, priv->dev,
-					   "broken speed: %d\n", phydev->speed);
-				phydev->speed = SPEED_UNKNOWN;
-				break;
-			}
-			if (phydev->speed != SPEED_UNKNOWN)
-				stmmac_hw_fix_mac_speed(priv);
-			priv->speed = phydev->speed;
-		}
-
-		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+		new_state = mac_adjust_link(priv, &phydev->speed,
+					    &phydev->duplex);
 
 		if (!priv->oldlink) {
 			new_state = true;
@@ -2538,6 +2553,9 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	/* Initialize MTL*/
 	stmmac_mtl_configuration(priv);
 
+	/* Initialize the xPCS PHY */
+	stmmac_xpcs_init(priv, dev, priv->plat->pcs_mode);
+
 	/* Initialize Safety Features */
 	stmmac_safety_feat_configuration(priv);
 
@@ -2579,6 +2597,8 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	if (priv->hw->pcs)
 		stmmac_pcs_ctrl_ane(priv, priv->hw, 1, priv->hw->ps, 0);
 
+	stmmac_xpcs_ctrl_ane(priv, dev, 1, 0);
+
 	/* set TX and RX rings length */
 	stmmac_set_rings_length(priv);
 
@@ -2694,11 +2714,27 @@ static int stmmac_open(struct net_device *dev)
 		}
 	}
 
+	/* xPCS IRQ line */
+	if (priv->xpcs_irq > 0) {
+		ret = request_irq(priv->xpcs_irq, xpcs_interrupt, IRQF_SHARED,
+				  dev->name, dev);
+		if (unlikely(ret < 0)) {
+			netdev_err(priv->dev,
+				   "%s: ERROR: allocating the xPCS IRQ %d (%d)\n",
+				   __func__, priv->xpcs_irq, ret);
+			goto xpcsirq_error;
+		}
+	}
+
 	stmmac_enable_all_queues(priv);
 	stmmac_start_all_queues(priv);
 
 	return 0;
 
+xpcsirq_error:
+	if (priv->lpi_irq > 0)
+		free_irq(priv->lpi_irq, dev);
+
 lpiirq_error:
 	if (priv->wol_irq != dev->irq)
 		free_irq(priv->wol_irq, dev);
@@ -3772,6 +3808,47 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/**
+ *  xPCS_interrupt - xPCS ISR
+ *  @irq: interrupt number.
+ *  @dev_id: to pass the net device pointer.
+ *  Description: this is the xPCS interrupt service routine.
+ */
+static irqreturn_t xpcs_interrupt(int irq, void *dev_id)
+{
+	irqreturn_t ret = IRQ_NONE;
+	struct net_device *ndev = (struct net_device *)dev_id;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	if (unlikely(!ndev)) {
+		netdev_err(priv->dev, "%s: invalid dev pointer\n",
+			   __func__);
+		return ret;
+	}
+
+	/* To handle xPCS interrupts */
+	ret = stmmac_xpcs_irq_status(priv, ndev, &priv->xstats,
+				     priv->plat->pcs_mode);
+
+	if (ret == IRQ_HANDLED) {
+		/* Keep the MAC's speed & duplex consistent with DW xPCS
+		 * because AN in DW xPCS does not update DW EQoS MAC
+		 * directly.
+		 */
+		int speed = (int)priv->xstats.pcs_speed;
+		int duplex = (int)priv->xstats.pcs_speed;
+
+		mac_adjust_link(priv, &speed, &duplex);
+
+		if (priv->xstats.pcs_link)
+			netif_carrier_on(ndev);
+		else
+			netif_carrier_off(ndev);
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 /* Polling receive - used by NETCONSOLE and other diagnostic tools
  * to allow network I/O with interrupts disabled.
@@ -4261,6 +4338,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->dev->irq = res->irq;
 	priv->wol_irq = res->wol_irq;
 	priv->lpi_irq = res->lpi_irq;
+	priv->xpcs_irq = res->xpcs_irq;
 
 	if (!IS_ERR_OR_NULL(res->mac))
 		memcpy(priv->dev->dev_addr, res->mac, ETH_ALEN);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index b00e7951a66d..c6778abd41c5 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -189,6 +189,8 @@ struct plat_stmmacenet_data {
 	struct reset_control *stmmac_rst;
 	struct stmmac_axi *axi;
 	int has_gmac4;
+	bool has_xpcs;
+	int pcs_mode;
 	bool has_sun8i;
 	bool tso_en;
 	int mac_port_sel_speed;
-- 
1.9.1

