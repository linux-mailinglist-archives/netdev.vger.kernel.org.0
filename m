Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFE627A51
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiKNKTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiKNKTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:19:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99AE5F90;
        Mon, 14 Nov 2022 02:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668421177; x=1699957177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KcbCz+Nkr/BeXhgReuHAK11MwVuA/5RoWL91hSAe1P8=;
  b=URzcqmRixvZ+zo5OQfKo8p9Q4s9nXuvOVUSthuULPzThz8hcC1ohv8As
   wtmApyZCzjJpZfRiGJ092wmtBS1lwX0GvOq95iXlBJXG+6OL45TvPmrd9
   c7araRNSLsIre7Ra6FJ7kvH8WXWuUMQRsxgUPg0QVhXG0wwJWArp+t3SY
   o2OxZj90uaoRcUYi+7bXeCsFoO7ks0OVlvmRDtwTKVIPCl7ru4UQkBxXm
   t9BuBVb69J3N2szv7YHDbf9wWbF17qicmh3dyhvYbvXM7E+4EcfuvqpVH
   9GA9yD+F5/rLvPvOqtKHkSuOzLDlZwKQGVr7yotEyUshR/bT2U7wBTtcl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="309560808"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="309560808"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 02:19:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="589314455"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="589314455"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2022 02:19:32 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ouWYr-00C7Kz-1G;
        Mon, 14 Nov 2022 12:19:29 +0200
Date:   Mon, 14 Nov 2022 12:19:29 +0200
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
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y3IWMe5nGePMAEFv@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
 <Y1+NHVS5ZJLFTBke@google.com>
 <Y1/qisszTjUL9ngU@smile.fi.intel.com>
 <Y2pmqBXYq3WQa97u@smile.fi.intel.com>
 <Y3IUTUr/MXf9RQEP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3IUTUr/MXf9RQEP@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 10:11:25AM +0000, Lee Jones wrote:
> On Tue, 08 Nov 2022, Andy Shevchenko wrote:
> > On Mon, Oct 31, 2022 at 05:32:26PM +0200, Andy Shevchenko wrote:
> > > On Mon, Oct 31, 2022 at 08:53:49AM +0000, Lee Jones wrote:
> > > > On Tue, 25 Oct 2022, Andy Shevchenko wrote:
> > > > 
> > > > > On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > > > > > There are several users of LED framework that reimplement the
> > > > > > functionality of led_init_default_state_get(). In order to
> > > > > > deduplicate them move the declaration to the global header
> > > > > > (patch 2) and convert users (patche 3-11).
> > > > > 
> > > > > Dear LED maintainers, is there any news on this series? It's hanging around
> > > > > for almost 2 months now...
> > > > 
> > > > My offer still stands if help is required.
> > > 
> > > From my point of view the LED subsystem is quite laggish lately (as shown by
> > > this patch series, for instance), which means that _in practice_ the help is
> > > needed, but I haven't got if we have any administrative agreement on that.
> > > 
> > > Pavel?
> > 
> > So, Pavel seems quite unresponsive lately... Shall we just move on and take
> > maintainership?
> 
> I had an off-line conversation with Greg who advised me against that.

OK. What the reasonable option we have then?

-- 
With Best Regards,
Andy Shevchenko


