Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9D6652B5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbjAKEWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjAKEWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AEC7646
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QoaAG2kAgAPkNcCiK7t3f4EkfcuvVTfPdM/eyK8Bayk=; b=LU13WSn36J9OyqWY+IaUSE1Z1a
        Wievx5eQ/zQzEuLLnrGjXadW9SAJKWjA/DuQQCaUb3MVIhvqejVrFFFhudRXk4fXO2VNATzrniZA9
        a0Sjzs/o5e7HT8brbzoy9sYz75dwKQtKY0M9RywnOjCKFqTpe2voPwqa61J9NGOLiBTFDikR82UIO
        8lzQRpz4gCh1sA6sany3BfM5AZSwYjpoX7lUeRLHaVvuj3tVCE6olVaWGA/Hj/N0OG8NcUcjR8b4N
        +B5yIlhOzDqUlINl/7yiVNKasqCb57RkNbj59aBCO7UQNaRPgwRcbGiIPTax2VE1kKtCS8sdoaEWL
        IqPDGWXg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFSd0-003nz7-A7; Wed, 11 Jan 2023 04:22:18 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 23/26] net: Add support for netmem in skb_frag
Date:   Wed, 11 Jan 2023 04:22:11 +0000
Message-Id: <20230111042214.907030-24-willy@infradead.org>
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

Allow drivers to add netmem to skbs & retrieve them again.  If the
VM_BUG_ON triggers, we can add a call to compound_head() either in
this function or in page_netmem().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/linux/skbuff.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..4b04240385cc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3346,6 +3346,12 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
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
@@ -3454,6 +3460,11 @@ static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
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

