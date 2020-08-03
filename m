Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFD239E8E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHCFF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:05:28 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:37322 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgHCFF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:05:27 -0400
Received: by mail-il1-f198.google.com with SMTP id k69so8126656ilg.4
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 22:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cut/OZHOZGCHhxupESbAJlID0VkFW48Y+FIVqKyDOXM=;
        b=Kpwrd2x2TxDHOR6FxlLRnVPCYR7Re//fSfHQhhZ6wAZtPOMdi8qf5gxy/nuq1cMNrz
         5jATPrC6dEQ0Xl5PfL2sL1FK+NV03gZgDt8BGEDe0PwdJFnTfsRrlmivByxSJecgaNu3
         D59PA4PG9BnYy0ttJjdhPertYFUx7TBMEIAMaZbHRz0jkBZSvTsUM9PQCuRVDhr9pUkG
         ynnk554Gwwuy2JtyuM15tVzunJvApY0Pk/UPbbFBHFAEdjrdIk4VJs1AaGWaKWgCtWRA
         XxOpj3iULoN1k/GbrWRzR6+XVe9GU/oI4In+yPjBHpSzix/S/VkKgW1q5NDK/ZBfWORR
         0gpg==
X-Gm-Message-State: AOAM532jmyQqtT38qUTiOV+Q7Ik0zwtwDa6vc4HtV8vBTHt/DfijjSHI
        4Qm+Wa9e2U8etPmnfHZoJ2R1R8s7OAXUdjeDjLjxhunA+xhg
X-Google-Smtp-Source: ABdhPJzj+NuLSz9Bg0hONKimYPAD2PStxSb+qf4Bdn0pfCvEw28/rTFX9HIXaWA2c4Xzxf1YJosn9E179niQ4kkhXNqwAoHiskDt
MIME-Version: 1.0
X-Received: by 2002:a92:aa01:: with SMTP id j1mr15351168ili.30.1596431126218;
 Sun, 02 Aug 2020 22:05:26 -0700 (PDT)
Date:   Sun, 02 Aug 2020 22:05:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fcce805abf21687@google.com>
Subject: KASAN: use-after-free Write in sco_chan_del
From:   syzbot <syzbot+8f6017ee5c7fb9515782@syzkaller.appspotmail.com>
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

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11638a42900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=8f6017ee5c7fb9515782
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17fd776c900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ac7014900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f6017ee5c7fb9515782@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:748 [inline]
BUG: KASAN: use-after-free in hci_conn_drop include/net/bluetooth/hci_core.h:1049 [inline]
BUG: KASAN: use-after-free in sco_chan_del+0xe6/0x430 net/bluetooth/sco.c:148
Write of size 4 at addr ffff8880a03d8010 by task syz-executor104/6978

CPU: 1 PID: 6978 Comm: syz-executor104 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_dec_and_test include/asm-generic/atomic-instrumented.h:748 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1049 [inline]
 sco_chan_del+0xe6/0x430 net/bluetooth/sco.c:148
 __sco_sock_close+0x16e/0x5b0 net/bluetooth/sco.c:433
 sco_sock_close net/bluetooth/sco.c:447 [inline]
 sco_sock_release+0x69/0x290 net/bluetooth/sco.c:1021
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1278
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:805
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 do_signal+0x82/0x2520 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0x156/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446e69
Code: Bad RIP value.
RSP: 002b:00007fff15a45008 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000000000000000 RCX: 0000000000446e69
RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000002 R09: 00000003000100ff
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000407ac0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6978:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_conn_add+0x53/0x1340 net/bluetooth/hci_conn.c:525
 hci_connect_sco+0x350/0x860 net/bluetooth/hci_conn.c:1279
 sco_connect net/bluetooth/sco.c:240 [inline]
 sco_sock_connect+0x308/0x980 net/bluetooth/sco.c:576
 __sys_connect_file+0x155/0x1a0 net/socket.c:1854
 __sys_connect+0x160/0x190 net/socket.c:1871
 __do_sys_connect net/socket.c:1882 [inline]
 __se_sys_connect net/socket.c:1879 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1879
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6972:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 device_release+0x71/0x200 drivers/base/core.c:1579
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c0/0x270 lib/kobject.c:739
 put_device+0x1b/0x30 drivers/base/core.c:2799
 hci_conn_del+0x27e/0x6a0 net/bluetooth/hci_conn.c:645
 hci_phy_link_complete_evt.isra.0+0x508/0x790 net/bluetooth/hci_event.c:4921
 hci_event_packet+0x481a/0x86f5 net/bluetooth/hci_event.c:6180
 hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880a03d8000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 16 bytes inside of
 4096-byte region [ffff8880a03d8000, ffff8880a03d9000)
The buggy address belongs to the page:
page:ffffea000280f600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea000280f600 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002882888 ffffea00027ede08 ffff8880aa002000
raw: 0000000000000000 ffff8880a03d8000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a03d7f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
 ffff8880a03d7f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a03d8000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880a03d8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a03d8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
