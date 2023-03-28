Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF14D6CC5BC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjC1PR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjC1PRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:17:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B14D31E;
        Tue, 28 Mar 2023 08:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680016588; x=1711552588;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=8UzayBLRBQ8s0UpLIwh56xr9xEKmxU+0z/KLnW55M0o=;
  b=SumoGfX0YN/yDtlAOt0QcuhrvFdAtHKq27bKLO7Pu1BSb1JXfhDwB26i
   OOAb2TNtFsEjPX09mlE1H84+pFNU5o/7g4jESXldy8rQ+AEGRFyTThmia
   CrvbtrWonFivCclp+aITlV95K7etvlG+uCHTvq9sMYQsALCD04nDmEaEE
   EQHHqWzPBAxN7eeBorFfiu9PBLHaGmqITusPacFggtjRTBZBdkJyfo1tD
   FBTtQgGPBplSy4Br7HKuno5bqXWsX50jw9s98XuKkm0YmWQk5iHgyzsmA
   Rn+GUBK/JbaVtJRFC0wOCZqs6i1tTYQO+IIN+ohFbyBwEg11td0wIToOm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403208591"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403208591"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:15:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="773181732"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="773181732"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:15:43 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH v5 0/8] drm/i915: use ref_tracker library for tracking wakerefs
Date:   Tue, 28 Mar 2023 17:15:24 +0200
Message-Id: <20230224-track_gt-v5-0-77be86f2c872@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIwEI2QC/3WNQQ7CIBREr9KwFqUUq3XlPYwxH/htiZY2gETT9
 O5CVy50+SbzZmbi0Rn05FTMxGE03ow2wX5TENWD7ZAanZhwxivGuaDBgbrfukBLWWk4Sg1KH0iq
 S/BIpQOr+iw8Jx8cwrDTbqDBTLkyOWzNa327XBP3xofRvdfzWOb0x08sKaMp4qypW6VVfTY24GO
 rxoHkkSj+iSKJohZ4BClUA/JbXJblA8iW3In8AAAA
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
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

---
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

Chris Wilson (1):
      drm/i915/gt: Hold a wakeref for the active VM

 drivers/gpu/drm/i915/Kconfig.debug                 |  19 ++
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
 drivers/gpu/drm/i915/intel_wakeref.h               |  99 ++++++++-
 include/linux/ref_tracker.h                        |  31 ++-
 lib/ref_tracker.c                                  | 179 ++++++++++++++---
 29 files changed, 456 insertions(+), 331 deletions(-)
---
base-commit: c6137ecf40b2dc5bdf1ed8928122b700bfc91fea
change-id: 20230224-track_gt-1b3da8bdacd7

Best regards,
-- 
Andrzej Hajda <andrzej.hajda@intel.com>
