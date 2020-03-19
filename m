Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D8718BCD9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgCSQlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbgCSQlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:46 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EFC2070A;
        Thu, 19 Mar 2020 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636105;
        bh=76u++2q/GyB2M+joyZVYolc+Pl5tCMWkdxdBfK/4pTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neOSPbjw7s35q/6BKm9cpB7DSe6y/dG2tBZ1P1owh6dytCkVSo2E4r7JL93cSt5TL
         Bd81fK4cio11OqCd3Qqx5alvkUDRlbjInaO1Q3HdXD7AKUEp08QQLXpv6agOx73/Zp
         gXciq+ncobnp72DBb0hFtbk2cc7nHYsFb8oyDhP4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 1/5] veth: move xdp stats in a dedicated structure
Date:   Thu, 19 Mar 2020 17:41:25 +0100
Message-Id: <9c81737737f863171c97d3debbfc2258711bbcc0.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move xdp stats in veth_stats data structure. This is a preliminary patch
to align xdp statistics to mlx5, ixgbe and mvneta drivers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d4cbb9e8c63f..33e23bbde5bf 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -40,10 +40,14 @@
 
 #define VETH_XDP_TX_BULK_SIZE	16
 
+struct veth_stats {
+	u64	xdp_packets;
+	u64	xdp_bytes;
+	u64	xdp_drops;
+};
+
 struct veth_rq_stats {
-	u64			xdp_packets;
-	u64			xdp_bytes;
-	u64			xdp_drops;
+	struct veth_stats	vs;
 	struct u64_stats_sync	syncp;
 };
 
@@ -80,7 +84,7 @@ struct veth_q_stat_desc {
 	size_t	offset;
 };
 
-#define VETH_RQ_STAT(m)	offsetof(struct veth_rq_stats, m)
+#define VETH_RQ_STAT(m)	offsetof(struct veth_stats, m)
 
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
@@ -155,7 +159,7 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 	idx = 1;
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
 		const struct veth_rq_stats *rq_stats = &priv->rq[i].stats;
-		const void *stats_base = (void *)rq_stats;
+		const void *stats_base = (void *)&rq_stats->vs;
 		unsigned int start;
 		size_t offset;
 
@@ -283,7 +287,7 @@ static u64 veth_stats_tx(struct net_device *dev, u64 *packets, u64 *bytes)
 	return atomic64_read(&priv->dropped);
 }
 
-static void veth_stats_rx(struct veth_rq_stats *result, struct net_device *dev)
+static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
@@ -298,9 +302,9 @@ static void veth_stats_rx(struct veth_rq_stats *result, struct net_device *dev)
 
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->xdp_packets;
-			bytes = stats->xdp_bytes;
-			drops = stats->xdp_drops;
+			packets = stats->vs.xdp_packets;
+			bytes = stats->vs.xdp_bytes;
+			drops = stats->vs.xdp_drops;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 		result->xdp_packets += packets;
 		result->xdp_bytes += bytes;
@@ -313,7 +317,7 @@ static void veth_get_stats64(struct net_device *dev,
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
-	struct veth_rq_stats rx;
+	struct veth_stats rx;
 	u64 packets, bytes;
 
 	tot->tx_dropped = veth_stats_tx(dev, &packets, &bytes);
@@ -740,9 +744,9 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit,
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
-	rq->stats.xdp_packets += done;
-	rq->stats.xdp_bytes += bytes;
-	rq->stats.xdp_drops += drops;
+	rq->stats.vs.xdp_packets += done;
+	rq->stats.vs.xdp_bytes += bytes;
+	rq->stats.vs.xdp_drops += drops;
 	u64_stats_update_end(&rq->stats.syncp);
 
 	return done;
-- 
2.25.1

