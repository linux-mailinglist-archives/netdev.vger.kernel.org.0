Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA87A55EC28
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiF1SI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbiF1SIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD456101E0;
        Tue, 28 Jun 2022 11:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A3D61AEC;
        Tue, 28 Jun 2022 18:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A0DC3411D;
        Tue, 28 Jun 2022 18:08:23 +0000 (UTC)
Subject: [PATCH v2 24/31] NFSD: Replace the "init once" mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:08:22 -0400
Message-ID: <165643970272.84360.11818847185304335051.stgit@manet.1015granger.net>
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

In a moment, the nfsd_file_hashtbl global will be replaced with an
rhashtable. Replace the one or two spots that need to check if the
hash table is available. We can easily reuse the SHUTDOWN flag for
this purpose.

Document that this mechanism relies on callers to hold the
nfsd_mutex to prevent init, shutdown, and purging to run
concurrently.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 69861b0d156c..e47c7f387ef2 100644
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
 static struct delayed_work		nfsd_filecache_laundrette;
@@ -67,9 +67,8 @@ static struct delayed_work		nfsd_filecache_laundrette;
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
@@ -704,9 +703,8 @@ nfsd_file_cache_init(void)
 	int		ret = -ENOMEM;
 	unsigned int	i;
 
-	clear_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
-
-	if (nfsd_file_hashtbl)
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
 		return 0;
 
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -792,8 +790,8 @@ nfsd_file_cache_init(void)
 /*
  * Note this can deadlock with nfsd_file_lru_cb.
  */
-void
-nfsd_file_cache_purge(struct net *net)
+static void
+__nfsd_file_cache_purge(struct net *net)
 {
 	unsigned int		i;
 	struct nfsd_file	*nf;
@@ -801,9 +799,6 @@ nfsd_file_cache_purge(struct net *net)
 	LIST_HEAD(dispose);
 	bool del;
 
-	if (!nfsd_file_hashtbl)
-		return;
-
 	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
 		struct nfsd_fcache_bucket *nfb = &nfsd_file_hashtbl[i];
 
@@ -864,6 +859,19 @@ nfsd_file_cache_start_net(struct net *net)
 	return nn->fcache_disposal ? 0 : -ENOMEM;
 }
 
+/**
+ * nfsd_file_cache_purge - Remove all cache items associated with @net
+ * @net: target net namespace
+ *
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
@@ -876,7 +884,9 @@ nfsd_file_cache_shutdown(void)
 {
 	int i;
 
-	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
+		return;
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
 	unregister_shrinker(&nfsd_file_shrinker);
@@ -885,7 +895,7 @@ nfsd_file_cache_shutdown(void)
 	 * calling nfsd_file_cache_purge
 	 */
 	cancel_delayed_work_sync(&nfsd_filecache_laundrette);
-	nfsd_file_cache_purge(NULL);
+	__nfsd_file_cache_purge(NULL);
 	list_lru_destroy(&nfsd_file_lru);
 	rcu_barrier();
 	fsnotify_put_group(nfsd_file_fsnotify_group);
@@ -1163,7 +1173,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	 * don't end up racing with server shutdown
 	 */
 	mutex_lock(&nfsd_mutex);
-	if (nfsd_file_hashtbl) {
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1) {
 		for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
 			count += nfsd_file_hashtbl[i].nfb_count;
 			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);


