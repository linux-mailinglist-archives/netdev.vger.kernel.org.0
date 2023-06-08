Return-Path: <netdev+bounces-9157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B85687279F9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3FFC1C20FDB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FD23B3FA;
	Thu,  8 Jun 2023 08:30:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6AC9471
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:30:54 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32DC2709
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:30:50 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-77ac4ec0bb7so30555939f.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 01:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686213050; x=1688805050;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WK8lPp+uAqV1z2WiaSVD2hwMpnbs+EalTlic1O+h3+Q=;
        b=Smen+wmVo4yUh7CJJ2j5gr1KbGBLGeTobm24cPAu9MQsNdzUaSYS/28FUlheXHDiX7
         BZyp3L0EJ1TYNElexMJNVd45MazVfFpZ7XktGc/4AhhGvEpvfrlVRwRDpXDp0N2nNRHm
         GLxOnwkaxtZ45ispvasVHF7kE1ke3fJ9HjUiSWM0ocdCfjmvGWChZLU+NcAPoUYTmed3
         Daev78cKRJZbRBCHEFeOr+eYxubKPeIcJTIzEOuTn67rXQU6Uqzp32aTxz2V5uqPNTAb
         qHPmy0QaVndA3zEwfMXG3NGjlTTPvJs0ist9EBQ/lWWr9UEIubQCtPhoJWu1aCQdxC88
         NHLA==
X-Gm-Message-State: AC+VfDy4RKh35EZz/wTrU4TdbtWvfDbpUJ5yEBbZxT+drBHbmQB2T7eh
	Q6oOzNNa3QMohtExlxpBYQiHGphyMQpceuxFMMK5PkDvRefj
X-Google-Smtp-Source: ACHHUZ6Sz9NfD6EAf34/7DHTdpL4YBaBpVt47ZDmgc/QRbsIWp05OgEgUkLOTit9Ku5H6ubCvxcKpfurwALvBs+pGYK3wiZHUwT9
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:7348:0:b0:41f:58a4:1cc0 with SMTP id
 a8-20020a027348000000b0041f58a41cc0mr254990jae.2.1686213050305; Thu, 08 Jun
 2023 01:30:50 -0700 (PDT)
Date: Thu, 08 Jun 2023 01:30:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e116ff05fd9a1126@google.com>
Subject: [syzbot] [net?] possible deadlock in sk_diag_fill (5)
From: syzbot <syzbot+94679b52dd4cd45b8d2b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    e8d018dd0257 Linux 6.3-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16738e1cc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d40f6d44826f6cf7
dashboard link: https://syzkaller.appspot.com/bug?extid=94679b52dd4cd45b8d2b
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/37e6a8fafda3/disk-e8d018dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6aadbe17d762/vmlinux-e8d018dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0216f5047041/bzImage-e8d018dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+94679b52dd4cd45b8d2b@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.3.0-rc3-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.2/23477 is trying to acquire lock:
ffff88801d542e80 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:87 [inline]
ffff88801d542e80 (&u->lock/1){+.+.}-{2:2}, at: sk_diag_fill+0x6ea/0xfe0 net/unix/diag.c:157

but task is already holding lock:
ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:69 [inline]
ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x643/0xfe0 net/unix/diag.c:157

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rlock-AF_UNIX){+.+.}-{2:2}:
       lock_acquire+0x1e1/0x520 kernel/locking/lockdep.c:5669
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
       skb_queue_tail+0x36/0x120 net/core/skbuff.c:3683
       unix_dgram_sendmsg+0x1502/0x2050 net/unix/af_unix.c:2082
       sock_sendmsg_nosec net/socket.c:724 [inline]
       sock_sendmsg net/socket.c:747 [inline]
       ____sys_sendmsg+0x58f/0x890 net/socket.c:2501
       ___sys_sendmsg net/socket.c:2555 [inline]
       __sys_sendmmsg+0x3af/0x730 net/socket.c:2641
       __do_sys_sendmmsg net/socket.c:2670 [inline]
       __se_sys_sendmmsg net/socket.c:2667 [inline]
       __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2667
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (&u->lock/1){+.+.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3098 [inline]
       check_prevs_add kernel/locking/lockdep.c:3217 [inline]
       validate_chain+0x166b/0x58e0 kernel/locking/lockdep.c:3832
       __lock_acquire+0x125b/0x1f80 kernel/locking/lockdep.c:5056
       lock_acquire+0x1e1/0x520 kernel/locking/lockdep.c:5669
       _raw_spin_lock_nested+0x31/0x40 kernel/locking/spinlock.c:378
       sk_diag_dump_icons net/unix/diag.c:87 [inline]
       sk_diag_fill+0x6ea/0xfe0 net/unix/diag.c:157
       sk_diag_dump net/unix/diag.c:196 [inline]
       unix_diag_dump+0x3eb/0x640 net/unix/diag.c:220
       netlink_dump+0x65e/0xcd0 net/netlink/af_netlink.c:2296
       __netlink_dump_start+0x536/0x700 net/netlink/af_netlink.c:2401
       netlink_dump_start include/linux/netlink.h:308 [inline]
       unix_diag_handler_dump+0x1c0/0x8e0 net/unix/diag.c:319
       sock_diag_rcv_msg+0xe3/0x400
       netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2574
       sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:280
       netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
       netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1942
       sock_sendmsg_nosec net/socket.c:724 [inline]
       sock_sendmsg net/socket.c:747 [inline]
       sock_write_iter+0x397/0x520 net/socket.c:1138
       do_iter_write+0x6ea/0xc50 fs/read_write.c:861
       vfs_writev fs/read_write.c:934 [inline]
       do_writev+0x27f/0x470 fs/read_write.c:977
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rlock-AF_UNIX);
                               lock(&u->lock/1);
                               lock(rlock-AF_UNIX);
  lock(&u->lock/1);

 *** DEADLOCK ***

5 locks held by syz-executor.2/23477:
 #0: ffffffff8e095308 (sock_diag_mutex){+.+.}-{3:3}, at: sock_diag_rcv+0x1b/0x40 net/core/sock_diag.c:279
 #1: ffffffff8e095168 (sock_diag_table_mutex){+.+.}-{3:3}, at: __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 #1: ffffffff8e095168 (sock_diag_table_mutex){+.+.}-{3:3}, at: sock_diag_rcv_msg+0x214/0x400 net/core/sock_diag.c:269
 #2: ffff88807c415688 (nlk_cb_mutex-SOCK_DIAG){+.+.}-{3:3}, at: netlink_dump+0xe7/0xcd0 net/netlink/af_netlink.c:2244
 #3: ffff888020e5a798 (&net->unx.table.locks[i]){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
 #3: ffff888020e5a798 (&net->unx.table.locks[i]){+.+.}-{2:2}, at: unix_diag_dump+0x192/0x640 net/unix/diag.c:214
 #4: ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
 #4: ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_dump_icons net/unix/diag.c:69 [inline]
 #4: ffff88801d5401e8 (rlock-AF_UNIX){+.+.}-{2:2}, at: sk_diag_fill+0x643/0xfe0 net/unix/diag.c:157

stack backtrace:
CPU: 1 PID: 23477 Comm: syz-executor.2 Not tainted 6.3.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 check_noncircular+0x2fe/0x3b0 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3098 [inline]
 check_prevs_add kernel/locking/lockdep.c:3217 [inline]
 validate_chain+0x166b/0x58e0 kernel/locking/lockdep.c:3832
 __lock_acquire+0x125b/0x1f80 kernel/locking/lockdep.c:5056
 lock_acquire+0x1e1/0x520 kernel/locking/lockdep.c:5669
 _raw_spin_lock_nested+0x31/0x40 kernel/locking/spinlock.c:378
 sk_diag_dump_icons net/unix/diag.c:87 [inline]
 sk_diag_fill+0x6ea/0xfe0 net/unix/diag.c:157
 sk_diag_dump net/unix/diag.c:196 [inline]
 unix_diag_dump+0x3eb/0x640 net/unix/diag.c:220
 netlink_dump+0x65e/0xcd0 net/netlink/af_netlink.c:2296
 __netlink_dump_start+0x536/0x700 net/netlink/af_netlink.c:2401
 netlink_dump_start include/linux/netlink.h:308 [inline]
 unix_diag_handler_dump+0x1c0/0x8e0 net/unix/diag.c:319
 sock_diag_rcv_msg+0xe3/0x400
 netlink_rcv_skb+0x1df/0x430 net/netlink/af_netlink.c:2574
 sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:280
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x7c3/0x990 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0xa2a/0xd60 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 sock_write_iter+0x397/0x520 net/socket.c:1138
 do_iter_write+0x6ea/0xc50 fs/read_write.c:861
 vfs_writev fs/read_write.c:934 [inline]
 do_writev+0x27f/0x470 fs/read_write.c:977
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f22a728c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f22a80c6168 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f22a73abf80 RCX: 00007f22a728c0f9
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007f22a72e7b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc7d0da7bf R14: 00007f22a80c6300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

