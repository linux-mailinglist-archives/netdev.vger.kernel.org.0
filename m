Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC8D18BCDC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgCSQly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgCSQlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:53 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6B42072D;
        Thu, 19 Mar 2020 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636113;
        bh=JDcArIjhwfvXkpLGDHltgyMjCJBnYEAE7m3soZVKqlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvnFIU5nRJIawkSrbgbv2KvYSucRYNCqrYFoiOHzlJJd7PkMX3bViTLZEyk8jNRsV
         OFWTA1SyDpRwdv+F3O/Tf0mPKt2ehsp2v6RhMS2Tr/jzBN7Vm+dmHN1y6iG4yAIJlS
         3NYUL2+Qjb+ACURizMgGm2+8Iocogst8RwF4vpqo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 4/5] veth: introduce more xdp counters
Date:   Thu, 19 Mar 2020 17:41:28 +0100
Message-Id: <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_xmit counter in order to distinguish between XDP_TX and
ndo_xdp_xmit stats. Introduce the following ethtool counters:
- rx_xdp_tx
- rx_xdp_tx_errors
- tx_xdp_xmit
- tx_xdp_xmit_errors
- rx_xdp_redirect

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2307696d4897..093b55acedb1 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -44,6 +44,9 @@ struct veth_stats {
 	u64	xdp_redirect;
 	u64	xdp_drops;
 	u64	xdp_tx;
+	u64	xdp_tx_err;
+	u64	xdp_xmit;
+	u64	xdp_xmit_err;
 };
 
 struct veth_rq_stats {
@@ -89,8 +92,13 @@ struct veth_q_stat_desc {
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
-	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
 	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
+	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
+	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
+	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
+	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
+	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
+	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
 };
 
 #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
@@ -129,7 +137,7 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
 			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
 				snprintf(p, ETH_GSTRING_LEN,
-					 "rx_queue_%u_%.11s",
+					 "rx_queue_%u_%.18s",
 					 i, veth_rq_stats_desc[j].desc);
 				p += ETH_GSTRING_LEN;
 			}
@@ -374,12 +382,13 @@ static int veth_select_rxq(struct net_device *dev)
 }
 
 static int veth_xdp_xmit(struct net_device *dev, int n,
-			 struct xdp_frame **frames, u32 flags)
+			 struct xdp_frame **frames,
+			 u32 flags, bool ndo_xmit)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
+	unsigned int qidx, max_len;
 	struct net_device *rcv;
 	int i, ret, drops = n;
-	unsigned int max_len;
 	struct veth_rq *rq;
 
 	rcu_read_lock();
@@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	}
 
 	rcv_priv = netdev_priv(rcv);
-	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
+	qidx = veth_select_rxq(rcv);
+	rq = &rcv_priv->rq[qidx];
 	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
 	 * side. This means an XDP program is loaded on the peer and the peer
 	 * device is up.
@@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	if (flags & XDP_XMIT_FLUSH)
 		__veth_xdp_flush(rq);
 
+	rq = &priv->rq[qidx];
+	u64_stats_update_begin(&rq->stats.syncp);
+	if (ndo_xmit) {
+		rq->stats.vs.xdp_xmit += n - drops;
+		rq->stats.vs.xdp_xmit_err += drops;
+	} else {
+		rq->stats.vs.xdp_tx += n - drops;
+		rq->stats.vs.xdp_tx_err += drops;
+	}
+	u64_stats_update_end(&rq->stats.syncp);
+
 	if (likely(!drops)) {
 		rcu_read_unlock();
 		return n;
@@ -437,11 +458,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	return ret;
 }
 
+static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
+			     struct xdp_frame **frames, u32 flags)
+{
+	return veth_xdp_xmit(dev, n, frames, flags, true);
+}
+
 static void veth_xdp_flush_bq(struct net_device *dev, struct veth_xdp_tx_bq *bq)
 {
 	int sent, i, err = 0;
 
-	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
+	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0, false);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
@@ -753,6 +780,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
+	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
 	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
 	rq->stats.vs.xdp_drops += stats->xdp_drops;
 	rq->stats.vs.rx_drops += stats->rx_drops;
@@ -1172,7 +1200,7 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_set_rx_headroom	= veth_set_rx_headroom,
 	.ndo_bpf		= veth_xdp,
-	.ndo_xdp_xmit		= veth_xdp_xmit,
+	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-- 
2.25.1

