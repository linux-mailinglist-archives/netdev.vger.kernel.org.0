Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83D16CC5E7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbjC1PTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjC1PSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:18:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957C111150;
        Tue, 28 Mar 2023 08:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680016649; x=1711552649;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LsmUDbnIlE4apXp83QZEhT9gpY1ZA5IO+nuheEoXvek=;
  b=JLNe9raE1O4kncgBgoGGGJ0HPYcaT7Jt2nQoWAAzzH91q8qQAnmm0FaA
   NGgEcy77VLTv3eJREywT3kgXU6CR+meieVUD7twFIapTESwFo4Gjn0fqi
   shsr9JzGGioV88v5UTnqCYKG4ITmgEJqRl0TGLZqgGBANagjr6G8W2ItL
   UaVSauPs/DTLLgLtatvWUW0BPHBidPHK2ipdkxiYvSNkzvlNMHFI1Cm4Q
   eqVTHTXZusUgWdyBVftBK6TZcwnjTxtYDrArJlEc0X0E8nSzHLjCait3h
   kh8FJBqqC5UNGGBGVzokTHkQMDU4CL/coJ/WBjsbMUjbaaZdRQNAu3HbT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403208773"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403208773"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:16:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="773181781"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="773181781"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:16:10 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Date:   Tue, 28 Mar 2023 17:15:31 +0200
Subject: [PATCH v5 8/8] drm/i915/gt: Hold a wakeref for the active VM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v5-8-77be86f2c872@intel.com>
References: <20230224-track_gt-v5-0-77be86f2c872@intel.com>
In-Reply-To: <20230224-track_gt-v5-0-77be86f2c872@intel.com>
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
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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
