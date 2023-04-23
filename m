Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077286EBD10
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 06:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDWEp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 00:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDWEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 00:45:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E971FCC;
        Sat, 22 Apr 2023 21:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682225156; x=1713761156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bdRNz+e+eYTIoxHI9aB0m86TKGuGAia3gtQEZ0ujnko=;
  b=SeRHsj6uWXmQhRNifajcf/Bk369QNGLBoEm7ZN2Y2sQXvDih7a/AfGe/
   SN4fGLSzzEqmLPqIdIwhpPQKiZ9OKH/3nluJ0cj8jbgW9fMOP9A0+NmVF
   hmsCj8XucUnaDvRdLzEUOye8zrwo/lC6jgpHsLGvDG/eDG5Y0hJNq2+Im
   yk+J8FQ96lUmBMcd9sp1kFgcR253WbMDSMM4/t4iqvjyKxI4ve4d+k75r
   4jEeqj+N4/LWu9QbErmIyUFiv6RnrN+/RkICcrJJrxq5eoFu0+PWmjfuF
   +2+IX0THdVpTXYNMehR1Hm+XDeOGKE3wAqh+31R3vtiBgr0z6k19988+N
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="411516553"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="411516553"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 21:45:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="836564075"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="836564075"
Received: from bjwdesw007.ccr.corp.intel.com (HELO [10.238.154.181]) ([10.238.154.181])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 21:45:52 -0700
Message-ID: <bc7374f0-4b1c-a632-4581-9e4da0a5090f@linux.intel.com>
Date:   Sun, 23 Apr 2023 12:45:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 6/7] drm/i915: Replace custom intel runtime_pm tracker
 with ref_tracker library
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
 <20230224-track_gt-v7-6-11f08358c1ec@intel.com>
From:   Zhou Furong <furong.zhou@linux.intel.com>
In-Reply-To: <20230224-track_gt-v7-6-11f08358c1ec@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> +
> +static inline void
> +intel_wakeref_tracker_show(struct ref_tracker_dir *dir,
> +			   struct drm_printer *p)
> +{
> +	const size_t buf_size = PAGE_SIZE;
> +	char *buf, *sb, *se;
> +	size_t count;
> +
> +	buf = kmalloc(buf_size, GFP_NOWAIT);
> +	if (!buf)
> +		return;
> +
> +	count = ref_tracker_dir_snprint(dir, buf, buf_size);
> +	if (!count)
> +		goto free;
> +	/* printk does not like big buffers, so we split it */
> +	for (sb = buf; *sb; sb = se + 1) {
> +		se = strchrnul(sb, '\n');
> +		drm_printf(p, "%.*s", (int)(se - sb + 1), sb);
> +		if (!*se)
> +			break;
> +	}
> +	if (count >= buf_size)
> +		drm_printf(p, "\n...dropped %zd extra bytes of leak report.\n",
> +			   count + 1 - buf_size);
> +free:
> +	kfree(buf);
> +}
> +

move to c source?

