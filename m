Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4004565F611
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbjAEVqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbjAEVqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651AF676E2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NvXYimBhkC9d0f/zXB3DUmNEVicwJZ07XethqUojHGM=; b=Mo74Isxg6Sr4vltDjX+oAMDu17
        H1OVN76kk1HywCbMBHQflKlZsd+tUK4n/HqaF/M9lPHOkTN+8C/TZz5dZF5MTR9MgYetwAN66rCpm
        pb+VgH7d2XmUpG+43YCbBpbMFI6AQ5lb+IjGdUFxrhfroGpJT4Q3TAPp8nhtDCFdILRC0/Jm6fvUY
        OPUrxv5D5ERSLg7zZKYAf+FhYnhVwhrbDBEabzmubIgf71OkWALdIEua2sdwgbky2ySCng5KX6dnl
        vJezFvIqgSnKJ1hNdZmvjeS478Gz6VwoWsa5qAXAetAPaR7834+TSyGohv7bDpeKqgMXUVBLwh4km
        gB/Q8YlQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnt-Q5; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 16/24] page_pool: Use netmem in page_pool_drain_frag()
Date:   Thu,  5 Jan 2023 21:46:23 +0000
Message-Id: <20230105214631.3939268-17-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
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

We're not quite ready to change the API of page_pool_drain_frag(),
but we can remove the use of several wrappers by using the netmem
throughout.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/page_pool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index c495e3a16e83..cd469a9970e7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -672,17 +672,17 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 	long drain_count = BIAS_MAX - pool->frag_users;
 
 	/* Some user is still using the page frag */
-	if (likely(page_pool_defrag_page(page, drain_count)))
+	if (likely(page_pool_defrag_netmem(nmem, drain_count)))
 		return NULL;
 
-	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
+	if (netmem_ref_count(nmem) == 1 && !netmem_is_pfmemalloc(nmem)) {
 		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 			page_pool_dma_sync_for_device(pool, nmem, -1);
 
 		return page;
 	}
 
-	page_pool_return_page(pool, page);
+	page_pool_return_netmem(pool, nmem);
 	return NULL;
 }
 
-- 
2.35.1

