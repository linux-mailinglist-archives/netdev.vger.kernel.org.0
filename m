Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E695FA645
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJJUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJJUaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:30:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB660A469;
        Mon, 10 Oct 2022 13:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665433781; x=1696969781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pj1tfEUCE/wJH4QG9Wqos5hm0JlIhucQm+V+ho/BGWU=;
  b=FB4xj1SNUzpr9ddA2IEhruOiNK/aOaowmkfXZ1bkVP82M17XJ47rBMB2
   OAHSje80C4HSV4IZCk7oz/ixkTGeMxfAcIqlkjyLRLu2pRJsIDaTXugQU
   F1vszebuBs8lxAYgpNvoYfAhZN4oAwJujB+jBUc8QUxVWVzy1srJZgLZ9
   R20ewZ+lk2HY6QkWtpm9HMJkfVrrFgA58CASBnRKS2xcERmw4KR5S3fTb
   HPd2DmzeLpseXCYsXb4i1mVQ33pPZO1/Q4JhfruR/NLcz9REuCqVZ+Abg
   nGmu0j11amalJArBMsSmLN8h9j8ZkY5ulYukbzExZdjVImwHxmpJ7HDQx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="305952274"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="305952274"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 13:29:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="768534240"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="768534240"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2022 13:29:39 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ohzP7-00512U-1i;
        Mon, 10 Oct 2022 23:29:37 +0300
Date:   Mon, 10 Oct 2022 23:29:37 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Message-ID: <Y0SAsQoD0/5oDlGX@smile.fi.intel.com>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
 <Y0R+ZU6kdbeUER1c@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0R+ZU6kdbeUER1c@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 10:19:49PM +0200, Andrew Lunn wrote:
> On Wed, Oct 05, 2022 at 07:43:01PM +0300, Andy Shevchenko wrote:
> > The strlen() may go too far when estimating the length of
> > the given string. In some cases it may go over the boundary
> > and crash the system which is the case according to the commit
> > 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> > 
> > Rectify this by switching to strnlen() for the expected
> > maximum length of the string.
> 
> This seems like something which should have a fixes: tag, and be
> against net, not net-next.

I can (re-)send it that way. Just need a consensus by net maintainers.

-- 
With Best Regards,
Andy Shevchenko


