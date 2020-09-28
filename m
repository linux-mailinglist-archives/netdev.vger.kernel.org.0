Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B385B27A866
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgI1HRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:17:44 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:52629 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgI1HR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:17:26 -0400
Received: by mail-il1-f206.google.com with SMTP id m1so65833iln.19
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2sEnEYxyNwpEgsimSPXtqWMnn7vsrC2lM97M08ZDK+I=;
        b=aDiHGoT7zNvqBDMog1ZJdk51FvdYIenIJEz6iv5szDaH2Zww6ZyFx/i3aqBnLB0Q1w
         CNlv2F6OoAJ8bw4fjbXva02jpFb/bWhKAk2N5MXnRx2BJw9q3GyV0D3wzhGSeMAwZnPj
         s6z64iPg1SSDdeJDDj0skfJzZ21qocYwoUUPPmatJfiGgB8JrnFXoqKUVfg7fJTBlhcm
         9mnH9ziK8ByFm++av6I/cL0qVMk5cCQvmAL8VHVaEUoQ3Vns/2lhrHD/HMwCi1E70K8V
         1jfwNfDkezWkzHUVMpJejKAeEGVBLVIY4mWOErbXR48oF9J2/m/vA7PxptISATwIn6o+
         fr7A==
X-Gm-Message-State: AOAM532xkcPwm59cZNBTeio7oAtnOoKaCQ4D4ztxG692agie3U/rxyIn
        MBeiMzfMkCAa/dJcHeLipljtIY5NdgYZOQNku5I0okWMePTT
X-Google-Smtp-Source: ABdhPJyMwyH/Mnql2TYZjy3b2buFlRc5CNsFNJxThykpholY53eE5GJuoQLTv7S3EjjVxbKs9rr/TraruyAeYSKnNuIgkVbO01jL
MIME-Version: 1.0
X-Received: by 2002:a92:c083:: with SMTP id h3mr85009ile.30.1601277444526;
 Mon, 28 Sep 2020 00:17:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:17:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044a00505b05a7576@google.com>
Subject: INFO: task hung in tcindex_partial_destroy_work
From:   syzbot <syzbot+e3c2598c1486366a941b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, hauke@hauke-m.de,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    05943249 net: atlantic: fix build when object tree is sepa..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1343b909900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=e3c2598c1486366a941b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a890a7900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16713f03900000

The issue was bisected to:

commit f9317ae5523f99999fb54c513ebabbb2bc887ddf
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Tue Sep 22 21:41:12 2020 +0000

    net: lantiq: Add locking for TX DMA channel

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164c9773900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=154c9773900000
console output: https://syzkaller.appspot.com/x/log.txt?x=114c9773900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e3c2598c1486366a941b@syzkaller.appspotmail.com
Fixes: f9317ae5523f ("net: lantiq: Add locking for TX DMA channel")

INFO: task kworker/u4:6:247 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:6    state:D stack:23816 pid:  247 ppid:     2 flags:0x00004000
Workqueue: tc_filter_workqueue tcindex_partial_destroy_work
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 tcindex_partial_destroy_work+0x13/0x50 net/sched/cls_tcindex.c:287
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
3 locks held by kworker/u4:6/247:
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a639c138 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90001af7da8 ((work_completion)(&(rwork)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: tcindex_partial_destroy_work+0x13/0x50 net/sched/cls_tcindex.c:287
1 lock held by khungtaskd/1171:
 #0: ffffffff8a067f00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
1 lock held by in:imklog/6564:
 #0: ffff8880a9106670 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
3 locks held by kworker/0:0/6861:
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888214cf6938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90001687da8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
1 lock held by syz-executor028/6890:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1171 Comm: khungtaskd Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6890 Comm: syz-executor028 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_kcov_mode kernel/kcov.c:165 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x2a/0x60 kernel/kcov.c:197
Code: 65 48 8b 14 25 c0 fe 01 00 65 8b 05 30 c0 8b 7e a9 00 01 ff 00 48 8b 34 24 74 0f f6 c4 01 74 35 8b 82 2c 14 00 00 85 c0 74 2b <8b> 82 08 14 00 00 83 f8 02 75 20 48 8b 8a 10 14 00 00 8b 92 0c 14
RSP: 0018:ffffc90002cdeb68 EFLAGS: 00000246
RAX: 0000000080000000 RBX: dffffc0000000000 RCX: ffffffff83d84523
RDX: ffff8880a92d2200 RSI: ffffffff83d8452e RDI: 0000000000000007
RBP: 0000000000000001 R08: 0000000000000000 R09: ffff8880a8b0e407
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8880a4b8ccc2
R13: ffff8880a8b0e4d8 R14: 0000000000000002 R15: 0000000000000000
FS:  00000000025b9880(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75ac76d6c0 CR3: 00000000a1c3e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 entry_to_node lib/radix-tree.c:68 [inline]
 __radix_tree_lookup+0x10e/0x290 lib/radix-tree.c:764
 tcf_idr_check_alloc+0xb0/0x3b0 net/sched/act_api.c:501
 tcf_police_init+0x347/0x13a0 net/sched/act_police.c:81
 tcf_action_init_1+0x1ab/0xac0 net/sched/act_api.c:998
 tcf_exts_validate+0x138/0x420 net/sched/cls_api.c:3058
 tcindex_set_parms+0x189/0x20d0 net/sched/cls_tcindex.c:342
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:546
 tc_new_tfilter+0x1398/0x2130 net/sched/cls_api.c:2129
 rtnetlink_rcv_msg+0x80f/0xad0 net/core/rtnetlink.c:5554
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441719
Code: e8 5c ad 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffc27a5578 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441719
RDX: 010efe10675dec16 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007fffc27a5580 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004a2a50
R13: 00000000004025f0 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
