Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DDA554C91
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358115AbiFVOQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358147AbiFVOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:15:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762573A721;
        Wed, 22 Jun 2022 07:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11DF961B9C;
        Wed, 22 Jun 2022 14:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D85C34114;
        Wed, 22 Jun 2022 14:15:12 +0000 (UTC)
Subject: [PATCH RFC 22/30] NFSD: nfsd_file_hash_remove can compute hashval
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:11 -0400
Message-ID: <165590731118.75778.13970409813627047015.stgit@manet.1015granger.net>
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

Remove an unnecessary use of nf_hashval.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0387b2028a9b..fa793413bc1f 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -295,6 +295,18 @@ nfsd_file_do_unhash(struct nfsd_file *nf)
 	atomic_long_dec(&nfsd_filecache_count);
 }
 
+static void
+nfsd_file_hash_remove(struct nfsd_file *nf)
+{
+	struct inode *inode = nf->nf_inode;
+	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
+				NFSD_FILE_HASH_BITS);
+
+	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	nfsd_file_do_unhash(nf);
+	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+}
+
 static bool
 nfsd_file_unhash(struct nfsd_file *nf)
 {
@@ -513,11 +525,8 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 {
 	struct nfsd_file *nf;
 
-	list_for_each_entry(nf, dispose, nf_lru) {
-		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-		nfsd_file_do_unhash(nf);
-		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-	}
+	list_for_each_entry(nf, dispose, nf_lru)
+		nfsd_file_hash_remove(nf);
 	nfsd_file_dispose_list_delayed(dispose);
 }
 


