Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525A74B6D0F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiBONJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:09:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238118AbiBONI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:08:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6FFC3330;
        Tue, 15 Feb 2022 05:08:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099AF61701;
        Tue, 15 Feb 2022 13:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B000BC340ED;
        Tue, 15 Feb 2022 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644930525;
        bh=jidf4B6XhyhuQjIGG9zoHGkIzBsp0ip8NDKaG7trYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWukVwupFG21Ef/F3je9iHot/gdEMFpnc4QIU7ZR6+U1dZtXii8OLBgBcQe28EB4z
         nAQYEdsgo+VikvEuRRhjw7ULGc1YPiE64FdwGekO0eyO6PnVGkdbiSeplNWkbZbDAK
         C/aRkYDdMEwhRUS0NbexPSnRt4OJ74ffVle4vHGhLwBx806Rn6D5KSjTiUD7cbBYpX
         VqAOTaUSn25RvKXG1MYibiLFsk1IRhNdgQgEPU5VNYT4RBtOcnihu/LpjMzAAX7LtL
         eTxJnOQ0N4dFOhyvSkYZ+EnsppIn13R+V34Xoqs3r5L9Aw89J8jghdEmnw/p3qsNry
         ahuB5lnZWKXiQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v2 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
Date:   Tue, 15 Feb 2022 14:08:10 +0100
Message-Id: <fee8f5a61f1fb03119c510e79800875fc27b7486.1644930125.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644930124.git.lorenzo@kernel.org>
References: <cover.1644930124.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce veth_convert_xdp_buff_from_skb routine in order to
convert a non-linear skb into a xdp buffer. If the received skb
is cloned or shared, veth_convert_xdp_buff_from_skb will copy it
in a new skb composed by order-0 pages for the linear and the
fragmented area. Moreover veth_convert_xdp_buff_from_skb guarantees
we have enough headroom for xdp.
This is a preliminary patch to allow attaching xdp programs with frags
support on veth devices.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 174 ++++++++++++++++++++++++++++++---------------
 net/core/xdp.c     |   1 +
 2 files changed, 119 insertions(+), 56 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 22ecaf8b8f98..a45aaaecc21f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -432,21 +432,6 @@ static void veth_set_multicast_list(struct net_device *dev)
 {
 }
 
-static struct sk_buff *veth_build_skb(void *head, int headroom, int len,
-				      int buflen)
-{
-	struct sk_buff *skb;
-
-	skb = build_skb(head, buflen);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, headroom);
-	skb_put(skb, len);
-
-	return skb;
-}
-
 static int veth_select_rxq(struct net_device *dev)
 {
 	return smp_processor_id() % dev->real_num_rx_queues;
@@ -694,72 +679,143 @@ static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
 	}
 }
 
-static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
-					struct sk_buff *skb,
-					struct veth_xdp_tx_bq *bq,
-					struct veth_stats *stats)
+static void veth_xdp_get(struct xdp_buff *xdp)
 {
-	u32 pktlen, headroom, act, metalen, frame_sz;
-	void *orig_data, *orig_data_end;
-	struct bpf_prog *xdp_prog;
-	int mac_len, delta, off;
-	struct xdp_buff xdp;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int i;
 
-	skb_prepare_for_gro(skb);
+	get_page(virt_to_page(xdp->data));
+	if (likely(!xdp_buff_has_frags(xdp)))
+		return;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
-	if (unlikely(!xdp_prog)) {
-		rcu_read_unlock();
-		goto out;
-	}
+	for (i = 0; i < sinfo->nr_frags; i++)
+		__skb_frag_ref(&sinfo->frags[i]);
+}
 
-	mac_len = skb->data - skb_mac_header(skb);
-	pktlen = skb->len + mac_len;
-	headroom = skb_headroom(skb) - mac_len;
+static int veth_convert_xdp_buff_from_skb(struct veth_rq *rq,
+					  struct xdp_buff *xdp,
+					  struct sk_buff **pskb)
+{
+	struct sk_buff *skb = *pskb;
+	u32 frame_sz;
 
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
-	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
+	    skb_shinfo(skb)->nr_frags) {
+		u32 size, len, max_head_size, off;
 		struct sk_buff *nskb;
-		int size, head_off;
-		void *head, *start;
 		struct page *page;
+		int i, head_off;
 
-		size = SKB_DATA_ALIGN(VETH_XDP_HEADROOM + pktlen) +
-		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		if (size > PAGE_SIZE)
+		/* We need a private copy of the skb and data buffers since
+		 * the ebpf program can modify it. We segment the original skb
+		 * into order-0 pages without linearize it.
+		 *
+		 * Make sure we have enough space for linear and paged area
+		 */
+		max_head_size = SKB_WITH_OVERHEAD(PAGE_SIZE -
+						  VETH_XDP_HEADROOM);
+		if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
 			goto drop;
 
+		/* Allocate skb head */
 		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
 		if (!page)
 			goto drop;
 
-		head = page_address(page);
-		start = head + VETH_XDP_HEADROOM;
-		if (skb_copy_bits(skb, -mac_len, start, pktlen)) {
-			page_frag_free(head);
+		nskb = build_skb(page_address(page), PAGE_SIZE);
+		if (!nskb) {
+			put_page(page);
 			goto drop;
 		}
 
-		nskb = veth_build_skb(head, VETH_XDP_HEADROOM + mac_len,
-				      skb->len, PAGE_SIZE);
-		if (!nskb) {
-			page_frag_free(head);
+		skb_reserve(nskb, VETH_XDP_HEADROOM);
+		size = min_t(u32, skb->len, max_head_size);
+		if (skb_copy_bits(skb, 0, nskb->data, size)) {
+			consume_skb(nskb);
 			goto drop;
 		}
+		skb_put(nskb, size);
 
 		skb_copy_header(nskb, skb);
 		head_off = skb_headroom(nskb) - skb_headroom(skb);
 		skb_headers_offset_update(nskb, head_off);
+
+		/* Allocate paged area of new skb */
+		off = size;
+		len = skb->len - off;
+
+		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
+			page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+			if (!page) {
+				consume_skb(nskb);
+				goto drop;
+			}
+
+			size = min_t(u32, len, PAGE_SIZE);
+			skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
+			if (skb_copy_bits(skb, off, page_address(page),
+					  size)) {
+				consume_skb(nskb);
+				goto drop;
+			}
+
+			len -= size;
+			off += size;
+		}
+
 		consume_skb(skb);
 		skb = nskb;
+	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
+		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
+		goto drop;
 	}
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	frame_sz = skb_end_pointer(skb) - skb->head;
 	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
-	xdp_prepare_buff(&xdp, skb->head, skb->mac_header, pktlen, true);
+	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
+			 skb_headlen(skb), true);
+
+	if (skb_is_nonlinear(skb)) {
+		skb_shinfo(skb)->xdp_frags_size = skb->data_len;
+		xdp_buff_set_frags_flag(xdp);
+	} else {
+		xdp_buff_clear_frags_flag(xdp);
+	}
+	*pskb = skb;
+
+	return 0;
+drop:
+	consume_skb(skb);
+	*pskb = NULL;
+
+	return -ENOMEM;
+}
+
+static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
+					struct sk_buff *skb,
+					struct veth_xdp_tx_bq *bq,
+					struct veth_stats *stats)
+{
+	void *orig_data, *orig_data_end;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 act, metalen;
+	int off;
+
+	skb_prepare_for_gro(skb);
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (unlikely(!xdp_prog)) {
+		rcu_read_unlock();
+		goto out;
+	}
+
+	__skb_push(skb, skb->data - skb_mac_header(skb));
+	if (veth_convert_xdp_buff_from_skb(rq, &xdp, &skb))
+		goto drop;
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
@@ -770,7 +826,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		get_page(virt_to_page(xdp.data));
+		veth_xdp_get(&xdp);
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
 		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
@@ -782,7 +838,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		rcu_read_unlock();
 		goto xdp_xmit;
 	case XDP_REDIRECT:
-		get_page(virt_to_page(xdp.data));
+		veth_xdp_get(&xdp);
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
@@ -805,18 +861,24 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	/* check if bpf_xdp_adjust_head was used */
-	delta = orig_data - xdp.data;
-	off = mac_len + delta;
+	off = orig_data - xdp.data;
 	if (off > 0)
 		__skb_push(skb, off);
 	else if (off < 0)
 		__skb_pull(skb, -off);
-	skb->mac_header -= delta;
+
+	skb_reset_mac_header(skb);
 
 	/* check if bpf_xdp_adjust_tail was used */
 	off = xdp.data_end - orig_data_end;
 	if (off != 0)
 		__skb_put(skb, off); /* positive on grow, negative on shrink */
+
+	if (xdp_buff_has_frags(&xdp))
+		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
+	else
+		skb->data_len = 0;
+
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
 	metalen = xdp.data - xdp.data_meta;
@@ -832,7 +894,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	return NULL;
 err_xdp:
 	rcu_read_unlock();
-	page_frag_free(xdp.data);
+	xdp_return_buff(&xdp);
 xdp_xmit:
 	return NULL;
 }
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 361df312ee7f..b5f2d428d856 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -528,6 +528,7 @@ void xdp_return_buff(struct xdp_buff *xdp)
 out:
 	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp);
 }
+EXPORT_SYMBOL_GPL(xdp_return_buff);
 
 /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
 void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
-- 
2.35.1

