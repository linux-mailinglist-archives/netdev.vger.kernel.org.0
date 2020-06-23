Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078CF2049DF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgFWG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:27:13 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:46983 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbgFWG1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:27:12 -0400
Received: by mail-il1-f197.google.com with SMTP id t69so13799153ilk.13
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 23:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gZ4kRg/lsKbtR4x7IDRCO8QC7n8viAfM9eVMzkEuu4M=;
        b=YvJUd9lx25aBx76rilC05oj1VGxdKxirgTVZMSKwfwy2aj8hSXWoFoLiklYBbESNNs
         yFBQXt62SlAEmOX0CWA77av2AyAUK01miyvwZcsfhNazSMUssaKYdtpMkHU4btAzf6dg
         lK3phrzAkOrhfRxwizItJ9S5saaHLP4A7JfyULF90OH5VUB2mPUVSJkYWq90CkSEKABA
         1AEx2tgF6EFVUVHWD9jYeaYIWITjiRuvVOa7jAIdaoiRIaCEYcxPO7kyvNzfjuIQShKO
         XP4LEDfv21O9dnz5Gv/X2g+d1WHj7vX4bLUKcpcNVHvNljUEi2HCdsI1JJ7zHRS/dlh8
         hotw==
X-Gm-Message-State: AOAM530OUvVoRz3ddlddIFMHLofRZPyiPrhmN9oCllkel9hbSL8FHPEv
        Gh8I7o4++WaNaFX41h1H8uP/O4ib3LuDZgnN7KELPdX0bNdN
X-Google-Smtp-Source: ABdhPJygsyK2Vg7E/T4BB9XKQGhiLjySMxeGIWjnVsQ3Y7mdHOw/zPYzo7vHaRR9JfmtztW9YO4105Fq0nDfS+tKwBuZ72HPfz4C
MIME-Version: 1.0
X-Received: by 2002:a5d:958e:: with SMTP id a14mr23593863ioo.157.1592893631204;
 Mon, 22 Jun 2020 23:27:11 -0700 (PDT)
Date:   Mon, 22 Jun 2020 23:27:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d958105a8ba73bf@google.com>
Subject: possible deadlock in rds_wake_sk_sleep (3)
From:   syzbot <syzbot+4670352c72e1f1994dc3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cb8e59cc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155e8915100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=4670352c72e1f1994dc3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4670352c72e1f1994dc3@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.7.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/13525 is trying to acquire lock:
ffff88808bdab658 (&rs->rs_recv_lock){..--}-{2:2}, at: rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109

but task is already holding lock:
ffff888050ad2900 (&rm->m_rs_lock){..-.}-{2:2}, at: rds_send_remove_from_sock+0x35a/0xa00 net/rds/send.c:628

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rm->m_rs_lock){..-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
       rds_message_purge net/rds/message.c:138 [inline]
       rds_message_put net/rds/message.c:180 [inline]
       rds_message_put+0x1d5/0xd90 net/rds/message.c:173
       rds_inc_put+0x13a/0x1a0 net/rds/recv.c:82
       rds_clear_recv_queue+0x14a/0x350 net/rds/recv.c:770
       rds_release+0x102/0x3f0 net/rds/af_rds.c:73
       __sock_release+0xcd/0x280 net/socket.c:605
       sock_close+0x18/0x20 net/socket.c:1278
       __fput+0x33e/0x880 fs/file_table.c:281
       task_work_run+0xf4/0x1b0 kernel/task_work.c:123
       tracehook_notify_resume include/linux/tracehook.h:188 [inline]
       exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
       prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
       syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
       do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
       entry_SYSCALL_64_after_hwframe+0x49/0xb3

-> #0 (&rs->rs_recv_lock){..--}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a9c/0x4a70 kernel/locking/lockdep.c:4380
       lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4959
       __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
       _raw_read_lock_irqsave+0x93/0xd0 kernel/locking/spinlock.c:231
       rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109
       rds_send_remove_from_sock+0xc1/0xa00 net/rds/send.c:634
       rds_send_path_drop_acked+0x303/0x3d0 net/rds/send.c:710
       rds_tcp_write_space+0x1a7/0x658 net/rds/tcp_send.c:198
       tcp_new_space net/ipv4/tcp_input.c:5226 [inline]
       tcp_check_space+0x178/0x730 net/ipv4/tcp_input.c:5237
       tcp_data_snd_check net/ipv4/tcp_input.c:5247 [inline]
       tcp_rcv_established+0x17dc/0x1d90 net/ipv4/tcp_input.c:5654
       tcp_v4_do_rcv+0x605/0x8b0 net/ipv4/tcp_ipv4.c:1629
       sk_backlog_rcv include/net/sock.h:996 [inline]
       __release_sock+0x134/0x3a0 net/core/sock.c:2548
       release_sock+0x54/0x1b0 net/core/sock.c:3064
       rds_send_xmit+0x1487/0x2510 net/rds/send.c:422
       rds_sendmsg+0x273d/0x3100 net/rds/send.c:1381
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
       ___sys_sendmsg+0x100/0x170 net/socket.c:2406
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
       do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
       entry_SYSCALL_64_after_hwframe+0x49/0xb3

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rm->m_rs_lock);
                               lock(&rs->rs_recv_lock);
                               lock(&rm->m_rs_lock);
  lock(&rs->rs_recv_lock);

 *** DEADLOCK ***

3 locks held by syz-executor.0/13525:
 #0: ffff888064497020 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1576 [inline]
 #0: ffff888064497020 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sock_set_cork+0x16/0x90 net/ipv4/tcp.c:2829
 #1: ffff8880644972c8 (k-clock-AF_INET){++.-}-{2:2}, at: rds_tcp_write_space+0x25/0x658 net/rds/tcp_send.c:184
 #2: ffff888050ad2900 (&rm->m_rs_lock){..-.}-{2:2}, at: rds_send_remove_from_sock+0x35a/0xa00 net/rds/send.c:628

stack backtrace:
CPU: 1 PID: 13525 Comm: syz-executor.0 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a9c/0x4a70 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4959
 __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
 _raw_read_lock_irqsave+0x93/0xd0 kernel/locking/spinlock.c:231
 rds_wake_sk_sleep+0x1f/0xe0 net/rds/af_rds.c:109
 rds_send_remove_from_sock+0xc1/0xa00 net/rds/send.c:634
 rds_send_path_drop_acked+0x303/0x3d0 net/rds/send.c:710
 rds_tcp_write_space+0x1a7/0x658 net/rds/tcp_send.c:198
 tcp_new_space net/ipv4/tcp_input.c:5226 [inline]
 tcp_check_space+0x178/0x730 net/ipv4/tcp_input.c:5237
 tcp_data_snd_check net/ipv4/tcp_input.c:5247 [inline]
 tcp_rcv_established+0x17dc/0x1d90 net/ipv4/tcp_input.c:5654
 tcp_v4_do_rcv+0x605/0x8b0 net/ipv4/tcp_ipv4.c:1629
 sk_backlog_rcv include/net/sock.h:996 [inline]
 __release_sock+0x134/0x3a0 net/core/sock.c:2548
 release_sock+0x54/0x1b0 net/core/sock.c:3064
 rds_send_xmit+0x1487/0x2510 net/rds/send.c:422
 rds_sendmsg+0x273d/0x3100 net/rds/send.c:1381
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca59
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6d9be39c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000005019e0 RCX: 000000000045ca59
RDX: 0000000000000040 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a1d R14: 00000000004cd008 R15: 00007f6d9be3a6d4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
