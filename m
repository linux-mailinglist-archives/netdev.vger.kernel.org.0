Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E62923BD79
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgHDPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 11:46:25 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:33112 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgHDPqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:46:21 -0400
Received: by mail-io1-f69.google.com with SMTP id a12so29468806ioo.0
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6DIGHsfagDAKp/ULUYoRigrhDRxL/hgZYQkhUVMz60M=;
        b=FF2MO1tqBGKdg5hkBtkgzQyBGKRZkEmFgiRWjtLEb2tefP2tMo7f9oSNyZKTb5F8No
         KNNK5b+iYZkZUCRPiNEWYI2ZRY3e44bdlv5bgfPNlTMthMSJWwh1pPeaje6oui9Nhl3E
         v7h08GpCuUWOl/q8+TazbDUVzTd8b7gPg1vtPQ0aAUkRVH8Q37JXMmgIBPZGSNual3sc
         gn+552k4b9h4DJ28JUfrDjMO7RtiSIGcLnCgkOZKjTCqbGBHRjh9ncVQ/SoK2lj7Sy0V
         ijmZw/WyQmqwuIfU3VTgo5HmxjhYJMDi9scp2jPKMz1uR3Wn5/a1BdxLZQjIXmDmyN4C
         w77A==
X-Gm-Message-State: AOAM5311yyIYV4k3nw4zUFIupWUa0QhymUHZ37Qpf22keF5qrMVdORSU
        NTYFOsgPB7mJ2taRuVj+yhggOee0ZJemsgTV5Ko8NHEpsloL
X-Google-Smtp-Source: ABdhPJwREH5djPThxSKSlsh2hZXG0gUc6T8OaJnHQpaUn8wwW0H6qM9YYvSOZhhGKa36+anYlyxP3/n0XA3MFh4u/NGsX+q9GZiB
MIME-Version: 1.0
X-Received: by 2002:a92:9106:: with SMTP id t6mr5721334ild.105.1596555980358;
 Tue, 04 Aug 2020 08:46:20 -0700 (PDT)
Date:   Tue, 04 Aug 2020 08:46:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012cbe905ac0f28c1@google.com>
Subject: KASAN: use-after-free Read in __sco_sock_close
From:   syzbot <syzbot+a9b58a6aa2a3e1d37f87@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bcf87687 Linux 5.8
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107dbe0a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b489d75d0c8859d
dashboard link: https://syzkaller.appspot.com/bug?extid=a9b58a6aa2a3e1d37f87
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145f6342900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9b58a6aa2a3e1d37f87@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x5e1/0x800 kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff8880a74d4e8c by task syz-executor.5/18383

CPU: 1 PID: 18383 Comm: syz-executor.5 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
 do_raw_spin_lock+0x5e1/0x800 kernel/locking/spinlock_debug.c:112
 spin_lock include/linux/spinlock.h:353 [inline]
 sco_chan_del net/bluetooth/sco.c:142 [inline]
 __sco_sock_close+0x408/0xed0 net/bluetooth/sco.c:433
 sco_sock_close net/bluetooth/sco.c:447 [inline]
 sco_sock_release+0x63/0x4f0 net/bluetooth/sco.c:1021
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1278
 __fput+0x2f0/0x750 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 get_signal+0x15ab/0x1d30 kernel/signal.c:2547
 do_signal+0x33/0x610 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0xd7/0x1e0 arch/x86/entry/common.c:269
 do_syscall_64+0x7f/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cce9
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff2665afc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000000000002140 RCX: 000000000045cce9
RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffdf046a56f R14: 00007ff2665b09c0 R15: 000000000078bf0c

Allocated by task 18383:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 sco_conn_add net/bluetooth/sco.c:112 [inline]
 sco_connect net/bluetooth/sco.c:247 [inline]
 sco_sock_connect+0x3c6/0xaa0 net/bluetooth/sco.c:576
 __sys_connect_file net/socket.c:1854 [inline]
 __sys_connect+0x2da/0x360 net/socket.c:1871
 __do_sys_connect net/socket.c:1882 [inline]
 __se_sys_connect net/socket.c:1879 [inline]
 __x64_sys_connect+0x76/0x80 net/socket.c:1879
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8113:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 sco_connect_cfm+0x96/0x7e0 net/bluetooth/sco.c:1136
 hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
 hci_sco_setup+0xf0/0x3e0 net/bluetooth/hci_conn.c:399
 hci_conn_complete_evt net/bluetooth/hci_event.c:2641 [inline]
 hci_event_packet+0x1258e/0x18260 net/bluetooth/hci_event.c:6033
 hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880a74d4e80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 12 bytes inside of
 96-byte region [ffff8880a74d4e80, ffff8880a74d4ee0)
The buggy address belongs to the page:
page:ffffea00029d3500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00023cae88 ffffea000288c588 ffff8880aa400540
raw: 0000000000000000 ffff8880a74d4000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a74d4d80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880a74d4e00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff8880a74d4e80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                      ^
 ffff8880a74d4f00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ffff8880a74d4f80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
