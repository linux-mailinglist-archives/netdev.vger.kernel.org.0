Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4328F64B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389258AbgJOQBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:01:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:33297 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388393AbgJOQBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:01:30 -0400
IronPort-SDR: HUkNclRrQeNIZfYc1tGVpf0tvpK0YYWnNCE/20aB0Sl61lzJbzBi/Xf3f4KmUQu4S/fZGLMIf6
 dGZ01B6TwRgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="251076876"
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="251076876"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 09:01:27 -0700
IronPort-SDR: 5rem7uU//bY+JwDs644sliuC5UcFNbMBUkz4pSVMkJboDeLHWbDR3hoeUy4BdNzzH+h7s4Gcaz
 EVzXicsMkCHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="314564451"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga003.jf.intel.com with ESMTP; 15 Oct 2020 09:01:22 -0700
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
Subject: [PATCH v2 net-next] net: stmmac: Enable EEE HW LPI timer with auto SW/HW switching
Date:   Fri, 16 Oct 2020 00:01:22 +0800
Message-Id: <20201015160122.23448-1-weifeng.voon@intel.com>
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
v2 changelog:
-removed #define for LPI_ET_ENABLE and LPI_ET_DISABLE and directly use
 literals
-removed not required function header in stmmac.h
-renamed stmmac_lpi_entry_timer_enable() to stmmac_lpi_entry_timer_config()
-Moved stmmac_lpi_entry_timer_enable() up in the file before
 stmmac_disable_eee_mode()

 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  2 ++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 24 ++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 31 +++++++++++++++++--
 6 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index df7de50497a0..6f271c46368d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -402,6 +402,7 @@ struct dma_features {
 /* Default LPI timers */
 #define STMMAC_DEFAULT_LIT_LS	0x3E8
 #define STMMAC_DEFAULT_TWT_LS	0x1E
+#define STMMAC_ET_MAX		0xFFFFF
 
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
index 727e68dfaf1c..c88ee8ea4245 100644
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
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 220626a8d499..d8affb14edd5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -294,6 +294,16 @@ static inline u32 stmmac_rx_dirty(struct stmmac_priv *priv, u32 queue)
 	return dirty;
 }
 
+void stmmac_lpi_entry_timer_config(struct stmmac_priv *priv, bool en)
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
  * stmmac_enable_eee_mode - check and enter in LPI mode
  * @priv: driver private structure
@@ -327,6 +337,11 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
  */
 void stmmac_disable_eee_mode(struct stmmac_priv *priv)
 {
+	if (!priv->eee_sw_timer_en) {
+		stmmac_lpi_entry_timer_config(priv, 0);
+		return;
+	}
+
 	stmmac_reset_eee_mode(priv, priv->hw);
 	del_timer_sync(&priv->eee_ctrl_timer);
 	priv->tx_path_in_lpi_mode = false;
@@ -376,6 +391,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	if (!priv->eee_active) {
 		if (priv->eee_enabled) {
 			netdev_dbg(priv->dev, "disable EEE\n");
+			stmmac_lpi_entry_timer_config(priv, 0);
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
+		stmmac_lpi_entry_timer_config(priv, 1);
+	} else {
+		stmmac_lpi_entry_timer_config(priv, 0);
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

