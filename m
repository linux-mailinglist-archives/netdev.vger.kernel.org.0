Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D433DCB40
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhHAKoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:44:34 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42899 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhHAKo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:44:27 -0400
Received: by mail-io1-f71.google.com with SMTP id l2-20020a6b7f020000b0290439ea50822eso9463912ioq.9
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oFv1i//qpH6AOffLvv4YPkuxPAX3tmOECGx7x4XlVx4=;
        b=nAm2aHx91qnIwSScRsuX5gZYpLCUuDyLm/nNr+YMjjVCvP6zDkq5a/CKFUwaQnx98r
         JxRO9ZPJLj5AYBnftTjxTTbhGx/pkSc8kTsRytJaAbR9Xd2KjjgNVYvRNYm0GV17S8WY
         2EzXaf7njSG4f6dEvK/Fr34Re9z6ma6PeS8cylJFZRAAZVZ5f+/0Xq8mr39wfgq2iUXP
         2EUciJ0AZpH658J9NsRGR2bPQZorNMTasGcuOEoLFZv4gW5vqajbVAbRcD37Yjfl7iz6
         gCB+dQ3KVuYTSRLDI9EoPxZvH/cY4iMblINlWPQFxdaTZC1IzZsBnc0hLaLObF9Z6jRY
         LpvQ==
X-Gm-Message-State: AOAM5318vJnQYbEa5loudq4laorSVIhILGkk/hr/Yg4/v/aVBFWQ6xJE
        JqVzi1Nj6R7Ln48vaLO5iCHH1DS5zo79/1NcTOSedpv8eg+G
X-Google-Smtp-Source: ABdhPJyeh4ufoAcxLqVJHWse/qTK/DiToXD4JjpnUaRyHiv485wYzrBEHTzV8U40IKOuKlWMS3Ws7tiTxgnX7VJxN60WE6JHH6ti
MIME-Version: 1.0
X-Received: by 2002:a5e:db02:: with SMTP id q2mr197603iop.172.1627814659223;
 Sun, 01 Aug 2021 03:44:19 -0700 (PDT)
Date:   Sun, 01 Aug 2021 03:44:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085f72905c87d22f4@google.com>
Subject: [syzbot] possible deadlock in register_netdev
From:   syzbot <syzbot+ed8813d241a91de15965@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=14e77662300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
dashboard link: https://syzkaller.appspot.com/bug?extid=ed8813d241a91de15965
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15581d46300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15bae1b2300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed8813d241a91de15965@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc2-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor917/8441 is trying to acquire lock:
ffffffff8d0cb568 (rtnl_mutex){+.+.}-{3:3}, at: register_netdev+0x11/0x50 net/core/dev.c:10474

but task is already holding lock:
ffffffff8d0a9608 (br_ioctl_mutex){+.+.}-{3:3}, at: br_ioctl_call+0x3b/0xa0 net/socket.c:1089

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (br_ioctl_mutex){+.+.}-{3:3}:
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

-> #0 (rtnl_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
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

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(br_ioctl_mutex);
                               lock(rtnl_mutex);
                               lock(br_ioctl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

1 lock held by syz-executor917/8441:
 #0: ffffffff8d0a9608 (br_ioctl_mutex){+.+.}-{3:3}, at: br_ioctl_call+0x3b/0xa0 net/socket.c:1089

stack backtrace:
CPU: 0 PID: 8441 Comm: syz-executor917 Not tainted 5.14.0-rc2-syzkaller #0
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
RIP: 0033:0x4431e9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd3f5d9338 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd3f5d9348 RCX: 00000000004431e9
RDX: 0000000020000300 RSI: 00000000000089a0 RDI: 0000000000000005
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd3f5d9350
R13: 00007ffd3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
