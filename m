Return-Path: <netdev+bounces-7373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 064E971FEFF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8CB02812E1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26A618AF8;
	Fri,  2 Jun 2023 10:22:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B5E182B9
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:22:04 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B68FE50;
	Fri,  2 Jun 2023 03:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685701322; x=1717237322;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=2j0W7UL/pqSZ0Qe9hVrIOqCXRmXLMvc0HdEs6KkKVwQ=;
  b=SpvEq4eTNsilpqEJx9mPgtgQSmf/Pa9yVSn/m3rF0PMPHybNgxHftv7Z
   nvMTqlx03aiPwtHR1MWTURDAtCfTNU9IMekdHq8kukWYZ8GAlUcNNX5C7
   pAnsjS7zoXguIxucMBa8Fca3X0APFiyPJ2r64bihNPjwnK7PqZ/Di5Mk+
   53UbD2+hiW+uLgd+hytMHc8V9RWsm6UG7yojF6X6mrmUL+5cz8ccjXVeo
   nTvi83LeNWDYZqPqUpWiElajqESHYVIaqKSnfjqiR7kNawguNfKXeIZkF
   Rdl92rvhUVTUfvwfMmA9Erv87/SALLoJvgExIZWunzMjEqfHP0AhhtXyw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="358267622"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="358267622"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="707804972"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="707804972"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:21:59 -0700
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Fri, 02 Jun 2023 12:21:34 +0200
Subject: [PATCH v9 2/4] lib/ref_tracker: improve printing stats
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v9-2-5b47a33f55d1@intel.com>
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
In-Reply-To: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
To: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, 
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>, 
 netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
 Andi Shyti <andi.shyti@linux.intel.com>, 
 Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In case the library is tracking busy subsystem, simply
printing stack for every active reference will spam log
with long, hard to read, redundant stack traces. To improve
readabilty following changes have been made:
- reports are printed per stack_handle - log is more compact,
- added display name for ref_tracker_dir - it will differentiate
  multiple subsystems,
- stack trace is printed indented, in the same printk call,
- info about dropped references is printed as well.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ref_tracker.h |  9 ++++-
 lib/ref_tracker.c           | 90 +++++++++++++++++++++++++++++++++++++++------
 lib/test_ref_tracker.c      |  2 +-
 net/core/dev.c              |  2 +-
 net/core/net_namespace.c    |  4 +-
 5 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 87a92f2bec1b88..19a69e7809d6c1 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -17,12 +17,15 @@ struct ref_tracker_dir {
 	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
+	char			name[32];
 #endif
 };
 
 #ifdef CONFIG_REF_TRACKER
+
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+					unsigned int quarantine_count,
+					const char *name)
 {
 	INIT_LIST_HEAD(&dir->list);
 	INIT_LIST_HEAD(&dir->quarantine);
@@ -31,6 +34,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
 	refcount_set(&dir->no_tracker, 1);
+	strscpy(dir->name, name, sizeof(dir->name));
 	stack_depot_init();
 }
 
@@ -51,7 +55,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 #else /* CONFIG_REF_TRACKER */
 
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+					unsigned int quarantine_count,
+					const char *name)
 {
 }
 
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index d4eb0929af8f96..2ffe79c90c1771 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -1,11 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
+
+#define pr_fmt(fmt) "ref_tracker: " fmt
+
 #include <linux/export.h>
+#include <linux/list_sort.h>
 #include <linux/ref_tracker.h>
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
 
 #define REF_TRACKER_STACK_ENTRIES 16
+#define STACK_BUF_SIZE 1024
 
 struct ref_tracker {
 	struct list_head	head;   /* anchor into dir->list or dir->quarantine */
@@ -14,24 +19,87 @@ struct ref_tracker {
 	depot_stack_handle_t	free_stack_handle;
 };
 
-void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
-				  unsigned int display_limit)
+struct ref_tracker_dir_stats {
+	int total;
+	int count;
+	struct {
+		depot_stack_handle_t stack_handle;
+		unsigned int count;
+	} stacks[];
+};
+
+static struct ref_tracker_dir_stats *
+ref_tracker_get_stats(struct ref_tracker_dir *dir, unsigned int limit)
 {
+	struct ref_tracker_dir_stats *stats;
 	struct ref_tracker *tracker;
-	unsigned int i = 0;
 
-	lockdep_assert_held(&dir->lock);
+	stats = kmalloc(struct_size(stats, stacks, limit),
+			GFP_NOWAIT | __GFP_NOWARN);
+	if (!stats)
+		return ERR_PTR(-ENOMEM);
+	stats->total = 0;
+	stats->count = 0;
 
 	list_for_each_entry(tracker, &dir->list, head) {
-		if (i < display_limit) {
-			pr_err("leaked reference.\n");
-			if (tracker->alloc_stack_handle)
-				stack_depot_print(tracker->alloc_stack_handle);
-			i++;
-		} else {
-			break;
+		depot_stack_handle_t stack = tracker->alloc_stack_handle;
+		int i;
+
+		++stats->total;
+		for (i = 0; i < stats->count; ++i)
+			if (stats->stacks[i].stack_handle == stack)
+				break;
+		if (i >= limit)
+			continue;
+		if (i >= stats->count) {
+			stats->stacks[i].stack_handle = stack;
+			stats->stacks[i].count = 0;
+			++stats->count;
 		}
+		++stats->stacks[i].count;
+	}
+
+	return stats;
+}
+
+void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
+				  unsigned int display_limit)
+{
+	struct ref_tracker_dir_stats *stats;
+	unsigned int i = 0, skipped;
+	depot_stack_handle_t stack;
+	char *sbuf;
+
+	lockdep_assert_held(&dir->lock);
+
+	if (list_empty(&dir->list))
+		return;
+
+	stats = ref_tracker_get_stats(dir, display_limit);
+	if (IS_ERR(stats)) {
+		pr_err("%s@%pK: couldn't get stats, error %pe\n",
+		       dir->name, dir, stats);
+		return;
 	}
+
+	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
+
+	for (i = 0, skipped = stats->total; i < stats->count; ++i) {
+		stack = stats->stacks[i].stack_handle;
+		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
+			sbuf[0] = 0;
+		pr_err("%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
+		       stats->stacks[i].count, stats->total, sbuf);
+		skipped -= stats->stacks[i].count;
+	}
+
+	if (skipped)
+		pr_err("%s@%pK skipped reports about %d/%d users.\n",
+		       dir->name, dir, skipped, stats->total);
+
+	kfree(sbuf);
+
+	kfree(stats);
 }
 EXPORT_SYMBOL(ref_tracker_dir_print_locked);
 
diff --git a/lib/test_ref_tracker.c b/lib/test_ref_tracker.c
index 19d7dec70cc62f..49970a7c96f3f4 100644
--- a/lib/test_ref_tracker.c
+++ b/lib/test_ref_tracker.c
@@ -64,7 +64,7 @@ static int __init test_ref_tracker_init(void)
 {
 	int i;
 
-	ref_tracker_dir_init(&ref_dir, 100);
+	ref_tracker_dir_init(&ref_dir, 100, "selftest");
 
 	timer_setup(&test_ref_tracker_timer, test_ref_tracker_timer_func, 0);
 	mod_timer(&test_ref_tracker_timer, jiffies + 1);
diff --git a/net/core/dev.c b/net/core/dev.c
index 99d99b247bc976..8870eeb5a2ae1f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10635,7 +10635,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
 
-	ref_tracker_dir_init(&dev->refcnt_tracker, 128);
+	ref_tracker_dir_init(&dev->refcnt_tracker, 128, name);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3e3598cd49f23e..f4183c4c1ec82f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 /* init code that must occur even if setup_net() is not called. */
 static __net_init void preinit_net(struct net *net)
 {
-	ref_tracker_dir_init(&net->notrefcnt_tracker, 128);
+	ref_tracker_dir_init(&net->notrefcnt_tracker, 128, "net notrefcnt");
 }
 
 /*
@@ -322,7 +322,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	LIST_HEAD(net_exit_list);
 
 	refcount_set(&net->ns.count, 1);
-	ref_tracker_dir_init(&net->refcnt_tracker, 128);
+	ref_tracker_dir_init(&net->refcnt_tracker, 128, "net refcnt");
 
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));

-- 
2.34.1


