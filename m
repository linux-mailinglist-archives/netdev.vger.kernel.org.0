Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B7510971
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfEAOpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49350 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dz7pVtA7rFK2G0jePblFnhGShk5IIFNauDHXX8vCdjE=; b=W56fc+mKRQl0bJwp5AgF8qoqv
        LrvzzTnQUolO3FMnezcUWtBWwD4FfJd04z+bUzgHHW+e89V3ntrIxisRXmi3UnX9RyJIQ0uPrcfTm
        nJG3YrbS8LGlAPvdtV9aXxIvWnJ2bdabIS3068MqOfmao7r2XtZ+YupJ6bpio0Ul9imRxdCLd3kpO
        WwjgQAA8lVHa/qwKScogJcKy4Hhbp0uXiz03WQkQLITMXJGfClCdBfcEqmBOxJNfyPNVk+5kzstcL
        gvHNNuDsWQhKBFL1unVoqxd7dLZTqzItqLv33FLC6+3iw1ZeosdAliMl3WTyE+2bm6MZmeioqBk0O
        LZn7sl+9A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTk-00026X-Lf; Wed, 01 May 2019 14:45:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 7/7] net: Convert skb_frag_t to bio_vec
Date:   Wed,  1 May 2019 07:44:57 -0700
Message-Id: <20190501144457.7942-8-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

There are a lot of users of frag->page_offset, and of struct
skb_frag_struct, so use a union and a compatibility define respectively
to avoid converting those users today.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/bvec.h   | 5 ++++-
 include/linux/skbuff.h | 9 +++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index ff13cbc1887d..49a8ad6c331b 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -31,7 +31,10 @@
 struct bio_vec {
 	struct page	*bv_page;
 	unsigned int	bv_len;
-	unsigned int	bv_offset;
+	union {
+		__u32		page_offset;
+		unsigned int	bv_offset;
+	};
 };
 
 struct bvec_iter {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index df07b3144c77..d61d496e0083 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -18,6 +18,7 @@
 #include <linux/compiler.h>
 #include <linux/time.h>
 #include <linux/bug.h>
+#include <linux/bvec.h>
 #include <linux/cache.h>
 #include <linux/rbtree.h>
 #include <linux/socket.h>
@@ -312,13 +313,9 @@ extern int sysctl_max_skb_frags;
  */
 #define GSO_BY_FRAGS	0xFFFF
 
-typedef struct skb_frag_struct skb_frag_t;
+#define skb_frag_struct bio_vec
 
-struct skb_frag_struct {
-	struct page *bv_page;
-	unsigned int bv_len;
-	__u32 page_offset;
-};
+typedef struct bio_vec skb_frag_t;
 
 /**
  * skb_frag_size - Returns the size of a skb fragment
-- 
2.20.1

