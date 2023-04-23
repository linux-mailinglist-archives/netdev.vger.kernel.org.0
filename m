Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A896EBCBD
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDWDyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDWDyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:54:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5506E211C;
        Sat, 22 Apr 2023 20:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682222041; x=1713758041;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MujmvEf+jmoiPm2N89sMRbCh0pFkyHsT9w/vf8yBLUU=;
  b=TMPWtgx39VGpBUz61XyHg1dbjQ2txynEPzeembxqHcWDKAEjdfyiT2Vo
   mekPu+/C1yIceZn6Aq9FGtTL522BdTu5ZVbAtMSavpRyz91Et/rWNIYbn
   eUb8A9iChi3a5mGQ1ccHF+1Ns3p/CX/eR1PRJAixv21gDjPJDs/NvRJNx
   e1c9rvzHre5o3Mjw6M1Nzf8sREYmj+YlNhat6lXWHyp0YYP8wY+jiNUwI
   xNsDvvW28WqfB8KeztXpiHbX7XIxaI1ysb8HtzKpKEQD3b7oYU7V1LXkl
   CEYgMD3BfgMjFYO/27Pjx/LmiK1TAPug/ur5a/0KDisjDiCmNhntvLCFA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="330442442"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="330442442"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 20:54:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="836557787"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="836557787"
Received: from bjwdesw007.ccr.corp.intel.com (HELO [10.238.154.181]) ([10.238.154.181])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 20:53:56 -0700
Message-ID: <01575988-c041-d9f6-f507-994740b50876@linux.intel.com>
Date:   Sun, 23 Apr 2023 11:53:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 7/7] drm/i915: track gt pm wakerefs
Content-Language: en-US
To:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
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
        Andi Shyti <andi.shyti@linux.intel.com>
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
 <20230224-track_gt-v7-7-11f08358c1ec@intel.com>
From:   Zhou Furong <furong.zhou@linux.intel.com>
In-Reply-To: <20230224-track_gt-v7-7-11f08358c1ec@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If in doubt, say "N"
> +
> +config DRM_I915_DEBUG_WAKEREF
> +	bool "Enable extra tracking for wakerefs"
> +	depends on DRM_I915
> +	default n
'default n' is not need
