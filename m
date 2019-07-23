Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1CE70F94
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbfGWDI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36444 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387927AbfGWDIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SlB6oagSf+EHNNhYMcvoRwKHpGUn+VlNx7tHqLEQaso=; b=nRb1Zcv3rwZYRxaKx7xdExLuT4
        9UbMwHgvpOFcOeT4rFyNnvfYSdCscRGxfImIfETUHjqXOwmSSqzVyiRUfCaYFQPAsH7uuQNt8cz6x
        rOSY2ITYe3G5SZNVB8W3jOEbLjTGOa/KrNno1cjznPnkwDogI/1ZkREJIyaUEPSPWMvehb0AzCp8q
        maYaZ0f2ImsmFTaV0Ssw3nQj3PVpepC2hZ3QPOzhu/ef1x1Y/gov/cIxtMh89Ui6bcQ+Ld4ZrL2q9
        trUKuUxyCXvwuYcJ7mPxaPwYYWewdiob4YEgnGcHc7Q3Wbo2AiEUxJNJ8zcCkWPXIU33UTQHOl28V
        SO/RY9vA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-000370-Kv; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 7/7] net: Convert skb_frag_t to bio_vec
Date:   Mon, 22 Jul 2019 20:08:31 -0700
Message-Id: <20190723030831.11879-8-willy@infradead.org>
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

There are a lot of users of frag->page_offset, so use a union
to avoid converting those users today.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/bvec.h   | 5 ++++-
 include/linux/skbuff.h | 9 ++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index a032f01e928c..7f2b2ea9399c 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -18,7 +18,10 @@
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
index e849e411d1f3..718742b1c505 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/time.h>
 #include <linux/bug.h>
+#include <linux/bvec.h>
 #include <linux/cache.h>
 #include <linux/rbtree.h>
 #include <linux/socket.h>
@@ -308,13 +309,7 @@ extern int sysctl_max_skb_frags;
  */
 #define GSO_BY_FRAGS	0xFFFF
 
-typedef struct skb_frag_struct skb_frag_t;
-
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

