Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0228F4BEDF1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiBUXU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:20:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236719AbiBUXTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:19:21 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D96E25C5B;
        Mon, 21 Feb 2022 15:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485507; x=1677021507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlFqLRfrfrx4mNRF6vVIBqvEiaofH2gyPUSV1nRx1WA=;
  b=Qb0x3wY5UAkZ9FlMKRR/FnBsv5FznIjQsFBX50TsMZuhnfrBbNH6JRhd
   HFBm43RYFqOjsjzkIR7tx0eduty3vn/H5XPOMT4EWd8ZyuCLvINGsvDY4
   6QvyHW9OK0YEEdZayNuSIVEDcUrtGSBqK7iXAqsNCHkV9wZ39ePetHVL1
   v/AhPR6oBR9AjTkxXIDh1Bn+utXatBE75zu5F3Vml2leNpKyuZGlxwZYm
   PwECGJiKOHwk09x2LXps1aVhfuymA5TfAfAmj7EAQWa7JKcmD4lGt2UZy
   yrxDTEuCwwwMHgLQkucimVrCmGDSc+TUlcOswqK9ciQI6gP7WwVIz0d0X
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251530474"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251530474"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:18:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="638694621"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:18:21 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 09/11] drm/i915: Track leaked gt->wakerefs
Date:   Tue, 22 Feb 2022 00:17:03 +0100
Message-Id: <20220221231705.1481059-22-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221231705.1481059-1-andrzej.hajda@intel.com>
References: <20220221231705.1481059-1-andrzej.hajda@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

Track every intel_gt_pm_get() until its corresponding release in
intel_gt_pm_put() by returning a cookie to the caller for acquire that
must be passed by on rleased. When there is an imbalance, we can see who
either tried to free a stale wakeref, or who forgot to free theirs.

v2: Rebase from backporting wakeref leak (Umesh)

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 drivers/gpu/drm/i915/Kconfig.debug            | 15 +++++++
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    |  7 ++--
 .../i915/gem/selftests/i915_gem_coherency.c   | 10 +++--
 .../drm/i915/gem/selftests/i915_gem_mman.c    | 14 ++++---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c   | 13 ++++--
 .../gpu/drm/i915/gt/intel_breadcrumbs_types.h |  3 +-
 drivers/gpu/drm/i915/gt/intel_engine_pm.c     |  4 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  2 +
 .../drm/i915/gt/intel_execlists_submission.c  |  2 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.c         | 10 +++--
 drivers/gpu/drm/i915/gt/intel_gt_pm.h         | 36 ++++++++++++----
 drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c |  4 +-
 drivers/gpu/drm/i915/gt/selftest_engine_cs.c  | 20 +++++----
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c      |  5 ++-
 drivers/gpu/drm/i915/gt/selftest_reset.c      | 10 +++--
 drivers/gpu/drm/i915/gt/selftest_rps.c        | 17 ++++----
 drivers/gpu/drm/i915/gt/selftest_slpc.c       | 10 +++--
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  9 ++--
 drivers/gpu/drm/i915/i915_pmu.c               | 16 +++----
 drivers/gpu/drm/i915/intel_wakeref.c          |  4 ++
 drivers/gpu/drm/i915/intel_wakeref.h          | 42 +++++++++++++++++++
 21 files changed, 182 insertions(+), 71 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
index 8b1973146e848..3bdc73f30a9e1 100644
--- a/drivers/gpu/drm/i915/Kconfig.debug
+++ b/drivers/gpu/drm/i915/Kconfig.debug
@@ -48,6 +48,7 @@ config DRM_I915_DEBUG
 	select DRM_I915_DEBUG_MMIO
 	select DRM_I915_TRACK_WAKEREF
 	select DRM_I915_DEBUG_RUNTIME_PM
+	select DRM_I915_DEBUG_WAKEREF
 	select DRM_I915_SW_FENCE_DEBUG_OBJECTS
 	select DRM_I915_SELFTEST
 	select BROKEN # for prototype uAPI
@@ -257,3 +258,17 @@ config DRM_I915_DEBUG_RUNTIME_PM
 	  Recommended for driver developers only.
 
 	  If in doubt, say "N"
+
+config DRM_I915_DEBUG_WAKEREF
+	bool "Enable extra tracking for wakerefs"
+	depends on DRM_I915
+	default n
+	select STACKDEPOT
+	select STACKTRACE
+	select DRM_I915_TRACK_WAKEREF
+	help
+	  Choose this option to turn on extra state checking and usage
+	  tracking for the wakerefPM functionality. This may introduce
+	  overhead during driver runtime.
+
+	  If in doubt, say "N"
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 13c975da77474..4b6c144f706da 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -252,6 +252,7 @@ struct i915_execbuffer {
 	struct intel_gt *gt; /* gt for the execbuf */
 	struct intel_context *context; /* logical state for the request */
 	struct i915_gem_context *gem_context; /** caller's context */
+	intel_wakeref_t wakeref;
 
 	/** our requests to build */
 	struct i915_request *requests[MAX_ENGINE_INSTANCE + 1];
@@ -2679,7 +2680,7 @@ eb_select_engine(struct i915_execbuffer *eb)
 
 	for_each_child(ce, child)
 		intel_context_get(child);
-	intel_gt_pm_get(ce->engine->gt);
+	eb->wakeref = intel_gt_pm_get(ce->engine->gt);
 
 	if (!test_bit(CONTEXT_ALLOC_BIT, &ce->flags)) {
 		err = intel_context_alloc_state(ce);
@@ -2713,7 +2714,7 @@ eb_select_engine(struct i915_execbuffer *eb)
 	return err;
 
 err:
-	intel_gt_pm_put(ce->engine->gt);
+	intel_gt_pm_put(ce->engine->gt, eb->wakeref);
 	for_each_child(ce, child)
 		intel_context_put(child);
 	intel_context_put(ce);
@@ -2725,7 +2726,7 @@ eb_put_engine(struct i915_execbuffer *eb)
 {
 	struct intel_context *child;
 
-	intel_gt_pm_put(eb->gt);
+	intel_gt_pm_put(eb->context->engine->gt, eb->wakeref);
 	for_each_child(eb->context, child)
 		intel_context_put(child);
 	intel_context_put(eb->context);
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
index 13b088cc787eb..553f2730c2a76 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
@@ -85,6 +85,7 @@ static int cpu_get(struct context *ctx, unsigned long offset, u32 *v)
 
 static int gtt_set(struct context *ctx, unsigned long offset, u32 v)
 {
+	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	u32 __iomem *map;
 	int err = 0;
@@ -99,7 +100,7 @@ static int gtt_set(struct context *ctx, unsigned long offset, u32 v)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
@@ -112,12 +113,13 @@ static int gtt_set(struct context *ctx, unsigned long offset, u32 v)
 	i915_vma_unpin_iomap(vma);
 
 out_rpm:
-	intel_gt_pm_put(vma->vm->gt);
+	intel_gt_pm_put(vma->vm->gt, wakeref);
 	return err;
 }
 
 static int gtt_get(struct context *ctx, unsigned long offset, u32 *v)
 {
+	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	u32 __iomem *map;
 	int err = 0;
@@ -132,7 +134,7 @@ static int gtt_get(struct context *ctx, unsigned long offset, u32 *v)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
@@ -145,7 +147,7 @@ static int gtt_get(struct context *ctx, unsigned long offset, u32 *v)
 	i915_vma_unpin_iomap(vma);
 
 out_rpm:
-	intel_gt_pm_put(vma->vm->gt);
+	intel_gt_pm_put(vma->vm->gt, wakeref);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index 8ae1a1530bd80..dea5e8e39ab2d 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -624,14 +624,14 @@ static bool assert_mmap_offset(struct drm_i915_private *i915,
 static void disable_retire_worker(struct drm_i915_private *i915)
 {
 	i915_gem_driver_unregister__shrinker(i915);
-	intel_gt_pm_get(to_gt(i915));
+	intel_gt_pm_get_untracked(to_gt(i915));
 	cancel_delayed_work_sync(&to_gt(i915)->requests.retire_work);
 }
 
 static void restore_retire_worker(struct drm_i915_private *i915)
 {
 	igt_flush_test(i915);
-	intel_gt_pm_put(to_gt(i915));
+	intel_gt_pm_put_untracked(to_gt(i915));
 	i915_gem_driver_register__shrinker(i915);
 }
 
@@ -772,6 +772,7 @@ static int igt_mmap_offset_exhaustion(void *arg)
 
 static int gtt_set(struct drm_i915_gem_object *obj)
 {
+	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	void __iomem *map;
 	int err = 0;
@@ -780,7 +781,7 @@ static int gtt_set(struct drm_i915_gem_object *obj)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
 	if (IS_ERR(map)) {
@@ -792,12 +793,13 @@ static int gtt_set(struct drm_i915_gem_object *obj)
 	i915_vma_unpin_iomap(vma);
 
 out:
-	intel_gt_pm_put(vma->vm->gt);
+	intel_gt_pm_put(vma->vm->gt, wakeref);
 	return err;
 }
 
 static int gtt_check(struct drm_i915_gem_object *obj)
 {
+	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	void __iomem *map;
 	int err = 0;
@@ -806,7 +808,7 @@ static int gtt_check(struct drm_i915_gem_object *obj)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
 	if (IS_ERR(map)) {
@@ -822,7 +824,7 @@ static int gtt_check(struct drm_i915_gem_object *obj)
 	i915_vma_unpin_iomap(vma);
 
 out:
-	intel_gt_pm_put(vma->vm->gt);
+	intel_gt_pm_put(vma->vm->gt, wakeref);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index 209cf265bf746..f061d93c27357 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -27,11 +27,14 @@ static void irq_disable(struct intel_breadcrumbs *b)
 
 static void __intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 {
+	intel_wakeref_t wakeref;
+
 	/*
 	 * Since we are waiting on a request, the GPU should be busy
 	 * and should have its own rpm reference.
 	 */
-	if (GEM_WARN_ON(!intel_gt_pm_get_if_awake(b->irq_engine->gt)))
+	wakeref = intel_gt_pm_get_if_awake(b->irq_engine->gt);
+	if (GEM_WARN_ON(!wakeref))
 		return;
 
 	/*
@@ -40,7 +43,7 @@ static void __intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 	 * which we can add a new waiter and avoid the cost of re-enabling
 	 * the irq.
 	 */
-	WRITE_ONCE(b->irq_armed, true);
+	WRITE_ONCE(b->irq_armed, wakeref);
 
 	/* Requests may have completed before we could enable the interrupt. */
 	if (!b->irq_enabled++ && b->irq_enable(b))
@@ -60,12 +63,14 @@ static void intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 
 static void __intel_breadcrumbs_disarm_irq(struct intel_breadcrumbs *b)
 {
+	intel_wakeref_t wakeref = b->irq_armed;
+
 	GEM_BUG_ON(!b->irq_enabled);
 	if (!--b->irq_enabled)
 		b->irq_disable(b);
 
-	WRITE_ONCE(b->irq_armed, false);
-	intel_gt_pm_put_async(b->irq_engine->gt);
+	WRITE_ONCE(b->irq_armed, 0);
+	intel_gt_pm_put_async(b->irq_engine->gt, wakeref);
 }
 
 static void intel_breadcrumbs_disarm_irq(struct intel_breadcrumbs *b)
diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h b/drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h
index 72dfd3748c4c3..bdf09fd67b6e7 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 
 #include "intel_engine_types.h"
+#include "intel_wakeref.h"
 
 /*
  * Rather than have every client wait upon all user interrupts,
@@ -43,7 +44,7 @@ struct intel_breadcrumbs {
 	spinlock_t irq_lock; /* protects the interrupt from hardirq context */
 	struct irq_work irq_work; /* for use from inside irq_lock */
 	unsigned int irq_enabled;
-	bool irq_armed;
+	intel_wakeref_t irq_armed;
 
 	/* Not all breadcrumbs are attached to physical HW */
 	intel_engine_mask_t	engine_mask;
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index b0a4a2dbe3ee9..52e46e7830ff5 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -47,7 +47,7 @@ static int __engine_unpark(struct intel_wakeref *wf)
 
 	ENGINE_TRACE(engine, "\n");
 
-	intel_gt_pm_get(engine->gt);
+	engine->wakeref_track = intel_gt_pm_get(engine->gt);
 
 	/* Discard stale context state from across idling */
 	ce = engine->kernel_context;
@@ -260,7 +260,7 @@ static int __engine_park(struct intel_wakeref *wf)
 		engine->park(engine);
 
 	/* While gt calls i915_vma_parked(), we have to break the lock cycle */
-	intel_gt_pm_put_async(engine->gt);
+	intel_gt_pm_put_async(engine->gt, engine->wakeref_track);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 36365bdbe1ee7..dcd84d1eb90b7 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -382,7 +382,9 @@ struct intel_engine_cs {
 	unsigned long serial;
 
 	unsigned long wakeref_serial;
+	intel_wakeref_t wakeref_track;
 	struct intel_wakeref wakeref;
+
 	struct file *default_state;
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 961d795220a30..4ff269b2697d5 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -630,7 +630,7 @@ static void __execlists_schedule_out(struct i915_request * const rq,
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
 	if (engine->fw_domain && !--engine->fw_active)
 		intel_uncore_forcewake_put(engine->uncore, engine->fw_domain);
-	intel_gt_pm_put_async(engine->gt);
+	intel_gt_pm_put_async_untracked(engine->gt);
 
 	/*
 	 * If this is part of a virtual engine, its next request may
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.c b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
index c0fa41e4c8030..7ee65a93f926f 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
@@ -25,19 +25,20 @@
 static void user_forcewake(struct intel_gt *gt, bool suspend)
 {
 	int count = atomic_read(&gt->user_wakeref);
+	intel_wakeref_t wakeref;
 
 	/* Inside suspend/resume so single threaded, no races to worry about. */
 	if (likely(!count))
 		return;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	if (suspend) {
 		GEM_BUG_ON(count > atomic_read(&gt->wakeref.count));
 		atomic_sub(count, &gt->wakeref.count);
 	} else {
 		atomic_add(count, &gt->wakeref.count);
 	}
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 }
 
 static void runtime_begin(struct intel_gt *gt)
@@ -210,6 +211,7 @@ int intel_gt_resume(struct intel_gt *gt)
 {
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err;
 
 	err = intel_gt_has_unrecoverable_error(gt);
@@ -226,7 +228,7 @@ int intel_gt_resume(struct intel_gt *gt)
 	 */
 	gt_sanitize(gt, true);
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 
 	intel_uncore_forcewake_get(gt->uncore, FORCEWAKE_ALL);
 	intel_rc6_sanitize(&gt->rc6);
@@ -273,7 +275,7 @@ int intel_gt_resume(struct intel_gt *gt)
 
 out_fw:
 	intel_uncore_forcewake_put(gt->uncore, FORCEWAKE_ALL);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 	return err;
 
 err_wedged:
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.h b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
index bc898df7a48cc..3ab06d897df25 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
@@ -16,19 +16,28 @@ static inline bool intel_gt_pm_is_awake(const struct intel_gt *gt)
 	return intel_wakeref_is_active(&gt->wakeref);
 }
 
-static inline void intel_gt_pm_get(struct intel_gt *gt)
+static inline void intel_gt_pm_get_untracked(struct intel_gt *gt)
 {
 	intel_wakeref_get(&gt->wakeref);
 }
 
+static inline intel_wakeref_t intel_gt_pm_get(struct intel_gt *gt)
+{
+	intel_gt_pm_get_untracked(gt);
+	return intel_wakeref_track(&gt->wakeref);
+}
+
 static inline void __intel_gt_pm_get(struct intel_gt *gt)
 {
 	__intel_wakeref_get(&gt->wakeref);
 }
 
-static inline bool intel_gt_pm_get_if_awake(struct intel_gt *gt)
+static inline intel_wakeref_t intel_gt_pm_get_if_awake(struct intel_gt *gt)
 {
-	return intel_wakeref_get_if_active(&gt->wakeref);
+	if (!intel_wakeref_get_if_active(&gt->wakeref))
+		return 0;
+
+	return intel_wakeref_track(&gt->wakeref);
 }
 
 static inline void intel_gt_pm_might_get(struct intel_gt *gt)
@@ -36,12 +45,18 @@ static inline void intel_gt_pm_might_get(struct intel_gt *gt)
 	intel_wakeref_might_get(&gt->wakeref);
 }
 
-static inline void intel_gt_pm_put(struct intel_gt *gt)
+static inline void intel_gt_pm_put_untracked(struct intel_gt *gt)
 {
 	intel_wakeref_put(&gt->wakeref);
 }
 
-static inline void intel_gt_pm_put_async(struct intel_gt *gt)
+static inline void intel_gt_pm_put(struct intel_gt *gt, intel_wakeref_t handle)
+{
+	intel_wakeref_untrack(&gt->wakeref, handle);
+	intel_gt_pm_put_untracked(gt);
+}
+
+static inline void intel_gt_pm_put_async_untracked(struct intel_gt *gt)
 {
 	intel_wakeref_put_async(&gt->wakeref);
 }
@@ -51,9 +66,14 @@ static inline void intel_gt_pm_might_put(struct intel_gt *gt)
 	intel_wakeref_might_put(&gt->wakeref);
 }
 
-#define with_intel_gt_pm(gt, tmp) \
-	for (tmp = 1, intel_gt_pm_get(gt); tmp; \
-	     intel_gt_pm_put(gt), tmp = 0)
+static inline void intel_gt_pm_put_async(struct intel_gt *gt, intel_wakeref_t handle)
+{
+	intel_wakeref_untrack(&gt->wakeref, handle);
+	intel_gt_pm_put_async_untracked(gt);
+}
+
+#define with_intel_gt_pm(gt, wf) \
+	for (wf = intel_gt_pm_get(gt); wf; intel_gt_pm_put(gt, wf), wf = 0)
 
 static inline int intel_gt_pm_wait_for_idle(struct intel_gt *gt)
 {
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
index 37765919fe322..e02a3e26e0d02 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
@@ -26,7 +26,7 @@
 int intel_gt_pm_debugfs_forcewake_user_open(struct intel_gt *gt)
 {
 	atomic_inc(&gt->user_wakeref);
-	intel_gt_pm_get(gt);
+	intel_gt_pm_get_untracked(gt);
 	if (GRAPHICS_VER(gt->i915) >= 6)
 		intel_uncore_forcewake_user_get(gt->uncore);
 
@@ -37,7 +37,7 @@ int intel_gt_pm_debugfs_forcewake_user_release(struct intel_gt *gt)
 {
 	if (GRAPHICS_VER(gt->i915) >= 6)
 		intel_uncore_forcewake_user_put(gt->uncore);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put_untracked(gt);
 	atomic_dec(&gt->user_wakeref);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/gt/selftest_engine_cs.c b/drivers/gpu/drm/i915/gt/selftest_engine_cs.c
index 1b75f478d1b83..8ea6bf4c987e2 100644
--- a/drivers/gpu/drm/i915/gt/selftest_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/selftest_engine_cs.c
@@ -21,20 +21,22 @@ static int cmp_u32(const void *A, const void *B)
 	return *a - *b;
 }
 
-static void perf_begin(struct intel_gt *gt)
+static intel_wakeref_t perf_begin(struct intel_gt *gt)
 {
-	intel_gt_pm_get(gt);
+	intel_wakeref_t wakeref = intel_gt_pm_get(gt);
 
 	/* Boost gpufreq to max [waitboost] and keep it fixed */
 	atomic_inc(&gt->rps.num_waiters);
 	schedule_work(&gt->rps.work);
 	flush_work(&gt->rps.work);
+
+	return wakeref;
 }
 
-static int perf_end(struct intel_gt *gt)
+static int perf_end(struct intel_gt *gt, intel_wakeref_t wakeref)
 {
 	atomic_dec(&gt->rps.num_waiters);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	return igt_flush_test(gt->i915);
 }
@@ -123,12 +125,13 @@ static int perf_mi_bb_start(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (GRAPHICS_VER(gt->i915) < 7) /* for per-engine CS_TIMESTAMP */
 		return 0;
 
-	perf_begin(gt);
+	wakeref = perf_begin(gt);
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce = engine->kernel_context;
 		struct i915_vma *batch;
@@ -194,7 +197,7 @@ static int perf_mi_bb_start(void *arg)
 		pr_info("%s: MI_BB_START cycles: %u\n",
 			engine->name, trifilter(cycles));
 	}
-	if (perf_end(gt))
+	if (perf_end(gt, wakeref))
 		err = -EIO;
 
 	return err;
@@ -247,12 +250,13 @@ static int perf_mi_noop(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (GRAPHICS_VER(gt->i915) < 7) /* for per-engine CS_TIMESTAMP */
 		return 0;
 
-	perf_begin(gt);
+	wakeref = perf_begin(gt);
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce = engine->kernel_context;
 		struct i915_vma *base, *nop;
@@ -348,7 +352,7 @@ static int perf_mi_noop(void *arg)
 		pr_info("%s: 16K MI_NOOP cycles: %u\n",
 			engine->name, trifilter(cycles));
 	}
-	if (perf_end(gt))
+	if (perf_end(gt, wakeref))
 		err = -EIO;
 
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
index be94f863bdeff..f0f9983a6fbb2 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -68,6 +68,7 @@ static int live_gt_clocks(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (!gt->clock_frequency) { /* unknown */
@@ -97,7 +98,7 @@ static int live_gt_clocks(void *arg)
 		 */
 		return 0;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	intel_uncore_forcewake_get(gt->uncore, FORCEWAKE_ALL);
 
 	for_each_engine(engine, gt, id) {
@@ -134,7 +135,7 @@ static int live_gt_clocks(void *arg)
 	}
 
 	intel_uncore_forcewake_put(gt->uncore, FORCEWAKE_ALL);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	return err;
 }
diff --git a/drivers/gpu/drm/i915/gt/selftest_reset.c b/drivers/gpu/drm/i915/gt/selftest_reset.c
index 37c38bdd5f474..cb01901c94e94 100644
--- a/drivers/gpu/drm/i915/gt/selftest_reset.c
+++ b/drivers/gpu/drm/i915/gt/selftest_reset.c
@@ -257,11 +257,12 @@ static int igt_atomic_reset(void *arg)
 {
 	struct intel_gt *gt = arg;
 	const typeof(*igt_atomic_phases) *p;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	/* Check that the resets are usable from atomic context */
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	igt_global_reset_lock(gt);
 
 	/* Flush any requests before we get started and check basics */
@@ -292,7 +293,7 @@ static int igt_atomic_reset(void *arg)
 
 unlock:
 	igt_global_reset_unlock(gt);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	return err;
 }
@@ -303,6 +304,7 @@ static int igt_atomic_engine_reset(void *arg)
 	const typeof(*igt_atomic_phases) *p;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	/* Check that the resets are usable from atomic context */
@@ -313,7 +315,7 @@ static int igt_atomic_engine_reset(void *arg)
 	if (intel_uc_uses_guc_submission(&gt->uc))
 		return 0;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	igt_global_reset_lock(gt);
 
 	/* Flush any requests before we get started and check basics */
@@ -361,7 +363,7 @@ static int igt_atomic_engine_reset(void *arg)
 
 out_unlock:
 	igt_global_reset_unlock(gt);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	return err;
 }
diff --git a/drivers/gpu/drm/i915/gt/selftest_rps.c b/drivers/gpu/drm/i915/gt/selftest_rps.c
index 6a69ac0184ad8..7effd09ced988 100644
--- a/drivers/gpu/drm/i915/gt/selftest_rps.c
+++ b/drivers/gpu/drm/i915/gt/selftest_rps.c
@@ -223,6 +223,7 @@ int live_rps_clock_interval(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (!intel_rps_is_enabled(rps) || GRAPHICS_VER(gt->i915) < 6)
@@ -235,7 +236,7 @@ int live_rps_clock_interval(void *arg)
 	saved_work = rps->work.func;
 	rps->work.func = dummy_rps_work;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	intel_rps_disable(&gt->rps);
 
 	intel_gt_check_clock_frequency(gt);
@@ -354,7 +355,7 @@ int live_rps_clock_interval(void *arg)
 	}
 
 	intel_rps_enable(&gt->rps);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	igt_spinner_fini(&spin);
 
@@ -375,6 +376,7 @@ int live_rps_control(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	/*
@@ -397,7 +399,7 @@ int live_rps_control(void *arg)
 	saved_work = rps->work.func;
 	rps->work.func = dummy_rps_work;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	for_each_engine(engine, gt, id) {
 		struct i915_request *rq;
 		ktime_t min_dt, max_dt;
@@ -487,7 +489,7 @@ int live_rps_control(void *arg)
 			break;
 		}
 	}
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	igt_spinner_fini(&spin);
 
@@ -1026,6 +1028,7 @@ int live_rps_interrupt(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	u32 pm_events;
 	int err = 0;
 
@@ -1036,9 +1039,9 @@ int live_rps_interrupt(void *arg)
 	if (!intel_rps_has_interrupts(rps) || GRAPHICS_VER(gt->i915) < 6)
 		return 0;
 
-	intel_gt_pm_get(gt);
-	pm_events = rps->pm_events;
-	intel_gt_pm_put(gt);
+	pm_events = 0;
+	with_intel_gt_pm(gt, wakeref)
+		pm_events = rps->pm_events;
 	if (!pm_events) {
 		pr_err("No RPS PM events registered, but RPS is enabled?\n");
 		return -ENODEV;
diff --git a/drivers/gpu/drm/i915/gt/selftest_slpc.c b/drivers/gpu/drm/i915/gt/selftest_slpc.c
index b768cea5943dd..27be3c9b29b13 100644
--- a/drivers/gpu/drm/i915/gt/selftest_slpc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_slpc.c
@@ -44,6 +44,7 @@ static int live_slpc_clamp_min(void *arg)
 	struct intel_rps *rps = &gt->rps;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	struct igt_spinner spin;
 	u32 slpc_min_freq, slpc_max_freq;
 	int err = 0;
@@ -70,7 +71,7 @@ static int live_slpc_clamp_min(void *arg)
 	}
 
 	intel_gt_pm_wait_for_idle(gt);
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	for_each_engine(engine, gt, id) {
 		struct i915_request *rq;
 		u32 step, min_freq, req_freq;
@@ -156,7 +157,7 @@ static int live_slpc_clamp_min(void *arg)
 	if (igt_flush_test(gt->i915))
 		err = -EIO;
 
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 	igt_spinner_fini(&spin);
 	intel_gt_pm_wait_for_idle(gt);
 
@@ -171,6 +172,7 @@ static int live_slpc_clamp_max(void *arg)
 	struct intel_rps *rps;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	struct igt_spinner spin;
 	int err = 0;
 	u32 slpc_min_freq, slpc_max_freq;
@@ -200,7 +202,7 @@ static int live_slpc_clamp_max(void *arg)
 	}
 
 	intel_gt_pm_wait_for_idle(gt);
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	for_each_engine(engine, gt, id) {
 		struct i915_request *rq;
 		u32 max_freq, req_freq;
@@ -290,7 +292,7 @@ static int live_slpc_clamp_max(void *arg)
 	slpc_set_max_freq(slpc, slpc_max_freq);
 	slpc_set_min_freq(slpc, slpc_min_freq);
 
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 	igt_spinner_fini(&spin);
 	intel_gt_pm_wait_for_idle(gt);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index b3a429a92c0da..7799939c38945 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1048,7 +1048,7 @@ static void scrub_guc_desc_for_outstanding_g2h(struct intel_guc *guc)
 			if (deregister)
 				guc_signal_context_fence(ce);
 			if (destroyed) {
-				intel_gt_pm_put_async(guc_to_gt(guc));
+				intel_gt_pm_put_async_untracked(guc_to_gt(guc));
 				release_guc_id(guc, ce);
 				__guc_context_destroy(ce);
 			}
@@ -1254,6 +1254,7 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 	unsigned long flags;
 	u32 reset_count;
 	bool in_reset;
+	intel_wakeref_t wakeref;
 
 	spin_lock_irqsave(&guc->timestamp.lock, flags);
 
@@ -1276,7 +1277,7 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 	 * start_gt_clk is derived from GuC state. To get a consistent
 	 * view of activity, we query the GuC state only if gt is awake.
 	 */
-	if (!in_reset && intel_gt_pm_get_if_awake(gt)) {
+	if (!in_reset && (wakeref = intel_gt_pm_get_if_awake(gt))) {
 		stats_saved = *stats;
 		gt_stamp_saved = guc->timestamp.gt_stamp;
 		/*
@@ -1285,7 +1286,7 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 		 */
 		guc_update_engine_gt_clks(engine);
 		guc_update_pm_timestamp(guc, now);
-		intel_gt_pm_put_async(gt);
+		intel_gt_pm_put_async(gt, wakeref);
 		if (i915_reset_count(gpu_error) != reset_count) {
 			*stats = stats_saved;
 			guc->timestamp.gt_stamp = gt_stamp_saved;
@@ -3903,7 +3904,7 @@ int intel_guc_deregister_done_process_msg(struct intel_guc *guc,
 		intel_context_put(ce);
 	} else if (context_destroyed(ce)) {
 		/* Context has been destroyed */
-		intel_gt_pm_put_async(guc_to_gt(guc));
+		intel_gt_pm_put_async_untracked(guc_to_gt(guc));
 		release_guc_id(guc, ce);
 		__guc_context_destroy(ce);
 	}
diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index cfc21042499d0..3bd0c75c2ee69 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -171,19 +171,19 @@ static u64 get_rc6(struct intel_gt *gt)
 {
 	struct drm_i915_private *i915 = gt->i915;
 	struct i915_pmu *pmu = &i915->pmu;
+	intel_wakeref_t wakeref;
 	unsigned long flags;
-	bool awake = false;
 	u64 val;
 
-	if (intel_gt_pm_get_if_awake(gt)) {
+	wakeref = intel_gt_pm_get_if_awake(gt);
+	if (wakeref) {
 		val = __get_rc6(gt);
-		intel_gt_pm_put_async(gt);
-		awake = true;
+		intel_gt_pm_put_async(gt, wakeref);
 	}
 
 	spin_lock_irqsave(&pmu->lock, flags);
 
-	if (awake) {
+	if (wakeref) {
 		pmu->sample[__I915_SAMPLE_RC6].cur = val;
 	} else {
 		/*
@@ -377,12 +377,14 @@ frequency_sample(struct intel_gt *gt, unsigned int period_ns)
 	struct intel_uncore *uncore = gt->uncore;
 	struct i915_pmu *pmu = &i915->pmu;
 	struct intel_rps *rps = &gt->rps;
+	intel_wakeref_t wakeref;
 
 	if (!frequency_sampling_enabled(pmu))
 		return;
 
 	/* Report 0/0 (actual/requested) frequency while parked. */
-	if (!intel_gt_pm_get_if_awake(gt))
+	wakeref = intel_gt_pm_get_if_awake(gt);
+	if (!wakeref)
 		return;
 
 	if (pmu->enable & config_mask(I915_PMU_ACTUAL_FREQUENCY)) {
@@ -413,7 +415,7 @@ frequency_sample(struct intel_gt *gt, unsigned int period_ns)
 				period_ns / 1000);
 	}
 
-	intel_gt_pm_put_async(gt);
+	intel_gt_pm_put_async(gt, wakeref);
 }
 
 static enum hrtimer_restart i915_sample(struct hrtimer *hrtimer)
diff --git a/drivers/gpu/drm/i915/intel_wakeref.c b/drivers/gpu/drm/i915/intel_wakeref.c
index dfd87d0822180..db4887e33ea60 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.c
+++ b/drivers/gpu/drm/i915/intel_wakeref.c
@@ -108,6 +108,10 @@ void __intel_wakeref_init(struct intel_wakeref *wf,
 	INIT_DELAYED_WORK(&wf->work, __intel_wakeref_put_work);
 	lockdep_init_map(&wf->work.work.lockdep_map,
 			 "wakeref.work", &key->work, 0);
+
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+	intel_wakeref_tracker_init(&wf->debug);
+#endif
 }
 
 int intel_wakeref_wait_for_idle(struct intel_wakeref *wf)
diff --git a/drivers/gpu/drm/i915/intel_wakeref.h b/drivers/gpu/drm/i915/intel_wakeref.h
index e6ba389652d74..38439deefc5cc 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.h
+++ b/drivers/gpu/drm/i915/intel_wakeref.h
@@ -43,6 +43,10 @@ struct intel_wakeref {
 	const struct intel_wakeref_ops *ops;
 
 	struct delayed_work work;
+
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+	struct intel_wakeref_tracker debug;
+#endif
 };
 
 struct intel_wakeref_lockclass {
@@ -262,6 +266,44 @@ __intel_wakeref_defer_park(struct intel_wakeref *wf)
  */
 int intel_wakeref_wait_for_idle(struct intel_wakeref *wf);
 
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+
+static inline intel_wakeref_t intel_wakeref_track(struct intel_wakeref *wf)
+{
+	return intel_wakeref_tracker_add(&wf->debug);
+}
+
+static inline void intel_wakeref_untrack(struct intel_wakeref *wf,
+					 intel_wakeref_t handle)
+{
+	intel_wakeref_tracker_remove(&wf->debug, handle);
+}
+
+static inline void intel_wakeref_show(struct intel_wakeref *wf,
+				      struct drm_printer *p)
+{
+	intel_wakeref_tracker_show(&wf->debug, p);
+}
+
+#else
+
+static inline intel_wakeref_t intel_wakeref_track(struct intel_wakeref *wf)
+{
+	return -1;
+}
+
+static inline void intel_wakeref_untrack(struct intel_wakeref *wf,
+					 intel_wakeref_t handle)
+{
+}
+
+static inline void intel_wakeref_show(struct intel_wakeref *wf,
+				      struct drm_printer *p)
+{
+}
+
+#endif
+
 struct intel_wakeref_auto {
 	struct intel_runtime_pm *rpm;
 	struct timer_list timer;
-- 
2.25.1

