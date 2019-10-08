Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD4CF0BD
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfJHCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHCMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 22:12:36 -0400
Received: from paulmck-ThinkPad-P72 (unknown [12.12.162.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E37206C0;
        Tue,  8 Oct 2019 02:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570500755;
        bh=g63pxPdC5IAbKjAaknmayKF9T+zNdIQdrbMaRa/vhiQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=2t1hz9/6BvgIM0PlWann5zS78nzBY5rIeKYD34+d1ddDAIrDLvy/Cix//NCfp63bD
         KnzFDTg7kBo5FPBDcRjW4WHhX1MKMK9d4QOYxvyNKaICSzLe+IVK7sqZRMbGwpHtRv
         nA09RK7HyeouCSNU+Q5BYsgP4GU+5uMz4+jxViQw=
Date:   Mon, 7 Oct 2019 19:12:33 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Boqun Feng <boqun.feng@gmail.com>, Marco Elver <elver@google.com>,
        syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        rcu@vger.kernel.org, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191008021233.GD2689@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <000000000000604e8905944f211f@google.com>
 <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
 <20191007134304.GA2609633@tardis>
 <20191008001131.GB255532@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008001131.GB255532@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 08:11:31PM -0400, Joel Fernandes wrote:
> On Mon, Oct 07, 2019 at 09:43:04PM +0800, Boqun Feng wrote:
> > Hi Marco,
> 
> Hi Boqun, Steve and Paul, fun times!
> 
> Marco, good catch ;-)

Indeed!  ;-)

> Some comments below:
> 
> > On Mon, Oct 07, 2019 at 12:04:16PM +0200, Marco Elver wrote:
> > > +RCU maintainers
> > > This might be a data-race in RCU itself.
> > > 
> > > On Mon, 7 Oct 2019 at 12:01, syzbot
> > > <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    b4bd9343 x86, kcsan: Enable KCSAN for x86
> > > > git tree:       https://github.com/google/ktsan.git kcsan
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11edb20d600000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c0906aa620713d80
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=134336b86f728d6e55a0
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
> > > >
> > > > ==================================================================
> > > > BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
> > > >
> > > > write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
> > > >   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
> > > >   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
> > > >   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h:475
> > > >   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
> > > >   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
> > > >   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
> > > >   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
> > > >   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
> > > >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> > > >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> > > >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> > > >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> > > >
> > > > read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
> > > >   _find_next_bit lib/find_bit.c:39 [inline]
> > > >   find_next_bit+0x57/0xe0 lib/find_bit.c:70
> > > >   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
> > 
> > This is the second for_each_leaf_node_cpu_mask() loop in
> > sync_rcu_exp_select_node_cpus(), the first loop is for collecting which
> > CPU blocks current grace period (IOW, which CPU need to be sent an IPI
> > to), and the second loop does the real work of sending IPI. The first
> > loop is protected by proper lock (rcu node lock), so there is no race
> > there. But the second one can't hold rcu node lock, because the IPI
> > handler (rcu_exp_handler) needs to acquire the same lock, so rcu node
> > lock has to be dropped before the second loop to avoid deadlock.
> > 
> > Now for the racy find_next_bit() on rnp->expmask:
> > 
> > 1) if an extra bit appears: it's OK since there is checking on whether
> > the bit exists in mask_ofl_ipi (the result of the first loop).
> > 
> > 2) if a bit is missing: it will be problematic, because the second loop
> > will skip the CPU, and the rest of the code will treat the CPU as
> > offline but hasn't reported a quesient state, and the
> > rcu_report_exp_cpu_mult() will report the qs for it, even though the CPU
> > may currenlty run inside a RCU read-side critical section.
> > 
> > Note both "appears" and "missing" means some intermediate state of a
> > plain unset for expmask contributed by compiler magic.
> > 
> > Please see below for a compile-test-only patch:
> > 
> > > >   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
> > > >   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
> > > >   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
> > > >   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> > > >   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> > > >   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> > > >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> > > >
> > > > Reported by Kernel Concurrency Sanitizer on:
> > > > CPU: 1 PID: 7251 Comm: kworker/1:4 Not tainted 5.3.0+ #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > > Google 01/01/2011
> > > > Workqueue: rcu_gp wait_rcu_exp_gp
> > > > ==================================================================
> > > >
> > > >
> > 
> > Regards,
> > Boqun
> > 
> > ------------------->8
> > Subject: [PATCH] rcu: exp: Avoid race on lockless rcu_node::expmask loop
> > 
> > KCSAN reported an issue:
> > 
> > | BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
> > |
> > | write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
> > |   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
> > |   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
> > |   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h:475
> > |   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
> > |   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
> > |   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
> > |   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
> > |   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
> > |   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> > |   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> > |   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> > |   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> > |
> > | read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
> > |   _find_next_bit lib/find_bit.c:39 [inline]
> > |   find_next_bit+0x57/0xe0 lib/find_bit.c:70
> > |   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
> > |   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
> > |   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
> > |   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
> > |   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
> > |   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
> > |   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
> > |   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> > 
> > The root cause of this is the second for_each_leaf_node_cpu_mask() loop
> > in sync_rcu_exp_select_node_cpus() accesses the rcu_node::expmask
> > without holding rcu_node's lock. This is by design, because the second
> > loop may issue IPIs to other CPUs, and the IPI handler (rcu_exp_handler)
> > may acquire the same rcu_node's lock. So the rcu_node's lock has to be
> > dropped before the second loop.
> > 
> > The problem will occur when the normal unsetting of rcu_node::expmask
> > results into some intermediate state (because it's a plain access),
> > where an extra bit gets zeroed. The second loop will skip the
> > corrensponding CPU, but treat it as offline and in quesient state. This
> > will cause trouble because that CPU may be in a RCU read-side critical
> > section.
> > 
> > To fix this, take a snapshot of mask_ofl_ipi, and make the second loop
> > iterate on the snapshot's bits, as a result, the find_next_bit() of the
> > second loop doesn't access any variables that may get changed in
> > parallel, so the race is avoided.
> > 
> > Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  kernel/rcu/tree_exp.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
> > index af7e7b9c86af..7f3e19d0275e 100644
> > --- a/kernel/rcu/tree_exp.h
> > +++ b/kernel/rcu/tree_exp.h
> > @@ -335,6 +335,7 @@ static void sync_rcu_exp_select_node_cpus(struct work_struct *wp)
> >  	unsigned long flags;
> >  	unsigned long mask_ofl_test;
> >  	unsigned long mask_ofl_ipi;
> > +	unsigned long mask_ofl_ipi_snap;
> >  	int ret;
> >  	struct rcu_exp_work *rewp =
> >  		container_of(wp, struct rcu_exp_work, rew_work);
> > @@ -371,13 +372,12 @@ static void sync_rcu_exp_select_node_cpus(struct work_struct *wp)
> >  		rnp->exp_tasks = rnp->blkd_tasks.next;
> >  	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> >  
> > +	mask_ofl_ipi_snap = mask_ofl_ipi;
> >  	/* IPI the remaining CPUs for expedited quiescent state. */
> > -	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
> > +	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi_snap) {

Why can't we just use mask_ofl_ipi?  The bits removed are only those
bits just now looked at, right?  Also, the test of mask_ofl_ipi can be
dropped, since that branch will never be taken, correct?

> This looks good to me. Just a nit, I prefer if the comment to IPI the
> remaining CPUs is before the assignment to mask_ofl_ipi_snap since the
> new assignment is done for consumption by the for_each..(..) loop itself.
> 
> Steve's patch looks good as well and I was thinking along the same lines but
> Boqun's patch is slightly better because he doesn't need to snapshot exp_mask
> inside the locked section.

There are also similar lockless accesses to ->expmask in the stall-warning
code.

> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

But thank all three of you for looking this over!  My original patch
was overly ornate.  ;-)

							Thanx, Paul

> thanks,
> 
>  - Joel
> 
> >  		unsigned long mask = leaf_node_cpu_bit(rnp, cpu);
> >  		struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
> >  
> > -		if (!(mask_ofl_ipi & mask))
> > -			continue;
> >  retry_ipi:
> >  		if (rcu_dynticks_in_eqs_since(rdp, rdp->exp_dynticks_snap)) {
> >  			mask_ofl_test |= mask;
> > -- 
> > 2.23.0
> > 
