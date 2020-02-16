Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684341606A4
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgBPVIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgBPVIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:22 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F92A20726;
        Sun, 16 Feb 2020 21:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887302;
        bh=edApw08klPhIPD/+7aOi+ITndtjGY0qm7alSyftfdFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0p4xH9jPt6qtQ9vE1YaDoPa+FO0U7eFuNPUoQMssH1tQTKEYBGITFsLYXi8HzVUj
         C6qa2qP19nqRONyLT/W1K1Ie54ElN/OjJrtsu0dgjmS67OAciHi+YpivmrtMXj6aNg
         3VP61x12ceiHbqMRxFLX3wl1w1HoCTHH5JtCXzaU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 3/5] net: mvneta: rely on struct mvneta_stats in mvneta_update_stats routine
Date:   Sun, 16 Feb 2020 22:07:31 +0100
Message-Id: <efdce29ba14838c3715ef3822cbc679c9cba3161.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mvneta_stats structure in mvneta_update_stats routine signature
in order to collect all the rx stats and update them at the end at the
napi loop. mvneta_stats will be reused adding xdp statistics support to
ethtool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 73 +++++++++++++++------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 6552b84be7c9..d41fc7044fa6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -397,7 +397,15 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
 };
 
+struct mvneta_stats {
+	u64	rx_packets;
+	u64	rx_bytes;
+	u64	tx_packets;
+	u64	tx_bytes;
+};
+
 struct mvneta_ethtool_stats {
+	struct mvneta_stats ps;
 	u64	skb_alloc_error;
 	u64	refill_error;
 };
@@ -406,12 +414,8 @@ struct mvneta_pcpu_stats {
 	struct u64_stats_sync syncp;
 
 	struct mvneta_ethtool_stats es;
-	u64	rx_packets;
-	u64	rx_bytes;
 	u64	rx_dropped;
 	u64	rx_errors;
-	u64	tx_packets;
-	u64	tx_bytes;
 };
 
 struct mvneta_pcpu_port {
@@ -751,12 +755,12 @@ mvneta_get_stats64(struct net_device *dev,
 		cpu_stats = per_cpu_ptr(pp->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			rx_packets = cpu_stats->rx_packets;
-			rx_bytes   = cpu_stats->rx_bytes;
+			rx_packets = cpu_stats->es.ps.rx_packets;
+			rx_bytes   = cpu_stats->es.ps.rx_bytes;
 			rx_dropped = cpu_stats->rx_dropped;
 			rx_errors  = cpu_stats->rx_errors;
-			tx_packets = cpu_stats->tx_packets;
-			tx_bytes   = cpu_stats->tx_bytes;
+			tx_packets = cpu_stats->es.ps.tx_packets;
+			tx_bytes   = cpu_stats->es.ps.tx_bytes;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
@@ -1945,13 +1949,14 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 }
 
 static void
-mvneta_update_stats(struct mvneta_port *pp, u32 pkts, u32 len)
+mvneta_update_stats(struct mvneta_port *pp,
+		    struct mvneta_stats *ps)
 {
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
 	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets += pkts;
-	stats->rx_bytes += len;
+	stats->es.ps.rx_packets += ps->rx_packets;
+	stats->es.ps.rx_bytes += ps->rx_bytes;
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -2026,8 +2031,8 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	tx_desc->data_size = xdpf->len;
 
 	u64_stats_update_begin(&stats->syncp);
-	stats->tx_bytes += xdpf->len;
-	stats->tx_packets++;
+	stats->es.ps.tx_bytes += xdpf->len;
+	stats->es.ps.tx_packets++;
 	u64_stats_update_end(&stats->syncp);
 
 	mvneta_txq_inc_put(txq);
@@ -2098,7 +2103,8 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 
 static int
 mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
-	       struct bpf_prog *prog, struct xdp_buff *xdp)
+	       struct bpf_prog *prog, struct xdp_buff *xdp,
+	       struct mvneta_stats *stats)
 {
 	unsigned int len;
 	u32 ret, act;
@@ -2108,8 +2114,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 	switch (act) {
 	case XDP_PASS:
-		ret = MVNETA_XDP_PASS;
-		break;
+		return MVNETA_XDP_PASS;
 	case XDP_REDIRECT: {
 		int err;
 
@@ -2145,6 +2150,9 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		break;
 	}
 
+	stats->rx_bytes += xdp->data_end - xdp->data;
+	stats->rx_packets++;
+
 	return ret;
 }
 
@@ -2154,7 +2162,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp,
 		     struct bpf_prog *xdp_prog,
-		     struct page *page, u32 *xdp_ret)
+		     struct page *page, u32 *xdp_ret,
+		     struct mvneta_stats *stats)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
@@ -2185,10 +2194,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	if (xdp_prog) {
 		u32 ret;
 
-		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp);
+		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp, stats);
 		if (ret != MVNETA_XDP_PASS) {
-			mvneta_update_stats(pp, 1,
-					    xdp->data_end - xdp->data);
 			rx_desc->buf_phys_addr = 0;
 			*xdp_ret |= ret;
 			return ret;
@@ -2259,11 +2266,11 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			  struct mvneta_port *pp, int budget,
 			  struct mvneta_rx_queue *rxq)
 {
-	int rcvd_pkts = 0, rcvd_bytes = 0, rx_proc = 0;
+	int rx_proc = 0, rx_todo, refill;
 	struct net_device *dev = pp->dev;
+	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp_buf;
-	int rx_todo, refill;
 	u32 xdp_ret = 0;
 
 	/* Get number of received packets */
@@ -2297,7 +2304,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			}
 
 			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-						   xdp_prog, page, &xdp_ret);
+						   xdp_prog, page, &xdp_ret,
+						   &ps);
 			if (err)
 				continue;
 		} else {
@@ -2321,8 +2329,9 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			rxq->skb = NULL;
 			continue;
 		}
-		rcvd_pkts++;
-		rcvd_bytes += rxq->skb->len;
+
+		ps.rx_bytes += rxq->skb->len;
+		ps.rx_packets++;
 
 		/* Linux processing */
 		rxq->skb->protocol = eth_type_trans(rxq->skb, dev);
@@ -2337,8 +2346,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	if (xdp_ret & MVNETA_XDP_REDIR)
 		xdp_do_flush_map();
 
-	if (rcvd_pkts)
-		mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes);
+	if (ps.rx_packets)
+		mvneta_update_stats(pp, &ps);
 
 	/* return some buffers to hardware queue, one at a time is too slow */
 	refill = mvneta_rx_refill_queue(pp, rxq);
@@ -2346,7 +2355,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	/* Update rxq management counters */
 	mvneta_rxq_desc_num_update(pp, rxq, rx_proc, refill);
 
-	return rcvd_pkts;
+	return ps.rx_packets;
 }
 
 /* Main rx processing when using hardware buffer management */
@@ -2472,8 +2481,8 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
 		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets += rcvd_pkts;
-		stats->rx_bytes += rcvd_bytes;
+		stats->es.ps.rx_packets += rcvd_pkts;
+		stats->es.ps.rx_bytes += rcvd_bytes;
 		u64_stats_update_end(&stats->syncp);
 	}
 
@@ -2746,8 +2755,8 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 			txq->pending += frags;
 
 		u64_stats_update_begin(&stats->syncp);
-		stats->tx_bytes += len;
-		stats->tx_packets++;
+		stats->es.ps.tx_bytes += len;
+		stats->es.ps.tx_packets++;
 		u64_stats_update_end(&stats->syncp);
 	} else {
 		dev->stats.tx_dropped++;
-- 
2.24.1

