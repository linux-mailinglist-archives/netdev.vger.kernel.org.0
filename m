Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2753C344CB1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhCVRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:04:28 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:40639 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhCVRDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:03:55 -0400
Received: by mail-ej1-f49.google.com with SMTP id u9so22491654ejj.7;
        Mon, 22 Mar 2021 10:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jdgNn6wGQVPWa83h8L7hpha0BMyYWY/WMzObKAw2/sA=;
        b=gCOm680nSnb8yTuoBmDm3wrqJY7LzA20ubfuyOBMByeWgQWxbbbSIlg1OhuYCIiYwT
         8tSpCpyL0MGFhOM0UC2qoLpqEEcCKGyAGWIurVep7VIAyRifOVaqTQaYcWWDxpKZjXe2
         46OZt+61t4JCVoU1b0DXxbabRS5LUbsGL5djJwlStWUQohp3OJngjOpo21Db2eAlLj0t
         DzXR3uh6Fsw6prW0Xyqm1uU+LdN3sj6tiJJ981/y7wMaallEKxkb7krbK1U7d6D9Sxx7
         9GOvv4jlcmJVQqS1F9n1jQNaDIy/bqTytNq0hVpwZr1gAPSqp0x5l83NJ+fWX4Xl6CgL
         4G+g==
X-Gm-Message-State: AOAM532OL+WNiPTYGOYyrgq7FXjgJHkwicMb9lbjsVFs4Sshb80Gcpp5
        QYpAVg7ClFcvyO3jF7D4P6Ugd+QPi+Q=
X-Google-Smtp-Source: ABdhPJyPV+k+08FXDbxqVyi7JYSVFfEsOJk8Frp80JIGvE1gROEYoMnyLdaKWoB++oc46RgRTI8X6w==
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr733128eju.493.1616432634042;
        Mon, 22 Mar 2021 10:03:54 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-34-63-208.cust.vodafonedsl.it. [2.34.63.208])
        by smtp.gmail.com with ESMTPSA id h22sm9891589eji.80.2021.03.22.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:03:53 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/6] page_pool: DMA handling and allow to recycles frames via SKB
Date:   Mon, 22 Mar 2021 18:02:58 +0100
Message-Id: <20210322170301.26017-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

During skb_release_data() intercept the packet and if it's a buffer
coming from our page_pool API recycle it back to the pool for further
usage.
To achieve that we introduce a bit in struct sk_buff (pp_recycle:1) and
store the xdp_mem_info in page->private. The SKB bit is needed since
page->private is used by skb_copy_ubufs, so we can't rely solely on
page->private to trigger recycling.

The driver has to take care of the sync operations on it's own
during the buffer recycling since the buffer is never unmapped.

In order to enable recycling the driver must call skb_mark_for_recycle()
to store the information we need for recycling in page->private and
enabling the recycling bit

Storing the information in page->private allows us to recycle both SKBs
and their fragments

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/skbuff.h  | 33 +++++++++++++++++++++++++++----
 include/net/page_pool.h | 13 +++++++++++++
 include/net/xdp.h       |  1 +
 net/core/page_pool.c    | 43 +++++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c       | 20 +++++++++++++++++--
 net/core/xdp.c          |  6 ++++++
 6 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ecc029674ae4..3e09a070136f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -40,6 +40,9 @@
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+#include <net/page_pool.h>
+#endif
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -247,6 +250,7 @@ struct napi_struct;
 struct bpf_prog;
 union bpf_attr;
 struct skb_ext;
+struct xdp_mem_info;
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
@@ -666,6 +670,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
+ *	@pp_recycle: mark the packet for recycling instead of freeing (implies
+ *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -790,10 +796,12 @@ struct sk_buff {
 				fclone:2,
 				peeked:1,
 				head_frag:1,
-				pfmemalloc:1;
+				pfmemalloc:1,
+				pp_recycle:1; /* page_pool recycle indicator */
 #ifdef CONFIG_SKB_EXTENSIONS
 	__u8			active_extensions;
 #endif
+
 	/* fields enclosed in headers_start/headers_end are copied
 	 * using a single memcpy() in __copy_skb_header()
 	 */
@@ -3080,12 +3088,20 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
+ * @recycle: recycle the page if allocated via page_pool
  *
  * Releases a reference on the paged fragment @frag.
+ * or recycles the page via the page_pool API
  */
-static inline void __skb_frag_unref(skb_frag_t *frag)
+static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
-	put_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+	if (recycle && page_pool_return_skb_page(page_address(page)))
+		return;
+#endif
+	put_page(page);
 }
 
 /**
@@ -3097,7 +3113,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f]);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
 }
 
 /**
@@ -4695,5 +4711,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
+					struct xdp_mem_info *mem)
+{
+	skb->pp_recycle = 1;
+	page_pool_store_mem_info(page, mem);
+}
+#endif
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b30405e84b5e..75fffc15788b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -65,6 +65,8 @@
 #define PP_ALLOC_CACHE_REFILL	64
 #define PP_SIGNATURE		0x20210303
 
+struct xdp_mem_info;
+
 struct pp_alloc_cache {
 	u32 count;
 	void *cache[PP_ALLOC_CACHE_SIZE];
@@ -148,6 +150,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+bool page_pool_return_skb_page(void *data);
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 #ifdef CONFIG_PAGE_POOL
@@ -243,4 +247,13 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
 		spin_unlock_bh(&pool->ring.producer_lock);
 }
 
+/* Store mem_info on struct page and use it while recycling skb frags */
+static inline
+void page_pool_store_mem_info(struct page *page, struct xdp_mem_info *mem)
+{
+	u32 *xmi = (u32 *)mem;
+
+	set_page_private(page, *xmi);
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index c35864d59113..5d7316f1f195 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -235,6 +235,7 @@ void xdp_return_buff(struct xdp_buff *xdp);
 void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
 void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 			   struct xdp_frame_bulk *bq);
+void xdp_return_skb_frame(void *data, struct xdp_mem_info *mem);
 
 /* When sending xdp_frame into the network stack, then there is no
  * return point callback, which is needed to release e.g. DMA-mapping
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2ae9b554ef98..43bfd2e3d8df 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/skbuff.h>
 
 #include <net/page_pool.h>
 #include <net/xdp.h>
@@ -17,12 +18,19 @@
 #include <linux/dma-mapping.h>
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for __put_page() */
+#include <net/xdp.h>
 
 #include <trace/events/page_pool.h>
 
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
+/* Used to store/retrieve hi/lo bytes from xdp_mem_info to page->private */
+union page_pool_xmi {
+	u32 raw;
+	struct xdp_mem_info mem_info;
+};
+
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -587,3 +595,38 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+bool page_pool_return_skb_page(void *data)
+{
+	struct xdp_mem_info mem_info;
+	union page_pool_xmi info;
+	struct page *page;
+
+	page = virt_to_head_page(data);
+	if (unlikely(page->signature != PP_SIGNATURE))
+		return false;
+
+	info.raw = page_private(page);
+	mem_info = info.mem_info;
+
+	/* If a buffer is marked for recycle and does not belong to
+	 * MEM_TYPE_PAGE_POOL, the buffers will be eventually freed from the
+	 * network stack and kfree_skb, but the DMA region will *not* be
+	 * correctly unmapped. WARN here for the recycling misusage
+	 */
+	if (unlikely(mem_info.type != MEM_TYPE_PAGE_POOL)) {
+		WARN_ONCE(true, "Tried to recycle non MEM_TYPE_PAGE_POOL");
+		return false;
+	}
+
+	/* Driver set this to memory recycling info. Reset it on recycle
+	 * This will *not* work for NIC using a split-page memory model.
+	 * The page will be returned to the pool here regardless of the
+	 * 'flipped' fragment being in use or not
+	 */
+	set_page_private(page, 0);
+	xdp_return_skb_frame(data, &mem_info);
+
+	return true;
+}
+EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e8320b5d651a..7f5c02085438 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -69,6 +69,9 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+#include <net/page_pool.h>
+#endif
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -644,6 +647,11 @@ static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
 
+#if IS_BUILTIN(CONFIG_PAGE_POOL)
+	if (skb->pp_recycle && page_pool_return_skb_page(head))
+		return;
+#endif
+
 	if (skb->head_frag)
 		skb_free_frag(head);
 	else
@@ -663,7 +671,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
+		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -1045,6 +1053,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
+	C(pp_recycle);
 	n->destructor = NULL;
 	C(tail);
 	C(end);
@@ -3453,7 +3462,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom);
+		__skb_frag_unref(fragfrom, skb->pp_recycle);
 	}
 
 	/* Reposition in the original skb */
@@ -5234,6 +5243,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
+	/* We can't coalesce skb that are allocated from slab and page_pool
+	 * The recycle mark is on the skb, so that might end up trying to
+	 * recycle slab allocated skb->head
+	 */
+	if (to->pp_recycle != from->pp_recycle)
+		return false;
+
 	if (len <= skb_tailroom(to)) {
 		if (len)
 			BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 3dd47ed83778..d89b827e54a9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -372,6 +372,12 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 	}
 }
 
+void xdp_return_skb_frame(void *data, struct xdp_mem_info *mem)
+{
+	__xdp_return(data, mem, false, NULL);
+}
+EXPORT_SYMBOL_GPL(xdp_return_skb_frame);
+
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
 	__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
-- 
2.30.2

