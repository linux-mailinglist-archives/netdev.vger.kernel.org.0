Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9705855EC36
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiF1SJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiF1SJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA1A13E8E;
        Tue, 28 Jun 2022 11:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34DAEB81F38;
        Tue, 28 Jun 2022 18:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D6C3411D;
        Tue, 28 Jun 2022 18:09:09 +0000 (UTC)
Subject: [PATCH v2 31/31] NFSD: NFSv4 CLOSE should release an nfsd_file
 immediately
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:09:08 -0400
Message-ID: <165643974865.84360.14514065655454215617.stgit@manet.1015granger.net>
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

The last close of a file should enable other accessors to open and
use that file immediately. Leaving the file open in the filecache
prevents other users from accessing that file until the filecache
garbage-collects the file -- sometimes that takes several seconds.

Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Link: https://bugzilla.linux-nfs.org/show_bug.cgi?387
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   18 ++++++++++++++++++
 fs/nfsd/filecache.h |    1 +
 fs/nfsd/nfs4state.c |    4 ++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index cee2770e13e5..5c2a68489480 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -458,6 +458,24 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_put_noref(nf);
 }
 
+/**
+ * nfsd_file_close - Close an nfsd_file
+ * @nf: nfsd_file to close
+ *
+ * If this is the final reference for @nf, free it immediately.
+ * This reflects an on-the-wire CLOSE or DELEGRETURN into the
+ * VFS and exported filesystem.
+ */
+void nfsd_file_close(struct nfsd_file *nf)
+{
+	nfsd_file_put(nf);
+	if (refcount_dec_if_one(&nf->nf_ref)) {
+		nfsd_file_unhash(nf);
+		nfsd_file_lru_remove(nf);
+		nfsd_file_free(nf);
+	}
+}
+
 struct nfsd_file *
 nfsd_file_get(struct nfsd_file *nf)
 {
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 5ce3fdf3b729..c1f28a0e9c0f 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -54,6 +54,7 @@ void nfsd_file_cache_shutdown(void);
 int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
+void nfsd_file_close(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3a05c095dfe5..9d1a3e131c49 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -820,9 +820,9 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 			swap(f2, fp->fi_fds[O_RDWR]);
 		spin_unlock(&fp->fi_lock);
 		if (f1)
-			nfsd_file_put(f1);
+			nfsd_file_close(f1);
 		if (f2)
-			nfsd_file_put(f2);
+			nfsd_file_close(f2);
 	}
 }
 


