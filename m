Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6F830DAA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 13:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfEaL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 07:58:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:9963 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbfEaL6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 07:58:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 04:58:01 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga003.jf.intel.com with ESMTP; 31 May 2019 04:57:58 -0700
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
Subject: [PATCH net-next v5 4/5] net: stmmac: add xPCS functions for device with DWMACv5.1
Date:   Sat,  1 Jun 2019 03:58:13 +0800
Message-Id: <1559332694-6354-5-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

We introduce support for driver that has v5.10 IP and is also using
xPCS as MMD. This can be easily enabled for other product that integrates
xPCS that is not using v5.00 IP.

Reviewed-by: Chuah Kim Tatt <kim.tatt.chuah@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Reviewed-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
Reviewed-by: Baoli Zhang <baoli.zhang@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 33 ++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.c        | 42 ++++++++++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  2 ++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 5e98da4e14f9..3afb60f2775c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -824,6 +824,39 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
+const struct stmmac_ops dwmac510_xpcs_ops = {
+	.core_init = dwmac4_core_init,
+	.set_mac = stmmac_dwmac4_set_mac,
+	.rx_ipc = dwmac4_rx_ipc_enable,
+	.rx_queue_enable = dwmac4_rx_queue_enable,
+	.rx_queue_prio = dwmac4_rx_queue_priority,
+	.tx_queue_prio = dwmac4_tx_queue_priority,
+	.rx_queue_routing = dwmac4_rx_queue_routing,
+	.prog_mtl_rx_algorithms = dwmac4_prog_mtl_rx_algorithms,
+	.prog_mtl_tx_algorithms = dwmac4_prog_mtl_tx_algorithms,
+	.set_mtl_tx_queue_weight = dwmac4_set_mtl_tx_queue_weight,
+	.map_mtl_to_dma = dwmac4_map_mtl_dma,
+	.config_cbs = dwmac4_config_cbs,
+	.dump_regs = dwmac4_dump_regs,
+	.host_irq_status = dwmac4_irq_status,
+	.host_mtl_irq_status = dwmac4_irq_mtl_status,
+	.flow_ctrl = dwmac4_flow_ctrl,
+	.pmt = dwmac4_pmt,
+	.set_umac_addr = dwmac4_set_umac_addr,
+	.get_umac_addr = dwmac4_get_umac_addr,
+	.set_eee_mode = dwmac4_set_eee_mode,
+	.reset_eee_mode = dwmac4_reset_eee_mode,
+	.set_eee_timer = dwmac4_set_eee_timer,
+	.set_eee_pls = dwmac4_set_eee_pls,
+	.debug = dwmac4_debug,
+	.set_filter = dwmac4_set_filter,
+	.safety_feat_config = dwmac5_safety_feat_config,
+	.safety_feat_irq_status = dwmac5_safety_feat_irq_status,
+	.safety_feat_dump = dwmac5_safety_feat_dump,
+	.rxp_config = dwmac5_rxp_config,
+	.flex_pps_config = dwmac5_flex_pps_config,
+};
+
 int dwmac4_setup(struct stmmac_priv *priv)
 {
 	struct mac_device_info *mac = priv->hw;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 6c61b753b55e..052a000feeb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -73,11 +73,13 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 	bool gmac;
 	bool gmac4;
 	bool xgmac;
+	bool has_xpcs;
 	u32 min_id;
 	const struct stmmac_regs_off regs;
 	const void *desc;
 	const void *dma;
 	const void *mac;
+	const void *xpcs;
 	const void *hwtimestamp;
 	const void *mode;
 	const void *tc;
@@ -90,6 +92,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -98,6 +101,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = NULL,
 		.dma = &dwmac100_dma_ops,
 		.mac = &dwmac100_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
@@ -108,6 +112,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = true,
 		.gmac4 = false,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -116,6 +121,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = NULL,
 		.dma = &dwmac1000_dma_ops,
 		.mac = &dwmac1000_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
@@ -126,6 +132,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -133,6 +140,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		},
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac4_dma_ops,
+		.xpcs = NULL,
 		.mac = &dwmac4_ops,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
@@ -144,6 +152,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = DWMAC_CORE_4_00,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -152,6 +161,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac4_dma_ops,
 		.mac = &dwmac410_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -162,6 +172,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = DWMAC_CORE_4_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -170,6 +181,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac410_dma_ops,
 		.mac = &dwmac410_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -180,6 +192,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_xpcs = false,
 		.min_id = DWMAC_CORE_5_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -188,6 +201,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac410_dma_ops,
 		.mac = &dwmac510_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -198,6 +212,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = true,
+		.has_xpcs = false,
 		.min_id = DWXGMAC_CORE_2_10,
 		.regs = {
 			.ptp_off = PTP_XGMAC_OFFSET,
@@ -206,13 +221,34 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.desc = &dwxgmac210_desc_ops,
 		.dma = &dwxgmac210_dma_ops,
 		.mac = &dwxgmac210_ops,
+		.xpcs = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
 		.mmc = NULL,
 		.setup = dwxgmac2_setup,
 		.quirks = NULL,
-	},
+	}, {
+		.gmac = false,
+		.gmac4 = true,
+		.xgmac = false,
+		.has_xpcs = true,
+		.min_id = DWMAC_CORE_5_10,
+		.regs = {
+			.ptp_off = PTP_GMAC4_OFFSET,
+			.mmc_off = MMC_GMAC4_OFFSET,
+		},
+		.desc = &dwmac4_desc_ops,
+		.dma = &dwmac410_dma_ops,
+		.mac = &dwmac510_xpcs_ops,
+		.xpcs = &xpcs_ops,
+		.hwtimestamp = &stmmac_ptp,
+		.mode = &dwmac4_ring_mode_ops,
+		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
+		.setup = dwmac4_setup,
+		.quirks = NULL,
+	}
 };
 
 int stmmac_hwif_init(struct stmmac_priv *priv)
@@ -220,6 +256,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 	bool needs_xgmac = priv->plat->has_xgmac;
 	bool needs_gmac4 = priv->plat->has_gmac4;
 	bool needs_gmac = priv->plat->has_gmac;
+	bool needs_xpcs = priv->plat->has_xpcs;
 	const struct stmmac_hwif_entry *entry;
 	struct mac_device_info *mac;
 	bool needs_setup = true;
@@ -264,6 +301,8 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 			continue;
 		if (needs_xgmac ^ entry->xgmac)
 			continue;
+		if (needs_xpcs ^ entry->has_xpcs)
+			continue;
 		/* Use synopsys_id var because some setups can override this */
 		if (priv->synopsys_id < entry->min_id)
 			continue;
@@ -272,6 +311,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->desc = mac->desc ? : entry->desc;
 		mac->dma = mac->dma ? : entry->dma;
 		mac->mac = mac->mac ? : entry->mac;
+		mac->xpcs = mac->xpcs ? : entry->xpcs;
 		mac->ptp = mac->ptp ? : entry->hwtimestamp;
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 431cf4261264..ebc7f9048094 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -509,6 +509,7 @@ struct stmmac_regs_off {
 };
 
 extern const struct stmmac_ops dwmac100_ops;
+extern const struct stmmac_xpcs_ops xpcs_ops;
 extern const struct stmmac_dma_ops dwmac100_dma_ops;
 extern const struct stmmac_ops dwmac1000_ops;
 extern const struct stmmac_dma_ops dwmac1000_dma_ops;
@@ -517,6 +518,7 @@ struct stmmac_regs_off {
 extern const struct stmmac_ops dwmac410_ops;
 extern const struct stmmac_dma_ops dwmac410_dma_ops;
 extern const struct stmmac_ops dwmac510_ops;
+extern const struct stmmac_ops dwmac510_xpcs_ops;
 extern const struct stmmac_tc_ops dwmac510_tc_ops;
 extern const struct stmmac_ops dwxgmac210_ops;
 extern const struct stmmac_dma_ops dwxgmac210_dma_ops;
-- 
1.9.1

