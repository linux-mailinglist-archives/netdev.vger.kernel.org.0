Return-Path: <netdev+bounces-10787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1EB7304ED
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9AD228124A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C13411C80;
	Wed, 14 Jun 2023 16:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC4F156CE;
	Wed, 14 Jun 2023 16:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E1DC433C0;
	Wed, 14 Jun 2023 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686760218;
	bh=38J+Lpe9beQ4yjmYo+d4WXoCGVHbzmLcJi7Bg/fXw0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObBOctGmKybhNkPc0leOFPBpDYA1Y7Ggl1Xl0RsCPDbftsFdUli1s1bLucO4RyV/u
	 z2jJg8HBu9FpuuYUu6Ac6PC9vQPQPdcgKrSKA+5aqkZVLFgfr9cjE75r5i4qctfzZu
	 KBwWzC60zD8FQtJcb10nZiq+2Wftk4VMtZgn/PQvAyBSdQWNQjJ8j3StY6OkA5QavD
	 C3ORY6Mdvrv21yggGYEzfG4IHlfXvBvAJsbNMAfMI4RHEvPDIVjzEgvIys7Tq8zePp
	 6xQIjUNP6etu8s8kE1CxMSBcx3WGVsSbw//J10tlQx1UVGt0A59/WKSF/3ppKSIY2U
	 JLZROH6DhndjQ==
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
Subject: [PATCH 2/3] net: stmmac: fix overflow of some network statistics
Date: Thu, 15 Jun 2023 00:18:46 +0800
Message-Id: <20230614161847.4071-3-jszhang@kernel.org>
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

Currently, network statistics in stmmac_extra_stats, stmmac_rxq_stats
and stmmac_txq_stats are 32 bit variables on 32 bit platforms. This
can cause some stats to overflow after several minutes of
high traffic, for example rx_pkt_n, tx_pkt_n and so on.

To fix this issue, we convert those statistics to 64 bit, implement
ndo_get_stats64 and update ethtool accordingly. Some statistics which
are not possible to overflow are still kept as is.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  43 +++--
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  12 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |   7 +-
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  14 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   3 +
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   6 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   2 +
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  20 +--
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  12 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  15 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  69 +++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 152 ++++++++++++++----
 13 files changed, 236 insertions(+), 132 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 4ad692c4116c..1cb8be45330d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -59,19 +59,22 @@
 /* #define FRAME_FILTER_DEBUG */
 
 struct stmmac_txq_stats {
-	unsigned long tx_pkt_n;
-	unsigned long tx_normal_irq_n;
+	struct u64_stats_sync syncp;
+	u64 tx_pkt_n;
+	u64 tx_normal_irq_n;
 };
 
 struct stmmac_rxq_stats {
-	unsigned long rx_pkt_n;
-	unsigned long rx_normal_irq_n;
+	struct u64_stats_sync syncp;
+	u64 rx_pkt_n;
+	u64 rx_normal_irq_n;
 };
 
 /* Extra statistic and debug information exposed by ethtool */
 struct stmmac_extra_stats {
+	struct u64_stats_sync syncp ____cacheline_aligned;
 	/* Transmit errors */
-	unsigned long tx_underflow ____cacheline_aligned;
+	unsigned long tx_underflow;
 	unsigned long tx_carrier;
 	unsigned long tx_losscarrier;
 	unsigned long vlan_tag;
@@ -81,6 +84,7 @@ struct stmmac_extra_stats {
 	unsigned long tx_frame_flushed;
 	unsigned long tx_payload_error;
 	unsigned long tx_ip_header_error;
+	unsigned long tx_collision;
 	/* Receive errors */
 	unsigned long rx_desc;
 	unsigned long sa_filter_fail;
@@ -113,14 +117,14 @@ struct stmmac_extra_stats {
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
+	u64 tx_pkt_n;
+	u64 rx_pkt_n;
+	u64 normal_irq_n;
+	u64 rx_normal_irq_n;
+	u64 napi_poll;
+	u64 tx_normal_irq_n;
+	u64 tx_clean;
+	u64 tx_set_ic_bit;
 	unsigned long irq_receive_pmt_irq_n;
 	/* MMC info */
 	unsigned long mmc_tx_irq_n;
@@ -191,8 +195,8 @@ struct stmmac_extra_stats {
 	unsigned long mac_rx_frame_ctrl_fifo;
 	unsigned long mac_gmii_rx_proto_engine;
 	/* TSO */
-	unsigned long tx_tso_frames;
-	unsigned long tx_tso_nfrags;
+	u64 tx_tso_frames;
+	u64 tx_tso_nfrags;
 	/* EST */
 	unsigned long mtl_est_cgce;
 	unsigned long mtl_est_hlbs;
@@ -202,6 +206,15 @@ struct stmmac_extra_stats {
 	/* per queue statistics */
 	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
 	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
+	/* device stats */
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 tx_packets;
+	u64 tx_bytes;
+	unsigned long rx_dropped;
+	unsigned long rx_errors;
+	unsigned long tx_dropped;
+	unsigned long tx_errors;
 };
 
 /* Safety Feature statistics exposed by ethtool */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index c2c592ba0eb8..1571ca0c6616 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -450,11 +450,18 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
 	else if (dir == DMA_DIR_TX)
 		v &= EMAC_INT_MSK_TX;
 
+	u64_stats_update_begin(&priv->xstats.syncp);
 	if (v & EMAC_TX_INT) {
 		ret |= handle_tx;
 		x->tx_normal_irq_n++;
 	}
 
+	if (v & EMAC_RX_INT) {
+		ret |= handle_rx;
+		x->rx_normal_irq_n++;
+	}
+	u64_stats_update_end(&priv->xstats.syncp);
+
 	if (v & EMAC_TX_DMA_STOP_INT)
 		x->tx_process_stopped_irq++;
 
@@ -472,11 +479,6 @@ static int sun8i_dwmac_dma_interrupt(struct stmmac_priv *priv,
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
index df41eac54058..eda4859fa468 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -198,18 +198,28 @@ int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 		}
 	}
 	/* TX/RX NORMAL interrupts */
+	u64_stats_update_begin(&priv->xstats.syncp);
 	if (likely(intr_status & DMA_CHAN_STATUS_NIS))
 		x->normal_irq_n++;
-	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
+	if (likely(intr_status & DMA_CHAN_STATUS_RI))
 		x->rx_normal_irq_n++;
+	if (likely(intr_status & DMA_CHAN_STATUS_TI))
+		x->tx_normal_irq_n++;
+	u64_stats_update_end(&priv->xstats.syncp);
+
+	if (likely(intr_status & DMA_CHAN_STATUS_RI)) {
+		u64_stats_update_begin(&priv->xstats.rxq_stats[chan].syncp);
 		x->rxq_stats[chan].rx_normal_irq_n++;
+		u64_stats_update_end(&priv->xstats.rxq_stats[chan].syncp);
 		ret |= handle_rx;
 	}
 	if (likely(intr_status & DMA_CHAN_STATUS_TI)) {
-		x->tx_normal_irq_n++;
+		u64_stats_update_begin(&priv->xstats.txq_stats[chan].syncp);
 		x->txq_stats[chan].tx_normal_irq_n++;
+		u64_stats_update_end(&priv->xstats.txq_stats[chan].syncp);
 		ret |= handle_tx;
 	}
+
 	if (unlikely(intr_status & DMA_CHAN_STATUS_TBU))
 		ret |= handle_tx;
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 0b6f999a8305..4cef67571d5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -10,6 +10,7 @@
 #include <linux/iopoll.h>
 #include "common.h"
 #include "dwmac_dma.h"
+#include "stmmac.h"
 
 #define GMAC_HI_REG_AE		0x80000000
 
@@ -208,6 +209,7 @@ int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 	}
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & DMA_STATUS_NIS)) {
+		u64_stats_update_begin(&priv->xstats.syncp);
 		x->normal_irq_n++;
 		if (likely(intr_status & DMA_STATUS_RI)) {
 			u32 value = readl(ioaddr + DMA_INTR_ENA);
@@ -221,6 +223,7 @@ int dwmac_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			x->tx_normal_irq_n++;
 			ret |= handle_tx;
 		}
+		u64_stats_update_end(&priv->xstats.syncp);
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
index dfd53264e036..5997aa0c9b55 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -364,6 +364,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 
 	/* TX/RX NORMAL interrupts */
 	if (likely(intr_status & XGMAC_NIS)) {
+		u64_stats_update_begin(&priv->xstats.syncp);
 		x->normal_irq_n++;
 
 		if (likely(intr_status & XGMAC_RI)) {
@@ -374,6 +375,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 			x->tx_normal_irq_n++;
 			ret |= handle_tx;
 		}
+		u64_stats_update_end(&priv->xstats.syncp);
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
index 2ae73ab842d4..f9cca2562d60 100644
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
@@ -175,6 +164,22 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 };
 #define STMMAC_STATS_LEN ARRAY_SIZE(stmmac_gstrings_stats)
 
+static const struct stmmac_stats stmmac_gstrings_stats64[] = {
+	/* Tx/Rx IRQ Events */
+	STMMAC_STAT(tx_pkt_n),
+	STMMAC_STAT(rx_pkt_n),
+	STMMAC_STAT(normal_irq_n),
+	STMMAC_STAT(rx_normal_irq_n),
+	STMMAC_STAT(napi_poll),
+	STMMAC_STAT(tx_normal_irq_n),
+	STMMAC_STAT(tx_clean),
+	STMMAC_STAT(tx_set_ic_bit),
+	/* TSO */
+	STMMAC_STAT(tx_tso_frames),
+	STMMAC_STAT(tx_tso_nfrags),
+};
+#define STMMAC_STATS64_LEN ARRAY_SIZE(stmmac_gstrings_stats64)
+
 /* HW MAC Management counters (if supported) */
 #define STMMAC_MMC_STAT(m)	\
 	{ #m, sizeof_field(struct stmmac_counters, m),	\
@@ -535,24 +540,31 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	unsigned int start;
 	int q, stat;
 	char *p;
 
 	for (q = 0; q < tx_cnt; q++) {
-		p = (char *)priv + offsetof(struct stmmac_priv,
-					    xstats.txq_stats[q].tx_pkt_n);
-		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ = (*(unsigned long *)p);
-			p += sizeof(unsigned long);
-		}
+		do {
+			start = u64_stats_fetch_begin(&priv->xstats.txq_stats[q].syncp);
+			p = (char *)priv + offsetof(struct stmmac_priv,
+						    xstats.txq_stats[q].tx_pkt_n);
+			for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
+				*data++ = (*(u64 *)p);
+				p += sizeof(u64);
+			}
+		} while (u64_stats_fetch_retry(&priv->xstats.txq_stats[q].syncp, start));
 	}
 	for (q = 0; q < rx_cnt; q++) {
-		p = (char *)priv + offsetof(struct stmmac_priv,
-					    xstats.rxq_stats[q].rx_pkt_n);
-		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ = (*(unsigned long *)p);
-			p += sizeof(unsigned long);
-		}
+		do {
+			start = u64_stats_fetch_begin(&priv->xstats.rxq_stats[q].syncp);
+			p = (char *)priv + offsetof(struct stmmac_priv,
+						    xstats.rxq_stats[q].rx_pkt_n);
+			for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
+				*data++ = (*(u64 *)p);
+				p += sizeof(u64);
+			}
+		} while (u64_stats_fetch_retry(&priv->xstats.rxq_stats[q].syncp, start));
 	}
 }
 
@@ -563,6 +575,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	u32 rx_queues_count = priv->plat->rx_queues_to_use;
 	u32 tx_queues_count = priv->plat->tx_queues_to_use;
 	unsigned long count;
+	unsigned int start;
 	int i, j = 0, ret;
 
 	if (priv->dma_cap.asp) {
@@ -574,8 +587,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	}
 
 	/* Update the DMA HW counters for dwmac10/100 */
-	ret = stmmac_dma_diagnostic_fr(priv, &dev->stats, (void *) &priv->xstats,
-			priv->ioaddr);
+	ret = stmmac_dma_diagnostic_fr(priv, &priv->xstats, priv->ioaddr);
 	if (ret) {
 		/* If supported, for new GMAC chips expose the MMC counters */
 		if (priv->dma_cap.rmon) {
@@ -606,6 +618,13 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 		data[j++] = (stmmac_gstrings_stats[i].sizeof_stat ==
 			     sizeof(u64)) ? (*(u64 *)p) : (*(u32 *)p);
 	}
+	do {
+		start = u64_stats_fetch_begin(&priv->xstats.syncp);
+		for (i = 0; i < STMMAC_STATS64_LEN; i++) {
+			char *p = (char *)priv + stmmac_gstrings_stats64[i].stat_offset;
+			data[j++] = *(u64 *)p;
+		}
+	} while (u64_stats_fetch_retry(&priv->xstats.syncp, start));
 	stmmac_get_per_qstats(priv, &data[j]);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 951e037d0a80..69cb2835fa82 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2429,6 +2429,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	struct dma_desc *tx_desc = NULL;
 	struct xdp_desc xdp_desc;
 	bool work_done = true;
+	u32 tx_set_ic_bit = 0;
 
 	/* Avoids TX time-out as we are sharing with slow path */
 	txq_trans_cond_update(nq);
@@ -2489,7 +2490,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		if (set_ic) {
 			tx_q->tx_count_frames = 0;
 			stmmac_set_tx_ic(priv, tx_desc);
-			priv->xstats.tx_set_ic_bit++;
+			tx_set_ic_bit++;
 		}
 
 		stmmac_prepare_tx_desc(priv, tx_desc, 1, xdp_desc.len,
@@ -2501,6 +2502,9 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 		entry = tx_q->cur_tx;
 	}
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.tx_set_ic_bit += tx_set_ic_bit;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	if (tx_desc) {
 		stmmac_flush_tx_descriptors(priv, queue);
@@ -2542,11 +2546,10 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
+	u32 tx_packets = 0, tx_errors = 0;
 
 	__netif_tx_lock_bh(netdev_get_tx_queue(priv->dev, queue));
 
-	priv->xstats.tx_clean++;
-
 	tx_q->xsk_frames_done = 0;
 
 	entry = tx_q->dirty_tx;
@@ -2577,8 +2580,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		else
 			p = tx_q->dma_tx + entry;
 
-		status = stmmac_tx_status(priv, &priv->dev->stats,
-				&priv->xstats, p, priv->ioaddr);
+		status = stmmac_tx_status(priv,	&priv->xstats, p, priv->ioaddr);
 		/* Check if the descriptor is owned by the DMA */
 		if (unlikely(status & tx_dma_own))
 			break;
@@ -2594,13 +2596,11 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
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
@@ -2704,6 +2704,18 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 			      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 			      HRTIMER_MODE_REL);
 
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.tx_packets += tx_packets;
+	priv->xstats.tx_pkt_n += tx_packets;
+	priv->xstats.tx_clean++;
+	u64_stats_update_end(&priv->xstats.syncp);
+
+	u64_stats_update_begin(&priv->xstats.txq_stats[queue].syncp);
+	priv->xstats.txq_stats[queue].tx_pkt_n += tx_packets;
+	u64_stats_update_end(&priv->xstats.txq_stats[queue].syncp);
+
+	priv->xstats.tx_errors += tx_errors;
+
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
 	/* Combine decisions from TX clean and XSK TX */
@@ -2731,7 +2743,7 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 			    tx_q->dma_tx_phy, chan);
 	stmmac_start_tx_dma(priv, chan);
 
-	priv->dev->stats.tx_errors++;
+	priv->xstats.tx_errors++;
 	netif_tx_wake_queue(netdev_get_tx_queue(priv->dev, chan));
 }
 
@@ -4248,7 +4260,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
-		priv->xstats.tx_set_ic_bit++;
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -4264,9 +4275,13 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	dev->stats.tx_bytes += skb->len;
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.tx_bytes += skb->len;
 	priv->xstats.tx_tso_frames++;
 	priv->xstats.tx_tso_nfrags += nfrags;
+	if (set_ic)
+		priv->xstats.tx_set_ic_bit++;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4316,7 +4331,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 dma_map_err:
 	dev_err(priv->device, "Tx dma map failed\n");
 	dev_kfree_skb(skb);
-	priv->dev->stats.tx_dropped++;
+	priv->xstats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
@@ -4470,7 +4485,6 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
-		priv->xstats.tx_set_ic_bit++;
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -4497,7 +4511,11 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 
-	dev->stats.tx_bytes += skb->len;
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.tx_bytes += skb->len;
+	if (set_ic)
+		priv->xstats.tx_set_ic_bit++;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
@@ -4559,7 +4577,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 dma_map_err:
 	netdev_err(priv->dev, "Tx DMA map failed\n");
 	dev_kfree_skb(skb);
-	priv->dev->stats.tx_dropped++;
+	priv->xstats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
@@ -4762,7 +4780,9 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	if (set_ic) {
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, tx_desc);
+		u64_stats_update_begin(&priv->xstats.syncp);
 		priv->xstats.tx_set_ic_bit++;
+		u64_stats_update_end(&priv->xstats.syncp);
 	}
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
@@ -4916,7 +4936,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 
 	skb = stmmac_construct_skb_zc(ch, xdp);
 	if (!skb) {
-		priv->dev->stats.rx_dropped++;
+		priv->xstats.rx_dropped++;
 		return;
 	}
 
@@ -4935,8 +4955,10 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	skb_record_rx_queue(skb, queue);
 	napi_gro_receive(&ch->rxtx_napi, skb);
 
-	priv->dev->stats.rx_packets++;
-	priv->dev->stats.rx_bytes += len;
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.rx_packets++;
+	priv->xstats.rx_bytes += len;
+	u64_stats_update_end(&priv->xstats.syncp);
 }
 
 static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
@@ -5011,6 +5033,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int count = 0, error = 0, len = 0;
+	u32 rx_errors = 0, rx_dropped = 0;
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int next_entry = rx_q->cur_rx;
 	unsigned int desc_size;
@@ -5071,8 +5094,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			p = rx_q->dma_rx + entry;
 
 		/* read the status of the incoming frame */
-		status = stmmac_rx_status(priv, &priv->dev->stats,
-					  &priv->xstats, p);
+		status = stmmac_rx_status(priv, &priv->xstats, p);
 		/* check if managed by the DMA otherwise go ahead */
 		if (unlikely(status & dma_own))
 			break;
@@ -5094,8 +5116,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 
 		if (priv->extend_desc)
-			stmmac_rx_extended_status(priv, &priv->dev->stats,
-						  &priv->xstats,
+			stmmac_rx_extended_status(priv, &priv->xstats,
 						  rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
 			xsk_buff_free(buf->xdp);
@@ -5103,7 +5124,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			dirty++;
 			error = 1;
 			if (!priv->hwts_rx_en)
-				priv->dev->stats.rx_errors++;
+				rx_errors++;
 		}
 
 		if (unlikely(error && (status & rx_not_ls)))
@@ -5151,7 +5172,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 		case STMMAC_XDP_CONSUMED:
 			xsk_buff_free(buf->xdp);
-			priv->dev->stats.rx_dropped++;
+			rx_dropped++;
 			break;
 		case STMMAC_XDP_TX:
 		case STMMAC_XDP_REDIRECT:
@@ -5172,8 +5193,16 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_finalize_xdp_rx(priv, xdp_status);
 
+	u64_stats_update_begin(&priv->xstats.syncp);
 	priv->xstats.rx_pkt_n += count;
+	u64_stats_update_end(&priv->xstats.syncp);
+
+	u64_stats_update_begin(&priv->xstats.rxq_stats[queue].syncp);
 	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&priv->xstats.rxq_stats[queue].syncp);
+
+	priv->xstats.rx_dropped += rx_dropped;
+	priv->xstats.rx_errors += rx_errors;
 
 	if (xsk_uses_need_wakeup(rx_q->xsk_pool)) {
 		if (failure || stmmac_rx_dirty(priv, queue) > 0)
@@ -5197,6 +5226,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
+	u32 rx_errors = 0, rx_dropped = 0, rx_bytes = 0, rx_packets = 0;
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int count = 0, error = 0, len = 0;
@@ -5261,8 +5291,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			p = rx_q->dma_rx + entry;
 
 		/* read the status of the incoming frame */
-		status = stmmac_rx_status(priv, &priv->dev->stats,
-				&priv->xstats, p);
+		status = stmmac_rx_status(priv, &priv->xstats, p);
 		/* check if managed by the DMA otherwise go ahead */
 		if (unlikely(status & dma_own))
 			break;
@@ -5279,14 +5308,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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
@@ -5354,7 +5382,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   virt_to_head_page(ctx.xdp.data),
 							   sync_len, true);
 					buf->page = NULL;
-					priv->dev->stats.rx_dropped++;
+					rx_dropped++;
 
 					/* Clear skb as it was set as
 					 * status by XDP program.
@@ -5383,7 +5411,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
-				priv->dev->stats.rx_dropped++;
+				rx_dropped++;
 				count++;
 				goto drain_data;
 			}
@@ -5443,8 +5471,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		napi_gro_receive(&ch->rx_napi, skb);
 		skb = NULL;
 
-		priv->dev->stats.rx_packets++;
-		priv->dev->stats.rx_bytes += len;
+		rx_packets++;
+		rx_bytes += len;
 		count++;
 	}
 
@@ -5459,8 +5487,18 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 	stmmac_rx_refill(priv, queue);
 
+	u64_stats_update_begin(&priv->xstats.syncp);
+	priv->xstats.rx_packets += rx_packets;
+	priv->xstats.rx_bytes += rx_bytes;
 	priv->xstats.rx_pkt_n += count;
+	u64_stats_update_end(&priv->xstats.syncp);
+
+	u64_stats_update_begin(&priv->xstats.rxq_stats[queue].syncp);
 	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
+	u64_stats_update_end(&priv->xstats.rxq_stats[queue].syncp);
+
+	priv->xstats.rx_dropped += rx_dropped;
+	priv->xstats.rx_errors += rx_errors;
 
 	return count;
 }
@@ -5473,7 +5511,9 @@ static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 	u32 chan = ch->index;
 	int work_done;
 
+	u64_stats_update_begin(&priv->xstats.syncp);
 	priv->xstats.napi_poll++;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	work_done = stmmac_rx(priv, budget, chan);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -5495,7 +5535,9 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 	u32 chan = ch->index;
 	int work_done;
 
+	u64_stats_update_begin(&priv->xstats.syncp);
 	priv->xstats.napi_poll++;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	work_done = stmmac_tx_clean(priv, budget, chan);
 	work_done = min(work_done, budget);
@@ -5519,7 +5561,9 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	int rx_done, tx_done, rxtx_done;
 	u32 chan = ch->index;
 
+	u64_stats_update_begin(&priv->xstats.syncp);
 	priv->xstats.napi_poll++;
+	u64_stats_update_end(&priv->xstats.syncp);
 
 	tx_done = stmmac_tx_clean(priv, budget, chan);
 	tx_done = min(tx_done, budget);
@@ -6775,6 +6819,39 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 	return 0;
 }
 
+static void stmmac_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	unsigned int start;
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 tx_packets;
+	u64 tx_bytes;
+
+	do {
+		start = u64_stats_fetch_begin(&priv->xstats.syncp);
+		rx_packets = priv->xstats.rx_packets;
+		rx_bytes   = priv->xstats.rx_bytes;
+		tx_packets = priv->xstats.tx_packets;
+		tx_bytes   = priv->xstats.tx_bytes;
+	} while (u64_stats_fetch_retry(&priv->xstats.syncp, start));
+
+	stats->rx_packets = rx_packets;
+	stats->rx_bytes = rx_bytes;
+	stats->tx_packets = tx_packets;
+	stats->tx_bytes = tx_bytes;
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
@@ -6785,6 +6862,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_set_rx_mode = stmmac_set_rx_mode,
 	.ndo_tx_timeout = stmmac_tx_timeout,
 	.ndo_eth_ioctl = stmmac_ioctl,
+	.ndo_get_stats64 = stmmac_get_stats64,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -7305,6 +7383,12 @@ int stmmac_dvr_probe(struct device *device,
 
 	priv->xstats.threshold = tc;
 
+	u64_stats_init(&priv->xstats.syncp);
+	for (i = 0; i < priv->plat->rx_queues_to_use; i++)
+		u64_stats_init(&priv->xstats.rxq_stats[i].syncp);
+	for (i = 0; i < priv->plat->tx_queues_to_use; i++)
+		u64_stats_init(&priv->xstats.txq_stats[i].syncp);
+
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
 	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
-- 
2.40.1


