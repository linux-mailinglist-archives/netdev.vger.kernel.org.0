Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF88F554CA7
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357924AbiFVORM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358315AbiFVOQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF95412091;
        Wed, 22 Jun 2022 07:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 752EDB81EB6;
        Wed, 22 Jun 2022 14:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B547AC34114;
        Wed, 22 Jun 2022 14:15:57 +0000 (UTC)
Subject: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:56 -0400
Message-ID: <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
In-Reply-To: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
User-Agent: StGit/1.5.dev2+g9ce680a5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the filecache hash table to start small, then grow with the
workload. Smaller server deployments benefit because there should
be lower memory utilization. Larger server deployments should see
improved scaling with the number of open files.

I know this is a big and messy patch, but there's no good way to
rip out and replace a data structure like this.

Suggested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  259 ++++++++++++++++++++++++---------------------------
 fs/nfsd/trace.h     |    2 
 2 files changed, 125 insertions(+), 136 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index a491519598fc..14b607e544bf 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -62,7 +62,6 @@ static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
 static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
-static atomic_long_t			nfsd_filecache_count;
 static atomic_long_t			nfsd_file_total_age;
 static struct delayed_work		nfsd_filecache_laundrette;
 
@@ -170,7 +169,7 @@ static const struct rhashtable_params nfsd_file_rhash_params = {
 static void
 nfsd_file_schedule_laundrette(void)
 {
-	if ((atomic_long_read(&nfsd_filecache_count) == 0) ||
+	if ((atomic_read(&nfsd_file_rhash_tbl.nelems) == 0) ||
 	    test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
 		return;
 
@@ -282,9 +281,10 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 		nf->nf_file = NULL;
 		nf->nf_cred = get_current_cred();
 		nf->nf_net = net;
-		nf->nf_flags = 0;
+		nf->nf_flags = BIT(NFSD_FILE_HASHED) | BIT(NFSD_FILE_PENDING);
 		nf->nf_inode = inode;
-		refcount_set(&nf->nf_ref, 1);
+		/* nf_ref is pre-incremented for hash table */
+		refcount_set(&nf->nf_ref, 2);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
 		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
 			if (may & NFSD_MAY_WRITE)
@@ -377,40 +377,21 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
 }
 
 static void
-nfsd_file_do_unhash(struct nfsd_file *nf)
+nfsd_file_hash_remove(struct nfsd_file *nf)
 {
-	struct inode *inode = nf->nf_inode;
-	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
-				NFSD_FILE_HASH_BITS);
-
-	lockdep_assert_held(&nfsd_file_hashtbl[hashval].nfb_lock);
-
 	trace_nfsd_file_unhash(nf);
 
 	if (nfsd_file_check_write_error(nf))
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-	--nfsd_file_hashtbl[hashval].nfb_count;
-	hlist_del_rcu(&nf->nf_node);
-	atomic_long_dec(&nfsd_filecache_count);
-}
-
-static void
-nfsd_file_hash_remove(struct nfsd_file *nf)
-{
-	struct inode *inode = nf->nf_inode;
-	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
-				NFSD_FILE_HASH_BITS);
-
-	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	nfsd_file_do_unhash(nf);
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	rhashtable_remove_fast(&nfsd_file_rhash_tbl, &nf->nf_rhash,
+			       nfsd_file_rhash_params);
 }
 
 static bool
 nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
-		nfsd_file_do_unhash(nf);
+		nfsd_file_hash_remove(nf);
 		return true;
 	}
 	return false;
@@ -420,9 +401,9 @@ nfsd_file_unhash(struct nfsd_file *nf)
  * Return true if the file was unhashed.
  */
 static bool
-nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *dispose)
+nfsd_file_unhash_and_dispose(struct nfsd_file *nf, struct list_head *dispose)
 {
-	trace_nfsd_file_unhash_and_release_locked(nf);
+	trace_nfsd_file_unhash_and_dispose(nf);
 	if (!nfsd_file_unhash(nf))
 		return false;
 	/* keep final reference for nfsd_file_lru_dispose */
@@ -683,17 +664,21 @@ static struct shrinker	nfsd_file_shrinker = {
 static void
 __nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
-	struct nfsd_file	*nf;
-	struct hlist_node	*tmp;
-
-	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	hlist_for_each_entry_safe(nf, tmp, &nfsd_file_hashtbl[hashval].nfb_head, nf_node) {
-		if (inode == nf->nf_inode)
-			nfsd_file_unhash_and_release_locked(nf, dispose);
-	}
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_INODE,
+		.inode	= inode,
+	};
+	struct nfsd_file *nf;
+
+	rcu_read_lock();
+	do {
+		nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
+				       nfsd_file_rhash_params);
+		if (!nf)
+			break;
+		nfsd_file_unhash_and_dispose(nf, dispose);
+	} while (1);
+	rcu_read_unlock();
 }
 
 /**
@@ -895,30 +880,39 @@ nfsd_file_cache_init(void)
 static void
 __nfsd_file_cache_purge(struct net *net)
 {
-	unsigned int		i;
-	struct nfsd_file	*nf;
-	struct hlist_node	*next;
+	struct rhashtable_iter iter;
+	struct nfsd_file *nf;
 	LIST_HEAD(dispose);
 	bool del;
 
-	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
-		struct nfsd_fcache_bucket *nfb = &nfsd_file_hashtbl[i];
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
+		return;
+
+	rhashtable_walk_enter(&nfsd_file_rhash_tbl, &iter);
+	do {
+		rhashtable_walk_start(&iter);
 
-		spin_lock(&nfb->nfb_lock);
-		hlist_for_each_entry_safe(nf, next, &nfb->nfb_head, nf_node) {
+		nf = rhashtable_walk_next(&iter);
+		while (!IS_ERR_OR_NULL(nf)) {
 			if (net && nf->nf_net != net)
 				continue;
-			del = nfsd_file_unhash_and_release_locked(nf, &dispose);
+			del = nfsd_file_unhash_and_dispose(nf, &dispose);
 
 			/*
 			 * Deadlock detected! Something marked this entry as
 			 * unhased, but hasn't removed it from the hash list.
 			 */
 			WARN_ON_ONCE(!del);
+
+			nf = rhashtable_walk_next(&iter);
 		}
-		spin_unlock(&nfb->nfb_lock);
-		nfsd_file_dispose_list(&dispose);
-	}
+
+		rhashtable_walk_stop(&iter);
+	} while (nf == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+
+	nfsd_file_dispose_list(&dispose);
 }
 
 static struct nfsd_fcache_disposal *
@@ -1025,55 +1019,73 @@ nfsd_file_cache_shutdown(void)
 }
 
 static struct nfsd_file *
-nfsd_file_find_locked(struct inode *inode, unsigned int may_flags,
-			unsigned int hashval, struct net *net)
+nfsd_file_find(struct inode *inode, unsigned int may_flags, struct net *net)
 {
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_FULL,
+		.inode	= inode,
+		.need	= may_flags & NFSD_FILE_MAY_MASK,
+		.net	= net,
+		.cred	= current_cred(),
+	};
 	struct nfsd_file *nf;
-	unsigned char need = may_flags & NFSD_FILE_MAY_MASK;
 
-	hlist_for_each_entry_rcu(nf, &nfsd_file_hashtbl[hashval].nfb_head,
-				 nf_node, lockdep_is_held(&nfsd_file_hashtbl[hashval].nfb_lock)) {
-		if (nf->nf_may != need)
-			continue;
-		if (nf->nf_inode != inode)
-			continue;
-		if (nf->nf_net != net)
-			continue;
-		if (!nfsd_match_cred(nf->nf_cred, current_cred()))
-			continue;
-		if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags))
-			continue;
-		if (nfsd_file_get(nf) != NULL)
-			return nf;
-	}
-	return NULL;
+	rcu_read_lock();
+	nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
+			       nfsd_file_rhash_params);
+	if (nf)
+		nf = nfsd_file_get(nf);
+	rcu_read_unlock();
+	return nf;
+}
+
+/*
+ * Atomically insert a new nfsd_file item into nfsd_file_rhash_tbl.
+ *
+ * Return values:
+ *   %NULL: @new was inserted successfully
+ *   %A valid pointer: @new was not inserted, a matching item is returned
+ *   %ERR_PTR: an unexpected error occurred during insertion
+ */
+static struct nfsd_file *nfsd_file_insert(struct nfsd_file *new)
+{
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_FULL,
+		.inode	= new->nf_inode,
+		.need	= new->nf_flags,
+		.net	= new->nf_net,
+		.cred	= current_cred(),
+	};
+	struct nfsd_file *nf;
+
+	nf = rhashtable_lookup_get_insert_key(&nfsd_file_rhash_tbl,
+					      &key, &new->nf_rhash,
+					      nfsd_file_rhash_params);
+	if (!nf)
+		return nf;
+	return nfsd_file_get(nf);
 }
 
 /**
- * nfsd_file_is_cached - are there any cached open files for this fh?
- * @inode: inode of the file to check
+ * nfsd_file_is_cached - are there any cached open files for this inode?
+ * @inode: inode to check
  *
- * Scan the hashtable for open files that match this fh. Returns true if there
- * are any, and false if not.
+ * Return values:
+ *   %true: filecache contains at least one file matching this inode
+ *   %false: filecache contains no files matching this inode
  */
 bool
 nfsd_file_is_cached(struct inode *inode)
 {
-	bool			ret = false;
-	struct nfsd_file	*nf;
-	unsigned int		hashval;
-
-        hashval = (unsigned int)hash_long(inode->i_ino, NFSD_FILE_HASH_BITS);
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(nf, &nfsd_file_hashtbl[hashval].nfb_head,
-				 nf_node) {
-		if (inode == nf->nf_inode) {
-			ret = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_INODE,
+		.inode	= inode,
+	};
+	bool ret = false;
+
+	if (rhashtable_lookup_fast(&nfsd_file_rhash_tbl, &key,
+				   nfsd_file_rhash_params) != NULL)
+		ret = true;
 	trace_nfsd_file_is_cached(inode, (int)ret);
 	return ret;
 }
@@ -1086,7 +1098,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct net *net = SVC_NET(rqstp);
 	struct nfsd_file *nf, *new;
 	struct inode *inode;
-	unsigned int hashval;
 	bool retry = true;
 
 	status = fh_verify(rqstp, fhp, S_IFREG,
@@ -1095,12 +1106,9 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		return status;
 
 	inode = d_inode(fhp->fh_dentry);
-	hashval = (unsigned int)hash_long(inode->i_ino, NFSD_FILE_HASH_BITS);
 retry:
 	/* Avoid allocation if the item is already in cache */
-	rcu_read_lock();
-	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
-	rcu_read_unlock();
+	nf = nfsd_file_find(inode, may_flags, net);
 	if (nf == NULL) {
 		new = nfsd_file_alloc(inode, may_flags, net);
 		if (!new) {
@@ -1108,18 +1116,20 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			goto out_status;
 		}
 
-		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-		nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
-		if (nf == NULL)
+		nf = nfsd_file_insert(new);
+		if (nf == NULL) {
+			nf = new;
 			goto open_file;
-		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+		}
 
 		nfsd_file_slab_free(&new->nf_rcu);
+		if (IS_ERR(nf)) {
+			status = nfserr_jukebox;
+			goto out_status;
+		}
 	}
 
 	wait_on_bit(&nf->nf_flags, NFSD_FILE_PENDING, TASK_UNINTERRUPTIBLE);
-
-	/* Did construction of this file fail? */
 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		this_cpu_inc(nfsd_file_cons_fails);
 		if (!retry) {
@@ -1128,6 +1138,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		}
 		retry = false;
 		nfsd_file_put_noref(nf);
+		cond_resched();
 		goto retry;
 	}
 
@@ -1164,18 +1175,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return status;
 
 open_file:
-	nf = new;
-	/* Take reference for the hashtable */
-	refcount_inc(&nf->nf_ref);
-	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
-	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
-	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
-	++nfsd_file_hashtbl[hashval].nfb_count;
-	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
-			nfsd_file_hashtbl[hashval].nfb_count);
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	atomic_long_inc(&nfsd_filecache_count);
-
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
 		if (open) {
@@ -1190,15 +1189,9 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * If construction failed, or we raced with a call to unlink()
 	 * then unhash.
 	 */
-	if (status != nfs_ok || inode->i_nlink == 0) {
-		bool do_free;
-		nfsd_file_lru_remove(nf);
-		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-		do_free = nfsd_file_unhash(nf);
-		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-		if (do_free)
+	if (status != nfs_ok || inode->i_nlink == 0)
+		if (nfsd_file_unhash(nf))
 			nfsd_file_put_noref(nf);
-	}
 	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
 	smp_mb__after_atomic();
 	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
@@ -1248,21 +1241,15 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
 	unsigned long hits = 0, acquisitions = 0, cons_fails = 0;
-	unsigned int i, count = 0, longest = 0;
+	struct bucket_table *tbl;
+	int i;
 
-	/*
-	 * No need for spinlocks here since we're not terribly interested in
-	 * accuracy. We do take the nfsd_mutex simply to ensure that we
-	 * don't end up racing with server shutdown
-	 */
+	/* Serialize with server shutdown */
 	mutex_lock(&nfsd_mutex);
-	if (nfsd_file_hashtbl) {
-		for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
-			count += nfsd_file_hashtbl[i].nfb_count;
-			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
-		}
-	}
-	mutex_unlock(&nfsd_mutex);
+
+	rcu_read_lock();
+	tbl = rht_dereference_rcu(nfsd_file_rhash_tbl.tbl, &nfsd_file_rhash_tbl);
+	rcu_read_unlock();
 
 	for_each_possible_cpu(i) {
 		hits += per_cpu(nfsd_file_cache_hits, i);
@@ -1273,8 +1260,8 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		cons_fails += per_cpu(nfsd_file_cons_fails, i);
 	}
 
-	seq_printf(m, "total entries: %u\n", count);
-	seq_printf(m, "longest chain: %u\n", longest);
+	seq_printf(m, "total entries: %d\n", atomic_read(&nfsd_file_rhash_tbl.nelems));
+	seq_printf(m, "hash buckets:  %u\n", tbl->size);
 	seq_printf(m, "lru entries:   %lu\n", list_lru_count(&nfsd_file_lru));
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
@@ -1287,6 +1274,8 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		seq_printf(m, "mean age (ms): -\n");
 	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	seq_printf(m, "cons fails:    %lu\n", cons_fails);
+
+	mutex_unlock(&nfsd_mutex);
 	return 0;
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c64336016d2c..ac2712271b08 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -734,7 +734,7 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_alloc);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put_final);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
-DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_release_locked);
+DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(


