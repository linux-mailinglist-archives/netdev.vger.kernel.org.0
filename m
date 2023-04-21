Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026636EA94D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjDULgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjDULfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:35:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60C0C677;
        Fri, 21 Apr 2023 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682076940; x=1713612940;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=c8+BCYMwy3wnJcAac5yNCiepvnan5EkQFWm7bo+KAD4=;
  b=VOldcgP3K1Ahx1eyGKy6x3vMSTGmxJeWs3nd9Iv2+MJqGXHVwKr5HJdz
   K5xLkAFrSqOaqdYoAiv4lxHCJ5cDVp5nCw1pkalk2pbsvcVWNja6cxTEJ
   26GdMGy0VCGnrCAmcde3d+VPZ2vETBjAlgKBhYhaEpcHrpRCrq9XQSNJX
   OMV/FgZNrKuuv1NUE/RV7w208dD/i3HBfgUPAfJykFjeWcFxhhAevmdKN
   nuTswE6GlAnQyJChsD92E2iPihyZFmDYVm8TayctY/ZRnXKrMhlIKscEl
   SX3OVNkRQR7bewJLFB8iKrZNtPNqbXpXo4zXsQXEITN2z/RpWCBoIOU/x
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432249947"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="432249947"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 04:35:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="642489686"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642489686"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 04:35:36 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Fri, 21 Apr 2023 13:35:09 +0200
Subject: [PATCH v7 6/7] drm/i915: Replace custom intel runtime_pm tracker with
 ref_tracker library
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v7-6-11f08358c1ec@intel.com>
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
In-Reply-To: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
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
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
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
---
 drivers/gpu/drm/i915/Kconfig.debug                 |   4 +
 drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
 drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
 drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
 drivers/gpu/drm/i915/intel_wakeref.h               |  61 +++++-
 6 files changed, 84 insertions(+), 217 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
index 47e845353ffad8..76454fcbf65228 100644
--- a/drivers/gpu/drm/i915/Kconfig.debug
+++ b/drivers/gpu/drm/i915/Kconfig.debug
@@ -24,7 +24,9 @@ config DRM_I915_DEBUG
 	select DEBUG_FS
 	select PREEMPT_COUNT
 	select I2C_CHARDEV
+	select REF_TRACKER
 	select STACKDEPOT
+	select STACKTRACE
 	select DRM_DP_AUX_CHARDEV
 	select X86_MSR # used by igt/pm_rpm
 	select DRM_VGEM # used by igt/prime_vgem (dmabuf interop checks)
@@ -230,7 +232,9 @@ config DRM_I915_DEBUG_RUNTIME_PM
 	bool "Enable extra state checking for runtime PM"
 	depends on DRM_I915
 	default n
+	select REF_TRACKER
 	select STACKDEPOT
+	select STACKTRACE
 	help
 	  Choose this option to turn on extra state checking for the
 	  runtime PM functionality. This may introduce overhead during
diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 7c9f4288329ede..6ebdcfaa009906 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -406,7 +406,7 @@ print_async_put_domains_state(struct i915_power_domains *power_domains)
 						     struct drm_i915_private,
 						     display.power.domains);
 
-	drm_dbg(&i915->drm, "async_put_wakeref %u\n",
+	drm_dbg(&i915->drm, "async_put_wakeref %lu\n",
 		power_domains->async_put_wakeref);
 
 	print_power_domains(power_domains, "async_put_domains[0]",
diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index a52db8a8090065..89d5e4cdfb4386 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1019,7 +1019,7 @@ void i915_driver_shutdown(struct drm_i915_private *i915)
 	intel_power_domains_driver_remove(i915);
 	enable_rpm_wakeref_asserts(&i915->runtime_pm);
 
-	intel_runtime_pm_driver_release(&i915->runtime_pm);
+	intel_runtime_pm_driver_last_release(&i915->runtime_pm);
 }
 
 static bool suspend_to_idle(struct drm_i915_private *dev_priv)
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.c b/drivers/gpu/drm/i915/intel_runtime_pm.c
index cf5122299b6b8c..c5785ddaa717e4 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -52,182 +52,37 @@
 
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG_RUNTIME_PM)
 
-#include <linux/sort.h>
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
 static void init_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
-	spin_lock_init(&rpm->debug.lock);
-	stack_depot_init();
+	ref_tracker_dir_init(&rpm->debug, INTEL_REFTRACK_DEAD_COUNT, dev_name(rpm->kdev));
 }
 
-static noinline depot_stack_handle_t
+static intel_wakeref_t
 track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
-	depot_stack_handle_t stack, *stacks;
-	unsigned long flags;
-
-	if (rpm->no_wakeref_tracking)
-		return -1;
-
-	stack = __save_depot_stack();
-	if (!stack)
+	if (!rpm->available || rpm->no_wakeref_tracking)
 		return -1;
 
-	spin_lock_irqsave(&rpm->debug.lock, flags);
-
-	if (!rpm->debug.count)
-		rpm->debug.last_acquire = stack;
-
-	stacks = krealloc(rpm->debug.owners,
-			  (rpm->debug.count + 1) * sizeof(*stacks),
-			  GFP_NOWAIT | __GFP_NOWARN);
-	if (stacks) {
-		stacks[rpm->debug.count++] = stack;
-		rpm->debug.owners = stacks;
-	} else {
-		stack = -1;
-	}
-
-	spin_unlock_irqrestore(&rpm->debug.lock, flags);
-
-	return stack;
+	return intel_ref_tracker_alloc(&rpm->debug);
 }
 
 static void untrack_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm,
-					     depot_stack_handle_t stack)
+					     intel_wakeref_t wakeref)
 {
-	struct drm_i915_private *i915 = container_of(rpm,
-						     struct drm_i915_private,
-						     runtime_pm);
-	unsigned long flags, n;
-	bool found = false;
-
-	if (unlikely(stack == -1))
+	if (!rpm->available || rpm->no_wakeref_tracking)
 		return;
 
-	spin_lock_irqsave(&rpm->debug.lock, flags);
-	for (n = rpm->debug.count; n--; ) {
-		if (rpm->debug.owners[n] == stack) {
-			memmove(rpm->debug.owners + n,
-				rpm->debug.owners + n + 1,
-				(--rpm->debug.count - n) * sizeof(stack));
-			found = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&rpm->debug.lock, flags);
-
-	if (drm_WARN(&i915->drm, !found,
-		     "Unmatched wakeref (tracking %lu), count %u\n",
-		     rpm->debug.count, atomic_read(&rpm->wakeref_count))) {
-		char *buf;
-
-		buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
-		if (!buf)
-			return;
-
-		stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
-		DRM_DEBUG_DRIVER("wakeref %x from\n%s", stack, buf);
-
-		stack = READ_ONCE(rpm->debug.last_release);
-		if (stack) {
-			stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
-			DRM_DEBUG_DRIVER("wakeref last released at\n%s", buf);
-		}
-
-		kfree(buf);
-	}
+	intel_ref_tracker_free(&rpm->debug, wakeref);
 }
 
-static int cmphandle(const void *_a, const void *_b)
+static void untrack_all_intel_runtime_pm_wakerefs(struct intel_runtime_pm *rpm)
 {
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
-static void
-__print_intel_runtime_pm_wakeref(struct drm_printer *p,
-				 const struct intel_runtime_pm_debug *dbg)
-{
-	unsigned long i;
-	char *buf;
-
-	buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
-	if (!buf)
-		return;
-
-	if (dbg->last_acquire) {
-		stack_depot_snprint(dbg->last_acquire, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref last acquired:\n%s", buf);
-	}
-
-	if (dbg->last_release) {
-		stack_depot_snprint(dbg->last_release, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref last released:\n%s", buf);
-	}
-
-	drm_printf(p, "Wakeref count: %lu\n", dbg->count);
-
-	sort(dbg->owners, dbg->count, sizeof(*dbg->owners), cmphandle, NULL);
-
-	for (i = 0; i < dbg->count; i++) {
-		depot_stack_handle_t stack = dbg->owners[i];
-		unsigned long rep;
-
-		rep = 1;
-		while (i + 1 < dbg->count && dbg->owners[i + 1] == stack)
-			rep++, i++;
-		stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
-		drm_printf(p, "Wakeref x%lu taken at:\n%s", rep, buf);
-	}
-
-	kfree(buf);
-}
-
-static noinline void
-__untrack_all_wakerefs(struct intel_runtime_pm_debug *debug,
-		       struct intel_runtime_pm_debug *saved)
-{
-	*saved = *debug;
-
-	debug->owners = NULL;
-	debug->count = 0;
-	debug->last_release = __save_depot_stack();
-}
-
-static void
-dump_and_free_wakeref_tracking(struct intel_runtime_pm_debug *debug)
-{
-	if (debug->count) {
-		struct drm_printer p = drm_debug_printer("i915");
-
-		__print_intel_runtime_pm_wakeref(&p, debug);
-	}
-
-	kfree(debug->owners);
+	ref_tracker_dir_exit(&rpm->debug);
 }
 
 static noinline void
 __intel_wakeref_dec_and_check_tracking(struct intel_runtime_pm *rpm)
 {
-	struct intel_runtime_pm_debug dbg = {};
 	unsigned long flags;
 
 	if (!atomic_dec_and_lock_irqsave(&rpm->wakeref_count,
@@ -235,60 +90,14 @@ __intel_wakeref_dec_and_check_tracking(struct intel_runtime_pm *rpm)
 					 flags))
 		return;
 
-	__untrack_all_wakerefs(&rpm->debug, &dbg);
+	ref_tracker_dir_print_locked(&rpm->debug, INTEL_REFTRACK_PRINT_LIMIT);
 	spin_unlock_irqrestore(&rpm->debug.lock, flags);
-
-	dump_and_free_wakeref_tracking(&dbg);
-}
-
-static noinline void
-untrack_all_intel_runtime_pm_wakerefs(struct intel_runtime_pm *rpm)
-{
-	struct intel_runtime_pm_debug dbg = {};
-	unsigned long flags;
-
-	spin_lock_irqsave(&rpm->debug.lock, flags);
-	__untrack_all_wakerefs(&rpm->debug, &dbg);
-	spin_unlock_irqrestore(&rpm->debug.lock, flags);
-
-	dump_and_free_wakeref_tracking(&dbg);
 }
 
 void print_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm,
 				    struct drm_printer *p)
 {
-	struct intel_runtime_pm_debug dbg = {};
-
-	do {
-		unsigned long alloc = dbg.count;
-		depot_stack_handle_t *s;
-
-		spin_lock_irq(&rpm->debug.lock);
-		dbg.count = rpm->debug.count;
-		if (dbg.count <= alloc) {
-			memcpy(dbg.owners,
-			       rpm->debug.owners,
-			       dbg.count * sizeof(*s));
-		}
-		dbg.last_acquire = rpm->debug.last_acquire;
-		dbg.last_release = rpm->debug.last_release;
-		spin_unlock_irq(&rpm->debug.lock);
-		if (dbg.count <= alloc)
-			break;
-
-		s = krealloc(dbg.owners,
-			     dbg.count * sizeof(*s),
-			     GFP_NOWAIT | __GFP_NOWARN);
-		if (!s)
-			goto out;
-
-		dbg.owners = s;
-	} while (1);
-
-	__print_intel_runtime_pm_wakeref(p, &dbg);
-
-out:
-	kfree(dbg.owners);
+	intel_wakeref_tracker_show(&rpm->debug, p);
 }
 
 #else
@@ -297,14 +106,14 @@ static void init_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
 }
 
-static depot_stack_handle_t
+static intel_wakeref_t
 track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
 	return -1;
 }
 
 static void untrack_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm,
-					     intel_wakeref_t wref)
+					     intel_wakeref_t wakeref)
 {
 }
 
@@ -639,7 +448,11 @@ void intel_runtime_pm_driver_release(struct intel_runtime_pm *rpm)
 		 "i915 raw-wakerefs=%d wakelocks=%d on cleanup\n",
 		 intel_rpm_raw_wakeref_count(count),
 		 intel_rpm_wakelock_count(count));
+}
 
+void intel_runtime_pm_driver_last_release(struct intel_runtime_pm *rpm)
+{
+	intel_runtime_pm_driver_release(rpm);
 	untrack_all_intel_runtime_pm_wakerefs(rpm);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.h b/drivers/gpu/drm/i915/intel_runtime_pm.h
index e592e8d6499a1f..2f81d685bdb4d1 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -83,15 +83,7 @@ struct intel_runtime_pm {
 	 * paired rpm_put) we can remove corresponding pairs of and keep
 	 * the array trimmed to active wakerefs.
 	 */
-	struct intel_runtime_pm_debug {
-		spinlock_t lock;
-
-		depot_stack_handle_t last_acquire;
-		depot_stack_handle_t last_release;
-
-		depot_stack_handle_t *owners;
-		unsigned long count;
-	} debug;
+	struct ref_tracker_dir debug;
 #endif
 };
 
@@ -195,6 +187,7 @@ void intel_runtime_pm_init_early(struct intel_runtime_pm *rpm);
 void intel_runtime_pm_enable(struct intel_runtime_pm *rpm);
 void intel_runtime_pm_disable(struct intel_runtime_pm *rpm);
 void intel_runtime_pm_driver_release(struct intel_runtime_pm *rpm);
+void intel_runtime_pm_driver_last_release(struct intel_runtime_pm *rpm);
 
 intel_wakeref_t intel_runtime_pm_get(struct intel_runtime_pm *rpm);
 intel_wakeref_t intel_runtime_pm_get_if_in_use(struct intel_runtime_pm *rpm);
diff --git a/drivers/gpu/drm/i915/intel_wakeref.h b/drivers/gpu/drm/i915/intel_wakeref.h
index 0b6b4852ab236a..99ee6254976ebf 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.h
+++ b/drivers/gpu/drm/i915/intel_wakeref.h
@@ -7,16 +7,25 @@
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
 
+typedef unsigned long intel_wakeref_t;
+
+#define INTEL_REFTRACK_DEAD_COUNT 16
+#define INTEL_REFTRACK_PRINT_LIMIT 16
+
 #if IS_ENABLED(CONFIG_DRM_I915_DEBUG)
 #define INTEL_WAKEREF_BUG_ON(expr) BUG_ON(expr)
 #else
@@ -26,8 +35,6 @@
 struct intel_runtime_pm;
 struct intel_wakeref;
 
-typedef depot_stack_handle_t intel_wakeref_t;
-
 struct intel_wakeref_ops {
 	int (*get)(struct intel_wakeref *wf);
 	int (*put)(struct intel_wakeref *wf);
@@ -261,6 +268,56 @@ __intel_wakeref_defer_park(struct intel_wakeref *wf)
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
+		drm_printf(p, "\n...dropped %zd extra bytes of leak report.\n",
+			   count + 1 - buf_size);
+free:
+	kfree(buf);
+}
+
 struct intel_wakeref_auto {
 	struct intel_runtime_pm *rpm;
 	struct timer_list timer;

-- 
2.34.1
