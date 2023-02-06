Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091FC68C4D9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBFRbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBFRbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:31:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEBD19F07
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:31:09 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so12119277ybl.0
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=49y3rrQyPj+ZDUDqhU9vr/v8UwYQu0sYpMXvrnF3QeU=;
        b=hOyJ1U2t1Bm3NbSYgs1jTzMuFqLaWvJD/PTR5dSdwIKFCN+sw4A9aXUQIbVtLhycbm
         Nl0NI/pvsVkHw6+GZGp5fSfNm8DUFdTcq+zYDfCKB/c+h5wnImaCUCTPcSmEY79Ur+O8
         eDnUXP6UwK4HDWpiPi4i0PCmN8veLC5TbJfITNw0p2u1XjzSiDlPKwuD8bBhgYiHg9a3
         eZweKsR4hbVshv2vXyMViaVFiyAIRo3VAhXch0Nf+fslgKEALLvi0kXSMt5SPQbTXURy
         siMFRvbU4sZwmLnodHVGFI/VQHHUjcyBvNsJmHzm8EyOcBFpUpopoV2miH4+CRRI2fkH
         nkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=49y3rrQyPj+ZDUDqhU9vr/v8UwYQu0sYpMXvrnF3QeU=;
        b=V0M3jz5WU9LXtaX1g/L4qKltQTNuLZdMb8lv2E5pV7gMh2roqZ2oLuHlEDOa+pMwHR
         eh7lIyFuIOoyHXoCeVUymO4jqGwdWPQbpvkKN1clGkoDCTjuPkGGVfDA8OeB4Z797Rtv
         hMsWIBTcj1QxlGeddYeVkjmEQn4tsfsrAw9uL3OFDwchLJysUd8OAKqnNc0PiRsXTDUv
         +7O++tr9xcaM6GoPNrzMktFR0xq5xiqu9O2O/l8pmiml1WJbBkSE8muEFisUk6a9x2+x
         QV0vHjynHCxOUnnqFiCYWUZE7E0oMuiMdU7Pwp4dWFFHEdd88HotaUJ91TTT8s3dHqcN
         hThQ==
X-Gm-Message-State: AO0yUKXQYcpd8h45U54xnOO1OkqO5vF8AXYBt5JQTN3CiqoZjlJHE6qv
        zrIJ7TU7zfrl00uX4M3ZWlkjjL2iwwDssg==
X-Google-Smtp-Source: AK7set+gEoxp3S858yQBoMN+HkVTyCuPXYchRPSOAUz11U3oZjVun/BTkv/P6x2XPKBc5Tjc/hRdJFZoZFl81w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1813:b0:869:a08:a52f with SMTP
 id cf19-20020a056902181300b008690a08a52fmr42047ybb.354.1675704668485; Mon, 06
 Feb 2023 09:31:08 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:31:01 +0000
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230206173103.2617121-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206173103.2617121-3-edumazet@google.com>
Subject: [PATCH v2 net-next 2/4] net: remove osize variable in __alloc_skb()
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

This is a cleanup patch, to prepare following change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/core/skbuff.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4abfc3ba6898d89f4df97bf5f069b291dd5e420f..333f793f9cdba9946e0bd014e9a0f18bae20771d 100644
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
2.39.1.519.gcb327c4b5f-goog

