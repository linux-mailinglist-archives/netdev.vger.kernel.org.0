Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B495D31D1B9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBPUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:49:00 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:38680 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhBPUs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:48:57 -0500
Received: by mail-io1-f69.google.com with SMTP id a12so10101502ioe.5
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 12:48:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=orIsO18CBWkBi5Y2F5JsHw46nBBVv5ticc9570jrqkk=;
        b=P2bjyMx0k+cZ0vtqwZXBC4RGA0WK6lzF5T/gQ425gm4LTw5RLAnfH0W3hsCA6wkUAU
         9buVgpiER+w6r9esDDsrWCqZJV79XUBva6nRlANQbOnHPC61Y52lK8ouiywkF0D0uIM+
         NV76LCMXhheZ5ZvGT6k53NcOEQBy4X6tXu+nT+VnE8AL3KSy7iK2di/mFDjcVY9oDtY5
         e/2jf0RNXOHq5zkalFk2BUOVl4yyCfXfVTmRGyMLWPK1vSnuzjENmk5Baoq5Dvs3ANtI
         WRqPUUAvPT04zsQiuS1eRcqchzN1jNUk8l4GupcqfEhdRnMBEytCP2hkWn1MRfzeSQwq
         gMJg==
X-Gm-Message-State: AOAM5320WP7xvU/vRuDhLK+2PuRNXbG62pSHpXI7yw+M0z2K0YiRaR5s
        QHSxZXEju/d8NAmVmVDHx3rYMPMbHLkxiu9/hEf+Vw6ftbhn
X-Google-Smtp-Source: ABdhPJxoa12ysxlcKMrhxXk/Xm0ca45D5S8Su+qSybPj9wnp7NIjytadqFiYLzY9TqI0rTIYLHU/+Eavnk/HihXdbdZotkS/wMfr
MIME-Version: 1.0
X-Received: by 2002:a05:6638:35a3:: with SMTP id v35mr22065226jal.36.1613508495810;
 Tue, 16 Feb 2021 12:48:15 -0800 (PST)
Date:   Tue, 16 Feb 2021 12:48:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc239f05bb7a38aa@google.com>
Subject: possible deadlock in skb_queue_tail (2)
From:   syzbot <syzbot+67791dce9282c8bedfd1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, ktkhai@virtuozzo.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tklauser@distanz.ch
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dcc0b490 Merge tag 'powerpc-5.11-8' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a2fe9cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=67791dce9282c8bedfd1
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+67791dce9282c8bedfd1@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.11.0-rc7-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/13111 is trying to acquire lock:
ffff888012d36e60 (rlock-AF_UNIX){+.+.}-{2:2}, at: skb_queue_tail+0x21/0x140 net/core/skbuff.c:3161

but task is already holding lock:
ffff888012d372a8 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1108 [inline]
ffff888012d372a8 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1100

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&u->lock/1){+.+.}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       sk_diag_dump_icons net/unix/diag.c:86 [inline]
       sk_diag_fill+0xaaf/0x10d0 net/unix/diag.c:154
       sk_diag_dump net/unix/diag.c:192 [inline]
       unix_diag_dump+0x399/0x590 net/unix/diag.c:220
       netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2268
       __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2373
       netlink_dump_start include/linux/netlink.h:256 [inline]
       unix_diag_handler_dump+0x411/0x7d0 net/unix/diag.c:321
       __sock_diag_cmd net/core/sock_diag.c:234 [inline]
       sock_diag_rcv_msg+0x31a/0x440 net/core/sock_diag.c:265
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:276
       netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
       netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       sock_write_iter+0x289/0x3c0 net/socket.c:999
       call_write_iter include/linux/fs.h:1901 [inline]
       new_sync_write+0x426/0x650 fs/read_write.c:518
       vfs_write+0x791/0xa30 fs/read_write.c:605
       ksys_write+0x1ee/0x250 fs/read_write.c:658
       do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
       __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
       do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
       entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

-> #0 (rlock-AF_UNIX){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2868 [inline]
       check_prevs_add kernel/locking/lockdep.c:2993 [inline]
       validate_chain kernel/locking/lockdep.c:3608 [inline]
       __lock_acquire+0x2b26/0x54f0 kernel/locking/lockdep.c:4832
       lock_acquire kernel/locking/lockdep.c:5442 [inline]
       lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5407
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
       skb_queue_tail+0x21/0x140 net/core/skbuff.c:3161
       unix_dgram_sendmsg+0xfb2/0x1a80 net/unix/af_unix.c:1797
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x331/0x810 net/socket.c:2345
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
       __sys_sendmmsg+0x292/0x470 net/socket.c:2482
       __compat_sys_sendmmsg net/compat.c:361 [inline]
       __do_compat_sys_sendmmsg net/compat.c:368 [inline]
       __se_compat_sys_sendmmsg net/compat.c:365 [inline]
       __ia32_compat_sys_sendmmsg+0x9b/0x100 net/compat.c:365
       do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
       __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
       do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
       entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
  lock(rlock-AF_UNIX);

 *** DEADLOCK ***

1 lock held by syz-executor.0/13111:
 #0: ffff888012d372a8 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock net/unix/af_unix.c:1108 [inline]
 #0: ffff888012d372a8 (&u->lock/1){+.+.}-{2:2}, at: unix_state_double_lock+0x77/0xa0 net/unix/af_unix.c:1100

stack backtrace:
CPU: 1 PID: 13111 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2117
 check_prev_add kernel/locking/lockdep.c:2868 [inline]
 check_prevs_add kernel/locking/lockdep.c:2993 [inline]
 validate_chain kernel/locking/lockdep.c:3608 [inline]
 __lock_acquire+0x2b26/0x54f0 kernel/locking/lockdep.c:4832
 lock_acquire kernel/locking/lockdep.c:5442 [inline]
 lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5407
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 skb_queue_tail+0x21/0x140 net/core/skbuff.c:3161
 unix_dgram_sendmsg+0xfb2/0x1a80 net/unix/af_unix.c:1797
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmmsg+0x292/0x470 net/socket.c:2482
 __compat_sys_sendmmsg net/compat.c:361 [inline]
 __do_compat_sys_sendmmsg net/compat.c:368 [inline]
 __se_compat_sys_sendmmsg net/compat.c:365 [inline]
 __ia32_compat_sys_sendmmsg+0x9b/0x100 net/compat.c:365
 do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f6f549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55485fc EFLAGS: 00000296 ORIG_RAX: 0000000000000159
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00000000200bd000
RDX: 0000000024924c31 RSI: 000000000004ffe0 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
