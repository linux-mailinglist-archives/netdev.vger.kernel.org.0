Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E8659B249
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 08:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiHUGYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 02:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiHUGYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 02:24:30 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A96F22BFF
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 23:24:29 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id c7-20020a056e020bc700b002e59be6ce85so6155410ilu.12
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 23:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=PqboCOCwyASLavKwg3VOY5lF9ER/zs7glAbEsMVMddk=;
        b=2OvMKGjM9SbavShJrLHjTE8EH9Peo9fqS3iW/C3mzaqq2/uUOdhfDElHw61GNPU+6Q
         tnTwneOF65URCyxysigX6iwwp1jlhKG6KgUOsw7Kt4915cXtm2nWH6/s/mNa0G4rVhZD
         MxpvT4yCudcxhbHSi0Mah9LyeV9LJIiMzmYXqoCXUwsuvH4vC9bzaKpqg7K/f5iCs5U7
         JOCOS0oTe5WL6OHbtvdA3dHk/JkhW76fbKQufJjUMxQwhqhP30dDWJzxo/vPow1pXjQE
         9NRL3vNAd7zPnqsqasj/Z+IYPIpaLCTZeLuttYw4CcRPLUcRECwAmi5vwmG4HQy7y4b2
         5nzA==
X-Gm-Message-State: ACgBeo0+qHdPeO1f75xchn4zmnvoyNp8OXRV6pMqnFrLJnEE2KoZN/OE
        JhP0FqgwsPJuMlcTFz8nRKXOhdPhXAj04E5DWhsKUmi6Kr1E
X-Google-Smtp-Source: AA6agR6toP/uLZC9/Mjkijg+F5nQ6hr+rCdJi9lecAXpeeLcIoxAQ14XnfJqhkKTT/uWDLkIQiomgqsjiSqdpNqL7EjR+nPCfDSE
MIME-Version: 1.0
X-Received: by 2002:a6b:5d0f:0:b0:688:6559:7a00 with SMTP id
 r15-20020a6b5d0f000000b0068865597a00mr6250707iob.42.1661063068701; Sat, 20
 Aug 2022 23:24:28 -0700 (PDT)
Date:   Sat, 20 Aug 2022 23:24:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028d96a05e6ba6266@google.com>
Subject: [syzbot] possible deadlock in kcm_ioctl
From:   syzbot <syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, nikolay@nvidia.com, pabeni@redhat.com,
        sgarzare@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    95d10484d66e Add linux-next specific files for 20220817
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11b3b2f3080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f5fa747986be53a
dashboard link: https://syzkaller.appspot.com/bug?extid=e696806ef96cdd2d87cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1778e50d080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1379e5e3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc1-next-20220817-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor769/3613 is trying to acquire lock:
ffff88801cb5c0f8 ((work_completion)(&strp->work)){+.+.}-{0:0}, at: __flush_work+0xdd/0xae0 kernel/workqueue.c:3066

but task is already holding lock:
ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1687 [inline]
ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_attach net/kcm/kcmsock.c:1390 [inline]
ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_attach_ioctl net/kcm/kcmsock.c:1490 [inline]
ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_ioctl+0x396/0x1180 net/kcm/kcmsock.c:1696

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0x36/0xf0 net/core/sock.c:3391
       do_strp_work net/strparser/strparser.c:398 [inline]
       strp_work+0x40/0x130 net/strparser/strparser.c:415
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

-> #0 ((work_completion)(&strp->work)){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5666 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
       __flush_work+0x105/0xae0 kernel/workqueue.c:3069
       __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
       strp_done+0x64/0xf0 net/strparser/strparser.c:513
       kcm_attach net/kcm/kcmsock.c:1429 [inline]
       kcm_attach_ioctl net/kcm/kcmsock.c:1490 [inline]
       kcm_ioctl+0x913/0x1180 net/kcm/kcmsock.c:1696
       sock_do_ioctl+0xcc/0x230 net/socket.c:1169
       sock_ioctl+0x2f1/0x640 net/socket.c:1286
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:870 [inline]
       __se_sys_ioctl fs/ioctl.c:856 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_INET6);
                               lock((work_completion)(&strp->work));
                               lock(sk_lock-AF_INET6);
  lock((work_completion)(&strp->work));

 *** DEADLOCK ***

1 lock held by syz-executor769/3613:
 #0: ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1687 [inline]
 #0: ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_attach net/kcm/kcmsock.c:1390 [inline]
 #0: ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_attach_ioctl net/kcm/kcmsock.c:1490 [inline]
 #0: ffff88801d5b0fb0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: kcm_ioctl+0x396/0x1180 net/kcm/kcmsock.c:1696

stack backtrace:
CPU: 0 PID: 3613 Comm: syz-executor769 Not tainted 6.0.0-rc1-next-20220817-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __flush_work+0x105/0xae0 kernel/workqueue.c:3069
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
 strp_done+0x64/0xf0 net/strparser/strparser.c:513
 kcm_attach net/kcm/kcmsock.c:1429 [inline]
 kcm_attach_ioctl net/kcm/kcmsock.c:1490 [inline]
 kcm_ioctl+0x913/0x1180 net/kcm/kcmsock.c:1696
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x2f1/0x640 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc907a73f09
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5f76b0d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc907a73f09
RDX: 00000000200000c0 RSI: 00000000000089e0 RDI: 0000000000000003


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
