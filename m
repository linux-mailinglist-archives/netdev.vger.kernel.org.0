Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612D74BF4EB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiBVJpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiBVJpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:45:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358631587A0;
        Tue, 22 Feb 2022 01:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645523083; x=1677059083;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FjeZdgJyNM69LQtheHGzgcCWp87pZxz9Fy/QSUtonDM=;
  b=NckF2R0GYAgzYBSg+CEAMnQYK/eNP4sW0DAnjdMQniKLNZVxCaZo2zR9
   ZuR3Sr+FS9rvgFvX3H+Qfm7GYM/EwXk7Fb3RumDMKglSUyTnV5S0oBC8m
   eO9ThK25GhQ5uUOufy9mmm1C6pOfJ/cxCk02SSFpKc9j1WLB5AeglO9OX
   j4wIPo84jli77UJT7mgVEexbAlKaYrST8z6KQD2aTfUjjNFAxajrkTX7v
   5FMIsyeUwqjGA1u0wuGvKsJKJy/ltZPTKLRSH/bBinnvcYp2NqPirDi99
   xrIPJjiFrk7guH0pBrZHo/eQlnRGMYQaSr375SMcPhbEkcUxaUDQb4hIk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235193217"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="235193217"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 01:44:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="573374702"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga001.jf.intel.com with SMTP; 22 Feb 2022 01:44:38 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 22 Feb 2022 11:44:37 +0200
Date:   Tue, 22 Feb 2022 11:44:37 +0200
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
Message-ID: <YhSwhdr96qnka4yx@intel.com>
References: <20220221232542.1481315-1-andrzej.hajda@intel.com>
 <20220221232542.1481315-9-andrzej.hajda@intel.com>
 <YhSM4HFT7UpRYEIg@intel.com>
 <acc45712-b6c7-5cc8-920f-93f3db45413f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acc45712-b6c7-5cc8-920f-93f3db45413f@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:28:33AM +0100, Andrzej Hajda wrote:
> 
> 
> On 22.02.2022 08:12, Ville Syrjälä wrote:
> > On Tue, Feb 22, 2022 at 12:25:39AM +0100, Andrzej Hajda wrote:
> >> -static noinline depot_stack_handle_t
> >> +static intel_wakeref_t
> >>   track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
> >>   {
> >> -	depot_stack_handle_t stack, *stacks;
> >> -	unsigned long flags;
> >> -
> >> -	if (rpm->no_wakeref_tracking)
> >> -		return -1;
> >> -
> >> -	stack = __save_depot_stack();
> >> -	if (!stack)
> >> +	if (!rpm->available)
> >>   		return -1;
> > Still not the same.
> >
> 
> It was fixed but in wrong place - patch 11. I will move the change here.

Doesn't look correct there either.

-- 
Ville Syrjälä
Intel
