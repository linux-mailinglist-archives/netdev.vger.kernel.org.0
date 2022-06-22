Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01533554C7F
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358486AbiFVOPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358433AbiFVOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D139833;
        Wed, 22 Jun 2022 07:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8DFE61B9C;
        Wed, 22 Jun 2022 14:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD70AC3411B;
        Wed, 22 Jun 2022 14:14:45 +0000 (UTC)
Subject: [PATCH RFC 18/30] NFSD: No longer record nf_hashval in the trace log
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:14:44 -0400
Message-ID: <165590728475.75778.5630229147335005562.stgit@manet.1015granger.net>
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

I'm about to replace nfsd_file_hashtbl with an rhashtable. The
individual hash values will no longer be visible or relevant, so
remove them from the tracepoints.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   15 ++++++++-------
 fs/nfsd/trace.h     |   45 +++++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 9d2e4b042b46..d620f18924a1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -598,7 +598,7 @@ nfsd_file_close_inode_sync(struct inode *inode)
 	LIST_HEAD(dispose);
 
 	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode_sync(inode, hashval, !list_empty(&dispose));
+	trace_nfsd_file_close_inode_sync(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_sync(&dispose);
 }
 
@@ -618,7 +618,7 @@ nfsd_file_close_inode(struct inode *inode)
 	LIST_HEAD(dispose);
 
 	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode(inode, hashval, !list_empty(&dispose));
+	trace_nfsd_file_close_inode(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_delayed(&dispose);
 }
 
@@ -972,7 +972,7 @@ nfsd_file_is_cached(struct inode *inode)
 		}
 	}
 	rcu_read_unlock();
-	trace_nfsd_file_is_cached(inode, hashval, (int)ret);
+	trace_nfsd_file_is_cached(inode, (int)ret);
 	return ret;
 }
 
@@ -1004,9 +1004,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	new = nfsd_file_alloc(inode, may_flags, hashval, net);
 	if (!new) {
-		trace_nfsd_file_acquire(rqstp, hashval, inode, may_flags,
-					NULL, nfserr_jukebox);
-		return nfserr_jukebox;
+		status = nfserr_jukebox;
+		goto out_status;
 	}
 
 	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
@@ -1059,8 +1058,10 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		nf = NULL;
 	}
 
-	trace_nfsd_file_acquire(rqstp, hashval, inode, may_flags, nf, status);
+out_status:
+	trace_nfsd_file_acquire(rqstp, inode, may_flags, nf, status);
 	return status;
+
 open_file:
 	nf = new;
 	/* Take reference for the hashtable */
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 954838616c51..c64336016d2c 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -704,7 +704,6 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 	TP_PROTO(struct nfsd_file *nf),
 	TP_ARGS(nf),
 	TP_STRUCT__entry(
-		__field(unsigned int, nf_hashval)
 		__field(void *, nf_inode)
 		__field(int, nf_ref)
 		__field(unsigned long, nf_flags)
@@ -712,15 +711,13 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 		__field(struct file *, nf_file)
 	),
 	TP_fast_assign(
-		__entry->nf_hashval = nf->nf_hashval;
 		__entry->nf_inode = nf->nf_inode;
 		__entry->nf_ref = refcount_read(&nf->nf_ref);
 		__entry->nf_flags = nf->nf_flags;
 		__entry->nf_may = nf->nf_may;
 		__entry->nf_file = nf->nf_file;
 	),
-	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
-		__entry->nf_hashval,
+	TP_printk("inode=%p ref=%d flags=%s may=%s nf_file=%p",
 		__entry->nf_inode,
 		__entry->nf_ref,
 		show_nf_flags(__entry->nf_flags),
@@ -740,15 +737,18 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_release_locked);
 
 TRACE_EVENT(nfsd_file_acquire,
-	TP_PROTO(struct svc_rqst *rqstp, unsigned int hash,
-		 struct inode *inode, unsigned int may_flags,
-		 struct nfsd_file *nf, __be32 status),
+	TP_PROTO(
+		struct svc_rqst *rqstp,
+		struct inode *inode,
+		unsigned int may_flags,
+		struct nfsd_file *nf,
+		__be32 status
+	),
 
-	TP_ARGS(rqstp, hash, inode, may_flags, nf, status),
+	TP_ARGS(rqstp, inode, may_flags, nf, status),
 
 	TP_STRUCT__entry(
 		__field(u32, xid)
-		__field(unsigned int, hash)
 		__field(void *, inode)
 		__field(unsigned long, may_flags)
 		__field(int, nf_ref)
@@ -760,7 +760,6 @@ TRACE_EVENT(nfsd_file_acquire,
 
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-		__entry->hash = hash;
 		__entry->inode = inode;
 		__entry->may_flags = may_flags;
 		__entry->nf_ref = nf ? refcount_read(&nf->nf_ref) : 0;
@@ -770,8 +769,8 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->status = be32_to_cpu(status);
 	),
 
-	TP_printk("xid=0x%x hash=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
-			__entry->xid, __entry->hash, __entry->inode,
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
+			__entry->xid, __entry->inode,
 			show_nfsd_may_flags(__entry->may_flags),
 			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
 			show_nfsd_may_flags(__entry->nf_may),
@@ -782,7 +781,6 @@ TRACE_EVENT(nfsd_file_open,
 	TP_PROTO(struct nfsd_file *nf, __be32 status),
 	TP_ARGS(nf, status),
 	TP_STRUCT__entry(
-		__field(unsigned int, nf_hashval)
 		__field(void *, nf_inode)	/* cannot be dereferenced */
 		__field(int, nf_ref)
 		__field(unsigned long, nf_flags)
@@ -790,15 +788,13 @@ TRACE_EVENT(nfsd_file_open,
 		__field(void *, nf_file)	/* cannot be dereferenced */
 	),
 	TP_fast_assign(
-		__entry->nf_hashval = nf->nf_hashval;
 		__entry->nf_inode = nf->nf_inode;
 		__entry->nf_ref = refcount_read(&nf->nf_ref);
 		__entry->nf_flags = nf->nf_flags;
 		__entry->nf_may = nf->nf_may;
 		__entry->nf_file = nf->nf_file;
 	),
-	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
-		__entry->nf_hashval,
+	TP_printk("inode=%p ref=%d flags=%s may=%s file=%p",
 		__entry->nf_inode,
 		__entry->nf_ref,
 		show_nf_flags(__entry->nf_flags),
@@ -807,26 +803,27 @@ TRACE_EVENT(nfsd_file_open,
 )
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
-	TP_PROTO(struct inode *inode, unsigned int hash, int found),
-	TP_ARGS(inode, hash, found),
+	TP_PROTO(
+		struct inode *inode,
+		int found
+	),
+	TP_ARGS(inode, found),
 	TP_STRUCT__entry(
 		__field(struct inode *, inode)
-		__field(unsigned int, hash)
 		__field(int, found)
 	),
 	TP_fast_assign(
 		__entry->inode = inode;
-		__entry->hash = hash;
 		__entry->found = found;
 	),
-	TP_printk("hash=0x%x inode=%p found=%d", __entry->hash,
-			__entry->inode, __entry->found)
+	TP_printk("inode=%p found=%d",
+		__entry->inode, __entry->found)
 );
 
 #define DEFINE_NFSD_FILE_SEARCH_EVENT(name)				\
 DEFINE_EVENT(nfsd_file_search_class, name,				\
-	TP_PROTO(struct inode *inode, unsigned int hash, int found),	\
-	TP_ARGS(inode, hash, found))
+	TP_PROTO(struct inode *inode, int found),			\
+	TP_ARGS(inode, found))
 
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode_sync);
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode);


