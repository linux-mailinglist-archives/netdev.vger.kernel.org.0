Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B0D304D45
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 00:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbhAZXHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390982AbhAZSnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 13:43:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7EF722286;
        Tue, 26 Jan 2021 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611686548;
        bh=xsSQgyzTplv0SsBJ7NkFDqsTUF/LqUhSoDlzv91qAGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqQRbYeKnONLeoUsAfdvhonLK3yPnIFrpW8jfK8cRiAy48sYd1eSN1wV+7voMPl4q
         DloUid1zmJnuRwIgSblReW+WI04Bp9u3egFisht/RNFregjA1mzrz5TuTbGZbpMibe
         P3RSVSNaT24h9/is/CbQSxW7CoTUoEG8yy4++G0mjvwU/315SOcgsfXqAQzOGTzxij
         us9e13N1oAD8uDdJk8s0Q35HMdydwz0Kpv6bvD0E2kkMBMwautf2sKp0HlZOLoibkQ
         cwTqdOLuVhWLxtQ2dNV+5KJ8Mm53bmFbvtTs8K5RAF8MMdDZk6Pz+n8nWi1H68tamy
         1khU1Q1wG5fVA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: [PATCH bpf-next 1/3] net: veth: introduce bulking for XDP_PASS
Date:   Tue, 26 Jan 2021 19:41:59 +0100
Message-Id: <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611685778.git.lorenzo@kernel.org>
References: <cover.1611685778.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bulking support for XDP_PASS verdict forwarding skbs to
the networking stack

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6e03b619c93c..23137d9966da 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -35,6 +35,7 @@
 #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
 
 #define VETH_XDP_TX_BULK_SIZE	16
+#define VETH_XDP_BATCH		8
 
 struct veth_stats {
 	u64	rx_drops;
@@ -787,27 +788,35 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	int i, done = 0;
 
 	for (i = 0; i < budget; i++) {
-		void *ptr = __ptr_ring_consume(&rq->xdp_ring);
-		struct sk_buff *skb;
+		void *frames[VETH_XDP_BATCH];
+		void *skbs[VETH_XDP_BATCH];
+		int i, n_frame, n_skb = 0;
 
-		if (!ptr)
+		n_frame = __ptr_ring_consume_batched(&rq->xdp_ring, frames,
+						     VETH_XDP_BATCH);
+		if (!n_frame)
 			break;
 
-		if (veth_is_xdp_frame(ptr)) {
-			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
+		for (i = 0; i < n_frame; i++) {
+			void *f = frames[i];
+			struct sk_buff *skb;
 
-			stats->xdp_bytes += frame->len;
-			skb = veth_xdp_rcv_one(rq, frame, bq, stats);
-		} else {
-			skb = ptr;
-			stats->xdp_bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
-		}
-
-		if (skb)
-			napi_gro_receive(&rq->xdp_napi, skb);
+			if (veth_is_xdp_frame(f)) {
+				struct xdp_frame *frame = veth_ptr_to_xdp(f);
 
-		done++;
+				stats->xdp_bytes += frame->len;
+				skb = veth_xdp_rcv_one(rq, frame, bq, stats);
+			} else {
+				skb = f;
+				stats->xdp_bytes += skb->len;
+				skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			}
+			if (skb)
+				skbs[n_skb++] = skb;
+		}
+		for (i = 0; i < n_skb; i++)
+			napi_gro_receive(&rq->xdp_napi, skbs[i]);
+		done += n_frame;
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
@@ -818,7 +827,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 	rq->stats.vs.xdp_packets += done;
 	u64_stats_update_end(&rq->stats.syncp);
 
-	return done;
+	return i;
 }
 
 static int veth_poll(struct napi_struct *napi, int budget)
-- 
2.29.2

