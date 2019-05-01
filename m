Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4095D1097E
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfEAOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zsx0PPOEbJRtwTUIPCdU9qXedBlMcjPmxgmnwsbOnds=; b=dJ8uRkRdMoloVT3qU6pmoUAfr
        e+M9Di05sKc1xtaBSWhwPZ0Di/sx7dSFfuiKiVAj3jPSsh2pVF6mdPFHK2VLWeIu+5IAxwUbzumzl
        huSjlxnHVSBvRXNtT2jXqHAy/tOp+J3oEZq4teeALh0dx/bsUB9SWW1QbY/s2ca/isP685E6g906W
        gCE7cOvdMsB5ms/aplddpVr5uRDjXqvDFOPykYAo7ZYoJlAdp/i+ru8LqIsJIFiGV4KW0gR3mME1Y
        O+T0Qq6XcSCvLAP0WROdQlBDiST/gd6JZI8o9zhRAM4WlwP0MYUxXJdRMjU9xfqKIf835o1c+VYIp
        qod2SWrhg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTk-00025p-5l; Wed, 01 May 2019 14:45:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 5/7] net: Rename skb_frag page to bv_page
Date:   Wed,  1 May 2019 07:44:55 -0700
Message-Id: <20190501144457.7942-6-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

One step closer to turning the skb_frag_t into a bio_vec.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 12 +++++-------
 net/core/skbuff.c      |  2 +-
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9c6193a57241..a75e85226bea 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -315,9 +315,7 @@ extern int sysctl_max_skb_frags;
 typedef struct skb_frag_struct skb_frag_t;
 
 struct skb_frag_struct {
-	struct {
-		struct page *p;
-	} page;
+	struct page *bv_page;
 	__u32 size;
 	__u32 page_offset;
 };
@@ -378,7 +376,7 @@ static inline bool skb_frag_must_loop(struct page *p)
  *	skb_frag_foreach_page - loop over pages in a fragment
  *
  *	@f:		skb frag to operate on
- *	@f_off:		offset from start of f->page.p
+ *	@f_off:		offset from start of f->bv_page
  *	@f_len:		length from f_off to loop over
  *	@p:		(temp var) current page
  *	@p_off:		(temp var) offset from start of current page,
@@ -2061,7 +2059,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * that not all callers have unique ownership of the page but rely
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
-	frag->page.p		  = page;
+	frag->bv_page		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
 
@@ -2849,7 +2847,7 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
  */
 static inline struct page *skb_frag_page(const skb_frag_t *frag)
 {
-	return frag->page.p;
+	return frag->bv_page;
 }
 
 /**
@@ -2935,7 +2933,7 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
  */
 static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
 {
-	frag->page.p = page;
+	frag->bv_page = page;
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b689e13be808..357b6b2fc58b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3198,7 +3198,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			__skb_frag_ref(fragfrom);
-			fragto->page = fragfrom->page;
+			fragto->bv_page = fragfrom->bv_page;
 			fragto->page_offset = fragfrom->page_offset;
 			skb_frag_size_set(fragto, todo);
 
-- 
2.20.1

