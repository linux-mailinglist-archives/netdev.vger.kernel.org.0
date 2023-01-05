Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2795565F612
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbjAEVq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbjAEVq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59056676D8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EeQYJMHII3fp3OKocboX4WAkN9RPKcuLop98P7fQXtk=; b=AZ1Y1AH+/uF+RM6PRqrmUXQoZc
        M/LZru31cC6BIHXqNZwO7eZ6SIgOirGp4tBiqTTCVW9LpBMEyi1jD/mCN0J2NvDkJGFY0gZYUd9Ep
        9SRGENxcY01USdBXt1gp0sV0sSByQ6IGKsSWxF+mGU/FTFnRTww45hNq3IOBzI4UfHAVaNZDodTKq
        IdGnOcfx+8q37FpU4C0YPbg6Shd3hgacIC4xmkNSush4JxHf2jppdhn/Gil00V4EIGLmVu8qBmNTr
        fXJUVufSPWdp35WAOuEM8NlndUTHdwrtYmtgG6t3lvkBo/igKrOstwLXz/M4zEcSZ+Flj58mCNjwi
        Zt+j5CCw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnF-4u; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 11/24] page_pool: Convert page_pool_empty_ring() to use netmem
Date:   Thu,  5 Jan 2023 21:46:18 +0000
Message-Id: <20230105214631.3939268-12-willy@infradead.org>
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

Retrieve a netmem from the ptr_ring instead of a page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

