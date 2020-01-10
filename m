Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F8137168
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgAJPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:36:06 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7641 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgAJPgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578670566; x=1610206566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SgZqy3XTPlr7N1P3ccJM4s/BqmaQ1P0z1Cl70TTTVVg=;
  b=NONlX9UG1D5DZuADMfoS9coLx+Va8a87a4NT1so3/7QqC5vI/PyRzPNQ
   7ajz471P2nPny8LQhrByUSqUjrp1HL822VVg3V7BtwWzvwDp5c1nwo9bc
   k4IInC5ZhdY1gTnQaZgwRznNqNzrb9aj9KtYO+XjxeanVG1pNvNHTld6s
   8=;
IronPort-SDR: vO0XLbMQgitppzP2QpWLx/9TWANK+p+D6rx2ItFgJb7JazVRZhu9IZvwDPQiY2YXRlIwTKxqQ2
 K0Gg7agBJwZQ==
X-IronPort-AV: E=Sophos;i="5.69,417,1571702400"; 
   d="scan'208";a="17985115"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Jan 2020 15:35:54 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 1C7D0A0716;
        Fri, 10 Jan 2020 15:35:45 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 15:35:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 15:35:21 +0000
Received: from localhost (10.85.220.176) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 10 Jan 2020 15:35:21 +0000
Date:   Fri, 10 Jan 2020 07:35:20 -0800
From:   Eduardo Valentin <eduval@amazon.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Anchal Agarwal <anchalag@amazon.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.co>, <roger.pau@citrix.com>, <axboe@kernel.dk>,
        <davem@davemloft.net>, <rjw@rjwysocki.net>, <len.brown@intel.com>,
        <pavel@ucw.cz>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200108105011.GY2827@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Peter,

On Wed, Jan 08, 2020 at 11:50:11AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 07, 2020 at 11:45:26PM +0000, Anchal Agarwal wrote:
> > From: Eduardo Valentin <eduval@amazon.com>
> > 
> > System instability are seen during resume from hibernation when system
> > is under heavy CPU load. This is due to the lack of update of sched
> > clock data, and the scheduler would then think that heavy CPU hog
> > tasks need more time in CPU, causing the system to freeze
> > during the unfreezing of tasks. For example, threaded irqs,
> > and kernel processes servicing network interface may be delayed
> > for several tens of seconds, causing the system to be unreachable.
> 
> > The fix for this situation is to mark the sched clock as unstable
> > as early as possible in the resume path, leaving it unstable
> > for the duration of the resume process. This will force the
> > scheduler to attempt to align the sched clock across CPUs using
> > the delta with time of day, updating sched clock data. In a post
> > hibernation event, we can then mark the sched clock as stable
> > again, avoiding unnecessary syncs with time of day on systems
> > in which TSC is reliable.
> 
> This makes no frigging sense what so bloody ever. If the clock is
> stable, we don't care about sched_clock_data. When it is stable you get
> a linear function of the TSC without complicated bits on.
> 
> When it is unstable, only then do we care about the sched_clock_data.
> 

Yeah, maybe what is not clear here is that we covering for situation
where clock stability changes over time, e.g. at regular boot clock is
stable, hibernation happens, then restore happens in a non-stable clock.

> > Reviewed-by: Erik Quanstrom <quanstro@amazon.com>
> > Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> > Reviewed-by: Balbir Singh <sblbir@amazon.com>
> > Reviewed-by: Munehisa Kamata <kamatam@amazon.com>
> > Tested-by: Anchal Agarwal <anchalag@amazon.com>
> > Signed-off-by: Eduardo Valentin <eduval@amazon.com>
> > ---
> 
> NAK, the code very much relies on never getting marked stable again
> after it gets set to unstable.
> 

Well actually, at the PM_POST_HIBERNATION, we do the check and set stable if
known to be stable.

The issue only really happens during the restoration path under scheduling pressure,
which takes forever to finish, as described in the commit.

Do you see a better solution for this issue?


> > diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> > index 1152259a4ca0..374d40e5b1a2 100644
> > --- a/kernel/sched/clock.c
> > +++ b/kernel/sched/clock.c
> > @@ -116,7 +116,7 @@ static void __scd_stamp(struct sched_clock_data *scd)
> >  	scd->tick_raw = sched_clock();
> >  }
> >  
> > -static void __set_sched_clock_stable(void)
> > +void set_sched_clock_stable(void)
> >  {
> >  	struct sched_clock_data *scd;
> >  
> > @@ -236,7 +236,7 @@ static int __init sched_clock_init_late(void)
> >  	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
> >  
> >  	if (__sched_clock_stable_early)
> > -		__set_sched_clock_stable();
> > +		set_sched_clock_stable();
> >  
> >  	return 0;
> >  }
> > -- 
> > 2.15.3.AMZN
> > 

-- 
All the best,
Eduardo Valentin
