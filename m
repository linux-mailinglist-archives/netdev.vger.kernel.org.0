Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6A284FA9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJFQQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:16:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:58074 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJFQQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:16:33 -0400
IronPort-SDR: V/20mc1Sn9GfXO/FVQ9PIl/g2bF/vZNZJLW3dI+5MUVWE2kRQ2B4klrkNduzmol+oT1Jd7egKt
 azGxddKz9Zkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="161938618"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="161938618"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 09:06:39 -0700
IronPort-SDR: H8Xe/8tGV9mu9bEzuirarxuexnEAMYA1IUaCIvcO5OBD020IGv8TROaacCtx1z27164tKSfAcf
 0RVdTrdaGk4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="460862552"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga004.jf.intel.com with ESMTP; 06 Oct 2020 09:06:33 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with auto SW/HW auto switch
Date:   Wed,  7 Oct 2020 00:06:32 +0800
Message-Id: <20201006160633.23470-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

This patch enables the HW LPI Timer which controls the automatic entry
and exit of the LPI state.
The EEE LPI timer value is configured through ethtool. The driver will
auto select the LPI HW timer if the value in the HW timer supported range.
Else, the driver will fallback to SW timer.

Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  3 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  2 ++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 24 +++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 +++++++++++++++++--
 include/linux/stmmac.h                        |  1 +
 7 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index df7de50497a0..f59c4a1c1674 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -402,6 +402,9 @@ struct dma_features {
 /* Default LPI timers */
 #define STMMAC_DEFAULT_LIT_LS	0x3E8
 #define STMMAC_DEFAULT_TWT_LS	0x1E
+#define STMMAC_ET_MAX		0xFFFFF
+#define LPI_ET_ENABLE		1
+#define LPI_ET_DISABLE		0
 
 #define STMMAC_CHAIN_MODE	0x1
 #define STMMAC_RING_MODE	0x2
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 592b043f9676..82df91c130f7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -176,9 +176,11 @@ enum power_event {
  */
 #define GMAC4_LPI_CTRL_STATUS	0xd0
 #define GMAC4_LPI_TIMER_CTRL	0xd4
+#define GMAC4_LPI_ENTRY_TIMER	0xd8
 
 /* LPI control and status defines */
 #define GMAC4_LPI_CTRL_STATUS_LPITCSE	BIT(21)	/* LPI Tx Clock Stop Enable */
+#define GMAC4_LPI_CTRL_STATUS_LPIATE	BIT(20) /* LPI Timer Enable */
 #define GMAC4_LPI_CTRL_STATUS_LPITXA	BIT(19)	/* Enable LPI TX Automate */
 #define GMAC4_LPI_CTRL_STATUS_PLS	BIT(17) /* PHY Link Status */
 #define GMAC4_LPI_CTRL_STATUS_LPIEN	BIT(16)	/* LPI Enable */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 002791b77356..3ed4f4cda7f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -379,6 +379,27 @@ static void dwmac4_set_eee_pls(struct mac_device_info *hw, int link)
 	writel(value, ioaddr + GMAC4_LPI_CTRL_STATUS);
 }
 
+static void dwmac4_set_eee_lpi_entry_timer(struct mac_device_info *hw, int et)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	int value = et & STMMAC_ET_MAX;
+	int regval;
+
+	/* Program LPI entry timer value into register */
+	writel(value, ioaddr + GMAC4_LPI_ENTRY_TIMER);
+
+	/* Enable/disable LPI entry timer */
+	regval = readl(ioaddr + GMAC4_LPI_CTRL_STATUS);
+	regval |= GMAC4_LPI_CTRL_STATUS_LPIEN | GMAC4_LPI_CTRL_STATUS_LPITXA;
+
+	if (et)
+		regval |= GMAC4_LPI_CTRL_STATUS_LPIATE;
+	else
+		regval &= ~GMAC4_LPI_CTRL_STATUS_LPIATE;
+
+	writel(regval, ioaddr + GMAC4_LPI_CTRL_STATUS);
+}
+
 static void dwmac4_set_eee_timer(struct mac_device_info *hw, int ls, int tw)
 {
 	void __iomem *ioaddr = hw->pcsr;
@@ -1164,6 +1185,7 @@ const struct stmmac_ops dwmac4_ops = {
 	.get_umac_addr = dwmac4_get_umac_addr,
 	.set_eee_mode = dwmac4_set_eee_mode,
 	.reset_eee_mode = dwmac4_reset_eee_mode,
+	.set_eee_lpi_entry_timer = dwmac4_set_eee_lpi_entry_timer,
 	.set_eee_timer = dwmac4_set_eee_timer,
 	.set_eee_pls = dwmac4_set_eee_pls,
 	.pcs_ctrl_ane = dwmac4_ctrl_ane,
@@ -1206,6 +1228,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.get_umac_addr = dwmac4_get_umac_addr,
 	.set_eee_mode = dwmac4_set_eee_mode,
 	.reset_eee_mode = dwmac4_reset_eee_mode,
+	.set_eee_lpi_entry_timer = dwmac4_set_eee_lpi_entry_timer,
 	.set_eee_timer = dwmac4_set_eee_timer,
 	.set_eee_pls = dwmac4_set_eee_pls,
 	.pcs_ctrl_ane = dwmac4_ctrl_ane,
@@ -1249,6 +1272,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.get_umac_addr = dwmac4_get_umac_addr,
 	.set_eee_mode = dwmac4_set_eee_mode,
 	.reset_eee_mode = dwmac4_reset_eee_mode,
+	.set_eee_lpi_entry_timer = dwmac4_set_eee_lpi_entry_timer,
 	.set_eee_timer = dwmac4_set_eee_timer,
 	.set_eee_pls = dwmac4_set_eee_pls,
 	.pcs_ctrl_ane = dwmac4_ctrl_ane,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index e2dca9b6e992..b40b2e0667bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -337,6 +337,7 @@ struct stmmac_ops {
 	void (*set_eee_mode)(struct mac_device_info *hw,
 			     bool en_tx_lpi_clockgating);
 	void (*reset_eee_mode)(struct mac_device_info *hw);
+	void (*set_eee_lpi_entry_timer)(struct mac_device_info *hw, int et);
 	void (*set_eee_timer)(struct mac_device_info *hw, int ls, int tw);
 	void (*set_eee_pls)(struct mac_device_info *hw, int link);
 	void (*debug)(void __iomem *ioaddr, struct stmmac_extra_stats *x,
@@ -439,6 +440,8 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, set_eee_mode, __args)
 #define stmmac_reset_eee_mode(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, reset_eee_mode, __args)
+#define stmmac_set_eee_lpi_timer(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, set_eee_lpi_entry_timer, __args)
 #define stmmac_set_eee_timer(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_eee_timer, __args)
 #define stmmac_set_eee_pls(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 014a816c9d0b..9c5c16709dc3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -266,6 +266,7 @@ int stmmac_dvr_probe(struct device *device,
 		     struct stmmac_resources *res);
 void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
+void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4779826b997d..779e95e458e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -327,6 +327,11 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
  */
 void stmmac_disable_eee_mode(struct stmmac_priv *priv)
 {
+	if (!priv->plat->eee_timer) {
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
+		return;
+	}
+
 	stmmac_reset_eee_mode(priv, priv->hw);
 	del_timer_sync(&priv->eee_ctrl_timer);
 	priv->tx_path_in_lpi_mode = false;
@@ -347,6 +352,16 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 }
 
+void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en)
+{
+	int tx_lpi_timer;
+
+	/* Clear/set the SW EEE timer flag based on LPI ET enablement */
+	priv->plat->eee_timer = en ? 0 : 1;
+	tx_lpi_timer  = en ? priv->tx_lpi_timer : 0;
+	stmmac_set_eee_lpi_timer(priv, priv->hw, tx_lpi_timer);
+}
+
 /**
  * stmmac_eee_init - init EEE
  * @priv: driver private structure
@@ -376,6 +391,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	if (!priv->eee_active) {
 		if (priv->eee_enabled) {
 			netdev_dbg(priv->dev, "disable EEE\n");
+			stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
 			del_timer_sync(&priv->eee_ctrl_timer);
 			stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
 		}
@@ -390,6 +406,15 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 				     tx_lpi_timer);
 	}
 
+	if (priv->plat->has_gmac4 && priv->tx_lpi_timer <= STMMAC_ET_MAX) {
+		del_timer_sync(&priv->eee_ctrl_timer);
+		priv->tx_path_in_lpi_mode = false;
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_ENABLE);
+	} else {
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(tx_lpi_timer));
+	}
+
 	mutex_unlock(&priv->lock);
 	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
 	return true;
@@ -2041,7 +2066,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		netif_tx_wake_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
+	if (priv->eee_enabled && !priv->tx_path_in_lpi_mode &&
+	    priv->plat->eee_timer) {
 		stmmac_enable_eee_mode(priv);
 		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 	}
@@ -3299,7 +3325,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_q = &priv->tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
-	if (priv->tx_path_in_lpi_mode)
+	if (priv->tx_path_in_lpi_mode && priv->plat->eee_timer)
 		stmmac_disable_eee_mode(priv);
 
 	/* Manage oversized TCP frames for GMAC4 device */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 00e83c877496..dc688e6cc362 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -200,5 +200,6 @@ struct plat_stmmacenet_data {
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
+	bool eee_timer;
 };
 #endif
-- 
2.17.1

