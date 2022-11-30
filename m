Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7B63E311
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiK3WII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiK3WIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2130F54341
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0pEHOtsVyrt2uy64MIziwQ+z4DkQ3BQz3gapa10bEAk=; b=FV9m59ZLLmonxbZodQwy/1V+DG
        sp5RKJnRn2xVXD954BBVMq6nItUlAlmCP6Th9l1yDzP2o4//MgKL4DoUx9tcIWtTQ1nCtGZujwx52
        zd2sNnr+CPeXINX1ahXYO+Bv3OCtT6oQqPVADwluv8wTylDLVODSLC76+1OCWSwcMSazlyQwHRm/1
        Q6Y4A34fJvpcn0oryqFccot8+5coDn049YKQJ6mdMyaMeOoHAmJ2Nych4sR5o8LJBhxxC1eKDcGx2
        DONEpcngxIePq61eTw+xfjGq8CeoxKVlWe9Mbu0uXORFcT38R7v/Zl4CXCFXblIPF68rIZ75aXcIb
        fCWa+p7g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFP-00FLWw-30; Wed, 30 Nov 2022 22:08:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 23/24] net: Add support for netmem in skb_frag
Date:   Wed, 30 Nov 2022 22:08:02 +0000
Message-Id: <20221130220803.3657490-24-willy@infradead.org>
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

Allow drivers to add netmem to skbs & retrieve them again.  If the
VM_BUG_ON triggers, we can add a call to compound_head() either in
this function or in page_netmem().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4e464a27adaf..dabfb392ca01 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3345,6 +3345,12 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
 	return frag->bv_page;
 }
 
+static inline struct netmem *skb_frag_netmem(const skb_frag_t *frag)
+{
+	VM_BUG_ON_PAGE(PageTail(frag->bv_page), frag->bv_page);
+	return page_netmem(frag->bv_page);
+}
+
 /**
  * __skb_frag_ref - take an addition reference on a paged fragment.
  * @frag: the paged fragment
@@ -3453,6 +3459,11 @@ static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
 	frag->bv_page = page;
 }
 
+static inline void __skb_frag_set_netmem(skb_frag_t *frag, struct netmem *nmem)
+{
+	__skb_frag_set_page(frag, netmem_page(nmem));
+}
+
 /**
  * skb_frag_set_page - sets the page contained in a paged fragment of an skb
  * @skb: the buffer
-- 
2.35.1

