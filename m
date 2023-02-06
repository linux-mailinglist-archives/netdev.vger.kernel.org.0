Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B992968C4DD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjBFRbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBFRbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:31:14 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6059D2
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:31:10 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id e5-20020a056214110500b0053547681552so6127940qvs.8
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+U430XvaQd6ywNJ0mxNiIZ4Q3ScjXCNbOxPuWt0PHM=;
        b=YksWyvUaSZyDfoOU/qEUI4uXSZCb+flysO7FCKnFU+gE8ro8ISPsQtEHvjYo2BcV7S
         72rpB7iZERfMi1vVaKo6fNY7Fsgsyv3rqWGaAHI+MB9sVdEPIjBSdi9TDTThkVP9Tnmj
         FXWXkUHGKbxd/Z/i7FZcIaNpBHwUzNWcoeJb9AcpHHYd33bBgEAWquOTovehx3jsRtM+
         2vt4R0JF7YGwkqoQL0DiTo/+sYQ0KQhANllhmwhtaJ6Mbllekrt3wpjjN61B5Isbbd1v
         qgHS0/HuFAzDz5i9j7K2r4ruesIEW1mwZUzYlJ0FLnDVsv3J2sh54S/E2vZwctF4vVx5
         orlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+U430XvaQd6ywNJ0mxNiIZ4Q3ScjXCNbOxPuWt0PHM=;
        b=UI6fITTVGadS3/aGoVGEleyh6twVwO0L9v37XTtwXTv+qu/1u6FOf43aavF1xAMar4
         cgrSBRNPOgAY60Neh/eDM9K8F4yqXt0BRSimhPOIWpFsvrgFQ+m2lY23yLQkItqBtxL4
         AvLL3UkLQQRN3GKmcXrcgTX0px+VBX945gevGYfoH+vMmYC0RTpAjqIiPOAwNi6grg8q
         n9JAta6RHplocXIBSEAGXCbwAsrnzkDVGZCe6EF5j8unNP9mR65OPPQmh4HxX5PwWygT
         8nKk6eCAxnQH9QFRBwfYQHq/VCJiogpToop7IvI44X7LD89Acy+M46fyyFm7Xh4hE1cG
         lmqA==
X-Gm-Message-State: AO0yUKUXqwtjIbFmWSwENLw2yN+cJtWltlVnZMy9Nh6pHealgthByT19
        wlBaoMGWlZ6IKjO1jqM+XTcEAffqyv1a1g==
X-Google-Smtp-Source: AK7set/dwWCMcRD1gm6r9TIp1HGbFgINRX/xxN+jZGbgWRELQfJ884AdaC5HaMYVRZV5z+JMg5KmRZdH+kdJbQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:1995:b0:3b8:680a:40bd with SMTP
 id u21-20020a05622a199500b003b8680a40bdmr18223qtc.44.1675704670099; Mon, 06
 Feb 2023 09:31:10 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:31:02 +0000
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230206173103.2617121-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206173103.2617121-4-edumazet@google.com>
Subject: [PATCH v2 net-next 3/4] net: factorize code in kmalloc_reserve()
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

All kmalloc_reserve() callers have to make the same computation,
we can factorize them, to prepare following patch in the series.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/core/skbuff.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 333f793f9cdba9946e0bd014e9a0f18bae20771d..c1232837cd0cb3befce0262fb8fda20272a26d45 100644
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
@@ -1933,9 +1934,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6283,9 +6282,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	size = SKB_HEAD_ALIGN(size);
-	size = kmalloc_size_roundup(size);
-	data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
@@ -6401,9 +6398,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
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
2.39.1.519.gcb327c4b5f-goog

