Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390072F38D9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392628AbhALS1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392380AbhALS1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 13:27:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E137123121;
        Tue, 12 Jan 2021 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610475990;
        bh=Szh6saMLxdZWpYRkTzFvafxw2ceyvrSm3aOiwAK0tA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjuMUsC+9VdyuYcMSNo5T+RUMFJ85LkMZ8N+j4eDbW3Uue9RCSfKMRmTxDkxx8FJC
         bjUP28hZXC2HHZpHcN7yqOAV4vEcTxaxOJv0s/R/+1tbP8Ud1eel4K2URJq0dQ2ar+
         Ms7X15p9+QE5mhCuUp0P/w7H/10Ypql+jK8xOE7iXUtjcfuj0GQSJvIQ65vukHHWzE
         UALh0ghOiJ/3qlKXrGwrNHCVdt5b/eB30vH/nCO8nh/ak01Nlb1cScWRLoT3rpO5uZ
         GkylwG4yNTBslLD6QbSOOb10dxslE38JJ0RueYe5pa+RsGxaiqM2hL9+Nlyt+U4dKG
         oclAACERusBAw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com
Subject: [PATCH v2 bpf-next 2/2] net: xdp: introduce xdp_build_skb_from_frame utility routine
Date:   Tue, 12 Jan 2021 19:26:13 +0100
Message-Id: <94ade9e853162ae1947941965193190da97457bc.1610475660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610475660.git.lorenzo@kernel.org>
References: <cover.1610475660.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_build_skb_from_frame utility routine to build the skb
from xdp_frame. Respect to __xdp_build_skb_from_frame,
xdp_build_skb_from_frame will allocate the skb object. Rely on
xdp_build_skb_from_frame in veth driver.
Introduce missing xdp metadata support in veth_xdp_rcv_one routine.
Add missing metadata support in veth_xdp_rcv_one().

Reviewed-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 18 +++---------------
 include/net/xdp.h  |  2 ++
 net/core/xdp.c     | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 99caae7d1641..6e03b619c93c 100644
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
index 689206dee6de..c4bfdc9a8b79 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -167,6 +167,8 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
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

