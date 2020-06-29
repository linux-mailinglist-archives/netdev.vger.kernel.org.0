Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6253A20E32A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390342AbgF2VMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730165AbgF2S5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:57:45 -0400
Received: from mail-il1-x145.google.com (mail-il1-x145.google.com [IPv6:2607:f8b0:4864:20::145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E76C030F1D
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:31:16 -0700 (PDT)
Received: by mail-il1-x145.google.com with SMTP id d8so9465985ilc.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e2jyBs9m7j26V7FyK6gc1HYxfIhhiqM9f7Qz6OnD4vY=;
        b=EKJ7StGzjTLBXIdLmU4bmH9yAxcqBllLIuHdbM+wl3+RK82+2ciq2oobomJOJ3n3GP
         fOz0ZsrViSZODYuZ35Apbxe0ZDl8x6Nj9HqXL1rqpm1qjQ9tdfaiqP6GA5+J0BvFWnuQ
         uCztOSQBMcBk+2CRosvP+01n/gWpw8BimNqej+gKImFViLjKsB/51xU1W6L68Ao3OX33
         EXJMVssMDqw95SaHztHS/NldJ6dMrhInt0lT1fRGFV6c5QkRY/RaeIDPYj8/vXd18wbp
         OIYY7lOv5vfPBenPAGwuVsX6biT+6qtkCC80thV4Qn9a7xTV2mYK75zuG5nbipEkD17V
         jnRg==
X-Gm-Message-State: AOAM530uiEzdiUdcRvjLVdY64dHJdaC/+4WNSYtdyk5fcB/WXee9vVH3
        AWaD21xcqji/nkb6j4NVM3f+5vyHsZLln0pDtdzNVIgET4Aj
X-Google-Smtp-Source: ABdhPJxO6N8vlOnWysT70BKpT5ycEDDvU9NMvt4s47+qOP576fZh1oBAfMemkbTCTplsoEpJgUtp0U5KZwcMSSOl2HSpCoJCXL8q
MIME-Version: 1.0
X-Received: by 2002:a5d:8417:: with SMTP id i23mr16921548ion.132.1593448275920;
 Mon, 29 Jun 2020 09:31:15 -0700 (PDT)
Date:   Mon, 29 Jun 2020 09:31:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000744a6805a93b969a@google.com>
Subject: KASAN: use-after-free Read in devlink_get_from_attrs
From:   syzbot <syzbot+09b4a3f42f32d58b8982@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4e99b321 Merge tag 'nfs-for-5.8-2' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1048c3c5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=09b4a3f42f32d58b8982
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108b3df9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d426e3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+09b4a3f42f32d58b8982@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in strcmp+0x90/0xb0 lib/string.c:364
Read of size 1 at addr ffff88808408dc18 by task syz-executor100/8628

CPU: 0 PID: 8628 Comm: syz-executor100 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 strcmp+0x90/0xb0 lib/string.c:364
 devlink_get_from_attrs+0x1bf/0x2f0 net/core/devlink.c:133
 devlink_nl_cmd_region_read_dumpit+0x177/0xed0 net/core/devlink.c:4271
 genl_lock_dumpit+0x7f/0xb0 net/netlink/genetlink.c:575
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit+0x2ac/0x310 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x797/0x9e0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447c09
Code: Bad RIP value.
RSP: 002b:00007ffcadc8f968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000447c09
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000003
RBP: 00000000000119d3 R08: 0000000000000000 R09: 0000000200000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000404ed0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8626:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x94f/0xd90 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8626:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 skb_free_head net/core/skbuff.c:590 [inline]
 skb_release_data+0x6d9/0x910 net/core/skbuff.c:610
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:831
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x53b/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88808408dc00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff88808408dc00, ffff88808408de00)
The buggy address belongs to the page:
page:ffffea0002102340 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00024d93c8 ffffea000211e048 ffff8880aa000a80
raw: 0000000000000000 ffff88808408d000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808408db00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808408db80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88808408dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88808408dc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808408dd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
