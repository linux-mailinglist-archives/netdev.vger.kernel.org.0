Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0D63E328
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiK3WJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiK3WI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86092950DA
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nlPeMtORpr6+hFy3RU85lPdDgtB6HfYh05fUjnke2sY=; b=OYGXvLcMfCDTR1Yg5QJsgRr95s
        UDWFqlJveoL80vS0DnQ6dlAM7v6kPJHJFmCuIRSfGqhB1yiuSAkGX10+RHs54a3Cn5tRL32bnjgKY
        ebCIiwqhtd87TcTJDwvZvvsM+SRE2oC7OqRJoE55xyaOcnNdP4wym76XshSYdxDY+NJMYJvfYSpk3
        y9UbgeA0Sm0Q1su4P1KsqfG8lNKKQJmknsFMiEjG/6vL89EtuNE9xEHjH36A7BbVQNTvLLPjlQiV1
        HWKt7Ip/TqLkkeu6jz97MJcJEb68+V/mllSqamGb/9IkUpZOEvGDjqH0m6Z1oeloyVYg+kuF8shup
        JkQJuIbg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVm-Uy; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 16/24] page_pool: Use netmem in page_pool_drain_frag()
Date:   Wed, 30 Nov 2022 22:07:55 +0000
Message-Id: <20221130220803.3657490-17-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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
index c89a13393a23..39f09d011a46 100644
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

