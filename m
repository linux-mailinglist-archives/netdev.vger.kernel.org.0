Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8866C5164
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCVQ6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCVQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25354C30
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679504246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CpXVTDLQB08O5tSWiImjBguRkrDlOZEpxZfPb6HDQ2s=;
        b=VDDGan9o0ztKy1UlW4VpoBKJOtKf7vrsIeVsbNlzDfgMqlpOTtW4FcYbQpiIhGPcfOdjss
        7YsTeJYy9yJ9Em+A1JnaKeI+FuyrQpF//PuuhZ4tKfUdYZPrkJrvhSDt9g0CZ/kGO0uYdk
        /i8w8KAs9G53g9paNTp2Uvfra+4LQVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-ESTI1vcSPniqHCdqE7FENg-1; Wed, 22 Mar 2023 12:57:24 -0400
X-MC-Unique: ESTI1vcSPniqHCdqE7FENg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61BDC802D2E;
        Wed, 22 Mar 2023 16:57:24 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFB02027040;
        Wed, 22 Mar 2023 16:57:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH v6] epoll: use refcount to reduce ep_mutex contention
Date:   Wed, 22 Mar 2023 17:57:02 +0100
Message-Id: <4a57788dcaf28f5eb4f8dfddcc3a8b172a7357bb.1679504153.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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

The eventpoll struct is released by whoever - among EP file close() and
and the monitored file close() drops its last reference.

Additionally, this introduces a new 'dying' flag to prevent races between
the EP file close() and the monitored file close().
ep_eventpoll_release() marks, under f_lock spinlock, each epitem as dying
before removing it, while EP file close() does not touch dying epitems.

The above is needed as both close operations could run concurrently and
drop the EP reference acquired via the epitem entry. Without the above
flag, the monitored file close() could reach the EP struct via the epitem
list while the epitem is still listed and then try to put it after its
disposal.

An alternative could be avoiding touching the references acquired via
the epitems at EP file close() time, but that could leave the EP struct
alive for potentially unlimited time after EP file close(), with nasty
side effects.

With all the above in place, we can drop the epmutex usage at disposal time.

Overall this produces a significant performance improvement in the
mentioned connection/rate scenario: the mutex operations disappear from
the topmost offenders in the perf report, and the measured connections/rate
grows by ~60%.

To make the change more readable this additionally renames ep_free() to
ep_clear_and_put(), and moves the actual memory cleanup in a separate
ep_free() helper.

Co-developed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Xiumei Mu <xmu@redhiat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
This addresses a deadlock reported by syzkaller on v5:
https://lore.kernel.org/lkml/000000000000c6dc0305f75b4d74@google.com/T/#u
Due to such change I stripped the acked-by/reviewed-by tag carried in
the previous revision

v5 at:
https://lore.kernel.org/linux-fsdevel/323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com/

v4 at:
https://lore.kernel.org/linux-fsdevel/f0c49fb4b682b81d64184d1181bc960728907474.camel@redhat.com/T/#t

v3 at:
https://lore.kernel.org/linux-fsdevel/1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com/

v2 at:
https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/

v1 at:
https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/

Previous related effort at:
https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-cj.chengjian@huawei.com/
https://lkml.org/lkml/2017/10/28/81
---
 fs/eventpoll.c | 195 +++++++++++++++++++++++++++++++------------------
 1 file changed, 123 insertions(+), 72 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 64659b110973..0ecdfd3043a3 100644
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
+	 * usage count, used together with epitem->dying to
+	 * orchestrate the disposal of this struct
+	 */
+	refcount_t refcount;
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
@@ -557,8 +562,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 
 /*
  * This function unregisters poll callbacks from the associated file
- * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
- * ep_free).
+ * descriptor.  Must be called with "mtx" held.
  */
 static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 {
@@ -681,11 +685,40 @@ static void epi_rcu_free(struct rcu_head *head)
 	kmem_cache_free(epi_cache, epi);
 }
 
+static void ep_get(struct eventpoll *ep)
+{
+	refcount_inc(&ep->refcount);
+}
+
+/*
+ * Returns true if the event poll can be disposed
+ */
+static bool ep_refcount_dec_and_test(struct eventpoll *ep)
+{
+	if (!refcount_dec_and_test(&ep->refcount))
+		return false;
+
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
+	return true;
+}
+
+static void ep_free(struct eventpoll *ep)
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
+ * This prevents ep_clear_and_put() from dropping all the ep references
+ * while running concurrently with eventpoll_release_file().
+ * Returns true if the eventpoll can be disposed.
  */
-static int ep_remove(struct eventpoll *ep, struct epitem *epi)
+static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 {
 	struct file *file = epi->ffd.file;
 	struct epitems_head *to_free;
@@ -700,6 +733,11 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
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
@@ -733,28 +771,28 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	call_rcu(&epi->rcu, epi_rcu_free);
 
 	percpu_counter_dec(&ep->user->epoll_watches);
+	return ep_refcount_dec_and_test(ep);
+}
 
-	return 0;
+/*
+ * ep_remove variant for callers owing an additional reference to the ep
+ */
+static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
+{
+	WARN_ON_ONCE(__ep_remove(ep, epi, false));
 }
 
-static void ep_free(struct eventpoll *ep)
+static void ep_clear_and_put(struct eventpoll *ep)
 {
-	struct rb_node *rbp;
+	struct rb_node *rbp, *next;
 	struct epitem *epi;
+	bool dispose;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
 		ep_poll_safewake(ep, NULL, 0);
 
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
@@ -767,26 +805,25 @@ static void ep_free(struct eventpoll *ep)
 	}
 
 	/*
-	 * Walks through the whole tree by freeing each "struct epitem". At this
-	 * point we are sure no poll callbacks will be lingering around, and also by
-	 * holding "epmutex" we can be sure that no file cleanup code will hit
-	 * us during this operation. So we can avoid the lock on "ep->lock".
-	 * We do not need to lock ep->mtx, either, we only do it to prevent
-	 * a lockdep warning.
+	 * Walks through the whole tree and try to free each "struct epitem".
+	 * Note that ep_remove_safe() will not remove the epitem in case of a
+	 * racing eventpoll_release_file(); the latter will do the removal.
+	 * At this point we are sure no poll callbacks will be lingering around.
+	 * Since we still own a reference to the eventpoll struct, the loop can't
+	 * dispose it.
 	 */
-	mutex_lock(&ep->mtx);
-	while ((rbp = rb_first_cached(&ep->rbr)) != NULL) {
+	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = next) {
+		next = rb_next(rbp);
 		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove(ep, epi);
+		ep_remove_safe(ep, epi);
 		cond_resched();
 	}
+
+	dispose = ep_refcount_dec_and_test(ep);
 	mutex_unlock(&ep->mtx);
 
-	mutex_unlock(&epmutex);
-	mutex_destroy(&ep->mtx);
-	free_uid(ep->user);
-	wakeup_source_unregister(ep->ws);
-	kfree(ep);
+	if (dispose)
+		ep_free(ep);
 }
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
@@ -794,7 +831,7 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 	struct eventpoll *ep = file->private_data;
 
 	if (ep)
-		ep_free(ep);
+		ep_clear_and_put(ep);
 
 	return 0;
 }
@@ -906,33 +943,34 @@ void eventpoll_release_file(struct file *file)
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
+	 * Use the 'dying' flag to prevent a concurrent ep_clear_and_put() from
+	 * touching the epitems list before eventpoll_release_file() can access
+	 * the ep->mtx.
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
+			ep_free(ep);
+		goto again;
 	}
-	mutex_unlock(&epmutex);
+	spin_unlock(&file->f_lock);
 }
 
 static int ep_alloc(struct eventpoll **pep)
@@ -955,6 +993,7 @@ static int ep_alloc(struct eventpoll **pep)
 	ep->rbr = RB_ROOT_CACHED;
 	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
+	refcount_set(&ep->refcount, 1);
 
 	*pep = ep;
 
@@ -1223,10 +1262,10 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 		 */
 		list_del_init(&wait->entry);
 		/*
-		 * ->whead != NULL protects us from the race with ep_free()
-		 * or ep_remove(), ep_remove_wait_queue() takes whead->lock
-		 * held by the caller. Once we nullify it, nothing protects
-		 * ep/epi or even wait.
+		 * ->whead != NULL protects us from the race with
+		 * ep_clear_and_put() or ep_remove(), ep_remove_wait_queue()
+		 * takes whead->lock held by the caller. Once we nullify it,
+		 * nothing protects ep/epi or even wait.
 		 */
 		smp_store_release(&ep_pwq_from_wait(wait)->whead, NULL);
 	}
@@ -1496,16 +1535,22 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	if (tep)
 		mutex_unlock(&tep->mtx);
 
+	/*
+	 * ep_remove_safe() calls in the later error paths can't lead to
+	 * ep_free() as the ep file itself still holds an ep reference.
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
@@ -1529,7 +1574,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	 * high memory pressure.
 	 */
 	if (unlikely(!epq.epi)) {
-		ep_remove(ep, epi);
+		ep_remove_safe(ep, epi);
 		return -ENOMEM;
 	}
 
@@ -2025,7 +2070,7 @@ static int do_epoll_create(int flags)
 out_free_fd:
 	put_unused_fd(fd);
 out_free_ep:
-	ep_free(ep);
+	ep_clear_and_put(ep);
 	return error;
 }
 
@@ -2167,10 +2212,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
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
2.39.2

