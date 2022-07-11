Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB9D55EC04
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiF1SGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiF1SGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:06:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCA1EAD6;
        Tue, 28 Jun 2022 11:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D7EFB81F58;
        Tue, 28 Jun 2022 18:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AAAC341C6;
        Tue, 28 Jun 2022 18:06:25 +0000 (UTC)
Subject: [PATCH v2 06/31] NFSD: Add nfsd_file_lru_dispose_list() helper
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:06:24 -0400
Message-ID: <165643958472.84360.12808478593932401447.stgit@manet.1015granger.net>
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

Refactor the invariant part of nfsd_file_lru_walk_list() into a
separate helper function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index da48c51a2bf0..b278030e0a12 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -457,11 +457,31 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	return LRU_SKIP;
 }
 
+/*
+ * Unhash items on @dispose immediately, then queue them on the
+ * disposal workqueue to finish releasing them in the background.
+ *
+ * cel: Note that between the time list_lru_shrink_walk runs and
+ * now, these items are in the hash table but marked unhashed.
+ * Why release these outside of lru_cb ? There's no lock ordering
+ * problem since lru_cb currently takes no lock.
+ */
+static void nfsd_file_gc_dispose_list(struct list_head *dispose)
+{
+	struct nfsd_file *nf;
+
+	list_for_each_entry(nf, dispose, nf_lru) {
+		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+		nfsd_file_do_unhash(nf);
+		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+	}
+	nfsd_file_dispose_list_delayed(dispose);
+}
+
 static unsigned long
 nfsd_file_lru_walk_list(struct shrink_control *sc)
 {
 	LIST_HEAD(head);
-	struct nfsd_file *nf;
 	unsigned long ret;
 
 	if (sc)
@@ -471,12 +491,7 @@ nfsd_file_lru_walk_list(struct shrink_control *sc)
 		ret = list_lru_walk(&nfsd_file_lru,
 				nfsd_file_lru_cb,
 				&head, LONG_MAX);
-	list_for_each_entry(nf, &head, nf_lru) {
-		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-		nfsd_file_do_unhash(nf);
-		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-	}
-	nfsd_file_dispose_list_delayed(&head);
+	nfsd_file_gc_dispose_list(&head);
 	return ret;
 }
 


