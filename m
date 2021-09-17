Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3396A40F454
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 10:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbhIQIqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 04:46:36 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:59897 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233688AbhIQIqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 04:46:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uofyx2P_1631868310;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uofyx2P_1631868310)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 17 Sep 2021 16:45:10 +0800
From:   tonylu_linux <tonylu@linux.alibaba.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH] virtio_net: introduce TX timeout watchdog
Date:   Fri, 17 Sep 2021 16:40:06 +0800
Message-Id: <20210917084004.44332-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tony.ly@linux.alibaba.com>

This implements ndo_tx_timeout handler and put this into stats. When
there is something wrong to send out packets, we could notice tx timeout
events and total timeout counter.

We have suffered send timeout issues due to the backends hung. With this,
we can find the details, and collect the counters by monitor systems.

Signed-off-by: Tony Lu <tony.ly@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 271d38c1d9f8..90fed0fdc40f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -80,6 +80,7 @@ struct virtnet_sq_stats {
 	u64 xdp_tx;
 	u64 xdp_tx_drops;
 	u64 kicks;
+	u64 tx_timeouts;
 };
 
 struct virtnet_rq_stats {
@@ -103,6 +104,7 @@ static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "xdp_tx",		VIRTNET_SQ_STAT(xdp_tx) },
 	{ "xdp_tx_drops",	VIRTNET_SQ_STAT(xdp_tx_drops) },
 	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
+	{ "tx_timeouts",	VIRTNET_SQ_STAT(tx_timeouts) },
 };
 
 static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
@@ -1856,7 +1858,7 @@ static void virtnet_stats(struct net_device *dev,
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		u64 tpackets, tbytes, rpackets, rbytes, rdrops;
+		u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
 		struct receive_queue *rq = &vi->rq[i];
 		struct send_queue *sq = &vi->sq[i];
 
@@ -1864,6 +1866,7 @@ static void virtnet_stats(struct net_device *dev,
 			start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
 			tpackets = sq->stats.packets;
 			tbytes   = sq->stats.bytes;
+			terrors  = sq->stats.tx_timeouts;
 		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
 
 		do {
@@ -1878,6 +1881,7 @@ static void virtnet_stats(struct net_device *dev,
 		tot->rx_bytes   += rbytes;
 		tot->tx_bytes   += tbytes;
 		tot->rx_dropped += rdrops;
+		tot->tx_errors  += terrors;
 	}
 
 	tot->tx_dropped = dev->stats.tx_dropped;
@@ -2659,6 +2663,21 @@ static int virtnet_set_features(struct net_device *dev,
 	return 0;
 }
 
+static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
+{
+	struct virtnet_info *priv = netdev_priv(dev);
+	struct send_queue *sq = &priv->sq[txqueue];
+	struct netdev_queue *txq = netdev_get_tx_queue(dev, txqueue);
+
+	u64_stats_update_begin(&sq->stats.syncp);
+	sq->stats.tx_timeouts++;
+	u64_stats_update_end(&sq->stats.syncp);
+
+	netdev_err(dev, "TX timeout on queue: %u, sq: %s, vq: 0x%x, name: %s, %u usecs ago\n",
+		   txqueue, sq->name, sq->vq->index, sq->vq->name,
+		   jiffies_to_usecs(jiffies - txq->trans_start));
+}
+
 static const struct net_device_ops virtnet_netdev = {
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
@@ -2674,6 +2693,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_tx_timeout		= virtnet_tx_timeout,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
-- 
2.19.1.6.gb485710b

