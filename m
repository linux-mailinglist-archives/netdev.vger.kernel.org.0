Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E1B4517D1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbhKOWq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351046AbhKOWio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:38:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9BEF61AAA;
        Mon, 15 Nov 2021 22:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015649;
        bh=E9WE0yczLyhNGK9QtzeDC71awa6w1/0Jo/71/FNommA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQpb09teupB+pQaOiKlVD2ZHzMUavgvfK2ahcmMqHTor9jfBVtK8hq0I3U5D5JKEl
         m4YtvvVxlMFL56DwmFvPjOV4eiJJhLLXx/74+DEqGtw1wiWKnDDbZvBPKEmSYJSNn8
         5ujRY2JRtO63TD/nqX0A4k+j2x0qdnkCzu+vo6qpx6SW8LIdSXrbc1H7ZR7tq93Iys
         YrjImBGYldCwZExgn7L+BoVab6YxWCbUFxuTbsH6wmOXVDSz+PQi3+Us/UoXhcTQUa
         sLuh56tE6ml66vyuDF0ZOoFBDCSuvnUh92UwSO3yYehqiIGmJUf/i0RIEZHNyXzFt3
         Vgr/LpZ8RkOLw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 05/23] net: xdp: add xdp_update_skb_shared_info utility routine
Date:   Mon, 15 Nov 2021 23:32:59 +0100
Message-Id: <6868077c3913573257c7cf417baaadb5d12dd467.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_update_skb_shared_info routine to update frags array
metadata in skb_shared_info data structure converting to a skb from
a xdp_buff or xdp_frame.
According to the current skb_shared_info architecture in
xdp_frame/xdp_buff and to the xdp multi-buff support, there is
no need to run skb_add_rx_frag() and reset frags array converting the buffer
to a skb since the frag array will be in the same position for xdp_buff/xdp_frame
and for the skb, we just need to update memory metadata.
Introduce XDP_FLAGS_PF_MEMALLOC flag in xdp_buff_flags in order to mark
the xdp_buff or xdp_frame as under memory-pressure if pages of the frags array
are under memory pressure. Doing so we can avoid looping over all fragments in
xdp_update_skb_shared_info routine. The driver is expected to set the
flag constructing the xdp_buffer using xdp_buff_set_frag_pfmemalloc
utility routine.
Rely on xdp_update_skb_shared_info in __xdp_build_skb_from_frame routine
converting the multi-buff xdp_frame to a skb after performing a XDP_REDIRECT.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 33 ++++++++++++++++++++++++++++++++-
 net/core/xdp.c    | 12 ++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 4ec7bdf0d937..e594016eb193 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -67,7 +67,10 @@ struct xdp_txq_info {
 };
 
 enum xdp_buff_flags {
-	XDP_FLAGS_MULTI_BUFF	= BIT(0), /* non-linear xdp buff */
+	XDP_FLAGS_MULTI_BUFF		= BIT(0), /* non-linear xdp buff */
+	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(1), /* xdp multi-buff paged memory
+						   * is under pressure
+						   */
 };
 
 struct xdp_buff {
@@ -96,6 +99,16 @@ static __always_inline void xdp_buff_clear_mb(struct xdp_buff *xdp)
 	xdp->flags &= ~XDP_FLAGS_MULTI_BUFF;
 }
 
+static __always_inline bool xdp_buff_is_frag_pfmemalloc(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_FRAGS_PF_MEMALLOC);
+}
+
+static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
+{
+	xdp->flags |= XDP_FLAGS_FRAGS_PF_MEMALLOC;
+}
+
 static __always_inline void
 xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
@@ -151,6 +164,11 @@ static __always_inline bool xdp_frame_is_mb(struct xdp_frame *frame)
 	return !!(frame->flags & XDP_FLAGS_MULTI_BUFF);
 }
 
+static __always_inline bool xdp_frame_is_frag_pfmemalloc(struct xdp_frame *frame)
+{
+	return !!(frame->flags & XDP_FLAGS_FRAGS_PF_MEMALLOC);
+}
+
 #define XDP_BULK_QUEUE_SIZE	16
 struct xdp_frame_bulk {
 	int count;
@@ -186,6 +204,19 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
 	frame->dev_rx = NULL;
 }
 
+static inline void
+xdp_update_skb_shared_info(struct sk_buff *skb, u8 nr_frags,
+			   unsigned int size, unsigned int truesize,
+			   bool pfmemalloc)
+{
+	skb_shinfo(skb)->nr_frags = nr_frags;
+
+	skb->len += size;
+	skb->data_len += size;
+	skb->truesize += truesize;
+	skb->pfmemalloc |= pfmemalloc;
+}
+
 /* Avoids inlining WARN macro in fast-path */
 void xdp_warn(const char *msg, const char *func, const int line);
 #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..89183b2e3c07 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -529,8 +529,14 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	unsigned int headroom, frame_size;
 	void *hard_start;
+	u8 nr_frags;
+
+	/* xdp multi-buff frame */
+	if (unlikely(xdp_frame_is_mb(xdpf)))
+		nr_frags = sinfo->nr_frags;
 
 	/* Part of headroom was reserved to xdpf */
 	headroom = sizeof(*xdpf) + xdpf->headroom;
@@ -550,6 +556,12 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	if (xdpf->metasize)
 		skb_metadata_set(skb, xdpf->metasize);
 
+	if (unlikely(xdp_frame_is_mb(xdpf)))
+		xdp_update_skb_shared_info(skb, nr_frags,
+					   sinfo->xdp_frags_size,
+					   nr_frags * xdpf->frame_sz,
+					   xdp_frame_is_frag_pfmemalloc(xdpf));
+
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.31.1

