Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA9568873B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbjBBS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjBBS6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:58:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FBD367C2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:58:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y14-20020a2586ce000000b0086167203873so1217604ybm.13
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YN98cNrpXDkdIzhcVIFV9D+C1oGPSiwZEV1Jck03X/k=;
        b=LHtAj0g2cRL2d50o/VRlQ5X5Vsew/dV9XGyFAGjvZO2n3BY8ehVB9ep3eDyIXS8vHR
         c+yqhOXg2APkL9cgvGTwvxrwTXqH6yxw6qOOcISw3QBTKCNHURc8XNeGxwQG0wiIKmyC
         saZje2uIyZ60dxCfP2TRmIYYWjTNeb8ggkCThsR8DZ/Y9yp6a3T6VJbt3ESp3zvaapN/
         Rb6ZVgdA7ejtvfDOS6NILGONmSTCidxv8cqflqn5yXLzj4Ez6WqC3xjMLpn7s/sbiwlg
         w5LBLK+Sy2L4/tlbhJCye0o34B/AF1PLhCU3xGcZvjz6HQP9u/5uJFpvbmkmzntSYRUK
         nXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YN98cNrpXDkdIzhcVIFV9D+C1oGPSiwZEV1Jck03X/k=;
        b=SwrFuzF0Vm/ncWSN2T/3LNSY6qZZppWxVYpBUKnVfdrWfQ4o8vHeMZXD7RG/lZsn5m
         9jFYqWd3MvwtKn6e5gaZkh04ub6iNdRtqv7L+fdnoQxTlMTg42cXpYcj8aju+PEXAHvU
         aTrO1xxMCbgYAbI3M78ZSgWpMaMxE24f57Lf3Vp/HDZ1QUMHsiF2UdEpcbH47wWGhe+O
         PZrysN55mwiQPgaclw9eKR/JAGuvt2HGsfwGW792usBbklKCx8LAgp2CgIad7TxFX74x
         KyruvtplxMx+m8fHAmzqurCaj6DehIfTF8C8TDmma1BbDEJHHu+uYaVZWKiCmyA76Kfk
         qCpA==
X-Gm-Message-State: AO0yUKW8ChKfgC5of3JWkAWUwEofWqcCBwQFUWnr41WuczvNhTDUYSDe
        mrg3Y8yUuZdMhSkZgh22+GzrEcsvEwQlzA==
X-Google-Smtp-Source: AK7set9kLcju52ic8X2PGOCqTOvyETaXxHwKQkg72i7xemfCNN31rlNpBX6+k8jAe+F3mTyxNXelmWVhB1mTCw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1d83:0:b0:524:896a:5a2a with SMTP id
 d125-20020a811d83000000b00524896a5a2amr1ywd.9.1675364292746; Thu, 02 Feb 2023
 10:58:12 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:58:01 +0000
In-Reply-To: <20230202185801.4179599-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202185801.4179599-5-edumazet@google.com>
Subject: [PATCH net-next 4/4] net: add dedicated kmem_cache for typical/small skb->head
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
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

Considering that many allocations are small,
we can have our own kmem_cache to avoid the cache line miss.

This also saves memory because these small heads
are no longer padded to 1024 bytes.

CONFIG_SLUB=y
$ grep skbuff_small_head /proc/slabinfo
skbuff_small_head   2907   2907    640   51    8 : tunables    0    0    0 : slabdata     57     57      0

CONFIG_SLAB=y
$ grep skbuff_small_head /proc/slabinfo
skbuff_small_head    607    624    640    6    1 : tunables   54   27    8 : slabdata    104    104      5

Note: after Kees Cook patches and this one, we might
be able to revert commit
dbae2b062824 ("net: skb: introduce and use a single page frag cache")
because GRO_MAX_HEAD is also small.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 52 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ae0b2aa1f01e8060cc4fe69137e9bd98e44280cc..3e540b4924701cc57b6fbd1b668bab3b652ee94c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -89,6 +89,19 @@ static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
 #ifdef CONFIG_SKB_EXTENSIONS
 static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 #endif
+static struct kmem_cache *skb_small_head_cache __ro_after_init;
+
+#define SKB_SMALL_HEAD_SIZE SKB_HEAD_ALIGN(MAX_TCP_HEADER)
+
+/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two. */
+#define SKB_SMALL_HEAD_CACHE_SIZE					\
+	(is_power_of_2(SKB_SMALL_HEAD_SIZE) ?			\
+		(SKB_SMALL_HEAD_SIZE + L1_CACHE_BYTES) :	\
+		SKB_SMALL_HEAD_SIZE)
+
+#define SKB_SMALL_HEAD_HEADROOM						\
+	SKB_WITH_OVERHEAD(SKB_SMALL_HEAD_CACHE_SIZE)
+
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
 
@@ -486,6 +499,21 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	void *obj;
 
 	obj_size = SKB_HEAD_ALIGN(*size);
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
 	*size = obj_size = kmalloc_size_roundup(obj_size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
@@ -805,6 +833,14 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data)
 	return page_pool_return_skb_page(virt_to_page(data));
 }
 
+static void skb_kfree_head(void *head, unsigned int end_offset)
+{
+	if (end_offset == SKB_SMALL_HEAD_HEADROOM)
+		kmem_cache_free(skb_small_head_cache, head);
+	else
+		kfree(head);
+}
+
 static void skb_free_head(struct sk_buff *skb)
 {
 	unsigned char *head = skb->head;
@@ -814,7 +850,7 @@ static void skb_free_head(struct sk_buff *skb)
 			return;
 		skb_free_frag(head);
 	} else {
-		kfree(head);
+		skb_kfree_head(head, skb_end_offset(skb));
 	}
 }
 
@@ -1995,7 +2031,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	return 0;
 
 nofrags:
-	kfree(data);
+	skb_kfree_head(data, size);
 nodata:
 	return -ENOMEM;
 }
@@ -4633,6 +4669,12 @@ void __init skb_init(void)
 						0,
 						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 						NULL);
+	skb_small_head_cache = kmem_cache_create("skbuff_small_head",
+						SKB_SMALL_HEAD_CACHE_SIZE,
+						0,
+						SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+						NULL);
+
 	skb_extensions_init();
 }
 
@@ -6297,7 +6339,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_cloned(skb)) {
 		/* drop the old head gracefully */
 		if (skb_orphan_frags(skb, gfp_mask)) {
-			kfree(data);
+			skb_kfree_head(data, size);
 			return -ENOMEM;
 		}
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
@@ -6405,7 +6447,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
 	if (skb_orphan_frags(skb, gfp_mask)) {
-		kfree(data);
+		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
 	shinfo = (struct skb_shared_info *)(data + size);
@@ -6441,7 +6483,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		/* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
 		if (skb_has_frag_list(skb))
 			kfree_skb_list(skb_shinfo(skb)->frag_list);
-		kfree(data);
+		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
 	skb_release_data(skb, SKB_CONSUMED);
-- 
2.39.1.456.gfc5497dd1b-goog

