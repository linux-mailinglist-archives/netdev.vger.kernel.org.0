Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DBC19037D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 03:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCXCFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 22:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgCXCFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 22:05:05 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545A62051A;
        Tue, 24 Mar 2020 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585015504;
        bh=ts0X52FH1oa59KdqdB95tDAVKxMN7apo6ZkPMxfzJwc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YMG1YxTBHYmxYMPc5hqXy5baZgL40j1vUEKM6ScoAhOQA9q0iHioB/fjIwyGvL57N
         bTzqbxT6E3HoT6a4kxtS+mdFfluLeBlpb3fr/0ZeIlOH25SBL9qsA5/xCY3FBnMhER
         qLuHikr73g8vqt+oCqXsL544aw9O/ZPh0NiPZKZ8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 2694835226D5; Mon, 23 Mar 2020 19:05:04 -0700 (PDT)
Date:   Mon, 23 Mar 2020 19:05:04 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
Message-ID: <20200324020504.GR3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <000000000000742e9e05a10170bc@google.com>
 <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de>
 <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zeuftwm.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 02:01:13AM +0100, Thomas Gleixner wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > We use an ordered workqueue for tc filters, so these two
> >> > works are executed in the same order as they are queued.
> >>
> >> The workqueue is ordered, but look how the work is queued on the work
> >> queue:
> >>
> >> tcf_queue_work()
> >>   queue_rcu_work()
> >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> >>
> >> So after the grace period elapses rcu_work_rcufn() queues it in the
> >> actual work queue.
> >>
> >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> >> invoked from preemtible context. Now assume the following:
> >>
> >> CPU0
> >>   tcf_queue_work()
> >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> >>
> >> -> Migration
> >>
> >> CPU1
> >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> >>
> >> So your RCU callbacks can be placed on different CPUs which obviously
> >> has no ordering guarantee at all. See also:
> >
> > Good catch!
> >
> > I thought about this when I added this ordered workqueue, but it
> > seems I misinterpret max_active, so despite we have max_active==1,
> > more than 1 work could still be queued on different CPU's here.
> 
> The workqueue is not the problem. it works perfectly fine. The way how
> the work gets queued is the issue.
> 
> > I don't know how to fix this properly, I think essentially RCU work
> > should be guaranteed the same ordering with regular work. But this
> > seems impossible unless RCU offers some API to achieve that.
> 
> I don't think that's possible w/o putting constraints on the flexibility
> of RCU (Paul of course might disagree).

It is possible, but it does not come for free.

From an RCU/workqueues perspective, if I understand the scenario, you
can do the following:

	tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);

	rcu_barrier(); // Wait for the RCU callback.
	flush_work(...); // Wait for the workqueue handler.
			 // But maybe for quite a few of them...

	// All the earlier handlers have completed.
	tcf_queue_work(&p->rwork, tcindex_destroy_work);

This of course introduces overhead and latency.  Maybe that is not a
problem at teardown time, or maybe the final tcf_queue_work() can itself
be dumped into a workqueue in order to get it off of the critical path.

However, depending on your constraints ...

> I assume that the filters which hang of tcindex_data::perfect and
> tcindex_data:p must be freed before tcindex_data, right?
> 
> Refcounting of tcindex_data should do the trick. I.e. any element which
> you add to a tcindex_data instance takes a refcount and when that is
> destroyed then the rcu/work callback drops a reference which once it
> reaches 0 triggers tcindex_data to be freed.

... reference counts might work much better for you.

							Thanx, Paul
