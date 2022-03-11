Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0564D5E21
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346172AbiCKJQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345646AbiCKJQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4941BB73A;
        Fri, 11 Mar 2022 01:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A16C61F2A;
        Fri, 11 Mar 2022 09:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA37C340F3;
        Fri, 11 Mar 2022 09:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646990106;
        bh=HCCSiwwusuPFDujvRRxiAqoFYDqBp1+SqwDe+Bwssw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3M+p0MJZXZQK0gbKYwLsoz0v4XUrCAlkeHhXe6nno3ZBCPDKJV+ZykWTF2tmDI5J
         zn8oSk7Fdl1+q1qE9IM1IlQDJIQ7kWYl+bSF1xZG4azhutachgP9kZGRj8gLDV2lkT
         za1kATzZKiq2dAO1X0ZitxqjuTvavqneves+5PzcdwTi4D+girEjuA8rnYx/gXpbhF
         7iMBHB77Gl++iqscUP2pzjN5O8wu6YKm6ZMiT+uuoowsPSb2s0fKiJVtYCzcVETV3I
         A6iqA5Hk/J53Dc2q9MM2BvYSZwfvraiIf/WjLhEPADNzQfg/zynwiUip+6tsQ3xOuF
         +dDqPWQTK827g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v5 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
Date:   Fri, 11 Mar 2022 10:14:19 +0100
Message-Id: <8d228b106bc1903571afd1d77e797bffe9a5ea7c.1646989407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce veth_convert_skb_to_xdp_buff routine in order to
convert a non-linear skb into a xdp buffer. If the received skb
is cloned or shared, veth_convert_skb_to_xdp_buff will copy it
in a new skb composed by order-0 pages for the linear and the
fragmented area. Moreover veth_convert_skb_to_xdp_buff guarantees
we have enough headroom for xdp.
This is a preliminary patch to allow attaching xdp programs with frags
support on veth devices.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 177 +++++++++++++++++++++++++++++++--------------
 net/core/xdp.c     |   1 +
 2 files changed, 122 insertions(+), 56 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b77ce3fdcfe8..bfae15ec902b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -433,21 +433,6 @@ static void veth_set_multicast_list(struct net_device *dev)
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
@@ -695,72 +680,143 @@ static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
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
+static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
+					struct xdp_buff *xdp,
+					struct sk_buff **pskb)
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
+	if (veth_convert_skb_to_xdp_buff(rq, &xdp, &skb))
+		goto drop;
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
@@ -771,7 +827,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		get_page(virt_to_page(xdp.data));
+		veth_xdp_get(&xdp);
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
 		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
@@ -783,7 +839,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		rcu_read_unlock();
 		goto xdp_xmit;
 	case XDP_REDIRECT:
-		get_page(virt_to_page(xdp.data));
+		veth_xdp_get(&xdp);
 		consume_skb(skb);
 		xdp.rxq->mem = rq->xdp_mem;
 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
@@ -806,18 +862,27 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
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
+	/* XDP frag metadata (e.g. nr_frags) are updated in eBPF helpers
+	 * (e.g. bpf_xdp_adjust_tail), we need to update data_len here.
+	 */
+	if (xdp_buff_has_frags(&xdp))
+		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
+	else
+		skb->data_len = 0;
+
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
 	metalen = xdp.data - xdp.data_meta;
@@ -833,7 +898,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
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

