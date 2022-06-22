Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8AD554CAA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358232AbiFVORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358227AbiFVOQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C213BA54;
        Wed, 22 Jun 2022 07:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA6B7B81F5B;
        Wed, 22 Jun 2022 14:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4431FC34114;
        Wed, 22 Jun 2022 14:16:04 +0000 (UTC)
Subject: [PATCH RFC 30/30] NFSD: Clean up unusued code after rhashtable
 conversion
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:16:03 -0400
Message-ID: <165590736333.75778.11835074896938057232.stgit@manet.1015granger.net>
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

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   31 +------------------------------
 fs/nfsd/filecache.h |    3 +--
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 14b607e544bf..88c5d8393981 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -24,9 +24,6 @@
 
 #define NFSDDBG_FACILITY	NFSDDBG_FH
 
-/* FIXME: dynamically size this for the machine somehow? */
-#define NFSD_FILE_HASH_BITS                   12
-#define NFSD_FILE_HASH_SIZE                  (1 << NFSD_FILE_HASH_BITS)
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
 #define NFSD_FILE_CACHE_UP		     (0)
@@ -34,13 +31,6 @@
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
@@ -58,7 +48,6 @@ static struct workqueue_struct *nfsd_filecache_wq __read_mostly;
 
 static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
-static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
 static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
@@ -275,7 +264,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 
 	nf = kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
 	if (nf) {
-		INIT_HLIST_NODE(&nf->nf_node);
 		INIT_LIST_HEAD(&nf->nf_lru);
 		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
@@ -784,8 +772,7 @@ static const struct fsnotify_ops nfsd_file_fsnotify_ops = {
 int
 nfsd_file_cache_init(void)
 {
-	int		ret;
-	unsigned int	i;
+	int ret;
 
 	lockdep_assert_held(&nfsd_mutex);
 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
@@ -800,13 +787,6 @@ nfsd_file_cache_init(void)
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
@@ -850,11 +830,6 @@ nfsd_file_cache_init(void)
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
@@ -869,8 +844,6 @@ nfsd_file_cache_init(void)
 	nfsd_file_slab = NULL;
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
@@ -1002,8 +975,6 @@ nfsd_file_cache_shutdown(void)
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


