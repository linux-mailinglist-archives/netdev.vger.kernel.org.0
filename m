Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847EB672880
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 20:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjARTfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 14:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjARTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 14:35:06 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A425F39D;
        Wed, 18 Jan 2023 11:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674070415; x=1705606415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W+MjFX4jOPWTnLg8g2dW2U2dOR8hy/Gp2caHEbV0Gug=;
  b=ixwO88eTR2tzuOAePrjWH4d8LZBbFPwHSH9uzWHw9E/blppCFcPmHviJ
   7A6ybsUesdB4Y38sZ6tUNfseOYv8Ng4glI4o3h3qgpDHYwB+SMvMjMoYI
   M0XABk88HwBh1IMXzVDuRoBkpVWuB2dDCy0fnFmUS/zj5c+JBDYbG+HDQ
   DwnsKbKYGKD5gy/MSMhDC+FOy9fxhJKWE48DY3fP4TVHpKYGQWPfm2TAb
   JfMeYhAeSl3IpFWax759igHLMwYqa28fsii1LWKq0Q7KVi69OXpgluQee
   ZzPkjet3r9WLo1DXIV2m9ZdUtl3jmPbW3Xbnxym/V9RsT3+JvvZeDeVMW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323764360"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="323764360"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 11:33:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692134026"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="692134026"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 18 Jan 2023 11:33:32 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pIEBf-00BLFd-05;
        Wed, 18 Jan 2023 21:33:31 +0200
Date:   Wed, 18 Jan 2023 21:33:30 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v1 1/1] net: hns: Switch to use acpi_evaluate_dsm_typed()
Message-ID: <Y8hJiskzQeCgfW0u@smile.fi.intel.com>
References: <20230118092922.39426-1-andriy.shevchenko@linux.intel.com>
 <10538d3d-415e-7361-9038-e4ea70fc2640@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10538d3d-415e-7361-9038-e4ea70fc2640@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 10:15:11AM -0800, Tony Nguyen wrote:
> On 1/18/2023 1:29 AM, Andy Shevchenko wrote:
> > The acpi_evaluate_dsm_typed() provides a way to check the type of the
> > object evaluated by _DSM call. Use it instead of open coded variant.
> 
> LGTM
> 
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com

Thanks, but it needs a bit more work, I missed something.
So, I'll add tag into v2.

-- 
With Best Regards,
Andy Shevchenko


