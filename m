Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC170602868
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJRJdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJRJdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:33:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97F2AE222
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:33:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l4so13272766plb.8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vcm2DjcFdVdA2XmTeYXfvoBfujRgUbAVY112h3yQ01E=;
        b=Rf81/UGr3jsRCHiHZ4O2uCDtkwk3ZukD6i1ETq7uVpiDB3hv5Pg0SQPB+lcGsWZDXa
         bX1VCwnGbAuImcrTwkezVKVo+AzGEDVcs2xS9joui3Zb1W1q4E/V9BvIb+BZbC1gHkI1
         9S9DlbNlB1xiEjiGvlmr9o5KXPNso43opj0Cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vcm2DjcFdVdA2XmTeYXfvoBfujRgUbAVY112h3yQ01E=;
        b=llHmpveMmzB+4yERN240RnIM4NO9Znc/A226uK1NdrFrZW93X3YHM9lgN4yDBCKY/B
         sHKzn5C1NLg31kNCxQmWcWanCw7/zKeAvZXu3zoO6CbyDwjXyLF489LXRqcoaBjZoB8m
         f3kLO4f2UbYfsKR72hx17eujmgqmlTZK8mse/qPH2yK40dkzrBeCiiJkEte/K2rMoKUX
         XgOh/GPkoritB6VY/zYFPwlEazgono4PROpNn/GiIhXfDKTAbb152irGDD1Sdwi0smgB
         gGQxLCVycuvYE21QlRUmronjMiWAsjMk1xr7U9TXE7stBNmhMQ25vRkfJDWSDHPiw3PM
         7tEg==
X-Gm-Message-State: ACrzQf3jxNiZLD64mJpk5EcbY4MeDfAeZci3wjVrzLszkxSGxftUXgF5
        WCBf1GOeia7N5k2ptW7gnVIoJA==
X-Google-Smtp-Source: AMsMyM6slsitU+u2+16Y8O8YtqGpFS8zF9DIOV25bbZsfBuuEy+yjAb8GEvZKxEHewLg0d0qd1QhUg==
X-Received: by 2002:a17:902:724c:b0:177:5080:cbeb with SMTP id c12-20020a170902724c00b001775080cbebmr2294093pll.67.1666085620323;
        Tue, 18 Oct 2022 02:33:40 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o9-20020a170903210900b00179c9219195sm8192637ple.16.2022.10.18.02.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:33:39 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v3][next] skbuff: Proactively round up to kmalloc bucket size
Date:   Tue, 18 Oct 2022 02:33:36 -0700
Message-Id: <20221018093005.give.246-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5848; h=from:subject:message-id; bh=pkLoivXaq3CVJLhapnRLgcHPxB9L7soYhnHwJEdUlPc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTnLvD8DVluil9nQfvRUSQMN+hxeTSt8QuPl3dr4u gC7wBFaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05y7wAKCRCJcvTf3G3AJrQKEA CXK8cN3LQuRpfc2qi+jIv4AZtTeh+TEquNKS03J+jyWEQMX2TfMqJEBtXdWx8o60qualisfkZTw2dY QPfnJO5jb9mHv6kYBWvrBx19X+wNA4AQNJjDF8oJclIwC8wicuY1Be0Pv0ObTPKKsfn7vroHgK+e+C tKAt5ZGF033olGPFQdZQnx/RKiP1i5XySSGr0DjOSn5H+BjA2ALBPe9omF6NhqsiDEHkjUSCpWpGNr IEMdF0VrB5QNU/SacfDGnSjn4B9r94dF6tqUcO0vm62Va2MnPYMhiI0mssF1Eim4bNgrNTKRFv5VHg y2a2jFqmfLo3HPGO0uSTa4IMIONZAg376fbjHBkHwDtWJsyaSxjXQShTatXtSHOOSi4gDB4Cahvzs7 pOm6d/BZu5ubZBNMq7gyZrUYYHxrfI4ATFpd7WPoMa4i1ra4ZiE4niMHnK4AQAn9hIhmTOMcEeokUh yz3wU5NACqG32ulU633t6rQMLR0dw/53ldBXPRlWB4OEgr7qK+9bTog24H4yM0AkgInaCOJ1tVuoQM 0+lqCUvjwkKC6vZje+Xh3ag8SXfeyne/gaoxV0+mOG0/AINZecQ44rBNkryrzz/PDwxqkeVzjrWO50 jBk3cWIUCieUvThMEIW6ZjRAe9Q+RRrHsJOMEv6ab4HrLMOQRT375cQHq8bA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of discovering the kmalloc bucket size _after_ allocation, round
up proactively so the allocation is explicitly made for the full size,
allowing the compiler to correctly reason about the resulting size of
the buffer through the existing __alloc_size() hint.

This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
back the __alloc_size() hints that were temporarily reverted in commit
93dd04ab0b2b ("slab: remove __alloc_size attribute from __kmalloc_track_caller")

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3: refactor again to pass allocation size more cleanly to callers
v2: https://lore.kernel.org/lkml/20220923202822.2667581-4-keescook@chromium.org/
---
 net/core/skbuff.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..3ea1032d03ec 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -425,11 +425,12 @@ EXPORT_SYMBOL(napi_build_skb);
  * memory is free
  */
 static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
-			     bool *pfmemalloc)
+			     bool *pfmemalloc, size_t *alloc_size)
 {
 	void *obj;
 	bool ret_pfmemalloc = false;
 
+	size = kmalloc_size_roundup(size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
@@ -448,6 +449,7 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
 	if (pfmemalloc)
 		*pfmemalloc = ret_pfmemalloc;
 
+	*alloc_size = size;
 	return obj;
 }
 
@@ -479,7 +481,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 {
 	struct kmem_cache *cache;
 	struct sk_buff *skb;
-	unsigned int osize;
+	size_t alloc_size;
 	bool pfmemalloc;
 	u8 *data;
 
@@ -506,15 +508,15 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
-	if (unlikely(!data))
-		goto nodata;
-	/* kmalloc(size) might give us more room than requested.
+	/* kmalloc(size) might give us more room than requested, so
+	 * allocate the true bucket size up front.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	osize = ksize(data);
-	size = SKB_WITH_OVERHEAD(osize);
+	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc, &alloc_size);
+	if (unlikely(!data))
+		goto nodata;
+	size = SKB_WITH_OVERHEAD(alloc_size);
 	prefetchw(data + size);
 
 	/*
@@ -523,7 +525,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * the tail pointer in struct sk_buff!
 	 */
 	memset(skb, 0, offsetof(struct sk_buff, tail));
-	__build_skb_around(skb, data, osize);
+	__build_skb_around(skb, data, alloc_size);
 	skb->pfmemalloc = pfmemalloc;
 
 	if (flags & SKB_ALLOC_FCLONE) {
@@ -1816,6 +1818,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 {
 	int i, osize = skb_end_offset(skb);
 	int size = osize + nhead + ntail;
+	size_t alloc_size;
 	long off;
 	u8 *data;
 
@@ -1830,10 +1833,10 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+			       gfp_mask, NUMA_NO_NODE, NULL, &alloc_size);
 	if (!data)
 		goto nodata;
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(alloc_size);
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
@@ -6169,19 +6172,19 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	int i;
 	int size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
+	size_t alloc_size;
 	u8 *data;
 
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
+			       gfp_mask, NUMA_NO_NODE, NULL, &alloc_size);
 	if (!data)
 		return -ENOMEM;
 
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(alloc_size);
 
 	/* Copy real data, and all frags */
 	skb_copy_from_linear_data_offset(skb, off, data, new_hlen);
@@ -6290,18 +6293,18 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	u8 *data;
 	const int nfrags = skb_shinfo(skb)->nr_frags;
 	struct skb_shared_info *shinfo;
+	size_t alloc_size;
 
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
+			       gfp_mask, NUMA_NO_NODE, NULL, &alloc_size);
 	if (!data)
 		return -ENOMEM;
 
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(alloc_size);
 
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
-- 
2.34.1

