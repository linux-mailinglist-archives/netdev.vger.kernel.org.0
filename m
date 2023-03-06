Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CBB6AC81D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjCFQfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCFQfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:35:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6455D2BF3A;
        Mon,  6 Mar 2023 08:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678120487; x=1709656487;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=PX8UQ6oITUhb4x6lXD3oy5zdW3SXv9aazhZK9zfdjvM=;
  b=cqW1VSNIijC3ESiZUQGVoGkn8YB4RuXiHUkHRAFretht0rLgEa5uJn0q
   woao55wvPAz4lWWbEY4hspnAeysJ74R9VUT3odODskobmrUYottvpWKcK
   2t3LnQBW09OrHHEhng2icYPSHSST3V3rjhvBUURuDNZqzrauDu5C542kI
   edrHc+5dzRm8avVe4o5jv+OupnluzoXFP2FNwPrC6aAUTEEjPwmjh41tH
   ndP4NivF9TW8+3MkTsw3bf2ml9xqjmvqJ1Hc0ETkBmtEDAER6lJr+QMMd
   p2/s/W4pSzn05Lz+N/CoATjG3ERz8V5UVnkhmiDquVHq5BmRfcER4q2vo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315998600"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="315998600"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="745132826"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="745132826"
Received: from lab-ah.igk.intel.com ([10.102.42.211])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:26 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Mon, 06 Mar 2023 17:31:58 +0100
Subject: [PATCH v4 02/10] lib/ref_tracker: __ref_tracker_dir_print improve printing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v4-2-464e8ab4c9ab@intel.com>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
In-Reply-To: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve readability of ref_tracker printing following changes
have been performed:
- reports are printed per stack_handle - log is more compact,
- added display name for ref_tracker_dir,
- stack trace is printed indented, in the same printk call,
- total number of references is printed every time,
- print info about dropped references.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 include/linux/ref_tracker.h | 15 ++++++--
 lib/ref_tracker.c           | 90 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 91 insertions(+), 14 deletions(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 3e9e9df2a41f5f..a2cf1f6309adb2 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -17,12 +17,19 @@ struct ref_tracker_dir {
 	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
+	char			name[32];
 #endif
 };
 
 #ifdef CONFIG_REF_TRACKER
-static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+
+// Temporary allow two and three arguments, until consumers are converted
+#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
+#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
+
+static inline void __ref_tracker_dir_init(struct ref_tracker_dir *dir,
+					unsigned int quarantine_count,
+					const char *name)
 {
 	INIT_LIST_HEAD(&dir->list);
 	INIT_LIST_HEAD(&dir->quarantine);
@@ -31,6 +38,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
 	refcount_set(&dir->no_tracker, 1);
+	strlcpy(dir->name, name, sizeof(dir->name));
 	stack_depot_init();
 }
 
@@ -51,7 +59,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 #else /* CONFIG_REF_TRACKER */
 
 static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
-					unsigned int quarantine_count)
+					unsigned int quarantine_count,
+					...)
 {
 }
 
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 5e9f90bbf771b0..ab1253fde244ea 100644
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
 
-void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
-			   unsigned int display_limit)
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
+void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
+			   unsigned int display_limit)
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
 EXPORT_SYMBOL(__ref_tracker_dir_print);
 

-- 
2.34.1
