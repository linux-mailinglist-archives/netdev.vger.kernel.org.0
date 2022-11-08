Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A706213E7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiKHNzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiKHNzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:55:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19CA11C26;
        Tue,  8 Nov 2022 05:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667915710; x=1699451710;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wqCXR7/ERUAjOK9nxMrBawOH3yYc7LEcy0Ov7c+meso=;
  b=CykA7ojHunXMW6rC6IvHy/+tiNsMNLwycaBagnTnsPr++4ZEAXBdccmD
   NdN3YUiAGex+NLVNTx1PbiVQafpsHKAugGfxOTu5m2FGDQ4q+EqdNSRa/
   j5oN3W7zABTXKUoXhYmx4+9vOtdFCjao7+w+Nt89OtB55xPhLJjVnzUOR
   Z2c86Pl4buUVJTqYpm9BQ+GEdiw74C3F6cS5YD6b3GSjbe9+4YmswbSv4
   Rben67TQ8fLXggWQnnykkupZZmDL+LbUOnMR2WLbAWgJv7KPjeQtfbbz1
   GwEs6adZ19DGiL21fqWhMk8UH84qf53WDAIJ/npiP0JcBxTx+9cGdXNLh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="372838877"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="372838877"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 05:55:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="636338828"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="636338828"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2022 05:55:08 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1osP4E-0099m6-1j;
        Tue, 08 Nov 2022 15:55:06 +0200
Date:   Tue, 8 Nov 2022 15:55:06 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Message-ID: <Y2pfuloLUBKZ1+IA@smile.fi.intel.com>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
 <Y0R+ZU6kdbeUER1c@lunn.ch>
 <Y0SAsQoD0/5oDlGX@smile.fi.intel.com>
 <Y0SEfZi9oewmefGK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0SEfZi9oewmefGK@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 10:45:49PM +0200, Andrew Lunn wrote:
> On Mon, Oct 10, 2022 at 11:29:37PM +0300, Andy Shevchenko wrote:
> > On Mon, Oct 10, 2022 at 10:19:49PM +0200, Andrew Lunn wrote:
> > > On Wed, Oct 05, 2022 at 07:43:01PM +0300, Andy Shevchenko wrote:
> > > > The strlen() may go too far when estimating the length of
> > > > the given string. In some cases it may go over the boundary
> > > > and crash the system which is the case according to the commit
> > > > 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> > > > 
> > > > Rectify this by switching to strnlen() for the expected
> > > > maximum length of the string.
> > > 
> > > This seems like something which should have a fixes: tag, and be
> > > against net, not net-next.
> > 
> > I can (re-)send it that way. Just need a consensus by net maintainers.
> 
> I would probably do:
> 
> 	if (strnlen(s, maxlen) != maxlen)
>  		return false;
> 
> I doubt anybody is removing leading zeros in MAC addresses.

I'm not sure what this change gives us. < maxlen is more readable to understand
that we refuse anything that less than maxlen, with your change it's easy to
misinterpret it (by missing 'n' in the non-standard call) as "it must equal to
maxlen" which is obviously not true.

That said, I leave it as is.

-- 
With Best Regards,
Andy Shevchenko


