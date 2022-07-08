Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CAD56BF2A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiGHS2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiGHS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:27:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC79A6B7;
        Fri,  8 Jul 2022 11:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61588B82925;
        Fri,  8 Jul 2022 18:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD9C341C0;
        Fri,  8 Jul 2022 18:26:37 +0000 (UTC)
Subject: [PATCH v3 27/32] NFSD: Clean up unused code after rhashtable
 conversion
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:26:36 -0400
Message-ID: <165730479681.28142.15040014367918714032.stgit@klimt.1015granger.net>
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   33 +--------------------------------
 fs/nfsd/filecache.h |    1 -
 2 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7ae243ddf631..47826fb09b67 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -22,11 +22,6 @@
 #include "filecache.h"
 #include "trace.h"
 
-#define NFSDDBG_FACILITY	NFSDDBG_FH
-
-/* FIXME: dynamically size this for the machine somehow? */
-#define NFSD_FILE_HASH_BITS                   12
-#define NFSD_FILE_HASH_SIZE                  (1 << NFSD_FILE_HASH_BITS)
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
 #define NFSD_FILE_CACHE_UP		     (0)
@@ -34,13 +29,6 @@
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
 
-struct nfsd_fcache_bucket {
-	struct hlist_head	nfb_head;
-	spinlock_t		nfb_lock;
-	unsigned int		nfb_count;
-	unsigned int		nfb_maxcount;
-};
-
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
@@ -58,7 +46,6 @@ static struct workqueue_struct *nfsd_filecache_wq __read_mostly;
 
 static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
-static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
 static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
@@ -303,7 +290,6 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 
 	nf = kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
 	if (nf) {
-		INIT_HLIST_NODE(&nf->nf_node);
 		INIT_LIST_HEAD(&nf->nf_lru);
 		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
@@ -817,8 +803,7 @@ static const struct fsnotify_ops nfsd_file_fsnotify_ops = {
 int
 nfsd_file_cache_init(void)
 {
-	int		ret;
-	unsigned int	i;
+	int ret;
 
 	lockdep_assert_held(&nfsd_mutex);
 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
@@ -833,13 +818,6 @@ nfsd_file_cache_init(void)
 	if (!nfsd_filecache_wq)
 		goto out;
 
-	nfsd_file_hashtbl = kvcalloc(NFSD_FILE_HASH_SIZE,
-				sizeof(*nfsd_file_hashtbl), GFP_KERNEL);
-	if (!nfsd_file_hashtbl) {
-		pr_err("nfsd: unable to allocate nfsd_file_hashtbl\n");
-		goto out_err;
-	}
-
 	nfsd_file_slab = kmem_cache_create("nfsd_file",
 				sizeof(struct nfsd_file), 0, 0, NULL);
 	if (!nfsd_file_slab) {
@@ -883,11 +861,6 @@ nfsd_file_cache_init(void)
 		goto out_notifier;
 	}
 
-	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
-		INIT_HLIST_HEAD(&nfsd_file_hashtbl[i].nfb_head);
-		spin_lock_init(&nfsd_file_hashtbl[i].nfb_lock);
-	}
-
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
 	return ret;
@@ -902,8 +875,6 @@ nfsd_file_cache_init(void)
 	nfsd_file_slab = NULL;
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
@@ -1033,8 +1004,6 @@ nfsd_file_cache_shutdown(void)
 	fsnotify_wait_marks_destroyed();
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 7fc017e7b09e..7b40d5b446e1 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -30,7 +30,6 @@ struct nfsd_file_mark {
  */
 struct nfsd_file {
 	struct rhash_head	nf_rhash;
-	struct hlist_node	nf_node;
 	struct list_head	nf_lru;
 	struct rcu_head		nf_rcu;
 	struct file		*nf_file;


