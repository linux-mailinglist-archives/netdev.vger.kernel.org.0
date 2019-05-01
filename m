Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0010474
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfEAESD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfEAESD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=no5UTCYraUPjuk67CpLvZaQSLccORNwCKVypmwSia6o=; b=c/ZvP8yT6xWEFeWRFualbHCyG
        sfYQg66KEiVQ9fLghhw1tzV7g1fQgBNUSYAtRnOfk8DsW+a4Io0p6Q9fSbthhbrmog+t4j1oKfgcf
        O4HVxnqo1YgzAkkXtuHYSOoGNBpU6a0J0JZWUKHhGR5rh8lJUINfLjX1S3gP4+4x+nmrux+SBq40i
        /O2kGR2vwq2lAgg6aNKqqjxCrjxpQHJHPqtlxKa39Jb5K+PocpX6pJR7lyg9TQXkYElmW4ynHgMe4
        RujqFJatKl/+KVbuBZ82zrRfOUP7QUjQRXQZrWkFOQuZtGF0N014bIoKA9Vg7lx28WASE60f2natr
        zdUAlBpiw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggz-0002Gl-KO; Wed, 01 May 2019 04:18:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 5/5] net: Rename skb_frag page to bv_page
Date:   Tue, 30 Apr 2019 21:17:57 -0700
Message-Id: <20190501041757.8647-7-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
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
index bc416e5886f4..1fc0592d6a06 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -316,9 +316,7 @@ extern int sysctl_max_skb_frags;
 typedef struct skb_frag_struct skb_frag_t;
 
 struct skb_frag_struct {
-	struct {
-		struct page *p;
-	} page;
+	struct page *bv_page;
 	__u32 size;
 	__u32 page_offset;
 };
@@ -379,7 +377,7 @@ static inline bool skb_frag_must_loop(struct page *p)
  *	skb_frag_foreach_page - loop over pages in a fragment
  *
  *	@f:		skb frag to operate on
- *	@f_off:		offset from start of f->page.p
+ *	@f_off:		offset from start of f->bv_page
  *	@f_len:		length from f_off to loop over
  *	@p:		(temp var) current page
  *	@p_off:		(temp var) offset from start of current page,
@@ -2062,7 +2060,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * that not all callers have unique ownership of the page but rely
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
-	frag->page.p		  = page;
+	frag->bv_page		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
 
@@ -2850,7 +2848,7 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
  */
 static inline struct page *skb_frag_page(const skb_frag_t *frag)
 {
-	return frag->page.p;
+	return frag->bv_page;
 }
 
 /**
@@ -2936,7 +2934,7 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
  */
 static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
 {
-	frag->page.p = page;
+	frag->bv_page = page;
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12b60fdcff46..ee948851fd48 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3194,7 +3194,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			__skb_frag_ref(fragfrom);
-			fragto->page = fragfrom->page;
+			fragto->bv_page = fragfrom->bv_page;
 			fragto->page_offset = fragfrom->page_offset;
 			skb_frag_size_set(fragto, todo);
 
-- 
2.20.1

