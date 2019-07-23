Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B7B70F97
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbfGWDIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36396 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387881AbfGWDIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wZKRyP2yHzDk7GUgVML7BAwUWjeGymblM8qmdzItDWw=; b=M9XAOJwq4e1Rp95Bk1jctWShWn
        VTKhqmQvEEvpRQeu7X9LGZbveGa/4pXoeJ8r2VyACUsLmq5+sna9LEqk5vczu8fxusnDRf2pFhp6e
        /lRTM9vOw5cgEuFd8LYzWXOk8dW+Hu8SHXX88IOuAAh402PJX/p0F903mXMs8/JfkCiGY9RzEeFU9
        Wja3lakPTMFgCxM9Nguzw5HVzoQ31CkEzuSmKrvlPS/45o4mjDJEJxLOy+S4W16NIC/GqYEacFySy
        jpvWxxQh+tgVNMw9fkh6WfWS9Ludpk/gnxtoXNuzDumPslSnmYOO7i2VLBKZfuXaByIEIPrz/7pCY
        OeQOwWKQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036j-DD; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 3/7] net: Increase the size of skb_frag_t
Date:   Mon, 22 Jul 2019 20:08:27 -0700
Message-Id: <20190723030831.11879-4-willy@infradead.org>
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

