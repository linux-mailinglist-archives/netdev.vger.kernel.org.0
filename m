Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2543B767
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhJZQls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:41:48 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:44808 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhJZQlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 12:41:46 -0400
Received: by mail-io1-f69.google.com with SMTP id a1-20020a5d9801000000b005de11aa60b8so13620iol.11
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 09:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oVJE5hk1OPDGeJSK/rmTl39oO1i2rkzJcDSMlqr3TME=;
        b=fIMm4hPAKl2DUMPIcSviS5THGIgERIB3rDodjCYa1r/nnMRmVKqKg6x557pb6hX7l6
         Z6xkgeQ34vTk+4njW6AILh84vB8JYPyJMldlezwTPVuByahcqPQ0P/W9PyOzLUg4UsYU
         gbSo0KkHO5xNv7D/0YzYFwIE/Tii0BbSThsZVK5mKMnb7PH0po+FtNqnNDVAwG7rhWJd
         TZMtnRoJ4Jq8UH8NFLkcA9waLPcJHF5JZl6ztS4Lur9YUCx0XEXdog4MCJoNLiAsaTSW
         JA3f+Grwgcze6EtZw+cAFwfCLcQUSt4qHGrLflTWtMwEL79ZaSQwtw7Xc6eFUmgtFIYJ
         TTGQ==
X-Gm-Message-State: AOAM532aN94ZG7/EbNi4mhLpl2wFOv8hfnyK2suj+tbWtQ1fc9Bq2nlE
        VQXrpO67dDK9xvlWs9KLeHi39X9e93Tc+CEDmWR3A/c/vwMA
X-Google-Smtp-Source: ABdhPJzdPGTlWq9QGBp7b2eZMVolNg+mSvp8cCVjo9RkRuGD044cA7NydAFPGED7Z8R8RRF+cHun5M+6Xlt8f/9b6U3mVIAP1oBe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2162:: with SMTP id s2mr12669593ilv.170.1635266362394;
 Tue, 26 Oct 2021 09:39:22 -0700 (PDT)
Date:   Tue, 26 Oct 2021 09:39:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4cd2105cf441e76@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
From:   syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvivier@redhat.com, mpm@selenic.com,
        mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000

The issue was bisected to:

commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
Author: Leon Romanovsky <leonro@nvidia.com>
Date:   Thu Oct 21 14:16:14 2021 +0000

    devlink: Remove not-executed trap policer notifications

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")

==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542

CPU: 1 PID: 6542 Comm: syz-executor989 Not tainted 5.15.0-rc6-next-20211025-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 memcpy+0x20/0x60 mm/kasan/shadow.c:65
 memcpy include/linux/fortify-string.h:225 [inline]
 copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
 virtio_read+0x1e0/0x230 drivers/char/hw_random/virtio-rng.c:90
 rng_get_data drivers/char/hw_random/core.c:192 [inline]
 rng_dev_read+0x400/0x660 drivers/char/hw_random/core.c:229
 vfs_read+0x1b5/0x600 fs/read_write.c:483
 ksys_read+0x12d/0x250 fs/read_write.c:623
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f05696617e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd06461948 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 000000000001294d RCX: 00007f05696617e9
RDX: 00000000fffffff1 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd064619b0 R09: 00007ffd064619b0
R10: 00007ffd064613d0 R11: 0000000000000246 R12: 00007ffd0646197c
R13: 00007ffd064619b0 R14: 00007ffd06461990 R15: 0000000000000002
 </TASK>

Allocated by task 1:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 probe_common+0xaa/0x5b0 drivers/char/hw_random/virtio-rng.c:132
 virtio_dev_probe+0x44e/0x760 drivers/virtio/virtio.c:273
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __driver_attach+0x22d/0x4e0 drivers/base/dd.c:1140
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
 bus_add_driver+0x41d/0x630 drivers/base/bus.c:618
 driver_register+0x220/0x3a0 drivers/base/driver.c:171
 do_one_initcall+0x103/0x650 init/main.c:1303
 do_initcall_level init/main.c:1378 [inline]
 do_initcalls init/main.c:1394 [inline]
 do_basic_setup init/main.c:1413 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1618
 kernel_init+0x1a/0x1d0 init/main.c:1507
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88801a7a1400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 384 bytes inside of
 512-byte region [ffff88801a7a1400, ffff88801a7a1600)
The buggy address belongs to the page:
page:ffffea000069e800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a7a0
head:ffffea000069e800 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, ts 7709676886, free_ts 0
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2036
 alloc_pages+0x29f/0x300 mm/mempolicy.c:2186
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3259
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 device_private_init drivers/base/core.c:3238 [inline]
 device_add+0x11a7/0x1ee0 drivers/base/core.c:3288
 device_create_groups_vargs+0x203/0x280 drivers/base/core.c:4052
 device_create_with_groups+0xe3/0x120 drivers/base/core.c:4138
 misc_register+0x20a/0x690 drivers/char/misc.c:206
 register_miscdev drivers/char/hw_random/core.c:422 [inline]
 hwrng_modinit+0xd0/0x109 drivers/char/hw_random/core.c:621
 do_one_initcall+0x103/0x650 init/main.c:1303
 do_initcall_level init/main.c:1378 [inline]
 do_initcalls init/main.c:1394 [inline]
 do_basic_setup init/main.c:1413 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1618
 kernel_init+0x1a/0x1d0 init/main.c:1507
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801a7a1480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801a7a1500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801a7a1580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88801a7a1600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801a7a1680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
