Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBA70F96
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbfGWDIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387879AbfGWDIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HeORrwa9si66ZvlpwCeBZYgy7/TGUvA9hOEOdycgqq0=; b=ZL+QTXSxv+/Qdz2k2OodAI8ey5
        iJrPDMcrZ/Q7gm3lxFApKTJNcC4k4WnpiJQxhe5YZTiDRQiGTtnWNH76fQ1d3iDb+C0h3BH6xNdGM
        fLvL7oYU9WPdp8LKuVZJpTVxa4CnOreJU3ZkcLVNnKLEDDl9p4rV8kSciOhmXi+siBUTK8J038wUZ
        cv5yLPA5zrHP8tNPmWK4mm7lrtpJF7XnP7S8a/alhEu7clNYPx3H2ez5NWY6mnSfcRnuOI4fWyRqN
        kgXdMgounF4kld04PnMClkKEQ5xofRibRJXgfDk8XA3dGBhK29KDBqU3q89wBg4UZRUf29vehUs5h
        5xmdcexg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036s-Hr; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 5/7] net: Rename skb_frag page to bv_page
Date:   Mon, 22 Jul 2019 20:08:29 -0700
Message-Id: <20190723030831.11879-6-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index b9dc8b4f24b1..8076e2ba8349 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -311,9 +311,7 @@ extern int sysctl_max_skb_frags;
 typedef struct skb_frag_struct skb_frag_t;
 
 struct skb_frag_struct {
-	struct {
-		struct page *p;
-	} page;
+	struct page *bv_page;
 	__u32 size;
 	__u32 page_offset;
 };
@@ -374,7 +372,7 @@ static inline bool skb_frag_must_loop(struct page *p)
  *	skb_frag_foreach_page - loop over pages in a fragment
  *
  *	@f:		skb frag to operate on
- *	@f_off:		offset from start of f->page.p
+ *	@f_off:		offset from start of f->bv_page
  *	@f_len:		length from f_off to loop over
  *	@p:		(temp var) current page
  *	@p_off:		(temp var) offset from start of current page,
@@ -2084,7 +2082,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * that not all callers have unique ownership of the page but rely
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
-	frag->page.p		  = page;
+	frag->bv_page		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
 
@@ -2872,7 +2870,7 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
  */
 static inline struct page *skb_frag_page(const skb_frag_t *frag)
 {
-	return frag->page.p;
+	return frag->bv_page;
 }
 
 /**
@@ -2958,7 +2956,7 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
  */
 static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
 {
-	frag->page.p = page;
+	frag->bv_page = page;
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e32081709a0d..0acaf55fc482 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3364,7 +3364,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			__skb_frag_ref(fragfrom);
-			fragto->page = fragfrom->page;
+			fragto->bv_page = fragfrom->bv_page;
 			fragto->page_offset = fragfrom->page_offset;
 			skb_frag_size_set(fragto, todo);
 
-- 
2.20.1

