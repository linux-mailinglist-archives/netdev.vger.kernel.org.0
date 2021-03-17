Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B629933E43C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhCQA6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:4730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhCQA5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:33 -0400
IronPort-SDR: StDN7xzC2iQEXHpw3TAKPAFn/OlvJjYdbc1Toh1+lKiSPt2bGL/D27qZY9k5wT19qZ9NJ3SEZ5
 tiwtL5YXbPCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="253376107"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="253376107"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 17:57:31 -0700
IronPort-SDR: TbwLPsOxXb8ouloq3An2idNUUve+El7T3l7U2A1Nm10FkMne1nnbhedUkIm1SqjVPlWjCnFnUC
 xiYILn2G4biw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="411265359"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2021 17:57:29 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 1/1] net: stmmac: add per-queue TX & RX coalesce ethtool support
Date:   Wed, 17 Mar 2021 09:01:23 +0800
Message-Id: <20210317010123.6304-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317010123.6304-1-boon.leong.ong@intel.com>
References: <20210317010123.6304-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extending the driver to support per-queue RX and TX coalesce settings in
order to support below commands:

To show per-queue coalesce setting:-
 $ ethtool --per-queue <DEVNAME> queue_mask <MASK> --show-coalesce

To set per-queue coalesce setting:-
 $ ethtool --per-queue <DEVNAME> queue_mask <MASK> --coalesce \
     [rx-usecs N] [rx-frames M] [tx-usecs P] [tx-frames Q]

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   7 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   7 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   8 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 118 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  48 ++++---
 7 files changed, 143 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
index 2bac49b49f73..90383abafa66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c
@@ -255,7 +255,7 @@ static void dwmac1000_get_hw_feature(void __iomem *ioaddr,
 }
 
 static void dwmac1000_rx_watchdog(void __iomem *ioaddr, u32 riwt,
-				  u32 number_chan)
+				  u32 queue)
 {
 	writel(riwt, ioaddr + DMA_RX_WATCHDOG);
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 62aa0e95beb7..8958778d16b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -210,12 +210,9 @@ static void dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 		_dwmac4_dump_dma_regs(ioaddr, i, reg_space);
 }
 
-static void dwmac4_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 number_chan)
+static void dwmac4_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
 {
-	u32 chan;
-
-	for (chan = 0; chan < number_chan; chan++)
-		writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(chan));
+	writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(queue));
 }
 
 static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 77308c5c5d29..f2cab5b76732 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -441,12 +441,9 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->frpsel = (hw_cap & XGMAC_HWFEAT_FRPSEL) >> 3;
 }
 
-static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 nchan)
+static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
 {
-	u32 i;
-
-	for (i = 0; i < nchan; i++)
-		writel(riwt & XGMAC_RWT, ioaddr + XGMAC_DMA_CH_Rx_WATCHDOG(i));
+	writel(riwt & XGMAC_RWT, ioaddr + XGMAC_DMA_CH_Rx_WATCHDOG(queue));
 }
 
 static void dwxgmac2_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 979ac9fca23c..da9996a985f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -206,7 +206,7 @@ struct stmmac_dma_ops {
 	void (*get_hw_feature)(void __iomem *ioaddr,
 			       struct dma_features *dma_cap);
 	/* Program the HW RX Watchdog */
-	void (*rx_watchdog)(void __iomem *ioaddr, u32 riwt, u32 number_chan);
+	void (*rx_watchdog)(void __iomem *ioaddr, u32 riwt, u32 queue);
 	void (*set_tx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
 	void (*set_rx_ring_len)(void __iomem *ioaddr, u32 len, u32 chan);
 	void (*set_rx_tail_ptr)(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 10e8ae8e2d58..375c503d2df8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -147,9 +147,9 @@ struct stmmac_flow_entry {
 
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
-	u32 tx_coal_frames;
-	u32 tx_coal_timer;
-	u32 rx_coal_frames;
+	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
+	u32 tx_coal_timer[MTL_MAX_TX_QUEUES];
+	u32 rx_coal_frames[MTL_MAX_TX_QUEUES];
 
 	int tx_coalesce;
 	int hwts_tx_en;
@@ -160,7 +160,7 @@ struct stmmac_priv {
 
 	unsigned int dma_buf_sz;
 	unsigned int rx_copybreak;
-	u32 rx_riwt;
+	u32 rx_riwt[MTL_MAX_TX_QUEUES];
 	int hwts_rx_en;
 
 	void __iomem *ioaddr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index c5642985ef95..a78d5b0686bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -756,28 +756,75 @@ static u32 stmmac_riwt2usec(u32 riwt, struct stmmac_priv *priv)
 	return (riwt * 256) / (clk / 1000000);
 }
 
-static int stmmac_get_coalesce(struct net_device *dev,
-			       struct ethtool_coalesce *ec)
+static int __stmmac_get_coalesce(struct net_device *dev,
+				 struct ethtool_coalesce *ec,
+				 int queue)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	u32 max_cnt;
+	u32 rx_cnt;
+	u32 tx_cnt;
 
-	ec->tx_coalesce_usecs = priv->tx_coal_timer;
-	ec->tx_max_coalesced_frames = priv->tx_coal_frames;
+	rx_cnt = priv->plat->rx_queues_to_use;
+	tx_cnt = priv->plat->tx_queues_to_use;
+	max_cnt = max(rx_cnt, tx_cnt);
 
-	if (priv->use_riwt) {
-		ec->rx_max_coalesced_frames = priv->rx_coal_frames;
-		ec->rx_coalesce_usecs = stmmac_riwt2usec(priv->rx_riwt, priv);
+	if (queue < 0)
+		queue = 0;
+	else if (queue >= max_cnt)
+		return -EINVAL;
+
+	if (queue < tx_cnt) {
+		ec->tx_coalesce_usecs = priv->tx_coal_timer[queue];
+		ec->tx_max_coalesced_frames = priv->tx_coal_frames[queue];
+	} else {
+		ec->tx_coalesce_usecs = 0;
+		ec->tx_max_coalesced_frames = 0;
+	}
+
+	if (priv->use_riwt && queue < rx_cnt) {
+		ec->rx_max_coalesced_frames = priv->rx_coal_frames[queue];
+		ec->rx_coalesce_usecs = stmmac_riwt2usec(priv->rx_riwt[queue],
+							 priv);
+	} else {
+		ec->rx_max_coalesced_frames = 0;
+		ec->rx_coalesce_usecs = 0;
 	}
 
 	return 0;
 }
 
-static int stmmac_set_coalesce(struct net_device *dev,
+static int stmmac_get_coalesce(struct net_device *dev,
 			       struct ethtool_coalesce *ec)
+{
+	return __stmmac_get_coalesce(dev, ec, -1);
+}
+
+static int stmmac_get_per_queue_coalesce(struct net_device *dev, u32 queue,
+					 struct ethtool_coalesce *ec)
+{
+	return __stmmac_get_coalesce(dev, ec, queue);
+}
+
+static int __stmmac_set_coalesce(struct net_device *dev,
+				 struct ethtool_coalesce *ec,
+				 int queue)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	bool all_queues = false;
 	unsigned int rx_riwt;
+	u32 max_cnt;
+	u32 rx_cnt;
+	u32 tx_cnt;
+
+	rx_cnt = priv->plat->rx_queues_to_use;
+	tx_cnt = priv->plat->tx_queues_to_use;
+	max_cnt = max(rx_cnt, tx_cnt);
+
+	if (queue < 0)
+		all_queues = true;
+	else if (queue >= max_cnt)
+		return -EINVAL;
 
 	if (priv->use_riwt && (ec->rx_coalesce_usecs > 0)) {
 		rx_riwt = stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);
@@ -785,8 +832,23 @@ static int stmmac_set_coalesce(struct net_device *dev,
 		if ((rx_riwt > MAX_DMA_RIWT) || (rx_riwt < MIN_DMA_RIWT))
 			return -EINVAL;
 
-		priv->rx_riwt = rx_riwt;
-		stmmac_rx_watchdog(priv, priv->ioaddr, priv->rx_riwt, rx_cnt);
+		if (all_queues) {
+			int i;
+
+			for (i = 0; i < rx_cnt; i++) {
+				priv->rx_riwt[i] = rx_riwt;
+				stmmac_rx_watchdog(priv, priv->ioaddr,
+						   rx_riwt, i);
+				priv->rx_coal_frames[i] =
+					ec->rx_max_coalesced_frames;
+			}
+		} else if (queue < rx_cnt) {
+			priv->rx_riwt[queue] = rx_riwt;
+			stmmac_rx_watchdog(priv, priv->ioaddr,
+					   rx_riwt, queue);
+			priv->rx_coal_frames[queue] =
+				ec->rx_max_coalesced_frames;
+		}
 	}
 
 	if ((ec->tx_coalesce_usecs == 0) &&
@@ -797,13 +859,37 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	    (ec->tx_max_coalesced_frames > STMMAC_TX_MAX_FRAMES))
 		return -EINVAL;
 
-	/* Only copy relevant parameters, ignore all others. */
-	priv->tx_coal_frames = ec->tx_max_coalesced_frames;
-	priv->tx_coal_timer = ec->tx_coalesce_usecs;
-	priv->rx_coal_frames = ec->rx_max_coalesced_frames;
+	if (all_queues) {
+		int i;
+
+		for (i = 0; i < tx_cnt; i++) {
+			priv->tx_coal_frames[i] =
+				ec->tx_max_coalesced_frames;
+			priv->tx_coal_timer[i] =
+				ec->tx_coalesce_usecs;
+		}
+	} else if (queue < tx_cnt) {
+		priv->tx_coal_frames[queue] =
+			ec->tx_max_coalesced_frames;
+		priv->tx_coal_timer[queue] =
+			ec->tx_coalesce_usecs;
+	}
+
 	return 0;
 }
 
+static int stmmac_set_coalesce(struct net_device *dev,
+			       struct ethtool_coalesce *ec)
+{
+	return __stmmac_set_coalesce(dev, ec, -1);
+}
+
+static int stmmac_set_per_queue_coalesce(struct net_device *dev, u32 queue,
+					 struct ethtool_coalesce *ec)
+{
+	return __stmmac_set_coalesce(dev, ec, queue);
+}
+
 static int stmmac_get_rxnfc(struct net_device *dev,
 			    struct ethtool_rxnfc *rxnfc, u32 *rule_locs)
 {
@@ -1001,6 +1087,8 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.get_ts_info = stmmac_get_ts_info,
 	.get_coalesce = stmmac_get_coalesce,
 	.set_coalesce = stmmac_set_coalesce,
+	.get_per_queue_coalesce = stmmac_get_per_queue_coalesce,
+	.set_per_queue_coalesce = stmmac_set_per_queue_coalesce,
 	.get_channels = stmmac_get_channels,
 	.set_channels = stmmac_set_channels,
 	.get_tunable = stmmac_get_tunable,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a10704d8e3c6..0647f6c94aed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2218,7 +2218,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	/* We still have pending packets, let's call for a new scheduling */
 	if (tx_q->dirty_tx != tx_q->cur_tx)
-		hrtimer_start(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer),
+		hrtimer_start(&tx_q->txtimer,
+			      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 			      HRTIMER_MODE_REL);
 
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
@@ -2503,7 +2504,8 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
 {
 	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 
-	hrtimer_start(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer),
+	hrtimer_start(&tx_q->txtimer,
+		      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 		      HRTIMER_MODE_REL);
 }
 
@@ -2544,18 +2546,21 @@ static enum hrtimer_restart stmmac_tx_timer(struct hrtimer *t)
 static void stmmac_init_coalesce(struct stmmac_priv *priv)
 {
 	u32 tx_channel_count = priv->plat->tx_queues_to_use;
+	u32 rx_channel_count = priv->plat->rx_queues_to_use;
 	u32 chan;
 
-	priv->tx_coal_frames = STMMAC_TX_FRAMES;
-	priv->tx_coal_timer = STMMAC_COAL_TX_TIMER;
-	priv->rx_coal_frames = STMMAC_RX_FRAMES;
-
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
 
+		priv->tx_coal_frames[chan] = STMMAC_TX_FRAMES;
+		priv->tx_coal_timer[chan] = STMMAC_COAL_TX_TIMER;
+
 		hrtimer_init(&tx_q->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		tx_q->txtimer.function = stmmac_tx_timer;
 	}
+
+	for (chan = 0; chan < rx_channel_count; chan++)
+		priv->rx_coal_frames[chan] = STMMAC_RX_FRAMES;
 }
 
 static void stmmac_set_rings_length(struct stmmac_priv *priv)
@@ -2860,10 +2865,15 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 		priv->tx_lpi_timer = eee_timer * 1000;
 
 	if (priv->use_riwt) {
-		if (!priv->rx_riwt)
-			priv->rx_riwt = DEF_DMA_RIWT;
+		u32 queue;
+
+		for (queue = 0; queue < rx_cnt; queue++) {
+			if (!priv->rx_riwt[queue])
+				priv->rx_riwt[queue] = DEF_DMA_RIWT;
 
-		ret = stmmac_rx_watchdog(priv, priv->ioaddr, priv->rx_riwt, rx_cnt);
+			stmmac_rx_watchdog(priv, priv->ioaddr,
+					   priv->rx_riwt[queue], queue);
+		}
 	}
 
 	if (priv->hw->pcs)
@@ -3362,11 +3372,12 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) && priv->hwts_tx_en)
 		set_ic = true;
-	else if (!priv->tx_coal_frames)
+	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
-	else if (tx_packets > priv->tx_coal_frames)
+	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
-	else if ((tx_q->tx_count_frames % priv->tx_coal_frames) < tx_packets)
+	else if ((tx_q->tx_count_frames %
+		  priv->tx_coal_frames[queue]) < tx_packets)
 		set_ic = true;
 	else
 		set_ic = false;
@@ -3591,11 +3602,12 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) && priv->hwts_tx_en)
 		set_ic = true;
-	else if (!priv->tx_coal_frames)
+	else if (!priv->tx_coal_frames[queue])
 		set_ic = false;
-	else if (tx_packets > priv->tx_coal_frames)
+	else if (tx_packets > priv->tx_coal_frames[queue])
 		set_ic = true;
-	else if ((tx_q->tx_count_frames % priv->tx_coal_frames) < tx_packets)
+	else if ((tx_q->tx_count_frames %
+		  priv->tx_coal_frames[queue]) < tx_packets)
 		set_ic = true;
 	else
 		set_ic = false;
@@ -3794,11 +3806,11 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
-		rx_q->rx_count_frames += priv->rx_coal_frames;
-		if (rx_q->rx_count_frames > priv->rx_coal_frames)
+		rx_q->rx_count_frames += priv->rx_coal_frames[queue];
+		if (rx_q->rx_count_frames > priv->rx_coal_frames[queue])
 			rx_q->rx_count_frames = 0;
 
-		use_rx_wd = !priv->rx_coal_frames;
+		use_rx_wd = !priv->rx_coal_frames[queue];
 		use_rx_wd |= rx_q->rx_count_frames > 0;
 		if (!priv->use_riwt)
 			use_rx_wd = false;
-- 
2.25.1

