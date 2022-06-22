Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C84C554C7E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358356AbiFVOOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358355AbiFVOOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBD3A19B;
        Wed, 22 Jun 2022 07:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E785761BE0;
        Wed, 22 Jun 2022 14:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D24C341C5;
        Wed, 22 Jun 2022 14:14:25 +0000 (UTC)
Subject: [PATCH RFC 15/30] NFSD: Leave open files out of the filecache LRU
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:14:25 -0400
Message-ID: <165590726500.75778.8402041608666998635.stgit@manet.1015granger.net>
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

There have been reports of problems when running fstests generic/531
against Linux NFS servers with NFSv4. The NFS server that hosts the
test's SCRATCH_DEV suffers from CPU soft lock-ups during the test.
Analysis shows that:

fs/nfsd/filecache.c
 482                 ret = list_lru_walk(&nfsd_file_lru,
 483                                 nfsd_file_lru_cb,
 484                                 &head, LONG_MAX);

causes nfsd_file_gc() to walk the entire length of the filecache LRU
list every time it is called (which is quite frequently). The walk
holds a spinlock the entire time that prevents other nfsd threads
from accessing the filecache.

What's more, for NFSv4 workloads, none of the items that are visited
during this walk may be evicted, since they are all files that are
held OPEN by NFS clients.

Address this by ensuring that open files are not kept on the LRU
list.

Reported-by: Frank van der Linden <fllinden@amazon.com>
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=386
Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   24 +++++++++++++++++++-----
 fs/nfsd/trace.h     |    2 ++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1f65065cd325..65085853cc42 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -270,6 +270,7 @@ nfsd_file_flush(struct nfsd_file *nf)
 
 static void nfsd_file_lru_add(struct nfsd_file *nf)
 {
+	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
 	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
 		trace_nfsd_file_lru_add(nf);
 }
@@ -299,7 +300,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_do_unhash(nf);
-		nfsd_file_lru_remove(nf);
 		return true;
 	}
 	return false;
@@ -320,6 +320,7 @@ nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *disp
 	if (refcount_dec_not_one(&nf->nf_ref))
 		return true;
 
+	nfsd_file_lru_remove(nf);
 	list_add(&nf->nf_lru, dispose);
 	return true;
 }
@@ -331,6 +332,7 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 
 	if (refcount_dec_and_test(&nf->nf_ref)) {
 		WARN_ON(test_bit(NFSD_FILE_HASHED, &nf->nf_flags));
+		nfsd_file_lru_remove(nf);
 		nfsd_file_free(nf);
 	}
 }
@@ -340,7 +342,7 @@ nfsd_file_put(struct nfsd_file *nf)
 {
 	might_sleep();
 
-	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
+	nfsd_file_lru_add(nf);
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
@@ -440,8 +442,18 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
 	}
 }
 
-/*
+/**
+ * nfsd_file_lru_cb - Examine an entry on the LRU list
+ * @item: LRU entry to examine
+ * @lru: controlling LRU
+ * @lock: LRU list lock (unused)
+ * @arg: dispose list
+ *
  * Note this can deadlock with nfsd_file_cache_purge.
+ *
+ * Return values:
+ *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
 nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
@@ -463,8 +475,9 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	 * That order is deliberate to ensure that we can do this locklessly.
 	 */
 	if (refcount_read(&nf->nf_ref) > 1) {
+		list_lru_isolate(lru, &nf->nf_lru);
 		trace_nfsd_file_gc_in_use(nf);
-		return LRU_SKIP;
+		return LRU_REMOVED;
 	}
 
 	/*
@@ -1023,6 +1036,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto retry;
 	}
 
+	nfsd_file_lru_remove(nf);
 	this_cpu_inc(nfsd_file_cache_hits);
 
 	if (!(may_flags & NFSD_MAY_NOT_BREAK_LEASE)) {
@@ -1058,7 +1072,6 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	refcount_inc(&nf->nf_ref);
 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
-	nfsd_file_lru_add(nf);
 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
 	++nfsd_file_hashtbl[hashval].nfb_count;
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
@@ -1083,6 +1096,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 */
 	if (status != nfs_ok || inode->i_nlink == 0) {
 		bool do_free;
+		nfsd_file_lru_remove(nf);
 		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
 		do_free = nfsd_file_unhash(nf);
 		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index e56fe3dfa44c..954838616c51 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -883,7 +883,9 @@ DEFINE_EVENT(nfsd_file_gc_class, name,					\
 	TP_ARGS(nf))
 
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add_disposed);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del_disposed);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
 DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);


