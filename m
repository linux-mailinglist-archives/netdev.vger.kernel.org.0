Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA1306168
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhA0Q7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:59:09 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:38265 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbhA0Q5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:57:04 -0500
Received: by mail-il1-f197.google.com with SMTP id p14so2189648ilb.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=l/aVeDKTBQ9QZ6G/vbWHBu+UX2b0yRaS/S8fyUsx9vQ=;
        b=DRHxoP9Ga3sTWh/FMGTOQ5P0lLiCO8eXpoDSydtYZwLAUyLd0vUDs0i0mOcSV9wDnl
         t8fsNohmptRAAH9cEFmjTE2AFguMIRR+nRtSIESJJ0r+PP8Z1mXPK+c3RMZVwDQFA+s3
         10nWRMFbKc43/UUQIB34e4v/igdrm+uFWBl0f2K2zBChJ6uUrI6HOFq7tC9uztp3SI4v
         2QSzSSqUJo4U/8boyoZHPP5UQxDkwwlYaXkJmLPGN6kTPHgAH/IX1OyPlLy7Kn//R5bb
         /2u5Yx/DO2NssLG8ceiOKsKwfdo8C2LO/l8zfCDxOog+wwJoJBT6SPAHl6xBe4aVjJRG
         AF/A==
X-Gm-Message-State: AOAM5317DDQMx8Xp6Yz/aiAI5axzBrzymNsKzY2ADio3ahH1k48ej9RD
        qWehJ6wjjjdSRWhfTa6D++QsG559LYKalAVMPQJvvlf1RB03
X-Google-Smtp-Source: ABdhPJzXirQ+/bLhDe/iqJka1KLsT+EEumuwLl4oWMu8CmR9BtN8xc2YofHeXhmPjArq1x/Tpq/EYF5ooUgGfMZAfELGsc+SH2IK
MIME-Version: 1.0
X-Received: by 2002:a02:3441:: with SMTP id z1mr9774976jaz.63.1611766582715;
 Wed, 27 Jan 2021 08:56:22 -0800 (PST)
Date:   Wed, 27 Jan 2021 08:56:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009fae0b05b9e4a6dd@google.com>
Subject: linux-next test error: possible deadlock in cfg80211_netdev_notifier_call
From:   syzbot <syzbot+3d2d5e6cc3fb15c6a0fd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b28241d8 Add linux-next specific files for 20210127
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13316b44d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37c8f99c7210a867
dashboard link: https://syzkaller.appspot.com/bug?extid=3d2d5e6cc3fb15c6a0fd
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d2d5e6cc3fb15c6a0fd@syzkaller.appspotmail.com

batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
device hsr_slave_0 entered promiscuous mode
device hsr_slave_1 entered promiscuous mode
============================================
WARNING: possible recursive locking detected
5.11.0-rc5-next-20210127-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.0/8425 is trying to acquire lock:
ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: cfg80211_netdev_notifier_call+0x615/0x1180 net/wireless/core.c:1393

but task is already holding lock:
ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: virt_wifi_newlink+0x4cb/0x940 drivers/net/wireless/virt_wifi.c:540

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rdev->wiphy.mtx);
  lock(&rdev->wiphy.mtx);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.0/8425:
 #0: ffffffff8cc71b08 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8cc71b08 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5550
 #1: ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
 #1: ffff8881446785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: virt_wifi_newlink+0x4cb/0x940 drivers/net/wireless/virt_wifi.c:540

stack backtrace:
CPU: 1 PID: 8425 Comm: syz-executor.0 Not tainted 5.11.0-rc5-next-20210127-syzkaller #0
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
 cfg80211_netdev_notifier_call+0x615/0x1180 net/wireless/core.c:1393
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 register_netdevice+0x1034/0x14a0 net/core/dev.c:10008
 virt_wifi_newlink+0x4d3/0x940 drivers/net/wireless/virt_wifi.c:541
 __rtnl_newlink+0x108b/0x16e0 net/core/rtnetlink.c:3443
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 __sys_sendto+0x21c/0x320 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x417c97
Code: 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 81 19 00 00 c3 48 83 ec 08 e8 e7 fa ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 2d fb ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd43a145b0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000016b4300 RCX: 0000000000417c97
RDX: 000000000000004c RSI: 00000000016b4350 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd43a145c0 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000016b4350 R15: 0000000000000003


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
