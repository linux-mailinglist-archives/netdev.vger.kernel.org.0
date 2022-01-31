Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD6E4A507B
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243943AbiAaUsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:48:30 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:43879 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbiAaUs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:48:29 -0500
Received: by mail-il1-f198.google.com with SMTP id t8-20020a92c0c8000000b002bc1dbe3a04so3905395ilf.10
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 12:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T9rjZ+M8Y1i2lpTl6W7/0kER7Ge+gG5iNvXt/wJcle8=;
        b=d6CK0Ev0oj9A1e8Sn8y91M4E32XQn4csi1u1+XOPhI/ZCc05kfYL9WMZeHTi2bvtIX
         08n+IC5yLmZswltC8Awif55yc6tXgTJR5vkt4h+bt0h5o5f7vpMDLLITAXQYm8UTrboY
         CPFH6ZlrS1Utp6utbCM3MECEU00qsoNKJH32UFsdJH4KAzRTcnBjLg5DVvCw7QZpgiF9
         vR+bM/RLMJtzu+G0do/z5ws2ldLa+dvM4wrdWBu4cjx/apXy12L88Bz1FO+VJPQ4lttI
         CYPNFb7jEcanCBWTLq3JtWlbVr4AuDBzpUDiNEEwsc+09NnZERBU8OrPAlg1i64yT5LY
         sDAw==
X-Gm-Message-State: AOAM533YA6c230Cq4g4qw9udAZdh/ZSmO27AfhjTcgfnp05Tg0a0N3T7
        x4Ih9HSjylplBRyg+FTcSuaVZO9/908kynhfAMMg77pVbV9/
X-Google-Smtp-Source: ABdhPJz5pmOYq4Mwfg2X0YrpgIxDTixme3aXabI5umXBhD6whhdooP7V0wMm+BCJr4cJWlhDmfwSOk6TYCpHIJGtRaMYO4A/uTVY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24d5:: with SMTP id y21mr5149211jat.115.1643662109299;
 Mon, 31 Jan 2022 12:48:29 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:48:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027db6705d6e6e88a@google.com>
Subject: [syzbot] possible deadlock in ___neigh_create
From:   syzbot <syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com>
To:     daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6449520391df net: stmmac: properly handle with runtime pm ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=111187e0700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6620d0aab7dd315
dashboard link: https://syzkaller.appspot.com/bug?extid=5239d0e1778a500d477a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.17.0-rc1-syzkaller-00210-g6449520391df #0 Not tainted
--------------------------------------------
kworker/0:16/14617 is trying to acquire lock:
ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652

but task is already holding lock:
ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tbl->lock);
  lock(&tbl->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by kworker/0:16/14617:
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: ffffc9000293fdb8 ((work_completion)(&(&tbl->managed_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572
 #3: ffffffff8bb83ae0 (rcu_read_lock){....}-{1:2}, at: ip6_nd_hdr net/ipv6/ndisc.c:466 [inline]
 #3: ffffffff8bb83ae0 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x84b/0x17f0 net/ipv6/ndisc.c:502
 #4: ffffffff8bb83a80 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8bb83a80 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x2ad/0x14f0 net/ipv6/ip6_output.c:112

stack backtrace:
CPU: 0 PID: 14617 Comm: kworker/0:16 Not tainted 5.17.0-rc1-syzkaller-00210-g6449520391df #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient neigh_managed_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
 check_deadlock kernel/locking/lockdep.c:2999 [inline]
 validate_chain kernel/locking/lockdep.c:3788 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
 _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:334
 ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
 ip6_finish_output2+0x1070/0x14f0 net/ipv6/ip6_output.c:123
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
 ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:451 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
 ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
 ndisc_solicit+0x2cd/0x4f0 net/ipv6/ndisc.c:742
 neigh_probe+0xc2/0x110 net/core/neighbour.c:1040
 __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1201
 neigh_event_send include/net/neighbour.h:470 [inline]
 neigh_managed_work+0x162/0x250 net/core/neighbour.c:1574
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
