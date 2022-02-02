Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF984A7054
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiBBLv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:51:29 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:54240 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiBBLv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:51:28 -0500
Received: by mail-il1-f197.google.com with SMTP id e15-20020a92de4f000000b002b930c4d727so13846599ilr.20
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 03:51:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Czam2PfI+vECvmB19D4+RWWem8qSnvaySN3xSaozTXs=;
        b=D7bK7p2u21VVkeAH0jm+CmVg5cCq1gC3DB0TMTX6pBTPtDJ6bYaBVtCdeNPmKu3Y92
         /i4eHODtY5ctd57UVZYVMedEnepueJwDdQoTNPuAwFFlv5H9705NrYNiJl+oqvRLYGPE
         LrlLaizfMVcb3ITMqbrNL0JyMlat0GCzvpHovADEcOnQg9FCIoX40gJa0s+ES84swbP+
         zTKV0d6lS/6XMKu01S5eb2XTU6Z3amNOJi92rhPsNkG8Id+evFNjnrghi3q+JiGrhi6C
         5c5OrA5TbYh5Vu3NxpkBrGy+3JcmntSMjTHiUIcSeunGJolWN6M4xb/5BmkP3jpmbW81
         UVVA==
X-Gm-Message-State: AOAM5302s3BzI+jWlW0cxvyVQaOS0JPspC7VknUPHIYV9Wt5gBPV4pKn
        JTF2C03EXVJGlEUTh4hH9D7GVXwKGrvU+okwIL2+AYVVV1Xz
X-Google-Smtp-Source: ABdhPJzCjl2H/uG6VFwYRBIsNpqHTNX0x+oXtlYAGckAIJXlV+ich9wb3aySHYdPpjGigirpYnmfjxDN26ADh8P+f6NktX0xDGwC
MIME-Version: 1.0
X-Received: by 2002:a5e:9507:: with SMTP id r7mr16328334ioj.199.1643802687773;
 Wed, 02 Feb 2022 03:51:27 -0800 (PST)
Date:   Wed, 02 Feb 2022 03:51:27 -0800
In-Reply-To: <00000000000027db6705d6e6e88a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004923a605d707a31a@google.com>
Subject: Re: [syzbot] possible deadlock in ___neigh_create
From:   syzbot <syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com>
To:     daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9f7fb8de5d9b Merge tag 'spi-fix-v5.17-rc2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b5fcf4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4a89edfcc8f7c74
dashboard link: https://syzkaller.appspot.com/bug?extid=5239d0e1778a500d477a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dd62bfb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10581cbfb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.17.0-rc2-syzkaller-00039-g9f7fb8de5d9b #0 Not tainted
--------------------------------------------
kworker/0:1/7 is trying to acquire lock:
ffffffff8d4dd130 (&tbl->lock){+.-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652

but task is already holding lock:
ffffffff8d4dd130 (&tbl->lock){+.-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tbl->lock);
  lock(&tbl->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by kworker/0:1/7:
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: ffffc90000cc7db8 ((work_completion)(&(&tbl->managed_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffffffff8d4dd130 (&tbl->lock){+.-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572
 #3: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: ip6_nd_hdr net/ipv6/ndisc.c:466 [inline]
 #3: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x84b/0x17f0 net/ipv6/ndisc.c:502
 #4: ffffffff8bb83bc0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8bb83bc0 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x2ad/0x14f0 net/ipv6/ip6_output.c:112

stack backtrace:
CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.17.0-rc2-syzkaller-00039-g9f7fb8de5d9b #0
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

