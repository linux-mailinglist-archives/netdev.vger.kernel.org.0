Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB7438B7D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJXSpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJXSpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 14:45:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C2AC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t9-20020a63b249000000b002993d73be40so5059192pgo.4
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VIj2ODZ0bpI5gGkgy3drc6T9n9xMV/rtrNJ7de5dGpI=;
        b=CZcuPbk50e5w4+tWDtyLZKjd1Z9Uik2AVMjFVF6V+1pa4l7a9a2iJZhloULrYPHsRo
         iFNjaGUquLB3q5QptFgWBfJlNHqTAyzKhf+7k2Dx8H5nRnclp1PWwn77I8h2Xn2rJuUz
         nzZ5f5pJH7WNPP7QtRINnPvj7i9lHehvGuJCRdXWC+RCnD5HVmP+n8EZxqDn5ytt5gkV
         4fhQAKeOJ7h6WCRPHbI4zNg0ZAW+9BcWiRJkD+TacbJag9eADiRIJZGEg1F1F+sOMSxq
         iGmJZNdmfbu9gkbJ7SxU62gYaPVtcE9ZNvpS/ThXJH/lBfQkc+Gx2ncDQ8rPfmw0hglw
         ndcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VIj2ODZ0bpI5gGkgy3drc6T9n9xMV/rtrNJ7de5dGpI=;
        b=7bHYCGwbb6Ckj9jSi1faX2Pf+CCyWarAF/VmGYbuyjND36Uz6lAdQdxXywlbmgAOxP
         X7OMa5qYAxJug3YsCxqysn3aXzbagAB+7d3EJ+AjToyTVXruO3xr8K6lKMoVqw2UztM0
         WJK9FfCn9DzgYm63Z7bmyMo8G3QB8LQJd8INZ21APYU2hVGZRcz64VR2tQoMFR2PgxWa
         pq9fxAj9uE+5PC+3P8yUg1N5ysac7WMGcNwAZB1Cyu2brEFI86tTsf+zq9PuzLmvjpQg
         hxdAUH1STbRXYOxIV8nYxq0it3Jks63Em4Z/Xsv/BavseBfg5VgGnZzpbgbEYf4qMOYM
         YCxA==
X-Gm-Message-State: AOAM531tyGp7DAOHKlVvIxtgtcfcny3R3K3OqWNjS73W5yfd/+fosifi
        gbImOI4XFbIVAnJZOW93w4AFk6Bvy+s63NBHhxvH8bkNHfoqs85xwnBtk2FKLP9qeSuYfzfpkm3
        o5aK3ZSA34ffV5u+V/77CM+Z/Dn9F6gJqKiqh+Q8eqmxyPkGWqtbedkmcoMxVo4SlJso=
X-Google-Smtp-Source: ABdhPJx89qfZwJ1aCNTK9KAAuIy+TOeakmkEBaYR7o93ehvCb8qIl4rIH4tDvG3xRUnxfTigaTRPOYW8R+jQRA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:e3d1:fd04:4781:9855])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:1829:b0:44d:df1f:5624 with SMTP
 id y41-20020a056a00182900b0044ddf1f5624mr13578321pfa.27.1635100974032; Sun,
 24 Oct 2021 11:42:54 -0700 (PDT)
Date:   Sun, 24 Oct 2021 11:42:36 -0700
In-Reply-To: <20211024184238.409589-1-jeroendb@google.com>
Message-Id: <20211024184238.409589-2-jeroendb@google.com>
Mime-Version: 1.0
References: <20211024184238.409589-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH net-next 1/3] gve: Add RX context.
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>

This refactor moves the skb_head and skb_tail fields into a new
gve_rx_ctx struct. This new struct will contain information about the
current packet being processed. This is in preparation for
multi-descriptor RX packets.

Signed-off-by: David Awogbemila <awogbemila@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        | 13 +++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 68 ++++++++++----------
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 51ed8fe71d2d..03ef8e039065 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -142,6 +142,15 @@ struct gve_index_list {
 	s16 tail;
 };
 
+/* A single received packet split across multiple buffers may be
+ * reconstructed using the information in this structure.
+ */
+struct gve_rx_ctx {
+	/* head and tail of skb chain for the current packet or NULL if none */
+	struct sk_buff *skb_head;
+	struct sk_buff *skb_tail;
+};
+
 /* Contains datapath state used to represent an RX queue. */
 struct gve_rx_ring {
 	struct gve_priv *gve;
@@ -206,9 +215,7 @@ struct gve_rx_ring {
 	dma_addr_t q_resources_bus; /* dma address for the queue resources */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
 
-	/* head and tail of skb chain for the current packet or NULL if none */
-	struct sk_buff *skb_head;
-	struct sk_buff *skb_tail;
+	struct gve_rx_ctx ctx; /* Info for packet currently being processed in this ring. */
 };
 
 /* A TX desc ring entry */
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8500621b2cd4..9765c92a5c29 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -240,8 +240,8 @@ static int gve_rx_alloc_ring_dqo(struct gve_priv *priv, int idx)
 	rx->dqo.bufq.mask = buffer_queue_slots - 1;
 	rx->dqo.complq.num_free_slots = completion_queue_slots;
 	rx->dqo.complq.mask = completion_queue_slots - 1;
-	rx->skb_head = NULL;
-	rx->skb_tail = NULL;
+	rx->ctx.skb_head = NULL;
+	rx->ctx.skb_tail = NULL;
 
 	rx->dqo.num_buf_states = min_t(s16, S16_MAX, buffer_queue_slots * 4);
 	rx->dqo.buf_states = kvcalloc(rx->dqo.num_buf_states,
@@ -467,12 +467,12 @@ static void gve_rx_skb_hash(struct sk_buff *skb,
 
 static void gve_rx_free_skb(struct gve_rx_ring *rx)
 {
-	if (!rx->skb_head)
+	if (!rx->ctx.skb_head)
 		return;
 
-	dev_kfree_skb_any(rx->skb_head);
-	rx->skb_head = NULL;
-	rx->skb_tail = NULL;
+	dev_kfree_skb_any(rx->ctx.skb_head);
+	rx->ctx.skb_head = NULL;
+	rx->ctx.skb_tail = NULL;
 }
 
 /* Chains multi skbs for single rx packet.
@@ -483,7 +483,7 @@ static int gve_rx_append_frags(struct napi_struct *napi,
 			       u16 buf_len, struct gve_rx_ring *rx,
 			       struct gve_priv *priv)
 {
-	int num_frags = skb_shinfo(rx->skb_tail)->nr_frags;
+	int num_frags = skb_shinfo(rx->ctx.skb_tail)->nr_frags;
 
 	if (unlikely(num_frags == MAX_SKB_FRAGS)) {
 		struct sk_buff *skb;
@@ -492,17 +492,17 @@ static int gve_rx_append_frags(struct napi_struct *napi,
 		if (!skb)
 			return -1;
 
-		skb_shinfo(rx->skb_tail)->frag_list = skb;
-		rx->skb_tail = skb;
+		skb_shinfo(rx->ctx.skb_tail)->frag_list = skb;
+		rx->ctx.skb_tail = skb;
 		num_frags = 0;
 	}
-	if (rx->skb_tail != rx->skb_head) {
-		rx->skb_head->len += buf_len;
-		rx->skb_head->data_len += buf_len;
-		rx->skb_head->truesize += priv->data_buffer_size_dqo;
+	if (rx->ctx.skb_tail != rx->ctx.skb_head) {
+		rx->ctx.skb_head->len += buf_len;
+		rx->ctx.skb_head->data_len += buf_len;
+		rx->ctx.skb_head->truesize += priv->data_buffer_size_dqo;
 	}
 
-	skb_add_rx_frag(rx->skb_tail, num_frags,
+	skb_add_rx_frag(rx->ctx.skb_tail, num_frags,
 			buf_state->page_info.page,
 			buf_state->page_info.page_offset,
 			buf_len, priv->data_buffer_size_dqo);
@@ -556,7 +556,7 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 				      buf_len, DMA_FROM_DEVICE);
 
 	/* Append to current skb if one exists. */
-	if (rx->skb_head) {
+	if (rx->ctx.skb_head) {
 		if (unlikely(gve_rx_append_frags(napi, buf_state, buf_len, rx,
 						 priv)) != 0) {
 			goto error;
@@ -567,11 +567,11 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 	}
 
 	if (eop && buf_len <= priv->rx_copybreak) {
-		rx->skb_head = gve_rx_copy(priv->dev, napi,
-					   &buf_state->page_info, buf_len, 0);
-		if (unlikely(!rx->skb_head))
+		rx->ctx.skb_head = gve_rx_copy(priv->dev, napi,
+					       &buf_state->page_info, buf_len, 0);
+		if (unlikely(!rx->ctx.skb_head))
 			goto error;
-		rx->skb_tail = rx->skb_head;
+		rx->ctx.skb_tail = rx->ctx.skb_head;
 
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_copied_pkt++;
@@ -583,12 +583,12 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 		return 0;
 	}
 
-	rx->skb_head = napi_get_frags(napi);
-	if (unlikely(!rx->skb_head))
+	rx->ctx.skb_head = napi_get_frags(napi);
+	if (unlikely(!rx->ctx.skb_head))
 		goto error;
-	rx->skb_tail = rx->skb_head;
+	rx->ctx.skb_tail = rx->ctx.skb_head;
 
-	skb_add_rx_frag(rx->skb_head, 0, buf_state->page_info.page,
+	skb_add_rx_frag(rx->ctx.skb_head, 0, buf_state->page_info.page,
 			buf_state->page_info.page_offset, buf_len,
 			priv->data_buffer_size_dqo);
 	gve_dec_pagecnt_bias(&buf_state->page_info);
@@ -635,27 +635,27 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 		rx->gve->ptype_lut_dqo->ptypes[desc->packet_type];
 	int err;
 
-	skb_record_rx_queue(rx->skb_head, rx->q_num);
+	skb_record_rx_queue(rx->ctx.skb_head, rx->q_num);
 
 	if (feat & NETIF_F_RXHASH)
-		gve_rx_skb_hash(rx->skb_head, desc, ptype);
+		gve_rx_skb_hash(rx->ctx.skb_head, desc, ptype);
 
 	if (feat & NETIF_F_RXCSUM)
-		gve_rx_skb_csum(rx->skb_head, desc, ptype);
+		gve_rx_skb_csum(rx->ctx.skb_head, desc, ptype);
 
 	/* RSC packets must set gso_size otherwise the TCP stack will complain
 	 * that packets are larger than MTU.
 	 */
 	if (desc->rsc) {
-		err = gve_rx_complete_rsc(rx->skb_head, desc, ptype);
+		err = gve_rx_complete_rsc(rx->ctx.skb_head, desc, ptype);
 		if (err < 0)
 			return err;
 	}
 
-	if (skb_headlen(rx->skb_head) == 0)
+	if (skb_headlen(rx->ctx.skb_head) == 0)
 		napi_gro_frags(napi);
 	else
-		napi_gro_receive(napi, rx->skb_head);
+		napi_gro_receive(napi, rx->ctx.skb_head);
 
 	return 0;
 }
@@ -717,18 +717,18 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 		/* Free running counter of completed descriptors */
 		rx->cnt++;
 
-		if (!rx->skb_head)
+		if (!rx->ctx.skb_head)
 			continue;
 
 		if (!compl_desc->end_of_packet)
 			continue;
 
 		work_done++;
-		pkt_bytes = rx->skb_head->len;
+		pkt_bytes = rx->ctx.skb_head->len;
 		/* The ethernet header (first ETH_HLEN bytes) is snipped off
 		 * by eth_type_trans.
 		 */
-		if (skb_headlen(rx->skb_head))
+		if (skb_headlen(rx->ctx.skb_head))
 			pkt_bytes += ETH_HLEN;
 
 		/* gve_rx_complete_skb() will consume skb if successful */
@@ -741,8 +741,8 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 		}
 
 		bytes += pkt_bytes;
-		rx->skb_head = NULL;
-		rx->skb_tail = NULL;
+		rx->ctx.skb_head = NULL;
+		rx->ctx.skb_tail = NULL;
 	}
 
 	gve_rx_post_buffers_dqo(rx);
-- 
2.33.0.1079.g6e70778dc9-goog

