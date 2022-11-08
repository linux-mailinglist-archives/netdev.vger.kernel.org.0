Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0FB621399
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiKHNwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiKHNvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:51:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A5E62398;
        Tue,  8 Nov 2022 05:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667915498; x=1699451498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p3XVuiiHhYj4CpYcd/oIbXMmkx4DNUaNvQifZc4324s=;
  b=LrHwvaIz2CjC7Ji7RH6yvKpqkXHu4A4wvbXFoHO13czbvx71zAmrTPQA
   wWv/YsryWjlDDMLS5ffpHhFiPZJIEXmaF+GXmDtLYIlwnkoIDxUqdxUjA
   xPiNN6vR8qR3UIWLfaDBwZ4988LOLQIVlHlX/hBTKq2e5yicoWRVrnWpE
   xIKcMWd2esua1a8TFjsyP/+6grh9EuVxw2BaJarkcNGGuoD+fFHewjvQv
   0XbpwNKceCXMY7V3P76G+zqdyaeohTRYm65LOJT5mYjjVzOPEnHyQ8iZe
   lG89eGy5WnfQ4gpCiKJMKurb5AM1rGflCjUtkmauqkzJkoIDRgZoB72jn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="298212296"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="298212296"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 05:51:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="638794697"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="638794697"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 08 Nov 2022 05:51:35 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1osP0n-0099gl-0Q;
        Tue, 08 Nov 2022 15:51:33 +0200
Date:   Tue, 8 Nov 2022 15:51:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Message-ID: <Y2pe5JqTbTykO5Qf@smile.fi.intel.com>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
 <Y0R+ZU6kdbeUER1c@lunn.ch>
 <20221010173809.5f863ea6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010173809.5f863ea6@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 05:38:09PM -0700, Jakub Kicinski wrote:
> On Mon, 10 Oct 2022 22:19:49 +0200 Andrew Lunn wrote:
> > On Wed, Oct 05, 2022 at 07:43:01PM +0300, Andy Shevchenko wrote:
> > > The strlen() may go too far when estimating the length of
> > > the given string. In some cases it may go over the boundary
> > > and crash the system which is the case according to the commit
> > > 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> > > 
> > > Rectify this by switching to strnlen() for the expected
> > > maximum length of the string.  
> > 
> > This seems like something which should have a fixes: tag, and be
> > against net, not net-next.
> 
> Quoting DaveM's revert mentioned in the commit message:
> 
>     First of all, the orion5x buffer is not NULL terminated.  mac_pton()
>     has no business operating on non-NULL terminated buffers because
>     only the caller can know that this is valid and in what manner it
>     is ok to parse this NULL'less buffer.
>     
>     Second of all, orion5x operates on an __iomem pointer, which cannot
>     be dereferenced using normal C pointer operations.  Accesses to
>     such areas much be performed with the proper iomem accessors.
> 
> So AFAICT only null-terminated strings are expected here, this patch
> does not fix any known issue. No need to put it in net (if it's needed
> at all).

So, what is the decision with this patch? Should I resend that with net-next
in the subject?

-- 
With Best Regards,
Andy Shevchenko


