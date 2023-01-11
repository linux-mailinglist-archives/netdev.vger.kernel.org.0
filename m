Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37B56652C2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjAKEWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjAKEWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DBA657F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=rcz4ILIU0y+s+VzEhxoTryrk4XlkMDYpJ2m+mT7d/Ps=; b=EUgLfOhtF2Ji1vKd2kCpKbkGL8
        LsLmFriJbXWCq8uAJGKzj7c3sod/O5HFYHMvO6WAvZn3T1wc4KAs+XbM6gZrxv1t8cQVcV+6K1Wes
        9hNEDSCSFDvY4td4q3imcYF9Yy58ZUd3ODMJu4dDSGecxLl6BX9CHuBFoVe/Sp14xrYrfkORLvKav
        XBQNfLe2qUNtETVU/GkBQSpQ2zNxt0r+0FT3s7sc1kO1mwzv8XrLeFsTAXqtdptoRl0WPWEnbI0eN
        v0JS4BtcZ1Mz32S9AyNwzvoPDLlboEnpirvMCzt/SmOD/xKVA3XDT+5GvdvMttalJku8ZE2C4rF3O
        6vVUUX6A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFScz-003ny2-1J; Wed, 11 Jan 2023 04:22:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 11/26] page_pool: Convert page_pool_empty_ring() to use netmem
Date:   Wed, 11 Jan 2023 04:21:59 +0000
Message-Id: <20230111042214.907030-12-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retrieve a netmem from the ptr_ring instead of a page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/core/page_pool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e727a74504c2..0212244e07e7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -755,16 +755,16 @@ EXPORT_SYMBOL(page_pool_alloc_frag);
 
 static void page_pool_empty_ring(struct page_pool *pool)
 {
-	struct page *page;
+	struct netmem *nmem;
 
 	/* Empty recycle ring */
-	while ((page = ptr_ring_consume_bh(&pool->ring))) {
+	while ((nmem = ptr_ring_consume_bh(&pool->ring)) != NULL) {
 		/* Verify the refcnt invariant of cached pages */
-		if (!(page_ref_count(page) == 1))
+		if (netmem_ref_count(nmem) != 1)
 			pr_crit("%s() page_pool refcnt %d violation\n",
-				__func__, page_ref_count(page));
+				__func__, netmem_ref_count(nmem));
 
-		page_pool_return_page(pool, page);
+		page_pool_return_netmem(pool, nmem);
 	}
 }
 
-- 
2.35.1

