Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518BD2BB12B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgKTRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgKTRGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:06:20 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AA72240B;
        Fri, 20 Nov 2020 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605891979;
        bh=9XCqAiXAevArfrajvpC72jyXrSmmo6xHkuituXKHelc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIFl/NcIKkxBLif+U40Ls0eh94ZYzHDQLmaY7WYPqSlMwO0zUeYhiAR9K4VkZirqc
         nriQqVKf4liyX0JqWIJ7Gj0a47t2k+djAnWD70P7KJmU4aCxDS09XVSq6rc4KdYd9Y
         NA1JKcFOWCosAQy7KEMoJ7XA2P3d9LdcTK4XbRQo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com
Subject: [PATCH net-next 2/3] net: mvneta: move skb_shared_info in mvneta_xdp_put_buff caller
Date:   Fri, 20 Nov 2020 18:05:43 +0100
Message-Id: <c8e87ff62b37abdd79e213aa001c549802c4752a.1605889259.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605889258.git.lorenzo@kernel.org>
References: <cover.1605889258.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass skb_shared_info pointer from mvneta_xdp_put_buff caller. This is a
preliminary patch to reduce accesses to skb_shared_info area and reduce
cache misses.
Remove napi parameter in mvneta_xdp_put_buff signature since it is always
run in NAPI context

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 32 ++++++++++++++++++---------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 60a285f3a55f..17c446b1cb94 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2033,16 +2033,16 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
 
 static void
 mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
-		    struct xdp_buff *xdp, int sync_len, bool napi)
+		    struct xdp_buff *xdp, struct skb_shared_info *sinfo,
+		    int sync_len)
 {
-	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i;
 
 	for (i = 0; i < sinfo->nr_frags; i++)
 		page_pool_put_full_page(rxq->page_pool,
-					skb_frag_page(&sinfo->frags[i]), napi);
+					skb_frag_page(&sinfo->frags[i]), true);
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
-			   sync_len, napi);
+			   sync_len, true);
 }
 
 static int
@@ -2179,6 +2179,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp,
 	       u32 frame_sz, struct mvneta_stats *stats)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	unsigned int len, data_len, sync;
 	u32 ret, act;
 
@@ -2199,7 +2200,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (unlikely(err)) {
-			mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
+			mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
 			ret = MVNETA_XDP_DROPPED;
 		} else {
 			ret = MVNETA_XDP_REDIR;
@@ -2210,7 +2211,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
 		if (ret != MVNETA_XDP_TX)
-			mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
+			mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2219,7 +2220,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-		mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
+		mvneta_xdp_put_buff(pp, rxq, xdp, sinfo, sync);
 		ret = MVNETA_XDP_DROPPED;
 		stats->xdp_drop++;
 		break;
@@ -2406,7 +2407,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			continue;
 
 		if (size) {
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+			struct skb_shared_info *sinfo;
+
+			sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
 			goto next;
 		}
 
@@ -2417,8 +2421,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+			struct skb_shared_info *sinfo;
 
-			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+			sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
+			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
 
 			u64_stats_update_begin(&stats->syncp);
 			stats->es.skb_alloc_error++;
@@ -2438,8 +2444,12 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	}
 	rcu_read_unlock();
 
-	if (xdp_buf.data_hard_start)
-		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, -1, true);
+	if (xdp_buf.data_hard_start) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(&xdp_buf);
+		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, sinfo, -1);
+	}
 
 	if (ps.xdp_redirect)
 		xdp_do_flush_map();
-- 
2.26.2

