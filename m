Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD5554CA0
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358311AbiFVOQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358339AbiFVOQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A8D3B57F;
        Wed, 22 Jun 2022 07:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D17761BDC;
        Wed, 22 Jun 2022 14:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A0C34114;
        Wed, 22 Jun 2022 14:15:38 +0000 (UTC)
Subject: [PATCH RFC 26/30] NFSD: Document nfsd_file_cache_purge() API contract
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:37 -0400
Message-ID: <165590733727.75778.2800164109345599121.stgit@manet.1015granger.net>
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

In particular, document that the caller must hold nfsd_mutex.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 8b8d765a0df0..943db8cc87af 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -786,7 +786,10 @@ nfsd_file_cache_init(void)
 	goto out;
 }
 
-/*
+/**
+ * nfsd_file_cache_purge - Remove all cache items associated with @net
+ * @net: target net namespace
+ *
  * Note this can deadlock with nfsd_file_lru_cb.
  */
 void
@@ -798,6 +801,8 @@ nfsd_file_cache_purge(struct net *net)
 	LIST_HEAD(dispose);
 	bool del;
 
+	lockdep_assert_held(&nfsd_mutex);
+
 	if (!nfsd_file_hashtbl)
 		return;
 
@@ -1000,6 +1005,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	inode = d_inode(fhp->fh_dentry);
 	hashval = (unsigned int)hash_long(inode->i_ino, NFSD_FILE_HASH_BITS);
 retry:
+	/* Avoid allocation if the item is already in cache */
 	rcu_read_lock();
 	nf = nfsd_file_find_locked(inode, may_flags, hashval, net);
 	rcu_read_unlock();


