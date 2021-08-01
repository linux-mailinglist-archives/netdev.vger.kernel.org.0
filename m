Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70433DCB25
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhHAKed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:34:33 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37823 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhHAKec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:34:32 -0400
Received: by mail-io1-f72.google.com with SMTP id e7-20020a0566020447b029050017e563a6so9472894iov.4
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=47KcKz4WmoeO48+LZQ2h16RP+E2fy2ebXX67GEn8Y5E=;
        b=Gs4Uh3nlasZNEsEDOOY5jaUXVsealqpTNR9VVvHWzCVgpvfDTSPHq/e+zS/SKWmKo3
         ce75Z3F0/B8NZZufCrW5WKDFwmdy5Y1kzGi/A4+hB2wPHyVBXb40JNMNCTyz65fjkWyZ
         EzTTNzF9DSQ7wxHtm5jVnDj8quWjdit08w2EiFQ6V2+3KkhXwqhTmM9GK3zelaBJWVCN
         NYOHuS9tRsjFw7fQC3pSG+b0R8fRP4j9Z75aB5YkQODTfuRiYXa1Za6t5o/pdS+Rvy+T
         iixTWNQdPjA+F+6lsNP9HYWhk+ih+kIl7/bQmSqasJyMz5wAMmuSBMEAnKNj81duFwD1
         TBKA==
X-Gm-Message-State: AOAM532kbiHxLcQEd69e3w8KL4TsJA25PCUrP/Slliz721IgyFMenOsD
        541Tq7C6D9d4z0Ay71XZNudFqjpzL65+8jAtwElP4yRh+QJ4
X-Google-Smtp-Source: ABdhPJxsHaS2oHjQB1mYPEN/MH2N/WwPYMj2AKK565H1YFt3GrjQfjx7qT9GGHQbw7RDa7otbupK6OQVMe4MCzvIurzP0kF5JtYT
MIME-Version: 1.0
X-Received: by 2002:a5d:9eda:: with SMTP id a26mr62677ioe.166.1627814064557;
 Sun, 01 Aug 2021 03:34:24 -0700 (PDT)
Date:   Sun, 01 Aug 2021 03:34:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014105005c87cffdc@google.com>
Subject: [syzbot] possible deadlock in br_ioctl_call
From:   syzbot <syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3bdc70669eb2 Merge branch 'devlink-register'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11ee370a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
dashboard link: https://syzkaller.appspot.com/bug?extid=34fe5894623c4ab1b379
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114398c6300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d6d61a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor772/8460 is trying to acquire lock:
ffffffff8d0a9608 (br_ioctl_mutex){+.+.}-{3:3}, at: br_ioctl_call+0x3b/0xa0 net/socket.c:1089

but task is already holding lock:
ffffffff8d0cb568 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x1a7/0xee0 net/core/dev_ioctl.c:579

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rtnl_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:959 [inline]
       __mutex_lock+0x12a/0x10a0 kernel/locking/mutex.c:1104
       register_netdev+0x11/0x50 net/core/dev.c:10474
       br_add_bridge+0x97/0xf0 net/bridge/br_if.c:459
       br_ioctl_stub+0x750/0x7f0 net/bridge/br_ioctl.c:390
       br_ioctl_call+0x5e/0xa0 net/socket.c:1091
       sock_ioctl+0x30c/0x640 net/socket.c:1185
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:1069 [inline]
       __se_sys_ioctl fs/ioctl.c:1055 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (br_ioctl_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:959 [inline]
       __mutex_lock+0x12a/0x10a0 kernel/locking/mutex.c:1104
       br_ioctl_call+0x3b/0xa0 net/socket.c:1089
       dev_ifsioc+0xc1f/0xf60 net/core/dev_ioctl.c:382
       dev_ioctl+0x1b9/0xee0 net/core/dev_ioctl.c:580
       sock_do_ioctl+0x18b/0x210 net/socket.c:1128
       sock_ioctl+0x2f1/0x640 net/socket.c:1231
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:1069 [inline]
       __se_sys_ioctl fs/ioctl.c:1055 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rtnl_mutex);
                               lock(br_ioctl_mutex);
                               lock(rtnl_mutex);
  lock(br_ioctl_mutex);

 *** DEADLOCK ***

1 lock held by syz-executor772/8460:
 #0: ffffffff8d0cb568 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x1a7/0xee0 net/core/dev_ioctl.c:579

stack backtrace:
CPU: 0 PID: 8460 Comm: syz-executor772 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 __mutex_lock_common kernel/locking/mutex.c:959 [inline]
 __mutex_lock+0x12a/0x10a0 kernel/locking/mutex.c:1104
 br_ioctl_call+0x3b/0xa0 net/socket.c:1089
 dev_ifsioc+0xc1f/0xf60 net/core/dev_ioctl.c:382
 dev_ioctl+0x1b9/0xee0 net/core/dev_ioctl.c:580
 sock_do_ioctl+0x18b/0x210 net/socket.c:1128
 sock_ioctl+0x2f1/0x640 net/socket.c:1231
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4431f9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd0ab19648 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd0ab19658 RCX: 00000000004431f9
RDX: 0000000020000000 RSI: 00000000000089a2 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd0ab19660
R13


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
