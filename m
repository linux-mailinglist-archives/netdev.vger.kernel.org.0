Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13958257F6C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgHaRRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:17:19 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54191 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgHaRRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:17:18 -0400
Received: by mail-il1-f200.google.com with SMTP id o18so5603442ill.20
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=J4WApu1J9nwefk5AHyau6gXgcwFAWeCBEBAc5J2y57Y=;
        b=fZ3W6zSHxoCU001bTD9ZfBahz1Wn375jZ01dLSZWu22UHIokSQ/NkeuSAdlaVKX/zn
         xgCm83vXo6QtPGiJly4oNA1LCSBZr7e5mgeoAisSpvCr6unJ0Mb03Il40/ml/dPsLaeq
         /jQI0gU7JKKllLfjNWdMh/Is4Xmnrw+veX1ZfMY4IpJSBpWGiO5A5i7St8f5iD+M8Y/r
         Tpklj8X+f1vBqNqNmd6MzGrw2zQjRxh+TKuthvvmI2NYsTvxpP0v2UzHrtUNMQh9I9f2
         TYGZ26tOF4sFJ0jJCm2x3y+LyjFvxis8aKFp5T2B06qbJcOyT5qVPYrELmzV9A70zAUH
         I/ww==
X-Gm-Message-State: AOAM5328i0lhEicsIPr5en7h0Ho5IyYOQLBSraLCJFGiii3x0WivOZ3T
        5FSWRxXuvtEJ+4Kly/L8jDWd0HaP/JQAXb9XlBlPswKfPmqY
X-Google-Smtp-Source: ABdhPJyEUN9kxK5dr6TF3b5oh2U2n76m/HUQpew08ny+z1Bkgg1iMQM4SJNS/uyCyM1HlG43RfbUX/dUm0GQAh6NSZq9p60Hxxgp
MIME-Version: 1.0
X-Received: by 2002:a02:c506:: with SMTP id s6mr2194407jam.104.1598894237372;
 Mon, 31 Aug 2020 10:17:17 -0700 (PDT)
Date:   Mon, 31 Aug 2020 10:17:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d548c05ae2f93ab@google.com>
Subject: possible deadlock in cleanup_net
From:   syzbot <syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com>
To:     christian.brauner@ubuntu.com, daniel@iogearbox.net,
        davem@davemloft.net, gnault@redhat.com, hoang.h.le@dektech.com.au,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b36c9697 Add linux-next specific files for 20200828
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15185cc1900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e3cf99580b5542c
dashboard link: https://syzkaller.appspot.com/bug?extid=d5aa7e0385f6a5d0f4fd
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e9c761900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1051768e900000

The issue was bisected to:

commit fdeba99b1e58ecd18c2940c453e19e4ef20ff591
Author: Hoang Huu Le <hoang.h.le@dektech.com.au>
Date:   Thu Aug 27 02:56:51 2020 +0000

    tipc: fix use-after-free in tipc_bcast_get_mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102cd7c5900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=122cd7c5900000
console output: https://syzkaller.appspot.com/x/log.txt?x=142cd7c5900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Fixes: fdeba99b1e58 ("tipc: fix use-after-free in tipc_bcast_get_mode")

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/349 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (pernet_ops_rwsem){++++}-{3:3}:
       down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
       unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1861
       bcm_release+0x94/0x750 net/can/bcm.c:1474
       __sock_release+0xcd/0x280 net/socket.c:596
       sock_close+0x18/0x20 net/socket.c:1277
       __fput+0x285/0x920 fs/file_table.c:281
       task_work_run+0xdd/0x190 kernel/task_work.c:141
       tracehook_notify_resume include/linux/tracehook.h:188 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
       exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
       syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #2 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}:
       down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
       inode_lock include/linux/fs.h:779 [inline]
       __sock_release+0x86/0x280 net/socket.c:595
       sock_close+0x18/0x20 net/socket.c:1277
       __fput+0x285/0x920 fs/file_table.c:281
       delayed_fput+0x56/0x70 fs/file_table.c:309
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #1 ((delayed_fput_work).work){+.+.}-{0:0}:
       process_one_work+0x8bb/0x1670 kernel/workqueue.c:2245
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #0 ((wq_completion)events){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
       flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
       flush_scheduled_work include/linux/workqueue.h:597 [inline]
       tipc_exit_net+0x47/0x2a0 net/tipc/core.c:116
       ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
       cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

other info that might help us debug this:

Chain exists of:
  (wq_completion)events --> &sb->s_type->i_mutex_key#13 --> pernet_ops_rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***

3 locks held by kworker/u4:6/349:
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a97b1138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc900020e7da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

stack backtrace:
CPU: 1 PID: 349 Comm: kworker/u4:6 Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
 flush_scheduled_work include/linux/workqueue.h:597 [inline]
 tipc_exit_net+0x47/0x2a0 net/tipc/core.c:116
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
