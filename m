Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC36AC813
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCFQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCFQeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:34:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F683C642;
        Mon,  6 Mar 2023 08:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678120420; x=1709656420;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=tkVzW7sXUIGeU7LLrAVYS19oco2M/sPVMoMkRXsEHoE=;
  b=X4yCDwYm4V7dvzaPRJNP7PqdvFh06fqi7YewJSKmy8BVs32j7IwGmlVa
   rmb5jV7k7+XIxrDoZbEdMJH1aGopo+czj0j5bGSxrnHuYOISuHONQ2XGC
   68dXf9W4GNtCBXY4dLr4iu9fcwxJfSME0+N6Be9PURGgGOFeizzo30y++
   yFUNOdR931AuAWcJ8w+Ig9WHk4wWFRXzdCoX/DK9uLeop4qz3ukP9MwKG
   qsNZs2rtWyM0HMt5yERQ2PGH1qIymgV3jEINqLnQ2JyBVLYmQ4Is8s/Ew
   G5V5Cr+DSo4fzE624DM3WIVD9Jit8gKVLL0L3T3AidlLcFMMPX3i8Ql87
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315998543"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="315998543"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="745132781"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="745132781"
Received: from lab-ah.igk.intel.com ([10.102.42.211])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:32:19 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH v4 00/10] drm/i915: use ref_tracker library for tracking wakerefs
Date:   Mon, 06 Mar 2023 17:31:57 +0100
Message-Id: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH0VBmQC/22Nyw6CMBBFf4XM2ppSCD5W/ochpJ0OMFGLmTZEQ
 /h3C2uX5z5yFogkTBGuxQJCM0eeQob6UACONgyk2GcGo02ljalVEouPbkiqdJW3Z+ct+hPkubOR
 lBMbcNwOQn23b0m29p2ZP7vo3mYeOaZJvrt3Lrf0j2IulVY5MvrS9OixuXFI9Dzi9IJ2XdcfMfY
 9gr4AAAA=
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

This is revived patchset improving ref_tracker library and converting
i915 internal tracker to ref_tracker.
The old thread ended without consensus about small kernel allocations,
which are performed under spinlock.
I have tried to solve the problem by splitting the calls, but it results
in complicated API, so I went back to original solution.
If there are better solutions I am glad to discuss them.
Meanwhile I send original patchset with addressed remaining comments.

To: Jani Nikula <jani.nikula@linux.intel.com>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: David Airlie <airlied@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

---
Changes in v4:
- split "Separate wakeref tracking" to smaller parts
- fixed typos,
- Link to v1-v3: https://patchwork.freedesktop.org/series/100327/

---
Andrzej Hajda (7):
      lib/ref_tracker: add unlocked leak print helper
      lib/ref_tracker: __ref_tracker_dir_print improve printing
      lib/ref_tracker: add printing to memory buffer
      lib/ref_tracker: remove warnings in case of allocation failure
      drm/i915: Separate wakeref tracking types from rpm
      drm/i915: Correct type of wakeref variable
      drm/i915: replace Intel internal tracker with kernel core ref_tracker

Chris Wilson (3):
      drm/i915: Separate wakeref tracking
      drm/i915: Track leaked gt->wakerefs
      drm/i915/gt: Hold a wakeref for the active VM

 drivers/gpu/drm/i915/Kconfig.debug                 |  19 ++
 drivers/gpu/drm/i915/Makefile                      |   1 +
 drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
 .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
 drivers/gpu/drm/i915/gt/intel_context.h            |  15 +-
 drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
 drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  10 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |   2 +
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  12 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.h              |  38 +++-
 drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |   4 +-
 drivers/gpu/drm/i915/gt/selftest_engine_cs.c       |  20 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   5 +-
 drivers/gpu/drm/i915/gt/selftest_reset.c           |  10 +-
 drivers/gpu/drm/i915/gt/selftest_rps.c             |  17 +-
 drivers/gpu/drm/i915/gt/selftest_slpc.c            |   5 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  11 +-
 drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |  16 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
 drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
 drivers/gpu/drm/i915/intel_wakeref.c               |   7 +-
 drivers/gpu/drm/i915/intel_wakeref.h               | 112 ++++++++++-
 include/linux/ref_tracker.h                        |  31 ++-
 lib/ref_tracker.c                                  | 179 ++++++++++++++---
 30 files changed, 469 insertions(+), 332 deletions(-)
---
base-commit: 1ddc2effff762c6a109af52f3c39534c7115aebe
change-id: 20230224-track_gt-1b3da8bdacd7

Best regards,
-- 
Andrzej Hajda <andrzej.hajda@intel.com>
