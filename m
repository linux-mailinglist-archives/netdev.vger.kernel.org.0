Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DFD6BE8BB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjCQL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCQL6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:58:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D92FB79D0;
        Fri, 17 Mar 2023 04:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679054321; x=1710590321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sJw6ZvTiSBeJWWkSp+yJ3m9JmAmsP740tHkQ6iSYsCo=;
  b=ax4GZPevmFzbqPRF61nsCF5GHyyxAIT/uozgdfutBf3JN9oSqDZQAgKW
   0v8Uhz3alm5XiYBuqPU1VmTcutCAL8OiloYL1H8X0MLzL/oPd7yfAOsMs
   M+oT2qBH++2jeOf+qFEyuM/l5mEZvB2//ggfjTfsWTAJCRPQMA5/gdN0L
   0FLjwxNuf9uAvAR7i0qHuAiuUarQWZ6pWuoHYp+faU9QOKMe5Ep9MGSuJ
   umiN9t8XPY+QKsmlwp3ccf9cS6zgCrgZZ0PTbwnrd+2GVvZgsYd98P34u
   /HAmKCc/vYUpxev3zOwct6b46toWGHMqhHFoEx/daz+L3+23awu7ZAkSH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="340605715"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="340605715"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823648396"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="823648396"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.22.107]) ([10.213.22.107])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:58:36 -0700
Message-ID: <96586b9d-499b-930c-9d0b-edb2c1087fc9@intel.com>
Date:   Fri, 17 Mar 2023 12:58:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v4 00/10] drm/i915: use ref_tracker library
 for tracking wakerefs
Content-Language: en-US
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Gently ping on the series.

Regards
Andrzej

On 06.03.2023 17:31, Andrzej Hajda wrote:
> This is revived patchset improving ref_tracker library and converting
> i915 internal tracker to ref_tracker.
> The old thread ended without consensus about small kernel allocations,
> which are performed under spinlock.
> I have tried to solve the problem by splitting the calls, but it results
> in complicated API, so I went back to original solution.
> If there are better solutions I am glad to discuss them.
> Meanwhile I send original patchset with addressed remaining comments.
> 
> To: Jani Nikula <jani.nikula@linux.intel.com>
> To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> To: David Airlie <airlied@gmail.com>
> To: Daniel Vetter <daniel@ffwll.ch>
> Cc: linux-kernel@vger.kernel.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: netdev@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> 
> ---
> Changes in v4:
> - split "Separate wakeref tracking" to smaller parts
> - fixed typos,
> - Link to v1-v3: https://patchwork.freedesktop.org/series/100327/
> 
> ---
> Andrzej Hajda (7):
>        lib/ref_tracker: add unlocked leak print helper
>        lib/ref_tracker: __ref_tracker_dir_print improve printing
>        lib/ref_tracker: add printing to memory buffer
>        lib/ref_tracker: remove warnings in case of allocation failure
>        drm/i915: Separate wakeref tracking types from rpm
>        drm/i915: Correct type of wakeref variable
>        drm/i915: replace Intel internal tracker with kernel core ref_tracker
> 
> Chris Wilson (3):
>        drm/i915: Separate wakeref tracking
>        drm/i915: Track leaked gt->wakerefs
>        drm/i915/gt: Hold a wakeref for the active VM
> 
>   drivers/gpu/drm/i915/Kconfig.debug                 |  19 ++
>   drivers/gpu/drm/i915/Makefile                      |   1 +
>   drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
>   drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
>   .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
>   drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
>   drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
>   drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
>   drivers/gpu/drm/i915/gt/intel_context.h            |  15 +-
>   drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
>   drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  10 +-
>   drivers/gpu/drm/i915/gt/intel_engine_types.h       |   2 +
>   .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +-
>   drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  12 +-
>   drivers/gpu/drm/i915/gt/intel_gt_pm.h              |  38 +++-
>   drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |   4 +-
>   drivers/gpu/drm/i915/gt/selftest_engine_cs.c       |  20 +-
>   drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   5 +-
>   drivers/gpu/drm/i915/gt/selftest_reset.c           |  10 +-
>   drivers/gpu/drm/i915/gt/selftest_rps.c             |  17 +-
>   drivers/gpu/drm/i915/gt/selftest_slpc.c            |   5 +-
>   drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  11 +-
>   drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
>   drivers/gpu/drm/i915/i915_pmu.c                    |  16 +-
>   drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
>   drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
>   drivers/gpu/drm/i915/intel_wakeref.c               |   7 +-
>   drivers/gpu/drm/i915/intel_wakeref.h               | 112 ++++++++++-
>   include/linux/ref_tracker.h                        |  31 ++-
>   lib/ref_tracker.c                                  | 179 ++++++++++++++---
>   30 files changed, 469 insertions(+), 332 deletions(-)
> ---
> base-commit: 1ddc2effff762c6a109af52f3c39534c7115aebe
> change-id: 20230224-track_gt-1b3da8bdacd7
> 
> Best regards,

