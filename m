Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC9B481BA5
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 12:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhL3LQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 06:16:19 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:40605 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhL3LQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 06:16:19 -0500
Received: by mail-io1-f70.google.com with SMTP id d12-20020a0566022d4c00b005ebda1035b1so10809021iow.7
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 03:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DdJiJoPMs+seIe/UgA1bIYn2fRdIJapWUjI6wsJZCN8=;
        b=mUZZbFlg0H6RtdtnQFHiCtEdpJ4vhk5soRHHSoMYMQfSk7EU99B77kBd6MciOnD5og
         bdwZvOHfkP53DYgid9n7AJY9pSN+HZ511nLYGtcN/BE5R3PDonW8ve+sqT9g+kXnm5Ml
         r55G/koKrE8lV+FNUJqOIcsZG5m1WX4kjr5zvErw2hU4js5Fcb1yWeko3bTgjfVELRgr
         Ef5FjB4K0Cf2su3kF+Y3eTB4C98i/KvGN1Lp69vED2YmE1KjeSU5oYLXohN5JMp1Pywt
         UmR6LUvUHWiDi+L/Cfrz1KRoOEIV/0xyXvccHF7WVhTNY5vbr85rhIi0X85Tv7/uKP6K
         PJMw==
X-Gm-Message-State: AOAM530CkfNL8+MxcFiMU9wR+jAgk1+nbTWA2a/oqWkgnxireDAueJiw
        8wVjbF5st4v4HPv85zmw0gVxl1cVNUevpwKDjkjBtJhh6Iv0
X-Google-Smtp-Source: ABdhPJy0wQDKCuupOF+1E8CdNjesed8oiEjqUOWtW2mA+Ff/pNSJ3245T8fDhRItTv5eTj27S6pHCw1QKR24GBoE8xllLzpulSBf
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3815:: with SMTP id i21mr13781136jav.39.1640862978601;
 Thu, 30 Dec 2021 03:16:18 -0800 (PST)
Date:   Thu, 30 Dec 2021 03:16:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6fa5905d45b2ea5@google.com>
Subject: [syzbot] possible deadlock in genl_rcv (3)
From:   syzbot <syzbot+3feee90fde88bc16f893@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fw@strlen.de, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    438645193e59 Merge tag 'pinctrl-v5.16-3' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f67afbb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb2fb6a50dc0ed30
dashboard link: https://syzkaller.appspot.com/bug?extid=3feee90fde88bc16f893
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3feee90fde88bc16f893@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.16.0-rc6-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/17763 is trying to acquire lock:
ffffffff8d39eb90 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802

but task is already holding lock:
ffff888018a81868 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock_nested fs/pipe.c:81 [inline]
ffff888018a81868 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock+0x5a/0x70 fs/pipe.c:89

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&pipe->mutex/1){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:607 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:740
       pipe_lock_nested fs/pipe.c:81 [inline]
       pipe_lock+0x5a/0x70 fs/pipe.c:89
       iter_file_splice_write+0x15a/0xc10 fs/splice.c:635
       ovl_splice_write+0x4b2/0xde0 fs/overlayfs/file.c:451
       do_splice_from fs/splice.c:767 [inline]
       do_splice+0xb7e/0x1960 fs/splice.c:1079
       __do_splice+0x134/0x250 fs/splice.c:1144
       __do_sys_splice fs/splice.c:1350 [inline]
       __se_sys_splice fs/splice.c:1332 [inline]
       __x64_sys_splice+0x198/0x250 fs/splice.c:1332
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #6 (sb_writers#3){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1810 [inline]
       sb_start_write include/linux/fs.h:1880 [inline]
       file_start_write include/linux/fs.h:3008 [inline]
       lo_write_bvec drivers/block/loop.c:242 [inline]
       lo_write_simple drivers/block/loop.c:265 [inline]
       do_req_filebacked drivers/block/loop.c:494 [inline]
       loop_handle_cmd drivers/block/loop.c:1857 [inline]
       loop_process_work+0x1499/0x1db0 drivers/block/loop.c:1897
       process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
       worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
       kthread+0x405/0x4f0 kernel/kthread.c:327
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #5 ((work_completion)(&worker->work)){+.+.}-{0:0}:
       process_one_work+0x921/0x1690 kernel/workqueue.c:2274
       worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
       kthread+0x405/0x4f0 kernel/kthread.c:327
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #4 ((wq_completion)loop3){+.+.}-{0:0}:
       flush_workqueue+0x110/0x15b0 kernel/workqueue.c:2818
       drain_workqueue+0x1a5/0x3c0 kernel/workqueue.c:2983
       destroy_workqueue+0x71/0x800 kernel/workqueue.c:4420
       __loop_clr_fd+0x1de/0x1070 drivers/block/loop.c:1124
       lo_release+0x1ac/0x1f0 drivers/block/loop.c:1761
       blkdev_put_whole block/bdev.c:694 [inline]
       blkdev_put+0x2de/0x980 block/bdev.c:957
       blkdev_close+0x6a/0x80 block/fops.c:515
       __fput+0x286/0x9f0 fs/file_table.c:280
       task_work_run+0xdd/0x1a0 kernel/task_work.c:164
       tracehook_notify_resume include/linux/tracehook.h:189 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
       exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
       __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
       syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
       do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #3 (&lo->lo_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:607 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:740
       lo_open+0x75/0x120 drivers/block/loop.c:1733
       blkdev_get_whole+0x99/0x2d0 block/bdev.c:671
       blkdev_get_by_dev.part.0+0x5c6/0xc70 block/bdev.c:826
       blkdev_get_by_dev+0x6b/0x80 block/bdev.c:860
       blkdev_open+0x154/0x2e0 block/fops.c:501
       do_dentry_open+0x4c8/0x1250 fs/open.c:822
       do_open fs/namei.c:3426 [inline]
       path_openat+0x1cad/0x2750 fs/namei.c:3559
       do_filp_open+0x1aa/0x400 fs/namei.c:3586
       do_sys_openat2+0x16d/0x4d0 fs/open.c:1212
       do_sys_open fs/open.c:1228 [inline]
       __do_sys_openat fs/open.c:1244 [inline]
       __se_sys_openat fs/open.c:1239 [inline]
       __x64_sys_openat+0x13f/0x1f0 fs/open.c:1239
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #2 (&disk->open_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:607 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:740
       bd_register_pending_holders+0x2c/0x470 block/holder.c:161
       device_add_disk+0x6b1/0xef0 block/genhd.c:485
       add_disk include/linux/genhd.h:212 [inline]
       nbd_dev_add+0x8d9/0xcd0 drivers/block/nbd.c:1818
       nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1948
       genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
       genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
       genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
       genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:704 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:724
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #1 (genl_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:607 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:740
       genl_lock net/netlink/genetlink.c:33 [inline]
       genl_lock_all net/netlink/genetlink.c:46 [inline]
       genl_register_family net/netlink/genetlink.c:393 [inline]
       genl_register_family+0x40f/0x1300 net/netlink/genetlink.c:384
       vdpa_init drivers/vdpa/vdpa.c:926 [inline]
       vdpa_init+0x40/0x70 drivers/vdpa/vdpa.c:919
       do_one_initcall+0x103/0x650 init/main.c:1297
       do_initcall_level init/main.c:1370 [inline]
       do_initcalls init/main.c:1386 [inline]
       do_basic_setup init/main.c:1405 [inline]
       kernel_init_freeable+0x6b1/0x73a init/main.c:1610
       kernel_init+0x1a/0x1d0 init/main.c:1499
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #0 (cb_lock){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3063 [inline]
       check_prevs_add kernel/locking/lockdep.c:3186 [inline]
       validate_chain kernel/locking/lockdep.c:3801 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5027
       lock_acquire kernel/locking/lockdep.c:5637 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
       down_read+0x98/0x440 kernel/locking/rwsem.c:1470
       genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921
       sock_sendmsg_nosec net/socket.c:704 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:724
       sock_no_sendpage+0xf6/0x140 net/core/sock.c:3080
       kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
       kernel_sendpage net/socket.c:3501 [inline]
       sock_sendpage+0xe5/0x140 net/socket.c:1003
       pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
       splice_from_pipe_feed fs/splice.c:418 [inline]
       __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
       splice_from_pipe fs/splice.c:597 [inline]
       generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
       do_splice_from fs/splice.c:767 [inline]
       do_splice+0xb7e/0x1960 fs/splice.c:1079
       __do_splice+0x134/0x250 fs/splice.c:1144
       __do_sys_splice fs/splice.c:1350 [inline]
       __se_sys_splice fs/splice.c:1332 [inline]
       __x64_sys_splice+0x198/0x250 fs/splice.c:1332
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  cb_lock --> sb_writers#3 --> &pipe->mutex/1

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&pipe->mutex/1);
                               lock(sb_writers#3);
                               lock(&pipe->mutex/1);
  lock(cb_lock);

 *** DEADLOCK ***

1 lock held by syz-executor.0/17763:
 #0: ffff888018a81868 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock_nested fs/pipe.c:81 [inline]
 #0: ffff888018a81868 (&pipe->mutex/1){+.+.}-{3:3}, at: pipe_lock+0x5a/0x70 fs/pipe.c:89

stack backtrace:
CPU: 1 PID: 17763 Comm: syz-executor.0 Not tainted 5.16.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2143
 check_prev_add kernel/locking/lockdep.c:3063 [inline]
 check_prevs_add kernel/locking/lockdep.c:3186 [inline]
 validate_chain kernel/locking/lockdep.c:3801 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 down_read+0x98/0x440 kernel/locking/rwsem.c:1470
 genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0xf6/0x140 net/core/sock.c:3080
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0xb7e/0x1960 fs/splice.c:1079
 __do_splice+0x134/0x250 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice fs/splice.c:1332 [inline]
 __x64_sys_splice+0x198/0x250 fs/splice.c:1332
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb339614e99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb337f8a168 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007fb339727f60 RCX: 00007fb339614e99
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fb33966eff1 R08: 0000000000010004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9dc737af R14: 00007fb337f8a300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
