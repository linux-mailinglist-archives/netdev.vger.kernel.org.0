Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EB6554CA5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiFVORE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358265AbiFVOQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91678393CC;
        Wed, 22 Jun 2022 07:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2098561BD9;
        Wed, 22 Jun 2022 14:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3810BC34114;
        Wed, 22 Jun 2022 14:15:51 +0000 (UTC)
Subject: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Date:   Wed, 22 Jun 2022 10:15:50 -0400
Message-ID: <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
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

Add code to initialize and tear down an rhashtable. The rhashtable
is not used yet.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  131 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/nfsd/filecache.h |    1 
 2 files changed, 111 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 75cb1f52152c..a491519598fc 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -13,6 +13,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/rhashtable.h>
 
 #include "vfs.h"
 #include "nfsd.h"
@@ -65,6 +66,107 @@ static atomic_long_t			nfsd_filecache_count;
 static atomic_long_t			nfsd_file_total_age;
 static struct delayed_work		nfsd_filecache_laundrette;
 
+static struct rhashtable nfsd_file_rhash_tbl ____cacheline_aligned_in_smp;
+
+struct nfsd_file_lookup_key {
+	struct inode *inode;
+	struct net *net;
+	const struct cred *cred;
+	unsigned char type;
+	unsigned char need;
+};
+
+enum {
+	NFSD_FILE_KEY_INODE,
+	NFSD_FILE_KEY_FULL,
+};
+
+static bool
+nfsd_match_cred(const struct cred *c1, const struct cred *c2)
+{
+	int i;
+
+	if (!uid_eq(c1->fsuid, c2->fsuid))
+		return false;
+	if (!gid_eq(c1->fsgid, c2->fsgid))
+		return false;
+	if (c1->group_info == NULL || c2->group_info == NULL)
+		return c1->group_info == c2->group_info;
+	if (c1->group_info->ngroups != c2->group_info->ngroups)
+		return false;
+	for (i = 0; i < c1->group_info->ngroups; i++) {
+		if (!gid_eq(c1->group_info->gid[i], c2->group_info->gid[i]))
+			return false;
+	}
+	return true;
+}
+
+/**
+ * nfsd_file_obj_hashfn - Compute the hash value of an nfsd_file
+ * @data: object on which to compute the hash value
+ * @len: rhash table's key_len parameter (unused)
+ * @seed: rhash table's random seed of the day
+ *
+ * Return value:
+ *   Computed 32-bit hash value
+ */
+static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct nfsd_file *nf = data;
+
+	return jhash2((const u32 *)&nf->nf_inode,
+		      sizeof_field(struct nfsd_file, nf_inode) / sizeof(u32),
+		      seed);
+}
+
+/**
+ * nfsd_file_obj_cmpfn - Match a cache item against search criteria
+ * @arg: search criteria
+ * @ptr: cache item to check
+ *
+ * Return values:
+ *   %0 - Item matches search criteria
+ *   %1 - Item does not match search criteria
+ */
+static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
+			       const void *ptr)
+{
+	const struct nfsd_file_lookup_key *key = arg->key;
+	const struct nfsd_file *nf = ptr;
+
+	switch (key->type) {
+	case NFSD_FILE_KEY_INODE:
+		if (nf->nf_inode != key->inode)
+			return 1;
+		break;
+	case NFSD_FILE_KEY_FULL:
+		if (nf->nf_inode != key->inode)
+			return 1;
+		if (nf->nf_may != key->need)
+			return 1;
+		if (nf->nf_net != key->net)
+			return 1;
+		if (!nfsd_match_cred(nf->nf_cred, key->cred))
+			return 1;
+		if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags))
+			return 1;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct rhashtable_params nfsd_file_rhash_params = {
+	.key_len		= sizeof_field(struct nfsd_file, nf_inode),
+	.key_offset		= offsetof(struct nfsd_file, nf_inode),
+	.head_offset		= offsetof(struct nfsd_file, nf_rhash),
+	.obj_hashfn		= nfsd_file_obj_hashfn,
+	.obj_cmpfn		= nfsd_file_obj_cmpfn,
+	.max_size		= 131072,	/* buckets */
+	.min_size		= 1024,		/* buckets */
+	.automatic_shrinking	= true,
+};
+
 static void
 nfsd_file_schedule_laundrette(void)
 {
@@ -697,13 +799,18 @@ static const struct fsnotify_ops nfsd_file_fsnotify_ops = {
 int
 nfsd_file_cache_init(void)
 {
-	int		ret = -ENOMEM;
+	int		ret;
 	unsigned int	i;
 
 	lockdep_assert_held(&nfsd_mutex);
 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
 		return 0;
 
+	ret = rhashtable_init(&nfsd_file_rhash_tbl, &nfsd_file_rhash_params);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
 	if (!nfsd_filecache_wq)
 		goto out;
@@ -781,6 +888,7 @@ nfsd_file_cache_init(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+	rhashtable_destroy(&nfsd_file_rhash_tbl);
 	goto out;
 }
 
@@ -904,6 +1012,7 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+	rhashtable_destroy(&nfsd_file_rhash_tbl);
 
 	for_each_possible_cpu(i) {
 		this_cpu_write(nfsd_file_cache_hits, 0);
@@ -915,26 +1024,6 @@ nfsd_file_cache_shutdown(void)
 	}
 }
 
-static bool
-nfsd_match_cred(const struct cred *c1, const struct cred *c2)
-{
-	int i;
-
-	if (!uid_eq(c1->fsuid, c2->fsuid))
-		return false;
-	if (!gid_eq(c1->fsgid, c2->fsgid))
-		return false;
-	if (c1->group_info == NULL || c2->group_info == NULL)
-		return c1->group_info == c2->group_info;
-	if (c1->group_info->ngroups != c2->group_info->ngroups)
-		return false;
-	for (i = 0; i < c1->group_info->ngroups; i++) {
-		if (!gid_eq(c1->group_info->gid[i], c2->group_info->gid[i]))
-			return false;
-	}
-	return true;
-}
-
 static struct nfsd_file *
 nfsd_file_find_locked(struct inode *inode, unsigned int may_flags,
 			unsigned int hashval, struct net *net)
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 31dc65f82c75..7fc017e7b09e 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -29,6 +29,7 @@ struct nfsd_file_mark {
  * never be dereferenced, only used for comparison.
  */
 struct nfsd_file {
+	struct rhash_head	nf_rhash;
 	struct hlist_node	nf_node;
 	struct list_head	nf_lru;
 	struct rcu_head		nf_rcu;


