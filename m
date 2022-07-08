Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2A56C0F4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbiGHS2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239797AbiGHS1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADCEA0266;
        Fri,  8 Jul 2022 11:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 017A1B82924;
        Fri,  8 Jul 2022 18:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F06CC341C6;
        Fri,  8 Jul 2022 18:27:10 +0000 (UTC)
Subject: [PATCH v3 32/32] NFSD: Ensure nf_inode is never dereferenced
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:27:09 -0400
Message-ID: <165730482946.28142.13069318391976207471.stgit@klimt.1015granger.net>
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

The documenting comment for struct nf_file states:

/*
 * A representation of a file that has been opened by knfsd. These are hashed
 * in the hashtable by inode pointer value. Note that this object doesn't
 * hold a reference to the inode by itself, so the nf_inode pointer should
 * never be dereferenced, only used for comparison.
 */

Replace the two existing dereferences to make the comment always
true.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    5 ++---
 fs/nfsd/filecache.h |    2 +-
 fs/nfsd/nfs4state.c |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 36d61012d5de..11099c8918a4 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -228,12 +228,11 @@ nfsd_file_mark_put(struct nfsd_file_mark *nfm)
 }
 
 static struct nfsd_file_mark *
-nfsd_file_mark_find_or_create(struct nfsd_file *nf)
+nfsd_file_mark_find_or_create(struct nfsd_file *nf, struct inode *inode)
 {
 	int			err;
 	struct fsnotify_mark	*mark;
 	struct nfsd_file_mark	*nfm = NULL, *new;
-	struct inode *inode = nf->nf_inode;
 
 	do {
 		fsnotify_group_lock(nfsd_file_fsnotify_group);
@@ -1164,7 +1163,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 open_file:
 	trace_nfsd_file_alloc(nf);
-	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
+	nf->nf_mark = nfsd_file_mark_find_or_create(nf, key.inode);
 	if (nf->nf_mark) {
 		if (open) {
 			status = nfsd_open_verified(rqstp, fhp, may_flags,
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index c5ddc877116b..d534b76cb65b 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -41,7 +41,7 @@ struct nfsd_file {
 #define NFSD_FILE_BREAK_WRITE	(3)
 #define NFSD_FILE_REFERENCED	(4)
 	unsigned long		nf_flags;
-	struct inode		*nf_inode;
+	struct inode		*nf_inode;	/* don't deref */
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9d1a3e131c49..994bd11bafe0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2564,7 +2564,7 @@ static void nfs4_show_fname(struct seq_file *s, struct nfsd_file *f)
 
 static void nfs4_show_superblock(struct seq_file *s, struct nfsd_file *f)
 {
-	struct inode *inode = f->nf_inode;
+	struct inode *inode = file_inode(f->nf_file);
 
 	seq_printf(s, "superblock: \"%02x:%02x:%ld\"",
 					MAJOR(inode->i_sb->s_dev),


