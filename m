Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0298C6F110F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 06:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbjD1Ech (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 00:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjD1Ecf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 00:32:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F6983
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:32:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f808d894fso173780147b3.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682656353; x=1685248353;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=txQQnuNrdC+t0UyWbuXppDZC0EUzeemzesBJND4T1oQ=;
        b=Z+CirjM3PKqYExf2syY/+sit2BUDRlNWLjsCG0ePfgyg25nUdaYsbJ+9EN1AEVXizY
         hyEQVwrvyoQ6193vlKrB/hd9CfewxSMm+jcZspi9me37g/swS2VfHZLOoZ7NnA/T5FKf
         W4kWAGJY3Ikq0jMkt/NtH5Rs5O+5bC3zAqz2MCQWcMT7UuAsC/ZBiF36u7tJsG+gzLRt
         zSCRrPQoWMH79+ei/DiihgGfjmcUwvO8qOG94ioVTzp99nDq0vj2KucqKJQzkRKIpYUN
         gKZCZIElJvoL+g49Eh8QcRm9a98dJlhCKCxlZO+g+9fyzD2JVQ1ofi63iWejhNABdiB5
         codg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682656353; x=1685248353;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=txQQnuNrdC+t0UyWbuXppDZC0EUzeemzesBJND4T1oQ=;
        b=OKwR7W/18NBRshtrYWBMjOs7x+88uPQTJ1WC2gM2JJhJCKTT0dWciEAVd3LMqS68iS
         ym3lTFCPb09lnVGN/v/w4G4yY/EFwIpUUyGGGVtt9dqpL4DI7w3wzjdAbjGW7qmCldmK
         NWYB/6s8lNmEow3zGUfdCrkbUkaJU7RW5tk2lMfxaAkNOqB46CUMrjq9Xdy7UkqwIXDd
         KrAwmKdBG79/qb2t0iOb7UTkK14Xu2urJvZ1diYLttiMFVqVuIblDbfCvb8viU9w2msO
         N+3XvtPOfqtuqqFX+0laRlzsQFDa/UfQcMtVjJqV07dO9+qi41Ds+DN11UjZzHPuFKiW
         ZFgw==
X-Gm-Message-State: AC+VfDyjyZxRdtPhCsEgicm+2eCc7jzIH5GfsMhxL68bKsx0VbMepMQa
        ggFYChv2x+iHjDyy6GPi6xLiuEBW+zleSQ==
X-Google-Smtp-Source: ACHHUZ49I5uOoPlEhve8STSc6GZbZ/zD8GOjsHNd5J/DVzXQTxzDO1YcDpE9OGidwOjY1CCrhOODWMlPpX5fWA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:760d:0:b0:54f:a609:e88 with SMTP id
 r13-20020a81760d000000b0054fa6090e88mr2455524ywc.7.1682656353617; Thu, 27 Apr
 2023 21:32:33 -0700 (PDT)
Date:   Fri, 28 Apr 2023 04:32:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230428043231.501494-1-edumazet@google.com>
Subject: [PATCH v2 net] tcp: fix skb_copy_ubufs() vs BIG TCP
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx zerocopy
using hugepages, and skb length bigger than ~68 KB.

skb_copy_ubufs() assumed it could copy all payload using up to
MAX_SKB_FRAGS order-0 pages.

This assumption broke when BIG TCP was able to put up to 512 KB per skb.

We did not hit this bug at Google because we use CONFIG_MAX_SKB_FRAGS=45
and limit gso_max_size to 180000.

A solution is to use higher order pages if needed.

v2: add missing __GFP_COMP, or we leak memory.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Reported-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/netdev/c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Coco Li <lixiaoyan@google.com>
---
 net/core/skbuff.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2112146092bfe24061b24b9e4684bcc031a045b9..26a586007d8b1ae39ab7a09eecf8575e04dadfeb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1758,7 +1758,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	int num_frags = skb_shinfo(skb)->nr_frags;
 	struct page *page, *head = NULL;
-	int i, new_frags;
+	int i, order, psize, new_frags;
 	u32 d_off;
 
 	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
@@ -1767,9 +1767,17 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	if (!num_frags)
 		goto release;
 
-	new_frags = (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	/* We might have to allocate high order pages, so compute what minimum
+	 * page order is needed.
+	 */
+	order = 0;
+	while ((PAGE_SIZE << order) * MAX_SKB_FRAGS < __skb_pagelen(skb))
+		order++;
+	psize = (PAGE_SIZE << order);
+
+	new_frags = (__skb_pagelen(skb) + psize - 1) >> (PAGE_SHIFT + order);
 	for (i = 0; i < new_frags; i++) {
-		page = alloc_page(gfp_mask);
+		page = alloc_pages(gfp_mask | __GFP_COMP, order);
 		if (!page) {
 			while (head) {
 				struct page *next = (struct page *)page_private(head);
@@ -1796,11 +1804,11 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 			vaddr = kmap_atomic(p);
 
 			while (done < p_len) {
-				if (d_off == PAGE_SIZE) {
+				if (d_off == psize) {
 					d_off = 0;
 					page = (struct page *)page_private(page);
 				}
-				copy = min_t(u32, PAGE_SIZE - d_off, p_len - done);
+				copy = min_t(u32, psize - d_off, p_len - done);
 				memcpy(page_address(page) + d_off,
 				       vaddr + p_off + done, copy);
 				done += copy;
@@ -1816,7 +1824,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 
 	/* skb frags point to kernel buffers */
 	for (i = 0; i < new_frags - 1; i++) {
-		__skb_fill_page_desc(skb, i, head, 0, PAGE_SIZE);
+		__skb_fill_page_desc(skb, i, head, 0, psize);
 		head = (struct page *)page_private(head);
 	}
 	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
-- 
2.40.1.495.gc816e09b53d-goog

