Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF26A6EA92F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjDULfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDULfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:35:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBEE44A5;
        Fri, 21 Apr 2023 04:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682076919; x=1713612919;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=GhMRXRBkzeuO+c7mlyEN6y0EkdAtOsHoEGqibR6xLw8=;
  b=WI0aOSf4ynMWSYzRvaUfbb1RD0/qwF4ulSjbag4ylXoyzVckbkdsvk9S
   ZMlY5LQY3Bh1yOy0neuy8JHqvJVN5d0dFyQDOSglkMN+F3YIYNgPao9eo
   o44FjG6V9/ByD6prWXbM3ccQN0PxVr+im0A9BPRcM1qI3lhTMvw0rFzFd
   d1T69fpOLHFqHt/RZWh8hp47xDi/pz/9haL7OpKwPeEUqFJLmKLcuI4YZ
   O71Jvn4lg7hUsWSjb5FbDUpZLv9/oxRdvImML2DHJaTpnhFPP8S/5QWnh
   StNuuaM2npBlIWAGpZAI/hZOkyjInOkpNr834aFl2ivNSTimzhTYMvzeS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432249829"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="432249829"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 04:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="642489632"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642489632"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 04:35:14 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH v7 0/7] drm/i915: use ref_tracker library for tracking wakerefs
Date:   Fri, 21 Apr 2023 13:35:04 +0200
Message-Id: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOh0QmQC/3XOTW4DIQwF4KtErEvKEAKkq96jqiJjTAa18yOgo
 1bR3D2QVRR1ls/y5+cry5QiZfa2u7JES8xxGmswLzuGPYwX4tHXzKSQByGl4iUBfp0vhXfu4ME6
 D+gNq+sOMnGXYMS+gZ85l0QwvPo08BLntjInCvH33vbxWXMfc5nS37186dr0n56l44LXkRQnHdC
 jfo9joe89TgNrRxa1BVWFSiuy4BSewD3D4xY8VmiMI6uDRGvkM9RbULdXPVotuuCFDI9wXdcbyV
 qVIm4BAAA=
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

Gently ping for network developers, could you look at ref_tracker patches,
as the ref_tracker library was developed for network.

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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Das, Nirmoy <nirmoy.das@linux.intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

---
Changes in v7:
- removed 8th patch (hold wakeref), as it was already merged
- added tags (thx Andi)
- Link to v6: https://lore.kernel.org/r/20230224-track_gt-v6-0-0dc8601fd02f@intel.com

Changes in v6:
- rebased to solve minor conflict and allow CI testing
- Link to v5: https://lore.kernel.org/r/20230224-track_gt-v5-0-77be86f2c872@intel.com

Changes in v5 (thx Andi for review):
- use *_locked convention instead of __*,
- improved commit messages,
- re-worked i915 patches, squashed separation and conversion patches,
- added tags,
- Link to v4: https://lore.kernel.org/r/20230224-track_gt-v4-0-464e8ab4c9ab@intel.com

Changes in v4:
- split "Separate wakeref tracking" to smaller parts
- fixed typos,
- Link to v1-v3: https://patchwork.freedesktop.org/series/100327/

---
Andrzej Hajda (7):
      lib/ref_tracker: add unlocked leak print helper
      lib/ref_tracker: improve printing stats
      lib/ref_tracker: add printing to memory buffer
      lib/ref_tracker: remove warnings in case of allocation failure
      drm/i915: Correct type of wakeref variable
      drm/i915: Replace custom intel runtime_pm tracker with ref_tracker library
      drm/i915: track gt pm wakerefs

 drivers/gpu/drm/i915/Kconfig.debug                 |  19 ++
 drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
 .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
 drivers/gpu/drm/i915/gt/intel_context.h            |   4 +-
 drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
 drivers/gpu/drm/i915/gt/intel_engine_pm.c          |   7 +-
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
 drivers/gpu/drm/i915/intel_wakeref.h               |  99 ++++++++-
 include/linux/ref_tracker.h                        |  31 ++-
 lib/ref_tracker.c                                  | 179 ++++++++++++++---
 29 files changed, 444 insertions(+), 329 deletions(-)
---
base-commit: d224485cc77189981322356d4ca6b8c42f7bf9fa
change-id: 20230224-track_gt-1b3da8bdacd7

Best regards,
-- 
Andrzej Hajda <andrzej.hajda@intel.com>
