Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928971DBCBB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgETSXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:23:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37329 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgETSXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:23:20 -0400
Received: by mail-il1-f199.google.com with SMTP id k18so3458269ilq.4
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eNV/gcvohQYiWw7CuSofKZfplESLdrwFUzrwQcxhix4=;
        b=ozSe+rDu/3T+PkSmFPAOdGZNbIFc8QxKv1h73XsjGhpaSsB42CEKmoeIEGwzCYV3bG
         yqRJnap+Dp2hmj2D1KyH+uUhXFzgQmovD4TtpHg3HJxEUCB5Wn479WQ3Dqs8sMR2ztPc
         TvRXBl8ZT6yyUuU8mlcu0+M/JiaF9P2gEzaV22tz13+SbWHMkNGPySPq4BLjh6fu5hAY
         s/gMoqxZY5k4X9E+jySOEYfESZFdMHdMIlEh/8rdUpObFYokBFapnxbQLvh12jPXJFmx
         3IrJtvJGAEjVnisuRUQzhtApNofPCXOT6PWqzXz2RlMQC437vOn+2ku+ZQbjepYrLD8L
         qHSg==
X-Gm-Message-State: AOAM530rPCc2NTFXDPK2Sj2YBqIL+twD14zv6pp0b+ZVriuiLse+bQ78
        yuQvhIlNHZ92SsrVXTp5GrrLS8CXqZb8FKDzt/mZg8SgDeAZ
X-Google-Smtp-Source: ABdhPJy0f1uR3u/nCL98sxbemLWlycv9b/Flaa1EtG80uoOcStu5iWGKPnWugtydu1PTLBdOusCylbMfsn1TzCYptBX+MFjNQbDE
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c88:: with SMTP id i8mr2439676iow.74.1589998998198;
 Wed, 20 May 2020 11:23:18 -0700 (PDT)
Date:   Wed, 20 May 2020 11:23:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b211005a6187dc9@google.com>
Subject: KASAN: slab-out-of-bounds Read in br_mrp_parse
From:   syzbot <syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    dda18a5c selftests/bpf: Convert bpf_iter_test_kern{3, 4}.c..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c4e63c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=668983fd3dd1087e
dashboard link: https://syzkaller.appspot.com/bug?extid=9c6f0f1f8e32223df9a4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eaba3c100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128598f6100000

The bug was bisected to:

commit 6536993371fab3de4e8379649b60e94d03e6ff37
Author: Horatiu Vultur <horatiu.vultur@microchip.com>
Date:   Sun Apr 26 13:22:07 2020 +0000

    bridge: mrp: Integrate MRP into the bridge

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1187c352100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1387c352100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1587c352100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com
Fixes: 6536993371fa ("bridge: mrp: Integrate MRP into the bridge")

batman_adv: batadv0: Interface activated: batadv_slave_1
==================================================================
BUG: KASAN: slab-out-of-bounds in br_mrp_parse+0x362/0x450 net/bridge/br_mrp_netlink.c:30
Read of size 4 at addr ffff888094d96f24 by task syz-executor481/7028

CPU: 0 PID: 7028 Comm: syz-executor481 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:382
 __kasan_report.cold+0x20/0x38 mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 br_mrp_parse+0x362/0x450 net/bridge/br_mrp_netlink.c:30
 br_afspec+0x328/0x490 net/bridge/br_netlink.c:677
 br_setlink+0x363/0x610 net/bridge/br_netlink.c:934
 rtnl_bridge_setlink+0x279/0x6d0 net/core/rtnetlink.c:4803
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4438f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 6b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc8cfd2528 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004438f9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00007ffc8cfd2540 R08: 00000000bb1414ac R09: 00000000bb1414ac
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc8cfd2570
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7028:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:757 [inline]
 kvzalloc include/linux/mm.h:765 [inline]
 alloc_netdev_mqs+0x97/0xdc0 net/core/dev.c:9899
 rtnl_create_link+0x219/0xac0 net/core/rtnetlink.c:3068
 __rtnl_newlink+0xe2e/0x1590 net/core/rtnetlink.c:3330
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 __sys_sendto+0x219/0x330 net/socket.c:1995
 __do_sys_sendto net/socket.c:2007 [inline]
 __se_sys_sendto net/socket.c:2003 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2003
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff888094d96000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3876 bytes inside of
 4096-byte region [ffff888094d96000, ffff888094d97000)
The buggy address belongs to the page:
page:ffffea0002536580 refcount:1 mapcount:0 mapping:00000000c278d3e1 index:0x0 head:ffffea0002536580 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00024d5088 ffffea0002a47788 ffff8880aa002000
raw: 0000000000000000 ffff888094d96000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094d96e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888094d96e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888094d96f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                               ^
 ffff888094d96f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888094d97000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
