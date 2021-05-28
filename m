Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CF43946A5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhE1Rpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhE1Rpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 13:45:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0ED960C40;
        Fri, 28 May 2021 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622223855;
        bh=dc4we71V4NXYR+WdYzLHVbYTBq8QtFZ0VZh7MZX5RA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBFaZhR7/G/XwTxmZ7kl/BUyKKWMDlTAPftdCV5BzDZNpPtqAsFat+3Tm0gJGjCaP
         nw6S0so1fg4DPVGfa9YQqmXECl5wSDxVggspswGqBcyxQCH/t9Jfw8qzX6AKd8hWkH
         gUr1nFh2i3SgstfGWNjCBu+X2IOhJrVsqY/qUtQQhwMWNpEBeWkpmODGByVSXhS15T
         awj/v9cYiZzIkAiGy8/oPr9mI+J3k0Y285Ahp9wV6foR3qQCT8KY1AVZavuzn7z0Ve
         wM7Vv+SD1oJFhTMfLQ0AIX6vn5C46BHL7A8blRqQCox8cBmZO+ZOB1YEqcga5uD3LD
         lc/fNrHU8LGbw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        dsahern@gmail.com, magnus.karlsson@intel.com, toke@redhat.com,
        brouer@redhat.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
Subject: [RFC bpf-next 3/4] net: mvneta: report csum result in xdp_buff
Date:   Fri, 28 May 2021 19:43:43 +0200
Message-Id: <d668ff3d80561af2283c4d095d2c955dddfc2dba.1622222367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622222367.git.lorenzo@kernel.org>
References: <cover.1622222367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows reusing hw rx csum offloading performing XDP_REDIRECT
from the mvneta driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 4a7c153a2666..95a51c2efa63 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2263,6 +2263,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
+	xdp->flags = mvneta_rx_csum(pp, rx_desc->status);
 
 	sinfo = xdp_get_shared_info_from_buff(xdp);
 	sinfo->nr_frags = 0;
@@ -2317,7 +2318,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 
 static struct sk_buff *
 mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
-		      struct xdp_buff *xdp, u32 desc_status)
+		      struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	int i, num_frags = sinfo->nr_frags;
@@ -2331,7 +2332,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
-	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
+	xdp_buff_get_csum(xdp, skb);
 
 	for (i = 0; i < num_frags; i++) {
 		skb_frag_t *frag = &sinfo->frags[i];
@@ -2355,8 +2356,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	struct skb_shared_info sinfo;
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
-	u32 desc_status, frame_sz;
 	struct xdp_buff xdp_buf;
+	u32 frame_sz;
 
 	xdp_init_buff(&xdp_buf, PAGE_SIZE, &rxq->xdp_rxq);
 	xdp_buf.data_hard_start = NULL;
@@ -2392,7 +2393,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 
 			size = rx_desc->data_size;
 			frame_sz = size - ETH_FCS_LEN;
-			desc_status = rx_status;
 
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
@@ -2421,7 +2421,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
 
-		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
+		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
-- 
2.31.1

