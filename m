Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C6C235ADF
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgHBUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:45:36 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:49267 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgHBUpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:45:21 -0400
Received: by mail-il1-f198.google.com with SMTP id v12so15910133iln.16
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1xycOSK9097oITbtkPQ2Z+DRSqX1NFWh+pkPwjLV+LY=;
        b=MmOOORserg/qvTWtdTf6QhCYnbwY+HOoAJ+Gxw3j/NHhE8ni2HjDDNY6UdxcDNWRAg
         KaLrmhQyDL3VRNX0JcvCiNXh1lwgiBi8LLIwPeenaa9dH3USATN8xjCNFItHg48YVD6o
         Ane0DDGGr2esMyWjuq7iTQaw6hpYrxOmWzRXPU1QSOENgJCYqQclgMQawN2F5Ehs7JBY
         ArCO+wbTKrDxKWVAshf6CHiYiunmZsqqiF9YYBitDvQT4sJlMLVtqAOSyF+sBhlKzkNL
         p5EIJ/qoDmwQp7/oJbn4rSoTkeEVuOrO1HZahp/pLTBXvvntCKk1Ljn2Eru8ZionvCaP
         ZKMw==
X-Gm-Message-State: AOAM5300maLBtLVQemcmm218EPq+qEErJeHfhHMBpzbXHs46G1wRmSkU
        +DbD2vwh4xapjLTzPejLygHiROvqG+60bIZ38TU+r39pK2qQ
X-Google-Smtp-Source: ABdhPJwVUWGfBOw2qltlxlKtIO0DVihpZCkVO501w3BsGQbUNyEt3TmeTq4L2nxZ+whRI96eKPygp/iHbXShO3RmXqYwHRR2fGTk
MIME-Version: 1.0
X-Received: by 2002:a92:ba57:: with SMTP id o84mr13395563ili.215.1596401119857;
 Sun, 02 Aug 2020 13:45:19 -0700 (PDT)
Date:   Sun, 02 Aug 2020 13:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab11c505abeb19f5@google.com>
Subject: KASAN: use-after-free Write in __sco_sock_close
From:   syzbot <syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=17082904900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=077eca30d3cb7c02b273
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cf1904900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d52e14900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+077eca30d3cb7c02b273@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:748 [inline]
BUG: KASAN: use-after-free in hci_conn_drop include/net/bluetooth/hci_core.h:1049 [inline]
BUG: KASAN: use-after-free in sco_chan_del net/bluetooth/sco.c:148 [inline]
BUG: KASAN: use-after-free in __sco_sock_close+0x47c/0xed0 net/bluetooth/sco.c:433
Write of size 4 at addr ffff88809191e010 by task syz-executor393/6961

CPU: 0 PID: 6961 Comm: syz-executor393 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 check_memory_region+0x2b5/0x2f0 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_dec_and_test include/asm-generic/atomic-instrumented.h:748 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1049 [inline]
 sco_chan_del net/bluetooth/sco.c:148 [inline]
 __sco_sock_close+0x47c/0xed0 net/bluetooth/sco.c:433
 sco_sock_close net/bluetooth/sco.c:447 [inline]
 sco_sock_release+0x63/0x4f0 net/bluetooth/sco.c:1021
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1278
 __fput+0x2f0/0x750 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0x601/0x1f80 kernel/exit.c:805
 do_group_exit+0x161/0x2d0 kernel/exit.c:903
 get_signal+0x139b/0x1d30 kernel/signal.c:2743
 do_signal+0x33/0x610 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0xd7/0x1e0 arch/x86/entry/common.c:269
 do_syscall_64+0x7f/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446e69
Code: Bad RIP value.
RSP: 002b:00007ffde45fd7f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000000000000000 RCX: 0000000000446e69
RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000002 R09: 00000003000000ff
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000407ac0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6961:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_conn_add+0x5d/0x1040 net/bluetooth/hci_conn.c:525
 hci_connect_sco+0x29a/0xa10 net/bluetooth/hci_conn.c:1279
 sco_connect net/bluetooth/sco.c:240 [inline]
 sco_sock_connect+0x2de/0xaa0 net/bluetooth/sco.c:576
 __sys_connect_file net/socket.c:1854 [inline]
 __sys_connect+0x2da/0x360 net/socket.c:1871
 __do_sys_connect net/socket.c:1882 [inline]
 __se_sys_connect net/socket.c:1879 [inline]
 __x64_sys_connect+0x76/0x80 net/socket.c:1879
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6957:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 device_release+0x70/0x1a0 drivers/base/core.c:1575
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x15b/0x220 lib/kobject.c:739
 hci_conn_del+0x2c2/0x550 net/bluetooth/hci_conn.c:645
 hci_phy_link_complete_evt net/bluetooth/hci_event.c:4921 [inline]
 hci_event_packet+0x8335/0x18260 net/bluetooth/hci_event.c:6180
 hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88809191e000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 16 bytes inside of
 4096-byte region [ffff88809191e000, ffff88809191f000)
The buggy address belongs to the page:
page:ffffea0002464780 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002464780 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002489f88 ffffea000249dd08 ffff8880aa402000
raw: 0000000000000000 ffff88809191e000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809191df00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809191df80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809191e000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88809191e080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809191e100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
