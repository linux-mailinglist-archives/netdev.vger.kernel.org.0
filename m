Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C4353964
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 20:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhDDSZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhDDSZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 14:25:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC88C061756;
        Sun,  4 Apr 2021 11:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rW0csn7XoqpOPoaG0JrdSLYq0KyjeZt2w0r8mrp3/Lo=; b=qk332i2lZy7ImQVl0Nt3pXDVda
        DrP6tCq0Uq9uAsBRRTMcpk+JwcbETrzNoF4wVJ/WK663ushxk6wqlJLsH7YI5uYjFs7UhLC44pwOw
        1XKQNvXd3yzFIfKIo3TfjK3/oGO448Cx2rq0+s7DivR+EbUS+7UjTyOUun8hIO82QthA2MSY7Sj1V
        XaPe0FJVaLRYXsF0JWis1+6nz0QYAM7YZfGi4J5K8jNuq3tlalOKVkxNhe9+kRGEfuMZ05HxqNVPf
        f7iH26AEfvHRyR0KJ6wsZkSSa0DR+6WM00U9AhczQ4OlgGJ03iVmJilWr09r3mZWEu4rTWVR/xadY
        r61OMCtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lT7Qb-00AQID-AZ; Sun, 04 Apr 2021 18:24:54 +0000
Date:   Sun, 4 Apr 2021 19:24:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     syzbot <syzbot+dde0cc33951735441301@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        frederic@kernel.org
Subject: Re: Something is leaking RCU holds from interrupt context
Message-ID: <20210404182453.GT351017@casper.infradead.org>
References: <00000000000025a67605bf1dd4ab@google.com>
 <20210404102457.GS351017@casper.infradead.org>
 <20210404164808.GZ2696@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404164808.GZ2696@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 09:48:08AM -0700, Paul E. McKenney wrote:
> On Sun, Apr 04, 2021 at 11:24:57AM +0100, Matthew Wilcox wrote:
> > On Sat, Apr 03, 2021 at 09:15:17PM -0700, syzbot wrote:
> > > HEAD commit:    2bb25b3a Merge tag 'mips-fixes_5.12_3' of git://git.kernel..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1284cc31d00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=dde0cc33951735441301
> > > 
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+dde0cc33951735441301@syzkaller.appspotmail.com
> > > 
> > > WARNING: suspicious RCU usage
> > > 5.12.0-rc5-syzkaller #0 Not tainted
> > > -----------------------------
> > > kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!
> > > 
> > > other info that might help us debug this:
> > > 
> > > 
> > > rcu_scheduler_active = 2, debug_locks = 0
> > > no locks held by systemd-udevd/4825.
> > 
> > I think we have something that's taking the RCU read lock in
> > (soft?) interrupt context and not releasing it properly in all
> > situations.  This thread doesn't have any locks recorded, but
> > lock_is_held(&rcu_bh_lock_map) is true.
> > 
> > Is there some debugging code that could find this?  eg should
> > lockdep_softirq_end() check that rcu_bh_lock_map is not held?
> > (if it's taken in process context, then BHs can't run, so if it's
> > held at softirq exit, then there's definitely a problem).
> 
> Something like the (untested) patch below?

Maybe?  Will this tell us who took the lock?  I was really trying to
throw out a suggestion in the hope that somebody who knows this area
better than I do would tell me I was wrong.

> Please note that it does not make sense to also check for
> either rcu_lock_map or rcu_sched_lock_map because either of
> these might be held by the interrupted code.

Yes!  Although if we do it somewhere like tasklet_action_common(),
we could do something like:

+++ b/kernel/softirq.c
@@ -774,6 +774,7 @@ static void tasklet_action_common(struct softirq_action *a,
 
        while (list) {
                struct tasklet_struct *t = list;
+               unsigned long rcu_lockdep = rcu_get_lockdep_state();
 
                list = list->next;
 
@@ -790,6 +791,10 @@ static void tasklet_action_common(struct softirq_action *a,
                        }
                        tasklet_unlock(t);
                }
+               if (rcu_lockdep != rcu_get_lockdep_state()) {
+                       printk(something useful about t);
+                       RCU_LOCKDEP_WARN(... something else useful ...);
+               }
 
                local_irq_disable();

where rcu_get_lockdep_state() returns a bitmap of whether the four rcu
lockdep maps are held.

We might also need something similar in __do_softirq(), in case it's
not a tasklet that's the problem.
