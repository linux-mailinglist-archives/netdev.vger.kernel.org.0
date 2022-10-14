Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D1D5FEC33
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiJNKAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJNKAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:00:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5634D63F3F;
        Fri, 14 Oct 2022 03:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665741623; x=1697277623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yU691PK0LSDKQcnMRYmi3y8VrAcQvxQtXyiByydYRCI=;
  b=fnDX6KhJdiEHlqb54CTo5z/5p2CbzeTN91APcjAIThrkfvrlqwSSvWKk
   ITnQ0HxdzmcJgBQUEmuGrRrC+aovXewu9W1J2Cmra7KJbUoEgJ/hfMToG
   fvTAQ52eHGrNFMpB5CTdWuAyf2fBbgxZ1JaA/l7dme8TUmVgYGlWigaqi
   0Q4pUlwzW0bGORD01AaugeCDc2hJ/mpfyteX+DSXcyGEldVwkBxKp/l5E
   15grekbzCXT7V1nmSqA5/eLwBCubAFdGHu2A10oQBG9VCvfXxUP5HObr7
   bKy3FWXa7TxIF3AMY4AoIiO/R4zEY8FFs4Lh7FGpRBOSf2Rngi6kENCUv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="367360304"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="367360304"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 03:00:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="696251825"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="696251825"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP; 14 Oct 2022 03:00:13 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ojHUB-006sKC-0e;
        Fri, 14 Oct 2022 13:00:11 +0300
Date:   Fri, 14 Oct 2022 13:00:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     guoren@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 2/2] net: Fixup virtnet_set_affinity() cause cpumask
 warning
Message-ID: <Y0kzKgHO51LlqGkY@smile.fi.intel.com>
References: <20221014030459.3272206-1-guoren@kernel.org>
 <20221014030459.3272206-3-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014030459.3272206-3-guoren@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 11:04:59PM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> cause warning now 78e5a3399421 ("cpumask: fix checking valid
> cpu range").

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> Modules linked in:

Submitting Patches document suggests to cut this huge warning to only what
makes sense to see in the report.

-- 
With Best Regards,
Andy Shevchenko


