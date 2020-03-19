Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B53118BCDB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgCSQlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgCSQlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:51 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DA62070A;
        Thu, 19 Mar 2020 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636110;
        bh=xrI/ea9M6RAPFMH64NL5kONdcqhFNlldITx1hwTjPkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u9512V+B2qjjNfYtrgf3+t7W5JdN5FwScHEbj6yMGFJe+01Zj7+uLZIWunwIvSb3
         LGTnKbKeGOTqUQqQsz51E0cO89DEnauQ3MnZDA/AyCzcUKAiT/0VbnvDBdLcJm7wMX
         6BMJOJEx25klnIIoeLteXMl0WnBAq0gsDIT9A0TE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 3/5] veth: distinguish between rx_drops and xdp_drops
Date:   Thu, 19 Mar 2020 17:41:27 +0100
Message-Id: <4ab2cf4ede80a42fb6cd9e2309f645857ed09c74.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Distinguish between rx_drops and xdp_drops since the latter is already
reported in rx_packets. Report xdp_drops in ethtool statistics

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bad8fd432067..2307696d4897 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -90,6 +90,7 @@ static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
 	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
+	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
 };
 
 #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
@@ -294,7 +295,7 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 
 	result->xdp_packets = 0;
 	result->xdp_bytes = 0;
-	result->xdp_drops = 0;
+	result->rx_drops = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
 		struct veth_rq_stats *stats = &priv->rq[i].stats;
 		u64 packets, bytes, drops;
@@ -304,11 +305,11 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			packets = stats->vs.xdp_packets;
 			bytes = stats->vs.xdp_bytes;
-			drops = stats->vs.xdp_drops;
+			drops = stats->vs.rx_drops;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 		result->xdp_packets += packets;
 		result->xdp_bytes += bytes;
-		result->xdp_drops += drops;
+		result->rx_drops += drops;
 	}
 }
 
@@ -325,7 +326,7 @@ static void veth_get_stats64(struct net_device *dev,
 	tot->tx_packets = packets;
 
 	veth_stats_rx(&rx, dev);
-	tot->rx_dropped = rx.xdp_drops;
+	tot->rx_dropped = rx.rx_drops;
 	tot->rx_bytes = rx.xdp_bytes;
 	tot->rx_packets = rx.xdp_packets;
 
@@ -753,7 +754,8 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 
 	u64_stats_update_begin(&rq->stats.syncp);
 	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
-	rq->stats.vs.xdp_drops += stats->xdp_drops + stats->rx_drops;
+	rq->stats.vs.xdp_drops += stats->xdp_drops;
+	rq->stats.vs.rx_drops += stats->rx_drops;
 	rq->stats.vs.xdp_packets += done;
 	u64_stats_update_end(&rq->stats.syncp);
 
-- 
2.25.1

