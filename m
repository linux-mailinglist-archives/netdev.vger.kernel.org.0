Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5415168C4DA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBFRbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjBFRbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:31:11 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D6F25293
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:31:07 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52a87fc668cso12204107b3.18
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MX89JY1OCrbuxDDb7JH3LhU34Wn6PQ2hUnt/seh9tMM=;
        b=J01uAmfRdoWOduuci5YKHVGBdPLjsPecoy7ltrD0V73eYVw3kHpB2TUTk+H6Y0A5ur
         rqoljB7ETpIt3qLZgZ4FWzHvjH2IvVhTxlB5yqL91UQVS/C4J98mnvT5Q4rLsOLynCkO
         czrnAj7HJ7WtpQz33Mz7+T1Rz5xpx7Z+wBuvzpBv0G/cxlM/NQ56Q1HxPKRaY/f9uxWE
         IqHH1LK0ASl51c/RcJGkDU78aZ08EfkMb5+L11foqGP2KtDxbWtaJLsinMXLefP+7nva
         AhQ7YA10Z83eH2IUQEaMCgrpTvrVTNOHy7+v8M2TCeUmcQ9+gbkIhj7peNZj6uC43neW
         Ohgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MX89JY1OCrbuxDDb7JH3LhU34Wn6PQ2hUnt/seh9tMM=;
        b=FNG1JHtOCdUvNyp7fCwucJR17qHXWJAmT4Eu0HjZPcsjBNNVhx0wgH+GTgjrRl87rl
         1/J0JigZXKsXuyuZu/+CLj7RiwqdKFTsUP/8zT1zLXUlEpwWL74Pqn3SCKui5WfU5D7A
         VNVPEOComfAe4J932IKnFwHUZxq7c8W4gfqCOvOe2R8XK6VQdrxLwanMR3rHSUxr/4Sw
         +tz2r0LnfQU3yHoZuiqqBd87tY9Mcf8bFEOEUWlIj4X30f5ByNPubGnMnPO88fFX+6zP
         1cWLTUW4Mr+d6wChCAQRFlUSPDFgyAybOeJ6gxXevuF1ur8hn5nixxW2Hp/6RT1gvW2A
         dUMg==
X-Gm-Message-State: AO0yUKXDjAJx3GZDAmFIBwka5kCRMxrbhCWtv6vGAXySoDtRvO626Tq8
        DNOidW8qNom5NeGJ+MUvZuaSnpElU1ZYtQ==
X-Google-Smtp-Source: AK7set/LLcE8s4Wa00L0BbT/p96kDn0TqHBtjqIt+IK/P9tvjeNqXLGGMKX9HPe4hLj5QSgj/VFAMZMB/QO7cg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:18c:b0:80e:e93e:e433 with SMTP
 id t12-20020a056902018c00b0080ee93ee433mr60175ybh.257.1675704666710; Mon, 06
 Feb 2023 09:31:06 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:31:00 +0000
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230206173103.2617121-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206173103.2617121-2-edumazet@google.com>
Subject: [PATCH v2 net-next 1/4] net: add SKB_HEAD_ALIGN() helper
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

We have many places using this expression:

 SKB_DATA_ALIGN(sizeof(struct skb_shared_info))

Use of SKB_HEAD_ALIGN() will allow to clean them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/linux/skbuff.h |  8 ++++++++
 net/core/skbuff.c      | 18 ++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1fa95b916342e77601803ba1056f2d2b0646517b..c3df3b55da976dba2f5ba72bfa692329479d6750 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -255,6 +255,14 @@
 #define SKB_DATA_ALIGN(X)	ALIGN(X, SMP_CACHE_BYTES)
 #define SKB_WITH_OVERHEAD(X)	\
 	((X) - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
+/* For X bytes available in skb->head, what is the minimal
+ * allocation needed, knowing struct skb_shared_info needs
+ * to be aligned.
+ */
+#define SKB_HEAD_ALIGN(X) (SKB_DATA_ALIGN(X) + \
+	SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
 #define SKB_MAX_ORDER(X, ORDER) \
 	SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
 #define SKB_MAX_HEAD(X)		(SKB_MAX_ORDER((X), 0))
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 624e9e4ec116e2a619e49b3d8d8be7ece2ee41cc..4abfc3ba6898d89f4df97bf5f069b291dd5e420f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -558,8 +558,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * aligned memory blocks, unless SLUB/SLAB debug is enabled.
 	 * Both skb->head and skb_shared_info are cache line aligned.
 	 */
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	osize = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
@@ -632,8 +631,7 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 		goto skb_success;
 	}
 
-	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	len = SKB_DATA_ALIGN(len);
+	len = SKB_HEAD_ALIGN(len);
 
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
@@ -732,8 +730,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
 		pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
 	} else {
-		len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		len = SKB_DATA_ALIGN(len);
+		len = SKB_HEAD_ALIGN(len);
 
 		data = page_frag_alloc(&nc->page, len, gfp_mask);
 		pfmemalloc = nc->page.pfmemalloc;
@@ -1938,8 +1935,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
@@ -6289,8 +6285,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
@@ -6408,8 +6403,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
-- 
2.39.1.519.gcb327c4b5f-goog

