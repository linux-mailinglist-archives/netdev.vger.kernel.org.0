Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597C7629BA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404068AbfGHThJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:37:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36421 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391726AbfGHThI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:37:08 -0400
Received: by mail-io1-f69.google.com with SMTP id k21so20194578ioj.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rvU9EpJ/ZrGJ01qsksyZdkenSMAoMztu/ZdDa0dDQNo=;
        b=Ng1GZxmY1QAl2b3jB4jyIkgF6Q5oIYQJzL+CwL0vXp+kWGvzax1fFGDMZu9A0VnDiM
         z29EhMD0gl188X0tL7Oj8t/zxMkIw5hcZjKY/kXXc/FkmpfUQBz1k69iW3peUgOi8gL3
         C/3ztJU7xfnaWfY0IOdhb32ZTFAAj548n632RLr5UVFUq1IeUby1LbXacW958vpGjDRs
         YACGrU8VMpU8VAjgYmROwwy/8tQ16Qu58F+/OdYlByu8S6t/Rfhf7+4k2kfxNRfeDhP+
         dAriJNPl29PDKQcOGCCLqMQ4LctTM7A1InnyIAfksFfsJNF9dD7JJWUMlsUFDKTbl7Rd
         LXoQ==
X-Gm-Message-State: APjAAAXHbQ7N5aJeMmKDw0i/jG8usBml6z7YrgJXPyZYTuvPO6bXr2D7
        XjDt4TCURoqux2VsDELAUzJ4QGQbUCLK2fqctig3PpBBFtH0
X-Google-Smtp-Source: APXvYqziWldilP8K4vSOqdpjtylCdvMsx2+OcaZ8+SIDv2t9XOOmVzSHETzg0mpxmT6eA7sqSzsBIXyu2E8IBvgCWRHVNPt/xftW
MIME-Version: 1.0
X-Received: by 2002:a02:ca19:: with SMTP id i25mr24171955jak.6.1562614626405;
 Mon, 08 Jul 2019 12:37:06 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:37:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba542e058d309136@google.com>
Subject: possible deadlock in rtnl_lock (6)
From:   syzbot <syzbot+174ce29c2308dec5bc68@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, edumazet@google.com, hawk@kernel.org,
        i.maximets@samsung.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, petrm@mellanox.com,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    537de0c8 ipv4: Fix NULL pointer dereference in ipv4_neigh_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14521cc3a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90f5d2d9c1e7421c
dashboard link: https://syzkaller.appspot.com/bug?extid=174ce29c2308dec5bc68
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1777debba00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16969b53a00000

The bug was bisected to:

commit 455302d1c9ae9318660aaeb9748a01ff414c9741
Author: Ilya Maximets <i.maximets@samsung.com>
Date:   Fri Jun 28 08:04:07 2019 +0000

     xdp: fix hang while unregistering device bound to xdp socket

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1179943da00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1379943da00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1579943da00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+174ce29c2308dec5bc68@syzkaller.appspotmail.com
Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound to xdp  
socket")

======================================================
WARNING: possible circular locking dependency detected
5.2.0-rc6+ #76 Not tainted
------------------------------------------------------
syz-executor613/9114 is trying to acquire lock:
000000002c564901 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:72

but task is already holding lock:
0000000039d6ee9b (&xs->mutex){+.+.}, at: xsk_bind+0x16a/0xe70  
net/xdp/xsk.c:422

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&xs->mutex){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:926 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1073
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1088
        xsk_notifier+0x149/0x290 net/xdp/xsk.c:730
        notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
        __raw_notifier_call_chain kernel/notifier.c:396 [inline]
        raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
        call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1749
        call_netdevice_notifiers_extack net/core/dev.c:1761 [inline]
        call_netdevice_notifiers net/core/dev.c:1775 [inline]
        rollback_registered_many+0x9b9/0xfc0 net/core/dev.c:8206
        rollback_registered+0x109/0x1d0 net/core/dev.c:8248
        unregister_netdevice_queue net/core/dev.c:9295 [inline]
        unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9288
        br_dev_delete+0x145/0x1a0 net/bridge/br_if.c:383
        br_del_bridge+0xd7/0x120 net/bridge/br_if.c:483
        br_ioctl_deviceless_stub+0x2a4/0x7b0 net/bridge/br_ioctl.c:376
        sock_ioctl+0x44b/0x780 net/socket.c:1141
        vfs_ioctl fs/ioctl.c:46 [inline]
        file_ioctl fs/ioctl.c:509 [inline]
        do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
        ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
        __do_sys_ioctl fs/ioctl.c:720 [inline]
        __se_sys_ioctl fs/ioctl.c:718 [inline]
        __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
        do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (&net->xdp.lock){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:926 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1073
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1088
        xsk_notifier+0xa7/0x290 net/xdp/xsk.c:726
        notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
        __raw_notifier_call_chain kernel/notifier.c:396 [inline]
        raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
        call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1749
        call_netdevice_notifiers_extack net/core/dev.c:1761 [inline]
        call_netdevice_notifiers net/core/dev.c:1775 [inline]
        rollback_registered_many+0x9b9/0xfc0 net/core/dev.c:8206
        rollback_registered+0x109/0x1d0 net/core/dev.c:8248
        unregister_netdevice_queue net/core/dev.c:9295 [inline]
        unregister_netdevice_queue+0x1ee/0x2c0 net/core/dev.c:9288
        br_dev_delete+0x145/0x1a0 net/bridge/br_if.c:383
        br_del_bridge+0xd7/0x120 net/bridge/br_if.c:483
        br_ioctl_deviceless_stub+0x2a4/0x7b0 net/bridge/br_ioctl.c:376
        sock_ioctl+0x44b/0x780 net/socket.c:1141
        vfs_ioctl fs/ioctl.c:46 [inline]
        file_ioctl fs/ioctl.c:509 [inline]
        do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
        ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
        __do_sys_ioctl fs/ioctl.c:720 [inline]
        __se_sys_ioctl fs/ioctl.c:718 [inline]
        __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
        do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (rtnl_mutex){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
        __mutex_lock_common kernel/locking/mutex.c:926 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1073
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1088
        rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
        xdp_umem_assign_dev+0xbe/0x8b0 net/xdp/xdp_umem.c:96
        xsk_bind+0x4d7/0xe70 net/xdp/xsk.c:488
        __sys_bind+0x239/0x290 net/socket.c:1653
        __do_sys_bind net/socket.c:1664 [inline]
        __se_sys_bind net/socket.c:1662 [inline]
        __x64_sys_bind+0x73/0xb0 net/socket.c:1662
        do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
   rtnl_mutex --> &net->xdp.lock --> &xs->mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&xs->mutex);
                                lock(&net->xdp.lock);
                                lock(&xs->mutex);
   lock(rtnl_mutex);

  *** DEADLOCK ***

1 lock held by syz-executor613/9114:
  #0: 0000000039d6ee9b (&xs->mutex){+.+.}, at: xsk_bind+0x16a/0xe70  
net/xdp/xsk.c:422

stack backtrace:
CPU: 1 PID: 9114 Comm: syz-executor613 Not tainted 5.2.0-rc6+ #76
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_circular_bug.cold+0x1cc/0x28f kernel/locking/lockdep.c:1565
  check_prev_add kernel/locking/lockdep.c:2310 [inline]
  check_prevs_add kernel/locking/lockdep.c:2418 [inline]
  validate_chain kernel/locking/lockdep.c:2800 [inline]
  __lock_acquire+0x3755/0x5490 kernel/locking/lockdep.c:3793
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
  __mutex_lock_common kernel/locking/mutex.c:926 [inline]
  __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1073
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1088
  rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
  xdp_umem_assign_dev+0xbe/0x8b0 net/xdp/xdp_umem.c:96
  xsk_bind+0x4d7/0xe70 net/xdp/xsk.c:488
  __sys_bind+0x239/0x290 net/socket.c:1653
  __do_sys_bind net/socket.c:1664 [inline]
  __se_sys_bind net/socket.c:1662 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1662
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447909
Code: e8 cc e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 3b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb2a478fd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000006dcc58 RCX: 0000000000447909
RDX: 0000000000000010 RSI: 0000000020000040 RDI: 0000000000000005
RBP: 00000000006dcc50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc5c
R13: 0000003066736362 R14: 0000000000000000 R15: 0000003066736362


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
