Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85D520EA63
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgF3AkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:40:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50982 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgF3AkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:40:21 -0400
Received: by mail-il1-f199.google.com with SMTP id l17so13532778ilj.17
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5UrWBVmoV0kWYi8xJ1uBgWYJPb/HpjZvC3ntYfBIxAU=;
        b=VNocUruw3e2Yu/13DT2TnjlqlrN96LZhqAkJMEonv0rPhgMHkRTu7Wt5+Gqw/aoRtg
         xQK0+n41SXFTh09ECr3RrKu4+lB6YMEKriXTNlPTI7kV1KPSjJw/PUH3wvNMT+VidS+f
         RGhnzzdS/ado9n8rynzfX7L/LGNJFb7tNdst0UNAkptzxjqkRpLvwcfyzhwEJpeZ/muf
         F092nD9139nIvKRid/Mk62QYXKGxgWZVQCF/F/GIOejBJpfFL6Va4RxobC44H9CkgHUq
         uTfJkuHcJrZoLgBcwu5RGql6t5vPlBkI+8mPf+uxu2P6cWlv3sJ3429MVgWSWXwbM0ke
         9otw==
X-Gm-Message-State: AOAM530sxqpk2GkeoinBMd75601kCoEw5wt6OKuiPxTti9GNALVzuSxH
        4XcrYwE71noQhM0hweQfrGao39HD06K+Y42qCgM7TD2wLbGB
X-Google-Smtp-Source: ABdhPJwy0gmNL9dXwfjwwXH+OxIpk9277BnY8Xkr0x3lvDbLgnSTAeIpJJbea6uWk2JNS0jLiQPL3OZZDnalABZOYPmBC/vSlJuz
MIME-Version: 1.0
X-Received: by 2002:a02:c903:: with SMTP id t3mr3106487jao.30.1593477618905;
 Mon, 29 Jun 2020 17:40:18 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:40:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006eb8b705a9426b8b@google.com>
Subject: KASAN: use-after-free Read in netdev_name_node_lookup_rcu
From:   syzbot <syzbot+a82be85e09cd5df398fe@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1664afad100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=a82be85e09cd5df398fe
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a1bf1d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1514a06b100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a82be85e09cd5df398fe@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in strnlen+0x64/0x70 lib/string.c:561
Read of size 1 at addr ffff8880933b8c18 by task syz-executor821/6893

CPU: 0 PID: 6893 Comm: syz-executor821 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 strnlen+0x64/0x70 lib/string.c:561
 strnlen include/linux/string.h:339 [inline]
 dev_name_hash net/core/dev.c:208 [inline]
 netdev_name_node_lookup_rcu+0x22/0x150 net/core/dev.c:290
 dev_get_by_name_rcu net/core/dev.c:883 [inline]
 dev_get_by_name+0x7b/0x1e0 net/core/dev.c:905
 lookup_interface drivers/net/wireguard/netlink.c:63 [inline]
 wg_get_device_start+0x2e4/0x3f0 drivers/net/wireguard/netlink.c:203
 genl_start+0x342/0x6e0 net/netlink/genetlink.c:556
 __netlink_dump_start+0x585/0x900 net/netlink/af_netlink.c:2343
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
RIP: 0033:0x445299
Code: Bad RIP value.
RSP: 002b:00007ffd1e794308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000445299
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 0000000000082a5d R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402430
R13: 00000000004024c0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6894:
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

Freed by task 6894:
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

The buggy address belongs to the object at ffff8880933b8c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff8880933b8c00, ffff8880933b8e00)
The buggy address belongs to the page:
page:ffffea00024cee00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002a1da08 ffffea0002763a08 ffff8880aa000a80
raw: 0000000000000000 ffff8880933b8000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880933b8b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880933b8b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880933b8c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880933b8c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880933b8d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
