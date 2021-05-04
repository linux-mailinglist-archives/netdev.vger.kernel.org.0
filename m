Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA0D372BE4
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 16:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhEDOVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 10:21:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:8795 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhEDOVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 10:21:04 -0400
IronPort-SDR: Dl+3wmrQTGKQe1LSktxUyMlLjxVjrBAjRjgTlp4lf+7Hz/U36bQFiAl6QINunNaDc6f1k9wvso
 5CxQGuo7vbhQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="194850852"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="194850852"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 07:19:53 -0700
IronPort-SDR: qkkek3nBW/8NP07FnHrQYnmKgZfSSISUdWCRAkwIrf5d8HXsXJ2e3cGRvxkM0XktglkpQAVGCE
 lLuF3QqPa6Wg==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="406127072"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 07:19:49 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ldvtq-009YfE-5z; Tue, 04 May 2021 17:19:46 +0300
Date:   Tue, 4 May 2021 17:19:46 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Timo =?iso-8859-1?B?U2NobPzfbGVy?= <schluessler@krause.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Null pointer dereference in mcp251x driver when resuming from
 sleep
Message-ID: <YJFYAisb9xFUt15W@smile.fi.intel.com>
References: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
 <YI/+OP4z787Tmd05@smile.fi.intel.com>
 <YI//GqCv0nkvtQ54@smile.fi.intel.com>
 <YJAAn+H9nQl425QN@smile.fi.intel.com>
 <66f07d90-e459-325c-8d5d-9f255a0d8c8f@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f07d90-e459-325c-8d5d-9f255a0d8c8f@kontron.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 03:54:00PM +0200, Frieder Schrempf wrote:
> On 03.05.21 15:54, Andy Shevchenko wrote:
> > On Mon, May 03, 2021 at 04:48:10PM +0300, Andy Shevchenko wrote:
> > > On Mon, May 03, 2021 at 04:44:24PM +0300, Andy Shevchenko wrote:
> > > > On Mon, May 03, 2021 at 03:11:40PM +0200, Frieder Schrempf wrote:
> > > > > Hi,
> > > > > 
> > > > > with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference
> > > > > exception from the mcp251x driver when I resume from sleep (see trace
> > > > > below).
> > > > > 
> > > > > As far as I can tell this was working fine with 5.4. As I currently don't
> > > > > have the time to do further debugging/bisecting, for now I want to at least
> > > > > report this here.
> > > > > 
> > > > > Maybe there is someone around who could already give a wild guess for what
> > > > > might cause this just by looking at the trace/code!?
> > > > 
> > > > Does revert of c7299fea6769 ("spi: Fix spi device unregister flow") help?
> > > 
> > > Other than that, bisecting will take not more than 3-4 iterations only:
> > > % git log --oneline v5.4..v5.10.34 -- drivers/net/can/spi/mcp251x.c
> > > 3292c4fc9ce2 can: mcp251x: fix support for half duplex SPI host controllers
> > > e0e25001d088 can: mcp251x: add support for half duplex controllers
> > > 74fa565b63dc can: mcp251x: Use readx_poll_timeout() helper
> > > 2d52dabbef60 can: mcp251x: add GPIO support
> > > cfc24a0aa7a1 can: mcp251x: sort include files alphabetically
> > > df561f6688fe treewide: Use fallthrough pseudo-keyword
> > 
> > > 8ce8c0abcba3 can: mcp251x: only reset hardware as required
> > 
> > And only smoking gun by analyzing the code is the above. So, for the first I
> > would simply check before that commit and immediately after (15-30 minutes of
> > work). (I would do it myself if I had a hardware at hand...)
> 
> Thanks for pointing that out. Indeed when I revert this commit it works fine
> again.
> 
> When I look at the change I see that queue_work(priv->wq,
> &priv->restart_work) is called in two cases, when the interface is brought
> up after resume and now also when the device is only powered up after resume
> but the interface stays down.
> 
> The latter is a problem if the device was never brought up before, as the
> workqueue is only allocated and initialized in mcp251x_open().
> 
> To me it looks like a proper fix would be to just move the workqueue init to
> the probe function to make sure it is available when resuming even if the
> interface was never up before.
> 
> I will try this and send a patch if it looks good.

Sounds like a plan!

-- 
With Best Regards,
Andy Shevchenko


