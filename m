Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03C0308FC4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhA2WFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhA2WFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 17:05:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2938364DDB;
        Fri, 29 Jan 2021 22:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957855;
        bh=m3biG8PI/jKfwgFC5WC3EpEhJsNzvntmfxnzlkkDGns=;
        h=From:To:Cc:Subject:Date:From;
        b=QL/i993FejutmywW/Z35FllWk1eW0lM3O9ynbXkrZY7k3d8DC3kUgBVJlrM9e6Py8
         w5aqcElVONUtFDdA8atrVmj8Q+Qx09q3bGw9Q2StVjh0clCcF0kl47L3Q+MaQGKZFa
         DAhxZdikdwUJnrJqNzjrNCKB3e0NJlSl2u10LDX57nyQl07l6KFBfGhrJKSHiwAlRD
         aWDXfYwDgFvKpTgodZczLcHPwvU3bwHm37BFFU9slfst9cDM+7XQgeW38rNRmB26Rg
         N0Ovgk5T9gSwwSPx/oS645hNIYeTwAuQDqhYdTvym04jEcVB+9v0a4ysBKKNOunm+r
         w2TWuWG1NwtFg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
Date:   Fri, 29 Jan 2021 23:04:08 +0100
Message-Id: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
in order to alloc skbs in bulk for XDP_PASS verdict.
Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
The proposed approach has been tested in the following scenario:

eth (ixgbe) --> XDP_REDIRECT --> veth0 --> (remote-ns) veth1 --> XDP_PASS

XDP_REDIRECT: xdp_redirect_map bpf sample
XDP_PASS: xdp_rxq_info bpf sample

traffic generator: pkt_gen sending udp traffic on a remote device

bpf-next master: ~3.64Mpps
bpf-next + skb bulking allocation: ~3.79Mpps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v2:
- use __GFP_ZERO flag instead of memset
- move some veth_xdp_rcv_batch() logic in veth_xdp_rcv_skb()

Changes since v1:
- drop patch 2/3, squash patch 1/3 and 3/3
- set VETH_XDP_BATCH to 16
- rework veth_xdp_rcv to use __ptr_ring_consume
---
 drivers/net/veth.c | 78 ++++++++++++++++++++++++++++++++++------------
 include/net/xdp.h  |  1 +
 net/core/xdp.c     | 11 +++++++
 3 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6e03b619c93c..aa1a66ad2ce5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -35,6 +35,7 @@
 #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
 
 #define VETH_XDP_TX_BULK_SIZE	16
+#define VETH_XDP_BATCH		16
 
 struct veth_stats {
 	u64	rx_drops;
@@ -562,14 +563,13 @@ static int veth_xdp_tx(struct veth_rq *rq, struct xdp_buff *xdp,
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
@@ -623,13 +623,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
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
@@ -637,6 +631,37 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	return NULL;
 }
 
+/* frames array contains VETH_XDP_BATCH at most */
+static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
+				  int n_xdpf, struct veth_xdp_tx_bq *bq,
+				  struct veth_stats *stats)
+{
+	void *skbs[VETH_XDP_BATCH];
+	int i;
+
+	if (xdp_alloc_skb_bulk(skbs, n_xdpf,
+			       GFP_ATOMIC | __GFP_ZERO) < 0) {
+		for (i = 0; i < n_xdpf; i++)
+			xdp_return_frame(frames[i]);
+		stats->rx_drops += n_xdpf;
+
+		return;
+	}
+
+	for (i = 0; i < n_xdpf; i++) {
+		struct sk_buff *skb = skbs[i];
+
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
@@ -784,32 +809,45 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			struct veth_xdp_tx_bq *bq,
 			struct veth_stats *stats)
 {
-	int i, done = 0;
+	int i, done = 0, n_xdpf = 0;
+	void *xdpf[VETH_XDP_BATCH];
 
 	for (i = 0; i < budget; i++) {
 		void *ptr = __ptr_ring_consume(&rq->xdp_ring);
-		struct sk_buff *skb;
 
 		if (!ptr)
 			break;
 
 		if (veth_is_xdp_frame(ptr)) {
+			/* ndo_xdp_xmit */
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
 
 			stats->xdp_bytes += frame->len;
-			skb = veth_xdp_rcv_one(rq, frame, bq, stats);
+			frame = veth_xdp_rcv_one(rq, frame, bq, stats);
+			if (frame) {
+				/* XDP_PASS */
+				xdpf[n_xdpf++] = frame;
+				if (n_xdpf == VETH_XDP_BATCH) {
+					veth_xdp_rcv_bulk_skb(rq, xdpf, n_xdpf,
+							      bq, stats);
+					n_xdpf = 0;
+				}
+			}
 		} else {
-			skb = ptr;
+			/* ndo_start_xmit */
+			struct sk_buff *skb = ptr;
+
 			stats->xdp_bytes += skb->len;
 			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			if (skb)
+				napi_gro_receive(&rq->xdp_napi, skb);
 		}
-
-		if (skb)
-			napi_gro_receive(&rq->xdp_napi, skb);
-
 		done++;
 	}
 
+	if (n_xdpf)
+		veth_xdp_rcv_bulk_skb(rq, xdpf, n_xdpf, bq, stats);
+
 	u64_stats_update_begin(&rq->stats.syncp);
 	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
 	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index c4bfdc9a8b79..a5bc214a49d9 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -169,6 +169,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
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

