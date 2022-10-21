Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9113C608238
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 01:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJUXtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 19:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJUXto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 19:49:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829C3684E
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:49:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f23so3710305plr.6
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8BvgID2Mlp1LOZxFRRSQflp2rM/AmsvDLSJ/CidGjBk=;
        b=SipCePk/H4Ki27ow1q+KXNmCpWZJrBEfUawrVZrBsrf5flcWPAmOAbGluKxY12Iw/G
         bVtX/aW+LoBt1hQNS5jlDmWnBHFYNm84mGdiUKexkqYKjorbdT9UX3ZNLwsHmrTBQPvx
         YQ0XzkJG+Y1al9YY/M3wkrM4PXev+5RvO+WJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8BvgID2Mlp1LOZxFRRSQflp2rM/AmsvDLSJ/CidGjBk=;
        b=Oy5bWOA7Iji5vAfelXCx13bAiG4xHZv3hAO+3Tz73zR0Pxre6yWtxtYeKkmY06Lm6T
         OIM5fffiGVnEJK1OPnYUgKSFAu6tIAB/VgShAWfxws8OTElfTWUd4gcPBLAD3gL6UB6P
         7Fq6/QZe4eMnaVUzlK4yGQW/XMz1jg3lWxVj3UOS8VQs4Ezm3uNfljV521OGSwjcl3NT
         h01eGBh0/PibrcGldIgUVGIaCXwT3jkM4eYDJOAu3t/Hh0Y0zlRiOAB1NBts6MTD9haa
         9ZjI7bG5xmsEAgsQYtlvOcbLNsGr3FSIoHV/MhpyG4Sy+B4dr4iO15s5I8a8Y3xScEa7
         Vh2Q==
X-Gm-Message-State: ACrzQf3RqNLkg4TCOZH0lza/Vp16uNCz2NTDf4mwUKbuiT1pQykrQLV3
        JZx9lepNEsvojas7U7AwK4iAjw==
X-Google-Smtp-Source: AMsMyM4/tYwwOvCUIhmt8St2bueqQMk53krDt6Pxm+2ScI1STCM9fObrX/gRa0a5O/cIC5IEGbZKew==
X-Received: by 2002:a17:90a:e297:b0:212:dc30:7fed with SMTP id d23-20020a17090ae29700b00212dc307fedmr2146955pjz.90.1666396181692;
        Fri, 21 Oct 2022 16:49:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n21-20020a63ee55000000b00439d071c110sm13864837pgk.43.2022.10.21.16.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 16:49:40 -0700 (PDT)
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
Subject: [PATCH v4] skbuff: Proactively round up to kmalloc bucket size
Date:   Fri, 21 Oct 2022 16:49:36 -0700
Message-Id: <20221021234713.you.031-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5254; h=from:subject:message-id; bh=mBqppqtvL2/WoVg/f5+5q7YdX/5rZQrDaP9jvq5SNds=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjUzAQj4YnF7sfaNOXHp6h942Zp2pVBhavIZsxhufy hDpdcbqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1MwEAAKCRCJcvTf3G3AJlswD/ 9Y3r9CwzM02Mmy50J+PYZcLUgI4ibXyNuMNwupIkwi6KUI2W9fvMVSawsAkM5b/x+M1CWBOI0Y8Koe YtS6rlW11Th17D7xxNhqDh2MViFxJSFl9x1j5zs7OR895024SdmRLS/eT+GonMGTWn65cJoNCutmED 7tuxvlsf4mYqHJkQT/f6ewQ18P9JVGQhhu+aR1dFaiEAHE/2WuZflnqMP6crdv/DEfH2pc6kwKXjy/ 97qL1b2eKrjXbKQX3EydGxGUPRVD0ceddrFUGftCdz0J2H4sZHhFMCQRzbcCrJDNSiAAIVqdbyvrvI Jt+jYK4+8/K5qUobuq2jd85Yrp9gyfx7TX5TmMMWPq9ylU3VD8rCk3x//Wcf0+gJH8QzVFEbPas4OS XK8PyLEgI+uqZZhyHZCbo1hND4yu4lSZfeoRYp3nn3vyqOzaX6+CAPOJUD7+Yl4FSBZZa2EwDVkwKe FfNAS6xx79PI5Fvkyu2+hz6JPiOauASQTiFUe9wC/G+drcJFepnqlm8uPEqlCf02NGzyRrQUnkzDL7 rCEZs2bEF/laMbAR8K1Jq6vke2ET07GdEDOYiheaSE0SM6XfAq5rcn9hTReprIdJWKY6qJsB6986Qv nkOewbajlHJi/78QLUwtnxa+p096QwNqqhJpAAolsFrvQVy2XY5vLah1Snnw==
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
v4: use kmalloc_size_roundup() in callers, not kmalloc_reserve()
v3: https://lore.kernel.org/lkml/20221018093005.give.246-kees@kernel.org
v2: https://lore.kernel.org/lkml/20220923202822.2667581-4-keescook@chromium.org
---
 net/core/skbuff.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 651a82d30b09..77af430296e2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -508,14 +508,14 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+	osize = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
 	/* kmalloc(size) might give us more room than requested.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	osize = ksize(data);
 	size = SKB_WITH_OVERHEAD(osize);
 	prefetchw(data + size);
 
@@ -1816,10 +1816,11 @@ EXPORT_SYMBOL(__pskb_copy_fclone);
 int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		     gfp_t gfp_mask)
 {
-	int i, osize = skb_end_offset(skb);
-	int size = osize + nhead + ntail;
+	unsigned int osize = skb_end_offset(skb);
+	unsigned int size = osize + nhead + ntail;
 	long off;
 	u8 *data;
+	int i;
 
 	BUG_ON(nhead < 0);
 
@@ -1827,15 +1828,16 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 
 	skb_zcopy_downgrade_managed(skb);
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
@@ -6169,21 +6171,20 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 				    const int headlen, gfp_t gfp_mask)
 {
 	int i;
-	int size = skb_end_offset(skb);
+	unsigned int size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
 	u8 *data;
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
-
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy real data, and all frags */
 	skb_copy_from_linear_data_offset(skb, off, data, new_hlen);
@@ -6288,22 +6289,21 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 				       int pos, gfp_t gfp_mask)
 {
 	int i, k = 0;
-	int size = skb_end_offset(skb);
+	unsigned int size = skb_end_offset(skb);
 	u8 *data;
 	const int nfrags = skb_shinfo(skb)->nr_frags;
 	struct skb_shared_info *shinfo;
 
-	size = SKB_DATA_ALIGN(size);
-
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+
+	size = SKB_DATA_ALIGN(size);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
-
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
-- 
2.34.1

