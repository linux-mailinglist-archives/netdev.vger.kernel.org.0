Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BEC82483
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbfHESCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:02:12 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:56196 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729962AbfHESBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:01:35 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D7186C0265;
        Mon,  5 Aug 2019 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565028094; bh=ZScKZj7qhntAYFMoXsRRZOHL848j6J8v8glAt9eiNxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Dn8DPGN1OCa8WNnQkWtrPdv+ZACicrefj3DbESG7ujTNz4IjPjQzNukB9ZPAVOVah
         o9JDGjJTJNLb7IJPHgT7aCK9/RIZqTGlIr/Rdy36Dk1JcFkzRNnhRDoi3bHAC1XiH/
         h0GxxvVKyALNGFu/1gDuRuKHHf8f8tGdosIMhtsULbGvv1iJaWXI95kSH6AKqTWq8g
         ELRS6DF9DkBXQBwN2CJplh/Y0memI+P+nBO09XdIgw3CGaH3faHT+i0fxX4UErQJEb
         vfanhk52WGdNzri0nXu6TTG5/YbtM7TiBze5G6BGB1HFgep+mNe4ShRBafpnd2hJdF
         EWNtX3eI7wojQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 84323A0064;
        Mon,  5 Aug 2019 18:01:32 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/10] net: stmmac: xgmac: Implement MMC counters
Date:   Mon,  5 Aug 2019 20:01:15 +0200
Message-Id: <eb143f2abc5c7a1a22e13b14d7572821864f08ec.1565027782.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the MMC counters feature in XGMAC core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   1 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   9 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     | 192 +++++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   6 +
 7 files changed, 212 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 3174b701aa90..86a42bc39d21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -84,6 +84,7 @@
 #define XGMAC_HWFEAT_AVSEL		BIT(11)
 #define XGMAC_HWFEAT_RAVSEL		BIT(10)
 #define XGMAC_HWFEAT_ARPOFFSEL		BIT(9)
+#define XGMAC_HWFEAT_MMCSEL		BIT(8)
 #define XGMAC_HWFEAT_MGKSEL		BIT(7)
 #define XGMAC_HWFEAT_RWKSEL		BIT(6)
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index a4f236e3593e..0f1c772e892a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -356,6 +356,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
 	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
 	dma_cap->av &= (hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
+	dma_cap->rmon = (hw_cap & XGMAC_HWFEAT_MMCSEL) >> 8;
 	dma_cap->pmt_magic_frame = (hw_cap & XGMAC_HWFEAT_MGKSEL) >> 7;
 	dma_cap->pmt_remote_wake_up = (hw_cap & XGMAC_HWFEAT_RWKSEL) >> 6;
 	dma_cap->mbps_1000 = (hw_cap & XGMAC_HWFEAT_GMIISEL) >> 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 6c61b753b55e..3af2e5015245 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -201,7 +201,7 @@ static const struct stmmac_hwif_entry {
 		.min_id = DWXGMAC_CORE_2_10,
 		.regs = {
 			.ptp_off = PTP_XGMAC_OFFSET,
-			.mmc_off = 0,
+			.mmc_off = MMC_XGMAC_OFFSET,
 		},
 		.desc = &dwxgmac210_desc_ops,
 		.dma = &dwxgmac210_dma_ops,
@@ -209,7 +209,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
-		.mmc = NULL,
+		.mmc = &dwxgmac_mmc_ops,
 		.setup = dwxgmac2_setup,
 		.quirks = NULL,
 	},
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 278c0dbec9d9..00539a09d1db 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -503,6 +503,7 @@ extern const struct stmmac_ops dwxgmac210_ops;
 extern const struct stmmac_dma_ops dwxgmac210_dma_ops;
 extern const struct stmmac_desc_ops dwxgmac210_desc_ops;
 extern const struct stmmac_mmc_ops dwmac_mmc_ops;
+extern const struct stmmac_mmc_ops dwxgmac_mmc_ops;
 
 #define GMAC_VERSION		0x00000020	/* GMAC CORE Version */
 #define GMAC4_VERSION		0x00000110	/* GMAC4+ CORE Version */
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc.h b/drivers/net/ethernet/stmicro/stmmac/mmc.h
index 3587ceb9faf5..a0c05925883e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc.h
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc.h
@@ -24,6 +24,7 @@
 
 #define MMC_GMAC4_OFFSET		0x700
 #define MMC_GMAC3_X_OFFSET		0x100
+#define MMC_XGMAC_OFFSET		0x800
 
 struct stmmac_counters {
 	unsigned int mmc_tx_octetcount_gb;
@@ -116,6 +117,14 @@ struct stmmac_counters {
 	unsigned int mmc_rx_tcp_err_octets;
 	unsigned int mmc_rx_icmp_gd_octets;
 	unsigned int mmc_rx_icmp_err_octets;
+
+	/* FPE */
+	unsigned int mmc_tx_fpe_fragment_cntr;
+	unsigned int mmc_tx_hold_req_cntr;
+	unsigned int mmc_rx_packet_assembly_err_cntr;
+	unsigned int mmc_rx_packet_smd_err_cntr;
+	unsigned int mmc_rx_packet_assembly_ok_cntr;
+	unsigned int mmc_rx_fpe_fragment_cntr;
 };
 
 #endif /* __MMC_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
index a471db6d7b11..a223584f5f9a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -119,6 +119,64 @@
 #define MMC_RX_ICMP_GD_OCTETS		0x180
 #define MMC_RX_ICMP_ERR_OCTETS		0x184
 
+/* XGMAC MMC Registers */
+#define MMC_XGMAC_TX_OCTET_GB		0x14
+#define MMC_XGMAC_TX_PKT_GB		0x1c
+#define MMC_XGMAC_TX_BROAD_PKT_G	0x24
+#define MMC_XGMAC_TX_MULTI_PKT_G	0x2c
+#define MMC_XGMAC_TX_64OCT_GB		0x34
+#define MMC_XGMAC_TX_65OCT_GB		0x3c
+#define MMC_XGMAC_TX_128OCT_GB		0x44
+#define MMC_XGMAC_TX_256OCT_GB		0x4c
+#define MMC_XGMAC_TX_512OCT_GB		0x54
+#define MMC_XGMAC_TX_1024OCT_GB		0x5c
+#define MMC_XGMAC_TX_UNI_PKT_GB		0x64
+#define MMC_XGMAC_TX_MULTI_PKT_GB	0x6c
+#define MMC_XGMAC_TX_BROAD_PKT_GB	0x74
+#define MMC_XGMAC_TX_UNDER		0x7c
+#define MMC_XGMAC_TX_OCTET_G		0x84
+#define MMC_XGMAC_TX_PKT_G		0x8c
+#define MMC_XGMAC_TX_PAUSE		0x94
+#define MMC_XGMAC_TX_VLAN_PKT_G		0x9c
+#define MMC_XGMAC_TX_LPI_USEC		0xa4
+#define MMC_XGMAC_TX_LPI_TRAN		0xa8
+
+#define MMC_XGMAC_RX_PKT_GB		0x100
+#define MMC_XGMAC_RX_OCTET_GB		0x108
+#define MMC_XGMAC_RX_OCTET_G		0x110
+#define MMC_XGMAC_RX_BROAD_PKT_G	0x118
+#define MMC_XGMAC_RX_MULTI_PKT_G	0x120
+#define MMC_XGMAC_RX_CRC_ERR		0x128
+#define MMC_XGMAC_RX_RUNT_ERR		0x130
+#define MMC_XGMAC_RX_JABBER_ERR		0x134
+#define MMC_XGMAC_RX_UNDER		0x138
+#define MMC_XGMAC_RX_OVER		0x13c
+#define MMC_XGMAC_RX_64OCT_GB		0x140
+#define MMC_XGMAC_RX_65OCT_GB		0x148
+#define MMC_XGMAC_RX_128OCT_GB		0x150
+#define MMC_XGMAC_RX_256OCT_GB		0x158
+#define MMC_XGMAC_RX_512OCT_GB		0x160
+#define MMC_XGMAC_RX_1024OCT_GB		0x168
+#define MMC_XGMAC_RX_UNI_PKT_G		0x170
+#define MMC_XGMAC_RX_LENGTH_ERR		0x178
+#define MMC_XGMAC_RX_RANGE		0x180
+#define MMC_XGMAC_RX_PAUSE		0x188
+#define MMC_XGMAC_RX_FIFOOVER_PKT	0x190
+#define MMC_XGMAC_RX_VLAN_PKT_GB	0x198
+#define MMC_XGMAC_RX_WATCHDOG_ERR	0x1a0
+#define MMC_XGMAC_RX_LPI_USEC		0x1a4
+#define MMC_XGMAC_RX_LPI_TRAN		0x1a8
+#define MMC_XGMAC_RX_DISCARD_PKT_GB	0x1ac
+#define MMC_XGMAC_RX_DISCARD_OCT_GB	0x1b4
+#define MMC_XGMAC_RX_ALIGN_ERR_PKT	0x1bc
+
+#define MMC_XGMAC_TX_FPE_FRAG		0x208
+#define MMC_XGMAC_TX_HOLD_REQ		0x20c
+#define MMC_XGMAC_RX_PKT_ASSEMBLY_ERR	0x228
+#define MMC_XGMAC_RX_PKT_SMD_ERR	0x22c
+#define MMC_XGMAC_RX_PKT_ASSEMBLY_OK	0x230
+#define MMC_XGMAC_RX_FPE_FRAG		0x234
+
 static void dwmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
 {
 	u32 value = readl(mmcaddr + MMC_CNTRL);
@@ -263,3 +321,137 @@ const struct stmmac_mmc_ops dwmac_mmc_ops = {
 	.intr_all_mask = dwmac_mmc_intr_all_mask,
 	.read = dwmac_mmc_read,
 };
+
+static void dwxgmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
+{
+	u32 value = readl(mmcaddr + MMC_CNTRL);
+
+	value |= (mode & 0x3F);
+
+	writel(value, mmcaddr + MMC_CNTRL);
+}
+
+static void dwxgmac_mmc_intr_all_mask(void __iomem *mmcaddr)
+{
+	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_RX_INTR_MASK);
+	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_TX_INTR_MASK);
+}
+
+static void dwxgmac_read_mmc_reg(void __iomem *addr, u32 reg, u32 *dest)
+{
+	u64 tmp = 0;
+
+	tmp += readl(addr + reg);
+	tmp += ((u64 )readl(addr + reg + 0x4)) << 32;
+	if (tmp > GENMASK(31, 0))
+		*dest = ~0x0;
+	else
+		*dest = *dest + tmp;
+}
+
+/* This reads the MAC core counters (if actaully supported).
+ * by default the MMC core is programmed to reset each
+ * counter after a read. So all the field of the mmc struct
+ * have to be incremented.
+ */
+static void dwxgmac_mmc_read(void __iomem *mmcaddr, struct stmmac_counters *mmc)
+{
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_OCTET_GB,
+			     &mmc->mmc_tx_octetcount_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_PKT_GB,
+			     &mmc->mmc_tx_framecount_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_BROAD_PKT_G,
+			     &mmc->mmc_tx_broadcastframe_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_MULTI_PKT_G,
+			     &mmc->mmc_tx_multicastframe_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_64OCT_GB,
+			     &mmc->mmc_tx_64_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_65OCT_GB,
+			     &mmc->mmc_tx_65_to_127_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_128OCT_GB,
+			     &mmc->mmc_tx_128_to_255_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_256OCT_GB,
+			     &mmc->mmc_tx_256_to_511_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_512OCT_GB,
+			     &mmc->mmc_tx_512_to_1023_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_1024OCT_GB,
+			     &mmc->mmc_tx_1024_to_max_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_UNI_PKT_GB,
+			     &mmc->mmc_tx_unicast_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_MULTI_PKT_GB,
+			     &mmc->mmc_tx_multicast_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_BROAD_PKT_GB,
+			     &mmc->mmc_tx_broadcast_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_UNDER,
+			     &mmc->mmc_tx_underflow_error);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_OCTET_G,
+			     &mmc->mmc_tx_octetcount_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_PKT_G,
+			     &mmc->mmc_tx_framecount_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_PAUSE,
+			     &mmc->mmc_tx_pause_frame);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_TX_VLAN_PKT_G,
+			     &mmc->mmc_tx_vlan_frame_g);
+
+	/* MMC RX counter registers */
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_PKT_GB,
+			     &mmc->mmc_rx_framecount_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_OCTET_GB,
+			     &mmc->mmc_rx_octetcount_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_OCTET_G,
+			     &mmc->mmc_rx_octetcount_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_BROAD_PKT_G,
+			     &mmc->mmc_rx_broadcastframe_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_MULTI_PKT_G,
+			     &mmc->mmc_rx_multicastframe_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_CRC_ERR,
+			     &mmc->mmc_rx_crc_error);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_CRC_ERR,
+			     &mmc->mmc_rx_crc_error);
+	mmc->mmc_rx_run_error += readl(mmcaddr + MMC_XGMAC_RX_RUNT_ERR);
+	mmc->mmc_rx_jabber_error += readl(mmcaddr + MMC_XGMAC_RX_JABBER_ERR);
+	mmc->mmc_rx_undersize_g += readl(mmcaddr + MMC_XGMAC_RX_UNDER);
+	mmc->mmc_rx_oversize_g += readl(mmcaddr + MMC_XGMAC_RX_OVER);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_64OCT_GB,
+			     &mmc->mmc_rx_64_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_65OCT_GB,
+			     &mmc->mmc_rx_65_to_127_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_128OCT_GB,
+			     &mmc->mmc_rx_128_to_255_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_256OCT_GB,
+			     &mmc->mmc_rx_256_to_511_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_512OCT_GB,
+			     &mmc->mmc_rx_512_to_1023_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_1024OCT_GB,
+			     &mmc->mmc_rx_1024_to_max_octets_gb);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_UNI_PKT_G,
+			     &mmc->mmc_rx_unicast_g);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_LENGTH_ERR,
+			     &mmc->mmc_rx_length_error);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_RANGE,
+			     &mmc->mmc_rx_autofrangetype);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_PAUSE,
+			     &mmc->mmc_rx_pause_frames);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_FIFOOVER_PKT,
+			     &mmc->mmc_rx_fifo_overflow);
+	dwxgmac_read_mmc_reg(mmcaddr, MMC_XGMAC_RX_VLAN_PKT_GB,
+			     &mmc->mmc_rx_vlan_frames_gb);
+	mmc->mmc_rx_watchdog_error += readl(mmcaddr + MMC_XGMAC_RX_WATCHDOG_ERR);
+
+	mmc->mmc_tx_fpe_fragment_cntr += readl(mmcaddr + MMC_XGMAC_TX_FPE_FRAG);
+	mmc->mmc_tx_hold_req_cntr += readl(mmcaddr + MMC_XGMAC_TX_HOLD_REQ);
+	mmc->mmc_rx_packet_assembly_err_cntr +=
+		readl(mmcaddr + MMC_XGMAC_RX_PKT_ASSEMBLY_ERR);
+	mmc->mmc_rx_packet_smd_err_cntr +=
+		readl(mmcaddr + MMC_XGMAC_RX_PKT_SMD_ERR);
+	mmc->mmc_rx_packet_assembly_ok_cntr +=
+		readl(mmcaddr + MMC_XGMAC_RX_PKT_ASSEMBLY_OK);
+	mmc->mmc_rx_fpe_fragment_cntr +=
+		readl(mmcaddr + MMC_XGMAC_RX_FPE_FRAG);
+}
+
+const struct stmmac_mmc_ops dwxgmac_mmc_ops = {
+	.ctrl = dwxgmac_mmc_ctrl,
+	.intr_all_mask = dwxgmac_mmc_intr_all_mask,
+	.read = dwxgmac_mmc_read,
+};
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 6efb66820d4c..d294590cba27 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -243,6 +243,12 @@ static const struct stmmac_stats stmmac_mmc[] = {
 	STMMAC_MMC_STAT(mmc_rx_tcp_err_octets),
 	STMMAC_MMC_STAT(mmc_rx_icmp_gd_octets),
 	STMMAC_MMC_STAT(mmc_rx_icmp_err_octets),
+	STMMAC_MMC_STAT(mmc_tx_fpe_fragment_cntr),
+	STMMAC_MMC_STAT(mmc_tx_hold_req_cntr),
+	STMMAC_MMC_STAT(mmc_rx_packet_assembly_err_cntr),
+	STMMAC_MMC_STAT(mmc_rx_packet_smd_err_cntr),
+	STMMAC_MMC_STAT(mmc_rx_packet_assembly_ok_cntr),
+	STMMAC_MMC_STAT(mmc_rx_fpe_fragment_cntr),
 };
 #define STMMAC_MMC_STATS_LEN ARRAY_SIZE(stmmac_mmc)
 
-- 
2.7.4

