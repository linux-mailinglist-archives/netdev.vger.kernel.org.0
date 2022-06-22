Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4D554CA2
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358171AbiFVOQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358012AbiFVOQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A488C39834;
        Wed, 22 Jun 2022 07:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A993B81EB6;
        Wed, 22 Jun 2022 14:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD75C34114;
        Wed, 22 Jun 2022 14:15:44 +0000 (UTC)
Subject: [PATCH RFC 27/30] NFSD: Replace the "init once" mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:43 -0400
Message-ID: <165590734374.75778.4416002794540603539.stgit@manet.1015granger.net>
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

In a moment, the nfsd_file_hashtbl global will be replaced with an
rhashtable. Replace the one or two spots that need to check if the
hash table is available. We can easily reuse the SHUTDOWN flag for
this purpose.

Document that this mechanism relies on callers to hold the
nfsd_mutex to prevent init, shutdown, and purging to run
concurrently.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 943db8cc87af..75cb1f52152c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -28,7 +28,7 @@
 #define NFSD_FILE_HASH_SIZE                  (1 << NFSD_FILE_HASH_BITS)
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
-#define NFSD_FILE_SHUTDOWN		     (1)
+#define NFSD_FILE_CACHE_UP		     (0)
 
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
@@ -59,7 +59,7 @@ static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
 static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
-static long				nfsd_file_lru_flags;
+static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static atomic_long_t			nfsd_file_total_age;
@@ -68,9 +68,8 @@ static struct delayed_work		nfsd_filecache_laundrette;
 static void
 nfsd_file_schedule_laundrette(void)
 {
-	long count = atomic_long_read(&nfsd_filecache_count);
-
-	if (count == 0 || test_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags))
+	if ((atomic_long_read(&nfsd_filecache_count) == 0) ||
+	    test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
 		return;
 
 	queue_delayed_work(system_wq, &nfsd_filecache_laundrette,
@@ -701,9 +700,8 @@ nfsd_file_cache_init(void)
 	int		ret = -ENOMEM;
 	unsigned int	i;
 
-	clear_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
-
-	if (nfsd_file_hashtbl)
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
 		return 0;
 
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -786,14 +784,8 @@ nfsd_file_cache_init(void)
 	goto out;
 }
 
-/**
- * nfsd_file_cache_purge - Remove all cache items associated with @net
- * @net: target net namespace
- *
- * Note this can deadlock with nfsd_file_lru_cb.
- */
-void
-nfsd_file_cache_purge(struct net *net)
+static void
+__nfsd_file_cache_purge(struct net *net)
 {
 	unsigned int		i;
 	struct nfsd_file	*nf;
@@ -801,11 +793,6 @@ nfsd_file_cache_purge(struct net *net)
 	LIST_HEAD(dispose);
 	bool del;
 
-	lockdep_assert_held(&nfsd_mutex);
-
-	if (!nfsd_file_hashtbl)
-		return;
-
 	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
 		struct nfsd_fcache_bucket *nfb = &nfsd_file_hashtbl[i];
 
@@ -866,6 +853,20 @@ nfsd_file_cache_start_net(struct net *net)
 	return nn->fcache_disposal ? 0 : -ENOMEM;
 }
 
+/**
+ * nfsd_file_cache_purge - Remove all cache items associated with @net
+ * @net: target net namespace
+ *
+ * Note this can deadlock with nfsd_file_lru_cb.
+ */
+void
+nfsd_file_cache_purge(struct net *net)
+{
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
+		__nfsd_file_cache_purge(net);
+}
+
 void
 nfsd_file_cache_shutdown_net(struct net *net)
 {
@@ -878,7 +879,9 @@ nfsd_file_cache_shutdown(void)
 {
 	int i;
 
-	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
+		return;
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
 	unregister_shrinker(&nfsd_file_shrinker);
@@ -887,7 +890,7 @@ nfsd_file_cache_shutdown(void)
 	 * calling nfsd_file_cache_purge
 	 */
 	cancel_delayed_work_sync(&nfsd_filecache_laundrette);
-	nfsd_file_cache_purge(NULL);
+	__nfsd_file_cache_purge(NULL);
 	list_lru_destroy(&nfsd_file_lru);
 	rcu_barrier();
 	fsnotify_put_group(nfsd_file_fsnotify_group);


