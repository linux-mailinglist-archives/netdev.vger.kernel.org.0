Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81D555EC26
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiF1SIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiF1SIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865EDF59C;
        Tue, 28 Jun 2022 11:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2149261AD5;
        Tue, 28 Jun 2022 18:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2021BC3411D;
        Tue, 28 Jun 2022 18:08:17 +0000 (UTC)
Subject: [PATCH v2 23/31] NFSD: Remove nfsd_file::nf_hashval
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:08:16 -0400
Message-ID: <165643969610.84360.17724675805829023649.stgit@manet.1015granger.net>
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

The value in this field can always be computed from nf_inode, thus
it is no longer used.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    6 ++----
 fs/nfsd/filecache.h |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d2cbb1c48207..69861b0d156c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -168,8 +168,7 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 }
 
 static struct nfsd_file *
-nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
-		struct net *net)
+nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 {
 	struct nfsd_file *nf;
 
@@ -183,7 +182,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 		nf->nf_net = net;
 		nf->nf_flags = 0;
 		nf->nf_inode = inode;
-		nf->nf_hashval = hashval;
 		refcount_set(&nf->nf_ref, 1);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
 		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
@@ -1012,7 +1010,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (nf)
 		goto wait_for_construction;
 
-	new = nfsd_file_alloc(inode, may_flags, hashval, net);
+	new = nfsd_file_alloc(inode, may_flags, net);
 	if (!new) {
 		status = nfserr_jukebox;
 		goto out_status;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index d0c42619dc10..31dc65f82c75 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -42,7 +42,6 @@ struct nfsd_file {
 #define NFSD_FILE_REFERENCED	(4)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;
-	unsigned int		nf_hashval;
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;


