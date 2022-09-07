Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6D95B090C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiIGPqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiIGPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9149A82762
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQkFLDjoyFYBBnPe05h3hhYJQzwJrKql3Np1KjDu3/w=;
        b=XnjbzR/GMrf8EpWBF51QOw6wL2nv1GUn/JRvCpobCLtMUv2Z5c+E/Phmar/d7IRXgiyruY
        jl3dA/0OMRush1xbIjEf4pO00W6NBbr0sc79J1rJmXB4ktv+JheRH62qtyYQbG1n1pi0sb
        MPleh9A9SsDbOJt5i9jR4Dewpl5UYIc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-Fyr_K0d3Oyaoqn-ZWrtPjA-1; Wed, 07 Sep 2022 11:46:03 -0400
X-MC-Unique: Fyr_K0d3Oyaoqn-ZWrtPjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4B7B85A58D;
        Wed,  7 Sep 2022 15:46:02 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 556BD4010E4D;
        Wed,  7 Sep 2022 15:46:02 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 51EE930721A6C;
        Wed,  7 Sep 2022 17:46:01 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 12/18] net: use XDP-hints in xdp_frame to SKB
 conversion
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:46:01 +0200
Message-ID: <166256556130.1434226.10426110144984671774.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the net/core/xdp function __xdp_build_skb_from_frame()
consume HW offloads provided via XDP-hints when creating an SKB based
on an xdp_frame. This is an initial step towards SKB less drivers that
moves SKB handing to net/core.

Current users that already benefit from this are: Redirect into veth
and cpumap. XDP_PASS action in bpf_test_run_xdp_live and driver
ethernet/aquantia/atlantic/.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |   17 ++++++++-----
 2 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index c7cdcef83fa5..bdb497c7b296 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -153,6 +153,68 @@ static __always_inline u32 xdp_hints_set_vlan(struct xdp_hints_common *hints,
 	return flags;
 }
 
+/* XDP hints to SKB helper functions */
+static inline void xdp_hint2skb_record_rx_queue(struct sk_buff *skb,
+						struct xdp_hints_common *hints)
+{
+	if (hints->xdp_hints_flags & HINT_FLAG_RX_QUEUE)
+		skb_record_rx_queue(skb, hints->rx_queue);
+}
+
+static inline void xdp_hint2skb_set_hash(struct sk_buff *skb,
+					 struct xdp_hints_common *hints)
+{
+	u32 hash_type = hints->xdp_hints_flags & HINT_FLAG_RX_HASH_TYPE_MASK;
+
+	if (hash_type) {
+		hash_type = hash_type >> HINT_FLAG_RX_HASH_TYPE_SHIFT;
+		skb_set_hash(skb, hints->rx_hash32, hash_type);
+	}
+}
+
+static inline void xdp_hint2skb_checksum(struct sk_buff *skb,
+					 struct xdp_hints_common *hints)
+{
+	u32 csum_type = hints->xdp_hints_flags & HINT_FLAG_CSUM_TYPE_MASK;
+	u32 csum_level = hints->xdp_hints_flags & HINT_FLAG_CSUM_LEVEL_MASK;
+
+	if (csum_type == CHECKSUM_UNNECESSARY)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	if (csum_level)
+		skb->csum_level = csum_level >> HINT_FLAG_CSUM_LEVEL_SHIFT;
+
+	/* TODO: First driver implementing CHECKSUM_PARTIAL or CHECKSUM_COMPLETE
+	 *  need to implement handling here.
+	 */
+}
+
+static inline void xdp_hint2skb_vlan_hw_tag(struct sk_buff *skb,
+					    struct xdp_hints_common *hints)
+{
+	u32 flags = hints->xdp_hints_flags;
+	__be16 proto = htons(ETH_P_8021Q);
+
+	if (flags & HINT_FLAG_VLAN_PROTO_ETH_P_8021AD)
+		proto = htons(ETH_P_8021AD);
+
+	if (flags & HINT_FLAG_VLAN_PRESENT) {
+		/* like: __vlan_hwaccel_put_tag */
+		skb->vlan_proto = proto;
+		skb->vlan_tci = hints->vlan_tci;
+		skb->vlan_present = 1;
+	}
+}
+
+static inline void xdp_hint2skb(struct sk_buff *skb,
+				struct xdp_hints_common *hints)
+{
+	xdp_hint2skb_record_rx_queue(skb, hints);
+	xdp_hint2skb_set_hash(skb, hints);
+	xdp_hint2skb_checksum(skb, hints);
+	xdp_hint2skb_vlan_hw_tag(skb, hints);
+}
+
 /**
  * DOC: XDP RX-queue information
  *
@@ -364,6 +426,16 @@ static __always_inline bool xdp_frame_is_frag_pfmemalloc(struct xdp_frame *frame
 	return !!(frame->flags & XDP_FLAGS_FRAGS_PF_MEMALLOC);
 }
 
+static __always_inline bool xdp_frame_has_hints_compat(struct xdp_frame *xdpf)
+{
+	u32 flags = xdpf->flags;
+
+	if (!(flags & XDP_FLAGS_HINTS_COMPAT_COMMON))
+		return false;
+
+	return !!(flags & XDP_FLAGS_HINTS_MASK);
+}
+
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index a57bd5278b47..ffa353367941 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -623,6 +623,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct net_device *dev)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	struct xdp_hints_common *xdp_hints = NULL;
 	unsigned int headroom, frame_size;
 	void *hard_start;
 	u8 nr_frags;
@@ -640,14 +641,17 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	frame_size = xdpf->frame_sz;
 
 	hard_start = xdpf->data - headroom;
+	prefetch(xdpf->data); /* cache-line for eth_type_trans */
 	skb = build_skb_around(skb, hard_start, frame_size);
 	if (unlikely(!skb))
 		return NULL;
 
 	skb_reserve(skb, headroom);
 	__skb_put(skb, xdpf->len);
-	if (xdpf->metasize)
+	if (xdpf->metasize) {
 		skb_metadata_set(skb, xdpf->metasize);
+		prefetch(xdpf->data - sizeof(*xdp_hints));
+	}
 
 	if (unlikely(xdp_frame_has_frags(xdpf)))
 		xdp_update_skb_shared_info(skb, nr_frags,
@@ -658,11 +662,12 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
-	 * - HW RX hash			(skb_set_hash)
-	 * - RX ring dev queue index	(skb_record_rx_queue)
-	 */
+	/* Populate (optional) HW offload hints in SKB via XDP-hints */
+	if (xdp_frame_has_hints_compat(xdpf)
+	    && xdpf->metasize >= sizeof(*xdp_hints)) {
+		xdp_hints = xdpf->data - sizeof(*xdp_hints);
+		xdp_hint2skb(skb, xdp_hints);
+	}
 
 	/* Until page_pool get SKB return path, release DMA here */
 	xdp_release_frame(xdpf);


