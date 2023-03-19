Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7336C06AE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCSX55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCSX5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:57:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3D411174;
        Sun, 19 Mar 2023 16:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679270271; x=1710806271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cCOThqLAwvz6B3Yezxu3AYAlmA2tlUrgZZbWP+6UGtg=;
  b=ISyc8kLxgt2poqFHRzNSQvSmU0UfJOdUl4y/lApiE4EuKFxhmbxgiQEa
   zIx80ub7uigws0L3Fd2p/lC3XteTrVFPv3goDV9lun0AJS4xya9HfrwVT
   wBC5Hspj22XEWU/l+qTKI7smS4WMcDnpbz654P0su/RoZLZerGeZsC9DI
   zGybL4D6fJlyvTzBERDRmF6V0gOK3ZkToDjSOHJMD/bRip+HljGbT2YAE
   KGlGcHXLGV92OHwvFq+7314hgf5sYSTdsDPdF9WYbJgBX3VwoSD2RHwLK
   ptUc6wNt4lwdXOP0ndzCZcA80/3e0U47usjE/1S2xmUGmGxfc0J3EToRj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="336042700"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="336042700"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:57:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="630929739"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="630929739"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:57:46 -0700
Date:   Mon, 20 Mar 2023 00:57:20 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v4 06/10] drm/i915: Separate wakeref tracking
Message-ID: <ZBehYC0npr4nv4mw@ashyti-mobl2.lan>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-6-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v4-6-464e8ab4c9ab@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Mon, Mar 06, 2023 at 05:32:02PM +0100, Andrzej Hajda wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> Extract the callstack tracking of intel_runtime_pm.c into its own
> utility so that that we can reuse it for other online debugging of
> scoped wakerefs.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> ---
>  drivers/gpu/drm/i915/Kconfig.debug           |   9 ++
>  drivers/gpu/drm/i915/Makefile                |   4 +
>  drivers/gpu/drm/i915/intel_runtime_pm.c      | 222 +++----------------------
>  drivers/gpu/drm/i915/intel_wakeref.h         |   2 +-
>  drivers/gpu/drm/i915/intel_wakeref_tracker.c | 234 +++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_wakeref_tracker.h |  52 ++++++
>  6 files changed, 319 insertions(+), 204 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
> index 93dfb7ed970547..5fde52107e3b44 100644
> --- a/drivers/gpu/drm/i915/Kconfig.debug
> +++ b/drivers/gpu/drm/i915/Kconfig.debug
> @@ -25,6 +25,7 @@ config DRM_I915_DEBUG
>  	select PREEMPT_COUNT
>  	select I2C_CHARDEV
>  	select STACKDEPOT
> +	select STACKTRACE
>  	select DRM_DP_AUX_CHARDEV
>  	select X86_MSR # used by igt/pm_rpm
>  	select DRM_VGEM # used by igt/prime_vgem (dmabuf interop checks)
> @@ -37,6 +38,7 @@ config DRM_I915_DEBUG
>  	select DRM_I915_DEBUG_GEM
>  	select DRM_I915_DEBUG_GEM_ONCE
>  	select DRM_I915_DEBUG_MMIO
> +	select DRM_I915_TRACK_WAKEREF
>  	select DRM_I915_DEBUG_RUNTIME_PM
>  	select DRM_I915_SW_FENCE_DEBUG_OBJECTS
>  	select DRM_I915_SELFTEST
> @@ -227,11 +229,18 @@ config DRM_I915_DEBUG_VBLANK_EVADE
>  
>  	  If in doubt, say "N".
>  
> +config DRM_I915_TRACK_WAKEREF
> +	depends on STACKDEPOT
> +	depends on STACKTRACE
> +	bool
> +
>  config DRM_I915_DEBUG_RUNTIME_PM
>  	bool "Enable extra state checking for runtime PM"
>  	depends on DRM_I915
>  	default n
>  	select STACKDEPOT
> +	select STACKTRACE
> +	select DRM_I915_TRACK_WAKEREF
>  	help
>  	  Choose this option to turn on extra state checking for the
>  	  runtime PM functionality. This may introduce overhead during
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index b2f91a1f826858..42daff6d575a82 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -81,6 +81,10 @@ i915-$(CONFIG_DEBUG_FS) += \
>  	i915_debugfs_params.o \
>  	display/intel_display_debugfs.o \
>  	display/intel_pipe_crc.o
> +
> +i915-$(CONFIG_DRM_I915_TRACK_WAKEREF) += \
> +	intel_wakeref_tracker.o
> +

This patch, along with the previous one and two following it, is
a bit confusing. We add this file only to remove it later and
the code hops from file to file. There seem to be some extra
steps that could be avoided.

Is there room for simplification?

Thanks,
Andi
