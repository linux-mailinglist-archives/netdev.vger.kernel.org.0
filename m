Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCE167061
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfGLNoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:44:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfGLNoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wZKRyP2yHzDk7GUgVML7BAwUWjeGymblM8qmdzItDWw=; b=Nt73KgDCuZOnyPoXrLdAwoMUu4
        zs2aMafasfANbmVj3XHwDTsU0qsvp0yacNKbHXPXj0D+c2M1av+C5eK3qVjNgsyEZLtu0YHi5i4j8
        iGz7h+n/3ckfDr3KcQD1ImqY1wSP6GJVlxpCB3cgWma0Oj8knPIn4O/T8FXWcaLsxvy/92dqCBkqR
        8zK/qVO2FudWkZx0rsRNZ+PxVjuOgVCV/R4k/0f/TJ1aMwrseZ+Oq2kXhuE3ZwZa05LyohisZ+1gk
        Nw27HgU8VNgUq4XyaORw/bRPnrHlmjDBEv7uhD/Rov6fUFe44oi5yy8DNkVTByna7wRcvvwrxV2rX
        PdGntxvA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlvpz-00059w-Hl; Fri, 12 Jul 2019 13:43:47 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 3/7] net: Increase the size of skb_frag_t
Date:   Fri, 12 Jul 2019 06:43:41 -0700
Message-Id: <20190712134345.19767-4-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712134345.19767-1-willy@infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index f9078e7edb53..7910935410e6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -314,13 +314,8 @@ struct skb_frag_struct {
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

