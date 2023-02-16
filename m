Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099C8699340
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjBPLhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjBPLhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:37:18 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C705E3E0BD;
        Thu, 16 Feb 2023 03:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676547426; x=1708083426;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ct/9bsJQQk5exOP6l0wQUmJkkT4cMwPrw9zcb2M1MRo=;
  b=GlFvpKp7OZOgrdsJy0rEU8Z8NpPaIr3dZ/61CRX4j/88bT/fKnscaYS7
   drFhpd5k3dTFaLRh9wl2uTO/UjtVBcbYtdIWLCRZQrHUFWnkzCHlfxT00
   zvC/PoIBzzlcR32kfYP6BAdV/xvW/vimQ9siH9bECjm8YX1mDOm7cbY0l
   k8YjOfSwmoqOhJ8ujaKYZJmX8AMBYu/nAly8vFE6gFJDrHfBNTG67GeK7
   LWeMFzCr7FYUHoWYB/SdFRI1fycwbdBjXwFKKEcgNhzsimsjZdRiiQ27N
   idEODBf6P5QWdqY91YzOJP2PmEqjAYz0M3PwZ070k6+n7p0r2ML6QSt/J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="330333141"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="330333141"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 03:37:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="733839766"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733839766"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 03:37:02 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pScZQ-007kQm-0f;
        Thu, 16 Feb 2023 13:37:00 +0200
Date:   Thu, 16 Feb 2023 13:36:59 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Chas Williams <3chas3@gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: atmel-mci: Convert to agnostic GPIO API
Message-ID: <Y+4VW71A0DxJsb9W@smile.fi.intel.com>
References: <20230215155410.80944-1-andriy.shevchenko@linux.intel.com>
 <20230215155410.80944-2-andriy.shevchenko@linux.intel.com>
 <CAPDyKFoghVAiyG4bko6AXrKeV5pqiXP48Sh8Mk8evwK2oayw7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFoghVAiyG4bko6AXrKeV5pqiXP48Sh8Mk8evwK2oayw7Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 12:09:46PM +0100, Ulf Hansson wrote:
> On Wed, 15 Feb 2023 at 16:53, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > The of_gpio.h is going to be removed. In preparation of that convert
> > the driver to the agnostic API.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> This is the third attempt to get this done, within this release cycle. :-)
> 
> Arnd's:
> https://lore.kernel.org/netdev/20230126135034.3320638-1-arnd@kernel.org/
> 
> Balamanikandan's:
> https://lore.kernel.org/all/20221226073908.17317-1-balamanikandan.gunasundar@microchip.com/
> 
> Actually, Balamanikandan's version was acked already in December by
> Linus Walleij and Ludovic, but I failed to apply it so I was
> requesting a rebase.
> 
> That said, I think we should give BalaBalamanikandan some more time
> for a re-spin (unless someone is willing to help him out in this
> regard), as it's getting late for v6.3 anyway.

I see, thanks for heads up!

I believe there is still room for improvement in his series (I briefly looked
at it). Let's wait for v4 which I would like to review.

-- 
With Best Regards,
Andy Shevchenko


