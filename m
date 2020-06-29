Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A43920D12E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgF2SjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbgF2Sh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:59 -0400
Received: from mail-il1-x148.google.com (mail-il1-x148.google.com [IPv6:2607:f8b0:4864:20::148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E83C030F01
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:11:17 -0700 (PDT)
Received: by mail-il1-x148.google.com with SMTP id y3so702782ily.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GaRDhX7cOPGC7KOMXOAFCs/7Rjn+jmhfg9ZC0k5r71U=;
        b=CZbYpdCp6befcrUBNRt3zReVa7ALUfn50o8vUO6NHCB0FCuQ5vz8GxDw+rpKnY2xWq
         +h2BiiSlg0Ig6FK6PHDr/QYrtSQDlTktj6LijRI3pBqzvFg5m7e3aOF97CATWDPmRuPx
         NAWReB3yqIPw6qMUQ/WlGrDi4uXj4NBDcOJwavZDtYyePSaSr+z8c+Xes9ey/nVoRP+r
         E1vjK+vSlpwwYSUGnzeDXASKY0rovUycraM44yBSRvduCAzxCLK/E5exHULm8Z1laeh3
         JdsrJQ4LQT1V68suq8zwKBW6LaSjvFWeY6Grd8wgfH0HqC8VVquvVsasBUvKGM//8kUc
         4ceQ==
X-Gm-Message-State: AOAM532LKyXacG6Aw9bBC8X557e4aale05cUJwXrZ2DYr6S5QZb4GQ4u
        0nN2uqAoVEYAdojRbyZ6rk7BBGL2cpKK72FnMJDup8qGjEtA
X-Google-Smtp-Source: ABdhPJw3z2t1uM0GJaA/Osa2SsZoIxIS7OgCF3fDdFOVi6vY4GhZg/Hf0xiq2OUimUiGtPWglLDG9mSqk6Zl/leZAjbX/wyNWmbr
MIME-Version: 1.0
X-Received: by 2002:a02:5d49:: with SMTP id w70mr18854000jaa.16.1593447076495;
 Mon, 29 Jun 2020 09:11:16 -0700 (PDT)
Date:   Mon, 29 Jun 2020 09:11:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6883a05a93b4e6d@google.com>
Subject: KASAN: use-after-free Read in tipc_nl_publ_dump (2)
From:   syzbot <syzbot+6db30c775c0fb130e335@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4e99b321 Merge tag 'nfs-for-5.8-2' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=122afae3100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=6db30c775c0fb130e335
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158718cd100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b33c5100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6db30c775c0fb130e335@syzkaller.appspotmail.com

netlink: 8 bytes leftover after parsing attributes in process `syz-executor007'.
==================================================================
BUG: KASAN: use-after-free in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: use-after-free in nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
BUG: KASAN: use-after-free in tipc_nl_publ_dump+0xae0/0xce0 net/tipc/socket.c:3766
Read of size 2 at addr ffff8880a7ee0284 by task syz-executor007/6830

CPU: 0 PID: 6830 Comm: syz-executor007 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 nla_len include/net/netlink.h:1135 [inline]
 nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
 tipc_nl_publ_dump+0xae0/0xce0 net/tipc/socket.c:3766
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
RIP: 0033:0x445f09
Code: Bad RIP value.
RSP: 002b:00007fffb147d488 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000445f09
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000004
RBP: 00000000006d0018 R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004030a0
R13: 0000000000403130 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6828:
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

Freed by task 6828:
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

The buggy address belongs to the object at ffff8880a7ee0000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 644 bytes inside of
 1024-byte region [ffff8880a7ee0000, ffff8880a7ee0400)
The buggy address belongs to the page:
page:ffffea00029fb800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000278a308 ffffea00025273c8 ffff8880aa000c40
raw: 0000000000000000 ffff8880a7ee0000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a7ee0180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a7ee0200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a7ee0280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880a7ee0300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a7ee0380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
