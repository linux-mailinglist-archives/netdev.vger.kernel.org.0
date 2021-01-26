Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF29B304D48
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732152AbhAZXIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392337AbhAZSnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 13:43:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 565B622B2C;
        Tue, 26 Jan 2021 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611686554;
        bh=3qZm5K7ckbIxfNAVqBBI1SIMJgLLh/X7TkQMazS543I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmKLROO+6Q7ZXwFt2T+RKDugU96U4aItAoGg0OvXefdKqg+r5wL4lY79l9YB2iJDE
         aIVuEQ4dTY6JrIvC/aRGi/POhX2Sb3me7zc7IOSEmeXimUaxhCee/u+NmT6STM1MM5
         lx/ZbNQ7PLZobNWGJd+znSZjCNjdXpA9Mardw5FkSbQyYvJ/pT8haaDelLDnUI3gjq
         fgcmfkLBSK2MRym8I/SFmEHZ/QQSOKlv89BFaqU5yu1oN1RYqiMLJkQHr6MCJ6S0hZ
         uzKgQwyQuKp2BRWEUaM51YKdcxsYEfnzEiT8VE25jSheXsj2KNS+op0RgkZ4u16cy1
         RvNYdehwbaYAw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: [PATCH bpf-next 3/3] net: veth: alloc skb in bulk for ndo_xdp_xmit
Date:   Tue, 26 Jan 2021 19:42:01 +0100
Message-Id: <efff40b98b311f6c8de4e98f247a84aa587b8936.1611685778.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611685778.git.lorenzo@kernel.org>
References: <cover.1611685778.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
in order to alloc skbs in bulk for XDP_PASS verdict.
Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 96 ++++++++++++++++++++++++++++++++--------------
 include/net/xdp.h  |  1 +
 net/core/xdp.c     | 11 ++++++
 3 files changed, 79 insertions(+), 29 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ff77b541e5fc..3464f4c7844b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -563,14 +563,13 @@ static int veth_xdp_tx(struct veth_rq *rq, struct xdp_buff *xdp,
 	return 0;
 }
 
-static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
-					struct xdp_frame *frame,
-					struct veth_xdp_tx_bq *bq,
-					struct veth_stats *stats)
+static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
+					  struct xdp_frame *frame,
+					  struct veth_xdp_tx_bq *bq,
+					  struct veth_stats *stats)
 {
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
-	struct sk_buff *skb;
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
@@ -624,13 +623,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	}
 	rcu_read_unlock();
 
-	skb = xdp_build_skb_from_frame(frame, rq->dev);
-	if (!skb) {
-		xdp_return_frame(frame);
-		stats->rx_drops++;
-	}
-
-	return skb;
+	return frame;
 err_xdp:
 	rcu_read_unlock();
 	xdp_return_frame(frame);
@@ -638,6 +631,48 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	return NULL;
 }
 
+static void veth_xdp_rcv_batch(struct veth_rq *rq, void **frames,
+			       int n_xdpf, struct veth_xdp_tx_bq *bq,
+			       struct veth_stats *stats)
+{
+	void *skbs[XDP_BATCH_SIZE];
+	int i, n_skb = 0;
+
+	for (i = 0; i < n_xdpf; i++) {
+		struct xdp_frame *frame = frames[i];
+
+		stats->xdp_bytes += frame->len;
+		frame = veth_xdp_rcv_one(rq, frame, bq, stats);
+		if (frame)
+			frames[n_skb++] = frame;
+	}
+
+	if (!n_skb)
+		return;
+
+	if (xdp_alloc_skb_bulk(skbs, n_skb, GFP_ATOMIC) < 0) {
+		for (i = 0; i < n_skb; i++) {
+			xdp_return_frame(frames[i]);
+			stats->rx_drops++;
+		}
+		return;
+	}
+
+	for (i = 0; i < n_skb; i++) {
+		struct sk_buff *skb = skbs[i];
+
+		memset(skb, 0, offsetof(struct sk_buff, tail));
+		skb = __xdp_build_skb_from_frame(frames[i], skb,
+						 rq->dev);
+		if (!skb) {
+			xdp_return_frame(frames[i]);
+			stats->rx_drops++;
+			continue;
+		}
+		napi_gro_receive(&rq->xdp_napi, skb);
+	}
+}
+
 static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 					struct sk_buff *skb,
 					struct veth_xdp_tx_bq *bq,
@@ -788,9 +823,10 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	int i, done = 0;
 
 	for (i = 0; i < budget; i++) {
+		int i, n_frame, n_xdpf = 0, n_skb = 0;
 		void *frames[VETH_XDP_BATCH];
 		void *skbs[VETH_XDP_BATCH];
-		int i, n_frame, n_skb = 0;
+		void *xdpf[VETH_XDP_BATCH];
 
 		n_frame = __ptr_ring_consume_batched(&rq->xdp_ring, frames,
 						     XDP_BATCH_SIZE);
@@ -798,24 +834,26 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			break;
 
 		for (i = 0; i < n_frame; i++) {
-			void *f = frames[i];
-			struct sk_buff *skb;
-
-			if (veth_is_xdp_frame(f)) {
-				struct xdp_frame *frame = veth_ptr_to_xdp(f);
-
-				stats->xdp_bytes += frame->len;
-				skb = veth_xdp_rcv_one(rq, frame, bq, stats);
-			} else {
-				skb = f;
-				stats->xdp_bytes += skb->len;
-				skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
-			}
+			if (veth_is_xdp_frame(frames[i]))
+				xdpf[n_xdpf++] = veth_ptr_to_xdp(frames[i]);
+			else
+				skbs[n_skb++] = frames[i];
+		}
+
+		/* ndo_xdp_xmit */
+		if (n_xdpf)
+			veth_xdp_rcv_batch(rq, xdpf, n_xdpf, bq, stats);
+
+		/* ndo_start_xmit */
+		for (i = 0; i < n_skb; i++) {
+			struct sk_buff *skb = skbs[i];
+
+			stats->xdp_bytes += skb->len;
+			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
 			if (skb)
-				skbs[n_skb++] = skb;
+				napi_gro_receive(&rq->xdp_napi, skb);
 		}
-		for (i = 0; i < n_skb; i++)
-			napi_gro_receive(&rq->xdp_napi, skbs[i]);
+
 		done += n_frame;
 	}
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index c0e15bcb3a22..e8db521f5323 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -170,6 +170,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct net_device *dev);
 struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					 struct net_device *dev);
+int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp);
 
 static inline
 void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 0d2630a35c3e..05354976c1fc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -514,6 +514,17 @@ void xdp_warn(const char *msg, const char *func, const int line)
 };
 EXPORT_SYMBOL_GPL(xdp_warn);
 
+int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp)
+{
+	n_skb = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
+				      n_skb, skbs);
+	if (unlikely(!n_skb))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xdp_alloc_skb_bulk);
+
 struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev)
-- 
2.29.2

