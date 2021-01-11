Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFAE2F1007
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbhAKKY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:24:57 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:33057 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbhAKKY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:24:57 -0500
Received: by mail-io1-f72.google.com with SMTP id t23so12174219ioh.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:24:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UEm4iYaUHKutrveM2lkyBJqkbr/xk2Rk6V2j+DK2EEg=;
        b=XMabKhHMw1h+KeaNl2PIfeyNUgg8eM/+aeLiYxS/0o9YQCAgsAX2/k9/gpZg1gKccV
         4X5b/3jehPtcXjlAPV5T0d+STIn9QzvVHIKdULW9dRgMgdid+XVfRduDf2+SNy1RrRFS
         hsV+KjnGFHY5GCtee2+qBJrOsFhJ9oDDvRX5wNNNzbH+sk4L+6XrGsN2StHXGhujViGh
         tmpjgYExCUarGfNQH68XXeGT9qU5+Afs9DOIOkw3XsqSRAa4zI7NPmVNoRWyEBx4k2FJ
         3ZjTdVAvIUu/mS2vzqsDMKZn6huNnx65EraHPeVaWmFS209uS/BxzkUbXBtCCXTHuMsw
         xuVw==
X-Gm-Message-State: AOAM531pbqDPBDCTyI1/grx4sgGYZedAzKuxaMV9QsjQdncgM9DNZDBB
        5ht0bgCCaAh8dAyme9Elc/Twy5JYkkeTFX8nCaaEiw9Rm7nu
X-Google-Smtp-Source: ABdhPJw0uBHY1ferNPHbLFK91HAI3ve9fd/g8jcrcV0UCZe48GFwbyhUSSY3YOQlhaDkuIRXsB3FJ/8yRFMaq7woDbUCixAvHKTl
MIME-Version: 1.0
X-Received: by 2002:a5d:9252:: with SMTP id e18mr14273514iol.146.1610360655560;
 Mon, 11 Jan 2021 02:24:15 -0800 (PST)
Date:   Mon, 11 Jan 2021 02:24:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5ca2305b89d4efe@google.com>
Subject: KASAN: use-after-free Read in hci_dev_do_open
From:   syzbot <syzbot+8bf62d95824d213104fa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    71c061d2 Merge tag 'for-5.11-rc2-tag' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1612b248d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=8bf62d95824d213104fa
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bf62d95824d213104fa@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1051 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x2e/0x3f0 net/core/skbuff.c:697
Read of size 4 at addr ffff888022dacc1c by task syz-executor.2/13757

CPU: 0 PID: 13757 Comm: syz-executor.2 Not tainted 5.11.0-rc2-syzkaller #0
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
 refcount_read include/linux/refcount.h:147 [inline]
 skb_unref include/linux/skbuff.h:1051 [inline]
 kfree_skb+0x2e/0x3f0 net/core/skbuff.c:697
 hci_dev_do_open+0xa4a/0x1a00 net/bluetooth/hci_core.c:1619
 hci_dev_open+0x132/0x300 net/bluetooth/hci_core.c:1685
 hci_sock_ioctl+0x5b6/0x840 net/bluetooth/hci_sock.c:1025
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1037
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e087
Code: 48 83 c4 08 48 89 d8 5b 5d c3 66 0f 1f 84 00 00 00 00 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 92 66 90 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 6d b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffdcd39c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e087
RDX: 0000000000000002 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 00007fffdcd39ca0 R08: 0000000000000000 R09: 00007f60a0a24700
R10: 00007f60a0a249d0 R11: 0000000000000246 R12: 000000000310e914
R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8498:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:205 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 kmem_cache_alloc+0x1c6/0x440 mm/slub.c:2904
 skb_clone+0x14f/0x3c0 net/core/skbuff.c:1449
 hci_cmd_work+0x18f/0x390 net/bluetooth/hci_core.c:5007
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Freed by task 2042:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:188 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:627
 __kfree_skb net/core/skbuff.c:684 [inline]
 kfree_skb net/core/skbuff.c:701 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:695
 hci_cmd_work+0x182/0x390 net/bluetooth/hci_core.c:5005
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888022dacb40
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 220 bytes inside of
 232-byte region [ffff888022dacb40, ffff888022dacc28)
The buggy address belongs to the page:
page:00000000530f5d7f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22dac
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010cb4c80
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888022dacb00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
 ffff888022dacb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888022dacc00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
                            ^
 ffff888022dacc80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888022dacd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
