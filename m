Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5D28158C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbgJBOnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388016AbgJBOnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:43:19 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C65532074B;
        Fri,  2 Oct 2020 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649799;
        bh=X2lmksPI9nQGFdNp2KO6XfRfikz0sJW9YQmr7+W2m0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEQUqqJuqx7p7XIZ6+r+zOGFkrQuivzVp4kcEpDVq9NW+j/RKCkpJyH8rWvW8GVg1
         az4qE3/3OHytiT0gCY/RF6RhTPujZBKLkNGnR/hF5q9HqT9uEfJNzUu6KC8mZCpeXu
         7FQ9G1gvJU8t48BtOU9nw38RG5dx5nnTU6akzp10=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 13/13] bpf: cpumap: introduce xdp multi-buff support
Date:   Fri,  2 Oct 2020 16:42:11 +0200
Message-Id: <94ff09e2b8bf01eade7ae73d3cb0984423d3abe9.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
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
 kernel/bpf/cpumap.c | 45 +------------------------------
 net/core/xdp.c      | 64 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 44 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 4d47076546ff..8d9224ef75ee 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -134,6 +134,11 @@ void xdp_warn(const char *msg, const char *func, const int line);
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
index c61a23b564aa..fa07b4226836 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -155,49 +155,6 @@ static void cpu_map_kthread_stop(struct work_struct *work)
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
@@ -364,7 +321,7 @@ static int cpu_map_kthread_run(void *data)
 			struct sk_buff *skb = skbs[i];
 			int ret;
 
-			skb = cpu_map_build_skb(xdpf, skb);
+			skb = __xdp_build_skb_from_frame(xdpf, skb, xdpf->dev_rx);
 			if (!skb) {
 				xdp_return_frame(xdpf);
 				continue;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 6d4fd4dddb00..a6bdefed92e6 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -507,3 +507,67 @@ void xdp_warn(const char *msg, const char *func, const int line)
 	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
 };
 EXPORT_SYMBOL_GPL(xdp_warn);
+
+struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
+					   struct sk_buff *skb,
+					   struct net_device *dev)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	unsigned int headroom = sizeof(*xdpf) +  xdpf->headroom;
+	int i, num_frags = xdpf->mb ? sinfo->nr_frags : 0;
+	void *hard_start = xdpf->data - headroom;
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
+		skb_frag_t *frag = &sinfo->frags[i];
+
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				skb_frag_page(frag), skb_frag_off(frag),
+				skb_frag_size(frag), xdpf->frame_sz);
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
2.26.2

