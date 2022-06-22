Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB0554C9D
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358204AbiFVOQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358251AbiFVOP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838703B3C1;
        Wed, 22 Jun 2022 07:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F4DB81F69;
        Wed, 22 Jun 2022 14:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83E3C3411B;
        Wed, 22 Jun 2022 14:15:31 +0000 (UTC)
Subject: [PATCH RFC 25/30] NFSD: Clean up "open file" case in
 nfsd_file_acquire()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:30 -0400
Message-ID: <165590733080.75778.16386422015870544314.stgit@manet.1015granger.net>
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

Refactor a little to prepare for changes to nfsd_file_find_locked().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ae813e6f645f..8b8d765a0df0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1003,23 +1003,22 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	rcu_read_lock();
 	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
 	rcu_read_unlock();
-	if (nf)
-		goto wait_for_construction;
+	if (nf == NULL) {
+		new = nfsd_file_alloc(inode, may_flags, net);
+		if (!new) {
+			status = nfserr_jukebox;
+			goto out_status;
+		}
 
-	new = nfsd_file_alloc(inode, may_flags, net);
-	if (!new) {
-		status = nfserr_jukebox;
-		goto out_status;
-	}
+		spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
+		nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
+		if (nf == NULL)
+			goto open_file;
+		spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
 
-	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
-	if (nf == NULL)
-		goto open_file;
-	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	nfsd_file_slab_free(&new->nf_rcu);
+		nfsd_file_slab_free(&new->nf_rcu);
+	}
 
-wait_for_construction:
 	wait_on_bit(&nf->nf_flags, NFSD_FILE_PENDING, TASK_UNINTERRUPTIBLE);
 
 	/* Did construction of this file fail? */


