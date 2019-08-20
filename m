Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837B096C5D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfHTWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731003AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yRjwAkHFCQIYlAQd73rVeQP2G3UMpWqbCMu1zo0Dilg=; b=kXBsOb3Qq4P76PoQ+yStJAEzyQ
        f+e1dRtLYGGsY8cXUQq0aGGigKKn3OW0NodVV+DvPBqT0YGREyD/hGquyxtA5Tl9I7WrOoIamqOgM
        Cs0a5z0WYwXcoINnhAG54V4ce3icTH7qkJwDHrX3HlGMhj6emB3XR6SG1rqw8JiX5k/ZVUaIypqmh
        cj2ZmxCRZbbTs44gf1c2+J895cyIzu7qT9G/umHVvDTpbW9uBPRip1SqkSeCvsoms6g2H8rR7FSoN
        J1ua14W0uFo7Sh1uNOIdg3HhfopvPZJZtmLHWT98lCkKpUdm040ZCBkjIv3BKZ8D6cfHSm/2kwH06
        xyLqX6wQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rM-LE; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 19/38] 9p: Convert reqs IDR to XArray
Date:   Tue, 20 Aug 2019 15:32:40 -0700
Message-Id: <20190820223259.22348-20-willy@infradead.org>
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

Use the xarray spinlock instead of the client spinlock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/9p/client.h |  2 +-
 net/9p/client.c         | 41 ++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index acc60d8a3b3b..6fe36ca0c32e 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -124,7 +124,7 @@ struct p9_client {
 	} trans_opts;
 
 	struct idr fids;
-	struct idr reqs;
+	struct xarray reqs;
 
 	char name[__NEW_UTS_LEN + 1];
 };
diff --git a/net/9p/client.c b/net/9p/client.c
index 9622f3e469f6..5c566e48f63e 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -269,7 +269,8 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 {
 	struct p9_req_t *req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
 	int alloc_msize = min(c->msize, max_size);
-	int tag;
+	int err;
+	u32 tag;
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
@@ -285,17 +286,17 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
 
-	idr_preload(GFP_NOFS);
-	spin_lock_irq(&c->lock);
-	if (type == P9_TVERSION)
-		tag = idr_alloc(&c->reqs, req, P9_NOTAG, P9_NOTAG + 1,
-				GFP_NOWAIT);
-	else
-		tag = idr_alloc(&c->reqs, req, 0, P9_NOTAG, GFP_NOWAIT);
+	xa_lock_irq(&c->reqs);
+	if (type == P9_TVERSION) {
+		tag = P9_NOTAG;
+		err = __xa_insert(&c->reqs, P9_NOTAG, req, GFP_NOFS);
+	} else {
+		err = __xa_alloc(&c->reqs, &tag, req, XA_LIMIT(0, P9_NOTAG - 1),
+				GFP_NOFS);
+	}
 	req->tc.tag = tag;
-	spin_unlock_irq(&c->lock);
-	idr_preload_end();
-	if (tag < 0)
+	xa_unlock_irq(&c->reqs);
+	if (err < 0)
 		goto free;
 
 	/* Init ref to two because in the general case there is one ref
@@ -334,7 +335,7 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 
 	rcu_read_lock();
 again:
-	req = idr_find(&c->reqs, tag);
+	req = xa_load(&c->reqs, tag);
 	if (req) {
 		/* We have to be careful with the req found under rcu_read_lock
 		 * Thanks to SLAB_TYPESAFE_BY_RCU we can safely try to get the
@@ -367,9 +368,9 @@ static int p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	u16 tag = r->tc.tag;
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p req %p tag: %d\n", c, r, tag);
-	spin_lock_irqsave(&c->lock, flags);
-	idr_remove(&c->reqs, tag);
-	spin_unlock_irqrestore(&c->lock, flags);
+	xa_lock_irqsave(&c->reqs, flags);
+	__xa_erase(&c->reqs, tag);
+	xa_unlock_irqrestore(&c->reqs, flags);
 	return p9_req_put(r);
 }
 
@@ -397,16 +398,14 @@ EXPORT_SYMBOL(p9_req_put);
 static void p9_tag_cleanup(struct p9_client *c)
 {
 	struct p9_req_t *req;
-	int id;
+	unsigned long id;
 
-	rcu_read_lock();
-	idr_for_each_entry(&c->reqs, req, id) {
-		pr_info("Tag %d still in use\n", id);
+	xa_for_each(&c->reqs, id, req) {
+		pr_info("Tag %ld still in use\n", id);
 		if (p9_tag_remove(c, req) == 0)
 			pr_warn("Packet with tag %d has still references",
 				req->tc.tag);
 	}
-	rcu_read_unlock();
 }
 
 /**
@@ -1016,7 +1015,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	spin_lock_init(&clnt->lock);
 	idr_init(&clnt->fids);
-	idr_init(&clnt->reqs);
+	xa_init_flags(&clnt->reqs, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 
 	err = parse_opts(options, clnt);
 	if (err < 0)
-- 
2.23.0.rc1

