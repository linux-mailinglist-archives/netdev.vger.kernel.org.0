Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048D6258325
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgHaU6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:58:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49422 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgHaU6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:58:16 -0400
Received: by mail-io1-f71.google.com with SMTP id k133so4968549iof.16
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 13:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kTY+Uwg3ib3S5RkkgseOAR+2XsswT5YnxR3cu10Okqo=;
        b=RGs5r3fjy8pqgs0otaEY4zRrTZebiW1KP4vbMbWLbKdzHmR68fbWqujB57nzZqhVh/
         U1/xg8oDgTyRKNxmLgclUvDIba/MJU3M4dWbKlDXPCPvmdTyqlxAdxnOgkRwjNj1MeCN
         X2AV6qe2eGTpst21HYZsjtyw8V+G/EV0rHXNgQB8/X2hEXzP5rA9oA/P4uW/sSOvXnbc
         N3i6/Fgl/Ns9sI8Pxs8Boj2CO1X4/q9BJEujU1NbE8OcULYRt6U5KDTL+pgG2WJcqWRA
         zLAEZQLll8sNwdgqQcdPNZ7UHPjfLHhGN0lLY3WJ+pMM1k0aFfUebZoXcxp4UvkQWqsK
         +mrg==
X-Gm-Message-State: AOAM530pDnnbKfLrzWD/r5CZFbMevEIbSMB4wDb4artXNQP4dfKljn5e
        hKTUtjq9peHhMHoL0TVU3hKcw9WZ+T/tXDB/uVlxw3T40wP2
X-Google-Smtp-Source: ABdhPJza5y0DWIIomP+16EQJ4eYa7Z00iwEGl0MnxX10Ys8IO1mKh11DV3jIi99vbgsFw+ASRq+NNRSE1R7jR6wOVjoxglk1Bbmp
MIME-Version: 1.0
X-Received: by 2002:a92:1b48:: with SMTP id b69mr516771ilb.63.1598907494739;
 Mon, 31 Aug 2020 13:58:14 -0700 (PDT)
Date:   Mon, 31 Aug 2020 13:58:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000040b7ba05ae32a94a@google.com>
Subject: possible deadlock in __sock_release
From:   syzbot <syzbot+8e467b009209f1fcf666@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b36c9697 Add linux-next specific files for 20200828
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10bf2835900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e3cf99580b5542c
dashboard link: https://syzkaller.appspot.com/bug?extid=8e467b009209f1fcf666
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12be1435900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f77ad1900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8e467b009209f1fcf666@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/0:4/7108 is trying to acquire lock:
ffff888085730c90 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:779 [inline]
ffff888085730c90 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:595

but task is already holding lock:
ffffc90006037da8 ((delayed_fput_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((delayed_fput_work).work){+.+.}-{0:0}:
       process_one_work+0x8bb/0x1670 kernel/workqueue.c:2245
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #2 ((wq_completion)events){+.+.}-{0:0}:
       flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
       flush_scheduled_work include/linux/workqueue.h:597 [inline]
       tipc_exit_net+0x47/0x2a0 net/tipc/core.c:116
       ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
       cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
       process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
       worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
       kthread+0x3b5/0x4a0 kernel/kthread.c:292
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> #1 (pernet_ops_rwsem){++++}-{3:3}:
       down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
       unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1861
       raw_release+0x58/0x890 net/can/raw.c:354
       __sock_release+0xcd/0x280 net/socket.c:596
       sock_close+0x18/0x20 net/socket.c:1277
       __fput+0x285/0x920 fs/file_table.c:281
       task_work_run+0xdd/0x190 kernel/task_work.c:141
       tracehook_notify_resume include/linux/tracehook.h:188 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
       exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
       syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
       lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
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

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#13 --> (wq_completion)events --> (delayed_fput_work).work

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((delayed_fput_work).work);
                               lock((wq_completion)events);
                               lock((delayed_fput_work).work);
  lock(&sb->s_type->i_mutex_key#13);

 *** DEADLOCK ***

2 locks held by kworker/0:4/7108:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90006037da8 ((delayed_fput_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244

stack backtrace:
CPU: 0 PID: 7108 Comm: kworker/0:4 Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events delayed_fput
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a6b/0x5640 kernel/locking/lockdep.c:4426
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
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


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
