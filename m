Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6A6ED787
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjDXWHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbjDXWHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:07:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871639765;
        Mon, 24 Apr 2023 15:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682373993; x=1713909993;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=AQg7KZc9r4pt/1GKFRFO1byGhvFwUpRPfpH4lqM6wX0=;
  b=YefPCNmR68CTYKzsfFL6w4Ae4V3gwU6yqiuYgxz26mjQnu7d4ylNtgu4
   WENhylD38krsro1fzXLpUxHOwFytGWkuj3dwn+MP58NlbufnorSia/NyS
   lk6ufdDEWBgX79sccJc/KdI6ojn6JHO8Nj0x/XBxHxg0Q/qf9OjJSFzPu
   BaNhaRj3I255Yjzdxhouoz7SQ/mt24BeZX0fFqUl/e17rW6/DKtiM0kq/
   IqwtGIndjVBW0ZOJeMqCnEONQbj7TBlG7YOu1xChorXxU+fHb/uHK/QmM
   95I7km06VUscou5S77DQECTyW/1G6XLNYfA8cA/2wjwqtkK+rHCWWMYYY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335473769"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="335473769"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="939500416"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="939500416"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 15:06:13 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Tue, 25 Apr 2023 00:05:44 +0200
Subject: [PATCH v8 7/7] drm/i915: Track gt pm wakerefs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v8-7-4b6517e61be6@intel.com>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
In-Reply-To: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_PDS_OTHER_BAD_TLD,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track every intel_gt_pm_get() until its corresponding release in
intel_gt_pm_put() by returning a cookie to the caller for acquire that
must be passed by on released. When there is an imbalance, we can see who
either tried to free a stale wakeref, or who forgot to free theirs.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 drivers/gpu/drm/i915/Kconfig.debug                 | 14 ++++++++
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  7 ++--
 .../drm/i915/gem/selftests/i915_gem_coherency.c    | 10 +++---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 14 ++++----
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        | 13 +++++---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |  3 +-
 drivers/gpu/drm/i915/gt/intel_context.h            |  4 +--
 drivers/gpu/drm/i915/gt/intel_context_types.h      |  2 ++
 drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  7 ++--
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |  2 ++
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  2 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.c              | 12 ++++---
 drivers/gpu/drm/i915/gt/intel_gt_pm.h              | 38 +++++++++++++++++-----
 drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |  4 +--
 drivers/gpu/drm/i915/gt/selftest_engine_cs.c       | 20 +++++++-----
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |  5 +--
 drivers/gpu/drm/i915/gt/selftest_reset.c           | 10 +++---
 drivers/gpu/drm/i915/gt/selftest_rps.c             | 17 ++++++----
 drivers/gpu/drm/i915/gt/selftest_slpc.c            |  5 +--
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  | 10 +++---
 drivers/gpu/drm/i915/i915_pmu.c                    | 16 +++++----
 drivers/gpu/drm/i915/intel_wakeref.c               |  7 +++-
 drivers/gpu/drm/i915/intel_wakeref.h               | 38 ++++++++++++++++++++--
 23 files changed, 182 insertions(+), 78 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
index 76454fcbf65228..01e18e4c0e2590 100644
--- a/drivers/gpu/drm/i915/Kconfig.debug
+++ b/drivers/gpu/drm/i915/Kconfig.debug
@@ -40,6 +40,7 @@ config DRM_I915_DEBUG
 	select DRM_I915_DEBUG_GEM_ONCE
 	select DRM_I915_DEBUG_MMIO
 	select DRM_I915_DEBUG_RUNTIME_PM
+	select DRM_I915_DEBUG_WAKEREF
 	select DRM_I915_SW_FENCE_DEBUG_OBJECTS
 	select DRM_I915_SELFTEST
 	default n
@@ -243,3 +244,16 @@ config DRM_I915_DEBUG_RUNTIME_PM
 	  Recommended for driver developers only.
 
 	  If in doubt, say "N"
+
+config DRM_I915_DEBUG_WAKEREF
+	bool "Enable extra tracking for wakerefs"
+	depends on DRM_I915
+	select REF_TRACKER
+	select STACKDEPOT
+	select STACKTRACE
+	help
+	  Choose this option to turn on extra state checking and usage
+	  tracking for the wakerefPM functionality. This may introduce
+	  overhead during driver runtime.
+
+	  If in doubt, say "N"
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 3aeede6aee4dcc..33a034a9c42f11 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -253,6 +253,7 @@ struct i915_execbuffer {
 	struct intel_gt *gt; /* gt for the execbuf */
 	struct intel_context *context; /* logical state for the request */
 	struct i915_gem_context *gem_context; /** caller's context */
+	intel_wakeref_t wakeref;
 
 	/** our requests to build */
 	struct i915_request *requests[MAX_ENGINE_INSTANCE + 1];
@@ -2709,7 +2710,7 @@ eb_select_engine(struct i915_execbuffer *eb)
 
 	for_each_child(ce, child)
 		intel_context_get(child);
-	intel_gt_pm_get(ce->engine->gt);
+	eb->wakeref = intel_gt_pm_get(ce->engine->gt);
 
 	if (!test_bit(CONTEXT_ALLOC_BIT, &ce->flags)) {
 		err = intel_context_alloc_state(ce);
@@ -2748,7 +2749,7 @@ eb_select_engine(struct i915_execbuffer *eb)
 	return err;
 
 err:
-	intel_gt_pm_put(ce->engine->gt);
+	intel_gt_pm_put(ce->engine->gt, eb->wakeref);
 	for_each_child(ce, child)
 		intel_context_put(child);
 	intel_context_put(ce);
@@ -2761,7 +2762,7 @@ eb_put_engine(struct i915_execbuffer *eb)
 	struct intel_context *child;
 
 	i915_vm_put(eb->context->vm);
-	intel_gt_pm_put(eb->gt);
+	intel_gt_pm_put(eb->context->engine->gt, eb->wakeref);
 	for_each_child(eb->context, child)
 		intel_context_put(child);
 	intel_context_put(eb->context);
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_coherency.c
index 3bef1beec7cbb5..3fd68a099a85ef 100644
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
index 56279908ed305b..f6f36a85688814 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -630,14 +630,14 @@ static bool assert_mmap_offset(struct drm_i915_private *i915,
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
 
@@ -778,6 +778,7 @@ static int igt_mmap_offset_exhaustion(void *arg)
 
 static int gtt_set(struct drm_i915_gem_object *obj)
 {
+	intel_wakeref_t wakeref;
 	struct i915_vma *vma;
 	void __iomem *map;
 	int err = 0;
@@ -786,7 +787,7 @@ static int gtt_set(struct drm_i915_gem_object *obj)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
 	if (IS_ERR(map)) {
@@ -798,12 +799,13 @@ static int gtt_set(struct drm_i915_gem_object *obj)
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
@@ -812,7 +814,7 @@ static int gtt_check(struct drm_i915_gem_object *obj)
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	intel_gt_pm_get(vma->vm->gt);
+	wakeref = intel_gt_pm_get(vma->vm->gt);
 	map = i915_vma_pin_iomap(vma);
 	i915_vma_unpin(vma);
 	if (IS_ERR(map)) {
@@ -828,7 +830,7 @@ static int gtt_check(struct drm_i915_gem_object *obj)
 	i915_vma_unpin_iomap(vma);
 
 out:
-	intel_gt_pm_put(vma->vm->gt);
+	intel_gt_pm_put(vma->vm->gt, wakeref);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index ecc990ec1b9526..d650beb8ed22f6 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -28,11 +28,14 @@ static void irq_disable(struct intel_breadcrumbs *b)
 
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
@@ -41,7 +44,7 @@ static void __intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 	 * which we can add a new waiter and avoid the cost of re-enabling
 	 * the irq.
 	 */
-	WRITE_ONCE(b->irq_armed, true);
+	WRITE_ONCE(b->irq_armed, wakeref);
 
 	/* Requests may have completed before we could enable the interrupt. */
 	if (!b->irq_enabled++ && b->irq_enable(b))
@@ -61,12 +64,14 @@ static void intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 
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
index 72dfd3748c4c33..bdf09fd67b6e70 100644
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
diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index 48f888c3da083b..582faa21181e58 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -212,7 +212,7 @@ static inline void intel_context_enter(struct intel_context *ce)
 		return;
 
 	ce->ops->enter(ce);
-	intel_gt_pm_get(ce->vm->gt);
+	ce->wakeref = intel_gt_pm_get(ce->vm->gt);
 }
 
 static inline void intel_context_mark_active(struct intel_context *ce)
@@ -229,7 +229,7 @@ static inline void intel_context_exit(struct intel_context *ce)
 	if (--ce->active_count)
 		return;
 
-	intel_gt_pm_put_async(ce->vm->gt);
+	intel_gt_pm_put_async(ce->vm->gt, ce->wakeref);
 	ce->ops->exit(ce);
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index e36670f2e6260b..5dc39a9d7a501c 100644
--- a/drivers/gpu/drm/i915/gt/intel_context_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_context_types.h
@@ -17,6 +17,7 @@
 #include "i915_utils.h"
 #include "intel_engine_types.h"
 #include "intel_sseu.h"
+#include "intel_wakeref.h"
 
 #include "uc/intel_guc_fwif.h"
 
@@ -110,6 +111,7 @@ struct intel_context {
 	u32 ring_size;
 	struct intel_ring *ring;
 	struct intel_timeline *timeline;
+	intel_wakeref_t wakeref;
 
 	unsigned long flags;
 #define CONTEXT_BARRIER_BIT		0
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index ee531a5c142c77..bb021d83d3f882 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -63,7 +63,7 @@ static int __engine_unpark(struct intel_wakeref *wf)
 
 	ENGINE_TRACE(engine, "\n");
 
-	intel_gt_pm_get(engine->gt);
+	engine->wakeref_track = intel_gt_pm_get(engine->gt);
 
 	/* Discard stale context state from across idling */
 	ce = engine->kernel_context;
@@ -122,6 +122,7 @@ __queue_and_release_pm(struct i915_request *rq,
 	 */
 	GEM_BUG_ON(rq->context->active_count != 1);
 	__intel_gt_pm_get(engine->gt);
+	rq->context->wakeref = intel_wakeref_track(&engine->gt->wakeref);
 
 	/*
 	 * We have to serialise all potential retirement paths with our
@@ -285,7 +286,7 @@ static int __engine_park(struct intel_wakeref *wf)
 		engine->park(engine);
 
 	/* While gt calls i915_vma_parked(), we have to break the lock cycle */
-	intel_gt_pm_put_async(engine->gt);
+	intel_gt_pm_put_async(engine->gt, engine->wakeref_track);
 	return 0;
 }
 
@@ -298,7 +299,7 @@ void intel_engine_init__pm(struct intel_engine_cs *engine)
 {
 	struct intel_runtime_pm *rpm = engine->uncore->rpm;
 
-	intel_wakeref_init(&engine->wakeref, rpm, &wf_ops);
+	intel_wakeref_init(&engine->wakeref, rpm, &wf_ops, engine->name);
 	intel_engine_init_heartbeat(engine);
 
 	intel_gsc_idle_msg_enable(engine);
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 960291f88fd6cf..f55b524e518035 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -433,7 +433,9 @@ struct intel_engine_cs {
 	unsigned long serial;
 
 	unsigned long wakeref_serial;
+	intel_wakeref_t wakeref_track;
 	struct intel_wakeref wakeref;
+
 	struct file *default_state;
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 750326434677f1..f7d674c3c6ee65 100644
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
index e02cb90723ae03..76378dd2873dfc 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.c
@@ -27,19 +27,20 @@
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
@@ -137,7 +138,7 @@ void intel_gt_pm_init_early(struct intel_gt *gt)
 	 * runtime_pm is per-device rather than per-tile, so this is still the
 	 * correct structure.
 	 */
-	intel_wakeref_init(&gt->wakeref, &gt->i915->runtime_pm, &wf_ops);
+	intel_wakeref_init(&gt->wakeref, &gt->i915->runtime_pm, &wf_ops, "GT");
 	seqcount_mutex_init(&gt->stats.lock, &gt->wakeref.mutex);
 }
 
@@ -220,6 +221,7 @@ int intel_gt_resume(struct intel_gt *gt)
 {
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err;
 
 	err = intel_gt_has_unrecoverable_error(gt);
@@ -236,7 +238,7 @@ int intel_gt_resume(struct intel_gt *gt)
 	 */
 	gt_sanitize(gt, true);
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 
 	intel_uncore_forcewake_get(gt->uncore, FORCEWAKE_ALL);
 	intel_rc6_sanitize(&gt->rc6);
@@ -279,7 +281,7 @@ int intel_gt_resume(struct intel_gt *gt)
 
 out_fw:
 	intel_uncore_forcewake_put(gt->uncore, FORCEWAKE_ALL);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 	return err;
 
 err_wedged:
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.h b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
index 6c9a4645236467..2ae5fbbede6ca8 100644
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
 
 /**
  * with_intel_gt_pm_if_awake - if GT is PM awake, get a reference to prevent
@@ -64,7 +84,7 @@ static inline void intel_gt_pm_might_put(struct intel_gt *gt)
  * @wf: pointer to a temporary wakeref.
  */
 #define with_intel_gt_pm_if_awake(gt, wf) \
-	for (wf = intel_gt_pm_get_if_awake(gt); wf; intel_gt_pm_put_async(gt), wf = 0)
+	for (wf = intel_gt_pm_get_if_awake(gt); wf; intel_gt_pm_put_async(gt, wf), wf = 0)
 
 static inline int intel_gt_pm_wait_for_idle(struct intel_gt *gt)
 {
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
index 80dbbef86b1dbf..0960fae5a0b205 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c
@@ -27,7 +27,7 @@
 void intel_gt_pm_debugfs_forcewake_user_open(struct intel_gt *gt)
 {
 	atomic_inc(&gt->user_wakeref);
-	intel_gt_pm_get(gt);
+	intel_gt_pm_get_untracked(gt);
 	if (GRAPHICS_VER(gt->i915) >= 6)
 		intel_uncore_forcewake_user_get(gt->uncore);
 }
@@ -36,7 +36,7 @@ void intel_gt_pm_debugfs_forcewake_user_release(struct intel_gt *gt)
 {
 	if (GRAPHICS_VER(gt->i915) >= 6)
 		intel_uncore_forcewake_user_put(gt->uncore);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put_untracked(gt);
 	atomic_dec(&gt->user_wakeref);
 }
 
diff --git a/drivers/gpu/drm/i915/gt/selftest_engine_cs.c b/drivers/gpu/drm/i915/gt/selftest_engine_cs.c
index 542ce6d2de1922..f3d21bdfd7f639 100644
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
@@ -133,12 +135,13 @@ static int perf_mi_bb_start(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (GRAPHICS_VER(gt->i915) < 4) /* Any CS_TIMESTAMP? */
 		return 0;
 
-	perf_begin(gt);
+	wakeref = perf_begin(gt);
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce = engine->kernel_context;
 		struct i915_vma *batch;
@@ -207,7 +210,7 @@ static int perf_mi_bb_start(void *arg)
 		pr_info("%s: MI_BB_START cycles: %u\n",
 			engine->name, trifilter(cycles));
 	}
-	if (perf_end(gt))
+	if (perf_end(gt, wakeref))
 		err = -EIO;
 
 	return err;
@@ -260,12 +263,13 @@ static int perf_mi_noop(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (GRAPHICS_VER(gt->i915) < 4) /* Any CS_TIMESTAMP? */
 		return 0;
 
-	perf_begin(gt);
+	wakeref = perf_begin(gt);
 	for_each_engine(engine, gt, id) {
 		struct intel_context *ce = engine->kernel_context;
 		struct i915_vma *base, *nop;
@@ -364,7 +368,7 @@ static int perf_mi_noop(void *arg)
 		pr_info("%s: 16K MI_NOOP cycles: %u\n",
 			engine->name, trifilter(cycles));
 	}
-	if (perf_end(gt))
+	if (perf_end(gt, wakeref))
 		err = -EIO;
 
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
index 0971241707ce83..33351deeea4f0b 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -81,6 +81,7 @@ static int live_gt_clocks(void *arg)
 	struct intel_gt *gt = arg;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (!gt->clock_frequency) { /* unknown */
@@ -91,7 +92,7 @@ static int live_gt_clocks(void *arg)
 	if (GRAPHICS_VER(gt->i915) < 4) /* Any CS_TIMESTAMP? */
 		return 0;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	intel_uncore_forcewake_get(gt->uncore, FORCEWAKE_ALL);
 
 	for_each_engine(engine, gt, id) {
@@ -128,7 +129,7 @@ static int live_gt_clocks(void *arg)
 	}
 
 	intel_uncore_forcewake_put(gt->uncore, FORCEWAKE_ALL);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	return err;
 }
diff --git a/drivers/gpu/drm/i915/gt/selftest_reset.c b/drivers/gpu/drm/i915/gt/selftest_reset.c
index a9e0a91bc0e026..ab464cd72b8c39 100644
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
index fb30f733b03665..dcef8d49891972 100644
--- a/drivers/gpu/drm/i915/gt/selftest_rps.c
+++ b/drivers/gpu/drm/i915/gt/selftest_rps.c
@@ -224,6 +224,7 @@ int live_rps_clock_interval(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	if (!intel_rps_is_enabled(rps) || GRAPHICS_VER(gt->i915) < 6)
@@ -236,7 +237,7 @@ int live_rps_clock_interval(void *arg)
 	saved_work = rps->work.func;
 	rps->work.func = dummy_rps_work;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	intel_rps_disable(&gt->rps);
 
 	intel_gt_check_clock_frequency(gt);
@@ -355,7 +356,7 @@ int live_rps_clock_interval(void *arg)
 	}
 
 	intel_rps_enable(&gt->rps);
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	igt_spinner_fini(&spin);
 
@@ -376,6 +377,7 @@ int live_rps_control(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	int err = 0;
 
 	/*
@@ -398,7 +400,7 @@ int live_rps_control(void *arg)
 	saved_work = rps->work.func;
 	rps->work.func = dummy_rps_work;
 
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	for_each_engine(engine, gt, id) {
 		struct i915_request *rq;
 		ktime_t min_dt, max_dt;
@@ -488,7 +490,7 @@ int live_rps_control(void *arg)
 			break;
 		}
 	}
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 
 	igt_spinner_fini(&spin);
 
@@ -1023,6 +1025,7 @@ int live_rps_interrupt(void *arg)
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
 	struct igt_spinner spin;
+	intel_wakeref_t wakeref;
 	u32 pm_events;
 	int err = 0;
 
@@ -1033,9 +1036,9 @@ int live_rps_interrupt(void *arg)
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
index bd44ce73a5044e..81fa891eac19fc 100644
--- a/drivers/gpu/drm/i915/gt/selftest_slpc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_slpc.c
@@ -241,6 +241,7 @@ static int run_test(struct intel_gt *gt, int test_type)
 	struct intel_rps *rps = &gt->rps;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	intel_wakeref_t wakeref;
 	struct igt_spinner spin;
 	u32 slpc_min_freq, slpc_max_freq;
 	int err = 0;
@@ -278,7 +279,7 @@ static int run_test(struct intel_gt *gt, int test_type)
 	}
 
 	intel_gt_pm_wait_for_idle(gt);
-	intel_gt_pm_get(gt);
+	wakeref = intel_gt_pm_get(gt);
 	for_each_engine(engine, gt, id) {
 		struct i915_request *rq;
 		u32 max_act_freq;
@@ -365,7 +366,7 @@ static int run_test(struct intel_gt *gt, int test_type)
 	if (igt_flush_test(gt->i915))
 		err = -EIO;
 
-	intel_gt_pm_put(gt);
+	intel_gt_pm_put(gt, wakeref);
 	igt_spinner_fini(&spin);
 	intel_gt_pm_wait_for_idle(gt);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fe390d59929b02..76d3dfbdf479b7 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1106,7 +1106,7 @@ static void scrub_guc_desc_for_outstanding_g2h(struct intel_guc *guc)
 			if (deregister)
 				guc_signal_context_fence(ce);
 			if (destroyed) {
-				intel_gt_pm_put_async(guc_to_gt(guc));
+				intel_gt_pm_put_async_untracked(guc_to_gt(guc));
 				release_guc_id(guc, ce);
 				__guc_context_destroy(ce);
 			}
@@ -1302,6 +1302,7 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 	unsigned long flags;
 	u32 reset_count;
 	bool in_reset;
+	intel_wakeref_t wakeref;
 
 	spin_lock_irqsave(&guc->timestamp.lock, flags);
 
@@ -1324,7 +1325,8 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 	 * start_gt_clk is derived from GuC state. To get a consistent
 	 * view of activity, we query the GuC state only if gt is awake.
 	 */
-	if (!in_reset && intel_gt_pm_get_if_awake(gt)) {
+	wakeref = in_reset ? 0 : intel_gt_pm_get_if_awake(gt);
+	if (wakeref) {
 		stats_saved = *stats;
 		gt_stamp_saved = guc->timestamp.gt_stamp;
 		/*
@@ -1333,7 +1335,7 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 		 */
 		guc_update_engine_gt_clks(engine);
 		guc_update_pm_timestamp(guc, now);
-		intel_gt_pm_put_async(gt);
+		intel_gt_pm_put_async(gt, wakeref);
 		if (i915_reset_count(gpu_error) != reset_count) {
 			*stats = stats_saved;
 			guc->timestamp.gt_stamp = gt_stamp_saved;
@@ -4604,7 +4606,7 @@ int intel_guc_deregister_done_process_msg(struct intel_guc *guc,
 		intel_context_put(ce);
 	} else if (context_destroyed(ce)) {
 		/* Context has been destroyed */
-		intel_gt_pm_put_async(guc_to_gt(guc));
+		intel_gt_pm_put_async_untracked(guc_to_gt(guc));
 		release_guc_id(guc, ce);
 		__guc_context_destroy(ce);
 	}
diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 7ece883a7d9567..12d858e17902ec 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -167,19 +167,19 @@ static u64 get_rc6(struct intel_gt *gt)
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
@@ -372,12 +372,14 @@ frequency_sample(struct intel_gt *gt, unsigned int period_ns)
 	struct drm_i915_private *i915 = gt->i915;
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
@@ -406,7 +408,7 @@ frequency_sample(struct intel_gt *gt, unsigned int period_ns)
 				period_ns / 1000);
 	}
 
-	intel_gt_pm_put_async(gt);
+	intel_gt_pm_put_async(gt, wakeref);
 }
 
 static enum hrtimer_restart i915_sample(struct hrtimer *hrtimer)
diff --git a/drivers/gpu/drm/i915/intel_wakeref.c b/drivers/gpu/drm/i915/intel_wakeref.c
index 48c62fee1f4ede..957b25638b7a71 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.c
+++ b/drivers/gpu/drm/i915/intel_wakeref.c
@@ -96,7 +96,8 @@ static void __intel_wakeref_put_work(struct work_struct *wrk)
 void __intel_wakeref_init(struct intel_wakeref *wf,
 			  struct intel_runtime_pm *rpm,
 			  const struct intel_wakeref_ops *ops,
-			  struct intel_wakeref_lockclass *key)
+			  struct intel_wakeref_lockclass *key,
+			  const char *name)
 {
 	wf->rpm = rpm;
 	wf->ops = ops;
@@ -108,6 +109,10 @@ void __intel_wakeref_init(struct intel_wakeref *wf,
 	INIT_DELAYED_WORK(&wf->work, __intel_wakeref_put_work);
 	lockdep_init_map(&wf->work.work.lockdep_map,
 			 "wakeref.work", &key->work, 0);
+
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+	ref_tracker_dir_init(&wf->debug, INTEL_REFTRACK_DEAD_COUNT, name);
+#endif
 }
 
 int intel_wakeref_wait_for_idle(struct intel_wakeref *wf)
diff --git a/drivers/gpu/drm/i915/intel_wakeref.h b/drivers/gpu/drm/i915/intel_wakeref.h
index 439d8b172748ad..cd3fc88e4f657b 100644
--- a/drivers/gpu/drm/i915/intel_wakeref.h
+++ b/drivers/gpu/drm/i915/intel_wakeref.h
@@ -50,6 +50,10 @@ struct intel_wakeref {
 	const struct intel_wakeref_ops *ops;
 
 	struct delayed_work work;
+
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+	struct ref_tracker_dir debug;
+#endif
 };
 
 struct intel_wakeref_lockclass {
@@ -60,11 +64,12 @@ struct intel_wakeref_lockclass {
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
@@ -292,6 +297,33 @@ static inline void intel_ref_tracker_free(struct ref_tracker_dir *dir,
 void intel_ref_tracker_show(struct ref_tracker_dir *dir,
 			    struct drm_printer *p);
 
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_WAKEREF)
+
+static inline intel_wakeref_t intel_wakeref_track(struct intel_wakeref *wf)
+{
+	return intel_ref_tracker_alloc(&wf->debug);
+}
+
+static inline void intel_wakeref_untrack(struct intel_wakeref *wf,
+					 intel_wakeref_t handle)
+{
+	intel_ref_tracker_free(&wf->debug, handle);
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
+#endif
+
 struct intel_wakeref_auto {
 	struct intel_runtime_pm *rpm;
 	struct timer_list timer;

-- 
2.34.1
