Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA851606A2
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBPVIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgBPVIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:14 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384DA2086A;
        Sun, 16 Feb 2020 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887293;
        bh=muDzFphdqycvwgSXEbwYz9Scnsp0IQqSHFDJzGZkv64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTicixcSSE2RC2f9c7hbf3PUtC7lMRGZZD006aM6VBZYPc3ifEvXfS9fv1HDwQRpn
         /GvsHTpMPD6T7WagP8/8xOS/kOfgqhW6PYbbDkU7G7nChrZpIfoh6qevIsS3Epqb9D
         g3NGj9417A+rMDJctoScudBr2Wx6yZEo9bw2uQqo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 1/5] net: mvneta: move refill_err and skb_alloc_err in per-cpu stats
Date:   Sun, 16 Feb 2020 22:07:29 +0100
Message-Id: <bd39cb8cd436552adf5a73213ca1358ba983c9a7.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta_ethtool_update_stats routine is currently reporting
skb_alloc_error and refill_error only for the first rx queue.
Fix the issue moving skb_alloc_err and refill_err in
mvneta_pcpu_stats structure.
Moreover this patch will be used to introduce xdp statistics
to ethtool for the mvneta driver

Fixes: 17a96da62716 ("net: mvneta: discriminate error cause for missed packet")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 69 +++++++++++++++++++++------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 98017e7d5dd0..7433a305e0ff 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -397,8 +397,15 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
 };
 
+struct mvneta_ethtool_stats {
+	u64	skb_alloc_error;
+	u64	refill_error;
+};
+
 struct mvneta_pcpu_stats {
-	struct	u64_stats_sync syncp;
+	struct u64_stats_sync syncp;
+
+	struct mvneta_ethtool_stats es;
 	u64	rx_packets;
 	u64	rx_bytes;
 	u64	rx_dropped;
@@ -660,10 +667,6 @@ struct mvneta_rx_queue {
 	/* pointer to uncomplete skb buffer */
 	struct sk_buff *skb;
 	int left_size;
-
-	/* error counters */
-	u32 skb_alloc_err;
-	u32 refill_err;
 };
 
 static enum cpuhp_state online_hpstate;
@@ -1969,9 +1972,15 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 		rx_desc = rxq->descs + curr_desc;
 		if (!(rx_desc->buf_phys_addr)) {
 			if (mvneta_rx_refill(pp, rx_desc, rxq, GFP_ATOMIC)) {
+				struct mvneta_pcpu_stats *stats;
+
 				pr_err("Can't refill queue %d. Done %d from %d\n",
 				       rxq->id, i, rxq->refill_num);
-				rxq->refill_err++;
+
+				stats = this_cpu_ptr(pp->stats);
+				u64_stats_update_begin(&stats->syncp);
+				stats->es.refill_error++;
+				u64_stats_update_end(&stats->syncp);
 				break;
 			}
 		}
@@ -2193,9 +2202,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
 		netdev_err(dev, "Can't allocate skb on queue %d\n", rxq->id);
-		rxq->skb_alloc_err++;
 
 		u64_stats_update_begin(&stats->syncp);
+		stats->es.skb_alloc_error++;
 		stats->rx_dropped++;
 		u64_stats_update_end(&stats->syncp);
 
@@ -2423,8 +2432,15 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		/* Refill processing */
 		err = hwbm_pool_refill(&bm_pool->hwbm_pool, GFP_ATOMIC);
 		if (err) {
+			struct mvneta_pcpu_stats *stats;
+
 			netdev_err(dev, "Linux processing - Can't refill\n");
-			rxq->refill_err++;
+
+			stats = this_cpu_ptr(pp->stats);
+			u64_stats_update_begin(&stats->syncp);
+			stats->es.refill_error++;
+			u64_stats_update_end(&stats->syncp);
+
 			goto err_drop_frame_ret_pool;
 		}
 
@@ -4420,45 +4436,70 @@ static void mvneta_ethtool_get_strings(struct net_device *netdev, u32 sset,
 	}
 }
 
+static void
+mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
+				 struct mvneta_ethtool_stats *es)
+{
+	unsigned int start;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct mvneta_pcpu_stats *stats;
+		u64 skb_alloc_error;
+		u64 refill_error;
+
+		stats = per_cpu_ptr(pp->stats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			skb_alloc_error = stats->es.skb_alloc_error;
+			refill_error = stats->es.refill_error;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		es->skb_alloc_error += skb_alloc_error;
+		es->refill_error += refill_error;
+	}
+}
+
 static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 {
+	struct mvneta_ethtool_stats stats = {};
 	const struct mvneta_statistic *s;
 	void __iomem *base = pp->base;
 	u32 high, low;
 	u64 val;
 	int i;
 
+	mvneta_ethtool_update_pcpu_stats(pp, &stats);
 	for (i = 0, s = mvneta_statistics;
 	     s < mvneta_statistics + ARRAY_SIZE(mvneta_statistics);
 	     s++, i++) {
-		val = 0;
-
 		switch (s->type) {
 		case T_REG_32:
 			val = readl_relaxed(base + s->offset);
+			pp->ethtool_stats[i] += val;
 			break;
 		case T_REG_64:
 			/* Docs say to read low 32-bit then high */
 			low = readl_relaxed(base + s->offset);
 			high = readl_relaxed(base + s->offset + 4);
 			val = (u64)high << 32 | low;
+			pp->ethtool_stats[i] += val;
 			break;
 		case T_SW:
 			switch (s->offset) {
 			case ETHTOOL_STAT_EEE_WAKEUP:
 				val = phylink_get_eee_err(pp->phylink);
+				pp->ethtool_stats[i] += val;
 				break;
 			case ETHTOOL_STAT_SKB_ALLOC_ERR:
-				val = pp->rxqs[0].skb_alloc_err;
+				pp->ethtool_stats[i] = stats.skb_alloc_error;
 				break;
 			case ETHTOOL_STAT_REFILL_ERR:
-				val = pp->rxqs[0].refill_err;
+				pp->ethtool_stats[i] = stats.refill_error;
 				break;
 			}
 			break;
 		}
-
-		pp->ethtool_stats[i] += val;
 	}
 }
 
-- 
2.24.1

