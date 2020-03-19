Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8F18BCDD
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgCSQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgCSQl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:56 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A28F2070A;
        Thu, 19 Mar 2020 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636115;
        bh=8VgabHfLg2BEwFMOhzTZQsIhzbvrgOmG2oyDVFVIP8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXq6bNlb6RhP35bZyQaE7subMsb3ZxS5bTlBdeOl4S6sNu+eUgYdt1+JtvkjTn5MF
         kDVYuQg+3FV0VM9tT4qka/y2QfA8R/I2a9MRfRpoDgtxD2/GsWUjXgVymtxTFlg7/B
         /+J6lkec7VVM+xc++98aHDxWKFEsWDh1X0d6AyXU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 5/5] veth: remove atomic64_add from veth_xdp_xmit hotpath
Date:   Thu, 19 Mar 2020 17:41:29 +0100
Message-Id: <9d2d67d96de5609947d40cbd358ccf2f167f0814.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove atomic64_add from veth_xdp_xmit hotpath and rely on
xdp_xmit_err/xdp_tx_err counters

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 093b55acedb1..b6505a6c7102 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -301,20 +301,26 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
+	result->xdp_xmit_err = 0;
 	result->xdp_packets = 0;
+	result->xdp_tx_err = 0;
 	result->xdp_bytes = 0;
 	result->rx_drops = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
+		u64 packets, bytes, drops, xdp_tx_err, xdp_xmit_err;
 		struct veth_rq_stats *stats = &priv->rq[i].stats;
-		u64 packets, bytes, drops;
 		unsigned int start;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			xdp_xmit_err = stats->vs.xdp_xmit_err;
+			xdp_tx_err = stats->vs.xdp_tx_err;
 			packets = stats->vs.xdp_packets;
 			bytes = stats->vs.xdp_bytes;
 			drops = stats->vs.rx_drops;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		result->xdp_xmit_err += xdp_xmit_err;
+		result->xdp_tx_err += xdp_tx_err;
 		result->xdp_packets += packets;
 		result->xdp_bytes += bytes;
 		result->rx_drops += drops;
@@ -334,6 +340,7 @@ static void veth_get_stats64(struct net_device *dev,
 	tot->tx_packets = packets;
 
 	veth_stats_rx(&rx, dev);
+	tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
 	tot->rx_dropped = rx.rx_drops;
 	tot->rx_bytes = rx.xdp_bytes;
 	tot->rx_packets = rx.xdp_packets;
@@ -346,6 +353,7 @@ static void veth_get_stats64(struct net_device *dev,
 		tot->rx_packets += packets;
 
 		veth_stats_rx(&rx, peer);
+		tot->rx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
 		tot->tx_bytes += rx.xdp_bytes;
 		tot->tx_packets += rx.xdp_packets;
 	}
@@ -393,14 +401,16 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 
 	rcu_read_lock();
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
-		ret = -EINVAL;
-		goto drop;
+		rcu_read_unlock();
+		atomic64_add(drops, &priv->dropped);
+		return -EINVAL;
 	}
 
 	rcv = rcu_dereference(priv->peer);
 	if (unlikely(!rcv)) {
-		ret = -ENXIO;
-		goto drop;
+		rcu_read_unlock();
+		atomic64_add(drops, &priv->dropped);
+		return -ENXIO;
 	}
 
 	rcv_priv = netdev_priv(rcv);
@@ -434,6 +444,8 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	if (flags & XDP_XMIT_FLUSH)
 		__veth_xdp_flush(rq);
 
+	ret = n - drops;
+drop:
 	rq = &priv->rq[qidx];
 	u64_stats_update_begin(&rq->stats.syncp);
 	if (ndo_xmit) {
@@ -445,15 +457,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	}
 	u64_stats_update_end(&rq->stats.syncp);
 
-	if (likely(!drops)) {
-		rcu_read_unlock();
-		return n;
-	}
-
-	ret = n - drops;
-drop:
 	rcu_read_unlock();
-	atomic64_add(drops, &priv->dropped);
 
 	return ret;
 }
-- 
2.25.1

