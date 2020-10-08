Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10882879B8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgJHQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:11:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:33111 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgJHQL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:11:29 -0400
IronPort-SDR: w/qkH999gPicNkB2ZYIuDgNQNNrszB0NlD5LimhgDj2Kj09hiWljkRBr7dHtRbimyFl9sgANbX
 FLhooOMLAYBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="153197821"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="153197821"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:11:28 -0700
IronPort-SDR: ZeHyYgB6wrldPJSZSALGmMrmDj0grlcuMYsaJxcb/Ik7VRuIvCRfdeBYEqXwsbbn/29fVI2x/n
 OUkUFLy/OdEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="518358185"
Received: from climb.png.intel.com ([10.221.118.165])
  by fmsmga006.fm.intel.com with ESMTP; 08 Oct 2020 09:11:24 -0700
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
Subject: [PATCH v1 net-next] net: stmmac: Enable EEE HW LPI timer with auto SW/HW switching
Date:   Fri,  9 Oct 2020 00:11:23 +0800
Message-Id: <20201008161123.9317-1-weifeng.voon@intel.com>
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
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 24 ++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 31 +++++++++++++++++--
 6 files changed, 62 insertions(+), 3 deletions(-)

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
index 727e68dfaf1c..072e36852f63 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -207,6 +207,7 @@ struct stmmac_priv {
 	int tx_lpi_timer;
 	int tx_lpi_enabled;
 	int eee_tw_timer;
+	bool eee_sw_timer_en;
 	unsigned int mode;
 	unsigned int chain_mode;
 	int extend_desc;
@@ -268,6 +269,7 @@ int stmmac_dvr_probe(struct device *device,
 		     struct stmmac_resources *res);
 void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
+void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 220626a8d499..908df3cb12cd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -327,6 +327,11 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
  */
 void stmmac_disable_eee_mode(struct stmmac_priv *priv)
 {
+	if (!priv->eee_sw_timer_en) {
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
+		return;
+	}
+
 	stmmac_reset_eee_mode(priv, priv->hw);
 	del_timer_sync(&priv->eee_ctrl_timer);
 	priv->tx_path_in_lpi_mode = false;
@@ -347,6 +352,16 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
+void stmmac_lpi_entry_timer_enable(struct stmmac_priv *priv, bool en)
+{
+	int tx_lpi_timer;
+
+	/* Clear/set the SW EEE timer flag based on LPI ET enablement */
+	priv->eee_sw_timer_en = en ? 0 : 1;
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
 			stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
 		}
@@ -389,7 +405,15 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 				     eee_tw_timer);
 	}
 
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+	if (priv->plat->has_gmac4 && priv->tx_lpi_timer <= STMMAC_ET_MAX) {
+		del_timer_sync(&priv->eee_ctrl_timer);
+		priv->tx_path_in_lpi_mode = false;
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_ENABLE);
+	} else {
+		stmmac_lpi_entry_timer_enable(priv, LPI_ET_DISABLE);
+		mod_timer(&priv->eee_ctrl_timer,
+			  STMMAC_LPI_T(priv->tx_lpi_timer));
+	}
 
 	mutex_unlock(&priv->lock);
 	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
@@ -2044,7 +2068,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		netif_tx_wake_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
+	if (priv->eee_enabled && !priv->tx_path_in_lpi_mode &&
+	    priv->eee_sw_timer_en) {
 		stmmac_enable_eee_mode(priv);
 		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
@@ -3306,7 +3331,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_q = &priv->tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
-	if (priv->tx_path_in_lpi_mode)
+	if (priv->tx_path_in_lpi_mode && priv->eee_sw_timer_en)
 		stmmac_disable_eee_mode(priv);
 
 	/* Manage oversized TCP frames for GMAC4 device */
-- 
2.17.1

