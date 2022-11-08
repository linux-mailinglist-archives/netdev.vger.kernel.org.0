Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7A621645
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiKHO0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiKHO0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:26:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE235C765;
        Tue,  8 Nov 2022 06:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667917489; x=1699453489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SkQVJcDZAagONBPRjE0wTg4gud81SvHRy4ZcfIKi2yU=;
  b=aL7vUTeiKCNNx6y7kvHYTX0D+aQguOVfM93x0zgY+6mSrnSWlC0ILq/P
   b+gzZOkfDs052qhhg/bFLEF4BblJoy+z0qgOer+yEyeHZmoe2bSR7BNYl
   YcMCVMjr4UIujtnO2qo5jrqy6jcU0bBqEeZwOyjSLZHMhf9P8NUkObwdG
   hPQR6XPHsxKxvQet4AEd9Lh2rXTLFlbKWEPyGxHv9wgg/Rzq3PHp4/pvj
   3PY/LZrFrSeEYqcrpx0+47KVsP3LgnC/FGWNvNN2fHLq5/t4iEuvrXrAh
   39RPe/10rZUn8QZrDEAAEwH+edp1z5HjFKupe/mhK1hN5uynhoMtd6mJp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="298219735"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="298219735"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 06:24:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630884179"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="630884179"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2022 06:24:43 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1osPWq-009ANu-2m;
        Tue, 08 Nov 2022 16:24:40 +0200
Date:   Tue, 8 Nov 2022 16:24:40 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Lee Jones <lee@kernel.org>
Cc:     Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y2pmqBXYq3WQa97u@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
 <Y1+NHVS5ZJLFTBke@google.com>
 <Y1/qisszTjUL9ngU@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1/qisszTjUL9ngU@smile.fi.intel.com>
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

On Mon, Oct 31, 2022 at 05:32:26PM +0200, Andy Shevchenko wrote:
> On Mon, Oct 31, 2022 at 08:53:49AM +0000, Lee Jones wrote:
> > On Tue, 25 Oct 2022, Andy Shevchenko wrote:
> > 
> > > On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > > > There are several users of LED framework that reimplement the
> > > > functionality of led_init_default_state_get(). In order to
> > > > deduplicate them move the declaration to the global header
> > > > (patch 2) and convert users (patche 3-11).
> > > 
> > > Dear LED maintainers, is there any news on this series? It's hanging around
> > > for almost 2 months now...
> > 
> > My offer still stands if help is required.
> 
> From my point of view the LED subsystem is quite laggish lately (as shown by
> this patch series, for instance), which means that _in practice_ the help is
> needed, but I haven't got if we have any administrative agreement on that.
> 
> Pavel?

So, Pavel seems quite unresponsive lately... Shall we just move on and take
maintainership?

-- 
With Best Regards,
Andy Shevchenko


