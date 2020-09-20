Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95A5271542
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgITPMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:12:20 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:52898 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgITPMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:12:19 -0400
Received: by mail-io1-f80.google.com with SMTP id m4so8222789iov.19
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 08:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4h1WgrZ3msxiVY5gN6krMYZA5aFi9a0Lv0AJNKzWo6E=;
        b=dowwsZCz845nBYPlN3JZcJDT+zEyHf2Y+yFxGdhcg/HdR5gN+bleAaMevKo9Ka4vHR
         t/SCH8PI4RnH8LmDRcmeb5BSH2mYfnQQbcqSiOklhT6fRBKkM2i5TIIq4xPAfUKzpAUm
         oVIsuFtBgJrF7SlTWznC8wTmYrENHeUBlA+6acT5L1JPy2OUpkRFP374rhR54dRvVZBV
         1RDOCYVlI+aKFLV+YaGL7n703zdOxH/yjitZkPRaHEVGczCXJP8RLSY+Lr6Rdu0OZuNK
         o/EjzWit2/EkHLHwLoBZVG+JeMcuDDS9UMC+0SPfflpobCi3SM+FRwzVzxsApalbWZSu
         AfIA==
X-Gm-Message-State: AOAM532eL1lwoJM8mSVLScUBYxpiPV4KInkmngg8K+11HcA1Wxg9LOlV
        3nK1IMGVrmI7K4yY0V2jJcpYvCEdHagMUCwR2vF7B4nxGc8l
X-Google-Smtp-Source: ABdhPJyy2Jt9GUpIdVkeXdvmU+hIPyf9a29IbuE2yhRWMBqVbE5TjyHhnWcQZvkxA+uf7xRXDVrHx1UgpsgY6ypjXsNqWYErvU9q
MIME-Version: 1.0
X-Received: by 2002:a02:8802:: with SMTP id r2mr37653894jai.75.1600614738355;
 Sun, 20 Sep 2020 08:12:18 -0700 (PDT)
Date:   Sun, 20 Sep 2020 08:12:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6ed0205afc0287c@google.com>
Subject: KASAN: use-after-free Read in tcf_action_destroy
From:   syzbot <syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@mellanox.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vladbu@mellanox.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0f9ad4e7 Merge branch 's390-qeth-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15fc6755900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d29a102d22f784ea
dashboard link: https://syzkaller.appspot.com/bug?extid=2287853d392e4b42374a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133e6cc5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c4158b900000

The issue was bisected to:

commit 4e8ddd7f1758ca4ddd0c1f7cf3e66fce736241d2
Author: Vlad Buslov <vladbu@mellanox.com>
Date:   Thu Jul 5 14:24:30 2018 +0000

    net: sched: don't release reference on action overwrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13a50d01900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10650d01900000
console output: https://syzkaller.appspot.com/x/log.txt?x=17a50d01900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
Fixes: 4e8ddd7f1758 ("net: sched: don't release reference on action overwrite")

netlink: 32 bytes leftover after parsing attributes in process `syz-executor259'.
==================================================================
BUG: KASAN: use-after-free in tcf_action_destroy+0x188/0x1b0 net/sched/act_api.c:724
Read of size 8 at addr ffff8880a6998c00 by task syz-executor259/6880

CPU: 0 PID: 6880 Comm: syz-executor259 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 tcf_action_destroy+0x188/0x1b0 net/sched/act_api.c:724
 tcf_action_init+0x285/0x380 net/sched/act_api.c:1059
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1452
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1505
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446c69
Code: e8 5c b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f16641f8d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c69
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000000000 R15: 053b003000000098

Allocated by task 6880:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3655 [inline]
 __kmalloc+0x1b0/0x310 mm/slab.c:3664
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 tcf_idr_create+0x5b/0x7b0 net/sched/act_api.c:408
 tcf_connmark_init+0x535/0x960 net/sched/act_connmark.c:126
 tcf_action_init_1+0x6a5/0xac0 net/sched/act_api.c:984
 tcf_action_init+0x249/0x380 net/sched/act_api.c:1044
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1452
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1505
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6882:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3756
 tcf_idr_release_unsafe net/sched/act_api.c:284 [inline]
 tcf_del_walker net/sched/act_api.c:310 [inline]
 tcf_generic_walker+0x959/0xb60 net/sched/act_api.c:339
 tca_action_flush+0x42b/0x920 net/sched/act_api.c:1279
 tca_action_gd+0x8ac/0xda0 net/sched/act_api.c:1386
 tc_ctl_action+0x280/0x439 net/sched/act_api.c:1513
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a6998c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff8880a6998c00, ffff8880a6998e00)
The buggy address belongs to the page:
page:00000000db318149 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a6998400 pfn:0xa6998
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00029e0748 ffffea00029b4808 ffff8880aa040600
raw: ffff8880a6998400 ffff8880a6998000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a6998b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a6998b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a6998c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880a6998c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a6998d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
