Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9F3EBB30
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhHMRRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:17:48 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:42994 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhHMRRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 13:17:45 -0400
Received: by mail-il1-f197.google.com with SMTP id z14-20020a92d18e0000b029022418b34bc9so5434208ilz.9
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 10:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wSj22AakxH3PkPSYM69JRzcOm2KyY8xUWrWLa7wgAqI=;
        b=NZORx2ZNjc9qwSNkmUeMNejIfhkm3JBTpHcoGOnp+R8ovcct/+CrHGucTVGmJJI26A
         v6TGPGCrYaSWmEmpdgTCnkCqooX0qwdNW9oCz/uTQcQjPXrabaxUaJIo8vVNNgBA4p2H
         nOObdcaSLfTdRuE3VmqlZZWfh2uEFjNngEFcOLuV0W0BAA9nWZN11m5pUfg7wp23xE+K
         GgbeeXMcdUh0jSn402hJu4WKkULxwelj1DRC2yab24g7jrpCRgR5aopqrtpiIYpted2G
         up+QZtWPDbXSlh+Yq0gTz3QdH+5qHfMNsiNTOU0RqetjkqJ8sU0K1uEgnrUlGO4ur/jk
         DrQQ==
X-Gm-Message-State: AOAM531WgSWsTspHFY3TXjx+nDU0HdEtD0CtL/2J6JTHffG6DinNPHD0
        e+9NTIq8elpBGvams/DtK+KyTWRUaIdmjxQh9y06IJv3EUeE
X-Google-Smtp-Source: ABdhPJzh5p9bKKzP2xUqk0/F76Rq4L8fddhldlGO5bqgRsQhQIvrTZAjT1BBZ/HeGrQxsOZHlFG7plGHrm8Zsx9MCRxCZTNwCiGB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f93:: with SMTP id v19mr2477378ilo.170.1628875038744;
 Fri, 13 Aug 2021 10:17:18 -0700 (PDT)
Date:   Fri, 13 Aug 2021 10:17:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011675305c9740690@google.com>
Subject: [syzbot] possible deadlock in sk_diag_fill (3)
From:   syzbot <syzbot+00676df89338017efb46@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36a21d51725a Linux 5.14-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120315e6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
dashboard link: https://syzkaller.appspot.com/bug?extid=00676df89338017efb46
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00676df89338017efb46@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc5-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.5/2925 is trying to acquire lock:
ffff888018d38630 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:86 [inline]
ffff888018d38630 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_fill+0x6f2/0x1090 net/unix/diag.c:154

but task is already holding lock:
ffff888018d389a0 (
rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:68 [inline]
rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x64b/0x1090 net/unix/diag.c:154

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rlock-AF_UNIX){+.+.}-{2:2}:
       lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xb3/0x100 kernel/locking/spinlock.c:159
       skb_queue_tail+0x32/0x120 net/core/skbuff.c:3263
       unix_dgram_sendmsg+0x1a3c/0x2a80 net/unix/af_unix.c:1850
       sock_sendmsg_nosec net/socket.c:703 [inline]
       sock_sendmsg net/socket.c:723 [inline]
       ____sys_sendmsg+0x5a2/0x900 net/socket.c:2392
       ___sys_sendmsg net/socket.c:2446 [inline]
       __sys_sendmmsg+0x500/0x790 net/socket.c:2532
       __do_sys_sendmmsg net/socket.c:2561 [inline]
       __se_sys_sendmmsg net/socket.c:2558 [inline]
       __x64_sys_sendmmsg+0x9c/0xb0 net/socket.c:2558
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&u->lock/1){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add+0x4f9/0x5b30 kernel/locking/lockdep.c:3174
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x4476/0x6100 kernel/locking/lockdep.c:5015
       lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
       _raw_spin_lock_nested+0x2d/0x40 kernel/locking/spinlock.c:361
       sk_diag_dump_icons net/unix/diag.c:86 [inline]
       sk_diag_fill+0x6f2/0x1090 net/unix/diag.c:154
       sk_diag_dump net/unix/diag.c:192 [inline]
       unix_diag_dump+0x2e9/0x4f0 net/unix/diag.c:220
       netlink_dump+0x5b7/0xc30 net/netlink/af_netlink.c:2278
       __netlink_dump_start+0x53d/0x710 net/netlink/af_netlink.c:2383
       netlink_dump_start include/linux/netlink.h:258 [inline]
       unix_diag_handler_dump+0x307/0x7d0 net/unix/diag.c:319
       __sock_diag_cmd net/core/sock_diag.c:234 [inline]
       sock_diag_rcv_msg+0x350/0x460 net/core/sock_diag.c:265
       netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2504
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:276
       netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
       netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1340
       netlink_sendmsg+0x9e7/0xe00 net/netlink/af_netlink.c:1929
       sock_sendmsg_nosec net/socket.c:703 [inline]
       sock_sendmsg net/socket.c:723 [inline]
       sock_write_iter+0x398/0x520 net/socket.c:1056
       do_iter_readv_writev+0x566/0x770 include/linux/fs.h:2108
       do_iter_write+0x16c/0x5f0 fs/read_write.c:866
       vfs_writev fs/read_write.c:939 [inline]
       do_writev+0x240/0x440 fs/read_write.c:982
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
  lock(&u->lock/1);

 *** DEADLOCK ***

5 locks held by syz-executor.5/2925:
 #0: ffffffff8d751a88 (sock_diag_mutex){+.+.}-{3:3}, at: sock_diag_rcv+0x17/0x40 net/core/sock_diag.c:275
 #1: ffffffff8d7518e8 (sock_diag_table_mutex){+.+.}-{3:3}, at: __sock_diag_cmd net/core/sock_diag.c:229 [inline]
 #1: ffffffff8d7518e8 (sock_diag_table_mutex){+.+.}-{3:3}, at: sock_diag_rcv_msg+0x23f/0x460 net/core/sock_diag.c:265
 #2: ffff88806de6f638 (nlk_cb_mutex-SOCK_DIAG){+.+.}-{3:3}, at: netlink_dump+0xd0/0xc30 net/netlink/af_netlink.c:2233
 #3: ffffffff8d841178 (unix_table_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #3: ffffffff8d841178 (unix_table_lock){+.+.}-{2:2}, at: unix_diag_dump+0xf1/0x4f0 net/unix/diag.c:206
 #4: ffff888018d389a0 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #4: ffff888018d389a0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:68 [inline]
 #4: ffff888018d389a0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x64b/0x1090 net/unix/diag.c:154

stack backtrace:
CPU: 0 PID: 2925 Comm: syz-executor.5 Not tainted 5.14.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ae/0x29f lib/dump_stack.c:105
 print_circular_bug+0xb17/0xdc0 kernel/locking/lockdep.c:2009
 check_noncircular+0x2cc/0x390 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add+0x4f9/0x5b30 kernel/locking/lockdep.c:3174
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x4476/0x6100 kernel/locking/lockdep.c:5015
 lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
 _raw_spin_lock_nested+0x2d/0x40 kernel/locking/spinlock.c:361
 sk_diag_dump_icons net/unix/diag.c:86 [inline]
 sk_diag_fill+0x6f2/0x1090 net/unix/diag.c:154
 sk_diag_dump net/unix/diag.c:192 [inline]
 unix_diag_dump+0x2e9/0x4f0 net/unix/diag.c:220
 netlink_dump+0x5b7/0xc30 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x53d/0x710 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 unix_diag_handler_dump+0x307/0x7d0 net/unix/diag.c:319
 __sock_diag_cmd net/core/sock_diag.c:234 [inline]
 sock_diag_rcv_msg+0x350/0x460 net/core/sock_diag.c:265
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2504
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:276
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x9e7/0xe00 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 sock_write_iter+0x398/0x520 net/socket.c:1056
 do_iter_readv_writev+0x566/0x770 include/linux/fs.h:2108
 do_iter_write+0x16c/0x5f0 fs/read_write.c:866
 vfs_writev fs/read_write.c:939 [inline]
 do_writev+0x240/0x440 fs/read_write.c:982
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5b30d9a188 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000006
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd964833ff R14: 00007f5b30d9a300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
