Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B8E55EC32
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiF1SJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiF1SI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0701E15711;
        Tue, 28 Jun 2022 11:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 934E361ADB;
        Tue, 28 Jun 2022 18:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C79C3411D;
        Tue, 28 Jun 2022 18:08:56 +0000 (UTC)
Subject: [PATCH v2 29/31] NFSD: Move nfsd_file_trace_alloc() tracepoint
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:08:55 -0400
Message-ID: <165643973558.84360.24238171962065271.stgit@manet.1015granger.net>
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

Avoid recording the allocation of an nfsd_file item that is
immediately released because of a matching item was already
inserted in the hash.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    2 +-
 fs/nfsd/trace.h     |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0c7f86e81f4e..cee2770e13e5 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -309,7 +309,6 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
 		}
 		nf->nf_mark = NULL;
-		trace_nfsd_file_alloc(nf);
 	}
 	return nf;
 }
@@ -1150,6 +1149,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return status;
 
 open_file:
+	trace_nfsd_file_alloc(nf);
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
 		if (open) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index de765c583c62..c4582bdf988a 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -730,12 +730,35 @@ DEFINE_EVENT(nfsd_file_class, name, \
 	TP_PROTO(struct nfsd_file *nf), \
 	TP_ARGS(nf))
 
-DEFINE_NFSD_FILE_EVENT(nfsd_file_alloc);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put_final);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
+TRACE_EVENT(nfsd_file_alloc,
+	TP_PROTO(
+		const struct nfsd_file *nf
+	),
+	TP_ARGS(nf),
+	TP_STRUCT__entry(
+		__field(const void *, nf_inode)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(unsigned int, nf_ref)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_may = nf->nf_may;
+	),
+	TP_printk("inode=%p ref=%u flags=%s may=%s",
+		__entry->nf_inode, __entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may)
+	)
+);
+
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
 		const struct svc_rqst *rqstp,


