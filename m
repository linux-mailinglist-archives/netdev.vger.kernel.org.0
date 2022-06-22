Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9976C554C78
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358449AbiFVOOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358381AbiFVOOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:14:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1909639826;
        Wed, 22 Jun 2022 07:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AECD61BDC;
        Wed, 22 Jun 2022 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D3CC34114;
        Wed, 22 Jun 2022 14:14:19 +0000 (UTC)
Subject: [PATCH RFC 14/30] NFSD: Trace filecache LRU activity
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:14:18 -0400
Message-ID: <165590725828.75778.9811900270893499412.stgit@manet.1015granger.net>
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

Observe the operation of garbage collection and the lifetime of
filecache items.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   44 +++++++++++++++++++++++++++++++-------------
 fs/nfsd/trace.h     |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6bb37d3abbaa..1f65065cd325 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -268,6 +268,18 @@ nfsd_file_flush(struct nfsd_file *nf)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
+static void nfsd_file_lru_add(struct nfsd_file *nf)
+{
+	if (list_lru_add(&nfsd_file_lru, &nf->nf_lru))
+		trace_nfsd_file_lru_add(nf);
+}
+
+static void nfsd_file_lru_remove(struct nfsd_file *nf)
+{
+	if (list_lru_del(&nfsd_file_lru, &nf->nf_lru))
+		trace_nfsd_file_lru_del(nf);
+}
+
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
@@ -287,8 +299,7 @@ nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_do_unhash(nf);
-		if (!list_empty(&nf->nf_lru))
-			list_lru_del(&nfsd_file_lru, &nf->nf_lru);
+		nfsd_file_lru_remove(nf);
 		return true;
 	}
 	return false;
@@ -451,26 +462,33 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	 * counter. Here we check the counter and then test and clear the flag.
 	 * That order is deliberate to ensure that we can do this locklessly.
 	 */
-	if (refcount_read(&nf->nf_ref) > 1)
-		goto out_skip;
+	if (refcount_read(&nf->nf_ref) > 1) {
+		trace_nfsd_file_gc_in_use(nf);
+		return LRU_SKIP;
+	}
 
 	/*
 	 * Don't throw out files that are still undergoing I/O or
 	 * that have uncleared errors pending.
 	 */
-	if (nfsd_file_check_writeback(nf))
-		goto out_skip;
+	if (nfsd_file_check_writeback(nf)) {
+		trace_nfsd_file_gc_writeback(nf);
+		return LRU_SKIP;
+	}
 
-	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags))
-		goto out_skip;
+	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
+		trace_nfsd_file_gc_referenced(nf);
+		return LRU_SKIP;
+	}
 
-	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags))
-		goto out_skip;
+	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
+		trace_nfsd_file_gc_hashed(nf);
+		return LRU_SKIP;
+	}
 
 	list_lru_isolate_move(lru, &nf->nf_lru, head);
+	trace_nfsd_file_gc_disposed(nf);
 	return LRU_REMOVED;
-out_skip:
-	return LRU_SKIP;
 }
 
 /*
@@ -1040,7 +1058,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	refcount_inc(&nf->nf_ref);
 	__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 	__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
-	list_lru_add(&nfsd_file_lru, &nf->nf_lru);
+	nfsd_file_lru_add(nf);
 	hlist_add_head_rcu(&nf->nf_node, &nfsd_file_hashtbl[hashval].nfb_head);
 	++nfsd_file_hashtbl[hashval].nfb_count;
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c055c6361bd5..e56fe3dfa44c 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -851,6 +851,45 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+DECLARE_EVENT_CLASS(nfsd_file_gc_class,
+	TP_PROTO(
+		const struct nfsd_file *nf
+	),
+	TP_ARGS(nf),
+	TP_STRUCT__entry(
+		__field(void *, nf_inode)
+		__field(void *, nf_file)
+		__field(int, nf_ref)
+		__field(unsigned long, nf_flags)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_file = nf->nf_file;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_flags = nf->nf_flags;
+	),
+	TP_printk("inode=%p ref=%d nf_flags=%s nf_file=%p",
+		__entry->nf_inode, __entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		__entry->nf_file
+	)
+);
+
+#define DEFINE_NFSD_FILE_GC_EVENT(name)					\
+DEFINE_EVENT(nfsd_file_gc_class, name,					\
+	TP_PROTO(							\
+		const struct nfsd_file *nf				\
+	),								\
+	TP_ARGS(nf))
+
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_add);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_lru_del);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_in_use);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_writeback);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_referenced);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_hashed);
+DEFINE_NFSD_FILE_GC_EVENT(nfsd_file_gc_disposed);
+
 DECLARE_EVENT_CLASS(nfsd_file_lruwalk_class,
 	TP_PROTO(
 		unsigned long evicted,


