Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD29193109
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCYTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgCYTWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 15:22:30 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0945F206F6;
        Wed, 25 Mar 2020 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585164149;
        bh=JFhxtqfFJytZOH5uck3I258lBtYjfFYVYkdSodQoB3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTfP9b6y99TuFSf/20mvn4xN4XmlIy7bppmnELYUydMpKlTNm45ntb34nb1fPrr5/
         QGsEcBopVKjdMpPuJwfFtARzjH6SJmFh0Q3dDSgXcbdiMQByhjXhCOQPZ7pIeDtpct
         oPnQNOy3Lo98nK/vC0eh/HjB4UosjovYu4Fkcei0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 2/2] veth: rely on peer veth_rq for ndo_xdp_xmit accounting
Date:   Wed, 25 Mar 2020 20:22:06 +0100
Message-Id: <4d4f1772e71ba7ad67e416646f5d9357caf60a42.1585163874.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1585163874.git.lorenzo@kernel.org>
References: <cover.1585163874.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on 'remote' veth_rq to account ndo_xdp_xmit ethtool counters.
Move XDP_TX accounting to veth_xdp_flush_bq routine.
Remove 'rx' prefix in rx xdp ethool counters

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 113 +++++++++++++++++++++++++++++----------------
 1 file changed, 74 insertions(+), 39 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2041152da716..1b95ed0c6d67 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -92,17 +92,22 @@ struct veth_q_stat_desc {
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
-	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
-	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
-	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
-	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
-	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
-	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
-	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
+	{ "drops",		VETH_RQ_STAT(rx_drops) },
+	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
+	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
+	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
+	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
 };
 
 #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
 
+static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
+	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
+	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
+};
+
+#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
+
 static struct {
 	const char string[ETH_GSTRING_LEN];
 } ethtool_stats_keys[] = {
@@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				p += ETH_GSTRING_LEN;
 			}
 		}
+		for (i = 0; i < dev->real_num_tx_queues; i++) {
+			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
+				snprintf(p, ETH_GSTRING_LEN,
+					 "tx_queue_%u_%.18s",
+					 i, veth_tq_stats_desc[j].desc);
+				p += ETH_GSTRING_LEN;
+			}
+		}
 		break;
 	}
 }
@@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(ethtool_stats_keys) +
-		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
+		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
+		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 static void veth_get_ethtool_stats(struct net_device *dev,
 		struct ethtool_stats *stats, u64 *data)
 {
-	struct veth_priv *priv = netdev_priv(dev);
+	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	struct net_device *peer = rtnl_dereference(priv->peer);
 	int i, j, idx;
 
@@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
 		idx += VETH_RQ_STATS_LEN;
 	}
+
+	if (!peer)
+		return;
+
+	rcv_priv = netdev_priv(peer);
+	for (i = 0; i < peer->real_num_rx_queues; i++) {
+		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
+		const void *base = (void *)&rq_stats->vs;
+		unsigned int start, tx_idx = idx;
+		size_t offset;
+
+		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
+		do {
+			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
+				offset = veth_tq_stats_desc[j].offset;
+				data[tx_idx + j] += *(u64 *)(base + offset);
+			}
+		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+	}
 }
 
 static const struct ethtool_ops veth_ethtool_ops = {
@@ -340,8 +374,8 @@ static void veth_get_stats64(struct net_device *dev,
 	tot->tx_packets = packets;
 
 	veth_stats_rx(&rx, dev);
-	tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
-	tot->rx_dropped = rx.rx_drops;
+	tot->tx_dropped += rx.xdp_tx_err;
+	tot->rx_dropped = rx.rx_drops + rx.xdp_xmit_err;
 	tot->rx_bytes = rx.xdp_bytes;
 	tot->rx_packets = rx.xdp_packets;
 
@@ -353,7 +387,8 @@ static void veth_get_stats64(struct net_device *dev,
 		tot->rx_packets += packets;
 
 		veth_stats_rx(&rx, peer);
-		tot->rx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
+		tot->tx_dropped += rx.xdp_xmit_err;
+		tot->rx_dropped += rx.xdp_tx_err;
 		tot->tx_bytes += rx.xdp_bytes;
 		tot->tx_packets += rx.xdp_packets;
 	}
@@ -394,38 +429,28 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 			 u32 flags, bool ndo_xmit)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
-	unsigned int qidx, max_len;
+	int i, ret = -ENXIO, drops = 0;
 	struct net_device *rcv;
-	int i, ret, drops = n;
+	unsigned int max_len;
 	struct veth_rq *rq;
 
-	rcu_read_lock();
-	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
-		rcu_read_unlock();
-		atomic64_add(drops, &priv->dropped);
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
-	}
 
+	rcu_read_lock();
 	rcv = rcu_dereference(priv->peer);
-	if (unlikely(!rcv)) {
-		rcu_read_unlock();
-		atomic64_add(drops, &priv->dropped);
-		return -ENXIO;
-	}
+	if (unlikely(!rcv))
+		goto out;
 
 	rcv_priv = netdev_priv(rcv);
-	qidx = veth_select_rxq(rcv);
-	rq = &rcv_priv->rq[qidx];
+	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
 	 * side. This means an XDP program is loaded on the peer and the peer
 	 * device is up.
 	 */
-	if (!rcu_access_pointer(rq->xdp_prog)) {
-		ret = -ENXIO;
-		goto drop;
-	}
+	if (!rcu_access_pointer(rq->xdp_prog))
+		goto out;
 
-	drops = 0;
 	max_len = rcv->mtu + rcv->hard_header_len + VLAN_HLEN;
 
 	spin_lock(&rq->xdp_ring.producer_lock);
@@ -445,18 +470,14 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 		__veth_xdp_flush(rq);
 
 	ret = n - drops;
-drop:
-	rq = &priv->rq[qidx];
-	u64_stats_update_begin(&rq->stats.syncp);
 	if (ndo_xmit) {
+		u64_stats_update_begin(&rq->stats.syncp);
 		rq->stats.vs.xdp_xmit += n - drops;
 		rq->stats.vs.xdp_xmit_err += drops;
-	} else {
-		rq->stats.vs.xdp_tx += n - drops;
-		rq->stats.vs.xdp_tx_err += drops;
+		u64_stats_update_end(&rq->stats.syncp);
 	}
-	u64_stats_update_end(&rq->stats.syncp);
 
+out:
 	rcu_read_unlock();
 
 	return ret;
@@ -465,7 +486,16 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
 			     struct xdp_frame **frames, u32 flags)
 {
-	return veth_xdp_xmit(dev, n, frames, flags, true);
+	int err;
+
+	err = veth_xdp_xmit(dev, n, frames, flags, true);
+	if (err < 0) {
+		struct veth_priv *priv = netdev_priv(dev);
+
+		atomic64_add(n, &priv->dropped);
+	}
+
+	return err;
 }
 
 static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
@@ -481,6 +511,11 @@ static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	}
 	trace_xdp_bulk_tx(rq->dev, sent, bq->count - sent, err);
 
+	u64_stats_update_begin(&rq->stats.syncp);
+	rq->stats.vs.xdp_tx += sent;
+	rq->stats.vs.xdp_tx_err += bq->count - sent;
+	u64_stats_update_end(&rq->stats.syncp);
+
 	bq->count = 0;
 }
 
-- 
2.25.1

