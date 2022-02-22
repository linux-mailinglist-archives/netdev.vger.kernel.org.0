Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB064BF27A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiBVHND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:13:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiBVHND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:13:03 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2666ECB01;
        Mon, 21 Feb 2022 23:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645513958; x=1677049958;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vL8DcslhcdCxYi49Fsi+vRBJ4qnH5U4WDLaK8eziX50=;
  b=Uv2jToA7uEo22fXxl5KSeTvNvJ6x8IM5xIfpliaL4yZIxER8BCTXE3hV
   LqaIxIYtsiRadt5uxqNLPJ5iFfzeaORsS7VlhsDdD4hb7YEVZ2+rzdJXb
   1uwVpqI8E7XWja1rZala9PIt1bBN8YSfBUpZT/bb3WWFjNvmTp2zc/qjM
   9Jv5HBJlASOzYKsPbtXDcmO6E3nUfJVbuN1ROeiR31086xE28NC5PuoY+
   bdervUk+UtyOw/ABBlTlYLKCZC5pfxeJjhvva+ZhbsC7FOBOywqZ+ikz9
   OpcClQhJA45lCroKyBvIvf/Culf6e7nYDn1sx0a8Ipr5f+Wb96WsIPBjs
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="231595695"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="231595695"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:12:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="547615525"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga008.jf.intel.com with SMTP; 21 Feb 2022 23:12:33 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 22 Feb 2022 09:12:32 +0200
Date:   Tue, 22 Feb 2022 09:12:32 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, netdev <netdev@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v3 08/11] drm/i915: Separate wakeref tracking
Message-ID: <YhSM4HFT7UpRYEIg@intel.com>
References: <20220221232542.1481315-1-andrzej.hajda@intel.com>
 <20220221232542.1481315-9-andrzej.hajda@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221232542.1481315-9-andrzej.hajda@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 12:25:39AM +0100, Andrzej Hajda wrote:
> -static noinline depot_stack_handle_t
> +static intel_wakeref_t
>  track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
>  {
> -	depot_stack_handle_t stack, *stacks;
> -	unsigned long flags;
> -
> -	if (rpm->no_wakeref_tracking)
> -		return -1;
> -
> -	stack = __save_depot_stack();
> -	if (!stack)
> +	if (!rpm->available)
>  		return -1;

Still not the same.

-- 
Ville Syrjälä
Intel
