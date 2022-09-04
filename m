Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4D5AC2EE
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 08:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIDGJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 02:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDGJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 02:09:39 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5CC18E07
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 23:09:35 -0700 (PDT)
Received: from fsav115.sakura.ne.jp (fsav115.sakura.ne.jp [27.133.134.242])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28469XNa064425;
        Sun, 4 Sep 2022 15:09:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav115.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp);
 Sun, 04 Sep 2022 15:09:33 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28469XDq064422
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 4 Sep 2022 15:09:33 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <2470e028-9b05-2013-7198-1fdad071d999@I-love.SAKURA.ne.jp>
Date:   Sun, 4 Sep 2022 15:09:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: [PATCH] net/9p: use a dedicated spinlock for modifying IDR
Content-Language: en-US
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
References: <000000000000f842c805e64f17a8@google.com>
Cc:     syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000f842c805e64f17a8@google.com>
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
This patch is not tested, for reproducer is not available.

 net/9p/client.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 0a6110e15d0f..20f0a2d8dd38 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -28,6 +28,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/9p.h>
 
+static DEFINE_SPINLOCK(p9_idr_lock);
+
 #define DEFAULT_MSIZE (128 * 1024)
 
 /* Client Option Parsing (code inspired by NFS code)
@@ -283,14 +285,14 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	INIT_LIST_HEAD(&req->req_list);
 
 	idr_preload(GFP_NOFS);
-	spin_lock_irq(&c->lock);
+	spin_lock_irq(&p9_idr_lock);
 	if (type == P9_TVERSION)
 		tag = idr_alloc(&c->reqs, req, P9_NOTAG, P9_NOTAG + 1,
 				GFP_NOWAIT);
 	else
 		tag = idr_alloc(&c->reqs, req, 0, P9_NOTAG, GFP_NOWAIT);
 	req->tc.tag = tag;
-	spin_unlock_irq(&c->lock);
+	spin_unlock_irq(&p9_idr_lock);
 	idr_preload_end();
 	if (tag < 0)
 		goto free;
@@ -364,9 +366,9 @@ static void p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 	u16 tag = r->tc.tag;
 
 	p9_debug(P9_DEBUG_MUX, "freeing clnt %p req %p tag: %d\n", c, r, tag);
-	spin_lock_irqsave(&c->lock, flags);
+	spin_lock_irqsave(&p9_idr_lock, flags);
 	idr_remove(&c->reqs, tag);
-	spin_unlock_irqrestore(&c->lock, flags);
+	spin_unlock_irqrestore(&p9_idr_lock, flags);
 }
 
 int p9_req_put(struct p9_client *c, struct p9_req_t *r)
@@ -813,10 +815,10 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	refcount_set(&fid->count, 1);
 
 	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&clnt->lock);
+	spin_lock_irq(&p9_idr_lock);
 	ret = idr_alloc_u32(&clnt->fids, fid, &fid->fid, P9_NOFID - 1,
 			    GFP_NOWAIT);
-	spin_unlock_irq(&clnt->lock);
+	spin_unlock_irq(&p9_idr_lock);
 	idr_preload_end();
 	if (!ret) {
 		trace_9p_fid_ref(fid, P9_FID_REF_CREATE);
@@ -835,9 +837,9 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	p9_debug(P9_DEBUG_FID, "fid %d\n", fid->fid);
 	trace_9p_fid_ref(fid, P9_FID_REF_DESTROY);
 	clnt = fid->clnt;
-	spin_lock_irqsave(&clnt->lock, flags);
+	spin_lock_irqsave(&p9_idr_lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
-	spin_unlock_irqrestore(&clnt->lock, flags);
+	spin_unlock_irqrestore(&p9_idr_lock, flags);
 	kfree(fid->rdir);
 	kfree(fid);
 }
-- 
2.34.1


