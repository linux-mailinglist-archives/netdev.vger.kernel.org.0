Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2E699883
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBPPQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBPPQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:16:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC32F48E32;
        Thu, 16 Feb 2023 07:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676560582; x=1708096582;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hyvrL3VPiM3hBe27Vo+7YLaXTY2ZmoTK1UQfWn9rojw=;
  b=Crwo6lbsQ3nzD/dPh9DlsBMtw4SFwK/9HB1bBR2fQbwO1goeZ1vuXDZL
   a+m4aGSKljNeQ/YN8jZZXqXVC+SBqo6LIO00XLWNydsDA6rr8CcWVXEi3
   g++tAZH9+JCLyqKEfqkCFNlEk3c0IgSg990achUcYwZwpsFEGjk+UDCyZ
   mSvPzrh0v4xr4rRAQpXRiepwwdnQQYT4GVfPVeltOLnD2UX6CxWsbi3Cx
   zX8VaHaBVfPEB9V9mnouFab5P3wgqlIqNRQpJBV9h5QH+sRcOBy3MVPaP
   +9U9yr1SFBQA2GOQTJgtW1l60KC7ityvgvUx3rNYZIfqcvN9paZ4mIpxE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="312101385"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="312101385"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:16:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="663496371"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="663496371"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 16 Feb 2023 07:16:11 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pSfzT-007ppX-2j;
        Thu, 16 Feb 2023 17:16:07 +0200
Date:   Thu, 16 Feb 2023 17:16:07 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     Jonathan.Cameron@huawei.com, baohua@kernel.org, bristot@redhat.com,
        bsegall@google.com, davem@davemloft.net, dietmar.eggemann@arm.com,
        gal@nvidia.com, gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        ttoukan.linux@gmail.com, vincent.guittot@linaro.org,
        vschneid@redhat.com, yury.norov@gmail.com
Subject: Re: [PATCH v2 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+5It7zl66IoeKj3@smile.fi.intel.com>
References: <20230208153905.109912-1-pawel.chmielewski@intel.com>
 <20230216145455.661709-1-pawel.chmielewski@intel.com>
 <Y+5IWLpC1uTaa4Ks@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+5IWLpC1uTaa4Ks@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 05:14:33PM +0200, Andy Shevchenko wrote:
> On Thu, Feb 16, 2023 at 03:54:55PM +0100, Pawel Chmielewski wrote:

...

> > +		for_each_cpu_andnot(cpu, aff_mask, last_aff_mask) {
> > +			if (v_idx >= vsi->num_q_vectors)
> 
> > +				goto out;
> 
> Useless. You can return 0; here.
> 
> > +		}

Btw, I briefly checked the other functions nearby in the code and none of them
is using goto for OK cases.


-- 
With Best Regards,
Andy Shevchenko


