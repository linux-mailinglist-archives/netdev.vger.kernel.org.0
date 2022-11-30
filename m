Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FF563E312
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiK3WIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiK3WIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FEC52896
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=v8XZwj+qrPdVX2joAsiJ+16x3YDJToWBKe9JDnAu2v0=; b=CTMRjQjVAmOAztNSb86YHDpcSe
        jueHTUGiFOpQ+IAD0kbYeWdDpANdxW3zYimtYphn7Tlfk6/vQP27d4lg8BMsCEMWW+6Ix8NMlN9CX
        Z5PeuVwcpM+19U1V9QPwlSVgzHJQtl+snXGLnNcAOiQ5ZHYFhohObGRIsjO/NVo2+F73mAR3/Agmi
        NNXYRNPyde4sGEFDn+2S2DRn0vZ6nlB4S+OVzEFaeq5WjyxLJxQ4W2TUAEe/PjGMZvoy4CP2RVNkM
        +zy0CjkbLQxtwOXcerQ0HR7/G0oTpjQWbeuQi9ZxwlMIsh2IDQFD6Gsg0PBz9LG097G5WRKvOc+AC
        dTq4CSkA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFO-00FLWA-6g; Wed, 30 Nov 2022 22:08:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 19/24] xdp: Convert to netmem
Date:   Wed, 30 Nov 2022 22:07:58 +0000
Message-Id: <20221130220803.3657490-20-willy@infradead.org>
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

We dereference the 'pp' member of struct page, so we must use a netmem
here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/xdp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 844c9d99dc0e..7520c3b27356 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -375,17 +375,18 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		  struct xdp_buff *xdp)
 {
+	struct netmem *nmem;
 	struct page *page;
 
 	switch (mem->type) {
 	case MEM_TYPE_PAGE_POOL:
-		page = virt_to_head_page(data);
+		nmem = virt_to_netmem(data);
 		if (napi_direct && xdp_return_frame_no_direct())
 			napi_direct = false;
-		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
+		/* No need to check ((nmem->pp_magic & ~0x3UL) == PP_SIGNATURE)
 		 * as mem->type knows this a page_pool page
 		 */
-		page_pool_put_full_page(page->pp, page, napi_direct);
+		page_pool_put_full_netmem(nmem->pp, nmem, napi_direct);
 		break;
 	case MEM_TYPE_PAGE_SHARED:
 		page_frag_free(data);
-- 
2.35.1

