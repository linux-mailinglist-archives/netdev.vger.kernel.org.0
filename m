Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BC21C5EBA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgEERX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgEERX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:23:59 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F970206E6;
        Tue,  5 May 2020 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588699438;
        bh=t5A/U0Sexblxjhw78VzqUxtmAaJ6UZrXtrnGg9xfqJY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YqXQHuNgXTjYD+VUQZ1piM0t+2vFx9UxJIATSnJyiR6KvfoPfO7QZ185PJpgprYYg
         W8UkcvID46pXVGsh0B8y+quhYFQdQBEJxVSSueAQTbpJcIDdyY9r48IetpEMZCTgEt
         9Dr7ytNurWYNB5/D5uJsBivXoRT/uhYgiDz8tI70=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1AC9C3522F5F; Tue,  5 May 2020 10:23:58 -0700 (PDT)
Date:   Tue, 5 May 2020 10:23:58 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Message-ID: <20200505172358.GC2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200505161302.547-1-sjpark@amazon.com>
 <05843a3c-eb9d-3a0d-f992-7e4b97cc1f19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05843a3c-eb9d-3a0d-f992-7e4b97cc1f19@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 09:25:06AM -0700, Eric Dumazet wrote:
> 
> 
> On 5/5/20 9:13 AM, SeongJae Park wrote:
> > On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > 
> >> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> >>>
> >>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>
> >>>>
> >>>>
> >>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
> >>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> >>>>>
> >>>>
> >>>>>> Why do we have 10,000,000 objects around ? Could this be because of
> >>>>>> some RCU problem ?
> >>>>>
> >>>>> Mainly because of a long RCU grace period, as you guess.  I have no idea how
> >>>>> the grace period became so long in this case.
> >>>>>
> >>>>> As my test machine was a virtual machine instance, I guess RCU readers
> >>>>> preemption[1] like problem might affected this.
> >>>>>
> >>>>> [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf

If this is the root cause of the problem, then it will be necessary to
provide a hint to the hypervisor.  Or, in the near term, avoid loading
the hypervisor the point that vCPU preemption is so lengthy.

RCU could also provide some sort of pre-stall-warning notification that
some of the CPUs aren't passing through quiescent states, which might
allow the guest OS's userspace to take corrective action.

But first, what are you doing to either confirm or invalidate the
hypothesis that this might be due to vCPU preemption?

> >>>>>> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> >>>>>
> >>>>> Yes, both the old kernel that prior to Al's patches and the recent kernel
> >>>>> reverting the Al's patches didn't reproduce the problem.
> >>>>>
> >>>>
> >>>> I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
> >>>>
> >>>> TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
> >>>> object that was allocated in sock_alloc_inode() before Al patches.
> >>>>
> >>>> These objects should be visible in kmalloc-64 kmem cache.
> >>>
> >>> Not exactly the 10,000,000, as it is only the possible highest number, but I
> >>> was able to observe clear exponential increase of the number of the objects
> >>> using slabtop.  Before the start of the problematic workload, the number of
> >>> objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
> >>> to 1,136,576.
> >>>
> >>>           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> >>> before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
> >>> after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
> >>>
> >>
> >> Great, thanks.
> >>
> >> How recent is the kernel you are running for your experiment ?
> > 
> > It's based on 5.4.35.

Is it possible to retest on v5.6?  I have been adding various mechanisms
to make RCU keep up better with heavy callback overload.

Also, could you please provide the .config?  If either NO_HZ_FULL or
RCU_NOCB_CPU, please also provide the kernel boot parameters.

> >> Let's make sure the bug is not in RCU.
> > 
> > One thing I can currently say is that the grace period passes at last.  I
> > modified the benchmark to repeat not 10,000 times but only 5,000 times to run
> > the test without OOM but easily observable memory pressure.  As soon as the
> > benchmark finishes, the memory were freed.
> > 
> > If you need more tests, please let me know.
> 
> I would ask Paul opinion on this issue, because we have many objects
> being freed after RCU grace periods.

As always, "It depends."

o	If the problem is a too-long RCU reader, RCU is prohibited from
	ending the grace period.  The reader duration must be shortened,
	and until it is shortened, there is nothing RCU can do.

o	In some special cases of the above, RCU can and does help, for
	example, by enlisting the aid of cond_resched().  So perhaps
	there is a long in-kernel loop that needs a cond_resched().

	And perhaps RCU can help for some types of vCPU preemption.

o	As Al suggested offline and as has been discussed in the past,
	it would not be hard to cause RCU to burn CPU to attain faster
	grace periods during OOM events.  This could be helpful, but only
	given that RCU readers are completing in reasonable timeframes.

> If RCU subsystem can not keep-up, I guess other workloads will also suffer.

If readers are not excessively long, RCU should be able to keep up.
(In the absence of misconfigurations, for example, both NO_HZ_FULL and
then binding all the rcuo kthreads to a single CPU on a 100-CPU system
or some such.)

> Sure, we can revert patches there and there trying to work around the issue,
> but for objects allocated from process context, we should not have these problems.

Agreed, let's get more info on what is happening to RCU.

One approach is to shorten the RCU CPU stall warning timeout
(rcupdate.rcu_cpu_stall_timeout=10 for 10 seconds).

							Thanx, Paul
