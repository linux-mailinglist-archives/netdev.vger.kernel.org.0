Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB4034D538
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhC2Qel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:34:41 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52710 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhC2QeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:34:21 -0400
Received: by mail-io1-f69.google.com with SMTP id d4so1936569iop.19
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EKuiOPYTZa4B8SPETRVs18Sra54epZFcURNdr8lsLZk=;
        b=iGtLt1DHUotN0coA9VO0+IciDqYXL9szOtXh8ZiDJSDRISB3OnKSW85BMtJzIHhE2F
         i1YfHoI5CebHoGT8gvZYK+9zgxbhNKhNewqiGu83QbDKJeVwRwfhC20kqvxIBbMaZMgT
         lN6q4WgQiPo+JGm7aICjETLpzI+XriTsNLJa47mlBfTXLFg3x506V3t8sfASwMdPztD7
         YnfVQW+nAI2S3bZuRwNur2APEK+3Lc097OVTxjgQwk0j1iJo/LS9kExKQHO3VVRsAWxT
         FSt0TT2xWl4QLUoj/dOLBRNPkz2jkh+elLDTlx/O0hTPfKeXr2BnBx4kuLHyhuKsidNX
         w9nw==
X-Gm-Message-State: AOAM532eRZgV/eo2vBmMVaSGvFu7ss5CpVou1Aj6Q/fC3RLs1IMp3Svf
        ZLJvptLU+vFdwV+Ye5j6GRbmUJkmea7q+C5yXf9vkod0wpTM
X-Google-Smtp-Source: ABdhPJwBcegClubRSEuQMfIu8Ma8uOkKXwBOk5CFQQGzEn1vWpnEDKfvOcKviQcmTzYc8Oprx4eGpapgneGT+wd6gOZLbWf2oG1l
MIME-Version: 1.0
X-Received: by 2002:a02:aa92:: with SMTP id u18mr24915975jai.119.1617035661435;
 Mon, 29 Mar 2021 09:34:21 -0700 (PDT)
Date:   Mon, 29 Mar 2021 09:34:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003069fb05beaf74a4@google.com>
Subject: [syzbot] INFO: task can't die in msleep
From:   syzbot <syzbot+3a9c5d436cf1afce2cd6@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b4f20b70 Add linux-next specific files for 20210325
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e6bb06d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7d6f0d01f04bcd8
dashboard link: https://syzkaller.appspot.com/bug?extid=3a9c5d436cf1afce2cd6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105da362d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a6978ad00000

The issue was bisected to:

commit 766b0515d5bec4b780750773ed3009b148df8c0a
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Wed Jan 6 18:40:07 2021 +0000

    net: make sure devices go through netdev_wait_all_refs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124939aad00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=114939aad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=164939aad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3a9c5d436cf1afce2cd6@syzkaller.appspotmail.com
Fixes: 766b0515d5be ("net: make sure devices go through netdev_wait_all_refs")

INFO: task syz-executor638:25158 can't die for more than 143 seconds.
task:syz-executor638 state:D stack:26512 pid:25158 ppid:  8420 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4329 [inline]
 __schedule+0x911/0x2160 kernel/sched/core.c:5079
 schedule+0xcf/0x270 kernel/sched/core.c:5158
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1878
 schedule_timeout_uninterruptible kernel/time/timer.c:1912 [inline]
 msleep+0xa4/0xf0 kernel/time/timer.c:2032
 netdev_wait_allrefs net/core/dev.c:10457 [inline]
 netdev_run_todo+0x9e8/0xe10 net/core/dev.c:10538
 register_netdev+0x35/0x50 net/core/dev.c:10381
 sit_init_net+0x3a4/0xac0 net/ipv6/sit.c:1917
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:333
 copy_net_ns+0x31e/0x760 net/core/net_namespace.c:474
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x385/0x440 kernel/nsproxy.c:178
 copy_process+0x2bfe/0x71b0 kernel/fork.c:2111
 kernel_clone+0xe7/0xab0 kernel/fork.c:2501
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2618
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44da69
RSP: 002b:00007fd03f038318 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00000000004cb4a8 RCX: 000000000044da69
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000200
RBP: 00000000004cb4a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cb4ac
R13: 00007ffc9cc08d4f R14: 00007fd03f038400 R15: 0000000000022000

Showing all locks held in the system:
5 locks held by kworker/u4:8/422:
1 lock held by khungtaskd/1638:
 #0: ffffffff8bf75360 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6333
2 locks held by in:imklog/8122:
 #0: ffff888014d1eff0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
 #1: ffff8880b9d35218 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1329 [inline]
 #1: ffff8880b9d35218 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x2160 kernel/sched/core.c:4996
3 locks held by kworker/0:0/8498:
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90001a0fda8 (fqdir_free_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8bf7e470 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x44/0x430 kernel/rcu/tree.c:4018
2 locks held by kworker/1:12/10637:
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b3afda8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by syz-executor638/25158:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: netdev_wait_allrefs net/core/dev.c:10428 [inline]
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: netdev_run_todo+0xa13/0xe10 net/core/dev.c:10538
1 lock held by syz-executor638/1031:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
2 locks held by syz-executor638/1086:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: cangw_pernet_exit+0xe/0x20 net/can/gw.c:1241
2 locks held by syz-executor638/1091:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x22/0x360 net/sched/act_gate.c:624
2 locks held by syz-executor638/1113:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: fib6_rules_net_exit+0xe/0x50 net/ipv6/fib6_rules.c:496
2 locks held by syz-executor638/1198:
 #0: ffffffff8d674910 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2fa/0x760 net/core/net_namespace.c:470
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:799 [inline]
 #1: ffffffff8d6883e8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x245/0x400 net/smc/smc_pnet.c:868

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
