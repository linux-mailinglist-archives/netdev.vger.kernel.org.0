Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE35353A06
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 23:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhDDVgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 17:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhDDVgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 17:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E24E6135F;
        Sun,  4 Apr 2021 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617572165;
        bh=H4Ds74LWsoA/BwpIQgOpltuAShIQTfCXQfyXi0DuRRI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=uUUXBt9hiCCJ2UdfMZLkoU4HZITMSkkzHxQjGOMUa8FJbXWhBQqe1+k7qnGm0W8LV
         It2vEqClpcieXhDt+TN9LB381+hggUaZa9vuFPl50VvQOkC13ist+GcdoGKVECC6iC
         U5OcDlP9jZzUQOn7BHi+EGY5LStrn9hPyDs0G/KYhWXK9pjGdVgE5yqCsAcHWcA4iG
         kk1qg++knK9Kiqjpm1ySSOcDPlzm15F1fGcLjkj99t/tL+QS/IBzymv+cfOHLjuX32
         Rafcr9exBl4GHsfJTRI1AInhM/MuTekhjsgn1wSjsTu4C4wnT+bcJLtozh/XPEkM9P
         RhqiKIgsWdXQQ==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 619F23522F84; Sun,  4 Apr 2021 14:36:05 -0700 (PDT)
Date:   Sun, 4 Apr 2021 14:36:05 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+dde0cc33951735441301@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        frederic@kernel.org
Subject: Re: Something is leaking RCU holds from interrupt context
Message-ID: <20210404213605.GA2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <00000000000025a67605bf1dd4ab@google.com>
 <20210404102457.GS351017@casper.infradead.org>
 <20210404164808.GZ2696@paulmck-ThinkPad-P72>
 <20210404182453.GT351017@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404182453.GT351017@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 07:24:53PM +0100, Matthew Wilcox wrote:
> On Sun, Apr 04, 2021 at 09:48:08AM -0700, Paul E. McKenney wrote:
> > On Sun, Apr 04, 2021 at 11:24:57AM +0100, Matthew Wilcox wrote:
> > > On Sat, Apr 03, 2021 at 09:15:17PM -0700, syzbot wrote:
> > > > HEAD commit:    2bb25b3a Merge tag 'mips-fixes_5.12_3' of git://git.kernel..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1284cc31d00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=dde0cc33951735441301
> > > > 
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > 
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+dde0cc33951735441301@syzkaller.appspotmail.com
> > > > 
> > > > WARNING: suspicious RCU usage
> > > > 5.12.0-rc5-syzkaller #0 Not tainted
> > > > -----------------------------
> > > > kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!
> > > > 
> > > > other info that might help us debug this:
> > > > 
> > > > 
> > > > rcu_scheduler_active = 2, debug_locks = 0
> > > > no locks held by systemd-udevd/4825.
> > > 
> > > I think we have something that's taking the RCU read lock in
> > > (soft?) interrupt context and not releasing it properly in all
> > > situations.  This thread doesn't have any locks recorded, but
> > > lock_is_held(&rcu_bh_lock_map) is true.
> > > 
> > > Is there some debugging code that could find this?  eg should
> > > lockdep_softirq_end() check that rcu_bh_lock_map is not held?
> > > (if it's taken in process context, then BHs can't run, so if it's
> > > held at softirq exit, then there's definitely a problem).
> > 
> > Something like the (untested) patch below?
> 
> Maybe?  Will this tell us who took the lock?  I was really trying to
> throw out a suggestion in the hope that somebody who knows this area
> better than I do would tell me I was wrong.

No idea.  If it is reproducible, hopefully someone will try it.  If it
is not reproducible, so it goes!

And hey, it is not my fault that you sounded like you knew what you were
talking about!  ;-)

But yes, now that you mention it, it is odd that rcu_sleep_check()
thought that rcu_bh_lock_map was held, but lockdep_rcu_suspicious()
does not.  One clue might be that rcu_sleep_check() is looking at
rcu_bh_lock_map() itself, while lockdep_rcu_suspicious() and its callee,
lockdep_print_held_locks(), rely on current->lockdep_depth.

Maybe these have gotten out of sync.

> > Please note that it does not make sense to also check for
> > either rcu_lock_map or rcu_sched_lock_map because either of
> > these might be held by the interrupted code.
> 
> Yes!  Although if we do it somewhere like tasklet_action_common(),
> we could do something like:
> 
> +++ b/kernel/softirq.c
> @@ -774,6 +774,7 @@ static void tasklet_action_common(struct softirq_action *a,
>  
>         while (list) {
>                 struct tasklet_struct *t = list;
> +               unsigned long rcu_lockdep = rcu_get_lockdep_state();
>  
>                 list = list->next;
>  
> @@ -790,6 +791,10 @@ static void tasklet_action_common(struct softirq_action *a,
>                         }
>                         tasklet_unlock(t);
>                 }
> +               if (rcu_lockdep != rcu_get_lockdep_state()) {
> +                       printk(something useful about t);
> +                       RCU_LOCKDEP_WARN(... something else useful ...);
> +               }
>  
>                 local_irq_disable();
> 
> where rcu_get_lockdep_state() returns a bitmap of whether the four rcu
> lockdep maps are held.
> 
> We might also need something similar in __do_softirq(), in case it's
> not a tasklet that's the problem.

The rcu_get_lockdep_state() function would just set bits based on RCU's
various lockdep maps, but the comparison would need to take at least
debug_lockdep_rcu_enabled() into account.  Just in case there is a
lockdep report between the sampling and comparison.

But first let's see what the lockdep experts have to say.

							Thanx, Paul
