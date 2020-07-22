Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BD82297F9
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732212AbgGVMNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:13:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52698 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbgGVMNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:13:19 -0400
Received: by mail-io1-f72.google.com with SMTP id k12so1664797iom.19
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xhTbP+Z7qMRdHUaauewq7xGNB+cI8pI7ea/D+jH87Z8=;
        b=Vj5tt/TlwwzC45N4Z+pdIqNQzfgy3LVL2OBVK/sgytcly+EFISUw5CDlR4TIJnaMq7
         UU5HHPrr/GezsRht9H+YlMGhRGUIRwYP9PfN0r4yw5wEh0oA9NHJbU8/tjJcF2oYRLDl
         R4KyiB4hVckOoY2A5xF373OuVvTw6pIPGNqLKXpGC8GerpwGvINK3e0r4qo0eL9tLtrS
         i+cEGALPlujzTlxlk6NTOCWFv+UjzccxFu95rxvOReucCAOpz+r+j9xU5Gy6bdkd8u+y
         rMKUGpmcjOzgdmUNLNzNwi6Lt+FunHYCaDVMI9X1ZEZO/CnciS7kbER8iYPKbxV0BB/Y
         beOQ==
X-Gm-Message-State: AOAM530kZavGMx2WGhRF423vQQiWJ2tgmPEg5L6fJ6LslZfErBtioLpG
        ZnWn+qCbACEFOV8Fazk+ySMSLe835PheY1sDRYIyM6gH7ybV
X-Google-Smtp-Source: ABdhPJwKLQ696U5+LMoeaGOGpjvaWqBBgd7fFP2d2oJOVQoWujhVhdB3Ptormw4XIDCWWnihhRwH7jbcYeD9yC+pVOMVvJGyDSK4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:140d:: with SMTP id k13mr3740289jad.37.1595419997893;
 Wed, 22 Jul 2020 05:13:17 -0700 (PDT)
Date:   Wed, 22 Jul 2020 05:13:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003df98d05ab06aac6@google.com>
Subject: KASAN: use-after-free Read in linkwatch_fire_event
From:   syzbot <syzbot+987da0fff3a594532ce1@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2c4dc314 net: ethernet: ti: add NETIF_F_HW_TC hw feature f..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16a6aa44900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddbcb5a9f4192db
dashboard link: https://syzkaller.appspot.com/bug?extid=987da0fff3a594532ce1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+987da0fff3a594532ce1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
Read of size 8 at addr ffff88806fcd0570 by task syz-executor.4/28919

CPU: 0 PID: 28919 Comm: syz-executor.4 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __list_add_valid+0x93/0xa0 lib/list_debug.c:26
 __list_add include/linux/list.h:67 [inline]
 list_add_tail include/linux/list.h:100 [inline]
 linkwatch_add_event net/core/link_watch.c:111 [inline]
 linkwatch_fire_event+0xea/0x1d0 net/core/link_watch.c:261
 netif_carrier_off net/sched/sch_generic.c:513 [inline]
 netif_carrier_off+0x96/0xb0 net/sched/sch_generic.c:507
 __tun_detach+0xf2b/0x1310 drivers/net/tun.c:687
 tun_detach drivers/net/tun.c:708 [inline]
 tun_chr_close+0xd9/0x180 drivers/net/tun.c:3423
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:239 [inline]
 __prepare_exit_to_usermode+0x1e9/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x415d71
Code: Bad RIP value.
RSP: 002b:00007ffcc5547550 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000415d71
RDX: 0000000000000000 RSI: 0000000000001ba5 RDI: 0000000000000003
RBP: 0000000000000001 R08: 000000009f2ebba5 R09: 000000009f2ebba9
R10: 00007ffcc5547640 R11: 0000000000000293 R12: 000000000078c900
R13: 000000000078c900 R14: ffffffffffffffff R15: 000000000078bfac

Allocated by task 28915:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0xb4/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:753 [inline]
 kvzalloc include/linux/mm.h:761 [inline]
 alloc_netdev_mqs+0x97/0xdc0 net/core/dev.c:9938
 rtnl_create_link+0x219/0xad0 net/core/rtnetlink.c:3067
 __rtnl_newlink+0xfa0/0x1750 net/core/rtnetlink.c:3329
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 28915:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 device_release+0x71/0x200 drivers/base/core.c:1559
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c0/0x270 lib/kobject.c:739
 put_device+0x1b/0x30 drivers/base/core.c:2779
 free_netdev+0x35d/0x480 net/core/dev.c:10054
 __rtnl_newlink+0x14d8/0x1750 net/core/rtnetlink.c:3354
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88806fcd0000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1392 bytes inside of
 8192-byte region [ffff88806fcd0000, ffff88806fcd2000)
The buggy address belongs to the page:
page:ffffea0001bf3400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0001bf3400 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00018dfd08 ffffea0001a00808 ffff8880aa0021c0
raw: 0000000000000000 ffff88806fcd0000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88806fcd0400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806fcd0480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88806fcd0500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88806fcd0580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806fcd0600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
