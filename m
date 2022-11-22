Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48930633DDA
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiKVNi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiKVNiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:38:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F0E59874;
        Tue, 22 Nov 2022 05:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669124334; x=1700660334;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=++lP3KudX1Bg9p4n7EIiOiN/6GstJqa2TC078+e0FNM=;
  b=IFOVHr1gDoiJgoyyVP2631VGble6XGm0kVZZ4WHU/0sGIrKzT3cHFYYM
   4BwSpqyKBev6ewCzRyDwXP1RdynCVmI2Rb6LR/MqLtmij7GcG+TpEH0eY
   c4ds38xWRAg3uVSbTYXJAmwWGj5IMQRfrTUq+iERvGEHUAlN11EyCbT46
   /1tn3t49X9w0IHd5DURhGEQRIcENdmidxl1DK4jNprOlK5ac8icYN5Msk
   68Ciw8GxNhhx1tGgotX7Guea4RX9aLKzi00koASDWlYPtDx4HkKpgZVjD
   uQWtUKj98R+KoMVEEIEZh2fdJdLtMhs49A1xIH89aO57g1/h3Ek8capQ5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378072259"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="378072259"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 05:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="674349310"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="674349310"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2022 05:38:48 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oxTU5-00Fqhm-2v;
        Tue, 22 Nov 2022 15:38:45 +0200
Date:   Tue, 22 Nov 2022 15:38:45 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee@kernel.org>, Gene Chen <gene_chen@richtek.com>,
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
Message-ID: <Y3zQ5ZtAU4NL3hG4@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
 <Y1+NHVS5ZJLFTBke@google.com>
 <Y1/qisszTjUL9ngU@smile.fi.intel.com>
 <Y2pmqBXYq3WQa97u@smile.fi.intel.com>
 <Y3IUTUr/MXf9RQEP@google.com>
 <Y3IWMe5nGePMAEFv@smile.fi.intel.com>
 <Y3IbW5/yTWE7z0cO@kroah.com>
 <Y3Iq7tuSveejlVEU@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Iq7tuSveejlVEU@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:47:58PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 14, 2022 at 11:41:31AM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Nov 14, 2022 at 12:19:29PM +0200, Andy Shevchenko wrote:
> > > On Mon, Nov 14, 2022 at 10:11:25AM +0000, Lee Jones wrote:
> > > > On Tue, 08 Nov 2022, Andy Shevchenko wrote:
> > > > > On Mon, Oct 31, 2022 at 05:32:26PM +0200, Andy Shevchenko wrote:
> > > > > > On Mon, Oct 31, 2022 at 08:53:49AM +0000, Lee Jones wrote:
> > > > > > > On Tue, 25 Oct 2022, Andy Shevchenko wrote:
> > > > > > > > On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > > > > > > > > There are several users of LED framework that reimplement the
> > > > > > > > > functionality of led_init_default_state_get(). In order to
> > > > > > > > > deduplicate them move the declaration to the global header
> > > > > > > > > (patch 2) and convert users (patche 3-11).
> > > > > > > > 
> > > > > > > > Dear LED maintainers, is there any news on this series? It's hanging around
> > > > > > > > for almost 2 months now...
> > > > > > > 
> > > > > > > My offer still stands if help is required.
> > > > > > 
> > > > > > From my point of view the LED subsystem is quite laggish lately (as shown by
> > > > > > this patch series, for instance), which means that _in practice_ the help is
> > > > > > needed, but I haven't got if we have any administrative agreement on that.
> > > > > > 
> > > > > > Pavel?
> > > > > 
> > > > > So, Pavel seems quite unresponsive lately... Shall we just move on and take
> > > > > maintainership?
> > > > 
> > > > I had an off-line conversation with Greg who advised me against that.
> > > 
> > > OK. What the reasonable option we have then?
> > 
> > I thought there is now a new LED maintainer, is that not working out?
> 
> No new (co-)maintainer due to stale mate situation as far as I can read it
> right now.

So, any suggestion on how to proceed here?

De facto we have no patch flow in LED subsystem and the queue is growing...

-- 
With Best Regards,
Andy Shevchenko


