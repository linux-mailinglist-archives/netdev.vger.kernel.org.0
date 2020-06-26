Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE420B6B9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgFZRTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:19:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43459 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFZRTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:19:18 -0400
Received: by mail-il1-f197.google.com with SMTP id y13so6905302ila.10
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bbHmjID3z59mmaaYvnIzGsPe6xV/k7aMo8icX2rKAtE=;
        b=SKPHWfoR0MED9PpTBu7tuXiILm3ZBULar+lyQACZjYO0P4BZSqtzNG8TiQBL0qUcm7
         9OHUTSs2krSXBNaWm9+X11I4DsZDtjXCT6Zru/p6eNWV4pyXgB9hdtqs0F1B89vxprzB
         sc3H7SRmfmL6GiPMJukW72mXG2MqZ35k86CYTdjpL0JBpCXqamd3BUs7p4hw0VO+zfN8
         PTxNLjUgvfoGZC5v46BBgAmzJ5Vbt969/gerAKex9mSa8iF04yx17f2ie8Ukt5maAlyF
         0sRbW35LzonO5LmsXO+hCR+3WqizZX5ryokYMp/S96JSOzLUz6wAafujBo6jPX4kpVjj
         Em/Q==
X-Gm-Message-State: AOAM530o7hhxLBb2ZnlndBX3ejGOf92iLoWRnEGLw/k1aZRIwcBT2GQY
        8ec3PEAMdA75ugmViBth7+17R9u2f94KNFRXXA0F6fVJhzPC
X-Google-Smtp-Source: ABdhPJxkkrhebP0jWRJ55XWNgRt409xaaBy67XJo9kPoUlXgPHJj6ft3nJo3haivvGDHnZc8cII1sctajZjj2x7025npqZFtj75S
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2fc1:: with SMTP id v1mr4466155iow.39.1593191957067;
 Fri, 26 Jun 2020 10:19:17 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:19:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a9000405a8ffe8f1@google.com>
Subject: KASAN: use-after-free Read in tipc_nl_node_dump_link
From:   syzbot <syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com>
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

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131cc4e5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=520f8704db2b68091d44
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b1b023100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1181ecb1100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: use-after-free in nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
BUG: KASAN: use-after-free in tipc_nl_node_dump_link+0xdd6/0xdf0 net/tipc/node.c:2591
Read of size 2 at addr ffff88809ec28014 by task syz-executor491/6907

CPU: 0 PID: 6907 Comm: syz-executor491 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 nla_len include/net/netlink.h:1135 [inline]
 nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
 tipc_nl_node_dump_link+0xdd6/0xdf0 net/tipc/node.c:2591
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
RIP: 0033:0x4456f9
Code: Bad RIP value.
RSP: 002b:00007fff47fc7fe8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004456f9
RDX: 0000000020004014 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000000f82e R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402890
R13: 0000000000402920 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6908:
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

Freed by task 6908:
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

The buggy address belongs to the object at ffff88809ec28000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
 1024-byte region [ffff88809ec28000, ffff88809ec28400)
The buggy address belongs to the page:
page:ffffea00027b0a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000248d4c8 ffffea0002499b08 ffff8880aa000c40
raw: 0000000000000000 ffff88809ec28000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809ec27f00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff88809ec27f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809ec28000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88809ec28080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809ec28100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
