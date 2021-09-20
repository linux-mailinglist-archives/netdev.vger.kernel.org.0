Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2E34128A4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhITWIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 18:08:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33682 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhITWGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 18:06:01 -0400
Received: by mail-io1-f72.google.com with SMTP id g2-20020a6b7602000000b005be59530196so44656605iom.0
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 15:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ooqjh+UYLi3OQs32zgOKcf+yaAx3ZjhTbREeYysl+go=;
        b=b/tEVprKsFtB6AUWD8w4jOEam+iuKvrcdYQLA83sv1VIlzFgfxGIHI4NG+2K7uBp9M
         K/Wa5mFjRNNTZMO6FcxcJBrb+YqE0CzTjarPscii5qhNCFHpiI/0L1Zzp829hBoJzdfR
         KiGZV7DXRwnB35lzDa2ZIx1Cd+fRw65FRrK6TTkQHG0R+vlkr/fsjvv8gOVc/1QdwuDD
         U+9wnuuxGn4qZXqmF1RR6w/KJm534Dykby5Kk0tjwwpySrCpwgSZmwG1Y86y+nv/SE6J
         5Z07n4nxl4kbFJ3uUMsQFqGMMg6Zwng9fDRhNT8XIto268jzxC6CkvP8JBPL9JVpbovR
         Mjug==
X-Gm-Message-State: AOAM531uHSjglSwJyQ3ruAJhDXIzeT7GYHYrCIfWijTZ/sP6X+ACjU0B
        Vu+jrTML5ifl3QPnjXZi2TUgPfiyCpAuGn8Zb+M/+CHhh7vp
X-Google-Smtp-Source: ABdhPJwm5MsXEJa6v+U2g9eVQkAZNj0a7Sm3oDJySgJjTKMpzEZHeRyH7VNjcWqIif5/IzX3TwcX0/TcwLaL77VzcAOvuT33r9YZ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24d4:: with SMTP id y20mr21502264jat.27.1632175473655;
 Mon, 20 Sep 2021 15:04:33 -0700 (PDT)
Date:   Mon, 20 Sep 2021 15:04:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005183b005cc74779a@google.com>
Subject: [syzbot] possible deadlock in mptcp_close
From:   syzbot <syzbot+1dd53f7a89b299d59eaf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e30cd812dffa selftests: net: af_unix: Fix makefile to use ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1689d3e7300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=1dd53f7a89b299d59eaf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11adc1d7300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a351ab300000

The issue was bisected to:

commit 2dcb96bacce36021c2f3eaae0cef607b5bb71ede
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Sep 18 12:42:35 2021 +0000

    net: core: Correct the sock::sk_lock.owned lockdep annotations

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a511f3300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a511f3300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a511f3300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1dd53f7a89b299d59eaf@syzkaller.appspotmail.com
Fixes: 2dcb96bacce3 ("net: core: Correct the sock::sk_lock.owned lockdep annotations")

MPTCP: kernel_bind error, err=-98
============================================
WARNING: possible recursive locking detected
5.15.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor998/6520 is trying to acquire lock:
ffff8880795718a0 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x267/0x7b0 net/mptcp/protocol.c:2738

but task is already holding lock:
ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x23/0x7b0 net/mptcp/protocol.c:2720

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(k-sk_lock-AF_INET);
  lock(k-sk_lock-AF_INET);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor998/6520:
 #0: ffffffff8d176c50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 #1: ffffffff8d176d08 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8d176d08 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:790
 #2: ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
 #2: ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x23/0x7b0 net/mptcp/protocol.c:2720

stack backtrace:
CPU: 1 PID: 6520 Comm: syz-executor998 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 lock_sock_fast+0x36/0x100 net/core/sock.c:3229
 mptcp_close+0x267/0x7b0 net/mptcp/protocol.c:2738
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release net/socket.c:649 [inline]
 sock_release+0x87/0x1b0 net/socket.c:677
 mptcp_pm_nl_create_listen_socket+0x238/0x2c0 net/mptcp/pm_netlink.c:900
 mptcp_nl_cmd_add_addr+0x359/0x930 net/mptcp/pm_netlink.c:1170
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_no_sendpage+0x101/0x150 net/core/sock.c:2980
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3504
 kernel_sendpage net/socket.c:3501 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1003
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0xae9/0x1240 fs/read_write.c:1249
 __do_sys_sendfile64 fs/read_write.c:1314 [inline]
 __se_sys_sendfile64 fs/read_write.c:1300 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1300
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f215cb69969
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc96bb3868 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f215cbad072 RCX: 00007f215cb69969
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000005
RBP: 0000000000000000 R08: 00007ffc96bb3a08 R09: 00007ffc96bb3a08
R10: 0000000100000002 R11: 0000000000000246 R12: 00007ffc96bb387c
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
