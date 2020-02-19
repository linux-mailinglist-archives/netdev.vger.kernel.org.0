Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCCE1640E9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgBSJ5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbgBSJ5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 04:57:52 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3794521D56;
        Wed, 19 Feb 2020 09:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582106270;
        bh=HDpGa9t2mlk/qeWGVPL2lJCrLYCMr7KkBb+ZD4aNI/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=YNfJBYcDBmiqf57L2VbwBFTtoAL0s+k4hQGGHwxjoSttctmmIyEeLI0B+6H2u3jo0
         SqqrEeyCNQ7Sy9NEg0jtxW3x91xzbCKR0XqfkXWAp+tXwvruFXUT/3Rec5z26u1A2P
         eiRePQLCwuMrZi/+sLcuaszUOrtLn8IYobZBwHys=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, dsahern@kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next] net: mvneta: align xdp stats naming scheme to mlx5 driver
Date:   Wed, 19 Feb 2020 10:57:37 +0100
Message-Id: <6c5f27aff46e6dd6be92ce29b65bc3670eeabffc.1582105994.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce "rx" prefix in the name scheme for xdp counters
on rx path.
Differentiate between XDP_TX and ndo_xdp_xmit counters

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since RFC:
- rename rx_xdp_tx_xmit in rx_xdp_tx
- move tx stats accounting in mvneta_xdp_xmit_back/mvneta_xdp_xmit
---
 drivers/net/ethernet/marvell/mvneta.c | 52 ++++++++++++++++++---------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b7045b6a15c2..8e1feb678cea 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -344,6 +344,7 @@ enum {
 	ETHTOOL_XDP_REDIRECT,
 	ETHTOOL_XDP_PASS,
 	ETHTOOL_XDP_DROP,
+	ETHTOOL_XDP_XMIT,
 	ETHTOOL_XDP_TX,
 	ETHTOOL_MAX_STATS,
 };
@@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
 	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
-	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
-	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
-	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
-	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
+	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
+	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
+	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
+	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
+	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
 };
 
 struct mvneta_stats {
@@ -414,6 +416,7 @@ struct mvneta_stats {
 	u64	xdp_redirect;
 	u64	xdp_pass;
 	u64	xdp_drop;
+	u64	xdp_xmit;
 	u64	xdp_tx;
 };
 
@@ -2012,7 +2015,6 @@ static int
 mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 			struct xdp_frame *xdpf, bool dma_map)
 {
-	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_desc *tx_desc;
 	struct mvneta_tx_buf *buf;
 	dma_addr_t dma_addr;
@@ -2047,12 +2049,6 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	tx_desc->buf_phys_addr = dma_addr;
 	tx_desc->data_size = xdpf->len;
 
-	u64_stats_update_begin(&stats->syncp);
-	stats->es.ps.tx_bytes += xdpf->len;
-	stats->es.ps.tx_packets++;
-	stats->es.ps.xdp_tx++;
-	u64_stats_update_end(&stats->syncp);
-
 	mvneta_txq_inc_put(txq);
 	txq->pending++;
 	txq->count++;
@@ -2079,8 +2075,17 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 
 	__netif_tx_lock(nq, cpu);
 	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
-	if (ret == MVNETA_XDP_TX)
+	if (ret == MVNETA_XDP_TX) {
+		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
+		u64_stats_update_begin(&stats->syncp);
+		stats->es.ps.tx_bytes += xdpf->len;
+		stats->es.ps.tx_packets++;
+		stats->es.ps.xdp_tx++;
+		u64_stats_update_end(&stats->syncp);
+
 		mvneta_txq_pend_desc_add(pp, txq, 0);
+	}
 	__netif_tx_unlock(nq);
 
 	return ret;
@@ -2091,10 +2096,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 		struct xdp_frame **frames, u32 flags)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+	int i, nxmit_byte = 0, nxmit = num_frame;
 	int cpu = smp_processor_id();
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
-	int i, drops = 0;
 	u32 ret;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
@@ -2106,9 +2112,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 	__netif_tx_lock(nq, cpu);
 	for (i = 0; i < num_frame; i++) {
 		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
-		if (ret != MVNETA_XDP_TX) {
+		if (ret == MVNETA_XDP_TX) {
+			nxmit_byte += frames[i]->len;
+		} else {
 			xdp_return_frame_rx_napi(frames[i]);
-			drops++;
+			nxmit--;
 		}
 	}
 
@@ -2116,7 +2124,13 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 		mvneta_txq_pend_desc_add(pp, txq, 0);
 	__netif_tx_unlock(nq);
 
-	return num_frame - drops;
+	u64_stats_update_begin(&stats->syncp);
+	stats->es.ps.tx_bytes += nxmit_byte;
+	stats->es.ps.tx_packets += nxmit;
+	stats->es.ps.xdp_xmit += nxmit;
+	u64_stats_update_end(&stats->syncp);
+
+	return nxmit;
 }
 
 static int
@@ -4484,6 +4498,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		u64 xdp_redirect;
 		u64 xdp_pass;
 		u64 xdp_drop;
+		u64 xdp_xmit;
 		u64 xdp_tx;
 
 		stats = per_cpu_ptr(pp->stats, cpu);
@@ -4494,6 +4509,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 			xdp_redirect = stats->es.ps.xdp_redirect;
 			xdp_pass = stats->es.ps.xdp_pass;
 			xdp_drop = stats->es.ps.xdp_drop;
+			xdp_xmit = stats->es.ps.xdp_xmit;
 			xdp_tx = stats->es.ps.xdp_tx;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
@@ -4502,6 +4518,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		es->ps.xdp_redirect += xdp_redirect;
 		es->ps.xdp_pass += xdp_pass;
 		es->ps.xdp_drop += xdp_drop;
+		es->ps.xdp_xmit += xdp_xmit;
 		es->ps.xdp_tx += xdp_tx;
 	}
 }
@@ -4555,6 +4572,9 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_XDP_TX:
 				pp->ethtool_stats[i] = stats.ps.xdp_tx;
 				break;
+			case ETHTOOL_XDP_XMIT:
+				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
+				break;
 			}
 			break;
 		}
-- 
2.24.1

