Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B303AF157
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhFURHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFURHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:07:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED26C058A72;
        Mon, 21 Jun 2021 09:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gY/mJ1JYsG5Uc4lToWjwTSMGr1pqL1xz+/KvkVfWJCU=; b=N/aEfRfO38RCJhMJ6QJJYW84Br
        Ch+YdprdrfrDv5EiEioGtSGkYyvIaqkSwzd/VZnenCLctOyb0OD6ngnZefZfzkubWxyGdZIm5qW56
        Dca+2v00YMzLFnDNkO7NG7dXeKbT88nmod6vezVeQrAETk4Tgil8zCjcsIusvx3ECg2Hi5Vp1Vd+r
        TKcQfjWSzWnFyqckkCDRawERZeYVB0Xlfxl3I+pfQhJgrFuPzn8shaGU7tdNt1nfYRrNX2WiZ59S+
        Q83mNiAAFlbPHmsm4t8YtteKJa78Djbo6e0WeNyiruZIZ/AnbF3BIBAKzkmdLqZds5YMdpRb2WCDQ
        NOkycsAw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvN7R-00DLXM-SM; Mon, 21 Jun 2021 16:50:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] net: Remove fs.h from net.h
Date:   Mon, 21 Jun 2021 17:49:20 +0100
Message-Id: <20210621164920.3180672-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210621164920.3180672-1-willy@infradead.org>
References: <20210621164920.3180672-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need read_descriptor_t from fs.h, but the funny thing is that
fs.h doesn't need read_descriptor_t any more, so just move it to net.h.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/filesystems/locking.rst |  2 --
 include/linux/fs.h                    | 22 ----------------------
 include/linux/net.h                   | 21 ++++++++++++++++++++-
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 1e894480115b..4f519d6efb73 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -522,8 +522,6 @@ prototypes::
 			loff_t *);
 	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long,
 			loff_t *);
-	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t,
-			void __user *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t,
 			loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c3c88fdb9b2a..f2710ef476a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -345,28 +345,6 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 	return kiocb->ki_complete == NULL;
 }
 
-/*
- * "descriptor" for what we're up to with a read.
- * This allows us to use the same read code yet
- * have multiple different users of the data that
- * we read from a file.
- *
- * The simplest case just copies the data to user
- * mode.
- */
-typedef struct {
-	size_t written;
-	size_t count;
-	union {
-		char __user *buf;
-		void *data;
-	} arg;
-	int error;
-} read_descriptor_t;
-
-typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
-		unsigned long, unsigned long);
-
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
diff --git a/include/linux/net.h b/include/linux/net.h
index f54c8f478f3e..f6f9603a60bf 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -20,7 +20,6 @@
 #include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/rcupdate.h>
 #include <linux/once.h>
-#include <linux/fs.h>
 #include <linux/page_ref.h>
 #include <linux/sockptr.h>
 
@@ -131,6 +130,26 @@ struct sockaddr;
 struct msghdr;
 struct module;
 struct sk_buff;
+
+/*
+ * "descriptor" for what we're up to with a read.
+ * This allows us to use the same read code yet
+ * have multiple different users of the data that
+ * we read from a file.
+ *
+ * The simplest case just copies the data to user
+ * mode.
+ */
+typedef struct read_descriptor {
+	size_t written;
+	size_t count;
+	union {
+		char __user *buf;
+		void *data;
+	} arg;
+	int error;
+} read_descriptor_t;
+
 typedef int (*sk_read_actor_t)(read_descriptor_t *, struct sk_buff *,
 			       unsigned int, size_t);
 
-- 
2.30.2

