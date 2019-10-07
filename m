Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4E3CE502
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfJGOTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:19:13 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55503 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGOTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:19:13 -0400
Received: by mail-io1-f69.google.com with SMTP id r13so26849905ioj.22
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 07:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=plYEj++ipHdBTXQ1PUYl3/fHMsbt8QG4MrJRzJt4AcU=;
        b=Vm6dTBaTLD82KfONQr7mOwhmALWqfbatjgdj2hSRCIIl1jErHRrBfrzvCNglROwY4j
         uqZRWmhctI9txrZ6lfn54BZnCnGH9FFU3SBrpdPkHHN16jSEvIfn1Xfmvs2bcWo4c45W
         74e0FiP4wJNhRxKcr9wtJFAO0PMT6lUcccMquZXUKzIMy43cl16f7dxJeC61PoWj6kgx
         UG+Iipi/kv7MZjj3yV8dcjzgiCjUubkBzN9LLawPriytKty66tFHagAtP9dCDIs/4/Ps
         rBOBriz21MEJdU56j38ulD95YJDFHm7dt6NVSRb2Cs/G7tgywoeOS3jimo8OdW3/en0A
         Vc6Q==
X-Gm-Message-State: APjAAAWdLkN6IK0kk0hEVac/S7Zjzf3QTN+RaFMDf7m78DUTc0SEw7uy
        WPylmqCrjc5jQ3+5XsQSbkWe+2gduHImVEEWDTxH0Ti7bq9x
X-Google-Smtp-Source: APXvYqzxBnC5RCPnSQ5/pF44nS7nXBPwsSmkX2qzK2kUoW4qYR4mFul4YWwIiZUKU1Z4bmIZ5BYNdwf712u1iLyBvOfZ8T5PB4oD
MIME-Version: 1.0
X-Received: by 2002:a92:844f:: with SMTP id l76mr28163018ild.218.1570457949409;
 Mon, 07 Oct 2019 07:19:09 -0700 (PDT)
Date:   Mon, 07 Oct 2019 07:19:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035a04b059452bc21@google.com>
Subject: KASAN: use-after-free Read in __cfg8NUM_wpan_dev_from_attrs
From:   syzbot <syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    056ddc38 Merge branch 'stmmac-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=125aaafd600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=9cb7edb2906ea1e83006
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1232bb3f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162d0d0b600000

The bug was bisected to:

commit 75cdbdd089003cd53560ff87b690ae911fa7df8e
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Sat Oct 5 18:04:37 2019 +0000

     net: ieee802154: have genetlink code to parse the attrs during dumpit

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11be5d0b600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13be5d0b600000
console output: https://syzkaller.appspot.com/x/log.txt?x=15be5d0b600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com
Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the  
attrs during dumpit")

netlink: 'syz-executor134': attribute type 6 has an invalid length.
==================================================================
BUG: KASAN: use-after-free in nla_memcpy+0xa2/0xb0 lib/nlattr.c:572
Read of size 2 at addr ffff8880a74fba94 by task syz-executor134/8714

CPU: 1 PID: 8714 Comm: syz-executor134 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
  nla_memcpy+0xa2/0xb0 lib/nlattr.c:572
  nla_get_u64 include/net/netlink.h:1539 [inline]
  __cfg802154_wpan_dev_from_attrs+0x41b/0x550 net/ieee802154/nl802154.c:55
  nl802154_prepare_wpan_dev_dump.isra.0.constprop.0+0xf7/0x4b0  
net/ieee802154/nl802154.c:245
  nl802154_dump_llsec_seclevel+0xb9/0xae0 net/ieee802154/nl802154.c:1985
  genl_lock_dumpit+0x86/0xc0 net/netlink/genetlink.c:529
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
  genl_family_rcv_msg_dumpit net/netlink/genetlink.c:614 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:710 [inline]
  genl_rcv_msg+0xc9b/0x1000 net/netlink/genetlink.c:730
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:741
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441399
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe350885d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441399
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000402110
R13: 00000000004021a0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8716:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc_node mm/slab.c:3615 [inline]
  __kmalloc_node_track_caller+0x4e/0x70 mm/slab.c:3629
  __kmalloc_reserve.isra.0+0x40/0xf0 net/core/skbuff.c:141
  __alloc_skb+0x10b/0x5e0 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
  netlink_sendmsg+0x972/0xd60 net/netlink/af_netlink.c:1892
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8716:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  skb_free_head+0x93/0xb0 net/core/skbuff.c:591
  skb_release_data+0x42d/0x7c0 net/core/skbuff.c:611
  skb_release_all+0x4d/0x60 net/core/skbuff.c:665
  __kfree_skb net/core/skbuff.c:679 [inline]
  consume_skb net/core/skbuff.c:838 [inline]
  consume_skb+0xfb/0x3b0 net/core/skbuff.c:832
  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
  netlink_unicast+0x539/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a74fba80
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
  512-byte region [ffff8880a74fba80, ffff8880a74fbc80)
The buggy address belongs to the page:
page:ffffea00029d3ec0 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea000232e1c8 ffffea00028722c8 ffff8880aa400a80
raw: 0000000000000000 ffff8880a74fb080 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a74fb980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a74fba00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a74fba80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff8880a74fbb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a74fbb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
