Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983614BEE3F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 00:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiBUXRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:17:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiBUXRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:17:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD172458C;
        Mon, 21 Feb 2022 15:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645485438; x=1677021438;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5tyqff6dfNvC/ABbGwSMo3/Lpft1rAqd7sc+UvwZ8qE=;
  b=WRMNP8b3KxT4ggaHr+fYnCQWnXEHIDhklwMEMigRkrWKqWqGiiNdo6gG
   synaLA+5Fkrkx0BGqhQWYvprn90dSsKYSFH4HgsPGyu0I5woK7CHcf2my
   xQncwMHSTpjvxjdNA06YdhgW2/dyQSm8UFsN8QwALx/jSCmCInL306eDJ
   JlYdDVwfUUkYYFDboFTHVQDVZtzJYl7anbHAdIV292Jx4QBZFwjpef84+
   3kg/seeDtslU3gw1II401JIhXP5RdTc3oiFeHs9vHdaEFtTvNl67dRsSI
   F5/qdzI5ZYPJjMEF/H7d7kfYgLV6r6prp2GiSnNPf7IbQecPejarwquG3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251530337"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251530337"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="638694351"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:17:15 -0800
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
Subject: [PATCH v2 00/11] drm/i915: use ref_tracker library for tracking wakerefs
Date:   Tue, 22 Feb 2022 00:16:42 +0100
Message-Id: <20220221231705.1481059-1-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Appearance of ref_tracker library allows to drop custom solution for wakeref
tracking used in i915 and reuse the library.
For this few adjustements has been made to ref_tracker, details in patches.
I hope changes are OK for original author.

The patchset has been rebased on top of drm-tip to allow test changes by CI.
Patches marked "[DO NOT MERGE]" are cherry-picked from linux-next (they are
not yet in drm-tip), to allow build and run CI on the patchset (it works only
on drm-tip tree).

Added CC to netdev as the only user of the library atm.

v2:
  - replaced list_sort with ref_tracker_dir_stats, to avoid potentially
    extensive sorting, if number of reports is expected to be big enough (???)
    we can replace linear search in ref_tracker_dir_stats.stacks with binary
    heap (min_heap),
  - refactored gfp flags,
  - fixed i915 handling of no-tracking flag.

Regards
Andrzej


Andrzej Hajda (6):
  lib/ref_tracker: add unlocked leak print helper
  lib/ref_tracker: __ref_tracker_dir_print improve printing
  lib/ref_tracker: add printing to memory buffer
  lib/ref_tracker: remove warnings in case of allocation failure
  drm/i915: Correct type of wakeref variable
  drm/i915: replace Intel internal tracker with kernel core ref_tracker

Chris Wilson (2):
  drm/i915: Separate wakeref tracking
  drm/i915: Track leaked gt->wakerefs

Eric Dumazet (3):
  [DO NOT MERGE] ref_tracker: implement use-after-free detection
  [DO NOT MERGE] ref_tracker: add a count of untracked references
  [DO NOT MERGE] ref_tracker: remove filter_irq_stacks() call

 drivers/gpu/drm/i915/Kconfig.debug            |  19 ++
 drivers/gpu/drm/i915/Makefile                 |   1 +
 .../drm/i915/display/intel_display_power.c    |   2 +-
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    |   7 +-
 .../i915/gem/selftests/i915_gem_coherency.c   |  10 +-
 .../drm/i915/gem/selftests/i915_gem_mman.c    |  14 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c   |  13 +-
 .../gpu/drm/i915/gt/intel_breadcrumbs_types.h |   3 +-
 drivers/gpu/drm/i915/gt/intel_engine_pm.c     |   6 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |   2 +
 .../drm/i915/gt/intel_execlists_submission.c  |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.c         |  12 +-
 drivers/gpu/drm/i915/gt/intel_gt_pm.h         |  36 ++-
 drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c |   4 +-
 drivers/gpu/drm/i915/gt/selftest_engine_cs.c  |  20 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c      |   5 +-
 drivers/gpu/drm/i915/gt/selftest_reset.c      |  10 +-
 drivers/gpu/drm/i915/gt/selftest_rps.c        |  17 +-
 drivers/gpu/drm/i915/gt/selftest_slpc.c       |  10 +-
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  11 +-
 drivers/gpu/drm/i915/i915_pmu.c               |  16 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c       | 239 ++----------------
 drivers/gpu/drm/i915/intel_runtime_pm.h       |  10 +-
 drivers/gpu/drm/i915/intel_wakeref.c          |  10 +-
 drivers/gpu/drm/i915/intel_wakeref.h          | 112 +++++++-
 include/linux/ref_tracker.h                   |  35 ++-
 lib/ref_tracker.c                             | 198 ++++++++++++---
 27 files changed, 480 insertions(+), 344 deletions(-)

-- 
2.25.1

