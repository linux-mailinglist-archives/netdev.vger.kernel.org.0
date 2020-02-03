Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263DC15123B
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 23:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgBCWIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 17:08:16 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35123 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgBCWIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 17:08:14 -0500
Received: by mail-il1-f197.google.com with SMTP id h18so13254633ilc.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 14:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fl+mqf7SXbDA+ahGJYdNPGegyPt8l79GHARMg/wdaAs=;
        b=hNb+0CLMMZcQgFd5VDe9g9lVoZkZo3AjLm9n8v+4uE9sjXWrpz+1tv5gyDFUXA0b2j
         3lBlcGtRNyLtOIUkFxfIWVh1SMsj0qgL1b62hocOiqACX6HOBXlvwfNBmuFF5alRR19c
         qw2EnSlLlPKgJuGk8bzUk3G3AVijLJTsozGQmjE2WrOxYkvaOljZtwKApMQW5uX6hGFB
         QMbsRHF+q5q40sZFq9lY2WmoNJwMH67BVZUb1qztRUiCuu5tadVgFDrb1f1uW5z5Wy9M
         2Buo71g2Y5gY+rreJRvGQnkEyV6zRgMnSfFV+z1ndFRz+FMuecyG7v05Jwjv6hCHD7Ux
         MoPQ==
X-Gm-Message-State: APjAAAUqEbpDHtwXiQldEHmspbyaohPnqgUb0sYe/yng6YPngTgXObnr
        eNPOMWKR8Ipx18BqjXJKdVgdSWF6uie215UZB2A43iz4Gk4e
X-Google-Smtp-Source: APXvYqyQ+w9fm6B/HIwRnHtRDk2vjXzNHeQ1F3vNZIncW6vp9VQKkMODARcwAdWPAHzG6DjcnOeyZrGypXGWCmtfI4/BLtOOD23e
MIME-Version: 1.0
X-Received: by 2002:a02:81cc:: with SMTP id r12mr20424294jag.93.1580767692501;
 Mon, 03 Feb 2020 14:08:12 -0800 (PST)
Date:   Mon, 03 Feb 2020 14:08:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8bcba059db3289b@google.com>
Subject: possible deadlock in wg_set_device
From:   syzbot <syzbot+42d05aefd7fce69f968f@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, jason@zx2c4.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9f68e365 Merge tag 'drm-next-2020-01-30' of git://anongit...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11b068b5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=42d05aefd7fce69f968f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1087e9bee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c665bee00000

The bug was bisected to:

commit e7096c131e5161fa3b8e52a650d7719d2857adfd
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Sun Dec 8 23:27:34 2019 +0000

    net: WireGuard secure network tunnel

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15abc7c9e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17abc7c9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13abc7c9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+42d05aefd7fce69f968f@syzkaller.appspotmail.com
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

batman_adv: batadv0: Interface activated: batadv_slave_1
======================================================
WARNING: possible circular locking dependency detected
5.5.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor962/10036 is trying to acquire lock:
ffff8880a9696128 ((wq_completion)wg-kex-wireguard0){+.+.}, at: flush_workqueue+0xf7/0x14c0 kernel/workqueue.c:2772

but task is already holding lock:
ffff88808ee54e80 (&wg->static_identity.lock){++++}, at: wg_set_device+0xe8b/0x1350 drivers/net/wireguard/netlink.c:567

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&wg->static_identity.lock){++++}:
       down_read+0x95/0x430 kernel/locking/rwsem.c:1495
       wg_noise_handshake_create_initiation+0xc0/0x670 drivers/net/wireguard/noise.c:499
       wg_packet_send_handshake_initiation+0x185/0x250 drivers/net/wireguard/send.c:34
       wg_packet_handshake_send_worker+0x1d/0x30 drivers/net/wireguard/send.c:51
       process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
       worker_thread+0x98/0xe40 kernel/workqueue.c:2410
       kthread+0x361/0x430 kernel/kthread.c:255
       ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #1 ((work_completion)(&peer->transmit_handshake_work)){+.+.}:
       process_one_work+0x972/0x17a0 kernel/workqueue.c:2240
       worker_thread+0x98/0xe40 kernel/workqueue.c:2410
       kthread+0x361/0x430 kernel/kthread.c:255
       ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #0 ((wq_completion)wg-kex-wireguard0){+.+.}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       flush_workqueue+0x126/0x14c0 kernel/workqueue.c:2775
       peer_remove_after_dead+0x16b/0x230 drivers/net/wireguard/peer.c:141
       wg_peer_remove+0x244/0x340 drivers/net/wireguard/peer.c:176
       wg_set_device+0xf76/0x1350 drivers/net/wireguard/netlink.c:575
       genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
       genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
       netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
       genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
       netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
       netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
       netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xd7/0x130 net/socket.c:672
       ____sys_sendmsg+0x753/0x880 net/socket.c:2343
       ___sys_sendmsg+0x100/0x170 net/socket.c:2397
       __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
       __do_sys_sendmsg net/socket.c:2439 [inline]
       __se_sys_sendmsg net/socket.c:2437 [inline]
       __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  (wq_completion)wg-kex-wireguard0 --> (work_completion)(&peer->transmit_handshake_work) --> &wg->static_identity.lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&wg->static_identity.lock);
                               lock((work_completion)(&peer->transmit_handshake_work));
                               lock(&wg->static_identity.lock);
  lock((wq_completion)wg-kex-wireguard0);

 *** DEADLOCK ***

5 locks held by syz-executor962/10036:
 #0: ffffffff8a7899e8 (cb_lock){++++}, at: genl_rcv+0x1a/0x40 net/netlink/genetlink.c:744
 #1: ffffffff8a789aa0 (genl_mutex){+.+.}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8a789aa0 (genl_mutex){+.+.}, at: genl_rcv_msg+0x7de/0xea0 net/netlink/genetlink.c:732
 #2: ffffffff8a733c80 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
 #3: ffff88808ee550a0 (&wg->device_update_lock){+.+.}, at: wg_set_device+0x2be/0x1350 drivers/net/wireguard/netlink.c:510
 #4: ffff88808ee54e80 (&wg->static_identity.lock){++++}, at: wg_set_device+0xe8b/0x1350 drivers/net/wireguard/netlink.c:567

stack backtrace:
CPU: 0 PID: 10036 Comm: syz-executor962 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 flush_workqueue+0x126/0x14c0 kernel/workqueue.c:2775
 peer_remove_after_dead+0x16b/0x230 drivers/net/wireguard/peer.c:141
 wg_peer_remove+0x244/0x340 drivers/net/wireguard/peer.c:176
 wg_set_device+0xf76/0x1350 drivers/net/wireguard/netlink.c:575
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4491c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b d4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcc45f9878 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000003064 RCX: 00000000004491c9
RDX: 0000000000000000 RSI: 0000000020001340 RDI: 0000000000000004
RBP: 7261756765726977 R08: 0000000000000000 R09: 0000000001bbbbb


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
