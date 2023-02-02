Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0BC68873A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjBBS6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjBBS6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:58:11 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248A62A989
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:58:10 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4ff7c6679f2so29087837b3.12
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkepuJ2zoHdPzygKI1n27HnD325lkrHrRjgMMEPWapE=;
        b=q/W+3bFKPT3g+bygipMtMesVcowRidKkCMo5PWZzy1KTK4SBsocVdsYasyrnjJX8CE
         mPsjUzd9mJ26OjvCuAgFZoM9gzCYxEjfR/wWK83W/iKnk3jwFE2aWY2yCPrjF+0e8CM0
         DapjsXiSQxbMRzQ0OnHUEIBlIrEVVFNhHtcJrIDofdcJ8Tv6oBjlLJv5s26G1wJnjCnA
         8XA2ZypG8H7LdZgKqMpwEtL8RjeW1JKVgR4uEx2uaywkciF59eBFw28msJen6FZ2JuVV
         UIOS/xXHoW/4HhT5J6flJy4S0CkDjmigdEFQZWeRyiJTHBJF/a04/fwbieFEWwM3nF8x
         x0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkepuJ2zoHdPzygKI1n27HnD325lkrHrRjgMMEPWapE=;
        b=kpyWICn2HTtBcu3qU7aeUSqoyT5nJOoJQDq89kXHdlfPPY/BgICvUfyz3q7e8Msp04
         ptvfiKAQE26W3Hk0i4f1w6nzBdgjeWPmfF4bzdvf/Ec4CKnewzOcgDMPtwCjAnPbjdpu
         2EsN1uZ1UuQgOgIjoGTcoauAxfC6n0SJ7VIz+EHwuvzQSFgHtFxjy8nET7QhNs1cDedA
         aScT++zOjRGhw8ZIob9iEEnfNZQnzC6I9nWYxlz6/oxU/GZpd9/oOy9Yms9IbemUcqcF
         RO/8fHS1CFyqVDPhH7o9Tbw5wcI69e7YCYirGZRme4G8+9IZSMK+6IJYK0JE7Is655H5
         skhw==
X-Gm-Message-State: AO0yUKUh9oQPXoCt+lkct4toF/4gluqFykCBEqSfRkQBdEQaqAMOxm/E
        op5DlafNUsoC0gJM5puoIMia/jXyLlJz6Q==
X-Google-Smtp-Source: AK7set/X7P6HQRE4XpVbshE9a9X3A6wWuTvOL1gVxnlutuE5os7JSE4BPap+IMWP/Eklq2w9HzfT7Hwa/M+jcQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9191:0:b0:855:fafc:7419 with SMTP id
 w17-20020a259191000000b00855fafc7419mr2ybl.0.1675364286187; Thu, 02 Feb 2023
 10:58:06 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:57:59 +0000
In-Reply-To: <20230202185801.4179599-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202185801.4179599-3-edumazet@google.com>
Subject: [PATCH net-next 2/4] net: remove osize variable in __alloc_skb()
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

This is a cleanup patch, to prepare following change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b73de8fb0756c02cf9ba4b7e90854c9c17728463..a82df5289208d69716e60c5c1f201ec3ca50a258 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -533,7 +533,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 {
 	struct kmem_cache *cache;
 	struct sk_buff *skb;
-	unsigned int osize;
 	bool pfmemalloc;
 	u8 *data;
 
@@ -559,16 +558,15 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * Both skb->head and skb_shared_info are cache line aligned.
 	 */
 	size = SKB_HEAD_ALIGN(size);
-	osize = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
+	size = kmalloc_size_roundup(size);
+	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
 	if (unlikely(!data))
 		goto nodata;
 	/* kmalloc_size_roundup() might give us more room than requested.
 	 * Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	size = SKB_WITH_OVERHEAD(osize);
-	prefetchw(data + size);
+	prefetchw(data + SKB_WITH_OVERHEAD(size));
 
 	/*
 	 * Only clear those fields we need to clear, not those that we will
@@ -576,7 +574,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * the tail pointer in struct sk_buff!
 	 */
 	memset(skb, 0, offsetof(struct sk_buff, tail));
-	__build_skb_around(skb, data, osize);
+	__build_skb_around(skb, data, size);
 	skb->pfmemalloc = pfmemalloc;
 
 	if (flags & SKB_ALLOC_FCLONE) {
-- 
2.39.1.456.gfc5497dd1b-goog

