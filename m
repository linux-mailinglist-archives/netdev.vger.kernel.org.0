Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6015B169FF6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBXI2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:28:39 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:37721 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXI2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:28:15 -0500
Received: by mail-io1-f71.google.com with SMTP id p4so14226879ioo.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:28:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PMsLDG7qU8qRbJ/q4t0/FAebmEODLGmxDY1JVYSqgwU=;
        b=EC1tJdB2cXjEtzt68XPVwyX8E67BcKTOBGNqPlDpzT57/2UDyS7HyXxv6zOPdITD8t
         BYEb8Mavs/AWRsKytTkjR1tJFvfZNBBCPQl/NuXKlT/+uZuz4yHxC2A6QaURZxvH3Q4I
         GMsBBkZb07QmzkYHnHZIQitaFSL+HW0XMG86ObQN7ICiUbUivZqgk7s1hkV9ZdNodyHk
         kmGK67f4L+PJ40OIB5kjL5+WwZzGeKZUate42F3/XjcSOcaNNg/4XdtEP3GEf6jcCeA2
         Y/BqA3QZbCMXapMH3F4U49SuFqOKZQ9Qby1oD767HEfY9hJs653woOsJE+mUHIjPYxXq
         xbJw==
X-Gm-Message-State: APjAAAV0RG38UmUiowYHGMyivjzUBTjKs4Nx/3ruMtmutTPJIx0fjZf6
        e3yzQPT1PRyDV1kig73o26CtUrmQ0TN+EA+a26ZydvTCaBt+
X-Google-Smtp-Source: APXvYqxUWPfqxFQ3tf3i/uCWa7zXyz386/ink98iJ3mtu7gCUROGiwSVh282XG5tGuAhmd/WMlyKUs4FXOucJmFWjwWrY7ZFgBye
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:e8b:: with SMTP id t11mr52637692ilj.159.1582532894517;
 Mon, 24 Feb 2020 00:28:14 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:28:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005efef059f4e27e1@google.com>
Subject: KASAN: use-after-free Read in ethnl_update_bitset32
From:   syzbot <syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com>
To:     davem@davemloft.net, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0c0ddd6a Merge tag 'linux-watchdog-5.6-rc3' of git://www.l..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12f41c81e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=709b7a64d57978247e44
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13885de9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1518127ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
BUG: KASAN: use-after-free in ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
BUG: KASAN: use-after-free in ethnl_update_bitset32.part.0+0x8db/0x1820 net/ethtool/bitset.c:572
Read of size 4 at addr ffff8880a8adf43c by task syz-executor290/9875

CPU: 1 PID: 9875 Comm: syz-executor290 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:134
 ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
 ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
 ethnl_update_bitset32.part.0+0x8db/0x1820 net/ethtool/bitset.c:572
 ethnl_update_bitset32 net/ethtool/bitset.c:562 [inline]
 ethnl_update_bitset+0x4d/0x67 net/ethtool/bitset.c:734
 ethnl_update_linkmodes net/ethtool/linkmodes.c:303 [inline]
 ethnl_set_linkmodes+0x461/0xc30 net/ethtool/linkmodes.c:357
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445b39
Code: e8 ac cb 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab cc fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff3694a5d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000445b39
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000bb1414ac
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9724:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:523
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
 kmem_cache_zalloc include/linux/slab.h:659 [inline]
 __alloc_file+0x27/0x340 fs/file_table.c:101
 alloc_empty_file+0x72/0x170 fs/file_table.c:151
 path_openat+0xef/0x3490 fs/namei.c:3596
 do_filp_open+0x192/0x260 fs/namei.c:3637
 do_sys_openat2+0x5eb/0x7e0 fs/open.c:1149
 do_sys_open+0xf2/0x180 fs/open.c:1165
 ksys_open include/linux/syscalls.h:1386 [inline]
 __do_sys_open fs/open.c:1171 [inline]
 __se_sys_open fs/open.c:1169 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1169
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 file_free_rcu+0x98/0xe0 fs/file_table.c:50
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a8adf300
 which belongs to the cache filp of size 456
The buggy address is located 316 bytes inside of
 456-byte region [ffff8880a8adf300, ffff8880a8adf4c8)
The buggy address belongs to the page:
page:ffffea0002a2b7c0 refcount:1 mapcount:0 mapping:ffff8880aa5f88c0 index:0xffff8880a8adfa80
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028884c8 ffffea000299ec88 ffff8880aa5f88c0
raw: ffff8880a8adfa80 ffff8880a8adf080 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a8adf300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a8adf380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a8adf400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff8880a8adf480: fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc
 ffff8880a8adf500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
