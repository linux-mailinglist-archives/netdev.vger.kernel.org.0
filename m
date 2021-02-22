Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A96E3212AB
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBVJGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:06:23 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:45358 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhBVJGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:06:01 -0500
Received: by mail-il1-f197.google.com with SMTP id h17so7179930ila.12
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:05:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Gn1296qZG0YzHRO/kjdgq+1qhhHLjh3lQMKcYA49tHM=;
        b=XJQDDsLZxZC/Srcjl+IuTZ7+tsvn2egzPQTx/JMY2NImwhjWr6jx0LitcbeaIXA7e7
         gzwurk67gIXxtWDMSvoqlM2cmjtOa1MU1UExPfw+XfgYh9SDsaiecwR7JKD46Dy2v0iD
         GXw6k65HSFjdw7+NYCT7PdyxNKMRNRo1stYj04N8DRIwzNJDsalK9OggvAZ7hLy3xpKr
         3vTD8x5iwSRSN35sOFncgdX0N/6DeZq6bR3I8yc9xgRXQGJzfBxC7ejAl5Mo92sOI26V
         12hGUgf7Xwah57LqFInxoLxL5MEqGtOAldU8CKG8MZE6usAahDNqQLr926MaiIszPidg
         CVLQ==
X-Gm-Message-State: AOAM532Rc6guAv3cHxQD81lMUgKHrODEj58IR9I7nLGCkwxIqV47ZIHc
        70RPfl5FowlADraFFIJYPwou85z4193GiPWR54snOhN92/Nb
X-Google-Smtp-Source: ABdhPJyoaYdPhhSUvC1j/ioV5Yqv98Yj4Pns/xNN3PldtfOD8BcweecYWwrC2ikJALNVV2kMkAJxteqsUfyMLU8uSsG+01qmLPx1
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2a:: with SMTP id m10mr13988675ilh.17.1613984720116;
 Mon, 22 Feb 2021 01:05:20 -0800 (PST)
Date:   Mon, 22 Feb 2021 01:05:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea61fa05bbe91914@google.com>
Subject: KASAN: use-after-free Read in nbd_release
From:   syzbot <syzbot+74f888d2e102b3930324@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, josef@toxicpanda.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3af409ca net: enetc: fix destroyed phylink dereference dur..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=144bf26cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=74f888d2e102b3930324
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12917e5ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1131fb04d00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1252220cd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1152220cd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1652220cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+74f888d2e102b3930324@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_dec_not_one+0x71/0x1e0 lib/refcount.c:76
Read of size 4 at addr ffff888143bf71a0 by task systemd-udevd/8451

CPU: 0 PID: 8451 Comm: systemd-udevd Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 refcount_dec_not_one+0x71/0x1e0 lib/refcount.c:76
 refcount_dec_and_mutex_lock+0x19/0x140 lib/refcount.c:115
 nbd_put drivers/block/nbd.c:248 [inline]
 nbd_release+0x116/0x190 drivers/block/nbd.c:1508
 __blkdev_put+0x548/0x800 fs/block_dev.c:1579
 blkdev_put+0x92/0x570 fs/block_dev.c:1632
 blkdev_close+0x8c/0xb0 fs/block_dev.c:1640
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc1e92b5270
Code: 73 01 c3 48 8b 0d 38 7d 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 59 c1 20 00 00 75 10 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24
RSP: 002b:00007ffe8beb2d18 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000007 RCX: 00007fc1e92b5270
RDX: 000000000aba9500 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00007fc1ea16f710 R08: 000000000000004a R09: 0000000000000008
R10: 0000562f8cb0b2a8 R11: 0000000000000246 R12: 0000000000000000
R13: 0000562f8cb0afd0 R14: 0000000000000003 R15: 000000000000000e

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 nbd_dev_add+0x44/0x8e0 drivers/block/nbd.c:1673
 nbd_init+0x250/0x271 drivers/block/nbd.c:2394
 do_one_initcall+0x103/0x650 init/main.c:1223
 do_initcall_level init/main.c:1296 [inline]
 do_initcalls init/main.c:1312 [inline]
 do_basic_setup init/main.c:1332 [inline]
 kernel_init_freeable+0x605/0x689 init/main.c:1533
 kernel_init+0xd/0x1b8 init/main.c:1421
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Freed by task 8451:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3143 [inline]
 kfree+0xdb/0x3b0 mm/slub.c:4139
 nbd_dev_remove drivers/block/nbd.c:243 [inline]
 nbd_put.part.0+0x180/0x1d0 drivers/block/nbd.c:251
 nbd_put drivers/block/nbd.c:295 [inline]
 nbd_config_put+0x6dd/0x8c0 drivers/block/nbd.c:1242
 nbd_release+0x103/0x190 drivers/block/nbd.c:1507
 __blkdev_put+0x548/0x800 fs/block_dev.c:1579
 blkdev_put+0x92/0x570 fs/block_dev.c:1632
 blkdev_close+0x8c/0xb0 fs/block_dev.c:1640
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888143bf7000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 416 bytes inside of
 1024-byte region [ffff888143bf7000, ffff888143bf7400)
The buggy address belongs to the page:
page:000000005238f4ce refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x143bf0
head:000000005238f4ce order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 ffffea00004b1400 0000000300000003 ffff888010c41140
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888143bf7080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888143bf7100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888143bf7180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff888143bf7200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888143bf7280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
