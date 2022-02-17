Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD474BA282
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiBQOFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241722AbiBQOFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:43 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E1917C6D7;
        Thu, 17 Feb 2022 06:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106726; x=1676642726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oausHsFMvXj5B+qizgOxlxKt+444ZkIfhgF1cXdIgiQ=;
  b=b8w1Iuyqol+AKwT7idJgp76+YHm18QGUV4Tp3Ulk7wEAZoWeIDx0IPvr
   XYGAlF8AdN+GeTd8fQsl5mcNStFx/TvTVQ6bn9yKv97XJs9tOXo6RyS68
   ANxylomoAtT1B/v8Es0Al03ujK+e8aiH4ictmCG84yM6UC/KA9FqPBNZj
   9PZr/twB76zNi6BteMkar5LYZQdJMQebatBHAAjcPxKVZ3nxqhjKPu7AW
   qvLg4PGfLDSoRFDgrugJdBk+s/32TR5y5JMZXBmKC1i3KpCpMCXZN2D8Z
   K5ZP1rcjXXuu08gsdcE39Fwx1LzgZxHbYRugqF0kNt+ZdblqID28/oNB7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501927"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501927"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241424"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:05:23 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 9/9] drm/i915: replace Intel internal tracker with kernel core ref_tracker
Date:   Thu, 17 Feb 2022 15:04:41 +0100
Message-Id: <20220217140441.1218045-10-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220217140441.1218045-1-andrzej.hajda@intel.com>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Beside reusing existing code, the main advantage of ref_tracker is
tracking per instance of wakeref. It allows also to catch double
put.
On the other side we lose information about the first acquire and
the last release, but the advantages outweigh it.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
---
 drivers/gpu/drm/i915/Kconfig.debug            |  11 +-
 drivers/gpu/drm/i915/Makefile                 |   3 -
 .../drm/i915/display/intel_display_power.c    |   2 +-
 drivers/gpu/drm/i915/gt/intel_engine_pm.c     |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.c         |   2 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c       |  23 +-
 drivers/gpu/drm/i915/intel_runtime_pm.h       |   2 +-
 drivers/gpu/drm/i915/intel_wakeref.c          |   8 +-
 drivers/gpu/drm/i915/intel_wakeref.h          |  72 +++++-
 drivers/gpu/drm/i915/intel_wakeref_tracker.c  | 234 ------------------
 drivers/gpu/drm/i915/intel_wakeref_tracker.h  |  76 ------
 11 files changed, 86 insertions(+), 349 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/intel_wakeref_tracker.c
 delete mode 100644 drivers/gpu/drm/i915/intel_wakeref_tracker.h

diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
index 3bdc73f30a9e1..6c57f3e265f20 100644
--- a/drivers/gpu/drm/i915/Kconfig.debug
+++ b/drivers/gpu/drm/i915/Kconfig.debug
@@ -32,6 +32,7 @@ config DRM_I915_DEBUG
 	select DEBUG_FS
 	select PREEMPT_COUNT
 	select I2C_CHARDEV
+	select REF_TRACKER
 	select STACKDEPOT
 	select STACKTRACE
 	select DRM_DP_AUX_CHARDEV
@@ -46,7 +47,6 @@ config DRM_I915_DEBUG
 	select DRM_I915_DEBUG_GEM
 	select DRM_I915_DEBUG_GEM_ONCE
 	select DRM_I915_DEBUG_MMIO
-	select DRM_I915_TRACK_WAKEREF
 	select DRM_I915_DEBUG_RUNTIME_PM
 	select DRM_I915_DEBUG_WAKEREF
 	select DRM_I915_SW_FENCE_DEBUG_OBJECTS
@@ -238,18 +238,13 @@ config DRM_I915_DEBUG_VBLANK_EVADE
 
 	  If in doubt, say "N".
 
-config DRM_I915_TRACK_WAKEREF
-	depends on STACKDEPOT
-	depends on STACKTRACE
-	bool
-
 config DRM_I915_DEBUG_RUNTIME_PM
 	bool "Enable extra state checking for runtime PM"
 	depends on DRM_I915
 	default n
+	select REF_TRACKER
 	select STACKDEPOT
 	select STACKTRACE
-	select DRM_I915_TRACK_WAKEREF
 	help
 	  Choose this option to turn on extra state checking for the
 	  runtime PM functionality. This may introduce overhead during
@@ -263,9 +258,9 @@ config DRM_I915_DEBUG_WAKEREF
 	bool "Enable extra tracking for wakerefs"
 	depends on DRM_I915
 	default n
+	select REF_TRACKER
 	select STACKDEPOT
 	select STACKTRACE
-	select DRM_I915_TRACK_WAKEREF
 	help
 	  Choose this option to turn on extra state checking and usage
 	  tracking for the wakerefPM functionality. This may introduce
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 88a403d3294cb..1f8d71430e2e6 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -76,9 +76,6 @@ i915-$(CONFIG_DEBUG_FS) += \
 	display/intel_display_debugfs.o \
 	display/intel_pipe_crc.o
 
-i915-$(CONFIG_DRM_I915_TRACK_WAKEREF) += \
-	intel_wakeref_tracker.o
-
 i915-$(CONFIG_PERF_EVENTS) += i915_pmu.o
 
 # "Graphics Technology" (aka we talk to the gpu)
diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 9ebae7ac32356..0e1bf724f89b5 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -2107,7 +2107,7 @@ print_async_put_domains_state(struct i915_power_domains *power_domains)
 						     struct drm_i915_private,
 						     power_domains);
 
-	drm_dbg(&i915->drm, "async_put_wakeref %u\n",
+	drm_dbg(&i915->drm, "async_put_wakeref %lu\n",
 		power_domains->async_put_wakeref);
 
 	print_power_domains(power_domains, "async_put_domains[0]",
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index 52e46e7830ff5..cf8cc348942cb 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -273,7 +273,7 @@ void intel_engine_init__pm(struct intel_engine_cs *engine)
 {
 	struct intel_runtime_pm *rpm = engine->uncore->rpm;
 
-	intel_wakeref_init(&engine->wakeref, rpm, &wf_ops);
+	intel_wakeref_init(&engine->wakeref, rpm, &wf_ops, engine->name);
 	intel_engine_init_heartbeat(engine);
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.c b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
index 7ee65a93f926f..01a055d0d0989 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
@@ -129,7 +129,7 @@ static const struct intel_wakeref_ops wf_ops = {
 
 void intel_gt_pm_init_early(struct intel_gt *gt)
 {
-	intel_wakeref_init(&gt->wakeref, gt->uncore->rpm, &wf_ops);
+	intel_wakeref_init(&gt->wakeref, gt->uncore->rpm, &wf_ops, "GT");
 	seqcount_mutex_init(&gt->stats.lock, &gt->wakeref.mutex);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.c b/drivers/gpu/drm/i915/intel_runtime_pm.c
index 7bd10efa56bf3..e923ab8d8da08 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -54,7 +54,7 @@
 
 static void init_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
-	intel_wakeref_tracker_init(&rpm->debug);
+	ref_tracker_dir_init(&rpm->debug, INTEL_REFTRACK_DEAD_COUNT, dev_name(rpm->kdev));
 }
 
 static intel_wakeref_t
@@ -63,26 +63,26 @@ track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 	if (!rpm->available)
 		return -1;
 
-	return intel_wakeref_tracker_add(&rpm->debug);
+	return intel_ref_tracker_alloc(&rpm->debug);
 }
 
 static void untrack_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm,
 					     intel_wakeref_t wakeref)
 {
-	intel_wakeref_tracker_remove(&rpm->debug, wakeref);
+	if (!rpm->available)
+		return;
+
+	intel_ref_tracker_free(&rpm->debug, wakeref);
 }
 
 static void untrack_all_intel_runtime_pm_wakerefs(struct intel_runtime_pm *rpm)
 {
-	struct drm_printer p = drm_debug_printer("i915");
-
-	intel_wakeref_tracker_reset(&rpm->debug, &p);
+	ref_tracker_dir_exit(&rpm->debug);
 }
 
 static noinline void
 __intel_wakeref_dec_and_check_tracking(struct intel_runtime_pm *rpm)
 {
-	struct intel_wakeref_tracker saved;
 	unsigned long flags;
 
 	if (!atomic_dec_and_lock_irqsave(&rpm->wakeref_count,
@@ -90,15 +90,8 @@ __intel_wakeref_dec_and_check_tracking(struct intel_runtime_pm *rpm)
 					 flags))
 		return;
 
-	saved = __intel_wakeref_tracker_reset(&rpm->debug);
+	__ref_tracker_dir_print(&rpm->debug, INTEL_REFTRACK_PRINT_LIMIT);
 	spin_unlock_irqrestore(&rpm->debug.lock, flags);
-
-	if (saved.count) {
-		struct drm_printer p = drm_debug_printer("i915");
-
-		__intel_wakeref_tracker_show(&saved, &p);
-		intel_wakeref_tracker_fini(&saved);
-	}
 }
 
 void print_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm,
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.h b/drivers/gpu/drm/i915/intel_runtime_pm.h
index 0871fa2176474..db5692f1eb67e 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -61,7 +61,7 @@ struct intel_runtime_pm {
 	 * paired rpm_put) we can remove corresponding pairs of and keep
 	 * the array trimmed to active wakerefs.
 	 */
-	struct intel_wakeref_tracker debug;
+	struct ref_tracker_dir debug;
 #endif
 };
 
diff --git a/drivers/gpu/drm/i915/intel_wakeref.c b/drivers/gpu/drm/i915/intel_wakeref.c
index db4887e33ea60..97fe9a0f0adbd 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.c
+++ b/drivers/gpu/drm/i915/intel_wakeref.c
@@ -62,6 +62,9 @@ static void ____intel_wakeref_put_last(struct intel_wakeref *wf)
 	if (likely(!wf->ops->put(wf))) {
 		rpm_put(wf);
 		wake_up_var(&wf->wakeref);
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+		ref_tracker_dir_exit(&wf->debug);
+#endif
 	}
 
 unlock:
@@ -96,7 +99,8 @@ static void __intel_wakeref_put_work(struct work_struct *wrk)
 void __intel_wakeref_init(struct intel_wakeref *wf,
 			  struct intel_runtime_pm *rpm,
 			  const struct intel_wakeref_ops *ops,
-			  struct intel_wakeref_lockclass *key)
+			  struct intel_wakeref_lockclass *key,
+			  const char *name)
 {
 	wf->rpm = rpm;
 	wf->ops = ops;
@@ -110,7 +114,7 @@ void __intel_wakeref_init(struct intel_wakeref *wf,
 			 "wakeref.work", &key->work, 0);
 
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
-	intel_wakeref_tracker_init(&wf->debug);
+	ref_tracker_dir_init(&wf->debug, INTEL_REFTRACK_DEAD_COUNT, name);
 #endif
 }
 
diff --git a/drivers/gpu/drm/i915/intel_wakeref.h b/drivers/gpu/drm/i915/intel_wakeref.h
index 38439deefc5cc..c694d129aca7b 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.h
+++ b/drivers/gpu/drm/i915/intel_wakeref.h
@@ -7,17 +7,24 @@
 #ifndef INTEL_WAKEREF_H
 #define INTEL_WAKEREF_H
 
+#include <drm/drm_print.h>
+
 #include <linux/atomic.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/lockdep.h>
 #include <linux/mutex.h>
 #include <linux/refcount.h>
+#include <linux/ref_tracker.h>
+#include <linux/slab.h>
 #include <linux/stackdepot.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-#include "intel_wakeref_tracker.h"
+typedef unsigned long intel_wakeref_t;
+
+#define INTEL_REFTRACK_DEAD_COUNT 16
+#define INTEL_REFTRACK_PRINT_LIMIT 16
 
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
 #define INTEL_WAKEREF_BUG_ON(expr) BUG_ON(expr)
@@ -45,7 +52,7 @@ struct intel_wakeref {
 	struct delayed_work work;
 
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
-	struct intel_wakeref_tracker debug;
+	struct ref_tracker_dir debug;
 #endif
 };
 
@@ -57,11 +64,12 @@ struct intel_wakeref_lockclass {
 void __intel_wakeref_init(struct intel_wakeref *wf,
 			  struct intel_runtime_pm *rpm,
 			  const struct intel_wakeref_ops *ops,
-			  struct intel_wakeref_lockclass *key);
-#define intel_wakeref_init(wf, rpm, ops) do {				\
+			  struct intel_wakeref_lockclass *key,
+			  const char *name);
+#define intel_wakeref_init(wf, rpm, ops, name) do {				\
 	static struct intel_wakeref_lockclass __key;			\
 									\
-	__intel_wakeref_init((wf), (rpm), (ops), &__key);		\
+	__intel_wakeref_init((wf), (rpm), (ops), &__key, name);		\
 } while (0)
 
 int __intel_wakeref_get_first(struct intel_wakeref *wf);
@@ -266,17 +274,67 @@ __intel_wakeref_defer_park(struct intel_wakeref *wf)
  */
 int intel_wakeref_wait_for_idle(struct intel_wakeref *wf);
 
+#define INTEL_WAKEREF_DEF ((intel_wakeref_t)(-1))
+
+static inline intel_wakeref_t intel_ref_tracker_alloc(struct ref_tracker_dir *dir)
+{
+	struct ref_tracker *user = NULL;
+
+	ref_tracker_alloc(dir, &user, GFP_NOWAIT);
+
+	return (intel_wakeref_t)user ?: INTEL_WAKEREF_DEF;
+}
+
+static inline void intel_ref_tracker_free(struct ref_tracker_dir *dir,
+					  intel_wakeref_t handle)
+{
+	struct ref_tracker *user;
+
+	user = (handle == INTEL_WAKEREF_DEF) ? NULL : (void *)handle;
+
+	ref_tracker_free(dir, &user);
+}
+
+static inline void
+intel_wakeref_tracker_show(struct ref_tracker_dir *dir,
+			   struct drm_printer *p)
+{
+	const size_t buf_size = PAGE_SIZE;
+	char *buf, *sb, *se;
+	size_t count;
+
+	buf = kmalloc(buf_size, GFP_NOWAIT);
+	if (!buf)
+		return;
+
+	count = ref_tracker_dir_snprint(dir, buf, buf_size);
+	if (!count)
+		goto free;
+	/* printk does not like big buffers, so we split it */
+	for (sb = buf; *sb; sb = se + 1) {
+		se = strchrnul(sb, '\n');
+		drm_printf(p, "%.*s", (int)(se - sb + 1), sb);
+		if (!*se)
+			break;
+	}
+	if (count >= buf_size)
+		drm_printf(p, "dropped %zd extra bytes of leak report.\n",
+			   count + 1 - buf_size);
+free:
+	kfree(buf);
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
 
 static inline intel_wakeref_t intel_wakeref_track(struct intel_wakeref *wf)
 {
-	return intel_wakeref_tracker_add(&wf->debug);
+	return intel_ref_tracker_alloc(&wf->debug);
 }
 
 static inline void intel_wakeref_untrack(struct intel_wakeref *wf,
 					 intel_wakeref_t handle)
 {
-	intel_wakeref_tracker_remove(&wf->debug, handle);
+	intel_ref_tracker_free(&wf->debug, handle);
 }
 
 static inline void intel_wakeref_show(struct intel_wakeref *wf,
diff --git a/drivers/gpu/drm/i915/intel_wakeref_tracker.c b/drivers/gpu/drm/i915/intel_wakeref_tracker.c
deleted file mode 100644
index a0bcef13a1085..0000000000000
--- a/drivers/gpu/drm/i915/intel_wakeref_tracker.c
+++ /dev/null
@@ -1,234 +0,0 @@
-// SPDX-License-Identifier: MIT
-/*
- * Copyright © 2021 Intel Corporation
- */
-
-#include <linux/slab.h>
-#include <linux/stackdepot.h>
-#include <linux/stacktrace.h>
-#include <linux/sort.h>
-
-#include <drm/drm_print.h>
-
-#include "intel_wakeref.h"
-
-#define STACKDEPTH 8
-
-static noinline depot_stack_handle_t __save_depot_stack(void)
-{
-	unsigned long entries[STACKDEPTH];
-	unsigned int n;
-
-	n = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	return stack_depot_save(entries, n, GFP_NOWAIT | __GFP_NOWARN);
-}
-
-static void __print_depot_stack(depot_stack_handle_t stack,
-				char *buf, int sz, int indent)
-{
-	unsigned long *entries;
-	unsigned int nr_entries;
-
-	nr_entries = stack_depot_fetch(stack, &entries);
-	stack_trace_snprint(buf, sz, entries, nr_entries, indent);
-}
-
-static int cmphandle(const void *_a, const void *_b)
-{
-	const depot_stack_handle_t * const a = _a, * const b = _b;
-
-	if (*a < *b)
-		return -1;
-	else if (*a > *b)
-		return 1;
-	else
-		return 0;
-}
-
-void
-__intel_wakeref_tracker_show(const struct intel_wakeref_tracker *w,
-			     struct drm_printer *p)
-{
-	unsigned long i;
-	char *buf;
-
-	buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
-	if (!buf)
-		return;
-
-	if (w->last_acquire) {
-		__print_depot_stack(w->last_acquire, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref last acquired:\n%s", buf);
-	}
-
-	if (w->last_release) {
-		__print_depot_stack(w->last_release, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref last released:\n%s", buf);
-	}
-
-	drm_printf(p, "Wakeref count: %lu\n", w->count);
-
-	sort(w->owners, w->count, sizeof(*w->owners), cmphandle, NULL);
-
-	for (i = 0; i < w->count; i++) {
-		depot_stack_handle_t stack = w->owners[i];
-		unsigned long rep;
-
-		rep = 1;
-		while (i + 1 < w->count && w->owners[i + 1] == stack)
-			rep++, i++;
-		__print_depot_stack(stack, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref x%lu taken at:\n%s", rep, buf);
-	}
-
-	kfree(buf);
-}
-
-void intel_wakeref_tracker_show(struct intel_wakeref_tracker *w,
-				struct drm_printer *p)
-{
-	struct intel_wakeref_tracker tmp = {};
-
-	do {
-		unsigned long alloc = tmp.count;
-		depot_stack_handle_t *s;
-
-		spin_lock_irq(&w->lock);
-		tmp.count = w->count;
-		if (tmp.count <= alloc)
-			memcpy(tmp.owners, w->owners, tmp.count * sizeof(*s));
-		tmp.last_acquire = w->last_acquire;
-		tmp.last_release = w->last_release;
-		spin_unlock_irq(&w->lock);
-		if (tmp.count <= alloc)
-			break;
-
-		s = krealloc(tmp.owners,
-			     tmp.count * sizeof(*s),
-			     GFP_NOWAIT | __GFP_NOWARN);
-		if (!s)
-			goto out;
-
-		tmp.owners = s;
-	} while (1);
-
-	__intel_wakeref_tracker_show(&tmp, p);
-
-out:
-	intel_wakeref_tracker_fini(&tmp);
-}
-
-intel_wakeref_t intel_wakeref_tracker_add(struct intel_wakeref_tracker *w)
-{
-	depot_stack_handle_t stack, *stacks;
-	unsigned long flags;
-
-	stack = __save_depot_stack();
-	if (!stack)
-		return -1;
-
-	spin_lock_irqsave(&w->lock, flags);
-
-	if (!w->count)
-		w->last_acquire = stack;
-
-	stacks = krealloc(w->owners,
-			  (w->count + 1) * sizeof(*stacks),
-			  GFP_NOWAIT | __GFP_NOWARN);
-	if (stacks) {
-		stacks[w->count++] = stack;
-		w->owners = stacks;
-	} else {
-		stack = -1;
-	}
-
-	spin_unlock_irqrestore(&w->lock, flags);
-
-	return stack;
-}
-
-void intel_wakeref_tracker_remove(struct intel_wakeref_tracker *w,
-				  intel_wakeref_t stack)
-{
-	unsigned long flags, n;
-	bool found = false;
-
-	if (unlikely(stack == -1))
-		return;
-
-	spin_lock_irqsave(&w->lock, flags);
-	for (n = w->count; n--; ) {
-		if (w->owners[n] == stack) {
-			memmove(w->owners + n,
-				w->owners + n + 1,
-				(--w->count - n) * sizeof(stack));
-			found = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&w->lock, flags);
-
-	if (WARN(!found,
-		 "Unmatched wakeref %x, tracking %lu\n",
-		 stack, w->count)) {
-		char *buf;
-
-		buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
-		if (!buf)
-			return;
-
-		__print_depot_stack(stack, buf, PAGE_SIZE, 2);
-		pr_err("wakeref %x from\n%s", stack, buf);
-
-		stack = READ_ONCE(w->last_release);
-		if (stack && !w->count) {
-			__print_depot_stack(stack, buf, PAGE_SIZE, 2);
-			pr_err("wakeref last released at\n%s", buf);
-		}
-
-		kfree(buf);
-	}
-}
-
-struct intel_wakeref_tracker
-__intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w)
-{
-	struct intel_wakeref_tracker saved;
-
-	lockdep_assert_held(&w->lock);
-
-	saved = *w;
-
-	w->owners = NULL;
-	w->count = 0;
-	w->last_release = __save_depot_stack();
-
-	return saved;
-}
-
-void intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w,
-				 struct drm_printer *p)
-{
-	struct intel_wakeref_tracker tmp;
-
-	spin_lock_irq(&w->lock);
-	tmp = __intel_wakeref_tracker_reset(w);
-	spin_unlock_irq(&w->lock);
-
-	if (tmp.count)
-		__intel_wakeref_tracker_show(&tmp, p);
-
-	intel_wakeref_tracker_fini(&tmp);
-}
-
-void intel_wakeref_tracker_init(struct intel_wakeref_tracker *w)
-{
-	memset(w, 0, sizeof(*w));
-	spin_lock_init(&w->lock);
-	stack_depot_init();
-}
-
-void intel_wakeref_tracker_fini(struct intel_wakeref_tracker *w)
-{
-	kfree(w->owners);
-}
diff --git a/drivers/gpu/drm/i915/intel_wakeref_tracker.h b/drivers/gpu/drm/i915/intel_wakeref_tracker.h
deleted file mode 100644
index 61df68e28c0fb..0000000000000
--- a/drivers/gpu/drm/i915/intel_wakeref_tracker.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * Copyright © 2019 Intel Corporation
- */
-
-#ifndef INTEL_WAKEREF_TRACKER_H
-#define INTEL_WAKEREF_TRACKER_H
-
-#include <linux/kconfig.h>
-#include <linux/spinlock.h>
-#include <linux/stackdepot.h>
-
-typedef depot_stack_handle_t intel_wakeref_t;
-
-struct drm_printer;
-
-struct intel_wakeref_tracker {
-	spinlock_t lock;
-
-	depot_stack_handle_t last_acquire;
-	depot_stack_handle_t last_release;
-
-	depot_stack_handle_t *owners;
-	unsigned long count;
-};
-
-#if IS_ENABLED(CONFIG_DRM_I915_TRACK_WAKEREF)
-
-void intel_wakeref_tracker_init(struct intel_wakeref_tracker *w);
-void intel_wakeref_tracker_fini(struct intel_wakeref_tracker *w);
-
-intel_wakeref_t intel_wakeref_tracker_add(struct intel_wakeref_tracker *w);
-void intel_wakeref_tracker_remove(struct intel_wakeref_tracker *w,
-			   intel_wakeref_t handle);
-
-struct intel_wakeref_tracker
-__intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w);
-void intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w,
-				 struct drm_printer *p);
-
-void __intel_wakeref_tracker_show(const struct intel_wakeref_tracker *w,
-				  struct drm_printer *p);
-void intel_wakeref_tracker_show(struct intel_wakeref_tracker *w,
-				struct drm_printer *p);
-
-#else
-
-static inline void intel_wakeref_tracker_init(struct intel_wakeref_tracker *w) {}
-static inline void intel_wakeref_tracker_fini(struct intel_wakeref_tracker *w) {}
-
-static inline intel_wakeref_t
-intel_wakeref_tracker_add(struct intel_wakeref_tracker *w)
-{
-	return -1;
-}
-
-static inline void
-intel_wakeref_untrack_remove(struct intel_wakeref_tracker *w, intel_wakeref_t handle) {}
-
-static inline struct intel_wakeref_tracker
-__intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w)
-{
-	return (struct intel_wakeref_tracker){};
-}
-
-static inline void intel_wakeref_tracker_reset(struct intel_wakeref_tracker *w,
-					       struct drm_printer *p)
-{
-}
-
-static inline void __intel_wakeref_tracker_show(const struct intel_wakeref_tracker *w, struct drm_printer *p) {}
-static inline void intel_wakeref_tracker_show(struct intel_wakeref_tracker *w, struct drm_printer *p) {}
-
-#endif
-
-#endif /* INTEL_WAKEREF_TRACKER_H */
-- 
2.25.1

