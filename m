Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408816C1323
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCTNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbjCTNUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:20:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A71A1557F;
        Mon, 20 Mar 2023 06:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679318435; x=1710854435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oN90B4Wwlc6EO5Gvxv2AQ4PXiZOHqHCIJDAcEaHPdek=;
  b=HtTAExmlsRCTyHtc2DT/0WdCkrX9qSrgZ2nC+QZil/8hU1y7beZVhO31
   cnmquvqRN70Lk1aYZQgogNEoNuo3o9R/AHrOVZb+W2WIHT/htALB8YKFe
   8sgbhYolntddh3k3KF41ykcjgp9gZDTbsSeGE/VyUWis6rkwhctbX2sRY
   46IkBlMtJYzBzM+0SU9ZlzqFJQ/ZhzUaWc26YWemaXRmUE1qZoQJ8FvHj
   JNxt36gKPrVUCsSzu7rHKZUuce0ihrA5tH6qMUGap/14R4SvD7E7e0neK
   TM84RPTahAuEyhD3JwZpM7sbpPkJtmo7s0AlPfjaB2eHyQESq2Yfqu1eZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="341016484"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="341016484"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 06:20:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="824470477"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="824470477"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001.fm.intel.com with ESMTP; 20 Mar 2023 06:20:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1peFR8-006HKX-0t;
        Mon, 20 Mar 2023 15:20:30 +0200
Date:   Mon, 20 Mar 2023 15:20:30 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
 <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 10:37:58AM -0400, Nicolas Pitre wrote:
> On Wed, 15 Mar 2023, Andy Shevchenko wrote:
> > On Tue, Mar 14, 2023 at 12:46:48PM -0700, Richard Cochran wrote:
> > > On Tue, Mar 14, 2023 at 12:47:03PM +0200, Andy Shevchenko wrote:
> > > > The semantics of the above is similar to gpiod_get_optional() and since NULL
> > > > is a valid return in such cases, the PTP has to handle this transparently to
> > > > the user. Otherwise it's badly designed API which has to be fixed.
> > > 
> > > Does it now?  Whatever.
> > > 
> > > > TL;DR: If I'm mistaken, I would like to know why.
> > > 
> > > git log.  git blame.
> > > 
> > > Get to know the tools of trade.
> > 
> > So, the culprit seems the commit d1cbfd771ce8 ("ptp_clock: Allow for it
> > to be optional") which did it half way.
> > 
> > Now I would like to know why the good idea got bad implementation.
> > 
> > Nicolas?
> 
> I'd be happy to help but as presented I simply don't know what you're 
> talking about. Please give me more context.

When your change introduced the optionality of the above mentioned API,
i.e. ptp_clock_register(), the function started returning NULL, which
is fine. What's not in my opinion is to ask individual drivers to handle it.
That said, if we take a look at gpiod_*_optional() or clk_*_optional()
we may notice that they handle NULL as a valid parameter (object) to their
respective APIs and individual drivers shouldn't take care about that.

Why PTP is so special?

-- 
With Best Regards,
Andy Shevchenko


