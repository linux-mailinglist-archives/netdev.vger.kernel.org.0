Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF8688738
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjBBS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjBBS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:58:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB9E12F19
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:58:05 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5065604854eso29049577b3.16
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zo5Vq3MAn/Li5H6n621bkQpdnHht3zfcLn68T0vVpDQ=;
        b=sH7nonY4kCQVPsu3hze+evYr81/o0DoOzq7D7UIKYjAQ3/7jaGWMHgz+SJInipMDpt
         Ee37HL0FCjpVidoaCCKCTha06BMZb44+z0J2tVMlOegyQG+ANDapaU8oXeEkzBnCeo6r
         z9TbGOdU6wKZud9yq0Pz8uKVkcJc/kdAu4Fq9LX/GDymXLPb+jkcIQOp8j03/YExv1J1
         isKUlL2cYzj8KbW3PmE9rfj6qe9+c8qNMHaAWmXOGMvRj5GqGgHtRpYM9ibdEyIL2Gqg
         FTslEk+4vn6R8sRbFZFY48fDv/yR3Np38fZbSwL49SdDUIUW4r5yf9lcKatYCfcKAKe7
         7ZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zo5Vq3MAn/Li5H6n621bkQpdnHht3zfcLn68T0vVpDQ=;
        b=2Pn/INH7jgS8lY6MTuoh6BalMNGk0Mpbd2wGTSMGd5BgD2tyHnQqsdIRZeVpHrO7SR
         jQA1n6hwBQr4KZhE6xtelf4TTzEfH+1OGhLHR37C57nwxKHqa8jmSaxXsRtQ7c4h4Od2
         CWmE0EhDZjdzx6VwTzYIB7WvyoT3L4dCzGZ/afI9r1znb1xMy5SFoy5pZM4LqTbCW2xH
         E2ZwjJ30GApuAUGsymmtIbF+RZvzPCZgEoadzReAgodYRJTJDNJgM84FrPnBEQOQJldJ
         aHvexK1WQqMcAajd7mIW0q8Yr6Rjr7Kzf8mbhrEOkO7tO+aV35I4ZB13Xgb9fQtqyMRO
         zJhw==
X-Gm-Message-State: AO0yUKXUv8WwExEMP594FjtvgsTQqNaIZ50WaAmBQEBMbMiorR0YelJX
        0cDlIHZd87RtUwfXecdDPJEZfoLcseHSFg==
X-Google-Smtp-Source: AK7set9bMmBizAHUloRVsCbSu0u8g7qVikmv1d9SgF1YbrWIiEjWfPtvaH4PmxHIAQjhOijLDlikE/33zP75Kw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d093:0:b0:80b:a1ca:21fc with SMTP id
 h141-20020a25d093000000b0080ba1ca21fcmr910513ybg.403.1675364284685; Thu, 02
 Feb 2023 10:58:04 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:57:58 +0000
In-Reply-To: <20230202185801.4179599-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202185801.4179599-2-edumazet@google.com>
Subject: [PATCH net-next 1/4] net: add SKB_HEAD_ALIGN() helper
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

We have many places using this expression:

 SKB_DATA_ALIGN(sizeof(struct skb_shared_info))

Use of SKB_HEAD_ALIGN() will allow to clean them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h |  8 ++++++++
 net/core/skbuff.c      | 18 ++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5ba12185f43e311e37c9045763c3ee0efc274f2a..f2141b7e3940cee060e8443dbaa147b843eb43a0 100644
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
index bb79b4cb89db344d23609f93b2bcca5103f1e92d..b73de8fb0756c02cf9ba4b7e90854c9c17728463 100644
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
@@ -1936,8 +1933,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
@@ -6288,8 +6284,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
@@ -6407,8 +6402,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_DATA_ALIGN(size);
-	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = SKB_HEAD_ALIGN(size);
 	size = kmalloc_size_roundup(size);
 	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
-- 
2.39.1.456.gfc5497dd1b-goog

