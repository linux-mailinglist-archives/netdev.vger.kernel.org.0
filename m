Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650D2D1625
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgLGQe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbgLGQe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:28 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 11/14] bpf: cpumap: introduce xdp multi-buff support
Date:   Mon,  7 Dec 2020 17:32:40 +0100
Message-Id: <a12bf957bf99fa86d229f383f615f11ee7153340.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame
utility routines to build the skb from xdp_frame.
Add xdp multi-buff support to cpumap

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h   |  5 ++++
 kernel/bpf/cpumap.c | 45 +---------------------------
 net/core/xdp.c      | 73 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index d0e90d729023..76cfee6a40f7 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -191,6 +191,11 @@ void xdp_warn(const char *msg, const char *func, const int line);
 #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
+struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					   struct sk_buff *skb,
+					   struct net_device *dev);
+struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					 struct net_device *dev);
 
 static inline
 void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 747313698178..49113880b82a 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -141,49 +141,6 @@ static void cpu_map_kthread_stop(struct work_struct *work)
 	kthread_stop(rcpu->kthread);
 }
 
-static struct sk_buff *cpu_map_build_skb(struct xdp_frame *xdpf,
-					 struct sk_buff *skb)
-{
-	unsigned int hard_start_headroom;
-	unsigned int frame_size;
-	void *pkt_data_start;
-
-	/* Part of headroom was reserved to xdpf */
-	hard_start_headroom = sizeof(struct xdp_frame) +  xdpf->headroom;
-
-	/* Memory size backing xdp_frame data already have reserved
-	 * room for build_skb to place skb_shared_info in tailroom.
-	 */
-	frame_size = xdpf->frame_sz;
-
-	pkt_data_start = xdpf->data - hard_start_headroom;
-	skb = build_skb_around(skb, pkt_data_start, frame_size);
-	if (unlikely(!skb))
-		return NULL;
-
-	skb_reserve(skb, hard_start_headroom);
-	__skb_put(skb, xdpf->len);
-	if (xdpf->metasize)
-		skb_metadata_set(skb, xdpf->metasize);
-
-	/* Essential SKB info: protocol and skb->dev */
-	skb->protocol = eth_type_trans(skb, xdpf->dev_rx);
-
-	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
-	 * - HW RX hash			(skb_set_hash)
-	 * - RX ring dev queue index	(skb_record_rx_queue)
-	 */
-
-	/* Until page_pool get SKB return path, release DMA here */
-	xdp_release_frame(xdpf);
-
-	/* Allow SKB to reuse area used by xdp_frame */
-	xdp_scrub_frame(xdpf);
-
-	return skb;
-}
-
 static void __cpu_map_ring_cleanup(struct ptr_ring *ring)
 {
 	/* The tear-down procedure should have made sure that queue is
@@ -350,7 +307,7 @@ static int cpu_map_kthread_run(void *data)
 			struct sk_buff *skb = skbs[i];
 			int ret;
 
-			skb = cpu_map_build_skb(xdpf, skb);
+			skb = __xdp_build_skb_from_frame(xdpf, skb, xdpf->dev_rx);
 			if (!skb) {
 				xdp_return_frame(xdpf);
 				continue;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 6c8e743ad03a..55f3e9c69427 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -597,3 +597,76 @@ void xdp_warn(const char *msg, const char *func, const int line)
 	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
 };
 EXPORT_SYMBOL_GPL(xdp_warn);
+
+struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					   struct sk_buff *skb,
+					   struct net_device *dev)
+{
+	unsigned int headroom = sizeof(*xdpf) + xdpf->headroom;
+	void *hard_start = xdpf->data - headroom;
+	skb_frag_t frag_list[MAX_SKB_FRAGS];
+	struct xdp_shared_info *xdp_sinfo;
+	int i, num_frags = 0;
+
+	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+	if (unlikely(xdpf->mb)) {
+		num_frags = xdp_sinfo->nr_frags;
+		memcpy(frag_list, xdp_sinfo->frags,
+		       sizeof(skb_frag_t) * num_frags);
+	}
+
+	skb = build_skb_around(skb, hard_start, xdpf->frame_sz);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, headroom);
+	__skb_put(skb, xdpf->len);
+	if (xdpf->metasize)
+		skb_metadata_set(skb, xdpf->metasize);
+
+	if (likely(!num_frags))
+		goto out;
+
+	for (i = 0; i < num_frags; i++) {
+		struct page *page = xdp_get_frag_page(&frag_list[i]);
+
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				page, xdp_get_frag_offset(&frag_list[i]),
+				xdp_get_frag_size(&frag_list[i]),
+				xdpf->frame_sz);
+	}
+
+out:
+	/* Essential SKB info: protocol and skb->dev */
+	skb->protocol = eth_type_trans(skb, dev);
+
+	/* Optional SKB info, currently missing:
+	 * - HW checksum info		(skb->ip_summed)
+	 * - HW RX hash			(skb_set_hash)
+	 * - RX ring dev queue index	(skb_record_rx_queue)
+	 */
+
+	/* Until page_pool get SKB return path, release DMA here */
+	xdp_release_frame(xdpf);
+
+	/* Allow SKB to reuse area used by xdp_frame */
+	xdp_scrub_frame(xdpf);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(__xdp_build_skb_from_frame);
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
2.28.0

