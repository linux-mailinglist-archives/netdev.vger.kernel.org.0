Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9E6AC84F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCFQit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjCFQhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:37:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF4C42BD9;
        Mon,  6 Mar 2023 08:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678120602; x=1709656602;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LsmUDbnIlE4apXp83QZEhT9gpY1ZA5IO+nuheEoXvek=;
  b=PcrD/sqqTEyvOKUDunGOcoByU6aNznkbkjW34w8PVdJNBg/0wLgY3FbC
   mLb5hYNe5r/g3LKQttxuvaMzAX1OcXw2VIYqWSNlTa8BTF0qDTTMynI23
   eyyMQ9QWFPDk8AY4MeqSMgRM/21SAzHw4LEsZnPWHn2o0/hZaSu1D7i7/
   8qAT1vBLyNtiof0BeAafy/HE0V6+th4AGdOu2ZgZUTepsfHRaNXuy+492
   d3xb48GbIB5Nssy2TebW2g/lGZGJbj3UeG+M1cJnuqHk9CHlqJ2MzGIRx
   pZigTV6rQ4dp7VUpaAgiOuuQ/SM7Xh2UzI1759Mj5wqQ/U8RAtIw+WZsg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315998873"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="315998873"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="745133009"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="745133009"
Received: from lab-ah.igk.intel.com ([10.102.42.211])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:53 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Mon, 06 Mar 2023 17:32:06 +0100
Subject: [PATCH v4 10/10] drm/i915/gt: Hold a wakeref for the active VM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v4-10-464e8ab4c9ab@intel.com>
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

From: Chris Wilson <chris@chris-wilson.co.uk>

There may be a disconnect between the GT used by the engine and the GT
used for the VM, requiring us to hold a wakeref on both while the GPU is
active with this request.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_context.h       | 15 +++++++++++----
 drivers/gpu/drm/i915/gt/intel_context_types.h |  2 ++
 drivers/gpu/drm/i915/gt/intel_engine_pm.c     |  4 ++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index 0a8d553da3f439..582faa21181e58 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -14,6 +14,7 @@
 #include "i915_drv.h"
 #include "intel_context_types.h"
 #include "intel_engine_types.h"
+#include "intel_gt_pm.h"
 #include "intel_ring_types.h"
 #include "intel_timeline_types.h"
 #include "i915_trace.h"
@@ -207,8 +208,11 @@ void intel_context_exit_engine(struct intel_context *ce);
 static inline void intel_context_enter(struct intel_context *ce)
 {
 	lockdep_assert_held(&ce->timeline->mutex);
-	if (!ce->active_count++)
-		ce->ops->enter(ce);
+	if (ce->active_count++)
+		return;
+
+	ce->ops->enter(ce);
+	ce->wakeref = intel_gt_pm_get(ce->vm->gt);
 }
 
 static inline void intel_context_mark_active(struct intel_context *ce)
@@ -222,8 +226,11 @@ static inline void intel_context_exit(struct intel_context *ce)
 {
 	lockdep_assert_held(&ce->timeline->mutex);
 	GEM_BUG_ON(!ce->active_count);
-	if (!--ce->active_count)
-		ce->ops->exit(ce);
+	if (--ce->active_count)
+		return;
+
+	intel_gt_pm_put_async(ce->vm->gt, ce->wakeref);
+	ce->ops->exit(ce);
 }
 
 static inline struct intel_context *intel_context_get(struct intel_context *ce)
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
index 7063dea2112943..c2d17c97bfe989 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -114,6 +114,10 @@ __queue_and_release_pm(struct i915_request *rq,
 
 	ENGINE_TRACE(engine, "parking\n");
 
+	GEM_BUG_ON(rq->context->active_count != 1);
+	__intel_gt_pm_get(engine->gt);
+	rq->context->wakeref = intel_wakeref_track(&engine->gt->wakeref);
+
 	/*
 	 * We have to serialise all potential retirement paths with our
 	 * submission, as we don't want to underflow either the

-- 
2.34.1
