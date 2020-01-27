Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA8B14ABEE
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 23:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA0WOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 17:14:12 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:51949 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgA0WOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 17:14:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 7F7253C8014F;
        Mon, 27 Jan 2020 23:14:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1580163246; x=1581977647; bh=ulTH0RRxql
        7c//LE6kmDWTETxqSFptGl1z2vBDEwGHg=; b=MhN+qU0x5clKGQpORU07CDn/m2
        MRgqtL9/4EBx2eMYYhlB+SuR4eWJ5sFiT3An24gVmRXf3EoTQf7D08CxqQu+K13E
        65dM159lKVmdNQ8iSG2205NpDiLk8BOEUwJUlgWCa49VwzMyDPChXqvx9kQ4ngmd
        U+WytSVFc5bS4jY70=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 27 Jan 2020 23:14:06 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id C843F3C8011C;
        Mon, 27 Jan 2020 23:14:04 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id E70C321304; Mon, 27 Jan 2020 23:14:03 +0100 (CET)
Date:   Mon, 27 Jan 2020 23:14:03 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Hillf Danton <hdanton@sina.com>
cc:     syzbot <syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com>,
        x86@kernel.org, tony.luck@intel.com, peterz@infradead.org,
        netdev@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        coreteam@netfilter.org, bp@alien8.de,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, davem@davemloft.net
Subject: Re: [netfilter-core] INFO: rcu detected stall in hash_ip4_gc
In-Reply-To: <20200127042315.10456-1-hdanton@sina.com>
Message-ID: <alpine.DEB.2.20.2001272304410.2904@blackhole.kfki.hu>
References: <20200127042315.10456-1-hdanton@sina.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On Mon, 27 Jan 2020, Hillf Danton wrote:

> 
> Sun, 26 Jan 2020 11:17:12 -0800 (PST)
> > syzbot found the following crash on:
> > 
> > HEAD commit:    6381b442 Merge tag 'iommu-fixes-v5.5-rc7' of git://git.ker..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14f44769e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
> > dashboard link: https://syzkaller.appspot.com/bug?extid=68a806795ac89df3aa1c
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > userspace arch: i386
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fad479e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f62f21e00000
> > 
> > The bug was bisected to:
> > 
> > commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
> > Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Date:   Sat Oct 27 13:07:40 2018 +0000
> > 
> >     netfilter: ipset: Introduction of new commands and protocol version 7
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1128b611e00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1328b611e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1528b611e00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com
> > Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")
> > 
> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > 	(detected by 1, t=10502 jiffies, g=9453, q=929)
> > rcu: All QSes seen, last rcu_preempt kthread activity 10502 (4294981303-4294970801), jiffies_till_next_fqs=1, root ->qsmask 0x0
> > syz-executor596 R  running task    28776  9738   9733 0x20020008
> > Call Trace:
> >  <IRQ>
> >  sched_show_task kernel/sched/core.c:5954 [inline]
> >  sched_show_task.cold+0x2ee/0x35d kernel/sched/core.c:5929
> >  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
> >  check_cpu_stall kernel/rcu/tree_stall.h:538 [inline]
> >  rcu_pending kernel/rcu/tree.c:2827 [inline]
> >  rcu_sched_clock_irq.cold+0xaf4/0xc0d kernel/rcu/tree.c:2271
> >  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
> >  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
> >  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
> >  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
> >  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
> >  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
> >  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> > RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
> > Code: 18 77 de f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d c4 31 54 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d b4 31 54 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 fe 3f 8e f9 e8 c9
> > RSP: 0018:ffffc90000da8b10 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> > RAX: 1ffffffff1326676 RBX: ffff8880a46f6e20 RCX: 0000000000000002
> > RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff8880a3224b14
> > RBP: ffffc90000da8b30 R08: 1ffffffff165e7b1 R09: fffffbfff165e7b2
> > R10: fffffbfff165e7b1 R11: ffffffff8b2f3d8f R12: 0000000000000003
> > R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000001
> >  pv_wait arch/x86/include/asm/paravirt.h:648 [inline]
> >  pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
> >  __pv_queued_spin_lock_slowpath+0x9ba/0xc40 kernel/locking/qspinlock.c:507
> >  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:638 [inline]
> >  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
> >  queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
> >  do_raw_spin_lock+0x21d/0x2f0 kernel/locking/spinlock_debug.c:113
> >  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
> >  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
> >  spin_lock_bh include/linux/spinlock.h:343 [inline]
> >  hash_ip4_gc+0x49/0x150 net/netfilter/ipset/ip_set_hash_gen.h:532
> >  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
> >  expire_timers kernel/time/timer.c:1449 [inline]
> >  __run_timers kernel/time/timer.c:1773 [inline]
> >  __run_timers kernel/time/timer.c:1740 [inline]
> >  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
> >  __do_softirq+0x262/0x98c kernel/softirq.c:292
> >  invoke_softirq kernel/softirq.c:373 [inline]
> >  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
> >  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
> >  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> >  </IRQ>
> > RIP: 0010:schedule_debug kernel/sched/core.c:3878 [inline]
> > RIP: 0010:__schedule+0x119/0x1f90 kernel/sched/core.c:4013
> > Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 ad 18 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 7d 18 4c 89 fa 48 c1 ea 03 80 3c 02 00 <0f> 85 d2 18 00 00 49 81 3f 9d 6e ac 57 0f 85 47 1e 00 00 84 db 75
> > RSP: 0018:ffffc90001f17b70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff839f64da
> > RDX: 1ffff920003e2000 RSI: ffffffff839f64e3 RDI: ffff8880a3224298
> > RBP: ffffc90001f17c38 R08: ffff8880a3224280 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880ae937340
> > R13: ffff8880a3224280 R14: 0000000000037340 R15: ffffc90001f10000
> >  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
> >  freezable_schedule include/linux/freezer.h:172 [inline]
> >  do_nanosleep+0x21f/0x640 kernel/time/hrtimer.c:1874
> >  hrtimer_nanosleep+0x297/0x550 kernel/time/hrtimer.c:1927
> >  __do_sys_nanosleep_time32 kernel/time/hrtimer.c:1981 [inline]
> >  __se_sys_nanosleep_time32 kernel/time/hrtimer.c:1968 [inline]
> >  __ia32_sys_nanosleep_time32+0x1ad/0x230 kernel/time/hrtimer.c:1968
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
> >  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
> >  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> > RIP: 0023:0xf7f089a9
> > Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
> > RSP: 002b:00000000ffe365ac EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
> > RAX: ffffffffffffffda RBX: 00000000ffe365d8 RCX: 0000000000000000
> > RDX: 0000000000002611 RSI: 0000000000051fda RDI: 0000000000000000
> > RBP: 00000000ffe36628 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > rcu: rcu_preempt kthread starved for 10502 jiffies! g9453 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
> > rcu: RCU grace-period kthread stack dump:
> > rcu_preempt     R  running task    29264    10      2 0x80004000
> > Call Trace:
> >  context_switch kernel/sched/core.c:3385 [inline]
> >  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
> >  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
> >  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
> >  rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
> >  rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
> >  kthread+0x361/0x430 kernel/kthread.c:255
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > 
> > 
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 
> Retry gc next jiffy if someone else is doing their works under lock
> protection.

Thanks for the patch, but it does not fix completely the issue: the same 
error message can pop up in ip_set_uadd(), because it calls the gc 
function as well when the set is full but there can be timed out entries. 
I'm going to work on a solution with covers that case too.

Best regards,
Jozsef
 
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -527,13 +527,16 @@ mtype_gc(struct timer_list *t)
>  {
>  	struct htype *h = from_timer(h, t, gc);
>  	struct ip_set *set = h->set;
> +	bool busy = false;
>  
>  	pr_debug("called\n");
> -	spin_lock_bh(&set->lock);
> -	mtype_expire(set, h);
> -	spin_unlock_bh(&set->lock);
> +	if (spin_trylock_bh(&set->lock)) {
> +		mtype_expire(set, h);
> +		spin_unlock_bh(&set->lock);
> +	} else
> +		busy = true;
>  
> -	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
> +	h->gc.expires = jiffies + busy ? 1 : IPSET_GC_PERIOD(set->timeout) * HZ;
>  	add_timer(&h->gc);
>  }
>  
> 
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
