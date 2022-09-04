Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8B5AC319
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiIDHGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 03:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDHGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 03:06:44 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA02F4B0FB
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 00:06:43 -0700 (PDT)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28476gk3074662;
        Sun, 4 Sep 2022 16:06:42 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Sun, 04 Sep 2022 16:06:42 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28476f3d074659
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 4 Sep 2022 16:06:41 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <68540a56-6a5f-87e9-3c21-49c58758bfaf@I-love.SAKURA.ne.jp>
Date:   Sun, 4 Sep 2022 16:06:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: [PATCH v2] net/9p: use a dedicated spinlock for modifying IDR
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
References: <000000000000f842c805e64f17a8@google.com>
 <2470e028-9b05-2013-7198-1fdad071d999@I-love.SAKURA.ne.jp>
 <YxRHYaqqISAr5Rif@codewreck.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YxRHYaqqISAr5Rif@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting inconsistent lock state in p9_req_put(), for
p9_tag_remove() from p9_req_put() from IRQ context is using
spin_lock_irqsave() on "struct p9_client"->lock but other locations
not from IRQ context are using spin_lock().

Since spin_lock() => spin_lock_irqsave() conversion on this lock will
needlessly disable IRQ for infrequent event, and p9_tag_remove() needs
to disable IRQ only for modifying IDR (RCU read lock can be used for
reading IDR), let's introduce a spinlock dedicated for serializing
idr_alloc()/idr_alloc_u32()/idr_remove() calls. Since this spinlock
will be held as innermost lock, circular locking dependency problem
won't happen by adding this spinlock.

Link: https://syzkaller.appspot.com/bug?extid=2f20b523930c32c160cc [1]
Reported-by: syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Changes in v2:
  Make this spinlock per "struct p9_client", though I don't know how we
  should update "@lock" when "@idr_lock" also protects @fids and @reqs...

   /**
    * struct p9_client - per client instance state
    * @lock: protect @fids and @reqs
    * @msize: maximum data size negotiated by protocol
    * @proto_version: 9P protocol version to use
    * @trans_mod: module API instantiated with this client
    * @status: connection state
    * @trans: tranport instance state and API
    * @fids: All active FID handles
    * @reqs: All active requests.
  + * @idr_lock: protect @fids and @reqs when modifying IDR
    * @name: node name used as client id
    *
    * The client structure is used to keep track of various per-client
    * state that has been instantiated.
    */

 include/net/9p/client.h |  2 ++
 net/9p/client.c         | 17 +++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 78ebcf782ce5..5edb3bd144fc 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -94,6 +94,7 @@ struct p9_req_t {
  * @trans: tranport instance state and API
  * @fids: All active FID handles
  * @reqs: All active requests.
+ * @idr_lock: protect @fids and @reqs when modifying IDR
  * @name: node name used as client id
  *
  * The client structure is used to keep track of various per-client
@@ -122,6 +123,7 @@ struct p9_client {
 
 	struct idr fids;
 	struct idr reqs;
+	spinlock_t idr_lock;
 
 	char name[__NEW_UTS_LEN + 1];
 };
diff --git a/net/9p/client.c b/net/9p/client.c
index 0a6110e15d0f..9c801b49431d 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -283,14 +283,14 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	INIT_LIST_HEAD(&req->req_list);
 
 	idr_preload(GFP_NOFS);
-	spin_lock_irq(&c->lock);
+	spin_lock_irq(&c->idr_lock);
 	if (type == P9_TVERSION)
 		tag = idr_alloc(&c->reqs, req, P9_NOTAG, P9_NOTAG + 1,
 				GFP_NOWAIT);
 	else
 		tag = idr_alloc(&c->reqs, req, 0, P9_NOTAG, GFP_NOWAIT);
 	req->tc.tag = tag;
-	spin_unlock_irq(&c->lock);
+	spin_unlock_irq(&c->idr_lock);
 	idr_preload_end();
 	if (tag < 0)
 		goto free;
@@ -364,9 +364,9 @@ static void p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	u16 tag = r->tc.tag;
 
 	p9_debug(P9_DEBUG_MUX, "freeing clnt %p req %p tag: %d\n", c, r, tag);
-	spin_lock_irqsave(&c->lock, flags);
+	spin_lock_irqsave(&c->idr_lock, flags);
 	idr_remove(&c->reqs, tag);
-	spin_unlock_irqrestore(&c->lock, flags);
+	spin_unlock_irqrestore(&c->idr_lock, flags);
 }
 
 int p9_req_put(struct p9_client *c, struct p9_req_t *r)
@@ -813,10 +813,10 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	refcount_set(&fid->count, 1);
 
 	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&clnt->lock);
+	spin_lock_irq(&clnt->idr_lock);
 	ret = idr_alloc_u32(&clnt->fids, fid, &fid->fid, P9_NOFID - 1,
 			    GFP_NOWAIT);
-	spin_unlock_irq(&clnt->lock);
+	spin_unlock_irq(&clnt->idr_lock);
 	idr_preload_end();
 	if (!ret) {
 		trace_9p_fid_ref(fid, P9_FID_REF_CREATE);
@@ -835,9 +835,9 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	p9_debug(P9_DEBUG_FID, "fid %d\n", fid->fid);
 	trace_9p_fid_ref(fid, P9_FID_REF_DESTROY);
 	clnt = fid->clnt;
-	spin_lock_irqsave(&clnt->lock, flags);
+	spin_lock_irqsave(&clnt->idr_lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
-	spin_unlock_irqrestore(&clnt->lock, flags);
+	spin_unlock_irqrestore(&clnt->idr_lock, flags);
 	kfree(fid->rdir);
 	kfree(fid);
 }
@@ -943,6 +943,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
 
 	spin_lock_init(&clnt->lock);
+	spin_lock_init(&clnt->idr_lock);
 	idr_init(&clnt->fids);
 	idr_init(&clnt->reqs);
 
-- 
2.34.1

