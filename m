Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0640C55EC2E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiF1SIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiF1SIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E592510561;
        Tue, 28 Jun 2022 11:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C9161AEA;
        Tue, 28 Jun 2022 18:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBC2C341C6;
        Tue, 28 Jun 2022 18:08:43 +0000 (UTC)
Subject: [PATCH v2 27/31] NFSD: Clean up unused code after rhashtable
 conversion
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:08:42 -0400
Message-ID: <165643972249.84360.11591959671905684900.stgit@manet.1015granger.net>
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   33 +--------------------------------
 fs/nfsd/filecache.h |    3 +--
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index c3afc08ef2b6..392e5b65ac1b 100644
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
@@ -1037,8 +1008,6 @@ nfsd_file_cache_shutdown(void)
 	fsnotify_wait_marks_destroyed();
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 7fc017e7b09e..5ce3fdf3b729 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -24,13 +24,12 @@ struct nfsd_file_mark {
 
 /*
  * A representation of a file that has been opened by knfsd. These are hashed
- * in the hashtable by inode pointer value. Note that this object doesn't
+ * in an rhashtable by inode pointer value. Note that this object doesn't
  * hold a reference to the inode by itself, so the nf_inode pointer should
  * never be dereferenced, only used for comparison.
  */
 struct nfsd_file {
 	struct rhash_head	nf_rhash;
-	struct hlist_node	nf_node;
 	struct list_head	nf_lru;
 	struct rcu_head		nf_rcu;
 	struct file		*nf_file;


