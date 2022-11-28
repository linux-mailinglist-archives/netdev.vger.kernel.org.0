Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3C63B0F2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiK1SST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiK1SRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:17:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758142D769
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669658429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oScjHgUsfPCUpHvSbXmtkG9Jiz96znMS7UbDYb2DUKs=;
        b=e+GodBQruRnM7V3ter1vjcImBwJpDjlZPLWXuIHuxfhQBhsM9vMb/4TGM4I1biw83LSpnY
        FC5UlXs2I6YPUE8PU0Z7/8izFC9xQOwvisB6GENhnXcTsFMeBaqNB+02ozMmTvU8UHBhx6
        PFbtInQ82KIqyNWNLW1YdjSZzxAjxjk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-NMjeBuW-NqybOW6x25rqjA-1; Mon, 28 Nov 2022 13:00:25 -0500
X-MC-Unique: NMjeBuW-NqybOW6x25rqjA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E67529AA3BC;
        Mon, 28 Nov 2022 18:00:25 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5541940C6EC2;
        Mon, 28 Nov 2022 18:00:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
Date:   Mon, 28 Nov 2022 19:00:10 +0100
Message-Id: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are observing huge contention on the epmutex during an http
connection/rate test:

 83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
[...]
           |--66.96%--__fput
                      |--60.04%--eventpoll_release_file
                                 |--58.41%--__mutex_lock.isra.6
                                           |--56.56%--osq_lock

The application is multi-threaded, creates a new epoll entry for
each incoming connection, and does not delete it before the
connection shutdown - that is, before the connection's fd close().

Many different threads compete frequently for the epmutex lock,
affecting the overall performance.

To reduce the contention this patch introduces explicit reference counting
for the eventpoll struct. Each registered event acquires a reference,
and references are released at ep_remove() time.

Additionally, this introduces a new 'dying' flag to prevent races between
ep_free() and eventpoll_release_file(): the latter marks, under f_lock
spinlock, each epitem as before removing it, while ep_free() does not
touch dying epitems.

The eventpoll struct is released by whoever - among ep_free() and
eventpoll_release_file() drops its last reference.

With all the above in place, we can drop the epmutex usage at disposal time.

Overall this produces a significant performance improvement in the
mentioned connection/rate scenario: the mutex operations disappear from
the topmost offenders in the perf report, and the measured connections/rate
grows by ~60%.

Tested-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3: (addresses comments from Eric Biggers)
- introduce the 'dying' flag, use it to dispose immediately struct eventpoll
  at ep_free() time
- update a leftover comments still referring to old epmutex usage

v2 at:
https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/

v1 at:
https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/

Previous related effort at:
https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-cj.chengjian@huawei.com/
https://lkml.org/lkml/2017/10/28/81
---
 fs/eventpoll.c | 171 +++++++++++++++++++++++++++++++------------------
 1 file changed, 109 insertions(+), 62 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 52954d4637b5..af22e5e6f683 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -57,13 +57,7 @@
  * we need a lock that will allow us to sleep. This lock is a
  * mutex (ep->mtx). It is acquired during the event transfer loop,
  * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
- * Then we also need a global mutex to serialize eventpoll_release_file()
- * and ep_free().
- * This mutex is acquired by ep_free() during the epoll file
- * cleanup path and it is also acquired by eventpoll_release_file()
- * if a file has been pushed inside an epoll set and it is then
- * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
- * It is also acquired when inserting an epoll fd onto another epoll
+ * The epmutex is acquired when inserting an epoll fd onto another epoll
  * fd. We do this so that we walk the epoll tree and ensure that this
  * insertion does not create a cycle of epoll file descriptors, which
  * could lead to deadlock. We need a global mutex to prevent two
@@ -153,6 +147,13 @@ struct epitem {
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
+	/*
+	 * Protected by file->f_lock, true for to-be-released epitem already
+	 * removed from the "struct file" items list; together with
+	 * eventpoll->refcount orchestrates "struct eventpoll" disposal
+	 */
+	bool dying;
+
 	/* List containing poll wait queues */
 	struct eppoll_entry *pwqlist;
 
@@ -217,6 +218,12 @@ struct eventpoll {
 	u64 gen;
 	struct hlist_head refs;
 
+	/*
+	 * usage count, protected by mtx, used together with epitem->dying to
+	 * orchestrate the disposal of this struct
+	 */
+	unsigned int refcount;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -240,9 +247,7 @@ struct ep_pqueue {
 /* Maximum number of epoll watched descriptors, per user */
 static long max_user_watches __read_mostly;
 
-/*
- * This mutex is used to serialize ep_free() and eventpoll_release_file().
- */
+/* Used for cycles detection */
 static DEFINE_MUTEX(epmutex);
 
 static u64 loop_check_gen = 0;
@@ -555,8 +560,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 
 /*
  * This function unregisters poll callbacks from the associated file
- * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
- * ep_free).
+ * descriptor.  Must be called with "mtx" held.
  */
 static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 {
@@ -679,11 +683,38 @@ static void epi_rcu_free(struct rcu_head *head)
 	kmem_cache_free(epi_cache, epi);
 }
 
+static void ep_get(struct eventpoll *ep)
+{
+	ep->refcount++;
+}
+
+/*
+ * Returns true if the event poll can be disposed
+ */
+static bool ep_put(struct eventpoll *ep)
+{
+	if (--ep->refcount)
+		return false;
+
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
+	return true;
+}
+
+static void ep_dispose(struct eventpoll *ep)
+{
+	mutex_destroy(&ep->mtx);
+	free_uid(ep->user);
+	wakeup_source_unregister(ep->ws);
+	kfree(ep);
+}
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
+ * If the dying flag is set, do the removal only if force is true.
+ * Returns true if the eventpoll can be disposed.
  */
-static int ep_remove(struct eventpoll *ep, struct epitem *epi)
+static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 {
 	struct file *file = epi->ffd.file;
 	struct epitems_head *to_free;
@@ -698,6 +729,11 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
+	if (epi->dying && !force) {
+		spin_unlock(&file->f_lock);
+		return false;
+	}
+
 	to_free = NULL;
 	head = file->f_ep;
 	if (head->first == &epi->fllink && !epi->fllink.next) {
@@ -731,28 +767,28 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	call_rcu(&epi->rcu, epi_rcu_free);
 
 	percpu_counter_dec(&ep->user->epoll_watches);
+	return ep_put(ep);
+}
 
-	return 0;
+/*
+ * ep_remove variant for callers owing an additional reference to the ep
+ */
+static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
+{
+	WARN_ON_ONCE(__ep_remove(ep, epi, false));
 }
 
 static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
 	struct epitem *epi;
+	bool dispose;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
 		ep_poll_safewake(ep, NULL);
 
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
-	 * We do not need to hold "ep->mtx" here because the epoll file
-	 * is on the way to be removed and no one has references to it
-	 * anymore. The only hit might come from eventpoll_release_file() but
-	 * holding "epmutex" is sufficient here.
-	 */
-	mutex_lock(&epmutex);
+	mutex_lock(&ep->mtx);
 
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
@@ -766,25 +802,21 @@ static void ep_free(struct eventpoll *ep)
 
 	/*
 	 * Walks through the whole tree by freeing each "struct epitem". At this
-	 * point we are sure no poll callbacks will be lingering around, and also by
-	 * holding "epmutex" we can be sure that no file cleanup code will hit
-	 * us during this operation. So we can avoid the lock on "ep->lock".
-	 * We do not need to lock ep->mtx, either, we only do it to prevent
-	 * a lockdep warning.
+	 * point we are sure no poll callbacks will be lingering around.
+	 * Since we still own a reference to the eventpoll struct, the loop can't
+	 * dispose it.
 	 */
-	mutex_lock(&ep->mtx);
 	while ((rbp = rb_first_cached(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove(ep, epi);
+		ep_remove_safe(ep, epi);
 		cond_resched();
 	}
+
+	dispose = ep_put(ep);
 	mutex_unlock(&ep->mtx);
 
-	mutex_unlock(&epmutex);
-	mutex_destroy(&ep->mtx);
-	free_uid(ep->user);
-	wakeup_source_unregister(ep->ws);
-	kfree(ep);
+	if (dispose)
+		ep_dispose(ep);
 }
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
@@ -904,33 +936,35 @@ void eventpoll_release_file(struct file *file)
 {
 	struct eventpoll *ep;
 	struct epitem *epi;
-	struct hlist_node *next;
+	bool dispose;
 
 	/*
-	 * We don't want to get "file->f_lock" because it is not
-	 * necessary. It is not necessary because we're in the "struct file"
-	 * cleanup path, and this means that no one is using this file anymore.
-	 * So, for example, epoll_ctl() cannot hit here since if we reach this
-	 * point, the file counter already went to zero and fget() would fail.
-	 * The only hit might come from ep_free() but by holding the mutex
-	 * will correctly serialize the operation. We do need to acquire
-	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
-	 * from anywhere but ep_free().
-	 *
-	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
+	 * Use the 'dying' flag to prevent a concurrent ep_free() from touching
+	 * the epitems list before eventpoll_release_file() can access the
+	 * ep->mtx.
 	 */
-	mutex_lock(&epmutex);
-	if (unlikely(!file->f_ep)) {
-		mutex_unlock(&epmutex);
-		return;
-	}
-	hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
+again:
+	spin_lock(&file->f_lock);
+	if (file->f_ep && file->f_ep->first) {
+		/* detach from ep tree */
+		epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
+		epi->dying = true;
+		spin_unlock(&file->f_lock);
+
+		/*
+		 * ep access is safe as we still own a reference to the ep
+		 * struct
+		 */
 		ep = epi->ep;
-		mutex_lock_nested(&ep->mtx, 0);
-		ep_remove(ep, epi);
+		mutex_lock(&ep->mtx);
+		dispose = __ep_remove(ep, epi, true);
 		mutex_unlock(&ep->mtx);
+
+		if (dispose)
+			ep_dispose(ep);
+		goto again;
 	}
-	mutex_unlock(&epmutex);
+	spin_unlock(&file->f_lock);
 }
 
 static int ep_alloc(struct eventpoll **pep)
@@ -953,6 +987,7 @@ static int ep_alloc(struct eventpoll **pep)
 	ep->rbr = RB_ROOT_CACHED;
 	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
+	ep->refcount = 1;
 
 	*pep = ep;
 
@@ -1494,16 +1529,22 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	if (tep)
 		mutex_unlock(&tep->mtx);
 
+	/*
+	 * ep_remove() calls in the later error paths can't lead to ep_dispose()
+	 * as overall will lead to no refcount changes
+	 */
+	ep_get(ep);
+
 	/* now check if we've created too many backpaths */
 	if (unlikely(full_check && reverse_path_check())) {
-		ep_remove(ep, epi);
+		ep_remove_safe(ep, epi);
 		return -EINVAL;
 	}
 
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error) {
-			ep_remove(ep, epi);
+			ep_remove_safe(ep, epi);
 			return error;
 		}
 	}
@@ -1527,7 +1568,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	 * high memory pressure.
 	 */
 	if (unlikely(!epq.epi)) {
-		ep_remove(ep, epi);
+		ep_remove_safe(ep, epi);
 		return -ENOMEM;
 	}
 
@@ -2165,10 +2206,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 			error = -EEXIST;
 		break;
 	case EPOLL_CTL_DEL:
-		if (epi)
-			error = ep_remove(ep, epi);
-		else
+		if (epi) {
+			/*
+			 * The eventpoll itself is still alive: the refcount
+			 * can't go to zero here.
+			 */
+			ep_remove_safe(ep, epi);
+			error = 0;
+		} else {
 			error = -ENOENT;
+		}
 		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
-- 
2.38.1

