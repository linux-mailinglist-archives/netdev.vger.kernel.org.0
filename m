Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25CE400A96
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhIDJTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 05:19:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40910 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhIDJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 05:19:17 -0400
Received: by mail-io1-f71.google.com with SMTP id i26-20020a5e851a000000b005bb55343e9bso1153392ioj.7
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 02:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wuygMjKpui/5Jp1GW19pmXZYMaAIg3AN6x3yHD7X2RI=;
        b=CcSMA+5zXujU/uKbs+DFKA69IP57S/fCFkLyLagMMce6Won0rvEsPAmZyLB17+S306
         sa2f2OQdpyn6+B7bo/bLHsKq6STAU3qYVx2oZ5nXNjG3mla6E5v22bZhu/DtCbpCFAO7
         u92FUyPTEMXo+dzkbiPcZV/Hv9wXHJixKFAgmzQSBuMZtorOvwbkgz66YfsGlGNmYTij
         ZtWGSF7u4u0aNkrOBxzNWbkVyKda/Cu2oIDt1JsjkcrEwg/zCjvqRrX6WAOPzEChcMHG
         fe/nmeoTYlIiBffw9uOD2wQ7o5M6JYFZkW61+eVa86qBvHoEh+cOIxy6jx1Ym7wmy40c
         wRzQ==
X-Gm-Message-State: AOAM531DBGVQwNRsV1BpxzP+MEY6HyH9GCldaFIa3PJRfDGxsFeHDc0n
        VkIhJMa4sB68RAR+44EdaJuFS2qdLdgLwo102G8QOPhcClv1
X-Google-Smtp-Source: ABdhPJywEVIZdqnQcPsYk8BQqFbHBEahEnMNwNuu8dy3OrdOYDb3AdBnKH5NrneQJxrZJ6KFut5T8dyvRBVTCuChUi5iIhjA5H0c
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2297:: with SMTP id y23mr2557981jas.105.1630747096187;
 Sat, 04 Sep 2021 02:18:16 -0700 (PDT)
Date:   Sat, 04 Sep 2021 02:18:16 -0700
In-Reply-To: <20210904080739.3026-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006309ef05cb27e5b9@google.com>
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
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:24944 pid:   57 ppid:     2 flags:0x00004000
Workqueue: events_unbound fsnotify_mark_destroy_workfn
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 __synchronize_srcu+0x1f4/0x290 kernel/rcu/srcutree.c:930
 fsnotify_mark_destroy_workfn+0xfd/0x340 fs/notify/mark.c:860
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 process_scheduled_works kernel/workqueue.c:2360 [inline]
 worker_thread+0x85c/0x11f0 kernel/workqueue.c:2446
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 1649 Comm: khungtaskd Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 4027 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
Code: 01 f0 4d 89 03 e9 63 fd ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 0f 1f 00 <65> 8b 05 39 d2 8b 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc90014246c50 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff8880600a5580
RDX: 0000000000000000 RSI: ffff8880600a5580 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000002f R09: 0000000000000000
R10: ffffffff83f5086c R11: 0000000000000000 R12: ffffc90014246fd6
R13: ffff88802e928008 R14: ffffc90014246fe0 R15: ffffc90014246fd6
FS:  00007f0e855b9700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000052f7b0 CR3: 00000000532b1000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 number+0x16a/0xae0 lib/vsprintf.c:465
 vsnprintf+0xf09/0x14f0 lib/vsprintf.c:2863
 snprintf+0xbb/0xf0 lib/vsprintf.c:2930
 __dev_alloc_name net/core/dev.c:1126 [inline]
 dev_alloc_name_ns+0x3a4/0x6b0 net/core/dev.c:1154
 dev_get_valid_name+0x67/0x160 net/core/dev.c:1189
 register_netdevice+0x361/0x1500 net/core/dev.c:10214
 ipvlan_link_new+0x39b/0xc00 drivers/net/ipvlan/ipvlan_main.c:586
 __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0e855b9188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffdedf0960f R14: 00007f0e855b9300 R15: 0000000000022000
----------------
Code disassembly (best guess):
   0:	01 f0                	add    %esi,%eax
   2:	4d 89 03             	mov    %r8,(%r11)
   5:	e9 63 fd ff ff       	jmpq   0xfffffd6d
   a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   f:	ba 08 00 00 00       	mov    $0x8,%edx
  14:	4d 8b 03             	mov    (%r11),%r8
  17:	48 0f bd ca          	bsr    %rdx,%rcx
  1b:	49 8b 45 00          	mov    0x0(%r13),%rax
  1f:	48 63 c9             	movslq %ecx,%rcx
  22:	e9 64 ff ff ff       	jmpq   0xffffff8b
  27:	0f 1f 00             	nopl   (%rax)
* 2a:	65 8b 05 39 d2 8b 7e 	mov    %gs:0x7e8bd239(%rip),%eax        # 0x7e8bd26a <-- trapping instruction
  31:	89 c1                	mov    %eax,%ecx
  33:	48 8b 34 24          	mov    (%rsp),%rsi
  37:	81 e1 00 01 00 00    	and    $0x100,%ecx
  3d:	65                   	gs
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


Tested on:

commit:         f1583cb1 Merge tag 'linux-kselftest-next-5.15-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123f2ab9300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c582b69de20dde2
dashboard link: https://syzkaller.appspot.com/bug?extid=a9b681dcbc06eb2bca04
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12e12515300000

