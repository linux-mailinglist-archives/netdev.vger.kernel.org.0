Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE21120E91D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgF2XLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:11:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:45308 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgF2XLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 19:11:14 -0400
Received: by mail-io1-f70.google.com with SMTP id d64so11867347iof.12
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 16:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=scxQ3olKSlbD2dbdxyeSE7jRyJ9lJyRe3hVz8jvF9ow=;
        b=HJRti17zdZhxdBex203Yk6CiN3d1FPIqU2VVxb+bAzePcMjh+Jcjzky/kao2XLyQPA
         Ail2bCHpIbrVXcJByNllWdFJaiD+9/QRqMPLXAAexpyH34Av4EOmHdZHOUuzV16Gr4DP
         vrKowi71cNvFgnz87/fkHVzOeN0NV0UHWplw99ev/EBhWyfaBzkZuaNQ5npP6t2HyhVP
         LSzQyrRj5D+ysRJljg/UhcjbV2yk38iO00XyAmE18w+7e2Fosx3axu6ZQBHGGkfCW4YU
         1QJRXa1Gy2/028JLgynMECx/DiF/RXa1j64CFVPK/TSxCccCF0UTrSc0IrrO0augVoC9
         kkAw==
X-Gm-Message-State: AOAM530xneMXFFmod2m4HZMIxqp/IgVg+piv06HtQTQHduEq/zzEITCj
        aWeKpS3IHx1tPCgmoJKdORBs6lDyhCUYUB/XLTOXpR42zVD3
X-Google-Smtp-Source: ABdhPJx6hW4JpWu7xneEQCiHNeHEXyoCY16K9PPGVpQTWUp1dg1xDaKn7ah0VhFOgIgt4YT/p0ew9JG20fSp4FFidx1Smbq0Ak8v
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13cd:: with SMTP id v13mr9732535ilj.15.1593472272869;
 Mon, 29 Jun 2020 16:11:12 -0700 (PDT)
Date:   Mon, 29 Jun 2020 16:11:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8af7205a9412c5b@google.com>
Subject: KASAN: use-after-free Read in dev_get_by_name
From:   syzbot <syzbot+86e957379663a156cd31@syzkaller.appspotmail.com>
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

HEAD commit:    4e99b321 Merge tag 'nfs-for-5.8-2' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1013cb29100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=86e957379663a156cd31
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1689e8f5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f07bb100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+86e957379663a156cd31@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in strnlen+0x63/0x80 lib/string.c:561
Read of size 1 at addr ffff88809f3e9c18 by task syz-executor276/7264

CPU: 0 PID: 7264 Comm: syz-executor276 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 strnlen+0x63/0x80 lib/string.c:561
 dev_name_hash net/core/dev.c:208 [inline]
 netdev_name_node_lookup_rcu net/core/dev.c:290 [inline]
 dev_get_by_name_rcu net/core/dev.c:883 [inline]
 dev_get_by_name+0x9b/0x2a0 net/core/dev.c:905
 lookup_interface drivers/net/wireguard/netlink.c:63 [inline]
 wg_get_device_start+0x1fb/0x2d0 drivers/net/wireguard/netlink.c:203
 genl_start+0x390/0x570 net/netlink/genetlink.c:556
 __netlink_dump_start+0x3d2/0x700 net/netlink/af_netlink.c:2343
 genl_family_rcv_msg_dumpit net/netlink/genetlink.c:638 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0xb03/0xe00 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a809
Code: Bad RIP value.
RSP: 002b:00007fed6f920da8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 000000000044a809
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0000000000000000 R14: 0000000000316777 R15: 0000000000000000

Allocated by task 7265:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xde/0x4f0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7b2/0xd70 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 7265:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb+0x56/0x1c0 net/core/skbuff.c:678
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x78e/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809f3e9c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff88809f3e9c00, ffff88809f3e9e00)
The buggy address belongs to the page:
page:ffffea00027cfa40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000294b388 ffffea00029e4388 ffff8880aa400a80
raw: 0000000000000000 ffff88809f3e9000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809f3e9b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809f3e9b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809f3e9c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88809f3e9c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809f3e9d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
