Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3CA1606A3
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBPVIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbgBPVIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:19 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C795B208C3;
        Sun, 16 Feb 2020 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887298;
        bh=eD1Xhq+G9hHSl4+5EyFHz1hN32ScEYw/ekfzPEBJmQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEEKAAMy2cM7JlOCTkVGuewES6cjfBs4HqQ4ST0mp5byVjR51QrDJu1lA49DvnRMk
         tTz/vJDsO1rHPofQCVOrODqQJmlyX5KzdZsrnPi7tkvcPY42p4KRQbUsNVlx/lV49u
         xasCp4vXMyyjur9aAnhEz0baQpNagsxOL+lCbiI0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 2/5] net: mvneta: rely on open-coding updating stats for non-xdp and tx path
Date:   Sun, 16 Feb 2020 22:07:30 +0100
Message-Id: <e0c10323e86c0f5bb2b6d0d5d980b70789fa09a2.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In oreder to avoid unnecessary instructions rely on open-coding updating
per-cpu stats in mvneta_tx/mvneta_xdp_submit_frame and mvneta_rx_hwbm
routines. This patch will be used to add xdp support to ethtool for the
mvneta driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 40 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7433a305e0ff..6552b84be7c9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1945,19 +1945,13 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
 }
 
 static void
-mvneta_update_stats(struct mvneta_port *pp, u32 pkts,
-		    u32 len, bool tx)
+mvneta_update_stats(struct mvneta_port *pp, u32 pkts, u32 len)
 {
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
 	u64_stats_update_begin(&stats->syncp);
-	if (tx) {
-		stats->tx_packets += pkts;
-		stats->tx_bytes += len;
-	} else {
-		stats->rx_packets += pkts;
-		stats->rx_bytes += len;
-	}
+	stats->rx_packets += pkts;
+	stats->rx_bytes += len;
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -1996,6 +1990,7 @@ static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 			struct xdp_frame *xdpf, bool dma_map)
 {
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_desc *tx_desc;
 	struct mvneta_tx_buf *buf;
 	dma_addr_t dma_addr;
@@ -2030,7 +2025,11 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	tx_desc->buf_phys_addr = dma_addr;
 	tx_desc->data_size = xdpf->len;
 
-	mvneta_update_stats(pp, 1, xdpf->len, true);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += xdpf->len;
+	stats->tx_packets++;
+	u64_stats_update_end(&stats->syncp);
+
 	mvneta_txq_inc_put(txq);
 	txq->pending++;
 	txq->count++;
@@ -2189,8 +2188,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp);
 		if (ret != MVNETA_XDP_PASS) {
 			mvneta_update_stats(pp, 1,
-					    xdp->data_end - xdp->data,
-					    false);
+					    xdp->data_end - xdp->data);
 			rx_desc->buf_phys_addr = 0;
 			*xdp_ret |= ret;
 			return ret;
@@ -2340,7 +2338,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		xdp_do_flush_map();
 
 	if (rcvd_pkts)
-		mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
+		mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes);
 
 	/* return some buffers to hardware queue, one at a time is too slow */
 	refill = mvneta_rx_refill_queue(pp, rxq);
@@ -2470,8 +2468,14 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 		napi_gro_receive(napi, skb);
 	}
 
-	if (rcvd_pkts)
-		mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
+	if (rcvd_pkts) {
+		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_packets += rcvd_pkts;
+		stats->rx_bytes += rcvd_bytes;
+		u64_stats_update_end(&stats->syncp);
+	}
 
 	/* Update rxq management counters */
 	mvneta_rxq_desc_num_update(pp, rxq, rx_done, rx_done);
@@ -2727,6 +2731,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 out:
 	if (frags > 0) {
 		struct netdev_queue *nq = netdev_get_tx_queue(dev, txq_id);
+		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
 		netdev_tx_sent_queue(nq, len);
 
@@ -2740,7 +2745,10 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 		else
 			txq->pending += frags;
 
-		mvneta_update_stats(pp, 1, len, true);
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_bytes += len;
+		stats->tx_packets++;
+		u64_stats_update_end(&stats->syncp);
 	} else {
 		dev->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
-- 
2.24.1

