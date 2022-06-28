Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124CB55EC30
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiF1SI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiF1SIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:08:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4710561;
        Tue, 28 Jun 2022 11:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93026B81F27;
        Tue, 28 Jun 2022 18:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F297C3411D;
        Tue, 28 Jun 2022 18:08:49 +0000 (UTC)
Subject: [PATCH v2 28/31] NFSD: Separate tracepoints for acquire and create
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:08:49 -0400
Message-ID: <165643972912.84360.10155047066229996784.stgit@manet.1015granger.net>
In-Reply-To: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
References: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
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

These tracepoints collect different information: the create case does
not open a file, so there's no nf_file available.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    9 +++++----
 fs/nfsd/nfs4state.c |    1 +
 fs/nfsd/trace.h     |   54 +++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 392e5b65ac1b..0c7f86e81f4e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1047,7 +1047,7 @@ nfsd_file_is_cached(struct inode *inode)
 }
 
 static __be32
-nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
+nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		     unsigned int may_flags, struct nfsd_file **pnf, bool open)
 {
 	struct nfsd_file_lookup_key key = {
@@ -1145,7 +1145,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 out_status:
-	trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
+	if (open)
+		trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
 	return status;
 
 open_file:
@@ -1186,7 +1187,7 @@ __be32
 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_do_file_acquire(rqstp, fhp, may_flags, pnf, true);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true);
 }
 
 /**
@@ -1203,7 +1204,7 @@ __be32
 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		 unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_do_file_acquire(rqstp, fhp, may_flags, pnf, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false);
 }
 
 /*
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9409a0dc1b76..3a05c095dfe5 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5104,6 +5104,7 @@ static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
 				goto out_put_access;
 			nf->nf_file = open->op_filp;
 			open->op_filp = NULL;
+			trace_nfsd_file_create(rqstp, access, nf);
 		}
 
 		spin_lock(&fp->fi_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 40d264006004..de765c583c62 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -738,10 +738,10 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
-		struct svc_rqst *rqstp,
-		struct inode *inode,
+		const struct svc_rqst *rqstp,
+		const struct inode *inode,
 		unsigned int may_flags,
-		struct nfsd_file *nf,
+		const struct nfsd_file *nf,
 		__be32 status
 	),
 
@@ -749,12 +749,12 @@ TRACE_EVENT(nfsd_file_acquire,
 
 	TP_STRUCT__entry(
 		__field(u32, xid)
-		__field(void *, inode)
+		__field(const void *, inode)
 		__field(unsigned long, may_flags)
-		__field(int, nf_ref)
+		__field(unsigned int, nf_ref)
 		__field(unsigned long, nf_flags)
 		__field(unsigned long, nf_may)
-		__field(struct file *, nf_file)
+		__field(const void *, nf_file)
 		__field(u32, status)
 	),
 
@@ -769,12 +769,50 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->status = be32_to_cpu(status);
 	),
 
-	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p status=%u",
 			__entry->xid, __entry->inode,
 			show_nfsd_may_flags(__entry->may_flags),
 			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
 			show_nfsd_may_flags(__entry->nf_may),
-			__entry->nf_file, __entry->status)
+			__entry->nf_file, __entry->status
+	)
+);
+
+TRACE_EVENT(nfsd_file_create,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		unsigned int may_flags,
+		const struct nfsd_file *nf
+	),
+
+	TP_ARGS(rqstp, may_flags, nf),
+
+	TP_STRUCT__entry(
+		__field(const void *, nf_inode)
+		__field(const void *, nf_file)
+		__field(unsigned long, may_flags)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(unsigned int, nf_ref)
+		__field(u32, xid)
+	),
+
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_file = nf->nf_file;
+		__entry->may_flags = may_flags;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+	),
+
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p",
+		__entry->xid, __entry->nf_inode,
+		show_nfsd_may_flags(__entry->may_flags),
+		__entry->nf_ref, show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may), __entry->nf_file
+	)
 );
 
 TRACE_EVENT(nfsd_file_insert_err,


