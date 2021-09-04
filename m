Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42432400C37
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbhIDRFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 13:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhIDRFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 13:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE57E604AC;
        Sat,  4 Sep 2021 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630775073;
        bh=jQN9pOa2utEvgUjmJfKKFlymJ0+U5btYFHiOwwd6sEo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=NEO2r82D93lRejpL1iRy8IjWt/246f+rArW5i3BNzXjGqHg7VLuAjuI76vXKvPl+K
         5kjlWI9LwCkyYWDw1fJsc2wjqEZUSUKYm8qs2/c+5oJ8EwQtBs1f+SBQhWxNSWqrvw
         puTQghAyquBGKrhsSZkQEiQ7fKbnkjVWbqYHpmSTFExMSFHNoQYd4ByuQMtxnnBVEv
         8c7iqIsbS3145YQiB3fcTmhKQ5j6QVJ2Qjco9halGcFvuDZkqfLYIun6oVR6j7SL3u
         qiBHLDYiZrqrSExn1adylnJY60j/frbrxKBdz9NGPYb7MNHDieZfYqsxbdg/MF2TlN
         5/2l/BEkhD9jg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 91F3F5C0546; Sat,  4 Sep 2021 10:04:33 -0700 (PDT)
Date:   Sat, 4 Sep 2021 10:04:33 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>,
        eric.dumazet@gmail.com, Jan Kara <jack@suse.cz>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] INFO: task hung in __lru_add_drain_all
Message-ID: <20210904170433.GX4156@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210904080739.3026-1-hdanton@sina.com>
 <20210904104951.3084-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210904104951.3084-1-hdanton@sina.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 04, 2021 at 06:49:51PM +0800, Hillf Danton wrote:
> On Sat, 04 Sep 2021 02:18:16 -0700
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > INFO: task hung in synchronize_rcu
> 
> Could you please take a look at this report, Jan and Paul?
> 
> Thanks
> Hillf
> > 
> > INFO: task kworker/u4:3:57 blocked for more than 143 seconds.
> >       Not tainted 5.14.0-syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:kworker/u4:3    state:D stack:24944 pid:   57 ppid:     2 flags:0x00004000
> > Workqueue: events_unbound fsnotify_mark_destroy_workfn
> > Call Trace:
> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x940/0x26f0 kernel/sched/core.c:6287
> >  schedule+0xd3/0x270 kernel/sched/core.c:6366
> >  schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
> >  do_wait_for_common kernel/sched/completion.c:85 [inline]
> >  __wait_for_common kernel/sched/completion.c:106 [inline]
> >  wait_for_common kernel/sched/completion.c:117 [inline]
> >  wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
> >  __synchronize_srcu+0x1f4/0x290 kernel/rcu/srcutree.c:930
> >  fsnotify_mark_destroy_workfn+0xfd/0x340 fs/notify/mark.c:860
> >  process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
> >  process_scheduled_works kernel/workqueue.c:2360 [inline]
> >  worker_thread+0x85c/0x11f0 kernel/workqueue.c:2446
> >  kthread+0x3e5/0x4d0 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > INFO: lockdep is turned off.
> > NMI backtrace for cpu 1
> > CPU: 1 PID: 1649 Comm: khungtaskd Not tainted 5.14.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
> >  nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
> >  nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
> >  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
> >  check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
> >  watchdog+0xc1d/0xf50 kernel/hung_task.c:295
> >  kthread+0x3e5/0x4d0 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > Sending NMI from CPU 1 to CPUs 0:
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 4027 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
> > RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
> > RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
> > Code: 01 f0 4d 89 03 e9 63 fd ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 0f 1f 00 <65> 8b 05 39 d2 8b 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
> > RSP: 0018:ffffc90014246c50 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff8880600a5580
> > RDX: 0000000000000000 RSI: ffff8880600a5580 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 000000000000002f R09: 0000000000000000
> > R10: ffffffff83f5086c R11: 0000000000000000 R12: ffffc90014246fd6
> > R13: ffff88802e928008 R14: ffffc90014246fe0 R15: ffffc90014246fd6
> > FS:  00007f0e855b9700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000052f7b0 CR3: 00000000532b1000 CR4: 00000000001506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  number+0x16a/0xae0 lib/vsprintf.c:465
> >  vsnprintf+0xf09/0x14f0 lib/vsprintf.c:2863
> >  snprintf+0xbb/0xf0 lib/vsprintf.c:2930

The above three return addresses usually mean that the kernel is printing
console messages faster than they can be accommodated.  For example,
serial lines (even ones traditionally considered to be fast) get you here
quite easily.  Running a bunch of guest OSes all spewing console messages
can overrun many combinations of file systems and mass-storage devices
(and don't even get me started on NFS!).

My advice is:

1.	Get a faster path for your console output.

2.	Reduce the amount of console output being produced.

3.	Figure out what console output is overrunning your
	console setup and fix whatever is spewing so much
	output.

							Thanx, Paul

> >  __dev_alloc_name net/core/dev.c:1126 [inline]
> >  dev_alloc_name_ns+0x3a4/0x6b0 net/core/dev.c:1154
> >  dev_get_valid_name+0x67/0x160 net/core/dev.c:1189
> >  register_netdevice+0x361/0x1500 net/core/dev.c:10214
> >  ipvlan_link_new+0x39b/0xc00 drivers/net/ipvlan/ipvlan_main.c:586
> >  __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
> >  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
> >  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
> >  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
> >  sock_sendmsg_nosec net/socket.c:704 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:724
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x4665e9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f0e855b9188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
> > RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
> > RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> > R13: 00007ffdedf0960f R14: 00007f0e855b9300 R15: 0000000000022000
> > ----------------
> > Code disassembly (best guess):
> >    0:	01 f0                	add    %esi,%eax
> >    2:	4d 89 03             	mov    %r8,(%r11)
> >    5:	e9 63 fd ff ff       	jmpq   0xfffffd6d
> >    a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
> >    f:	ba 08 00 00 00       	mov    $0x8,%edx
> >   14:	4d 8b 03             	mov    (%r11),%r8
> >   17:	48 0f bd ca          	bsr    %rdx,%rcx
> >   1b:	49 8b 45 00          	mov    0x0(%r13),%rax
> >   1f:	48 63 c9             	movslq %ecx,%rcx
> >   22:	e9 64 ff ff ff       	jmpq   0xffffff8b
> >   27:	0f 1f 00             	nopl   (%rax)
> > * 2a:	65 8b 05 39 d2 8b 7e 	mov    %gs:0x7e8bd239(%rip),%eax        # 0x7e8bd26a <-- trapping instruction
> >   31:	89 c1                	mov    %eax,%ecx
> >   33:	48 8b 34 24          	mov    (%rsp),%rsi
> >   37:	81 e1 00 01 00 00    	and    $0x100,%ecx
> >   3d:	65                   	gs
> >   3e:	48                   	rex.W
> >   3f:	8b                   	.byte 0x8b
> > 
> > 
> > Tested on:
> > 
> > commit:         f1583cb1 Merge tag 'linux-kselftest-next-5.15-rc1' of ..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=123f2ab9300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9c582b69de20dde2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a9b681dcbc06eb2bca04
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> > patch:          https://syzkaller.appspot.com/x/patch.diff?x=12e12515300000
> > 
