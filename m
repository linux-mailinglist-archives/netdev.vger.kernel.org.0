Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B41197D13
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgC3Nh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgC3Nh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 09:37:28 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E08520771;
        Mon, 30 Mar 2020 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585575447;
        bh=bhkR5cAEROzrV2P74aJy/I2LsxpjbSCJMF1VCVAqNLQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Kn0Z1utO0Nzt8fXQ/oXQZY+Dwo+tktpKu1Ev4OYUfaISNzj7l1SPwCAEKczZ+5dFo
         4ceOaMHo+e48zfnp/FUNpTEwfmhvVFfALffOav+1yf8yFaSC2dDZNVO1t3REe/4Tzl
         KQh9eZvugPx7fB4pSDsUW3rn3HkX5b2waFiC2zZk=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 02E4835226F8; Mon, 30 Mar 2020 06:37:27 -0700 (PDT)
Date:   Mon, 30 Mar 2020 06:37:26 -0700
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
Message-ID: <20200330133726.GJ19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <000000000000742e9e05a10170bc@google.com>
 <87a74arown.fsf@nanos.tec.linutronix.de>
 <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
 <87ftdypyec.fsf@nanos.tec.linutronix.de>
 <CAM_iQpVR8Ve3Jy8bb9VB6RcQ=p22ZTyTqjxJxL11RZmO7rkWeg@mail.gmail.com>
 <875zeuftwm.fsf@nanos.tec.linutronix.de>
 <CAM_iQpWkNJ+yQ1g+pdkhJBCZ-CJfUGGpvJqOz1JH7LPVtqbRxg@mail.gmail.com>
 <20200325185815.GW19865@paulmck-ThinkPad-P72>
 <CAM_iQpU+1as_RAE64wfq+rWcCb16_amFP3V4rZVFRr29SfwD4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpU+1as_RAE64wfq+rWcCb16_amFP3V4rZVFRr29SfwD4Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 12:53:43PM -0700, Cong Wang wrote:
> On Wed, Mar 25, 2020 at 11:58 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Wed, Mar 25, 2020 at 11:36:16AM -0700, Cong Wang wrote:
> > > On Mon, Mar 23, 2020 at 6:01 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >
> > > > Cong Wang <xiyou.wangcong@gmail.com> writes:
> > > > > On Mon, Mar 23, 2020 at 2:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > >> > We use an ordered workqueue for tc filters, so these two
> > > > >> > works are executed in the same order as they are queued.
> > > > >>
> > > > >> The workqueue is ordered, but look how the work is queued on the work
> > > > >> queue:
> > > > >>
> > > > >> tcf_queue_work()
> > > > >>   queue_rcu_work()
> > > > >>     call_rcu(&rwork->rcu, rcu_work_rcufn);
> > > > >>
> > > > >> So after the grace period elapses rcu_work_rcufn() queues it in the
> > > > >> actual work queue.
> > > > >>
> > > > >> Now tcindex_destroy() is invoked via tcf_proto_destroy() which can be
> > > > >> invoked from preemtible context. Now assume the following:
> > > > >>
> > > > >> CPU0
> > > > >>   tcf_queue_work()
> > > > >>     tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> > > > >>
> > > > >> -> Migration
> > > > >>
> > > > >> CPU1
> > > > >>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
> > > > >>
> > > > >> So your RCU callbacks can be placed on different CPUs which obviously
> > > > >> has no ordering guarantee at all. See also:
> > > > >
> > > > > Good catch!
> > > > >
> > > > > I thought about this when I added this ordered workqueue, but it
> > > > > seems I misinterpret max_active, so despite we have max_active==1,
> > > > > more than 1 work could still be queued on different CPU's here.
> > > >
> > > > The workqueue is not the problem. it works perfectly fine. The way how
> > > > the work gets queued is the issue.
> > >
> > > Well, a RCU work is also a work, so the ordered workqueue should
> > > apply to RCU works too, from users' perspective. Users should not
> > > need to learn queue_rcu_work() is actually a call_rcu() which does
> > > not guarantee the ordering for an ordered workqueue.
> >
> > And the workqueues might well guarantee the ordering in cases where the
> > pair of RCU callbacks are invoked in a known order.  But that workqueues
> > ordering guarantee does not extend upstream to RCU, nor do I know of a
> > reasonable way to make this happen within the confines of RCU.
> >
> > If you have ideas, please do not keep them a secret, but please also
> > understand that call_rcu() must meet some pretty severe performance and
> > scalability constraints.
> >
> > I suppose that queue_rcu_work() could track outstanding call_rcu()
> > invocations, and (one way or another) defer the second queue_rcu_work()
> > if a first one is still pending from the current task, but that might not
> > make the common-case user of queue_rcu_work() all that happy.  But perhaps
> > there is a way to restrict these semantics to ordered workqueues.  In that
> > case, one could imagine the second and subsequent too-quick call to
> > queue_rcu_work() using the rcu_head structure's ->next field to queue these
> > too-quick callbacks, and then having rcu_work_rcufn() check for queued
> > too-quick callbacks, queuing the first one.
> >
> > But I must defer to Tejun on this one.
> >
> > And one additional caution...  This would meter out ordered
> > queue_rcu_work() requests at a rate of no faster than one per RCU
> > grace period.  The queue might build up, resulting in long delays.
> > Are you sure that your use case can live with this?
> 
> I don't know, I guess we might be able to add a call_rcu() takes a cpu
> as a parameter so that all of these call_rcu() callbacks will be queued
> on a same CPU thusly guarantees the ordering. But of course we
> need to figure out which cpu to use. :)
> 
> Just my two cents.

CPUs can go offline.  Plus if current trends continue, I will eventually
be forced to concurrently execute callbacks originating from a single CPU.

Another approach would be to have an additional step of workqueue
in the ordered case, so that a workqueue handler does rcu_barrier(),
invokes call_rcu(), which finally spawns the eventual workqueue handler.
But I do not believe that this will work well in your case because
you only need the last workqueue handler to be ordered against all the
previous callbacks.  I suppose that a separate queue_rcu_work_ordered()
API (or similar) could be added that did this, but I suspect that Tejun
might want to see a few more use cases before adding something like this.
Especially if the rcu_barrier() is introducing too much delay for your
use case.

> > > > > I don't know how to fix this properly, I think essentially RCU work
> > > > > should be guaranteed the same ordering with regular work. But this
> > > > > seems impossible unless RCU offers some API to achieve that.
> > > >
> > > > I don't think that's possible w/o putting constraints on the flexibility
> > > > of RCU (Paul of course might disagree).
> > > >
> > > > I assume that the filters which hang of tcindex_data::perfect and
> > > > tcindex_data:p must be freed before tcindex_data, right?
> > > >
> > > > Refcounting of tcindex_data should do the trick. I.e. any element which
> > > > you add to a tcindex_data instance takes a refcount and when that is
> > > > destroyed then the rcu/work callback drops a reference which once it
> > > > reaches 0 triggers tcindex_data to be freed.
> > >
> > > Yeah, but the problem is more than just tcindex filter, we have many
> > > places make the same assumption of ordering.
> >
> > But don't you also have a situation where there might be a large group
> > of queue_rcu_work() invocations whose order doesn't matter, followed by a
> > single queue_rcu_work() invocation that must be ordered after the earlier
> > group?  If so, ordering -all- of these invocations might be overkill.
> >
> > Or did I misread your code?
> 
> You are right. Previously I thought all non-trivial tc filters would need
> to address this ordering bug, but it turns out probably only tcindex
> needs it, because most of them actually use linked lists. As long as
> we remove the entry from the list before tcf_queue_work(), it is fine
> to free the list head before each entry in the list.
> 
> I just sent out a minimal fix using the refcnt.

Sounds good.

							Thanx, Paul
