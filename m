Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F67222A0DA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGVUm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:42:27 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53667 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgGVUm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:42:27 -0400
Received: by mail-io1-f70.google.com with SMTP id g11so2591377ioc.20
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XD+SXlq3/2gU9EkMcZLGPTp8jmHGm8EtipgOib0Vg24=;
        b=AKN/HVrpiSQ5Wig+urgTxQa02OPO4gvhLJPSwl7x4UMDr9mQUeDN9Z+2BkGP5E7d/G
         Vm6k+yMM2fQxmq6hej1tSgso8fdE00Vz0JxKsZMuBBNryHogHlDhMt/zIQrQ+vVvLNP7
         UENKAyLNNQQLvA8pXBAn61dqcSyjTHRm8asqCzJ78WxivNY/b/o7UV4IoFtucQ3jVa5U
         N4QJ4myahC0MuCPrRnGY5NeJTiVtMEPR5Wn8ZDKn+Y/Fe0HF8ItwyHlaQGhYREKrtVup
         ZU8duNKEQDv7BU1rFH36jqXiDeCjAnHXfFDM+29gD/63oAtGwhfRB/tZO5zN/TQZr4AZ
         qQ9A==
X-Gm-Message-State: AOAM533JQ1U9+z1SKX0bdNEli039W0a+Wnx0lSiXSRHPrXQEL6PQJT4c
        icBhGQGUFafD+1s8i9i7EKdh7toJ828UjD78addlLzEqyLQu
X-Google-Smtp-Source: ABdhPJyIVUe7TBkJ7v52/44AYMjF3LCCv5SR/P+tek0q5wlkLyDtLnVA2NDEqhHFTroTNwGVWSsmkU3mgJUXaYcveNhBWM5NExnA
MIME-Version: 1.0
X-Received: by 2002:a02:5b83:: with SMTP id g125mr1081660jab.91.1595450546168;
 Wed, 22 Jul 2020 13:42:26 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:42:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000fa7b205ab0dc778@google.com>
Subject: KASAN: use-after-free Write in __linkwatch_run_queue
From:   syzbot <syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com>
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

HEAD commit:    544f287b bonding: check error value of register_netdevice(..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14385887100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddbcb5a9f4192db
dashboard link: https://syzkaller.appspot.com/bug?extid=bbc3a11c4da63c1b74d6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b11780900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1080f887100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_splice include/linux/list.h:422 [inline]
BUG: KASAN: use-after-free in list_splice_init include/linux/list.h:464 [inline]
BUG: KASAN: use-after-free in __linkwatch_run_queue+0x58a/0x630 net/core/link_watch.c:200
Write of size 8 at addr ffff888094ccc578 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events linkwatch_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __list_splice include/linux/list.h:422 [inline]
 list_splice_init include/linux/list.h:464 [inline]
 __linkwatch_run_queue+0x58a/0x630 net/core/link_watch.c:200
 linkwatch_event+0x4a/0x60 net/core/link_watch.c:251
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6822:
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

Freed by task 6822:
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

The buggy address belongs to the object at ffff888094ccc000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1400 bytes inside of
 8192-byte region [ffff888094ccc000, ffff888094cce000)
The buggy address belongs to the page:
page:ffffea0002533300 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002533300 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002519408 ffffea0002623008 ffff8880aa0021c0
raw: 0000000000000000 ffff888094ccc000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094ccc400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094ccc480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888094ccc500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff888094ccc580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094ccc600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
