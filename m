Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB8150F5B
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgBCS2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:28:13 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45032 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBCS2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:28:12 -0500
Received: by mail-il1-f199.google.com with SMTP id h87so12698862ild.11
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fNirEIjUZWmHl3fUAVYFWGTvsAYsyyMxP84IDuD55uU=;
        b=hPL+YSmDAjO2bKFezKKFnrdCIrV/iRV2Xbs1brq/h+D9bILQv2SIEkaf0c7xSOuho6
         YDOqfqs850HPvNa0PgpLjqIWEznFNt6VMm2LFRLxbf82Qhm3cnfAiHB/z+QHHmeogc7/
         7K3hF9qvIyPVCe9OZ6bLAqLGqQNvcTJ/KVn8AB5CvC0n+Hyb7GvB6X42AxnCrm9nWUQG
         5+K46nTGLcpRDOcUl129To4pHGG1pA015db6QxWQaDGytJwkGOHnxIKHQTYBiAkJe8Qr
         1IgiBSF6alRUj0iBFfpVzzMxYfPQ20LR/+PogDW6+1c9IRjNturGlYvhebiuU4kT3FVp
         w0Iw==
X-Gm-Message-State: APjAAAVlKn1mJte2cRFiEjYaVVj4roL3CkL9QKCqW82/awhIaaEJma5B
        q0VPR+Ud6yetmM9TUgMRdQdCDKRzb8rDtHpxcczgDgpTWlbP
X-Google-Smtp-Source: APXvYqxAnqBewG1iFwpsyVzj92urVpUN607Q5R7WgBJZrs7tq87ZBAeAdxyr34hRFZHw5wcrwspswcSloprUWaKraiBImuLSxIpZ
MIME-Version: 1.0
X-Received: by 2002:a02:c906:: with SMTP id t6mr20831421jao.75.1580754491979;
 Mon, 03 Feb 2020 10:28:11 -0800 (PST)
Date:   Mon, 03 Feb 2020 10:28:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8bfe8059db01519@google.com>
Subject: possible deadlock in wg_noise_handshake_create_initiation
From:   syzbot <syzbot+d5bc560aaa1cedefffd5@syzkaller.appspotmail.com>
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

HEAD commit:    ccaaaf6f Merge tag 'mpx-for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16034a79e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3373595e41752b95
dashboard link: https://syzkaller.appspot.com/bug?extid=d5bc560aaa1cedefffd5
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103868b5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dd064ee00000

The bug was bisected to:

commit e7096c131e5161fa3b8e52a650d7719d2857adfd
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Sun Dec 8 23:27:34 2019 +0000

    net: WireGuard secure network tunnel

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14440195e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16440195e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12440195e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d5bc560aaa1cedefffd5@syzkaller.appspotmail.com
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

======================================================
WARNING: possible circular locking dependency detected
5.5.0-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:4/509 is trying to acquire lock:
ffff888097a30e80 (&wg->static_identity.lock){++++}, at: wg_noise_handshake_create_initiation+0x6a/0x15c0 drivers/net/wireguard/noise.c:499

but task is already holding lock:
ffffc90002157d78 ((work_completion)(&peer->transmit_handshake_work)){+.+.}, at: process_one_work+0x7a5/0x10f0 kernel/workqueue.c:2239

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 ((work_completion)(&peer->transmit_handshake_work)){+.+.}:
       lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
       process_one_work+0x7c8/0x10f0 kernel/workqueue.c:2240
       worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
       kthread+0x332/0x350 kernel/kthread.c:255
       ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #1 ((wq_completion)wg-kex-wireguard0){+.+.}:
       lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
       flush_workqueue+0x10a/0x1820 kernel/workqueue.c:2775
       peer_remove_after_dead+0x125/0x280 drivers/net/wireguard/peer.c:141
       wg_peer_remove+0x211/0x270 drivers/net/wireguard/peer.c:176
       wg_set_device+0xb6a/0x2010 drivers/net/wireguard/netlink.c:575
       genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
       genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
       genl_rcv_msg+0xf15/0x13e0 net/netlink/genetlink.c:734
       netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:745
       netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
       netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
       netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg net/socket.c:672 [inline]
       ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
       ___sys_sendmsg net/socket.c:2397 [inline]
       __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
       __do_sys_sendmsg net/socket.c:2439 [inline]
       __se_sys_sendmsg net/socket.c:2437 [inline]
       __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
       do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&wg->static_identity.lock){++++}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain+0x1507/0x7be0 kernel/locking/lockdep.c:2970
       __lock_acquire+0xc5a/0x1bc0 kernel/locking/lockdep.c:3954
       lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
       down_read+0x39/0x50 kernel/locking/rwsem.c:1495
       wg_noise_handshake_create_initiation+0x6a/0x15c0 drivers/net/wireguard/noise.c:499
       wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:34 [inline]
       wg_packet_handshake_send_worker+0xe5/0x1a0 drivers/net/wireguard/send.c:51
       process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
       worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
       kthread+0x332/0x350 kernel/kthread.c:255
       ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

other info that might help us debug this:

Chain exists of:
  &wg->static_identity.lock --> (wq_completion)wg-kex-wireguard0 --> (work_completion)(&peer->transmit_handshake_work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&peer->transmit_handshake_work));
                               lock((wq_completion)wg-kex-wireguard0);
                               lock((work_completion)(&peer->transmit_handshake_work));
  lock(&wg->static_identity.lock);

 *** DEADLOCK ***

2 locks held by kworker/u4:4/509:
 #0: ffff88809ec44128 ((wq_completion)wg-kex-wireguard0){+.+.}, at: spin_unlock_irq include/linux/spinlock.h:388 [inline]
 #0: ffff88809ec44128 ((wq_completion)wg-kex-wireguard0){+.+.}, at: process_one_work+0x763/0x10f0 kernel/workqueue.c:2237
 #1: ffffc90002157d78 ((work_completion)(&peer->transmit_handshake_work)){+.+.}, at: process_one_work+0x7a5/0x10f0 kernel/workqueue.c:2239

stack backtrace:
CPU: 1 PID: 509 Comm: kworker/u4:4 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wireguard0 wg_packet_handshake_send_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_circular_bug+0xc3f/0xe70 kernel/locking/lockdep.c:1684
 check_noncircular+0x206/0x3a0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain+0x1507/0x7be0 kernel/locking/lockdep.c:2970
 __lock_acquire+0xc5a/0x1bc0 kernel/locking/lockdep.c:3954
 lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
 down_read+0x39/0x50 kernel/locking/rwsem.c:1495
 wg_noise_handshake_create_initiation+0x6a/0x15c0 drivers/net/wireguard/noise.c:499
 wg_packet_send_handshake_initiation drivers/net/wireguard/send.c:34 [inline]
 wg_packet_handshake_send_worker+0xe5/0x1a0 drivers/net/wireguard/send.c:51
 process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
 worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
