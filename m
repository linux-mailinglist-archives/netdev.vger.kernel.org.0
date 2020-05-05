Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDB51C5FC3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgEESLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:11:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59334 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730184AbgEESLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588702291; x=1620238291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=+821Wwf5AYr1K8nxKevr7tEFWbfM2VMfbVR0LMsRGRU=;
  b=Fw32OJqkT9B3700Rs9H3z7XRNZaGo9VPDnYN9pLA8pm3reLQ5fTsrUeM
   Bv9j2h5CYdOgZLqHcCRJEyZt3/ZAeZQtbUn7MOG6BzHH2jIzXftcNDnXk
   vyQDA8dAvqjrC6U8NUcRZuAtulPeewL+/1qgwLIPWpnTtV6UEFaHlBNBq
   Y=;
IronPort-SDR: EW34MZA2llje8LI32uObFMWC21OA8p4OnrRx9nolhn7kb7tsekUE0ly/Qhvy52SivyxEb2Z0jP
 dGTlwrxrmSBw==
X-IronPort-AV: E=Sophos;i="5.73,356,1583193600"; 
   d="scan'208";a="42850494"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 May 2020 18:11:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id A6856A21CC;
        Tue,  5 May 2020 18:11:27 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 18:11:27 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.200) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 18:11:16 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 20:11:01 +0200
Message-ID: <20200505181101.16384-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505172850.GD2869@paulmck-ThinkPad-P72> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D06UWA004.ant.amazon.com (10.43.160.164) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 10:28:50 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Tue, May 05, 2020 at 09:37:42AM -0700, Eric Dumazet wrote:
> > 
> > 
> > On 5/5/20 9:31 AM, Eric Dumazet wrote:
> > > 
> > > 
> > > On 5/5/20 9:25 AM, Eric Dumazet wrote:
> > >>
> > >>
> > >> On 5/5/20 9:13 AM, SeongJae Park wrote:
> > >>> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > >>>
> > >>>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> > >>>>>
> > >>>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>>>>
> > >>>>>>
> > >>>>>>
> > >>>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
> > >>>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > >>>>>>>
> > >>>>>>
> > >>>>>>>> Why do we have 10,000,000 objects around ? Could this be because of
> > >>>>>>>> some RCU problem ?
> > >>>>>>>
> > >>>>>>> Mainly because of a long RCU grace period, as you guess.  I have no idea how
> > >>>>>>> the grace period became so long in this case.
> > >>>>>>>
> > >>>>>>> As my test machine was a virtual machine instance, I guess RCU readers
> > >>>>>>> preemption[1] like problem might affected this.
> > >>>>>>>
> > >>>>>>> [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
> > >>>>>>>
> > >>>>>>>>
> > >>>>>>>> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> > >>>>>>>
> > >>>>>>> Yes, both the old kernel that prior to Al's patches and the recent kernel
> > >>>>>>> reverting the Al's patches didn't reproduce the problem.
> > >>>>>>>
> > >>>>>>
> > >>>>>> I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
> > >>>>>>
> > >>>>>> TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
> > >>>>>> object that was allocated in sock_alloc_inode() before Al patches.
> > >>>>>>
> > >>>>>> These objects should be visible in kmalloc-64 kmem cache.
> > >>>>>
> > >>>>> Not exactly the 10,000,000, as it is only the possible highest number, but I
> > >>>>> was able to observe clear exponential increase of the number of the objects
> > >>>>> using slabtop.  Before the start of the problematic workload, the number of
> > >>>>> objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
> > >>>>> to 1,136,576.
> > >>>>>
> > >>>>>           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > >>>>> before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
> > >>>>> after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
> > >>>>>
> > >>>>
> > >>>> Great, thanks.
> > >>>>
> > >>>> How recent is the kernel you are running for your experiment ?
> > >>>
> > >>> It's based on 5.4.35.
> > >>>
> > >>>>
> > >>>> Let's make sure the bug is not in RCU.
> > >>>
> > >>> One thing I can currently say is that the grace period passes at last.  I
> > >>> modified the benchmark to repeat not 10,000 times but only 5,000 times to run
> > >>> the test without OOM but easily observable memory pressure.  As soon as the
> > >>> benchmark finishes, the memory were freed.
> > >>>
> > >>> If you need more tests, please let me know.
> > >>>
> > >>
> > >> I would ask Paul opinion on this issue, because we have many objects
> > >> being freed after RCU grace periods.
> > >>
> > >> If RCU subsystem can not keep-up, I guess other workloads will also suffer.
> > >>
> > >> Sure, we can revert patches there and there trying to work around the issue,
> > >> but for objects allocated from process context, we should not have these problems.
> > >>
> > > 
> > > I wonder if simply adjusting rcu_divisor to 6 or 5 would help 
> > > 
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index d9a49cd6065a20936edbda1b334136ab597cde52..fde833bac0f9f81e8536211b4dad6e7575c1219a 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -427,7 +427,7 @@ module_param(qovld, long, 0444);
> > >  static ulong jiffies_till_first_fqs = ULONG_MAX;
> > >  static ulong jiffies_till_next_fqs = ULONG_MAX;
> > >  static bool rcu_kick_kthreads;
> > > -static int rcu_divisor = 7;
> > > +static int rcu_divisor = 6;
> > >  module_param(rcu_divisor, int, 0644);
> > >  
> > >  /* Force an exit from rcu_do_batch() after 3 milliseconds. */
> > > 
> > 
> > To be clear, you can adjust the value without building a new kernel.
> > 
> > echo 6 >/sys/module/rcutree/parameters/rcu_divisor
> 
> Worth a try!  If that helps significantly, I have some ideas for updating
> that heuristic, such as checking for sudden increases in the number of
> pending callbacks.
> 
> But I would really also like to know whether there are long readers and
> whether v5.6 fares better.

I will share the results as soon as possible :)


Thanks,
SeongJae Park

> 
> 							Thanx, Paul
