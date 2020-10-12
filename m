Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6557528AEB7
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJLHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:03:11 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43973 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgJLHCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:02:33 -0400
Received: by mail-io1-f71.google.com with SMTP id x13so10004797iom.10
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 00:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oBTaOP0izjvvnMj3Tgkml6QTXmNy4hLZxNIIGyQr/DQ=;
        b=uGEWpGECvaRSI4dUlserlOZZCZQK5xrln0Kot/JpwvG/eO3p9YyIRuiZOH4L6BRilP
         ygnk88QptWlgSrbvE9ROi/k69n1EUKV16zXPFkeJjjpKPCONgz5IeJ8k1ub3ux0tHv08
         7mIGbYy5C0w3GgKtmklWdDXvtJxR/g1Hb35bB1A8EuV3xXWKbbzwyrfJMBhxE37UgWjt
         VCtDj+S8Hze30P5sZxKFiZ9R8/sqCPvgK8obcGpskdBLoq0EtfeEZv6NZ2G03XmtZh02
         Zxso3cOrvFgbqmh84HJ1LMuhMJ/tJD4gnO01IWvilz1xSKj2k0aUEXm+w0JHLqGAet51
         W4qQ==
X-Gm-Message-State: AOAM530eUnPfMVttxoINLOd8Ip3f3OGUTbiMSprU8Kti/cAtsvPvDtwI
        oeWN0zAGkF8mlrxFM1ZPEUeDGhpLpKBtg9Y7Tfkv7Y3do5DP
X-Google-Smtp-Source: ABdhPJwveXlEY9Ilmtv0AfpWuPoqxbcgCFdlsA9rA54OXuaN1WFzxd4zOAOlDSXFl7FcQAbFrYFKWB+zendvxxenblyg0tbvHdb7
MIME-Version: 1.0
X-Received: by 2002:a92:ca92:: with SMTP id t18mr18284723ilo.287.1602486150916;
 Mon, 12 Oct 2020 00:02:30 -0700 (PDT)
Date:   Mon, 12 Oct 2020 00:02:30 -0700
In-Reply-To: <000000000000ae8d6e05a9c7b889@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c86f1705b173e15a@google.com>
Subject: Re: possible deadlock in dev_uc_sync
From:   syzbot <syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3dd0130f Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b36120500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
dashboard link: https://syzkaller.appspot.com/bug?extid=4a0f7bc34e3997a6c7df
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105cbfb8500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13193ce8500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4a0f7bc34e3997a6c7df@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc8-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor655/7496 is trying to acquire lock:
ffff888092808280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: netif_addr_lock include/linux/netdevice.h:4281 [inline]
ffff888092808280 (&dev_addr_list_lock_key/2){+...}-{2:2}, at: dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640

but task is already holding lock:
ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4292 [inline]
ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8274 [inline]
ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x368/0x4d0 net/core/dev.c:1529

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}:
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock include/linux/netdevice.h:4281 [inline]
       dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640
       bond_hw_addr_swap drivers/net/bonding/bond_main.c:740 [inline]
       bond_change_active_slave+0xc3d/0x20d0 drivers/net/bonding/bond_main.c:1007
       bond_select_active_slave+0x28d/0xa40 drivers/net/bonding/bond_main.c:1093
       bond_enslave+0x4441/0x49a0 drivers/net/bonding/bond_main.c:1947
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2517
       __rtnl_newlink+0x132a/0x1740 net/core/rtnetlink.c:3469
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
       rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
       netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
       netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
       netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
       sock_sendmsg_nosec net/socket.c:651 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:671
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (&dev_addr_list_lock_key/2){+...}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a96/0x5780 kernel/locking/lockdep.c:4441
       lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
       netif_addr_lock include/linux/netdevice.h:4281 [inline]
       dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640
       macvlan_set_mac_lists+0x55/0x110 drivers/net/macvlan.c:802
       __dev_set_rx_mode+0x1e2/0x2e0 net/core/dev.c:8269
       dev_set_rx_mode net/core/dev.c:8275 [inline]
       __dev_open+0x370/0x4d0 net/core/dev.c:1529
       dev_open net/core/dev.c:1557 [inline]
       dev_open+0xe8/0x150 net/core/dev.c:1550
       bond_enslave+0x927/0x49a0 drivers/net/bonding/bond_main.c:1728
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2517
       __rtnl_newlink+0x132a/0x1740 net/core/rtnetlink.c:3469
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
       rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
       netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
       netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
       netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
       sock_sendmsg_nosec net/socket.c:651 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:671
       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
       ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&macvlan_netdev_addr_lock_key/1);
                               lock(&dev_addr_list_lock_key/2);
                               lock(&macvlan_netdev_addr_lock_key/1);
  lock(&dev_addr_list_lock_key/2);

 *** DEADLOCK ***

2 locks held by syz-executor655/7496:
 #0: ffffffff8b150908 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b150908 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
 #1: ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4292 [inline]
 #1: ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_set_rx_mode net/core/dev.c:8274 [inline]
 #1: ffff888087efa280 (&macvlan_netdev_addr_lock_key/1){+...}-{2:2}, at: __dev_open+0x368/0x4d0 net/core/dev.c:1529

stack backtrace:
CPU: 0 PID: 7496 Comm: syz-executor655 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a96/0x5780 kernel/locking/lockdep.c:4441
 lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 netif_addr_lock include/linux/netdevice.h:4281 [inline]
 dev_uc_sync+0xdc/0x190 net/core/dev_addr_lists.c:640
 macvlan_set_mac_lists+0x55/0x110 drivers/net/macvlan.c:802
 __dev_set_rx_mode+0x1e2/0x2e0 net/core/dev.c:8269
 dev_set_rx_mode net/core/dev.c:8275 [inline]
 __dev_open+0x370/0x4d0 net/core/dev.c:1529
 dev_open net/core/dev.c:1557 [inline]
 dev_open+0xe8/0x150 net/core/dev.c:1550
 bond_enslave+0x927/0x49a0 drivers/net/bonding/bond_main.c:1728
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2517
 __rtnl_newlink+0x132a/0x1740 net/core/rtnetlink.c:3469
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449b39
Code: e8 cc 0c 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb38e3d4d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dfca8 RCX: 0000000000449b39
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000008
RBP: 00000000006dfca0 R08: 00007fb38e3d5700 R09: 0000000000000000
R10: 00007fb38e3d5700 R11: 0000000000000246 R12: 00000000006dfcac
R13: 00000000000003ff R14: 0000003f797fa400 R15: 070d00100000003c
bond9: (slave macvlan9): Enslaving as an active interface with a down link

