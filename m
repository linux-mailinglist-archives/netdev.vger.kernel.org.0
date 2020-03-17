Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1202D187BE6
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgCQJTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:19:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48642 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgCQJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:19:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CD86240216;
        Tue, 17 Mar 2020 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584436750; bh=Du0EVgLnk2N+x8KKI9BRY6gwpsCtPCw91bTQ+xoRIBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gsYJJ6208idrSghOO4/asihHHkdL4I+PxzJYnMsrEGUzvMuVAQrvNklVCCy923agP
         WIKGpvRDbU3D42Y9vB6aRbQQPbyNNkWt9a2PH7fW1zTGpR3vzlP4mo8QqxyGNghEFB
         4KsPei/vlcS1Bim5ylx4IVfcgwuV8jK/qCWwuBcfjI8l08gu4Jeiidw72OnPaej8n/
         zZxCy3CAQJwwVP/ZJ26qcqNFowxVXx8sSoISr2cYEcVphOQ6Ps6+XyHQdGlCAiG9eU
         VDqvQ1vStW1/Bmp5PIN58wue4rFCsMsEt1apHi1cSGx0rRspJ/4uQkNlSGXVaFGPa5
         RGo1mVes3GgEQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4E91CA0068;
        Tue, 17 Mar 2020 09:19:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/4] net: stmmac: Add support for Enterprise MAC version
Date:   Tue, 17 Mar 2020 10:18:52 +0100
Message-Id: <e5f2bad98becf9fcc8dc0904de11c591a568dca1.1584436401.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the support for Enterprise MAC IP version which is very similar to
XGMAC. It's so similar that we just need to check the device id and add
new speeds definitions and some minor callbacks.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  7 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 99 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h    | 22 +++++
 drivers/net/ethernet/stmicro/stmmac/hwif.c         | 45 +++++++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  1 +
 5 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 7fd073144bac..386663208c23 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -34,6 +34,11 @@
 #define DWMAC_CORE_5_00		0x50
 #define DWMAC_CORE_5_10		0x51
 #define DWXGMAC_CORE_2_10	0x21
+#define DWXLGMAC_CORE_2_00	0x20
+
+/* Device ID */
+#define DWXGMAC_ID		0x76
+#define DWXLGMAC_ID		0x27
 
 #define STMMAC_CHAN0	0	/* Always supported and default for all chips */
 
@@ -465,6 +470,7 @@ struct mac_device_info {
 	unsigned int pcs;
 	unsigned int pmt;
 	unsigned int ps;
+	unsigned int xlgmac;
 };
 
 struct stmmac_rx_routing {
@@ -476,6 +482,7 @@ int dwmac100_setup(struct stmmac_priv *priv);
 int dwmac1000_setup(struct stmmac_priv *priv);
 int dwmac4_setup(struct stmmac_priv *priv);
 int dwxgmac2_setup(struct stmmac_priv *priv);
+int dwxlgmac2_setup(struct stmmac_priv *priv);
 
 void stmmac_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
 			 unsigned int high, unsigned int low);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 67b754a56288..0e4575f7bedb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -9,6 +9,7 @@
 #include <linux/iopoll.h>
 #include "stmmac.h"
 #include "stmmac_ptp.h"
+#include "dwxlgmac2.h"
 #include "dwxgmac2.h"
 
 static void dwxgmac2_core_init(struct mac_device_info *hw,
@@ -1485,6 +1486,67 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.fpe_configure = dwxgmac3_fpe_configure,
 };
 
+static void dwxlgmac2_rx_queue_enable(struct mac_device_info *hw, u8 mode,
+				      u32 queue)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + XLGMAC_RXQ_ENABLE_CTRL0) & ~XGMAC_RXQEN(queue);
+	if (mode == MTL_QUEUE_AVB)
+		value |= 0x1 << XGMAC_RXQEN_SHIFT(queue);
+	else if (mode == MTL_QUEUE_DCB)
+		value |= 0x2 << XGMAC_RXQEN_SHIFT(queue);
+	writel(value, ioaddr + XLGMAC_RXQ_ENABLE_CTRL0);
+}
+
+const struct stmmac_ops dwxlgmac2_ops = {
+	.core_init = dwxgmac2_core_init,
+	.set_mac = dwxgmac2_set_mac,
+	.rx_ipc = dwxgmac2_rx_ipc,
+	.rx_queue_enable = dwxlgmac2_rx_queue_enable,
+	.rx_queue_prio = dwxgmac2_rx_queue_prio,
+	.tx_queue_prio = dwxgmac2_tx_queue_prio,
+	.rx_queue_routing = NULL,
+	.prog_mtl_rx_algorithms = dwxgmac2_prog_mtl_rx_algorithms,
+	.prog_mtl_tx_algorithms = dwxgmac2_prog_mtl_tx_algorithms,
+	.set_mtl_tx_queue_weight = dwxgmac2_set_mtl_tx_queue_weight,
+	.map_mtl_to_dma = dwxgmac2_map_mtl_to_dma,
+	.config_cbs = dwxgmac2_config_cbs,
+	.dump_regs = dwxgmac2_dump_regs,
+	.host_irq_status = dwxgmac2_host_irq_status,
+	.host_mtl_irq_status = dwxgmac2_host_mtl_irq_status,
+	.flow_ctrl = dwxgmac2_flow_ctrl,
+	.pmt = dwxgmac2_pmt,
+	.set_umac_addr = dwxgmac2_set_umac_addr,
+	.get_umac_addr = dwxgmac2_get_umac_addr,
+	.set_eee_mode = dwxgmac2_set_eee_mode,
+	.reset_eee_mode = dwxgmac2_reset_eee_mode,
+	.set_eee_timer = dwxgmac2_set_eee_timer,
+	.set_eee_pls = dwxgmac2_set_eee_pls,
+	.pcs_ctrl_ane = NULL,
+	.pcs_rane = NULL,
+	.pcs_get_adv_lp = NULL,
+	.debug = NULL,
+	.set_filter = dwxgmac2_set_filter,
+	.safety_feat_config = dwxgmac3_safety_feat_config,
+	.safety_feat_irq_status = dwxgmac3_safety_feat_irq_status,
+	.safety_feat_dump = dwxgmac3_safety_feat_dump,
+	.set_mac_loopback = dwxgmac2_set_mac_loopback,
+	.rss_configure = dwxgmac2_rss_configure,
+	.update_vlan_hash = dwxgmac2_update_vlan_hash,
+	.rxp_config = dwxgmac3_rxp_config,
+	.get_mac_tx_timestamp = dwxgmac2_get_mac_tx_timestamp,
+	.flex_pps_config = dwxgmac2_flex_pps_config,
+	.sarc_configure = dwxgmac2_sarc_configure,
+	.enable_vlan = dwxgmac2_enable_vlan,
+	.config_l3_filter = dwxgmac2_config_l3_filter,
+	.config_l4_filter = dwxgmac2_config_l4_filter,
+	.set_arp_offload = dwxgmac2_set_arp_offload,
+	.est_configure = dwxgmac3_est_configure,
+	.fpe_configure = dwxgmac3_fpe_configure,
+};
+
 int dwxgmac2_setup(struct stmmac_priv *priv)
 {
 	struct mac_device_info *mac = priv->hw;
@@ -1521,3 +1583,40 @@ int dwxgmac2_setup(struct stmmac_priv *priv)
 
 	return 0;
 }
+
+int dwxlgmac2_setup(struct stmmac_priv *priv)
+{
+	struct mac_device_info *mac = priv->hw;
+
+	dev_info(priv->device, "\tXLGMAC\n");
+
+	priv->dev->priv_flags |= IFF_UNICAST_FLT;
+	mac->pcsr = priv->ioaddr;
+	mac->multicast_filter_bins = priv->plat->multicast_filter_bins;
+	mac->unicast_filter_entries = priv->plat->unicast_filter_entries;
+	mac->mcast_bits_log2 = 0;
+
+	if (mac->multicast_filter_bins)
+		mac->mcast_bits_log2 = ilog2(mac->multicast_filter_bins);
+
+	mac->link.duplex = 0;
+	mac->link.speed1000 = XLGMAC_CONFIG_SS_1000;
+	mac->link.speed2500 = XLGMAC_CONFIG_SS_2500;
+	mac->link.xgmii.speed10000 = XLGMAC_CONFIG_SS_10G;
+	mac->link.xlgmii.speed25000 = XLGMAC_CONFIG_SS_25G;
+	mac->link.xlgmii.speed40000 = XLGMAC_CONFIG_SS_40G;
+	mac->link.xlgmii.speed50000 = XLGMAC_CONFIG_SS_50G;
+	mac->link.xlgmii.speed100000 = XLGMAC_CONFIG_SS_100G;
+	mac->link.speed_mask = XLGMAC_CONFIG_SS;
+
+	mac->mii.addr = XGMAC_MDIO_ADDR;
+	mac->mii.data = XGMAC_MDIO_DATA;
+	mac->mii.addr_shift = 16;
+	mac->mii.addr_mask = GENMASK(20, 16);
+	mac->mii.reg_shift = 0;
+	mac->mii.reg_mask = GENMASK(15, 0);
+	mac->mii.clk_csr_shift = 19;
+	mac->mii.clk_csr_mask = GENMASK(21, 19);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h
new file mode 100644
index 000000000000..726090d49221
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2020 Synopsys, Inc. and/or its affiliates.
+ * Synopsys DesignWare XLGMAC definitions.
+ */
+
+#ifndef __STMMAC_DWXLGMAC2_H__
+#define __STMMAC_DWXLGMAC2_H__
+
+/* MAC Registers */
+#define XLGMAC_CONFIG_SS		GENMASK(30, 28)
+#define XLGMAC_CONFIG_SS_SHIFT		28
+#define XLGMAC_CONFIG_SS_40G		(0x0 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_25G		(0x1 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_50G		(0x2 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_100G		(0x3 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_10G		(0x4 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_2500		(0x6 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_CONFIG_SS_1000		(0x7 << XLGMAC_CONFIG_SS_SHIFT)
+#define XLGMAC_RXQ_ENABLE_CTRL0		0x00000140
+
+#endif /* __STMMAC_DWXLGMAC2_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 3af2e5015245..bb7114f970f8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -23,6 +23,18 @@ static u32 stmmac_get_id(struct stmmac_priv *priv, u32 id_reg)
 	return reg & GENMASK(7, 0);
 }
 
+static u32 stmmac_get_dev_id(struct stmmac_priv *priv, u32 id_reg)
+{
+	u32 reg = readl(priv->ioaddr + id_reg);
+
+	if (!reg) {
+		dev_info(priv->device, "Version ID not available\n");
+		return 0x0;
+	}
+
+	return (reg & GENMASK(15, 8)) >> 8;
+}
+
 static void stmmac_dwmac_mode_quirk(struct stmmac_priv *priv)
 {
 	struct mac_device_info *mac = priv->hw;
@@ -69,11 +81,18 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 	return 0;
 }
 
+static int stmmac_dwxlgmac_quirks(struct stmmac_priv *priv)
+{
+	priv->hw->xlgmac = true;
+	return 0;
+}
+
 static const struct stmmac_hwif_entry {
 	bool gmac;
 	bool gmac4;
 	bool xgmac;
 	u32 min_id;
+	u32 dev_id;
 	const struct stmmac_regs_off regs;
 	const void *desc;
 	const void *dma;
@@ -199,6 +218,7 @@ static const struct stmmac_hwif_entry {
 		.gmac4 = false,
 		.xgmac = true,
 		.min_id = DWXGMAC_CORE_2_10,
+		.dev_id = DWXGMAC_ID,
 		.regs = {
 			.ptp_off = PTP_XGMAC_OFFSET,
 			.mmc_off = MMC_XGMAC_OFFSET,
@@ -212,6 +232,25 @@ static const struct stmmac_hwif_entry {
 		.mmc = &dwxgmac_mmc_ops,
 		.setup = dwxgmac2_setup,
 		.quirks = NULL,
+	}, {
+		.gmac = false,
+		.gmac4 = false,
+		.xgmac = true,
+		.min_id = DWXLGMAC_CORE_2_00,
+		.dev_id = DWXLGMAC_ID,
+		.regs = {
+			.ptp_off = PTP_XGMAC_OFFSET,
+			.mmc_off = MMC_XGMAC_OFFSET,
+		},
+		.desc = &dwxgmac210_desc_ops,
+		.dma = &dwxgmac210_dma_ops,
+		.mac = &dwxlgmac2_ops,
+		.hwtimestamp = &stmmac_ptp,
+		.mode = NULL,
+		.tc = &dwmac510_tc_ops,
+		.mmc = &dwxgmac_mmc_ops,
+		.setup = dwxlgmac2_setup,
+		.quirks = stmmac_dwxlgmac_quirks,
 	},
 };
 
@@ -223,13 +262,15 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 	const struct stmmac_hwif_entry *entry;
 	struct mac_device_info *mac;
 	bool needs_setup = true;
+	u32 id, dev_id = 0;
 	int i, ret;
-	u32 id;
 
 	if (needs_gmac) {
 		id = stmmac_get_id(priv, GMAC_VERSION);
 	} else if (needs_gmac4 || needs_xgmac) {
 		id = stmmac_get_id(priv, GMAC4_VERSION);
+		if (needs_xgmac)
+			dev_id = stmmac_get_dev_id(priv, GMAC4_VERSION);
 	} else {
 		id = 0;
 	}
@@ -267,6 +308,8 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		/* Use synopsys_id var because some setups can override this */
 		if (priv->synopsys_id < entry->min_id)
 			continue;
+		if (needs_xgmac && (dev_id ^ entry->dev_id))
+			continue;
 
 		/* Only use generic HW helpers if needed */
 		mac->desc = mac->desc ? : entry->desc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index c71dd99c8abf..fc350149ba34 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -605,6 +605,7 @@ extern const struct stmmac_dma_ops dwmac410_dma_ops;
 extern const struct stmmac_ops dwmac510_ops;
 extern const struct stmmac_tc_ops dwmac510_tc_ops;
 extern const struct stmmac_ops dwxgmac210_ops;
+extern const struct stmmac_ops dwxlgmac2_ops;
 extern const struct stmmac_dma_ops dwxgmac210_dma_ops;
 extern const struct stmmac_desc_ops dwxgmac210_desc_ops;
 extern const struct stmmac_mmc_ops dwmac_mmc_ops;
-- 
2.7.4

