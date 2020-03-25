Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947341930E1
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCYTHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgCYTHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 15:07:40 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD3820714;
        Wed, 25 Mar 2020 19:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585163259;
        bh=lhy+Eu3yict1wi7voNpWry2+n+0EtZmY4ZR96Tpx/lk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=covR7fziSsoadZsZ3tfWGwczdeUG39GhVnWXCKG+7tq8E1HYiSz1PYd3ELksGojq2
         rPjZ7AvTthbbsa3jKaD1DrCwkSzWKIliKuXK7H0OJEDATfGIy2Ul1oZeLwElqrnj++
         VZuuljk7mYTga+VGE220XaFoAartJ1pigV1vzOBo=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 631D33520BDC; Wed, 25 Mar 2020 12:07:39 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:07:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
Message-ID: <20200325190739.GA19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <000000000000742e9e05a10170bc@google.com>
 <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de>
 <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de>
 <20200324020504.GR3199@paulmck-ThinkPad-P72>
 <CAM_iQpVK5tNrer3UnnBVU82cRcdNAVtn5bxCm4rDVZM1_ffPAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVK5tNrer3UnnBVU82cRcdNAVtn5bxCm4rDVZM1_ffPAQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:53:51AM -0700, Cong Wang wrote:
> On Mon, Mar 23, 2020 at 7:05 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Tue, Mar 24, 2020 at 02:01:13AM +0100, Thomas Gleixner wrote:
> > > Cong Wang <xiyou.wangcong@gmail.com> writes:
> > > > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >> > We use an ordered workqueue for tc filters, so these two
> > > >> > works are executed in the same order as they are queued.
> > > >>
> > > >> The workqueue is ordered, but look how the work is queued on the work
> > > >> queue:
> > > >>
> > > >> tcf_queue_work()
> > > >>   queue_rcu_work()
> > > >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> > > >>
> > > >> So after the grace period elapses rcu_work_rcufn() queues it in the
> > > >> actual work queue.
> > > >>
> > > >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> > > >> invoked from preemtible context. Now assume the following:
> > > >>
> > > >> CPU0
> > > >>   tcf_queue_work()
> > > >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > > >>
> > > >> -> Migration
> > > >>
> > > >> CPU1
> > > >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > > >>
> > > >> So your RCU callbacks can be placed on different CPUs which obviously
> > > >> has no ordering guarantee at all. See also:
> > > >
> > > > Good catch!
> > > >
> > > > I thought about this when I added this ordered workqueue, but it
> > > > seems I misinterpret max_active, so despite we have max_active==1,
> > > > more than 1 work could still be queued on different CPU's here.
> > >
> > > The workqueue is not the problem. it works perfectly fine. The way how
> > > the work gets queued is the issue.
> > >
> > > > I don't know how to fix this properly, I think essentially RCU work
> > > > should be guaranteed the same ordering with regular work. But this
> > > > seems impossible unless RCU offers some API to achieve that.
> > >
> > > I don't think that's possible w/o putting constraints on the flexibility
> > > of RCU (Paul of course might disagree).
> >
> > It is possible, but it does not come for free.
> >
> > From an RCU/workqueues perspective, if I understand the scenario, you
> > can do the following:
> >
> >         tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> >
> >         rcu_barrier(); // Wait for the RCU callback.
> >         flush_work(...); // Wait for the workqueue handler.
> >                          // But maybe for quite a few of them...
> >
> >         // All the earlier handlers have completed.
> >         tcf_queue_work(&p->rwork, tcindex_destroy_work);
> >
> > This of course introduces overhead and latency.  Maybe that is not a
> > problem at teardown time, or maybe the final tcf_queue_work() can itself
> > be dumped into a workqueue in order to get it off of the critical path.
> 
> I personally agree, but nowadays NIC vendors care about tc filter
> slow path performance as well. :-/

I bet that they do!  ;-)

But have you actually tried the rcu_barrier()/flush_work() approach?
It is reasonably simple to implement, even if you do have to use multiple
flush_work() calls, and who knows?  Maybe it is fast enough.

So why not try it?

Hmmm...  Another approach would be to associate a counter with this group
of requests, incrementing this count in tcf_queue_work() and capturing
the prior value of the count, then in tcindex_destroy_work() waiting
for the count to reach the captured value.  This would avoid needless
waiting in tcindex_destroy_rexts_work().  Such needless waiting would
be hard to avoid within the confines of either RCU or workqueues, and
such needless waiting might well slow down this slowpath, which again
might make the NIC vendors unhappy.

> > However, depending on your constraints ...
> >
> > > I assume that the filters which hang of tcindex_data::perfect and
> > > tcindex_data:p must be freed before tcindex_data, right?
> > >
> > > Refcounting of tcindex_data should do the trick. I.e. any element which
> > > you add to a tcindex_data instance takes a refcount and when that is
> > > destroyed then the rcu/work callback drops a reference which once it
> > > reaches 0 triggers tcindex_data to be freed.
> >
> > ... reference counts might work much better for you.
> 
> I need to think about how much work is needed for refcnting, given
> other filters have the same assumption.

Perhaps you can create some common code to handle this situation, which
can then be shared among those various filters.

							Thanx, Paul
