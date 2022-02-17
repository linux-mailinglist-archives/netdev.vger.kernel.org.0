Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400024BA28D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241182AbiBQOFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:05:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiBQOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:05:13 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B0A24BF9;
        Thu, 17 Feb 2022 06:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645106697; x=1676642697;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=W9cusu0H41I9fgzaSsAcBFWP8L7H5DGUPWYmNsEav2c=;
  b=MPuVOH0Ldy3sxhLFb+rv8DmxD+NXBsSZha+aMAcBVlJYxqy1B/xTF+2i
   AGLzUSKaqitj4cgW15m5Jlm0hjvozxNwUkBW6u+85HO/necayUMTD08u9
   4r3/h+ZDLEYgxI3VD6bWKZRZCmD+QHmzyJnwSrG2YHTpcEEkbLJFOh9G8
   sYkCacrXFRS5wEmP8OlssWSPRaLHvQkhXPm7DkIUh7oBkrb3VxKRdWeQD
   hFAj8cRz/LtWY/qiNsSP/wdab5/6LMbRW6jAC5tR7oeRFigbC3V0mtSjm
   FL51EOIXyrAjWR8HGXEW16NC1zqe70DxynCzLEoGJL0zW8mx+I1v7tw2J
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="231501826"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="231501826"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:04:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="530241067"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:04:54 -0800
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 0/9] drm/i915: use ref_tracker library for tracking wakerefs
Date:   Thu, 17 Feb 2022 15:04:32 +0100
Message-Id: <20220217140441.1218045-1-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Added CC to netdev as the only user of the library atm.

Regards
Andrzej


Andrzej Hajda (7):
  lib/ref_tracker: add unlocked leak print helper
  lib/ref_tracker: compact stacktraces before printing
  lib/ref_tracker: __ref_tracker_dir_print improve printing
  lib/ref_tracker: add printing to memory buffer
  lib/ref_tracker: improve allocation flags
  drm/i915: Correct type of wakeref variable
  drm/i915: replace Intel internal tracker with kernel core ref_tracker

Chris Wilson (2):
  drm/i915: Separate wakeref tracking
  drm/i915: Track leaked gt->wakerefs

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
 include/linux/ref_tracker.h                   |  31 ++-
 lib/ref_tracker.c                             | 150 ++++++++---
 27 files changed, 429 insertions(+), 343 deletions(-)

-- 
2.25.1

