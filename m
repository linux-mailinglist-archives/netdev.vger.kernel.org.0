Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6060D740
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiJYWju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiJYWjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:39:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145B113F60
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:39:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so429680pji.0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BscdQ/NsM4VDGC3CZQ9/meLTUO36dVnQu3w4n7vR5V4=;
        b=BCOQ7rQzsFYSHgPqBabqx0HObPPxl5QB944nSKiXYhjcWAiDuA+AUllIWaG/gwyzTR
         K2AgmbX2Dfp/ZMKmW2o4gXPuC4D7GczOBXjW1SMPyI/j8SSTri5BQO1MC+G3S83WUahC
         bfQmutxpGyZ0BNm2xxEl/2fZ3fNAmFKoPXYAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BscdQ/NsM4VDGC3CZQ9/meLTUO36dVnQu3w4n7vR5V4=;
        b=Nz4oK5rGpjeWlK8+WSBC4w/213PpTDLDntfg9BOfs0Ddi+rKDITEyRaYQcz7kDLoOu
         yE4gAzKFFqqUqXZSlxXsLRoiR1ybIfi1tX124uO8IozleWMxrBLUE4J6bTys5FjrywOk
         7neW2W5b1WZZ5TowOIPg3f+c92d+HXPmz0Zr4G0oa7noAMB2HQl0pfYiooxllEOq0QKm
         JXLmM9FSJQNC6f+QzMpdbkBuIN6WrKSXvyhT9mYhGDcMwreWqgg247vgfdWbwwcFjGZ4
         OEIxTjdxl/LIJe9D6Rcr2XFhcAyzoWsrmuaw55yKPe2ICdZzyaaD0g8EP03HR85J7yrb
         cmAQ==
X-Gm-Message-State: ACrzQf2BTkfNZAe4f/VhwyxkaHKIUleSk+xP6dlyrgIiPxQGn0tbODJ1
        WaVeUVqqmV278knrZHyc9VEEt4YTLIjDlg==
X-Google-Smtp-Source: AMsMyM74DPlCMXrxnF/Oyu68hwdZ0pFH11L3PRjOmRwT/gKA//op+e4vjaLbvVMoUbtkG0ofseX/cw==
X-Received: by 2002:a17:902:ef4c:b0:186:6399:6b48 with SMTP id e12-20020a170902ef4c00b0018663996b48mr30731926plx.128.1666737578430;
        Tue, 25 Oct 2022 15:39:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id hh14-20020a17090b418e00b0020a0571b354sm67794pjb.57.2022.10.25.15.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:39:37 -0700 (PDT)
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
Subject: [PATCH net-next v5] skbuff: Proactively round up to kmalloc bucket size
Date:   Tue, 25 Oct 2022 15:39:35 -0700
Message-Id: <20221025223811.up.360-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5465; h=from:subject:message-id; bh=+9qWqpVntNhyrU9ZfiOeejtoM8CjXlCTF78ImfFP37E=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjWGWmWfFCucZQp+qJMUtCzotc08S2Crxq47MB7eLP 0xt8ljWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1hlpgAKCRCJcvTf3G3AJnPsD/ 0Q/cvRjHQMasXbQXJ34ZvnmQbtuxiuSqGXoJx/1b1mx1EkWN09upKQSC7rdKxp9lLThxXnjJncZQSE fOcsH+DK0JbRyLTmuZ69/4IkfdS3fdkmQhhEL0r0BUdzeqZtCUQTj3ksJw3nUmjYlmHgZkt5HcOwNj qgQDKuxmZ0myro8PjcEgx+DSWlWxRwaD/l4ajF10zF+tQISrRH4RkG77hKLPFLCMUlZWKk5nZeqFAO 07iwHGv0bKXarshxjVT6tpFmd9kVZymJJ5EMrhUyozJ7HkemGLvFY0FoK9PxsOsJYHNVoPDgeRhiiM Gtirl8kHgLGIFY5+6r07+9lsTPxJGny5i3gLVWt77E0rat/K6X2YoLa23elnXpDRpYnt05ifKGfsFQ S/92UB2YJZNMWUhOsoSaCV849wOcyk+vfhKdv9JrHwxf+jfEGX7abhHeyNxGXV8nvE58jYvGKHOqcQ sTVmCp2xn0zBQfEwGPx2HhKPEM9EDE9cT7ZKNnaAP8vGUQPEfhVkPE3o97qslQxNF8f2pcpF1KyDSb s3YwWsjP6gLqFLiZCWH6U/i4NynU3DgnRTvz7TitIbUOjwhOIZa20dJP6oEJ3JXcwHY9++/t1e7HRs DSnA8BIJnEzgae68xUKPkPo3O07ZK8jb6mrmPmxpkFv5uZJTqmpj0QQWXzZA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221021234713.you.031-kees@kernel.org/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5: update comment (vbabka)
v4: https://lore.kernel.org/all/20221021234713.you.031-kees@kernel.org/
v3: https://lore.kernel.org/lkml/20221018093005.give.246-kees@kernel.org
v2: https://lore.kernel.org/lkml/20220923202822.2667581-4-keescook@chromium.org
---
 net/core/skbuff.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..21911e4c0aca 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -506,14 +506,14 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+	osize = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
-	/* kmalloc(size) might give us more room than requested.
+	/* kmalloc_size_roundup() might give us more room than requested.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	osize = ksize(data);
 	size = SKB_WITH_OVERHEAD(osize);
 	prefetchw(data + size);
 
@@ -1814,10 +1814,11 @@ EXPORT_SYMBOL(__pskb_copy_fclone);
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
 
@@ -1825,15 +1826,16 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 
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
@@ -6167,21 +6169,20 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
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
@@ -6286,22 +6287,21 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
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

