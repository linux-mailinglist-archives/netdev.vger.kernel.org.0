Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FC156BF6F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbiGHS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbiGHS1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5543D9A68C;
        Fri,  8 Jul 2022 11:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D29C625C6;
        Fri,  8 Jul 2022 18:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34003C341C0;
        Fri,  8 Jul 2022 18:26:31 +0000 (UTC)
Subject: [PATCH v3 26/32] NFSD: Convert the filecache to use rhashtable
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:26:30 -0400
Message-ID: <165730479027.28142.17726783565248628509.stgit@klimt.1015granger.net>
In-Reply-To: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5.dev3+g9561319
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

Suggested-by: Jeff Layton <jlayton@kernel.org>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  265 +++++++++++++++++++++++----------------------------
 fs/nfsd/trace.h     |   63 ++++++++++++
 2 files changed, 179 insertions(+), 149 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index bc2ec7db4927..7ae243ddf631 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -62,7 +62,6 @@ static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
 static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
-static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
 static struct rhashtable		nfsd_file_rhash_tbl
 						____cacheline_aligned_in_smp;
@@ -198,7 +197,7 @@ static const struct rhashtable_params nfsd_file_rhash_params = {
 static void
 nfsd_file_schedule_laundrette(void)
 {
-	if ((atomic_long_read(&nfsd_filecache_count) == 0) ||
+	if ((atomic_read(&nfsd_file_rhash_tbl.nelems) == 0) ||
 	    test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
 		return;
 
@@ -298,7 +297,7 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 }
 
 static struct nfsd_file *
-nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
+nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 {
 	struct nfsd_file *nf;
 
@@ -309,11 +308,14 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
 		nf->nf_cred = get_current_cred();
-		nf->nf_net = net;
+		nf->nf_net = key->net;
 		nf->nf_flags = 0;
-		nf->nf_inode = inode;
-		refcount_set(&nf->nf_ref, 1);
-		nf->nf_may = may & NFSD_FILE_MAY_MASK;
+		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
+		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
+		nf->nf_inode = key->inode;
+		/* nf_ref is pre-incremented for hash table */
+		refcount_set(&nf->nf_ref, 2);
+		nf->nf_may = key->need;
 		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
 			if (may & NFSD_MAY_WRITE)
 				__set_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags);
@@ -405,40 +407,21 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
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
@@ -448,9 +431,9 @@ nfsd_file_unhash(struct nfsd_file *nf)
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
@@ -709,20 +692,23 @@ static struct shrinker	nfsd_file_shrinker = {
 static unsigned int
 __nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
-	unsigned int		count = 0;
-	struct nfsd_file	*nf;
-	struct hlist_node	*tmp;
-
-	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	hlist_for_each_entry_safe(nf, tmp, &nfsd_file_hashtbl[hashval].nfb_head, nf_node) {
-		if (inode == nf->nf_inode) {
-			nfsd_file_unhash_and_release_locked(nf, dispose);
-			count++;
-		}
-	}
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_INODE,
+		.inode	= inode,
+	};
+	unsigned int count = 0;
+	struct nfsd_file *nf;
+
+	rcu_read_lock();
+	do {
+		nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
+				       nfsd_file_rhash_params);
+		if (!nf)
+			break;
+		nfsd_file_unhash_and_dispose(nf, dispose);
+		count++;
+	} while (1);
+	rcu_read_unlock();
 	return count;
 }
 
@@ -930,30 +916,35 @@ nfsd_file_cache_init(void)
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
@@ -1058,56 +1049,29 @@ nfsd_file_cache_shutdown(void)
 	}
 }
 
-static struct nfsd_file *
-nfsd_file_find_locked(struct inode *inode, unsigned int may_flags,
-			unsigned int hashval, struct net *net)
-{
-	struct nfsd_file *nf;
-	unsigned char need = may_flags & NFSD_FILE_MAY_MASK;
-
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
-}
-
 /**
- * nfsd_file_is_cached - are there any cached open files for this fh?
- * @inode: inode of the file to check
+ * nfsd_file_is_cached - are there any cached open files for this inode?
+ * @inode: inode to check
+ *
+ * The lookup matches inodes in all net namespaces and is atomic wrt
+ * nfsd_file_acquire().
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
@@ -1116,39 +1080,51 @@ static __be32
 nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		     unsigned int may_flags, struct nfsd_file **pnf, bool open)
 {
-	__be32	status;
-	struct net *net = SVC_NET(rqstp);
+	struct nfsd_file_lookup_key key = {
+		.type	= NFSD_FILE_KEY_FULL,
+		.need	= may_flags & NFSD_FILE_MAY_MASK,
+		.net	= SVC_NET(rqstp),
+	};
 	struct nfsd_file *nf, *new;
-	struct inode *inode;
-	unsigned int hashval;
 	bool retry = true;
+	__be32 status;
 
-	/* FIXME: skip this if fh_dentry is already set? */
 	status = fh_verify(rqstp, fhp, S_IFREG,
 				may_flags|NFSD_MAY_OWNER_OVERRIDE);
 	if (status != nfs_ok)
 		return status;
+	key.inode = d_inode(fhp->fh_dentry);
+	key.cred = get_current_cred();
 
-	inode = d_inode(fhp->fh_dentry);
-	hashval = (unsigned int)hash_long(inode->i_ino, NFSD_FILE_HASH_BITS);
 retry:
-	rcu_read_lock();
-	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
-	rcu_read_unlock();
+	/* Avoid allocation if the item is already in cache */
+	nf = rhashtable_lookup_fast(&nfsd_file_rhash_tbl, &key,
+				    nfsd_file_rhash_params);
+	if (nf)
+		nf = nfsd_file_get(nf);
 	if (nf)
 		goto wait_for_construction;
 
-	new = nfsd_file_alloc(inode, may_flags, net);
+	new = nfsd_file_alloc(&key, may_flags);
 	if (!new) {
 		status = nfserr_jukebox;
 		goto out_status;
 	}
 
-	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
-	if (nf == NULL)
+	nf = rhashtable_lookup_get_insert_key(&nfsd_file_rhash_tbl,
+					      &key, &new->nf_rhash,
+					      nfsd_file_rhash_params);
+	if (!nf) {
+		nf = new;
+		goto open_file;
+	}
+	if (IS_ERR(nf))
+		goto insert_err;
+	nf = nfsd_file_get(nf);
+	if (nf == NULL) {
+		nf = new;
 		goto open_file;
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	}
 	nfsd_file_slab_free(&new->nf_rcu);
 
 wait_for_construction:
@@ -1156,6 +1132,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	/* Did construction of this file fail? */
 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
+		trace_nfsd_file_cons_err(rqstp, key.inode, may_flags, nf);
 		if (!retry) {
 			status = nfserr_jukebox;
 			goto out;
@@ -1194,22 +1171,11 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 out_status:
-	trace_nfsd_file_acquire(rqstp, inode, may_flags, nf, status);
+	put_cred(key.cred);
+	trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
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
@@ -1224,19 +1190,20 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
+	if (status != nfs_ok || key.inode->i_nlink == 0)
+		if (nfsd_file_unhash(nf))
 			nfsd_file_put_noref(nf);
-	}
 	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
 	smp_mb__after_atomic();
 	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
 	goto out;
+
+insert_err:
+	nfsd_file_slab_free(&new->nf_rcu);
+	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, PTR_ERR(nf));
+	nf = NULL;
+	status = nfserr_jukebox;
+	goto out_status;
 }
 
 /**
@@ -1282,21 +1249,23 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
 	unsigned long hits = 0, acquisitions = 0;
-	unsigned int i, count = 0, longest = 0;
+	unsigned int i, count = 0, buckets = 0;
 	unsigned long lru = 0, total_age = 0;
 
-	/*
-	 * No need for spinlocks here since we're not terribly interested in
-	 * accuracy. We do take the nfsd_mutex simply to ensure that we
-	 * don't end up racing with server shutdown
-	 */
+	/* Serialize with server shutdown */
 	mutex_lock(&nfsd_mutex);
 	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1) {
-		for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
-			count += nfsd_file_hashtbl[i].nfb_count;
-			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
-		}
+		struct bucket_table *tbl;
+		struct rhashtable *ht;
+
 		lru = list_lru_count(&nfsd_file_lru);
+
+		rcu_read_lock();
+		ht = &nfsd_file_rhash_tbl;
+		count = atomic_read(&ht->nelems);
+		tbl = rht_dereference_rcu(ht->tbl, ht);
+		buckets = tbl->size;
+		rcu_read_unlock();
 	}
 	mutex_unlock(&nfsd_mutex);
 
@@ -1310,7 +1279,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
-	seq_printf(m, "longest chain: %u\n", longest);
+	seq_printf(m, "hash buckets:  %u\n", buckets);
 	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index af609590ac86..68b02497233d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -780,7 +780,7 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_alloc);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put_final);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
-DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_release_locked);
+DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
@@ -823,6 +823,67 @@ TRACE_EVENT(nfsd_file_acquire,
 			__entry->nf_file, __entry->status)
 );
 
+TRACE_EVENT(nfsd_file_insert_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		const struct inode *inode,
+		unsigned int may_flags,
+		long error
+	),
+	TP_ARGS(rqstp, inode, may_flags, error),
+	TP_STRUCT__entry(
+		__field(u32, xid)
+		__field(const void *, inode)
+		__field(unsigned long, may_flags)
+		__field(long, error)
+	),
+	TP_fast_assign(
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->inode = inode;
+		__entry->may_flags = may_flags;
+		__entry->error = error;
+	),
+	TP_printk("xid=0x%x inode=%p may_flags=%s error=%ld",
+		__entry->xid, __entry->inode,
+		show_nfsd_may_flags(__entry->may_flags),
+		__entry->error
+	)
+);
+
+TRACE_EVENT(nfsd_file_cons_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		const struct inode *inode,
+		unsigned int may_flags,
+		const struct nfsd_file *nf
+	),
+	TP_ARGS(rqstp, inode, may_flags, nf),
+	TP_STRUCT__entry(
+		__field(u32, xid)
+		__field(const void *, inode)
+		__field(unsigned long, may_flags)
+		__field(unsigned int, nf_ref)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(const void *, nf_file)
+	),
+	TP_fast_assign(
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->inode = inode;
+		__entry->may_flags = may_flags;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_file = nf->nf_file;
+	),
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p",
+		__entry->xid, __entry->inode,
+		show_nfsd_may_flags(__entry->may_flags), __entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may), __entry->nf_file
+	)
+);
+
 TRACE_EVENT(nfsd_file_open,
 	TP_PROTO(struct nfsd_file *nf, __be32 status),
 	TP_ARGS(nf, status),


