Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8C3D29AA
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhGVQFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 12:05:54 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48070 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhGVQDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 12:03:44 -0400
Received: by mail-il1-f200.google.com with SMTP id c7-20020a92b7470000b0290205c6edd752so3854438ilm.14
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 09:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q/muFsTol+WeJxe30haEYdrpBSqkzslISNhPeY/1DvE=;
        b=NJlsIIXCSexgt8leoI0FaC1oF1LS/1Qgr+JknwL2Dpn/WMldrBHNknAFlfMINgFzhV
         FelauHkKMXft5m6ZYKLpg3+MjZl4ajJG2xKwKjK8kf+j7ji/IUjNes5mbTzEYxEoYZek
         4NMzngiQZoRM+ElKKF2zQER8Ch65uEhUEr9Jy741nWZ03EQ5NVKdUv6zzUn8mYfSc3Cd
         yXsu0bRwUYlh+59hs4WUCbp0HOLMS/+x9G/YBhF4uBoD+mPARLehqJF0cbw1CeQbXSqT
         0Lstua7Of+pm2Mek1phZV02jOcgqj5KgzHXDrOVmpIP/5ThRyJu1/FCA/nZ5ihcWYYvL
         Omzw==
X-Gm-Message-State: AOAM530Y9xADTOEX/vWDfs7ZoO7+IYA76QfwGluDUsqrQt9VSj6zngnj
        pLfU0Yd/lEFbNsdSFusf7RnVsn9Sq1X8xKX/p+j49RnSM+I8
X-Google-Smtp-Source: ABdhPJxE9Jfrm7wOQqxd2z7TM3qtaKNm0yJel8s0Imh1XWnaTR9Wp0lcCM1TTkc+xF0GpwZunFJ1n/sOZlJeeECXamXstN5EhwXR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1356:: with SMTP id u22mr393757jad.39.1626972257675;
 Thu, 22 Jul 2021 09:44:17 -0700 (PDT)
Date:   Thu, 22 Jul 2021 09:44:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a7b9c05c7b8ff4a@google.com>
Subject: [syzbot] possible deadlock in skb_queue_tail (3)
From:   syzbot <syzbot+06d44206f34e058fe2a5@syzkaller.appspotmail.com>
To:     christian.brauner@ubuntu.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1d67c8d993ba Merge tag 'soc-fixes-5.14-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1191cf78300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4743a765b066cc1c
dashboard link: https://syzkaller.appspot.com/bug?extid=06d44206f34e058fe2a5

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+06d44206f34e058fe2a5@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.2/23281 is trying to acquire lock:
ffff888079c6e9a0 (rlock-AF_UNIX){+.+.}-{2:2}, at: skb_queue_tail+0x21/0x140 net/core/skbuff.c:3249

but task is already holding lock:
ffff888079c6edf0 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1114 [inline]
ffff888079c6edf0 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1106

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&u->lock/1){+.+.}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       sk_diag_dump_icons net/unix/diag.c:86 [inline]
       sk_diag_fill+0xaa7/0x1100 net/unix/diag.c:154
       sk_diag_dump net/unix/diag.c:192 [inline]
       unix_diag_dump+0x399/0x590 net/unix/diag.c:220
       netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
       __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
       netlink_dump_start include/linux/netlink.h:258 [inline]
       unix_diag_handler_dump+0x411/0x7d0 net/unix/diag.c:319
       __sock_diag_cmd net/core/sock_diag.c:234 [inline]
       sock_diag_rcv_msg+0x31a/0x440 net/core/sock_diag.c:265
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:276
       netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
       netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
       sock_sendmsg_nosec net/socket.c:703 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:723
       sock_write_iter+0x289/0x3c0 net/socket.c:1056
       call_write_iter include/linux/fs.h:2114 [inline]
       new_sync_write+0x426/0x650 fs/read_write.c:518
       vfs_write+0x75a/0xa40 fs/read_write.c:605
       ksys_write+0x1ee/0x250 fs/read_write.c:658
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (rlock-AF_UNIX){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
       skb_queue_tail+0x21/0x140 net/core/skbuff.c:3249
       unix_dgram_sendmsg+0xfeb/0x1d30 net/unix/af_unix.c:1803
       sock_sendmsg_nosec net/socket.c:703 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:723
       io_send+0x4ad/0x580 fs/io_uring.c:4409
       io_issue_sqe+0xd05/0x6920 fs/io_uring.c:6158
       __io_queue_sqe+0x1ac/0xf10 fs/io_uring.c:6423
       io_queue_sqe fs/io_uring.c:6466 [inline]
       io_submit_sqe fs/io_uring.c:6621 [inline]
       io_submit_sqes+0x63ea/0x7bc0 fs/io_uring.c:6737
       __do_sys_io_uring_enter+0xb03/0x1d30 fs/io_uring.c:9342
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
  lock(rlock-AF_UNIX);

 *** DEADLOCK ***

2 locks held by syz-executor.2/23281:
 #0: ffff888027dfc0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0xaf8/0x1d30 fs/io_uring.c:9341
 #1: ffff888079c6edf0 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1114 [inline]
 #1: ffff888079c6edf0 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1106

stack backtrace:
CPU: 1 PID: 23281 Comm: syz-executor.2 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 skb_queue_tail+0x21/0x140 net/core/skbuff.c:3249
 unix_dgram_sendmsg+0xfeb/0x1d30 net/unix/af_unix.c:1803
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 io_send+0x4ad/0x580 fs/io_uring.c:4409
 io_issue_sqe+0xd05/0x6920 fs/io_uring.c:6158
 __io_queue_sqe+0x1ac/0xf10 fs/io_uring.c:6423
 io_queue_sqe fs/io_uring.c:6466 [inline]
 io_submit_sqe fs/io_uring.c:6621 [inline]
 io_submit_sqes+0x63ea/0x7bc0 fs/io_uring.c:6737
 __do_sys_io_uring_enter+0xb03/0x1d30 fs/io_uring.c:9342
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd4257d5188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000002a6e RDI: 0000000000000003
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 000000000000000e
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffc8b55477f R14: 00007fd4257d5300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
