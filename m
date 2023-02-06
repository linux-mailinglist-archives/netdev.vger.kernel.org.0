Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0260468C4DB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjBFRbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjBFRbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:31:15 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E42644A0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:31:12 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52a87fc668cso12206707b3.18
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iB+socU0AKk97tweSMWnrEWkBXfyBtmvwaea0l/B/bE=;
        b=Qp+mWTaWtjlEqzGnmNGm648JI85E2toMLQXSAwzMqSvR8bFQHCxDGHopnBDfQYxfCr
         O5vDxRFdvXwJZq9IMioMbI6n4QYFiSQWUawhqMDMOcOfq6kEPmlvY6ZraM3G/JUdfEmR
         dgZA6X+IYn3IKyFU/Aw2UiY3yGab3hh9YVUIWF1Wsxv8GEy1oAQSuk8QP60UO1B7X/g9
         dbMsO7eO7U+SngV40V6Lp0ghD1CswBD31/GbRiG1ERVO01M5M1afHqCxyiGY59ygb825
         NEFjLI6q4Qlc9oBW31lk+LARasLhL8qvvOjHcDusgwA4XW4kVnVBWb8p+7jrx881IuSI
         KJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB+socU0AKk97tweSMWnrEWkBXfyBtmvwaea0l/B/bE=;
        b=RhHTlJaKbaoXFGwwq446aWvtffiu8vHA/aCwSIl9zTwpf00EsrYaOel+oD8SdyaCq5
         N1yFk3GwdtPTwOsVkicuNYL6KC3qpTROoQZo/+zHdyJ7KX9rdATNXf8XjIQpq6q9Cv3Z
         LVunh+yVuYFOMg4N8B8WMS+PMqvys4mgQ6E5KXtjCalY4Q3mo+tRtHEH/ukBw5Jvwq40
         aXwLJruuhqX6OhtoyvMvBPtCuNBASJunHQqUJKJOh4yEQs7+ENO4tj3RpASGPNNvuOXW
         zfJQ+FF/ss9rdGnbRkmkeA+Rl6YLT8ZGcYjRp/ixdFeLv3fG3MNoxyGhrlCKyBAcVvRK
         ZPiw==
X-Gm-Message-State: AO0yUKUuCyjs+w1LIwCd2rfROtv56DlCFF9eNWllFB4mGc2jzfV4Tnoa
        TvhkyAz4aVBLMcIGZ/v+fAF/KnGdcBlwaA==
X-Google-Smtp-Source: AK7set95ho8k1WbBL4IyLS1RRYSwGOkhbTvIIUQsmHfiLbZxy8bbX2mws2ap0qBy9PjoA1i5Ftt6LgJaQ0SLfQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:f82:b0:525:2090:6b9c with SMTP
 id df2-20020a05690c0f8200b0052520906b9cmr0ywb.2.1675704671554; Mon, 06 Feb
 2023 09:31:11 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:31:03 +0000
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230206173103.2617121-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206173103.2617121-5-edumazet@google.com>
Subject: [PATCH v2 net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent removal of ksize() in alloc_skb() increased
performance because we no longer read
the associated struct page.

We have an equivalent cost at kfree_skb() time.

kfree(skb->head) has to access a struct page,
often cold in cpu caches to get the owning
struct kmem_cache.

Considering that many allocations are small (at least for TCP ones)
we can have our own kmem_cache to avoid the cache line miss.

This also saves memory because these small heads
are no longer padded to 1024 bytes.

CONFIG_SLUB=y
$ grep skbuff_small_head /proc/slabinfo
skbuff_small_head   2907   2907    640   51    8 : tunables    0    0    0 : slabdata     57     57      0

CONFIG_SLAB=y
$ grep skbuff_small_head /proc/slabinfo
skbuff_small_head    607    624    640    6    1 : tunables   54   27    8 : slabdata    104    104      5

Notes:

- After Kees Cook patches and this one, we might
  be able to revert commit
  dbae2b062824 ("net: skb: introduce and use a single page frag cache")
  because GRO_MAX_HEAD is also small.

- This patch is a NOP for CONFIG_SLOB=y builds.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/core/skbuff.c | 72 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c1232837cd0cb3befce0262fb8fda20272a26d45..bdb1e015e32b9386139e9ad73acd6efb3c357118 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -89,6 +89,34 @@ static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
 #ifdef CONFIG_SKB_EXTENSIONS
 static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 #endif
+
+/* skb_small_head_cache and related code is only supported
+ * for CONFIG_SLAB and CONFIG_SLUB.
+ * As soon as SLOB is removed from the kernel, we can clean up this.
+ */
+#if !defined(CONFIG_SLOB)
+# define HAVE_SKB_SMALL_HEAD_CACHE 1
+#endif
+
+#ifdef HAVE_SKB_SMALL_HEAD_CACHE
+static struct kmem_cache *skb_small_head_cache __ro_after_init;
+
+#define SKB_SMALL_HEAD_SIZE SKB_HEAD_ALIGN(MAX_TCP_HEADER)
+
+/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two.
+ * This should ensure that SKB_SMALL_HEAD_HEADROOM is a unique
+ * size, and we can differentiate heads from skb_small_head_cache
+ * vs system slabs by looking at their size (skb_end_offset()).
+ */
+#define SKB_SMALL_HEAD_CACHE_SIZE					\
+	(is_power_of_2(SKB_SMALL_HEAD_SIZE) ?			\
+		(SKB_SMALL_HEAD_SIZE + L1_CACHE_BYTES) :	\
+		SKB_SMALL_HEAD_SIZE)
+
+#define SKB_SMALL_HEAD_HEADROOM						\
+	SKB_WITH_OVERHEAD(SKB_SMALL_HEAD_CACHE_SIZE)
+#endif /* HAVE_SKB_SMALL_HEAD_CACHE */
+
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
 
@@ -486,6 +514,23 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	void *obj;
 
 	obj_size = SKB_HEAD_ALIGN(*size);
+#ifdef HAVE_SKB_SMALL_HEAD_CACHE
+	if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
+	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
+
+		/* skb_small_head_cache has non power of two size,
+		 * likely forcing SLUB to use order-3 pages.
+		 * We deliberately attempt a NOMEMALLOC allocation only.
+		 */
+		obj = kmem_cache_alloc_node(skb_small_head_cache,
+				flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
+				node);
+		if (obj) {
+			*size = SKB_SMALL_HEAD_CACHE_SIZE;
+			goto out;
+		}
+	}
+#endif
 	*size = obj_size = kmalloc_size_roundup(obj_size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
@@ -805,6 +850,16 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data)
 	return page_pool_return_skb_page(virt_to_page(data));
 }
 
+static void skb_kfree_head(void *head, unsigned int end_offset)
+{
+#ifdef HAVE_SKB_SMALL_HEAD_CACHE
+	if (end_offset == SKB_SMALL_HEAD_HEADROOM)
+		kmem_cache_free(skb_small_head_cache, head);
+	else
+#endif
+		kfree(head);
+}
+
 static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
@@ -814,7 +869,7 @@ static void skb_free_head(struct sk_buff *skb)
 			return;
 		skb_free_frag(head);
 	} else {
-		kfree(head);
+		skb_kfree_head(head, skb_end_offset(skb));
 	}
 }
 
@@ -1997,7 +2052,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	return 0;
 
 nofrags:
-	kfree(data);
+	skb_kfree_head(data, size);
 nodata:
 	return -ENOMEM;
 }
@@ -4634,6 +4689,13 @@ void __init skb_init(void)
 						0,
 						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 						NULL);
+#ifdef HAVE_SKB_SMALL_HEAD_CACHE
+	skb_small_head_cache = kmem_cache_create("skbuff_small_head",
+						SKB_SMALL_HEAD_CACHE_SIZE,
+						0,
+						SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+						NULL);
+#endif
 	skb_extensions_init();
 }
 
@@ -6298,7 +6360,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_cloned(skb)) {
 		/* drop the old head gracefully */
 		if (skb_orphan_frags(skb, gfp_mask)) {
-			kfree(data);
+			skb_kfree_head(data, size);
 			return -ENOMEM;
 		}
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
@@ -6406,7 +6468,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
 	if (skb_orphan_frags(skb, gfp_mask)) {
-		kfree(data);
+		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
 	shinfo = (struct skb_shared_info *)(data + size);
@@ -6442,7 +6504,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		/* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
 		if (skb_has_frag_list(skb))
 			kfree_skb_list(skb_shinfo(skb)->frag_list);
-		kfree(data);
+		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
 	skb_release_data(skb, SKB_CONSUMED);
-- 
2.39.1.519.gcb327c4b5f-goog

