Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A4A44F802
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhKNNVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 08:21:25 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:57019 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhKNNVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 08:21:17 -0500
Received: by mail-io1-f71.google.com with SMTP id r199-20020a6b2bd0000000b005e234972ddfso9475481ior.23
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 05:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=clbwvZDiR/DlyaikVUjSpRNT1Vppkb7PEK8GespTblw=;
        b=EPRYCnKzakpa7EhZFyl+gFLHx0yeqz/izJ9YRDq/GQNUOld/olo1gcXf+ze7npfDaj
         Q4fmJLbt21OdMchBgCYq0F1HwB+ov0RuwPICrvoGrZqvYpnukfWe8fCpwN9/RxEpJBru
         F+RFO3KphVlnG2d28eyvO0EqVrnjs/jEcmBM65ntU+jGaP8WTxWLY7hqxqEcotwBk279
         KY1Y+lMx0QdRGkihGtJlZkH4FIdfOmwy8iXFMPk3LAKYP8a2dEuWdiuRc+eCstJchsaR
         W4gRdvWr3PgJ4X9Cn1f42FOMs28eSQvz/U51tOC5HaHKcJnfa6G9FvT0EKxypcSWkMFA
         xmog==
X-Gm-Message-State: AOAM5338Ax8RiFd/ic6db106AEXeeV3BRKLnJrHohFCBpHO306CDekW6
        67TtaMM2gp6ta+oCEBA5Cw+/czoxwsaG1KMnt29QKjZ6WDzk
X-Google-Smtp-Source: ABdhPJw3E4VC/zBcHXsdqPH9m8PAXP+aWrZTrrprzfMrvJGTPdLiDuJfhDxB1/n/ti7o5HldlDhY+3j0emLOkmXR9qeDkpapAUhY
MIME-Version: 1.0
X-Received: by 2002:a92:c261:: with SMTP id h1mr16477149ild.291.1636895901759;
 Sun, 14 Nov 2021 05:18:21 -0800 (PST)
Date:   Sun, 14 Nov 2021 05:18:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c23f1405d0bf86d6@google.com>
Subject: [syzbot] KASAN: use-after-free Read in sixpack_close
From:   syzbot <syzbot+b6cb97f812986fb71e8f@syzkaller.appspotmail.com>
To:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linma@zju.edu.cn, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f2e19fd15bd7 Add linux-next specific files for 20211112
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16da6efab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba9c83199208e103
dashboard link: https://syzkaller.appspot.com/bug?extid=b6cb97f812986fb71e8f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ecdefab00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d72ce6b00000

The issue was bisected to:

commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8
Author: Lin Ma <linma@zju.edu.cn>
Date:   Mon Nov 8 10:37:59 2021 +0000

    hamradio: defer 6pack kfree after unregister_netdev

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1420b05eb00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1620b05eb00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1220b05eb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6cb97f812986fb71e8f@syzkaller.appspotmail.com
Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")

sp0: Synchronizing with TNC
==================================================================
BUG: KASAN: use-after-free in sixpack_close+0x236/0x270 drivers/net/hamradio/6pack.c:678
Read of size 8 at addr ffff8880788cac90 by task syz-executor090/6528

CPU: 0 PID: 6528 Comm: syz-executor090 Not tainted 5.15.0-next-20211112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 sixpack_close+0x236/0x270 drivers/net/hamradio/6pack.c:678
 tty_ldisc_close+0x110/0x190 drivers/tty/tty_ldisc.c:474
 tty_ldisc_kill+0x94/0x150 drivers/tty/tty_ldisc.c:629
 tty_ldisc_release+0xe3/0x2a0 drivers/tty/tty_ldisc.c:803
 tty_release_struct+0x20/0xe0 drivers/tty/tty_io.c:1706
 tty_release+0xc70/0x1200 drivers/tty/tty_io.c:1878
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 __do_sys_exit_group kernel/exit.c:940 [inline]
 __se_sys_exit_group kernel/exit.c:938 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6ba32c3f89
Code: Unable to access opcode bytes at RIP 0x7f6ba32c3f5f.
RSP: 002b:00007ffc56c579d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f6ba3337330 RCX: 00007f6ba32c3f89
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6ba3337330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 6528:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:613 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/slab.h:741 [inline]
 kvzalloc include/linux/slab.h:749 [inline]
 alloc_netdev_mqs+0x98/0xec0 net/core/dev.c:10828
 sixpack_open+0xfa/0xa50 drivers/net/hamradio/6pack.c:558
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
 tty_set_ldisc+0x2f1/0x680 drivers/tty/tty_ldisc.c:579
 tiocsetd drivers/tty/tty_io.c:2455 [inline]
 tty_ioctl+0xae0/0x1670 drivers/tty/tty_io.c:2741
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 6528:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
 kvfree+0x42/0x50 mm/util.c:620
 device_release+0x9f/0x240 drivers/base/core.c:2230
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 netdev_run_todo+0x75a/0xa80 net/core/dev.c:10638
 sixpack_close+0x184/0x270 drivers/net/hamradio/6pack.c:675
 tty_ldisc_close+0x110/0x190 drivers/tty/tty_ldisc.c:474
 tty_ldisc_kill+0x94/0x150 drivers/tty/tty_ldisc.c:629
 tty_ldisc_release+0xe3/0x2a0 drivers/tty/tty_ldisc.c:803
 tty_release_struct+0x20/0xe0 drivers/tty/tty_io.c:1706
 tty_release+0xc70/0x1200 drivers/tty/tty_io.c:1878
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 __do_sys_exit_group kernel/exit.c:940 [inline]
 __se_sys_exit_group kernel/exit.c:938 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880788ca000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 3216 bytes inside of
 4096-byte region [ffff8880788ca000, ffff8880788cb000)
The buggy address belongs to the page:
page:ffffea0001e23200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x788c8
head:ffffea0001e23200 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001e28a00 dead000000000003 ffff888010c4c280
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2965, ts 23164777597, free_ts 18335335301
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4467
 kmalloc_node include/linux/slab.h:613 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/slab.h:741 [inline]
 seq_buf_alloc fs/seq_file.c:38 [inline]
 seq_read_iter+0x7e7/0x1240 fs/seq_file.c:210
 kernfs_fop_read_iter+0x44f/0x5f0 fs/kernfs/file.c:241
 call_read_iter include/linux/fs.h:2156 [inline]
 new_sync_read+0x421/0x6e0 fs/read_write.c:400
 vfs_read+0x35c/0x600 fs/read_write.c:481
 ksys_read+0x12d/0x250 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 free_contig_range+0xa8/0xf0 mm/page_alloc.c:9271
 destroy_args+0xa8/0x646 mm/debug_vm_pgtable.c:1016
 debug_vm_pgtable+0x2984/0x2a16 mm/debug_vm_pgtable.c:1330
 do_one_initcall+0x103/0x650 init/main.c:1303
 do_initcall_level init/main.c:1378 [inline]
 do_initcalls init/main.c:1394 [inline]
 do_basic_setup init/main.c:1413 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1618
 kernel_init+0x1a/0x1d0 init/main.c:1507
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff8880788cab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880788cac00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880788cac80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880788cad00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880788cad80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
