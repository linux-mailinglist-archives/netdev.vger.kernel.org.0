Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E103FFF85
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349336AbhICMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:05:14 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:52965 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349280AbhICMFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:05:12 -0400
Received: by mail-io1-f70.google.com with SMTP id e18-20020a6b7312000000b005be766a70dbso3662485ioh.19
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 05:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/fhLtTMWX+YkLat1Pf8WyLw6nCwFWCGtGLW4T/NoWzo=;
        b=XUQT2XZDDj55fMy5Jb9pkg1y6f6vimRmXNPlZtorluCemAqHoAvieQCHO9XqW8mUr0
         lruMVF1ohVXxGBfovNrT38/RRsTqsDbIvBZhn34mSEHl0THhuv7lJ3gk0iQ8VaSN7JHb
         z0UG+OVz3J2h9HMVwDvsW5hb/iyTD8fAiKYGoZks8roxTsI2pJDhitoiOmEgwsLODhmi
         UqxUWw9JQJr7nVaJufPzXa9pssEDssOmXi/tCvNkIoihRpfJ2wWNVJW3Py+Xhp0LQY+f
         6sCuBc+3ekSccKdz55WidhBX6tPyPfeMZHrwoqVmJmD+QE1Hfg+Op/C64lzo/oBs4Pkt
         xW4Q==
X-Gm-Message-State: AOAM531kY6hJQfOkVPFWV3ISAUT8bCQoQDkhLEn/EM2ZK+Nk1F++Yk0Q
        bLy6zIvfsWCNxvDKneWgiz+sdDtMlBDP8Y+veWXQNzuvw1Il
X-Google-Smtp-Source: ABdhPJwRFeeFYeaGNc8dXyz155gF4Qsx41NEvam+wq1fj38Ro4spceicn61CBkiePl/6zKrCeuGUsK7EmPjL7soIdGqqFoPk+kRg
MIME-Version: 1.0
X-Received: by 2002:a92:8742:: with SMTP id d2mr2365263ilm.58.1630670652761;
 Fri, 03 Sep 2021 05:04:12 -0700 (PDT)
Date:   Fri, 03 Sep 2021 05:04:12 -0700
In-Reply-To: <20210903111011.2811-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000000ed7b05cb161911@google.com>
Subject: Re: [syzbot] INFO: task hung in __lru_add_drain_all
From:   syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>
To:     eric.dumazet@gmail.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in synchronize_rcu

INFO: task kworker/u4:3:57 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:26128 pid:   57 ppid:     2 flags:0x00004000
Workqueue: events_unbound fsnotify_mark_destroy_workfn
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 __synchronize_srcu+0x1f4/0x290 kernel/rcu/srcutree.c:930
 fsnotify_mark_destroy_workfn+0xfd/0x340 fs/notify/mark.c:832
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
3 locks held by kworker/0:1/7:
2 locks held by ksoftirqd/0/13:
2 locks held by kworker/u4:3/57:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90000f9fdb0 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
2 locks held by kworker/u4:4/129:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc900013afdb0 (connector_reaper_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
1 lock held by khungtaskd/1647:
 #0: ffffffff8b97ba40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by khugepaged/1662:
 #0: ffffffff8ba5e948 (lock#6){+.+.}-{3:3}, at: __lru_add_drain_all+0x65/0x760 mm/swap.c:791
1 lock held by systemd-udevd/4873:
1 lock held by in:imklog/8269:
 #0: ffff888011d9cd70 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
3 locks held by kworker/1:7/10141:
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff88802757d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc9000a747db0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d0cc6a8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1340 net/ipv6/addrconf.c:4031
4 locks held by kworker/u4:7/16665:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1647 Comm: khungtaskd Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:match_held_lock+0xe/0xc0 kernel/locking/lockdep.c:5077
Code: 48 c7 c7 40 db 8b 89 e8 66 7a be ff e8 cd 1a cd ff 31 c0 5d c3 0f 1f 80 00 00 00 00 53 48 89 fb 48 83 ec 08 48 39 77 10 74 6a <66> f7 47 22 f0 ff 74 5a 48 8b 46 08 48 89 f7 48 85 c0 74 42 8b 15
RSP: 0018:ffffc90000d27410 EFLAGS: 00000093
RAX: 0000000000000005 RBX: ffff888010a68a18 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8d0cc6a8 RDI: ffff888010a68a18
RBP: ffffffff8d0cc6a8 R08: ffffc90000d276d8 R09: ffffc90000d276c8
R10: ffffffff87d55c4a R11: 0000000000000000 R12: ffff888010a68000
R13: ffff888010a689f0 R14: 00000000ffffffff R15: ffff888010a68a18
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000052f7b0 CR3: 000000001d209000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __lock_is_held kernel/locking/lockdep.c:5368 [inline]
 lock_is_held_type+0xa7/0x140 kernel/locking/lockdep.c:5668
 lock_is_held include/linux/lockdep.h:283 [inline]
 lockdep_rtnl_is_held+0x17/0x30 net/core/rtnetlink.c:137
 __in6_dev_get include/net/addrconf.h:313 [inline]
 ip6_ignore_linkdown include/net/addrconf.h:404 [inline]
 find_match.part.0+0x78/0xcc0 net/ipv6/route.c:737
 find_match net/ipv6/route.c:824 [inline]
 __find_rr_leaf+0x17f/0xd20 net/ipv6/route.c:825
 find_rr_leaf net/ipv6/route.c:846 [inline]
 rt6_select net/ipv6/route.c:890 [inline]
 fib6_table_lookup+0x649/0xa20 net/ipv6/route.c:2174
 ip6_pol_route+0x1c5/0x11d0 net/ipv6/route.c:2210
 pol_lookup_func include/net/ip6_fib.h:579 [inline]
 fib6_rule_lookup+0x111/0x6f0 net/ipv6/fib6_rules.c:115
 ip6_route_input_lookup net/ipv6/route.c:2280 [inline]
 ip6_route_input+0x63c/0xb30 net/ipv6/route.c:2576
 ip6_rcv_finish_core.constprop.0.isra.0+0x168/0x570 net/ipv6/ip6_input.c:63
 ip6_rcv_finish net/ipv6/ip6_input.c:74 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x229/0x3c0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5498
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5612
 process_backlog+0x2a5/0x6c0 net/core/dev.c:6492
 __napi_poll+0xaf/0x440 net/core/dev.c:7047
 napi_poll net/core/dev.c:7114 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7201
 __do_softirq+0x292/0xa27 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:923 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:915
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	48 c7 c7 40 db 8b 89 	mov    $0xffffffff898bdb40,%rdi
   7:	e8 66 7a be ff       	callq  0xffbe7a72
   c:	e8 cd 1a cd ff       	callq  0xffcd1ade
  11:	31 c0                	xor    %eax,%eax
  13:	5d                   	pop    %rbp
  14:	c3                   	retq
  15:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  1c:	53                   	push   %rbx
  1d:	48 89 fb             	mov    %rdi,%rbx
  20:	48 83 ec 08          	sub    $0x8,%rsp
  24:	48 39 77 10          	cmp    %rsi,0x10(%rdi)
  28:	74 6a                	je     0x94
* 2a:	66 f7 47 22 f0 ff    	testw  $0xfff0,0x22(%rdi) <-- trapping instruction
  30:	74 5a                	je     0x8c
  32:	48 8b 46 08          	mov    0x8(%rsi),%rax
  36:	48 89 f7             	mov    %rsi,%rdi
  39:	48 85 c0             	test   %rax,%rax
  3c:	74 42                	je     0x80
  3e:	8b                   	.byte 0x8b
  3f:	15                   	.byte 0x15


Tested on:

commit:         c7d10223 Merge tag 'net-5.14-rc4' of git://git.kernel...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15c81b33300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bfd78f4abd4edaa6
dashboard link: https://syzkaller.appspot.com/bug?extid=a9b681dcbc06eb2bca04
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13983115300000

