Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920BF61C3E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfGHJRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:35115 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbfGHJRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:07 -0400
Received: by mail-io1-f69.google.com with SMTP id w17so18400261iom.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 02:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6Zur9AJgLx1rFwFRhvX8hzY44srk5dm7/NYk1XyNsWo=;
        b=BEQx4C7etpnGJ82hiSYabBcD9d3oMJsa7owjdleYBxpWCxXr6R0RRvVhPWkPGHHEj9
         RkIVyWY/TWLfNhUU63IP6AtT4fPNZpgDpwMmQWfKgaYNbgtVgkvJT/Ttjn1u8sPtnXVn
         PgiwMNXsACt4GG7AzCQZgdgIITC48B5DpVaoMsMV8RSwL4Sp2bEoS89e/ZgQKCzsf7jJ
         hSGfTajKAgi7L1ka+iACahrQr6+6iG4unb54UMBFvClh9WlF8pumDj3sV2yJENquC5l3
         oNyBo1u/JiSHyaeJpvtERRYHJmjHNNytgoDsKIOysCigpMU0j7W03IwykfjaXlBqKv9I
         IF9Q==
X-Gm-Message-State: APjAAAWuMSXkLDcDFmUq2cvF12oZjsIU1Rsz42tL0Lwy8i6h6OZCucQm
        xowkeEUgyavoPSnf6ZI5pXtMkSzlSaaA4+PM0cOgiTMo8Xrd
X-Google-Smtp-Source: APXvYqygQ0iIE3rjam4X8l//nYtSCithi3A4I4aoGQDZxl4UscLx2Mgi2vls+kw6Ey99+2Czm+ResQzRml3BHLslwKS1XKjOQdX/
MIME-Version: 1.0
X-Received: by 2002:a02:b68f:: with SMTP id i15mr20028702jam.107.1562577426421;
 Mon, 08 Jul 2019 02:17:06 -0700 (PDT)
Date:   Mon, 08 Jul 2019 02:17:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006fa5eb058d27e8d1@google.com>
Subject: possible deadlock in xsk_notifier
From:   syzbot <syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, hawk@kernel.org, i.maximets@samsung.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        johannes.berg@intel.com, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        petrm@mellanox.com, roopa@cumulusnetworks.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9d1bc24b bonding: validate ip header before check IPPROTO_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1464c78ba00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7c31a94f66cc0aa
dashboard link: https://syzkaller.appspot.com/bug?extid=bf64ec93de836d7f4c2c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1397378ba00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f51315a00000

The bug was bisected to:

commit 455302d1c9ae9318660aaeb9748a01ff414c9741
Author: Ilya Maximets <i.maximets@samsung.com>
Date:   Fri Jun 28 08:04:07 2019 +0000

     xdp: fix hang while unregistering device bound to xdp socket

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1092d9aba00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1292d9aba00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1492d9aba00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com
Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound to xdp  
socket")

======================================================
WARNING: possible circular locking dependency detected
5.2.0-rc6+ #75 Not tainted
------------------------------------------------------
syz-executor831/8960 is trying to acquire lock:
00000000f6cc1fdf (&xs->mutex){+.+.}, at: xsk_notifier+0x149/0x290  
net/xdp/xsk.c:730

but task is already holding lock:
00000000f06c3f54 (&net->xdp.lock){+.+.}, at: xsk_notifier+0xa7/0x290  
net/xdp/xsk.c:726

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&net->xdp.lock){+.+.}:
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

-> #1 (rtnl_mutex){+.+.}:
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

-> #0 (&xs->mutex){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
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

other info that might help us debug this:

Chain exists of:
   &xs->mutex --> rtnl_mutex --> &net->xdp.lock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&net->xdp.lock);
                                lock(rtnl_mutex);
                                lock(&net->xdp.lock);
   lock(&xs->mutex);

  *** DEADLOCK ***

3 locks held by syz-executor831/8960:
  #0: 00000000060d4522 (br_ioctl_mutex){+.+.}, at: sock_ioctl+0x427/0x780  
net/socket.c:1139
  #1: 000000006ae5b4ee (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:72
  #2: 00000000f06c3f54 (&net->xdp.lock){+.+.}, at: xsk_notifier+0xa7/0x290  
net/xdp/xsk.c:726

stack backtrace:
CPU: 1 PID: 8960 Comm: syz-executor831 Not tainted 5.2.0-rc6+ #75
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
RIP: 0033:0x447929
Code: e8 cc e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 3b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f24c6077d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006dcc58 RCX: 0000000000447929
RDX: 0000000020000180 RSI: 00000000000089a1 RDI: 0000000000000003
RBP: 00000000006dcc50 R08: 00007f24c6078700 R09: 0000000000000000
R10: 00007f24c6078700 R11: 0000000000000246 R12: 00000000006dcc5c
R13: 0000003066736362 R14: 0000000000000000 R15: 0000003066736362
kobject: 'batman_adv' (00000000e09eb5f6): kobject_uevent_env
kobject: 'batman_adv' (00000000e09eb5f6): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'batman_adv' (00000000e09eb5f6): kobject_cleanup, parent  
00000000e11c2695
kobject: 'batman_adv' (00000000e09eb5f6): calling ktype release
kobject: (00000000e09eb5f6): dynamic_kobj_release
kobject: 'batman_adv': free name
kobject: 'rx-0' (00000000fc3ea8b5): kobject_cleanup, parent 000000000f96f49f
kobject: 'rx-0' (00000000fc3ea8b5): auto cleanup 'remove' event
kobject: 'rx-0' (00000000fc3ea8b5): kobject_uevent_env
kobject: 'rx-0' (00000000fc3ea8b5): fill_kobj_path: path  
= '/devices/virtual/net/bcsf0/queues/rx-0'
kobject: 'rx-0' (00000000fc3ea8b5): auto cleanup kobject_del
kobject: 'rx-0' (00000000fc3ea8b5): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000089e0fc81): kobject_cleanup, parent 000000000f96f49f
kobject: 'tx-0' (0000000089e0fc81): auto cleanup 'remove' event
kobject: 'tx-0' (0000000089e0fc81): kobject_uevent_env
kobject: 'tx-0' (0000000089e0fc81): fill_kobj_path: path  
= '/devices/virtual/net/bcsf0/queues/tx-0'
kobject: 'tx-0' (0000000089e0fc81): auto cleanup kobject_del
kobject: 'tx-0' (0000000089e0fc81): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000000f96f49f): kobject_cleanup, parent  
00000000e11c2695
kobject: 'queues' (000000000f96f49f): calling ktype release
kobject: 'queues' (000000000f96f49f): kset_release
kobject: 'queues': free name
kobject: 'bcsf0' (00000000e3247f71): kobject_uevent_env
kobject: 'bcsf0' (00000000e3247f71): fill_kobj_path: path  
= '/devices/virtual/net/bcsf0'
kobject: 'bcsf0' (00000000e3247f71): kobject_cleanup, parent  
00000000e11c2695
kobject: 'bcsf0' (00000000e3247f71): calling ktype release
kobject: 'bcsf0': free name


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
