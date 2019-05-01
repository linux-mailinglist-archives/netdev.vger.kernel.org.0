Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD97610476
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfEAESF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfEAESE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vemidzzB3WY/5PjAc5z5G1RZBRF0gJ18TRUKik+lPW0=; b=LfZaTxPbiyi6CdSILIILFg77d
        jhkBMvbl7BzVOd9CKez7Bat4d1bBl3ELjbmyi+9o0LAfviGvbzP0emuA2h0o+gT9xflRWzPqcXiYB
        iYUgFKERgihLDVsH7/7OGu68EMqCEPXfJBYFzheig0SNN1m1LT4hH73dlnGZVRqWX4q1RLBH55EPE
        ncQPV9i0tpSL7QK6j5iY3bRMA8RyLQs4a5b7MyDheDJbYlZfvhyWZRpeMfFKA7tu/z0WFw6H67U0o
        QT2RxpD5bWwjfQKzyW4PSp+BPw+XXC8fhttYBaiPEFGI/0BPZA1umN2w/RDBQLPQKiXAi9l5TN6sg
        wQJOSTksw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggz-0002GK-0I; Wed, 01 May 2019 04:18:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 1/5] net: Increase the size of skb_frag_t
Date:   Tue, 30 Apr 2019 21:17:53 -0700
Message-Id: <20190501041757.8647-3-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

To increase commonality between block and net, we are going to replace
the skb_frag_t with the bio_vec.  This patch increases the size of
skb_frag_t on 32-bit machines from 8 bytes to 12 bytes.  The size is
unchanged on 64-bit machines.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9027a8c4219f..23f05c64aa31 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -318,13 +318,8 @@ struct skb_frag_struct {
 	struct {
 		struct page *p;
 	} page;
-#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
 	__u32 page_offset;
 	__u32 size;
-#else
-	__u16 page_offset;
-	__u16 size;
-#endif
 };
 
 /**
-- 
2.20.1

