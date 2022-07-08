Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3175A56C090
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbiGHS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbiGHS1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A19FE24;
        Fri,  8 Jul 2022 11:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E4A6246A;
        Fri,  8 Jul 2022 18:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB771C341C0;
        Fri,  8 Jul 2022 18:26:50 +0000 (UTC)
Subject: [PATCH v3 29/32] NFSD: Move nfsd_file_trace_alloc() tracepoint
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:26:49 -0400
Message-ID: <165730480977.28142.6276202322556034271.stgit@klimt.1015granger.net>
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

Avoid recording the allocation of an nfsd_file item that is
immediately released because a matching item was already
inserted in the hash.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    2 +-
 fs/nfsd/trace.h     |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 21bc7b9c25f3..a904364551e8 100644
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
@@ -1146,6 +1145,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return status;
 
 open_file:
+	trace_nfsd_file_alloc(nf);
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
 		if (open) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 1c4cf9d2dd8e..96bb6629541e 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -776,12 +776,35 @@ DEFINE_EVENT(nfsd_file_class, name, \
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


