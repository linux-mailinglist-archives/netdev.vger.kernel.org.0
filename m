Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF52F4BA38A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiBQOsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242061AbiBQOsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:48:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE7A160FDE;
        Thu, 17 Feb 2022 06:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645109304; x=1676645304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/a6kPOmK1R4gkycE4EvBWHz/vCQFwiKnu48Rd4yVAA0=;
  b=jWvXhL/tYb5RneHsiRe+5oH5OXHrywj/8+8/8+dn8J4/zL7gdN0tlFMT
   wB/J1oROE8H67ZgfLknjFU6/8xGnaTCPhAL/Yov66tbzcTWP11i6SVuKQ
   Tc67vsgaGcOPVWzdDW6IMNqzmpv63XbgGgoLP6lOts8hpWmKLXe2pJU47
   4Wo0ggmJxfBZADNqfkj1j00tQGTocHoLQLU1G1+0xx9hVFYz8nJ1bwERQ
   x2msxu/jQrVQwZgFPUtvA1HayXhYw9pdFJLysytBSLxswxKbR/cugR+jm
   6wVFm/27Y2YeweFM8Qg01LZe4xdZaPcXVaqg+ow+8WQzVCFoKLkJuLCrC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="249722768"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="249722768"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 06:48:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="502480195"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga006.jf.intel.com with SMTP; 17 Feb 2022 06:48:06 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 17 Feb 2022 16:48:05 +0200
Date:   Thu, 17 Feb 2022 16:48:05 +0200
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
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Separate wakeref tracking
Message-ID: <Yg5gJfSJCCaY5JYs@intel.com>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-7-andrzej.hajda@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220217140441.1218045-7-andrzej.hajda@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 03:04:38PM +0100, Andrzej Hajda wrote:
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

no_wakeref_tracking != available

-- 
Ville Syrjälä
Intel
