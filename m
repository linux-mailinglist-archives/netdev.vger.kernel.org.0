Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA902DC724
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388770AbgLPTdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388753AbgLPTdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:03 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com
Subject: [PATCH bpf-next 2/2] net: xdp: introduce xdp_build_skb_from_frame utility routine
Date:   Wed, 16 Dec 2020 19:38:34 +0100
Message-Id: <9d24e4c90c91aa2d9de413ee38adc4e8e44fc81a.1608142960.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1608142960.git.lorenzo@kernel.org>
References: <cover.1608142960.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_build_skb_from_frame utility routine to build the skb
from xdp_frame. Respect to __xdp_build_skb_from_frame,
xdp_build_skb_from_frame will allocate the skb object. Rely on
xdp_build_skb_from_frame in veth driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 18 +++---------------
 include/net/xdp.h  |  2 ++
 net/core/xdp.c     | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 02bfcdf50a7a..dbacf90df2b5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -567,16 +567,10 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct veth_xdp_tx_bq *bq,
 					struct veth_stats *stats)
 {
-	void *hard_start = frame->data - frame->headroom;
-	int len = frame->len, delta = 0;
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
-	unsigned int headroom;
 	struct sk_buff *skb;
 
-	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
-	hard_start -= sizeof(struct xdp_frame);
-
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
@@ -590,8 +584,8 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 
 		switch (act) {
 		case XDP_PASS:
-			delta = frame->data - xdp.data;
-			len = xdp.data_end - xdp.data;
+			if (xdp_update_frame_from_buff(&xdp, frame))
+				goto err_xdp;
 			break;
 		case XDP_TX:
 			orig_frame = *frame;
@@ -629,18 +623,12 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	}
 	rcu_read_unlock();
 
-	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb = veth_build_skb(hard_start, headroom, len, frame->frame_sz);
+	skb = xdp_build_skb_from_frame(frame, rq->dev);
 	if (!skb) {
 		xdp_return_frame(frame);
 		stats->rx_drops++;
-		goto err;
 	}
 
-	xdp_release_frame(frame);
-	xdp_scrub_frame(frame);
-	skb->protocol = eth_type_trans(skb, rq->dev);
-err:
 	return skb;
 err_xdp:
 	rcu_read_unlock();
diff --git a/include/net/xdp.h b/include/net/xdp.h
index da62fa20fa8a..11ec93f827c0 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -148,6 +148,8 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev);
+struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					 struct net_device *dev);
 
 static inline
 void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index aeb09ed0704c..0d2630a35c3e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -557,3 +557,18 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	return skb;
 }
 EXPORT_SYMBOL_GPL(__xdp_build_skb_from_frame);
+
+struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					 struct net_device *dev)
+{
+	struct sk_buff *skb;
+
+	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return NULL;
+
+	memset(skb, 0, offsetof(struct sk_buff, tail));
+
+	return __xdp_build_skb_from_frame(xdpf, skb, dev);
+}
+EXPORT_SYMBOL_GPL(xdp_build_skb_from_frame);
-- 
2.29.2

