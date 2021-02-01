Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267D130A43D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhBAJTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:19:14 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:35322 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhBAJSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:18:01 -0500
Received: by mail-il1-f199.google.com with SMTP id i7so13112311ilu.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:17:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SrNfZXHxsIEgxk3N2yFbbCHE4Z9hx44sWpRifIxl/so=;
        b=NtoobhJ9RExhBQ/iC8SsSKAWZm5h1rWqYY/K+lHDtelNn6fmL40GNobBuJtHr3PKUa
         48gbGV9oIxBhsFoZK/8phi+apd/cT2MKJqsUfFO0qEmTtoxCuzoMWRfiErxzCXK5IqIV
         qtB7IxLVo73U9vXIHKGKl6J4/39G1HiGenDEmN5TA+jvfC+qX2BdvMH/E+Q3vk2p8+t/
         sxqXIPSHzNN1zCS5QuNsnHZy9LpVBequ2unI2bonzuoXDiBcWEXTreMA62BVXg6D5ZwZ
         0BvXlww7w8TPPQ5kr+k+duGWxrmzUykivKmEJIboUrkAQheygRoY6pt0t16xqsGN6Wz2
         FOzQ==
X-Gm-Message-State: AOAM530028wK2OtDiCrIY7AOT4nKaQB2PjxcsmGzZC+yCHWgZrAVVj2M
        gMnidJBZxKb+71gypIfG/teoTJyNVlRHv/c/6VpuiNAddMbz
X-Google-Smtp-Source: ABdhPJzBp6bDTAA6yS8c2s7Pg2gEY+OmftfyIdFfbItyeJrPDcy6KQvwArKvZf3Kbhql7In6wo+xVCq6yd3rSEUmqd3fmXO3XxMd
MIME-Version: 1.0
X-Received: by 2002:a92:c5c5:: with SMTP id s5mr10130389ilt.111.1612171033418;
 Mon, 01 Feb 2021 01:17:13 -0800 (PST)
Date:   Mon, 01 Feb 2021 01:17:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3a1b705ba42d1ca@google.com>
Subject: possible deadlock in cfg80211_netdev_notifier_call
From:   syzbot <syzbot+2ae0ca9d7737ad1a62b7@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, hagen@jauu.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b01f250d Add linux-next specific files for 20210129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14daa408d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=725bc96dc234fda7
dashboard link: https://syzkaller.appspot.com/bug?extid=2ae0ca9d7737ad1a62b7
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1757f2a0d00000

The issue was bisected to:

commit cc9327f3b085ba5be5639a5ec3ce5b08a0f14a7c
Author: Mike Rapoport <rppt@linux.ibm.com>
Date:   Thu Jan 28 07:42:40 2021 +0000

    mm: introduce memfd_secret system call to create "secret" memory areas

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1505d28cd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1705d28cd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1305d28cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ae0ca9d7737ad1a62b7@syzkaller.appspotmail.com
Fixes: cc9327f3b085 ("mm: introduce memfd_secret system call to create "secret" memory areas")

============================================
WARNING: possible recursive locking detected
5.11.0-rc5-next-20210129-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/27924 is trying to acquire lock:
ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: cfg80211_netdev_notifier_call+0x68c/0x1180 net/wireless/core.c:1407

but task is already holding lock:
ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit+0x347/0x5a0 net/wireless/nl80211.c:14837

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rdev->wiphy.mtx);
  lock(&rdev->wiphy.mtx);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor.1/27924:
 #0: ffffffff8cd04eb0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8cc75248 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0x22/0x5a0 net/wireless/nl80211.c:14793
 #2: ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
 #2: ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit+0x347/0x5a0 net/wireless/nl80211.c:14837

stack backtrace:
CPU: 1 PID: 27924 Comm: syz-executor.1 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4899
 lock_acquire kernel/locking/lockdep.c:5509 [inline]
 lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x1110 kernel/locking/mutex.c:1103
 wiphy_lock include/net/cfg80211.h:5267 [inline]
 cfg80211_netdev_notifier_call+0x68c/0x1180 net/wireless/core.c:1407
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 unregister_netdevice_many+0x943/0x1750 net/core/dev.c:10704
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10638
 register_netdevice+0x109f/0x14a0 net/core/dev.c:10013
 cfg80211_register_netdevice+0x11d/0x2a0 net/wireless/core.c:1349
 ieee80211_if_add+0xfb8/0x18f0 net/mac80211/iface.c:1990
 ieee80211_add_iface+0x99/0x160 net/mac80211/cfg.c:125
 rdev_add_virtual_intf net/wireless/rdev-ops.h:45 [inline]
 nl80211_new_interface+0x541/0x1100 net/wireless/nl80211.c:3977
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2437
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5dce348c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000020000400 RDI: 0000000000000004
RBP: 000000000119c110 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c0dc
R13: 00007ffdf00f97ff R14: 00007f5dce3499c0 R15: 000000000119c0dc


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
