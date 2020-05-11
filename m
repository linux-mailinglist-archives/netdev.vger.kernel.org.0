Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3879A1CE27A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgEKSVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:21:24 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37331 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731070AbgEKSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:21:23 -0400
Received: by mail-io1-f71.google.com with SMTP id 141so1967801iou.4
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CHOkFnrfNMfKG7b6Q4Npd24oP1fJe4QpB/xNqqVOEeY=;
        b=DE6hLkrPb08pnE5m/z2HqL49dxjNaiMQq05Z+42E/ou7Dn5yo8xADQg0Fpoath6ze5
         TVAU47v3f2VFHcNG5yZBKbxAixfGVWB03pyacqePNWvAUNXK/ToD0Hs0m2bGcQZuTAF/
         5aZE8px++VXthlHm43H+mAltFxnj2gsxr8XIERVz3vCkJ62ekH70ZDoz0SYtnPsGOrTU
         x527eKSeK1pSPUV5/DL//zjJROeWHQK3LEY3OMsiQNtIziq7qBW77MUM3i3s5vTlJZv6
         NGH0OXasMb3cQwCOpKMF/+h68G5oCOUrI0LYkLe6f5SM3WKZn0sNVuh3iyuYq8ogYDio
         ozpQ==
X-Gm-Message-State: AGi0PuazinJ6mBN+xBsUe3l/gku5doU+I8gQVv7/I6HST/qyNn7tCdKq
        Xsv7+tiTETl91IBKejsXEBBm4UAWPXNCxibGh6BaGY3TzAdn
X-Google-Smtp-Source: APiQypJANE+T8nnZenndQy6vlFpGHn8hSZA1QXdsDb/mGt/aXgGztJl2ua8QNjF5t/eJxlkmZdfrfVObMupVvY1IvY4Fz6XDHuWh
MIME-Version: 1.0
X-Received: by 2002:a02:c615:: with SMTP id i21mr6690238jan.30.1589221281346;
 Mon, 11 May 2020 11:21:21 -0700 (PDT)
Date:   Mon, 11 May 2020 11:21:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1b78f05a563695e@google.com>
Subject: possible deadlock in sk_diag_fill (2)
From:   syzbot <syzbot+c07a7e4d97298524f320@syzkaller.appspotmail.com>
To:     davem@davemloft.net, felipe@felipegasper.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e99332e7 gcc-10: mark more functions __init to avoid secti..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1557910c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a96cf498e199d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=c07a7e4d97298524f320
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c07a7e4d97298524f320@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.7.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/31514 is trying to acquire lock:
ffff88806be19668 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:86 [inline]
ffff88806be19668 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_fill.isra.0+0x9d0/0x10e0 net/unix/diag.c:154

but task is already holding lock:
ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:68 [inline]
ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill.isra.0+0x8eb/0x10e0 net/unix/diag.c:154

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rlock-AF_UNIX){+.+.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
       skb_queue_tail+0x27/0x180 net/core/skbuff.c:3143
       unix_dgram_sendmsg+0xc96/0x12e0 net/unix/af_unix.c:1806
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x308/0x7e0 net/socket.c:2362
       ___sys_sendmsg+0x100/0x170 net/socket.c:2416
       __sys_sendmmsg+0x296/0x480 net/socket.c:2499
       __compat_sys_sendmmsg net/compat.c:672 [inline]
       __do_compat_sys_sendmmsg net/compat.c:679 [inline]
       __se_compat_sys_sendmmsg net/compat.c:676 [inline]
       __ia32_compat_sys_sendmmsg+0x9b/0x100 net/compat.c:676
       do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
       do_fast_syscall_32+0x270/0xe90 arch/x86/entry/common.c:396
       entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

-> #0 (&u->lock/1){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2515 [inline]
       check_prevs_add kernel/locking/lockdep.c:2620 [inline]
       validate_chain kernel/locking/lockdep.c:3237 [inline]
       __lock_acquire+0x2ab1/0x4c50 kernel/locking/lockdep.c:4355
       lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       sk_diag_dump_icons net/unix/diag.c:86 [inline]
       sk_diag_fill.isra.0+0x9d0/0x10e0 net/unix/diag.c:154
       sk_diag_dump net/unix/diag.c:192 [inline]
       unix_diag_dump+0x441/0x550 net/unix/diag.c:220
       netlink_dump+0x50b/0xf50 net/netlink/af_netlink.c:2245
       __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
       netlink_dump_start include/linux/netlink.h:246 [inline]
       unix_diag_handler_dump+0x3ea/0x7b0 net/unix/diag.c:321
       __sock_diag_cmd net/core/sock_diag.c:233 [inline]
       sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
       netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
       sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
       netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
       netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
       netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       sock_write_iter+0x289/0x3c0 net/socket.c:1004
       call_write_iter include/linux/fs.h:1907 [inline]
       do_iter_readv_writev+0x5a8/0x850 fs/read_write.c:694
       do_iter_write fs/read_write.c:999 [inline]
       do_iter_write+0x18b/0x600 fs/read_write.c:980
       compat_writev+0x1f1/0x390 fs/read_write.c:1352
       do_compat_writev+0xd5/0x1d0 fs/read_write.c:1373
       do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
       do_fast_syscall_32+0x270/0xe90 arch/x86/entry/common.c:396
       entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
  lock(&u->lock/1);

 *** DEADLOCK ***

5 locks held by syz-executor.3/31514:
 #0: ffffffff8a58a388 (sock_diag_mutex){+.+.}-{3:3}, at: sock_diag_rcv+0x17/0x40 net/core/sock_diag.c:274
 #1: ffffffff8a58a448 (sock_diag_table_mutex){+.+.}-{3:3}, at: __sock_diag_cmd net/core/sock_diag.c:228 [inline]
 #1: ffffffff8a58a448 (sock_diag_table_mutex){+.+.}-{3:3}, at: sock_diag_rcv_msg+0x18d/0x3e0 net/core/sock_diag.c:264
 #2: ffff888050ce1630 (nlk_cb_mutex-SOCK_DIAG){+.+.}-{3:3}, at: netlink_dump+0xd4/0xf50 net/netlink/af_netlink.c:2200
 #3: ffffffff8a65df18 (unix_table_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
 #3: ffffffff8a65df18 (unix_table_lock){+.+.}-{2:2}, at: unix_diag_dump+0x10c/0x550 net/unix/diag.c:206
 #4: ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
 #4: ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:68 [inline]
 #4: ffff888091bbf1e0 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill.isra.0+0x8eb/0x10e0 net/unix/diag.c:154

stack backtrace:
CPU: 0 PID: 31514 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1846
 check_prev_add kernel/locking/lockdep.c:2515 [inline]
 check_prevs_add kernel/locking/lockdep.c:2620 [inline]
 validate_chain kernel/locking/lockdep.c:3237 [inline]
 __lock_acquire+0x2ab1/0x4c50 kernel/locking/lockdep.c:4355
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 sk_diag_dump_icons net/unix/diag.c:86 [inline]
 sk_diag_fill.isra.0+0x9d0/0x10e0 net/unix/diag.c:154
 sk_diag_dump net/unix/diag.c:192 [inline]
 unix_diag_dump+0x441/0x550 net/unix/diag.c:220
 netlink_dump+0x50b/0xf50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
 netlink_dump_start include/linux/netlink.h:246 [inline]
 unix_diag_handler_dump+0x3ea/0x7b0 net/unix/diag.c:321
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x5a8/0x850 fs/read_write.c:694
 do_iter_write fs/read_write.c:999 [inline]
 do_iter_write+0x18b/0x600 fs/read_write.c:980
 compat_writev+0x1f1/0x390 fs/read_write.c:1352
 do_compat_writev+0xd5/0x1d0 fs/read_write.c:1373
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe90 arch/x86/entry/common.c:396
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
