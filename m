Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43B018BCDA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCSQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgCSQlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:49 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6CB32072D;
        Thu, 19 Mar 2020 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636108;
        bh=aMgtsiQQc43it+Bq8jY03jj3SDQ+GnOT1663DWrdvw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdjoPWQtGL7raOcpt0iltShepugqdDxuZ2BkEl+QLTYhL20J8hx3mINSV4v+qfaLd
         NuMVI5wsvpfsBGM6t/CjntZrNCw7dh51/bLOZ3OPHlnvi7oDVJaOHLa7sMB81hFpRU
         ntw4aXMj0+1Q3lpP6CSdc5FEKH2sfH5CK7L4hxPc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 2/5] veth: introduce more specialized counters in veth_stats
Date:   Thu, 19 Mar 2020 17:41:26 +0100
Message-Id: <9323381fb83fd7ca3a9d696e6d7d008f3fab321b.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_tx, xdp_redirect and rx_drops counters in veth_stats data
structure. Move stats accounting in veth_poll. Remove xdp_xmit variable
in veth_xdp_rcv_one/veth_xdp_rcv_skb and rely on veth_stats counters.
This is a preliminary patch to align veth xdp statistics to mlx, intel
and marvell xdp implementation

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 72 +++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 33e23bbde5bf..bad8fd432067 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -34,16 +34,16 @@
 #define VETH_RING_SIZE		256
 #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
 
-/* Separating two types of XDP xmit */
-#define VETH_XDP_TX		BIT(0)
-#define VETH_XDP_REDIR		BIT(1)
-
 #define VETH_XDP_TX_BULK_SIZE	16
 
 struct veth_stats {
+	u64	rx_drops;
+	/* xdp */
 	u64	xdp_packets;
 	u64	xdp_bytes;
+	u64	xdp_redirect;
 	u64	xdp_drops;
+	u64	xdp_tx;
 };
 
 struct veth_rq_stats {
@@ -493,8 +493,8 @@ static int veth_xdp_tx(struct net_device *dev, struct xdp_buff *xdp,
 
 static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct xdp_frame *frame,
-					unsigned int *xdp_xmit,
-					struct veth_xdp_tx_bq *bq)
+					struct veth_xdp_tx_bq *bq,
+					struct veth_stats *stats)
 {
 	void *hard_start = frame->data - frame->headroom;
 	void *head = hard_start - sizeof(struct xdp_frame);
@@ -530,9 +530,10 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
+				stats->rx_drops++;
 				goto err_xdp;
 			}
-			*xdp_xmit |= VETH_XDP_TX;
+			stats->xdp_tx++;
 			rcu_read_unlock();
 			goto xdp_xmit;
 		case XDP_REDIRECT:
@@ -541,9 +542,10 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			xdp.rxq->mem = frame->mem;
 			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
 				frame = &orig_frame;
+				stats->rx_drops++;
 				goto err_xdp;
 			}
-			*xdp_xmit |= VETH_XDP_REDIR;
+			stats->xdp_redirect++;
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
@@ -553,6 +555,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			trace_xdp_exception(rq->dev, xdp_prog, act);
 			/* fall through */
 		case XDP_DROP:
+			stats->xdp_drops++;
 			goto err_xdp;
 		}
 	}
@@ -562,6 +565,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	skb = veth_build_skb(head, headroom, len, 0);
 	if (!skb) {
 		xdp_return_frame(frame);
+		stats->rx_drops++;
 		goto err;
 	}
 
@@ -577,9 +581,10 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	return NULL;
 }
 
-static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
-					unsigned int *xdp_xmit,
-					struct veth_xdp_tx_bq *bq)
+static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
+					struct sk_buff *skb,
+					struct veth_xdp_tx_bq *bq,
+					struct veth_stats *stats)
 {
 	u32 pktlen, headroom, act, metalen;
 	void *orig_data, *orig_data_end;
@@ -657,18 +662,21 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 		xdp.rxq->mem = rq->xdp_mem;
 		if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
+			stats->rx_drops++;
 			goto err_xdp;
 		}
-		*xdp_xmit |= VETH_XDP_TX;
+		stats->xdp_tx++;
 		rcu_read_unlock();
 		goto xdp_xmit;
 	case XDP_REDIRECT:
 		get_page(virt_to_page(xdp.data));
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
-		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog))
+		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
+			stats->rx_drops++;
 			goto err_xdp;
-		*xdp_xmit |= VETH_XDP_REDIR;
+		}
+		stats->xdp_redirect++;
 		rcu_read_unlock();
 		goto xdp_xmit;
 	default:
@@ -678,7 +686,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 		trace_xdp_exception(rq->dev, xdp_prog, act);
 		/* fall through */
 	case XDP_DROP:
-		goto drop;
+		stats->xdp_drops++;
+		goto xdp_drop;
 	}
 	rcu_read_unlock();
 
@@ -700,6 +709,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 out:
 	return skb;
 drop:
+	stats->rx_drops++;
+xdp_drop:
 	rcu_read_unlock();
 	kfree_skb(skb);
 	return NULL;
@@ -710,14 +721,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq, struct sk_buff *skb,
 	return NULL;
 }
 
-static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit,
-			struct veth_xdp_tx_bq *bq)
+static int veth_xdp_rcv(struct veth_rq *rq, int budget,
+			struct veth_xdp_tx_bq *bq,
+			struct veth_stats *stats)
 {
-	int i, done = 0, drops = 0, bytes = 0;
+	int i, done = 0;
 
 	for (i = 0; i < budget; i++) {
 		void *ptr = __ptr_ring_consume(&rq->xdp_ring);
-		unsigned int xdp_xmit_one = 0;
 		struct sk_buff *skb;
 
 		if (!ptr)
@@ -726,27 +737,24 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget, unsigned int *xdp_xmit,
 		if (veth_is_xdp_frame(ptr)) {
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
 
-			bytes += frame->len;
-			skb = veth_xdp_rcv_one(rq, frame, &xdp_xmit_one, bq);
+			stats->xdp_bytes += frame->len;
+			skb = veth_xdp_rcv_one(rq, frame, bq, stats);
 		} else {
 			skb = ptr;
-			bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, &xdp_xmit_one, bq);
+			stats->xdp_bytes += skb->len;
+			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
 		}
-		*xdp_xmit |= xdp_xmit_one;
 
 		if (skb)
 			napi_gro_receive(&rq->xdp_napi, skb);
-		else if (!xdp_xmit_one)
-			drops++;
 
 		done++;
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
+	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
+	rq->stats.vs.xdp_drops += stats->xdp_drops + stats->rx_drops;
 	rq->stats.vs.xdp_packets += done;
-	rq->stats.vs.xdp_bytes += bytes;
-	rq->stats.vs.xdp_drops += drops;
 	u64_stats_update_end(&rq->stats.syncp);
 
 	return done;
@@ -756,14 +764,14 @@ static int veth_poll(struct napi_struct *napi, int budget)
 {
 	struct veth_rq *rq =
 		container_of(napi, struct veth_rq, xdp_napi);
-	unsigned int xdp_xmit = 0;
+	struct veth_stats stats = {};
 	struct veth_xdp_tx_bq bq;
 	int done;
 
 	bq.count = 0;
 
 	xdp_set_return_frame_no_direct();
-	done = veth_xdp_rcv(rq, budget, &xdp_xmit, &bq);
+	done = veth_xdp_rcv(rq, budget, &bq, &stats);
 
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
@@ -774,9 +782,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (xdp_xmit & VETH_XDP_TX)
+	if (stats.xdp_tx > 0)
 		veth_xdp_flush(rq->dev, &bq);
-	if (xdp_xmit & VETH_XDP_REDIR)
+	if (stats.xdp_redirect > 0)
 		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
-- 
2.25.1

