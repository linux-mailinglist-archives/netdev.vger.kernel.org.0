Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC156C0A2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbiGHS0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbiGHS0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:26:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7829A6B2;
        Fri,  8 Jul 2022 11:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F1760C1A;
        Fri,  8 Jul 2022 18:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B4FC341C6;
        Fri,  8 Jul 2022 18:25:58 +0000 (UTC)
Subject: [PATCH v3 21/32] NFSD: Refactor __nfsd_file_close_inode()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:25:57 -0400
Message-ID: <165730475728.28142.9076227274989975038.stgit@klimt.1015granger.net>
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

The code that computes the hashval is the same in both callers.

To prevent them from going stale, reframe the documenting comments
to remove descriptions of the underlying hash table structure, which
is about to be replaced.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   40 +++++++++++++++++++++-------------------
 fs/nfsd/trace.h     |   44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 4143898fff37..26d10e3c4e70 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -565,39 +565,44 @@ static struct shrinker	nfsd_file_shrinker = {
 	.seeks = 1,
 };
 
-static void
-__nfsd_file_close_inode(struct inode *inode, unsigned int hashval,
-			struct list_head *dispose)
+/*
+ * Find all cache items across all net namespaces that match @inode and
+ * move them to @dispose. The lookup is atomic wrt nfsd_file_acquire().
+ */
+static unsigned int
+__nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 {
+	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
+						NFSD_FILE_HASH_BITS);
+	unsigned int		count = 0;
 	struct nfsd_file	*nf;
 	struct hlist_node	*tmp;
 
 	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
 	hlist_for_each_entry_safe(nf, tmp, &nfsd_file_hashtbl[hashval].nfb_head, nf_node) {
-		if (inode == nf->nf_inode)
+		if (inode == nf->nf_inode) {
 			nfsd_file_unhash_and_release_locked(nf, dispose);
+			count++;
+		}
 	}
 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	return count;
 }
 
 /**
  * nfsd_file_close_inode_sync - attempt to forcibly close a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put. Also ensure that any of the
- * fputs also have their final __fput done as well.
+ * Unhash and put, then flush and fput all cache items associated with @inode.
  */
 void
 nfsd_file_close_inode_sync(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
+	unsigned int count;
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode_sync(inode, !list_empty(&dispose));
+	count = __nfsd_file_close_inode(inode, &dispose);
+	trace_nfsd_file_close_inode_sync(inode, count);
 	nfsd_file_dispose_list_sync(&dispose);
 }
 
@@ -605,19 +610,16 @@ nfsd_file_close_inode_sync(struct inode *inode)
  * nfsd_file_close_inode - attempt a delayed close of a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
- * Walk the whole hash bucket, looking for any files that correspond to "inode".
- * If any do, then unhash them and put the hashtable reference to them and
- * destroy any that had their last reference put.
+ * Unhash and put all cache item associated with @inode.
  */
 static void
 nfsd_file_close_inode(struct inode *inode)
 {
-	unsigned int		hashval = (unsigned int)hash_long(inode->i_ino,
-						NFSD_FILE_HASH_BITS);
 	LIST_HEAD(dispose);
+	unsigned int count;
 
-	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode(inode, !list_empty(&dispose));
+	count = __nfsd_file_close_inode(inode, &dispose);
+	trace_nfsd_file_close_inode(inode, count);
 	nfsd_file_dispose_list_delayed(&dispose);
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index bb5a17ccf2cd..af609590ac86 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -850,30 +850,52 @@ TRACE_EVENT(nfsd_file_open,
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
 	TP_PROTO(
-		struct inode *inode,
-		int found
+		const struct inode *inode,
+		unsigned int count
 	),
-	TP_ARGS(inode, found),
+	TP_ARGS(inode, count),
 	TP_STRUCT__entry(
-		__field(struct inode *, inode)
-		__field(int, found)
+		__field(const struct inode *, inode)
+		__field(unsigned int, count)
 	),
 	TP_fast_assign(
 		__entry->inode = inode;
-		__entry->found = found;
+		__entry->count = count;
 	),
-	TP_printk("inode=%p found=%d",
-		__entry->inode, __entry->found)
+	TP_printk("inode=%p count=%u",
+		__entry->inode, __entry->count)
 );
 
 #define DEFINE_NFSD_FILE_SEARCH_EVENT(name)				\
 DEFINE_EVENT(nfsd_file_search_class, name,				\
-	TP_PROTO(struct inode *inode, int found),			\
-	TP_ARGS(inode, found))
+	TP_PROTO(							\
+		const struct inode *inode,				\
+		unsigned int count					\
+	),								\
+	TP_ARGS(inode, count))
 
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode_sync);
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode);
-DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_is_cached);
+
+TRACE_EVENT(nfsd_file_is_cached,
+	TP_PROTO(
+		const struct inode *inode,
+		int found
+	),
+	TP_ARGS(inode, found),
+	TP_STRUCT__entry(
+		__field(const struct inode *, inode)
+		__field(int, found)
+	),
+	TP_fast_assign(
+		__entry->inode = inode;
+		__entry->found = found;
+	),
+	TP_printk("inode=%p is %scached",
+		__entry->inode,
+		__entry->found ? "" : "not "
+	)
+);
 
 TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 	TP_PROTO(struct inode *inode, u32 mask),


