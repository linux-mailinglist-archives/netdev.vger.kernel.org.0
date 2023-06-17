Return-Path: <netdev+bounces-11737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED3873412F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 15:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 942AF1C20ACA
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 13:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244C2944E;
	Sat, 17 Jun 2023 13:21:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFEAA944;
	Sat, 17 Jun 2023 13:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D070DC433C8;
	Sat, 17 Jun 2023 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687008081;
	bh=Q1lN2/BBNV3/2tmFhAOu8OGb4rLD9CVOVTuMW+78ygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qlrc9SiUv/fhzm0lvvR8Bor38D+QbE17jxSNpRBRNlQCWyUCPNshkilWTjMXb3+Yg
	 93HB94SydoyO/5m4mUBFJlsOQovncXadr/AMyYx1++WnhcBAjBJ8qtxC46lWMriIln
	 y4XsFUidCIOPTlkVhwiK9QWgoB3i+vuKvAGZNtpCZZPDpkmNSW+y5aywFk+RqRBuS8
	 7CNXz0h4B5YmU6A00vqKZdr8Ka/VTnHh55skjQsrL+X6udKkuNrR+tWH9TFxvoeuDr
	 aOv4NMnmHbXaLNy7Ex43cpv7C/8LyHj6XCFWGeQdCfJhTJKroOWPgq006IC84VBhxF
	 MfPpPtjpE0q5g==
From: Jisheng Zhang <jszhang@kernel.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 2/2] net: stmmac: use pcpu 64 bit statistics where necessary
Date: Sat, 17 Jun 2023 21:09:43 +0800
Message-Id: <20230617130943.2776-3-jszhang@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230617130943.2776-1-jszhang@kernel.org>
References: <20230617130943.2776-1-jszhang@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, there are two major issues with stmmac driver statistics
First of all, statistics in stmmac_extra_stats, stmmac_rxq_stats
and stmmac_txq_stats are 32 bit variables on 32 bit platforms. This
can cause some stats to overflow after several minutes of
high traffic, for example rx_pkt_n, tx_pkt_n and so on.

Secondly, iff HW supports multiqueues, there are frequent cacheline
ping pongs on some driver statistic vars, for example, normal_irq_n,
tx_pkt_n and so on. What's more, frequent cacheline ping pongs on
normal_irq_n happens in ISR, this makes the situation worse.

To improve the driver, we convert those statistics to 64 bit, implement
ndo_get_stats64 and update .get_ethtool_stats implementation
accordingly. We also use pcpu statistics where necessary to remove the
cacheline ping pongs as much as possible to make multiqueue operations
faster. Those statistics which are not possible to overflow and not
frequently updated are kept as is.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  54 +++--
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  15 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |   7 +-
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  15 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  10 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   6 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  13 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  20 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  12 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  15 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 101 +++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 184 +++++++++++++-----
 13 files changed, 303 insertions(+), 162 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 16e67c18b6f7..ac19e7a02ad2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -59,19 +59,44 @@
 /* #define FRAME_FILTER_DEBUG */
 
 struct stmmac_txq_stats {
-	unsigned long tx_pkt_n;
-	unsigned long tx_normal_irq_n;
+	u64 tx_pkt_n;
+	u64 tx_normal_irq_n;
 };
 
 struct stmmac_rxq_stats {
-	unsigned long rx_pkt_n;
-	unsigned long rx_normal_irq_n;
+	u64 rx_pkt_n;
+	u64 rx_normal_irq_n;
+};
+
+struct stmmac_pcpu_stats {
+	struct u64_stats_sync syncp;
+	/* per queue statistics */
+	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
+	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
+	/* device stats */
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 tx_packets;
+	u64 tx_bytes;
+	/* Tx/Rx IRQ Events */
+	u64 tx_pkt_n;
+	u64 rx_pkt_n;
+	u64 normal_irq_n;
+	u64 rx_normal_irq_n;
+	u64 napi_poll;
+	u64 tx_normal_irq_n;
+	u64 tx_clean;
+	u64 tx_set_ic_bit;
+	/* TSO */
+	u64 tx_tso_frames;
+	u64 tx_tso_nfrags;
 };
 
 /* Extra statistic and debug information exposed by ethtool */
 struct stmmac_extra_stats {
+	struct stmmac_pcpu_stats __percpu *pstats;
 	/* Transmit errors */
-	unsigned long tx_underflow ____cacheline_aligned;
+	unsigned long tx_underflow;
 	unsigned long tx_carrier;
 	unsigned long tx_losscarrier;
 	unsigned long vlan_tag;
@@ -81,6 +106,7 @@ struct stmmac_extra_stats {
 	unsigned long tx_frame_flushed;
 	unsigned long tx_payload_error;
 	unsigned long tx_ip_header_error;
+	unsigned long tx_collision;
 	/* Receive errors */
 	unsigned long rx_desc;
 	unsigned long sa_filter_fail;
@@ -113,14 +139,6 @@ struct stmmac_extra_stats {
 	/* Tx/Rx IRQ Events */
 	unsigned long rx_early_irq;
 	unsigned long threshold;
-	unsigned long tx_pkt_n;
-	unsigned long rx_pkt_n;
-	unsigned long normal_irq_n;
-	unsigned long rx_normal_irq_n;
-	unsigned long napi_poll;
-	unsigned long tx_normal_irq_n;
-	unsigned long tx_clean;
-	unsigned long tx_set_ic_bit;
 	unsigned long irq_receive_pmt_irq_n;
 	/* MMC info */
 	unsigned long mmc_tx_irq_n;
@@ -190,18 +208,16 @@ struct stmmac_extra_stats {
 	unsigned long mtl_rx_fifo_ctrl_active;
 	unsigned long mac_rx_frame_ctrl_fifo;
 	unsigned long mac_gmii_rx_proto_engine;
-	/* TSO */
-	unsigned long tx_tso_frames;
-	unsigned long tx_tso_nfrags;
 	/* EST */
 	unsigned long mtl_est_cgce;
 	unsigned long mtl_est_hlbs;
 	unsigned long mtl_est_hlbf;
 	unsigned long mtl_est_btre;
 	unsigned long mtl_est_btrlm;
-	/* per queue statistics */
-	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
-	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
+	unsigned long rx_dropped;
+	unsigned long rx_errors;
+	unsigned long tx_dropped;
+	unsigned long tx_errors;
 };
 
 /* Safety Feature statistics exposed by ethtool */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 1e714380d125..6b02c52ce917 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -440,6 +440,7 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 				     struct stmmac_extra_stats *x, u32 chan,
 				     u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	u32 v;
 	int ret = 0;
 
@@ -450,11 +451,18 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 	else if (dir == DMA_DIR_TX)
 		v &= EMAC_INT_MSK_TX;
 
+	u64_stats_update_begin(&stats->syncp);
 	if (v & EMAC_TX_INT) {
 		ret |= handle_tx;
-		x->tx_normal_irq_n++;
+		stats->tx_normal_irq_n++;
 	}
 
+	if (v & EMAC_RX_INT) {
+		ret |= handle_rx;
+		stats->rx_normal_irq_n++;
+	}
+	u64_stats_update_end(&stats->syncp);
+
 	if (v & EMAC_TX_DMA_STOP_INT)
 		x->tx_process_stopped_irq++;
 
@@ -472,11 +480,6 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 	if (v & EMAC_TX_EARLY_INT)
 		x->tx_early_irq++;
 
-	if (v & EMAC_RX_INT) {
-		ret |= handle_rx;
-		x->rx_normal_irq_n++;
-	}
-
 	if (v & EMAC_RX_BUF_UA_INT)
 		x->rx_buf_unav_irq++;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
index 1c32b1788f02..dea270f60cc3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c
@@ -82,29 +82,24 @@ static void dwmac100_dump_dma_regs(struct stmmac_priv *priv,
 }
 
 /* DMA controller has two counters to track the number of the missed frames. */
-static void dwmac100_dma_diagnostic_fr(struct net_device_stats *stats,
-				       struct stmmac_extra_stats *x,
+static void dwmac100_dma_diagnostic_fr(struct stmmac_extra_stats *x,
 				       void __iomem *ioaddr)
 {
 	u32 csr8 = readl(ioaddr + DMA_MISSED_FRAME_CTR);
 
 	if (unlikely(csr8)) {
 		if (csr8 & DMA_MISSED_FRAME_OVE) {
-			stats->rx_over_errors += 0x800;
 			x->rx_overflow_cntr += 0x800;
 		} else {
 			unsigned int ove_cntr;
 			ove_cntr = ((csr8 & DMA_MISSED_FRAME_OVE_CNTR) >> 17);
-			stats->rx_over_errors += ove_cntr;
 			x->rx_overflow_cntr += ove_cntr;
 		}
 
 		if (csr8 & DMA_MISSED_FRAME_OVE_M) {
-			stats->rx_missed_errors += 0xffff;
 			x->rx_missed_cntr += 0xffff;
 		} else {
 			unsigned int miss_f = (csr8 & DMA_MISSED_FRAME_M_CNTR);
-			stats->rx_missed_errors += miss_f;
 			x->rx_missed_cntr += miss_f;
 		}
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 6a011d8633e8..f0c71c281fc1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -13,8 +13,7 @@
 #include "dwmac4.h"
 #include "dwmac4_descs.h"
 
-static int dwmac4_wrback_get_tx_status(struct net_device_stats *stats,
-				       struct stmmac_extra_stats *x,
+static int dwmac4_wrback_get_tx_status(struct stmmac_extra_stats *x,
 				       struct dma_desc *p,
 				       void __iomem *ioaddr)
 {
@@ -40,15 +39,13 @@ static int dwmac4_wrback_get_tx_status(struct net_device_stats *stats,
 			x->tx_frame_flushed++;
 		if (unlikely(tdes3 & TDES3_LOSS_CARRIER)) {
 			x->tx_losscarrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely(tdes3 & TDES3_NO_CARRIER)) {
 			x->tx_carrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely((tdes3 & TDES3_LATE_COLLISION) ||
 			     (tdes3 & TDES3_EXCESSIVE_COLLISION)))
-			stats->collisions +=
+			x->tx_collision +=
 			    (tdes3 & TDES3_COLLISION_COUNT_MASK)
 			    >> TDES3_COLLISION_COUNT_SHIFT;
 
@@ -73,8 +70,7 @@ static int dwmac4_wrback_get_tx_status(struct net_device_stats *stats,
 	return ret;
 }
 
-static int dwmac4_wrback_get_rx_status(struct net_device_stats *stats,
-				       struct stmmac_extra_stats *x,
+static int dwmac4_wrback_get_rx_status(struct stmmac_extra_stats *x,
 				       struct dma_desc *p)
 {
 	unsigned int rdes1 = le32_to_cpu(p->des1);
@@ -93,7 +89,7 @@ static int dwmac4_wrback_get_rx_status(struct net_device_stats *stats,
 
 	if (unlikely(rdes3 & RDES3_ERROR_SUMMARY)) {
 		if (unlikely(rdes3 & RDES3_GIANT_PACKET))
-			stats->rx_length_errors++;
+			x->rx_length++;
 		if (unlikely(rdes3 & RDES3_OVERFLOW_ERROR))
 			x->rx_gmac_overflow++;
 
@@ -105,7 +101,6 @@ static int dwmac4_wrback_get_rx_status(struct net_device_stats *stats,
 
 		if (unlikely(rdes3 & RDES3_CRC_ERROR)) {
 			x->rx_crc_errors++;
-			stats->rx_crc_errors++;
 		}
 
 		if (unlikely(rdes3 & RDES3_DRIBBLE_ERROR))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index df41eac54058..6de82cb919ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -168,6 +168,7 @@ void dwmac410_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
 int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(dwmac4_addrs, chan));
 	u32 intr_en = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
@@ -198,18 +199,22 @@ int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 		}
 	}
 	/* TX/RX NORMAL interrupts */
+	u64_stats_update_begin(&stats->syncp);
 	if (likely(intr_status & DMA_CHAN_STATUS_NIS))
-		x->normal_irq_n++;
+		stats->normal_irq_n++;
+
 	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
-		x->rx_normal_irq_n++;
-		x->rxq_stats[chan].rx_normal_irq_n++;
+		stats->rx_normal_irq_n++;
+		stats->rxq_stats[chan].rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
 	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
-		x->tx_normal_irq_n++;
-		x->txq_stats[chan].tx_normal_irq_n++;
+		stats->tx_normal_irq_n++;
+		stats->txq_stats[chan].tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
+	u64_stats_update_end(&stats->syncp);
+
 	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
 		ret |= handle_tx;
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 0b6f999a8305..bb938b334313 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -10,6 +10,7 @@
 #include <linux/iopoll.h>
 #include "common.h"
 #include "dwmac_dma.h"
+#include "stmmac.h"
 
 #define GMAC_HI_REG_AE		0x80000000
 
@@ -161,6 +162,7 @@ static void show_rx_process_state(unsigned int status)
 int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	int ret = 0;
 	/* read the status register (CSR5) */
 	u32 intr_status = readl(ioaddr + DMA_STATUS);
@@ -208,19 +210,21 @@ int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 	}
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & DMA_STATUS_NIS)) {
-		x->normal_irq_n++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->normal_irq_n++;
 		if (likely(intr_status & DMA_STATUS_RI)) {
 			u32 value = readl(ioaddr + DMA_INTR_ENA);
 			/* to schedule NAPI on real RIE event. */
 			if (likely(value & DMA_INTR_ENA_RIE)) {
-				x->rx_normal_irq_n++;
+				stats->rx_normal_irq_n++;
 				ret |= handle_rx;
 			}
 		}
 		if (likely(intr_status & DMA_STATUS_TI)) {
-			x->tx_normal_irq_n++;
+			stats->tx_normal_irq_n++;
 			ret |= handle_tx;
 		}
+		u64_stats_update_end(&stats->syncp);
 		if (unlikely(intr_status & DMA_STATUS_ERI))
 			x->rx_early_irq++;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 13c347ee8be9..fc82862a612c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -8,8 +8,7 @@
 #include "common.h"
 #include "dwxgmac2.h"
 
-static int dwxgmac2_get_tx_status(struct net_device_stats *stats,
-				  struct stmmac_extra_stats *x,
+static int dwxgmac2_get_tx_status(struct stmmac_extra_stats *x,
 				  struct dma_desc *p, void __iomem *ioaddr)
 {
 	unsigned int tdes3 = le32_to_cpu(p->des3);
@@ -23,8 +22,7 @@ static int dwxgmac2_get_tx_status(struct net_device_stats *stats,
 	return ret;
 }
 
-static int dwxgmac2_get_rx_status(struct net_device_stats *stats,
-				  struct stmmac_extra_stats *x,
+static int dwxgmac2_get_rx_status(struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
 	unsigned int rdes3 = le32_to_cpu(p->des3);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 070bd912580b..5cf3e2f11892 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -337,6 +337,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 				  struct stmmac_extra_stats *x, u32 chan,
 				  u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	u32 intr_status = readl(ioaddr + XGMAC_DMA_CH_STATUS(chan));
 	u32 intr_en = readl(ioaddr + XGMAC_DMA_CH_INT_EN(chan));
 	int ret = 0;
@@ -364,18 +365,20 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & XGMAC_NIS)) {
-		x->normal_irq_n++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->normal_irq_n++;
 
 		if (likely(intr_status & XGMAC_RI)) {
-			x->rx_normal_irq_n++;
-			x->rxq_stats[chan].rx_normal_irq_n++;
+			stats->rx_normal_irq_n++;
+			stats->rxq_stats[chan].rx_normal_irq_n++;
 			ret |= handle_rx;
 		}
 		if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
-			x->tx_normal_irq_n++;
-			x->txq_stats[chan].tx_normal_irq_n++;
+			stats->tx_normal_irq_n++;
+			stats->txq_stats[chan].tx_normal_irq_n++;
 			ret |= handle_tx;
 		}
+		u64_stats_update_end(&stats->syncp);
 	}
 
 	/* Clear interrupts */
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index a91d8f13a931..937b7a0466fc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -12,8 +12,7 @@
 #include "common.h"
 #include "descs_com.h"
 
-static int enh_desc_get_tx_status(struct net_device_stats *stats,
-				  struct stmmac_extra_stats *x,
+static int enh_desc_get_tx_status(struct stmmac_extra_stats *x,
 				  struct dma_desc *p, void __iomem *ioaddr)
 {
 	unsigned int tdes0 = le32_to_cpu(p->des0);
@@ -38,15 +37,13 @@ static int enh_desc_get_tx_status(struct net_device_stats *stats,
 
 		if (unlikely(tdes0 & ETDES0_LOSS_CARRIER)) {
 			x->tx_losscarrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely(tdes0 & ETDES0_NO_CARRIER)) {
 			x->tx_carrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely((tdes0 & ETDES0_LATE_COLLISION) ||
 			     (tdes0 & ETDES0_EXCESSIVE_COLLISIONS)))
-			stats->collisions +=
+			x->tx_collision +=
 				(tdes0 & ETDES0_COLLISION_COUNT_MASK) >> 3;
 
 		if (unlikely(tdes0 & ETDES0_EXCESSIVE_DEFERRAL))
@@ -117,8 +114,7 @@ static int enh_desc_coe_rdes0(int ipc_err, int type, int payload_err)
 	return ret;
 }
 
-static void enh_desc_get_ext_status(struct net_device_stats *stats,
-				    struct stmmac_extra_stats *x,
+static void enh_desc_get_ext_status(struct stmmac_extra_stats *x,
 				    struct dma_extended_desc *p)
 {
 	unsigned int rdes0 = le32_to_cpu(p->basic.des0);
@@ -182,8 +178,7 @@ static void enh_desc_get_ext_status(struct net_device_stats *stats,
 	}
 }
 
-static int enh_desc_get_rx_status(struct net_device_stats *stats,
-				  struct stmmac_extra_stats *x,
+static int enh_desc_get_rx_status(struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
 	unsigned int rdes0 = le32_to_cpu(p->des0);
@@ -193,14 +188,14 @@ static int enh_desc_get_rx_status(struct net_device_stats *stats,
 		return dma_own;
 
 	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
-		stats->rx_length_errors++;
+		x->rx_length++;
 		return discard_frame;
 	}
 
 	if (unlikely(rdes0 & RDES0_ERROR_SUMMARY)) {
 		if (unlikely(rdes0 & RDES0_DESCRIPTOR_ERROR)) {
 			x->rx_desc++;
-			stats->rx_length_errors++;
+			x->rx_length++;
 		}
 		if (unlikely(rdes0 & RDES0_OVERFLOW_ERROR))
 			x->rx_gmac_overflow++;
@@ -209,7 +204,7 @@ static int enh_desc_get_rx_status(struct net_device_stats *stats,
 			pr_err("\tIPC Csum Error/Giant frame\n");
 
 		if (unlikely(rdes0 & RDES0_COLLISION))
-			stats->collisions++;
+			x->rx_collision++;
 		if (unlikely(rdes0 & RDES0_RECEIVE_WATCHDOG))
 			x->rx_watchdog++;
 
@@ -218,7 +213,6 @@ static int enh_desc_get_rx_status(struct net_device_stats *stats,
 
 		if (unlikely(rdes0 & RDES0_CRC_ERROR)) {
 			x->rx_crc_errors++;
-			stats->rx_crc_errors++;
 		}
 		ret = discard_frame;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 6ee7cf07cfd7..652af8f6e75f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -57,8 +57,7 @@ struct stmmac_desc_ops {
 	/* Last tx segment reports the transmit status */
 	int (*get_tx_ls)(struct dma_desc *p);
 	/* Return the transmit status looking at the TDES1 */
-	int (*tx_status)(struct net_device_stats *stats,
-			 struct stmmac_extra_stats *x,
+	int (*tx_status)(struct stmmac_extra_stats *x,
 			 struct dma_desc *p, void __iomem *ioaddr);
 	/* Get the buffer size from the descriptor */
 	int (*get_tx_len)(struct dma_desc *p);
@@ -67,11 +66,9 @@ struct stmmac_desc_ops {
 	/* Get the receive frame size */
 	int (*get_rx_frame_len)(struct dma_desc *p, int rx_coe_type);
 	/* Return the reception status looking at the RDES1 */
-	int (*rx_status)(struct net_device_stats *stats,
-			 struct stmmac_extra_stats *x,
+	int (*rx_status)(struct stmmac_extra_stats *x,
 			 struct dma_desc *p);
-	void (*rx_extended_status)(struct net_device_stats *stats,
-				   struct stmmac_extra_stats *x,
+	void (*rx_extended_status)(struct stmmac_extra_stats *x,
 				   struct dma_extended_desc *p);
 	/* Set tx timestamp enable bit */
 	void (*enable_tx_timestamp) (struct dma_desc *p);
@@ -191,8 +188,7 @@ struct stmmac_dma_ops {
 	void (*dma_tx_mode)(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    int mode, u32 channel, int fifosz, u8 qmode);
 	/* To track extra statistic (if supported) */
-	void (*dma_diagnostic_fr)(struct net_device_stats *stats,
-				  struct stmmac_extra_stats *x,
+	void (*dma_diagnostic_fr)(struct stmmac_extra_stats *x,
 				  void __iomem *ioaddr);
 	void (*enable_dma_transmission) (void __iomem *ioaddr);
 	void (*enable_dma_irq)(struct stmmac_priv *priv, void __iomem *ioaddr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index 350e6670a576..68a7cfcb1d8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -12,8 +12,7 @@
 #include "common.h"
 #include "descs_com.h"
 
-static int ndesc_get_tx_status(struct net_device_stats *stats,
-			       struct stmmac_extra_stats *x,
+static int ndesc_get_tx_status(struct stmmac_extra_stats *x,
 			       struct dma_desc *p, void __iomem *ioaddr)
 {
 	unsigned int tdes0 = le32_to_cpu(p->des0);
@@ -31,15 +30,12 @@ static int ndesc_get_tx_status(struct net_device_stats *stats,
 	if (unlikely(tdes0 & TDES0_ERROR_SUMMARY)) {
 		if (unlikely(tdes0 & TDES0_UNDERFLOW_ERROR)) {
 			x->tx_underflow++;
-			stats->tx_fifo_errors++;
 		}
 		if (unlikely(tdes0 & TDES0_NO_CARRIER)) {
 			x->tx_carrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely(tdes0 & TDES0_LOSS_CARRIER)) {
 			x->tx_losscarrier++;
-			stats->tx_carrier_errors++;
 		}
 		if (unlikely((tdes0 & TDES0_EXCESSIVE_DEFERRAL) ||
 			     (tdes0 & TDES0_EXCESSIVE_COLLISIONS) ||
@@ -47,7 +43,7 @@ static int ndesc_get_tx_status(struct net_device_stats *stats,
 			unsigned int collisions;
 
 			collisions = (tdes0 & TDES0_COLLISION_COUNT_MASK) >> 3;
-			stats->collisions += collisions;
+			x->tx_collision += collisions;
 		}
 		ret = tx_err;
 	}
@@ -70,8 +66,7 @@ static int ndesc_get_tx_len(struct dma_desc *p)
  * and, if required, updates the multicast statistics.
  * In case of success, it returns good_frame because the GMAC device
  * is supposed to be able to compute the csum in HW. */
-static int ndesc_get_rx_status(struct net_device_stats *stats,
-			       struct stmmac_extra_stats *x,
+static int ndesc_get_rx_status(struct stmmac_extra_stats *x,
 			       struct dma_desc *p)
 {
 	int ret = good_frame;
@@ -81,7 +76,7 @@ static int ndesc_get_rx_status(struct net_device_stats *stats,
 		return dma_own;
 
 	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
-		stats->rx_length_errors++;
+		x->rx_length++;
 		return discard_frame;
 	}
 
@@ -96,11 +91,9 @@ static int ndesc_get_rx_status(struct net_device_stats *stats,
 			x->ipc_csum_error++;
 		if (unlikely(rdes0 & RDES0_COLLISION)) {
 			x->rx_collision++;
-			stats->collisions++;
 		}
 		if (unlikely(rdes0 & RDES0_CRC_ERROR)) {
 			x->rx_crc_errors++;
-			stats->rx_crc_errors++;
 		}
 		ret = discard_frame;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 2ae73ab842d4..6a9930f24a0b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -89,14 +89,6 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 	/* Tx/Rx IRQ Events */
 	STMMAC_STAT(rx_early_irq),
 	STMMAC_STAT(threshold),
-	STMMAC_STAT(tx_pkt_n),
-	STMMAC_STAT(rx_pkt_n),
-	STMMAC_STAT(normal_irq_n),
-	STMMAC_STAT(rx_normal_irq_n),
-	STMMAC_STAT(napi_poll),
-	STMMAC_STAT(tx_normal_irq_n),
-	STMMAC_STAT(tx_clean),
-	STMMAC_STAT(tx_set_ic_bit),
 	STMMAC_STAT(irq_receive_pmt_irq_n),
 	/* MMC info */
 	STMMAC_STAT(mmc_tx_irq_n),
@@ -163,9 +155,6 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 	STMMAC_STAT(mtl_rx_fifo_ctrl_active),
 	STMMAC_STAT(mac_rx_frame_ctrl_fifo),
 	STMMAC_STAT(mac_gmii_rx_proto_engine),
-	/* TSO */
-	STMMAC_STAT(tx_tso_frames),
-	STMMAC_STAT(tx_tso_nfrags),
 	/* EST */
 	STMMAC_STAT(mtl_est_cgce),
 	STMMAC_STAT(mtl_est_hlbs),
@@ -175,6 +164,30 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 };
 #define STMMAC_STATS_LEN ARRAY_SIZE(stmmac_gstrings_stats)
 
+struct stmmac_ethtool_pcpu_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int stat_offset;
+};
+
+#define STMMAC_ETHTOOL_PCPU_STAT(m)	\
+	{ #m, offsetof(struct stmmac_pcpu_stats, m) }
+
+static const struct stmmac_ethtool_pcpu_stats stmmac_gstrings_pcpu_stats[] = {
+	/* Tx/Rx IRQ Events */
+	STMMAC_ETHTOOL_PCPU_STAT(tx_pkt_n),
+	STMMAC_ETHTOOL_PCPU_STAT(rx_pkt_n),
+	STMMAC_ETHTOOL_PCPU_STAT(normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(rx_normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(napi_poll),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_clean),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_set_ic_bit),
+	/* TSO */
+	STMMAC_ETHTOOL_PCPU_STAT(tx_tso_frames),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_tso_nfrags),
+};
+#define STMMAC_PCPU_STATS_LEN ARRAY_SIZE(stmmac_gstrings_pcpu_stats)
+
 /* HW MAC Management counters (if supported) */
 #define STMMAC_MMC_STAT(m)	\
 	{ #m, sizeof_field(struct stmmac_counters, m),	\
@@ -535,23 +548,37 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
-	int q, stat;
+	unsigned int start;
+	int q, stat, cpu;
 	char *p;
-
-	for (q = 0; q < tx_cnt; q++) {
-		p = (char *)priv + offsetof(struct stmmac_priv,
-					    xstats.txq_stats[q].tx_pkt_n);
-		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ = (*(unsigned long *)p);
-			p += sizeof(unsigned long);
+	u64 *pos;
+
+	pos = data;
+	for_each_possible_cpu(cpu) {
+		struct stmmac_pcpu_stats *stats, snapshot;
+
+		data = pos;
+		stats = per_cpu_ptr(priv->xstats.pstats, cpu);
+		do {
+			start = u64_stats_fetch_begin(&stats->syncp);
+			snapshot = *stats;
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+		for (q = 0; q < tx_cnt; q++) {
+			p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
+						    txq_stats[q].tx_pkt_n);
+			for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
+				*data++ = (*(u64 *)p);
+				p += sizeof(u64);
+			}
 		}
-	}
-	for (q = 0; q < rx_cnt; q++) {
-		p = (char *)priv + offsetof(struct stmmac_priv,
-					    xstats.rxq_stats[q].rx_pkt_n);
-		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ = (*(unsigned long *)p);
-			p += sizeof(unsigned long);
+		for (q = 0; q < rx_cnt; q++) {
+			p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
+						    rxq_stats[q].rx_pkt_n);
+			for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
+				*data++ = (*(u64 *)p);
+				p += sizeof(u64);
+			}
 		}
 	}
 }
@@ -563,7 +590,8 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	u32 rx_queues_count = priv->plat->rx_queues_to_use;
 	u32 tx_queues_count = priv->plat->tx_queues_to_use;
 	unsigned long count;
-	int i, j = 0, ret;
+	unsigned int start;
+	int i, j = 0, pos, ret, cpu;
 
 	if (priv->dma_cap.asp) {
 		for (i = 0; i < STMMAC_SAFETY_FEAT_SIZE; i++) {
@@ -574,8 +602,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	}
 
 	/* Update the DMA HW counters for dwmac10/100 */
-	ret = stmmac_dma_diagnostic_fr(priv, &dev->stats, (void *) &priv->xstats,
-			priv->ioaddr);
+	ret = stmmac_dma_diagnostic_fr(priv, &priv->xstats, priv->ioaddr);
 	if (ret) {
 		/* If supported, for new GMAC chips expose the MMC counters */
 		if (priv->dma_cap.rmon) {
@@ -606,6 +633,22 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 		data[j++] = (stmmac_gstrings_stats[i].sizeof_stat ==
 			     sizeof(u64)) ? (*(u64 *)p) : (*(u32 *)p);
 	}
+	pos = j;
+	for_each_possible_cpu(cpu) {
+		struct stmmac_pcpu_stats *stats, snapshot;
+
+		stats = per_cpu_ptr(priv->xstats.pstats, cpu);
+		j = pos;
+		do {
+			start = u64_stats_fetch_begin(&stats->syncp);
+			snapshot = *stats;
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+		for (i = 0; i < STMMAC_PCPU_STATS_LEN; i++) {
+			char *p = (char *)&snapshot + stmmac_gstrings_pcpu_stats[i].stat_offset;
+			data[j++] += *(u64 *)p;
+		}
+	}
 	stmmac_get_per_qstats(priv, &data[j]);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index eb83396d6971..ebb40a5fd54a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2425,6 +2425,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 
 static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct netdev_queue *nq = netdev_get_tx_queue(priv->dev, queue);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct xsk_buff_pool *pool = tx_q->xsk_pool;
@@ -2432,6 +2433,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	struct dma_desc *tx_desc = NULL;
 	struct xdp_desc xdp_desc;
 	bool work_done = true;
+	u32 tx_set_ic_bit = 0;
 
 	/* Avoids TX time-out as we are sharing with slow path */
 	txq_trans_cond_update(nq);
@@ -2492,7 +2494,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		if (set_ic) {
 			tx_q->tx_count_frames = 0;
 			stmmac_set_tx_ic(priv, tx_desc);
-			priv->xstats.tx_set_ic_bit++;
+			tx_set_ic_bit++;
 		}
 
 		stmmac_prepare_tx_desc(priv, tx_desc, 1, xdp_desc.len,
@@ -2504,6 +2506,9 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 		entry = tx_q->cur_tx;
 	}
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_set_ic_bit += tx_set_ic_bit;
+	u64_stats_update_end(&stats->syncp);
 
 	if (tx_desc) {
 		stmmac_flush_tx_descriptors(priv, queue);
@@ -2542,14 +2547,14 @@ static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
  */
 static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
+	u32 tx_packets = 0, tx_errors = 0;
 
 	__netif_tx_lock_bh(netdev_get_tx_queue(priv->dev, queue));
 
-	priv->xstats.tx_clean++;
-
 	tx_q->xsk_frames_done = 0;
 
 	entry = tx_q->dirty_tx;
@@ -2580,8 +2585,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		else
 			p = tx_q->dma_tx + entry;
 
-		status = stmmac_tx_status(priv, &priv->dev->stats,
-				&priv->xstats, p, priv->ioaddr);
+		status = stmmac_tx_status(priv,	&priv->xstats, p, priv->ioaddr);
 		/* Check if the descriptor is owned by the DMA */
 		if (unlikely(status & tx_dma_own))
 			break;
@@ -2597,13 +2601,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		if (likely(!(status & tx_not_ls))) {
 			/* ... verify the status error condition */
 			if (unlikely(status & tx_err)) {
-				priv->dev->stats.tx_errors++;
+				tx_errors++;
 				if (unlikely(status & tx_err_bump_tc))
 					stmmac_bump_dma_threshold(priv, queue);
 			} else {
-				priv->dev->stats.tx_packets++;
-				priv->xstats.tx_pkt_n++;
-				priv->xstats.txq_stats[queue].tx_pkt_n++;
+				tx_packets++;
 			}
 			if (skb)
 				stmmac_get_tx_hwtstamp(priv, p, skb);
@@ -2707,6 +2709,15 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 			      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 			      HRTIMER_MODE_REL);
 
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_packets += tx_packets;
+	stats->tx_pkt_n += tx_packets;
+	stats->tx_clean++;
+	stats->txq_stats[queue].tx_pkt_n += tx_packets;
+	u64_stats_update_end(&stats->syncp);
+
+	priv->xstats.tx_errors += tx_errors;
+
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
 	/* Combine decisions from TX clean and XSK TX */
@@ -2734,7 +2745,7 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 			    tx_q->dma_tx_phy, chan);
 	stmmac_start_tx_dma(priv, chan);
 
-	priv->dev->stats.tx_errors++;
+	priv->xstats.tx_errors++;
 	netif_tx_wake_queue(netdev_get_tx_queue(priv->dev, chan));
 }
 
@@ -4102,6 +4113,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	u32 queue = skb_get_queue_mapping(skb);
 	unsigned int first_entry, tx_packets;
+	struct stmmac_pcpu_stats *stats;
 	int tmp_pay_len = 0, first_tx;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
@@ -4254,7 +4266,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
-		priv->xstats.tx_set_ic_bit++;
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -4270,9 +4281,14 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	dev->stats.tx_bytes += skb->len;
-	priv->xstats.tx_tso_frames++;
-	priv->xstats.tx_tso_nfrags += nfrags;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += skb->len;
+	stats->tx_tso_frames++;
+	stats->tx_tso_nfrags += nfrags;
+	if (set_ic)
+		stats->tx_set_ic_bit++;
+	u64_stats_update_end(&stats->syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4322,7 +4338,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 dma_map_err:
 	dev_err(priv->device, "Tx dma map failed\n");
 	dev_kfree_skb(skb);
-	priv->dev->stats.tx_dropped++;
+	priv->xstats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
@@ -4344,6 +4360,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	int gso = skb_shinfo(skb)->gso_type;
 	struct dma_edesc *tbs_desc = NULL;
+	struct stmmac_pcpu_stats *stats;
 	struct dma_desc *desc, *first;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
@@ -4476,7 +4493,6 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
-		priv->xstats.tx_set_ic_bit++;
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -4503,7 +4519,12 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	dev->stats.tx_bytes += skb->len;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += skb->len;
+	if (set_ic)
+		stats->tx_set_ic_bit++;
+	u64_stats_update_end(&stats->syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4565,7 +4586,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 dma_map_err:
 	netdev_err(priv->dev, "Tx DMA map failed\n");
 	dev_kfree_skb(skb);
-	priv->dev->stats.tx_dropped++;
+	priv->xstats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
@@ -4710,6 +4731,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 				struct xdp_frame *xdpf, bool dma_map)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
@@ -4768,7 +4790,9 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	if (set_ic) {
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, tx_desc);
-		priv->xstats.tx_set_ic_bit++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_set_ic_bit++;
+		u64_stats_update_end(&stats->syncp);
 	}
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
@@ -4913,6 +4937,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 				   struct dma_desc *p, struct dma_desc *np,
 				   struct xdp_buff *xdp)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int len = xdp->data_end - xdp->data;
 	enum pkt_hash_types hash_type;
@@ -4922,7 +4947,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 
 	skb = stmmac_construct_skb_zc(ch, xdp);
 	if (!skb) {
-		priv->dev->stats.rx_dropped++;
+		priv->xstats.rx_dropped++;
 		return;
 	}
 
@@ -4941,8 +4966,10 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	skb_record_rx_queue(skb, queue);
 	napi_gro_receive(&ch->rxtx_napi, skb);
 
-	priv->dev->stats.rx_packets++;
-	priv->dev->stats.rx_bytes += len;
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_packets++;
+	stats->rx_bytes += len;
+	u64_stats_update_end(&stats->syncp);
 }
 
 static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
@@ -5015,8 +5042,10 @@ static struct stmmac_xdp_buff *xsk_buff_to_stmmac_ctx(struct xdp_buff *xdp)
 
 static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int count = 0, error = 0, len = 0;
+	u32 rx_errors = 0, rx_dropped = 0;
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int next_entry = rx_q->cur_rx;
 	unsigned int desc_size;
@@ -5077,8 +5106,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			p = rx_q->dma_rx + entry;
 
 		/* read the status of the incoming frame */
-		status = stmmac_rx_status(priv, &priv->dev->stats,
-					  &priv->xstats, p);
+		status = stmmac_rx_status(priv, &priv->xstats, p);
 		/* check if managed by the DMA otherwise go ahead */
 		if (unlikely(status & dma_own))
 			break;
@@ -5100,8 +5128,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 
 		if (priv->extend_desc)
-			stmmac_rx_extended_status(priv, &priv->dev->stats,
-						  &priv->xstats,
+			stmmac_rx_extended_status(priv, &priv->xstats,
 						  rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
 			xsk_buff_free(buf->xdp);
@@ -5109,7 +5136,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			dirty++;
 			error = 1;
 			if (!priv->hwts_rx_en)
-				priv->dev->stats.rx_errors++;
+				rx_errors++;
 		}
 
 		if (unlikely(error && (status & rx_not_ls)))
@@ -5157,7 +5184,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 		case STMMAC_XDP_CONSUMED:
 			xsk_buff_free(buf->xdp);
-			priv->dev->stats.rx_dropped++;
+			rx_dropped++;
 			break;
 		case STMMAC_XDP_TX:
 		case STMMAC_XDP_REDIRECT:
@@ -5178,8 +5205,13 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_finalize_xdp_rx(priv, xdp_status);
 
-	priv->xstats.rx_pkt_n += count;
-	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_pkt_n += count;
+	stats->rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&stats->syncp);
+
+	priv->xstats.rx_dropped += rx_dropped;
+	priv->xstats.rx_errors += rx_errors;
 
 	if (xsk_uses_need_wakeup(rx_q->xsk_pool)) {
 		if (failure || stmmac_rx_dirty(priv, queue) > 0)
@@ -5203,6 +5235,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
+	u32 rx_errors = 0, rx_dropped = 0, rx_bytes = 0, rx_packets = 0;
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int count = 0, error = 0, len = 0;
@@ -5267,8 +5301,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			p = rx_q->dma_rx + entry;
 
 		/* read the status of the incoming frame */
-		status = stmmac_rx_status(priv, &priv->dev->stats,
-				&priv->xstats, p);
+		status = stmmac_rx_status(priv, &priv->xstats, p);
 		/* check if managed by the DMA otherwise go ahead */
 		if (unlikely(status & dma_own))
 			break;
@@ -5285,14 +5318,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		prefetch(np);
 
 		if (priv->extend_desc)
-			stmmac_rx_extended_status(priv, &priv->dev->stats,
-					&priv->xstats, rx_q->dma_erx + entry);
+			stmmac_rx_extended_status(priv, &priv->xstats, rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
 			buf->page = NULL;
 			error = 1;
 			if (!priv->hwts_rx_en)
-				priv->dev->stats.rx_errors++;
+				rx_errors++;
 		}
 
 		if (unlikely(error && (status & rx_not_ls)))
@@ -5360,7 +5392,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   virt_to_head_page(ctx.xdp.data),
 							   sync_len, true);
 					buf->page = NULL;
-					priv->dev->stats.rx_dropped++;
+					rx_dropped++;
 
 					/* Clear skb as it was set as
 					 * status by XDP program.
@@ -5389,7 +5421,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
-				priv->dev->stats.rx_dropped++;
+				rx_dropped++;
 				count++;
 				goto drain_data;
 			}
@@ -5449,8 +5481,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		napi_gro_receive(&ch->rx_napi, skb);
 		skb = NULL;
 
-		priv->dev->stats.rx_packets++;
-		priv->dev->stats.rx_bytes += len;
+		rx_packets++;
+		rx_bytes += len;
 		count++;
 	}
 
@@ -5465,8 +5497,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_rx_refill(priv, queue);
 
-	priv->xstats.rx_pkt_n += count;
-	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_packets += rx_packets;
+	stats->rx_bytes += rx_bytes;
+	stats->rx_pkt_n += count;
+	stats->rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&stats->syncp);
+
+	priv->xstats.rx_dropped += rx_dropped;
+	priv->xstats.rx_errors += rx_errors;
 
 	return count;
 }
@@ -5476,10 +5515,14 @@ static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	u32 chan = ch->index;
 	int work_done;
 
-	priv->xstats.napi_poll++;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	work_done = stmmac_rx(priv, budget, chan);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -5498,10 +5541,14 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, tx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	u32 chan = ch->index;
 	int work_done;
 
-	priv->xstats.napi_poll++;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	work_done = stmmac_tx_clean(priv, budget, chan);
 	work_done = min(work_done, budget);
@@ -5522,10 +5569,14 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rxtx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
-	priv->xstats.napi_poll++;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	tx_done = stmmac_tx_clean(priv, budget, chan);
 	tx_done = min(tx_done, budget);
@@ -6784,6 +6835,46 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 	return 0;
 }
 
+static void stmmac_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	unsigned int start;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct stmmac_pcpu_stats *stats;
+		u64 rx_packets;
+		u64 rx_bytes;
+		u64 tx_packets;
+		u64 tx_bytes;
+
+		stats = per_cpu_ptr(priv->xstats.pstats, cpu);
+		do {
+			start = u64_stats_fetch_begin(&stats->syncp);
+			rx_packets = stats->rx_packets;
+			rx_bytes   = stats->rx_bytes;
+			tx_packets = stats->tx_packets;
+			tx_bytes   = stats->tx_bytes;
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes += tx_bytes;
+	}
+
+	stats->rx_dropped = priv->xstats.rx_dropped;
+	stats->rx_errors = priv->xstats.rx_errors;
+	stats->tx_dropped = priv->xstats.tx_dropped;
+	stats->tx_errors = priv->xstats.tx_errors;
+	stats->tx_carrier_errors = priv->xstats.tx_losscarrier + priv->xstats.tx_carrier;
+	stats->collisions = priv->xstats.tx_collision + priv->xstats.rx_collision;
+	stats->rx_length_errors = priv->xstats.rx_length;
+	stats->rx_crc_errors = priv->xstats.rx_crc_errors;
+	stats->rx_over_errors = priv->xstats.rx_overflow_cntr;
+	stats->rx_missed_errors = priv->xstats.rx_missed_cntr;
+}
+
 static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_open = stmmac_open,
 	.ndo_start_xmit = stmmac_xmit,
@@ -6794,6 +6885,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_set_rx_mode = stmmac_set_rx_mode,
 	.ndo_tx_timeout = stmmac_tx_timeout,
 	.ndo_eth_ioctl = stmmac_ioctl,
+	.ndo_get_stats64 = stmmac_get_stats64,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -7156,6 +7248,10 @@ int stmmac_dvr_probe(struct device *device,
 	priv->device = device;
 	priv->dev = ndev;
 
+	priv->xstats.pstats = devm_netdev_alloc_pcpu_stats(device, struct stmmac_pcpu_stats);
+	if (!priv->xstats.pstats)
+		return -ENOMEM;
+
 	stmmac_set_ethtool_ops(ndev);
 	priv->pause = pause;
 	priv->plat = plat_dat;
-- 
2.40.1


