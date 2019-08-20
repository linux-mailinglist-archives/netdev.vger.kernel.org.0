Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F85F96C5C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbfHTWdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731005AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OraGxPAuOyx8pLmsOf4xe1qwjeKReRlNFDHtH8AqlNA=; b=dCZxOGfxJW2blz81+t6Wn/egy8
        sth6NkWB4CtkSJMBqr4/tqxi9PrRwKCPDNMQ/2anjVkubYhQMAMegR5qIk8DVkiEHFRkJ7ok6J/iJ
        FDfiUXmbIDMbcAsyJlCeWrH/v/nsNR2/+ffnFMMq3Fkxhtgq4sDwCofTYaTSmMqWloTBab/E6o473
        RmD67hhWPbDicekSjKoodE83ULBrzLExobnv8+T/oIEIMG+OURaPDF33TGyJnVjLdA/en6wkcYkBd
        msEIltGg0IHd3vlX/zC1Fk1MdA4M+etJ4xfpavy86Ks34/6wIJnGzwWV55p6eX/Xt/Tc2DzVbx+Zu
        IyABdFMA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rS-Nm; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 20/38] 9p: Convert fids IDR to XArray
Date:   Tue, 20 Aug 2019 15:32:41 -0700
Message-Id: <20190820223259.22348-21-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Locking changes to use the internal XArray spinlock instead of the
client spinlock.  Also remove all references to the IDR header file
and a dangling define of P9_ROW_MAXTAG.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/9p/client.h |  7 ++-----
 net/9p/client.c         | 23 ++++++++---------------
 net/9p/trans_fd.c       |  1 -
 net/9p/trans_rdma.c     |  1 -
 net/9p/trans_virtio.c   |  1 -
 5 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 6fe36ca0c32e..a50f98cff203 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -12,10 +12,7 @@
 #define NET_9P_CLIENT_H
 
 #include <linux/utsname.h>
-#include <linux/idr.h>
-
-/* Number of requests per row */
-#define P9_ROW_MAXTAG 255
+#include <linux/xarray.h>
 
 /** enum p9_proto_versions - 9P protocol versions
  * @p9_proto_legacy: 9P Legacy mode, pre-9P2000.u
@@ -123,7 +120,7 @@ struct p9_client {
 		} tcp;
 	} trans_opts;
 
-	struct idr fids;
+	struct xarray fids;
 	struct xarray reqs;
 
 	char name[__NEW_UTS_LEN + 1];
diff --git a/net/9p/client.c b/net/9p/client.c
index 5c566e48f63e..ca7bd0949ebb 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
-#include <linux/idr.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
@@ -898,15 +897,9 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	fid->uid = current_fsuid();
 	fid->clnt = clnt;
 	fid->rdir = NULL;
-	fid->fid = 0;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&clnt->lock);
-	ret = idr_alloc_u32(&clnt->fids, fid, &fid->fid, P9_NOFID - 1,
-			    GFP_NOWAIT);
-	spin_unlock_irq(&clnt->lock);
-	idr_preload_end();
 
+	ret = xa_alloc_irq(&clnt->fids, &fid->fid, fid,
+				XA_LIMIT(0, P9_NOFID - 1), GFP_KERNEL);
 	if (!ret)
 		return fid;
 
@@ -921,9 +914,9 @@ static void p9_fid_destroy(struct p9_fid *fid)
 
 	p9_debug(P9_DEBUG_FID, "fid %d\n", fid->fid);
 	clnt = fid->clnt;
-	spin_lock_irqsave(&clnt->lock, flags);
-	idr_remove(&clnt->fids, fid->fid);
-	spin_unlock_irqrestore(&clnt->lock, flags);
+	xa_lock_irqsave(&clnt->fids, flags);
+	__xa_erase(&clnt->fids, fid->fid);
+	xa_unlock_irqrestore(&clnt->fids, flags);
 	kfree(fid->rdir);
 	kfree(fid);
 }
@@ -1014,7 +1007,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
 
 	spin_lock_init(&clnt->lock);
-	idr_init(&clnt->fids);
+	xa_init_flags(&clnt->fids, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	xa_init_flags(&clnt->reqs, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 
 	err = parse_opts(options, clnt);
@@ -1076,7 +1069,7 @@ EXPORT_SYMBOL(p9_client_create);
 void p9_client_destroy(struct p9_client *clnt)
 {
 	struct p9_fid *fid;
-	int id;
+	unsigned long id;
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p\n", clnt);
 
@@ -1085,7 +1078,7 @@ void p9_client_destroy(struct p9_client *clnt)
 
 	v9fs_put_trans(clnt->trans_mod);
 
-	idr_for_each_entry(&clnt->fids, fid, id) {
+	xa_for_each(&clnt->fids, id, fid) {
 		pr_info("Found fid %d not clunked\n", fid->fid);
 		p9_fid_destroy(fid);
 	}
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 13cd683a658a..05fa9cb2897e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -22,7 +22,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index bac8dad5dd69..935f9464da6e 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -23,7 +23,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/parser.h>
 #include <linux/semaphore.h>
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index a3cd90a74012..947a85f87f22 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -22,7 +22,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-- 
2.23.0.rc1

