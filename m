Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA490539341
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiEaOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiEaOoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:44:11 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31FD68E1B3;
        Tue, 31 May 2022 07:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=iuuhYKTTPiOzGziHSP
        rXCTcTDHlPtwy5gFXzjZU5qSA=; b=GUNYURUsZZ0yE8K1wk1KTamdGwDV0JGpYD
        KxAAJz5Dq5xtwbUOCNY0qSPu/kFVUgMsAC/ms06Mz2u6e+/hp8Wt6MQVrfDSvFLe
        dIP5Y7x+pG2sjgJIGkJd2aUovlsjzNv30gL9MietYXeMFKwk0+vQIyBu4IN2bBbP
        lbnmCXMI0=
Received: from localhost.localdomain (unknown [171.221.150.250])
        by smtp7 (Coremail) with SMTP id C8CowAC32aCRKZZiz_PwFQ--.58649S2;
        Tue, 31 May 2022 22:43:35 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     akpm@linux-foundation.org
Cc:     kuba@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, netdev@vger.kernel.org,
        Chen Lin <chen45464546@163.com>
Subject: [PATCH v3] mm: page_frag: Warn_on when frag_alloc size is bigger than PAGE_SIZE
Date:   Tue, 31 May 2022 22:43:08 +0800
Message-Id: <1654008188-3183-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20220530130705.29c5fa4a5225265d3736bfa4@linux-foundation.org>
References: <20220530130705.29c5fa4a5225265d3736bfa4@linux-foundation.org>
X-CM-TRANSID: C8CowAC32aCRKZZiz_PwFQ--.58649S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr17tw1fGFWkur17WF4rXwb_yoW8Kry8pF
        W7Cr15ZFs0qwnFkw4kJw4vyr45A398WFWUKrWFv3s09w13Gr1093s8KrWjvFyrAr10kFy7
        tF4Yyw13ua1jvaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMBTnXUUUUU=
X-Originating-IP: [171.221.150.250]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBzhcSnmI0UtCdCQAAsV
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_alloc_frag->page_frag_alloc may cause memory corruption in 
the following process:

1. A netdev_alloc_frag function call need alloc 200 Bytes to build a skb.

2. Insufficient memory to alloc PAGE_FRAG_CACHE_MAX_ORDER(32K) in 
__page_frag_cache_refill to fill frag cache, then one page(eg:4K) 
is allocated, now current frag cache is 4K, alloc is success, 
nc->pagecnt_bias--.

3. Then this 200 bytes skb in step 1 is freed, page->_refcount--.

4. Another netdev_alloc_frag function call need alloc 5k, page->_refcount 
is equal to nc->pagecnt_bias, reset page count bias and offset to 
start of new frag. page_frag_alloc will return the 4K memory for a 
5K memory request.

5. The caller write on the extra 1k memory which is not actual allocated 
will cause memory corruption.

page_frag_alloc is for fragmented allocation. We should warn the caller 
to avoid memory corruption.

When fragsz is larger than one page, we report the failure and return.
I don't think it is a good idea to make efforts to support the
allocation of more than one page in this function because the total
frag cache size(PAGE_FRAG_CACHE_MAX_SIZE 32768) is relatively small.
When the request is larger than one page, the caller should switch to
use other kernel interfaces, such as kmalloc and alloc_Pages.

This bug is mainly caused by the reuse of the previously allocated
frag cache memory by the following LARGER allocations. This bug existed
before page_frag_alloc was ported from __netdev_alloc_frag in 
net/core/skbuff.c, so most Linux versions have this problem.

Signed-off-by: Chen Lin <chen45464546@163.com>
---
 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3d..ffc42b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5574,6 +5574,15 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 	struct page *page;
 	int offset;
 
+	/*
+	 * frag_alloc is not suitable for memory alloc which fragsz
+	 * is bigger than PAGE_SIZE, use kmalloc or alloc_pages instead.
+	 */
+	if (WARN_ONCE(fragz > PAGE_SIZE,
+		      "alloc fragsz(%d) > PAGE_SIZE(%ld) not supported, alloc fail\n",
+		      fragsz, PAGE_SIZE))
+		return NULL;
+
 	if (unlikely(!nc->va)) {
 refill:
 		page = __page_frag_cache_refill(nc, gfp_mask);
-- 
1.7.9.5

