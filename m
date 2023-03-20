Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967886C203C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCTSr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCTSrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:47:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD52AF21;
        Mon, 20 Mar 2023 11:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679337619; x=1710873619;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NVpb0s44A4CDvY38C/xGCzroKuG69A4v+lxaRmy7irg=;
  b=bGvBe4PiDvsrKSgrUj8XdoZYQWLVQ4CO22Vi/Phib0tF2Ktslzh+vLXQ
   cuSbeTzia86HFJ1f0jC1zVfWBwCyHx9x6mcf7uxnk5sBm9Un3lBsKOYuu
   e7ceP2R525fD4n88OhYad9n9P99EqGHe/uwjVG7qGphLIz2nWkcUSsjWN
   e5Qc331oz2sznKaif7fcDwxfmnXITLu8dP4zwcH7YSYMSyoCch2VAMmo3
   1CgS50lBo5IShmUBP9qBuZV6D/ox3myuc+iEKYFlsY2geaFSb8fRjbOb2
   meyTh1oWFLNmAJsGYXTjGXVkmypIXWZM9LT9PTRXXUVX+WlK16AzvkYkv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337463648"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="337463648"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 11:39:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="824605929"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="824605929"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.6.65]) ([10.213.6.65])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 11:39:25 -0700
Message-ID: <e0481f32-1245-f429-cebe-b6c55c613f80@intel.com>
Date:   Mon, 20 Mar 2023 19:39:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v4 06/10] drm/i915: Separate wakeref tracking
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>
Cc:     Chris Wilson <chris.p.wilson@intel.com>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-6-464e8ab4c9ab@intel.com>
 <ZBehYC0npr4nv4mw@ashyti-mobl2.lan>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ZBehYC0npr4nv4mw@ashyti-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.03.2023 00:57, Andi Shyti wrote:
> Hi Andrzej,
> 
> On Mon, Mar 06, 2023 at 05:32:02PM +0100, Andrzej Hajda wrote:
>> From: Chris Wilson <chris@chris-wilson.co.uk>
>>
>> Extract the callstack tracking of intel_runtime_pm.c into its own
>> utility so that that we can reuse it for other online debugging of
>> scoped wakerefs.
>>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> ---
>>   drivers/gpu/drm/i915/Kconfig.debug           |   9 ++
>>   drivers/gpu/drm/i915/Makefile                |   4 +
>>   drivers/gpu/drm/i915/intel_runtime_pm.c      | 222 +++----------------------
>>   drivers/gpu/drm/i915/intel_wakeref.h         |   2 +-
>>   drivers/gpu/drm/i915/intel_wakeref_tracker.c | 234 +++++++++++++++++++++++++++
>>   drivers/gpu/drm/i915/intel_wakeref_tracker.h |  52 ++++++
>>   6 files changed, 319 insertions(+), 204 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
>> index 93dfb7ed970547..5fde52107e3b44 100644
>> --- a/drivers/gpu/drm/i915/Kconfig.debug
>> +++ b/drivers/gpu/drm/i915/Kconfig.debug
>> @@ -25,6 +25,7 @@ config DRM_I915_DEBUG
>>   	select PREEMPT_COUNT
>>   	select I2C_CHARDEV
>>   	select STACKDEPOT
>> +	select STACKTRACE
>>   	select DRM_DP_AUX_CHARDEV
>>   	select X86_MSR # used by igt/pm_rpm
>>   	select DRM_VGEM # used by igt/prime_vgem (dmabuf interop checks)
>> @@ -37,6 +38,7 @@ config DRM_I915_DEBUG
>>   	select DRM_I915_DEBUG_GEM
>>   	select DRM_I915_DEBUG_GEM_ONCE
>>   	select DRM_I915_DEBUG_MMIO
>> +	select DRM_I915_TRACK_WAKEREF
>>   	select DRM_I915_DEBUG_RUNTIME_PM
>>   	select DRM_I915_SW_FENCE_DEBUG_OBJECTS
>>   	select DRM_I915_SELFTEST
>> @@ -227,11 +229,18 @@ config DRM_I915_DEBUG_VBLANK_EVADE
>>   
>>   	  If in doubt, say "N".
>>   
>> +config DRM_I915_TRACK_WAKEREF
>> +	depends on STACKDEPOT
>> +	depends on STACKTRACE
>> +	bool
>> +
>>   config DRM_I915_DEBUG_RUNTIME_PM
>>   	bool "Enable extra state checking for runtime PM"
>>   	depends on DRM_I915
>>   	default n
>>   	select STACKDEPOT
>> +	select STACKTRACE
>> +	select DRM_I915_TRACK_WAKEREF
>>   	help
>>   	  Choose this option to turn on extra state checking for the
>>   	  runtime PM functionality. This may introduce overhead during
>> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
>> index b2f91a1f826858..42daff6d575a82 100644
>> --- a/drivers/gpu/drm/i915/Makefile
>> +++ b/drivers/gpu/drm/i915/Makefile
>> @@ -81,6 +81,10 @@ i915-$(CONFIG_DEBUG_FS) += \
>>   	i915_debugfs_params.o \
>>   	display/intel_display_debugfs.o \
>>   	display/intel_pipe_crc.o
>> +
>> +i915-$(CONFIG_DRM_I915_TRACK_WAKEREF) += \
>> +	intel_wakeref_tracker.o
>> +
> 
> This patch, along with the previous one and two following it, is
> a bit confusing. We add this file only to remove it later and
> the code hops from file to file. There seem to be some extra
> steps that could be avoided.
> 
> Is there room for simplification?

The reason behind this was that i915 had it's own tracker integrated 
with i915_runtime_pm, then it was abstracted out (05,06) to allow track 
gt->wakerefs (07) and then I proposed replacement of internal tracker 
with ref_tracker (09). I wanted to keep original history of development.
I can squash all/some of this work, but I am afraid it will generate 
less readable patches - now we have separated abstract-out and replace 
steps.

Probably sending patches 05-08 1st, then proposing conversion to 
ref_tracker in another patchset would make it more clear.

Regards
Andrzej


> 
> Thanks,
> Andi

