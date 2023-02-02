Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2D68873C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjBBS6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjBBS6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:58:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7303B3DB
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:58:11 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y125-20020a25c883000000b0086349255277so890489ybf.8
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8VHO+GQDTTptIyIkKxxaBfs2xV8urt7m1x/p/R1+WTA=;
        b=RonGC3uTj31BJmEL67HUYezC0Szr6RjQJeUnd/RXlc80yxMLhfIjCVg/PHm39v6xQl
         woaemFmMqRG9S50Fwdw2Mw4jwK/yy6OS13ChlAa0R8XhaPw0/L2OJ2TPRljPFL/FyG7K
         il+50cLywUl40ZoHcQrV27uf0wiSmSnuQhL75uuYRkqrWfuOIA5yKf394ycK8mu69xUI
         eO4JHbgyYtgBfDxzNeA++07abNK2Nd3SHagPM4cpiwNPvkjSucTgP0YW092uya3k0dsD
         P8BjBvchdoUBBPY9DKkHKZselObaxl3EUTG1oX407ghuy2je19In7FnS5sd0Des71Z/d
         3xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8VHO+GQDTTptIyIkKxxaBfs2xV8urt7m1x/p/R1+WTA=;
        b=Tda6vtAJ8s3oTaSdL2EyBR2RUCcmrqxjf5WDafvmOHSB+XzICckeMn6y5kpSiGg1ga
         YayL1+5f1kTyRfhSPGDpq3yiWsWlmMbUtD9YTVxFbQZHj1VxOzQcCpzS6aj3GCp7KYL1
         0OoXAQlDsWXXkQhQxM8ZeUCtthC36YEJsnc6lkf04sWuLbxvxKi2iXuaZxSAkuB/X6Oq
         sqY4/Fxltk4c/r9fHuH3ozz+PZGZEIN/SQfT9IAg1wZWkhhQeAJc/SSVKVCubtupebjc
         JETv+cn5tZkOsBD+Mlcz4mmHqwpgLSgXmv1E9I2ZaSGk3e/1c5TCmniIlIzSYPHGIJ5P
         sSOQ==
X-Gm-Message-State: AO0yUKV+raP9OlUJ8QxJojJVQr8MXlWzvlKbQ45PH2hS8xDxo4wX7t7u
        tEh0C3lvKoDad3W+oUCUjBkAiFH9tV17AA==
X-Google-Smtp-Source: AK7set9Oe6D6H9UCmqllq96MoMt2cq/s2i13RuqBA9bplSI3vAt1St4+KJTtqZImpe6D8IweRATB6jqGQ2OBZg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:889:0:b0:763:8e38:3fb3 with SMTP id
 e9-20020a5b0889000000b007638e383fb3mr471273ybq.547.1675364291125; Thu, 02 Feb
 2023 10:58:11 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:58:00 +0000
In-Reply-To: <20230202185801.4179599-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202185801.4179599-4-edumazet@google.com>
Subject: [PATCH net-next 3/4] net: factorize code in kmalloc_reserve()
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

All kmalloc_reserve() callers have to make the same computation,
we can factorize them, to prepare following patch in the series.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a82df5289208d69716e60c5c1f201ec3ca50a258..ae0b2aa1f01e8060cc4fe69137e9bd98e44280cc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -478,17 +478,20 @@ EXPORT_SYMBOL(napi_build_skb);
  * may be used. Otherwise, the packet data may be discarded until enough
  * memory is free
  */
-static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
+static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 			     bool *pfmemalloc)
 {
-	void *obj;
 	bool ret_pfmemalloc = false;
+	unsigned int obj_size;
+	void *obj;
 
+	obj_size = SKB_HEAD_ALIGN(*size);
+	*size = obj_size = kmalloc_size_roundup(obj_size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(size,
+	obj = kmalloc_node_track_caller(obj_size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (obj || !(gfp_pfmemalloc_allowed(flags)))
@@ -496,7 +499,7 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
 
 	/* Try again but now we are using pfmemalloc reserves */
 	ret_pfmemalloc = true;
-	obj = kmalloc_node_track_caller(size, flags, node);
+	obj = kmalloc_node_track_caller(obj_size, flags, node);
 
 out:
 	if (pfmemalloc)
@@ -557,9 +560,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * aligned memory blocks, unless SLUB/SLAB debug is enabled.
 	 * Both skb->head and skb_shared_info are cache line aligned.
 	 */
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
+	data = kmalloc_reserve(&size, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
 	/* kmalloc_size_roundup() might give us more room than requested.
@@ -1931,9 +1932,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6282,9 +6281,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6400,9 +6397,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
-- 
2.39.1.456.gfc5497dd1b-goog

