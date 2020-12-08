Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6321C2D1F0B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgLHAfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:35:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:61000 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgLHAfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:35:17 -0500
IronPort-SDR: ueegUsXtT03ex31T47y/NZ4TZqY4AjPC4ljPb19q109WAfEfo22bYLbMoudK7GfaOogpEIz0wI
 haIb9/ldUoKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="173917891"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="173917891"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 16:34:36 -0800
IronPort-SDR: 8dfOMyU6MT4zFO9br4ELZ2frdwyYSd5SfCP0Vffv+gMKu6hNU9/rbsGdTdsc7Rh6t5/A4isCyx
 dO97w7wHDNvA==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="317459820"
Received: from seherahx-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.17.196])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 16:34:33 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v1 0/9] ethtool: Add support for frame preemption
In-Reply-To: <20201207231230.3avhe6yqklsbxsiz@skbuf>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201205095021.36e1a24d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87o8j5z0xs.fsf@intel.com> <20201207231230.3avhe6yqklsbxsiz@skbuf>
Date:   Mon, 07 Dec 2020 16:34:32 -0800
Message-ID: <874kkxyw2v.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Mon, Dec 07, 2020 at 02:49:35PM -0800, Vinicius Costa Gomes wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>>
>> > On Tue,  1 Dec 2020 20:53:16 -0800 Vinicius Costa Gomes wrote:
>> >> $ tc qdisc replace dev $IFACE parent root handle 100 taprio \
>> >>       num_tc 3 \
>> >>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>> >>       queues 1@0 1@1 2@2 \
>> >>       base-time $BASE_TIME \
>> >>       sched-entry S 0f 10000000 \
>> >>       preempt 1110 \
>> >>       flags 0x2
>> >>
>> >> The "preempt" parameter is the only difference, it configures which
>> >> queues are marked as preemptible, in this example, queue 0 is marked
>> >> as "not preemptible", so it is express, the rest of the four queues
>> >> are preemptible.
>> >
>> > Does it make more sense for the individual queues to be preemptible
>> > or not, or is it better controlled at traffic class level?
>> > I was looking at patch 2, and 32 queues isn't that many these days..
>> > We either need a larger type there or configure this based on classes.
>>
>> I can set more future proof sizes for expressing the queues, sure, but
>> the issue, I think, is that frame preemption has dimishing returns with
>> link speed: at 2.5G the latency improvements are on the order of single
>> digit microseconds. At greater speeds the improvements are even less
>> noticeable.
>
> You could look at it another way.
> You can enable jumbo frames in your network, and your latency-sensitive
> traffic would not suffer as long as the jumbo frames are preemptible.
>

Speaking of jumbo frame, that's something that the standards are
missing, TSN features + jumbo frames will leave a lot of stuff up to the
implementation.

>> The only adapters that I see that support frame preemtion have 8 queues
>> or less.
>>
>> The idea of configuring frame preemption based on classes is
>> interesting. I will play with it, and see how it looks.
>
> I admit I never understood why you insist on configuring TSN offloads
> per hardware queue and not per traffic class.

So, I am sorry that I wasn't able to fully understand what you were
saying, then.

I always thought that you were thinking more that the driver was
responsible of making the 'traffic class to queue' translation than the
configuration interface for frame preemption to the user (taprio,
mqprio, etc) should be in terms of traffic classes, instead of queues.

My bad.


Cheers,
-- 
Vinicius
