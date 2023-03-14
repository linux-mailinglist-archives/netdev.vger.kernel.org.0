Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2746B9084
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCNKsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCNKsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:48:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17F14E84;
        Tue, 14 Mar 2023 03:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678790857; x=1710326857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aTQ8ccldvC8fVbY8dRmL+Ao/2Xx1BDNTgJMlqZjVPiQ=;
  b=OD9NmBD+ZlouAulvjT9GQ6LqDbpzF7c2mpCYRxBjJCNfUgieEDaQfX0u
   xCsdZqfYsw/yMSqObBdpFC7fdrqnOmIpJVR0mHLIeec+fU2ooWRucqujK
   WrTQ6wG9C9mjygtnA3N01aF5HESSGGP8JO6SgtZtnS2oaht59tok4pOU6
   vctV8LFC8meOkBuFeU69jBRR6aoEGovM1hG+qJKsEOpOv/td+Y8hFB9Jz
   7YmlEOoRXq0mLckkOiUP/7fNXrz2f83EdR6wOeASmFwZ/my2f7aJ6RTGU
   ntaVq1tG4MbUBXgqej8DI/oyyED69FmRzuHvHVMXNpCwD7NXgfDmapR+A
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="336082417"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="336082417"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 03:47:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="743266858"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="743266858"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 14 Mar 2023 03:47:05 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pc2BM-003AXU-1A;
        Tue, 14 Mar 2023 12:47:04 +0200
Date:   Tue, 14 Mar 2023 12:47:03 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Tianfei Zhang <tianfei.zhang@intel.com>, netdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, ilpo.jarvinen@linux.intel.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:49:53AM -0700, Richard Cochran wrote:
> On Sun, Mar 12, 2023 at 11:02:39PM -0400, Tianfei Zhang wrote:

...

> > +	dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);
> > +	if (IS_ERR(dt->ptp_clock))
> > +		return dev_err_probe(dt->dev, PTR_ERR(dt->ptp_clock),
> > +				     "Unable to register PTP clock\n");
> 
> Need to handle NULL as well...
> 
> /**
>  * ptp_clock_register() - register a PTP hardware clock driver
>  *
>  * @info:   Structure describing the new clock.
>  * @parent: Pointer to the parent device of the new clock.
>  *
>  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>  * support is missing at the configuration level, this function
>  * returns NULL, and drivers are expected to gracefully handle that
>  * case separately.
>  */

I'm wondering why.

The semantics of the above is similar to gpiod_get_optional() and since NULL
is a valid return in such cases, the PTP has to handle this transparently to
the user. Otherwise it's badly designed API which has to be fixed.

TL;DR: If I'm mistaken, I would like to know why.

-- 
With Best Regards,
Andy Shevchenko


