Return-Path: <netdev+bounces-10788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE0C7304EF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFBCF1C20D84
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6533611C98;
	Wed, 14 Jun 2023 16:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17D125DF;
	Wed, 14 Jun 2023 16:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE1C433CA;
	Wed, 14 Jun 2023 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686760222;
	bh=d8c+VFz/SkIzgvGXsjoVciNAQgD1uJNiNstNKgT5cMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1vC2ZFfA4ie3Q2PrgGGQfl45KXgto54o+hFJiNKM4X/H6fbXF2HX7re6NZpXff/5
	 gTi/a0YnKLxMVlgeZo3MgutaQJWncBRXRDKW+ksB2zWc1OOGjQmAN9WBvIdbzrfzLv
	 X9mqzWEiRATfzQ0UXPpELrh1va8tJ4zX7/X86IwEHXOkzh31JzI+wZCjr2056NUp/o
	 PUvVOI3m0uYrTsVBk2f1nF4ti8ZZ6ug9V206buFCi6ezosxNdUOJJkSwtFFmQ3BIB7
	 aVfTxosKI0gTauYLJQxg60YxmchWHCz2O/mEgdQSwEjF2myKgq/ymU/LjIzI5kpCR7
	 /sRiEezRMe0EA==
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
	linux-sunxi@lists.linux.dev
Subject: [PATCH 3/3] net: stmmac: use pcpu statistics where necessary
Date: Thu, 15 Jun 2023 00:18:47 +0800
Message-Id: <20230614161847.4071-4-jszhang@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614161847.4071-1-jszhang@kernel.org>
References: <20230614161847.4071-1-jszhang@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If HW supports multiqueues, there are frequent cacheline ping pongs
on some driver statistic vars, for example, normal_irq_n, tx_pkt_n
and so on. What's more, frequent cacheline ping pongs on normal_irq_n
happens in ISR, this make the situation worse.

Use pcpu statistics where necessary to remove cacheline ping pongs
as much as possible to make multiqueue operations faster. Those stats
vars which are not frequently updated are kept as is.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  45 ++---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   9 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  19 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  11 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  11 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  87 +++++----
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 166 ++++++++++--------
 7 files changed, 193 insertions(+), 155 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 1cb8be45330d..ec212528b9df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -59,20 +59,42 @@
 /* #define FRAME_FILTER_DEBUG */
 
 struct stmmac_txq_stats {
-	struct u64_stats_sync syncp;
 	u64 tx_pkt_n;
 	u64 tx_normal_irq_n;
 };
 
 struct stmmac_rxq_stats {
+	u64 rx_pkt_n;
+	u64 rx_normal_irq_n;
+};
+
+struct stmmac_pcpu_stats {
 	struct u64_stats_sync syncp;
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
 	u64 rx_pkt_n;
+	u64 normal_irq_n;
 	u64 rx_normal_irq_n;
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
-	struct u64_stats_sync syncp ____cacheline_aligned;
+	struct stmmac_pcpu_stats __percpu *pstats;
 	/* Transmit errors */
 	unsigned long tx_underflow;
 	unsigned long tx_carrier;
@@ -117,14 +139,6 @@ struct stmmac_extra_stats {
 	/* Tx/Rx IRQ Events */
 	unsigned long rx_early_irq;
 	unsigned long threshold;
-	u64 tx_pkt_n;
-	u64 rx_pkt_n;
-	u64 normal_irq_n;
-	u64 rx_normal_irq_n;
-	u64 napi_poll;
-	u64 tx_normal_irq_n;
-	u64 tx_clean;
-	u64 tx_set_ic_bit;
 	unsigned long irq_receive_pmt_irq_n;
 	/* MMC info */
 	unsigned long mmc_tx_irq_n;
@@ -194,23 +208,12 @@ struct stmmac_extra_stats {
 	unsigned long mtl_rx_fifo_ctrl_active;
 	unsigned long mac_rx_frame_ctrl_fifo;
 	unsigned long mac_gmii_rx_proto_engine;
-	/* TSO */
-	u64 tx_tso_frames;
-	u64 tx_tso_nfrags;
 	/* EST */
 	unsigned long mtl_est_cgce;
 	unsigned long mtl_est_hlbs;
 	unsigned long mtl_est_hlbf;
 	unsigned long mtl_est_btre;
 	unsigned long mtl_est_btrlm;
-	/* per queue statistics */
-	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
-	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
-	/* device stats */
-	u64 rx_packets;
-	u64 rx_bytes;
-	u64 tx_packets;
-	u64 tx_bytes;
 	unsigned long rx_dropped;
 	unsigned long rx_errors;
 	unsigned long tx_dropped;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 1571ca0c6616..c0a689529883 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -440,6 +440,7 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 				     struct stmmac_extra_stats *x, u32 chan,
 				     u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	u32 v;
 	int ret = 0;
 
@@ -450,17 +451,17 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 	else if (dir == DMA_DIR_TX)
 		v &= EMAC_INT_MSK_TX;
 
-	u64_stats_update_begin(&priv->xstats.syncp);
+	u64_stats_update_begin(&stats->syncp);
 	if (v & EMAC_TX_INT) {
 		ret |= handle_tx;
-		x->tx_normal_irq_n++;
+		stats->tx_normal_irq_n++;
 	}
 
 	if (v & EMAC_RX_INT) {
 		ret |= handle_rx;
-		x->rx_normal_irq_n++;
+		stats->rx_normal_irq_n++;
 	}
-	u64_stats_update_end(&priv->xstats.syncp);
+	u64_stats_update_end(&stats->syncp);
 
 	if (v & EMAC_TX_DMA_STOP_INT)
 		x->tx_process_stopped_irq++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index eda4859fa468..bd5fecb101af 100644
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
@@ -198,27 +199,23 @@ int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 		}
 	}
 	/* TX/RX NORMAL interrupts */
-	u64_stats_update_begin(&priv->xstats.syncp);
+	u64_stats_update_begin(&stats->syncp);
 	if (likely(intr_status & DMA_CHAN_STATUS_NIS))
-		x->normal_irq_n++;
+		stats->normal_irq_n++;
 	if (likely(intr_status & DMA_CHAN_STATUS_RI))
-		x->rx_normal_irq_n++;
+		stats->rx_normal_irq_n++;
 	if (likely(intr_status & DMA_CHAN_STATUS_TI))
-		x->tx_normal_irq_n++;
-	u64_stats_update_end(&priv->xstats.syncp);
+		stats->tx_normal_irq_n++;
 
 	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
-		u64_stats_update_begin(&priv->xstats.rxq_stats[chan].syncp);
-		x->rxq_stats[chan].rx_normal_irq_n++;
-		u64_stats_update_end(&priv->xstats.rxq_stats[chan].syncp);
+		stats->rxq_stats[chan].rx_normal_irq_n++;
 		ret |= handle_rx;
 	}
 	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
-		u64_stats_update_begin(&priv->xstats.txq_stats[chan].syncp);
-		x->txq_stats[chan].tx_normal_irq_n++;
-		u64_stats_update_end(&priv->xstats.txq_stats[chan].syncp);
+		stats->txq_stats[chan].tx_normal_irq_n++;
 		ret |= handle_tx;
 	}
+	u64_stats_update_end(&stats->syncp);
 
 	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
 		ret |= handle_tx;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 4cef67571d5a..bb938b334313 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -162,6 +162,7 @@ static void show_rx_process_state(unsigned int status)
 int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	int ret = 0;
 	/* read the status register (CSR5) */
 	u32 intr_status = readl(ioaddr + DMA_STATUS);
@@ -209,21 +210,21 @@ int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 	}
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & DMA_STATUS_NIS)) {
-		u64_stats_update_begin(&priv->xstats.syncp);
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
-		u64_stats_update_end(&priv->xstats.syncp);
+		u64_stats_update_end(&stats->syncp);
 		if (unlikely(intr_status & DMA_STATUS_ERI))
 			x->rx_early_irq++;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 5997aa0c9b55..052852aeb12d 100644
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
@@ -364,18 +365,18 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & XGMAC_NIS)) {
-		u64_stats_update_begin(&priv->xstats.syncp);
-		x->normal_irq_n++;
+		u64_stats_update_begin(&stats->syncp);
+		stats->normal_irq_n++;
 
 		if (likely(intr_status & XGMAC_RI)) {
-			x->rx_normal_irq_n++;
+			stats->rx_normal_irq_n++;
 			ret |= handle_rx;
 		}
 		if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
-			x->tx_normal_irq_n++;
+			stats->tx_normal_irq_n++;
 			ret |= handle_tx;
 		}
-		u64_stats_update_end(&priv->xstats.syncp);
+		u64_stats_update_end(&stats->syncp);
 	}
 
 	/* Clear interrupts */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index f9cca2562d60..2f56d0ab3d27 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -164,21 +164,29 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 };
 #define STMMAC_STATS_LEN ARRAY_SIZE(stmmac_gstrings_stats)
 
-static const struct stmmac_stats stmmac_gstrings_stats64[] = {
+struct stmmac_ethtool_pcpu_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int stat_offset;
+};
+
+#define STMMAC_ETHTOOL_PCPU_STAT(m)	\
+	{ #m, offsetof(struct stmmac_pcpu_stats, m) }
+
+static const struct stmmac_ethtool_pcpu_stats stmmac_gstrings_pcpu_stats[] = {
 	/* Tx/Rx IRQ Events */
-	STMMAC_STAT(tx_pkt_n),
-	STMMAC_STAT(rx_pkt_n),
-	STMMAC_STAT(normal_irq_n),
-	STMMAC_STAT(rx_normal_irq_n),
-	STMMAC_STAT(napi_poll),
-	STMMAC_STAT(tx_normal_irq_n),
-	STMMAC_STAT(tx_clean),
-	STMMAC_STAT(tx_set_ic_bit),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_pkt_n),
+	STMMAC_ETHTOOL_PCPU_STAT(rx_pkt_n),
+	STMMAC_ETHTOOL_PCPU_STAT(normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(rx_normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(napi_poll),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_normal_irq_n),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_clean),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_set_ic_bit),
 	/* TSO */
-	STMMAC_STAT(tx_tso_frames),
-	STMMAC_STAT(tx_tso_nfrags),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_tso_frames),
+	STMMAC_ETHTOOL_PCPU_STAT(tx_tso_nfrags),
 };
-#define STMMAC_STATS64_LEN ARRAY_SIZE(stmmac_gstrings_stats64)
+#define STMMAC_PCPU_STATS_LEN ARRAY_SIZE(stmmac_gstrings_pcpu_stats)
 
 /* HW MAC Management counters (if supported) */
 #define STMMAC_MMC_STAT(m)	\
@@ -541,30 +549,36 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	unsigned int start;
-	int q, stat;
+	int q, stat, cpu;
 	char *p;
+	u64 *pos;
 
-	for (q = 0; q < tx_cnt; q++) {
+	pos = data;
+	for_each_possible_cpu(cpu) {
+		struct stmmac_pcpu_stats *stats, snapshot;
+
+		data = pos;
+		stats = per_cpu_ptr(priv->xstats.pstats, cpu);
 		do {
-			start = u64_stats_fetch_begin(&priv->xstats.txq_stats[q].syncp);
-			p = (char *)priv + offsetof(struct stmmac_priv,
-						    xstats.txq_stats[q].tx_pkt_n);
+			snapshot = *stats;
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+		for (q = 0; q < tx_cnt; q++) {
+			p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
+						    txq_stats[q].tx_pkt_n);
 			for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
 				*data++ = (*(u64 *)p);
 				p += sizeof(u64);
 			}
-		} while (u64_stats_fetch_retry(&priv->xstats.txq_stats[q].syncp, start));
-	}
-	for (q = 0; q < rx_cnt; q++) {
-		do {
-			start = u64_stats_fetch_begin(&priv->xstats.rxq_stats[q].syncp);
-			p = (char *)priv + offsetof(struct stmmac_priv,
-						    xstats.rxq_stats[q].rx_pkt_n);
+		}
+		for (q = 0; q < rx_cnt; q++) {
+			p = (char *)&snapshot + offsetof(struct stmmac_pcpu_stats,
+						    rxq_stats[q].rx_pkt_n);
 			for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
 				*data++ = (*(u64 *)p);
 				p += sizeof(u64);
 			}
-		} while (u64_stats_fetch_retry(&priv->xstats.rxq_stats[q].syncp, start));
+		}
 	}
 }
 
@@ -576,7 +590,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	u32 tx_queues_count = priv->plat->tx_queues_to_use;
 	unsigned long count;
 	unsigned int start;
-	int i, j = 0, ret;
+	int i, j = 0, pos, ret, cpu;
 
 	if (priv->dma_cap.asp) {
 		for (i = 0; i < STMMAC_SAFETY_FEAT_SIZE; i++) {
@@ -618,13 +632,22 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 		data[j++] = (stmmac_gstrings_stats[i].sizeof_stat ==
 			     sizeof(u64)) ? (*(u64 *)p) : (*(u32 *)p);
 	}
-	do {
-		start = u64_stats_fetch_begin(&priv->xstats.syncp);
-		for (i = 0; i < STMMAC_STATS64_LEN; i++) {
-			char *p = (char *)priv + stmmac_gstrings_stats64[i].stat_offset;
-			data[j++] = *(u64 *)p;
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
 		}
-	} while (u64_stats_fetch_retry(&priv->xstats.syncp, start));
+	}
 	stmmac_get_per_qstats(priv, &data[j]);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 69cb2835fa82..4056ea859963 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2422,6 +2422,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 
 static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct netdev_queue *nq = netdev_get_tx_queue(priv->dev, queue);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct xsk_buff_pool *pool = tx_q->xsk_pool;
@@ -2502,9 +2503,9 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 		entry = tx_q->cur_tx;
 	}
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.tx_set_ic_bit += tx_set_ic_bit;
-	u64_stats_update_end(&priv->xstats.syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_set_ic_bit += tx_set_ic_bit;
+	u64_stats_update_end(&stats->syncp);
 
 	if (tx_desc) {
 		stmmac_flush_tx_descriptors(priv, queue);
@@ -2543,6 +2544,7 @@ static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
  */
 static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
@@ -2704,15 +2706,12 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 			      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 			      HRTIMER_MODE_REL);
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.tx_packets += tx_packets;
-	priv->xstats.tx_pkt_n += tx_packets;
-	priv->xstats.tx_clean++;
-	u64_stats_update_end(&priv->xstats.syncp);
-
-	u64_stats_update_begin(&priv->xstats.txq_stats[queue].syncp);
-	priv->xstats.txq_stats[queue].tx_pkt_n += tx_packets;
-	u64_stats_update_end(&priv->xstats.txq_stats[queue].syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_packets += tx_packets;
+	stats->tx_pkt_n += tx_packets;
+	stats->tx_clean++;
+	stats->txq_stats[queue].tx_pkt_n += tx_packets;
+	u64_stats_update_end(&stats->syncp);
 
 	priv->xstats.tx_errors += tx_errors;
 
@@ -4108,6 +4107,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	u32 queue = skb_get_queue_mapping(skb);
 	unsigned int first_entry, tx_packets;
+	struct stmmac_pcpu_stats *stats;
 	int tmp_pay_len = 0, first_tx;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
@@ -4275,13 +4275,14 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.tx_bytes += skb->len;
-	priv->xstats.tx_tso_frames++;
-	priv->xstats.tx_tso_nfrags += nfrags;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += skb->len;
+	stats->tx_tso_frames++;
+	stats->tx_tso_nfrags += nfrags;
 	if (set_ic)
-		priv->xstats.tx_set_ic_bit++;
-	u64_stats_update_end(&priv->xstats.syncp);
+		stats->tx_set_ic_bit++;
+	u64_stats_update_end(&stats->syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4353,6 +4354,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	int gso = skb_shinfo(skb)->gso_type;
 	struct dma_edesc *tbs_desc = NULL;
+	struct stmmac_pcpu_stats *stats;
 	struct dma_desc *desc, *first;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
@@ -4511,11 +4513,12 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.tx_bytes += skb->len;
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += skb->len;
 	if (set_ic)
-		priv->xstats.tx_set_ic_bit++;
-	u64_stats_update_end(&priv->xstats.syncp);
+		stats->tx_set_ic_bit++;
+	u64_stats_update_end(&stats->syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4722,6 +4725,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 				struct xdp_frame *xdpf, bool dma_map)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
@@ -4780,9 +4784,9 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	if (set_ic) {
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, tx_desc);
-		u64_stats_update_begin(&priv->xstats.syncp);
-		priv->xstats.tx_set_ic_bit++;
-		u64_stats_update_end(&priv->xstats.syncp);
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_set_ic_bit++;
+		u64_stats_update_end(&stats->syncp);
 	}
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
@@ -4927,6 +4931,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 				   struct dma_desc *p, struct dma_desc *np,
 				   struct xdp_buff *xdp)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int len = xdp->data_end - xdp->data;
 	enum pkt_hash_types hash_type;
@@ -4955,10 +4960,10 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	skb_record_rx_queue(skb, queue);
 	napi_gro_receive(&ch->rxtx_napi, skb);
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.rx_packets++;
-	priv->xstats.rx_bytes += len;
-	u64_stats_update_end(&priv->xstats.syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_packets++;
+	stats->rx_bytes += len;
+	u64_stats_update_end(&stats->syncp);
 }
 
 static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
@@ -5031,6 +5036,7 @@ static struct stmmac_xdp_buff *xsk_buff_to_stmmac_ctx(struct xdp_buff *xdp)
 
 static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int count = 0, error = 0, len = 0;
 	u32 rx_errors = 0, rx_dropped = 0;
@@ -5193,13 +5199,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_finalize_xdp_rx(priv, xdp_status);
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.rx_pkt_n += count;
-	u64_stats_update_end(&priv->xstats.syncp);
-
-	u64_stats_update_begin(&priv->xstats.rxq_stats[queue].syncp);
-	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
-	u64_stats_update_end(&priv->xstats.rxq_stats[queue].syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_pkt_n += count;
+	stats->rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&stats->syncp);
 
 	priv->xstats.rx_dropped += rx_dropped;
 	priv->xstats.rx_errors += rx_errors;
@@ -5226,6 +5229,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
+	struct stmmac_pcpu_stats *stats = this_cpu_ptr(priv->xstats.pstats);
 	u32 rx_errors = 0, rx_dropped = 0, rx_bytes = 0, rx_packets = 0;
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
@@ -5487,15 +5491,12 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_rx_refill(priv, queue);
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.rx_packets += rx_packets;
-	priv->xstats.rx_bytes += rx_bytes;
-	priv->xstats.rx_pkt_n += count;
-	u64_stats_update_end(&priv->xstats.syncp);
-
-	u64_stats_update_begin(&priv->xstats.rxq_stats[queue].syncp);
-	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
-	u64_stats_update_end(&priv->xstats.rxq_stats[queue].syncp);
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_packets += rx_packets;
+	stats->rx_bytes += rx_bytes;
+	stats->rx_pkt_n += count;
+	stats->rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&stats->syncp);
 
 	priv->xstats.rx_dropped += rx_dropped;
 	priv->xstats.rx_errors += rx_errors;
@@ -5508,12 +5509,14 @@ static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	u32 chan = ch->index;
 	int work_done;
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.napi_poll++;
-	u64_stats_update_end(&priv->xstats.syncp);
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	work_done = stmmac_rx(priv, budget, chan);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -5532,12 +5535,14 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, tx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	u32 chan = ch->index;
 	int work_done;
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.napi_poll++;
-	u64_stats_update_end(&priv->xstats.syncp);
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	work_done = stmmac_tx_clean(priv, budget, chan);
 	work_done = min(work_done, budget);
@@ -5558,12 +5563,14 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	struct stmmac_channel *ch =
 		container_of(napi, struct stmmac_channel, rxtx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_pcpu_stats *stats;
 	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
-	u64_stats_update_begin(&priv->xstats.syncp);
-	priv->xstats.napi_poll++;
-	u64_stats_update_end(&priv->xstats.syncp);
+	stats = this_cpu_ptr(priv->xstats.pstats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->napi_poll++;
+	u64_stats_update_end(&stats->syncp);
 
 	tx_done = stmmac_tx_clean(priv, budget, chan);
 	tx_done = min(tx_done, budget);
@@ -6823,23 +6830,30 @@ static void stmmac_get_stats64(struct net_device *dev, struct rtnl_link_stats64
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	unsigned int start;
-	u64 rx_packets;
-	u64 rx_bytes;
-	u64 tx_packets;
-	u64 tx_bytes;
-
-	do {
-		start = u64_stats_fetch_begin(&priv->xstats.syncp);
-		rx_packets = priv->xstats.rx_packets;
-		rx_bytes   = priv->xstats.rx_bytes;
-		tx_packets = priv->xstats.tx_packets;
-		tx_bytes   = priv->xstats.tx_bytes;
-	} while (u64_stats_fetch_retry(&priv->xstats.syncp, start));
-
-	stats->rx_packets = rx_packets;
-	stats->rx_bytes = rx_bytes;
-	stats->tx_packets = tx_packets;
-	stats->tx_bytes = tx_bytes;
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
 	stats->rx_dropped = priv->xstats.rx_dropped;
 	stats->rx_errors = priv->xstats.rx_errors;
 	stats->tx_dropped = priv->xstats.tx_dropped;
@@ -7225,6 +7239,10 @@ int stmmac_dvr_probe(struct device *device,
 	priv->device = device;
 	priv->dev = ndev;
 
+	priv->xstats.pstats = devm_netdev_alloc_pcpu_stats(device, struct stmmac_pcpu_stats);
+	if (!priv->xstas.pstats)
+		return -ENOMEM;
+
 	stmmac_set_ethtool_ops(ndev);
 	priv->pause = pause;
 	priv->plat = plat_dat;
@@ -7383,12 +7401,6 @@ int stmmac_dvr_probe(struct device *device,
 
 	priv->xstats.threshold = tc;
 
-	u64_stats_init(&priv->xstats.syncp);
-	for (i = 0; i < priv->plat->rx_queues_to_use; i++)
-		u64_stats_init(&priv->xstats.rxq_stats[i].syncp);
-	for (i = 0; i < priv->plat->tx_queues_to_use; i++)
-		u64_stats_init(&priv->xstats.txq_stats[i].syncp);
-
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
 	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
-- 
2.40.1


