Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211D020B69B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgFZRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:09:41 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35925 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgFZRJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:09:17 -0400
Received: by mail-il1-f199.google.com with SMTP id l11so6906615ilc.3
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:09:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A6/m2RfJ47HtBrFroQmKDP+Z+PxODyp3yWcPO/KmzL0=;
        b=mysmg41FWmF9tzLMfuOT2CrOUrctuNd5PptYEayDHEUuYJmqOTjmSYP6+5PcIShKtl
         Kki8qM1YFYJFHwardsX8pbIPv1wR4X88NeQEKcYcYT/tILmF/yqEpSjK+8XsJJ1dsk4b
         saDSX8hWQPpoQaN2N17MYBVqTht2gl8wrFDUfsD8peeHYwXs3qb2EtWiBgb4nh2N/Jkf
         vBnYir1Pu7+dstPbw/SNeEJ+XKTbGDCv5cmDtLBlbUjl6vg2FBXzWMa2lEUEA7qnnWlc
         w+N80L/QoNHljyFE8YsCCV55FxoNDUYy/9NATF1X8wZ83vMWtxhtAK071AbpzNBkKm2N
         0tpw==
X-Gm-Message-State: AOAM532LZ1rMUCXZ0HqF6ruSijuUxGPvyJCGJLbLW6gdxiUvMdQNWQQF
        Wca9aGUaNWg+w8y2rqwypbIMcTyxFoegRue5kRcRQrsZ4xwA
X-Google-Smtp-Source: ABdhPJx9mG4MxrXebe7wN+E0r5osOo4EvXNIYuwXYnNBgqqExyGJx89cHti99Ci2fWVwVK6VgrPJtCaDsdIY7z9S3tRMo1m7HQ/E
MIME-Version: 1.0
X-Received: by 2002:a92:dac8:: with SMTP id o8mr3949826ilq.152.1593191355585;
 Fri, 26 Jun 2020 10:09:15 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:09:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf1be105a8ffc44c@google.com>
Subject: possible deadlock in dev_mc_unsync
From:   syzbot <syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b835a71e usbnet: smsc95xx: Fix use-after-free after removal
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16e25419100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=08e3d39f3eb8643216be
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.5/12181 is trying to acquire lock:
ffff888090564280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
ffff888090564280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:915 [inline]
ffff888090564280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:909

but task is already holding lock:
ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:914 [inline]
ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:909

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&vlan_netdev_addr_lock_key/1);
  lock(&vlan_netdev_addr_lock_key/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by syz-executor.5/12181:
 #0: ffffffff8a809730 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:763
 #1: ffffffff8a8097e8 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8a8097e8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x76a/0x9e0 net/netlink/genetlink.c:751
 #2: ffffffff8a7d1088 (devlink_mutex){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x27/0x6a0 net/core/devlink.c:401
 #3: ffff88809df48370 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_port_del_all drivers/net/netdevsim/dev.c:951 [inline]
 #3: ffff88809df48370 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_reload_destroy+0x9e/0x1e0 drivers/net/netdevsim/dev.c:1130
 #4: ffffffff8a7afda8 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x2b/0x60 drivers/net/netdevsim/netdev.c:329
 #5: ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #5: ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
 #5: ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:914 [inline]
 #5: ffff88805dd76280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:909

stack backtrace:
CPU: 1 PID: 12181 Comm: syz-executor.5 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x178/0x3f8 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
 dev_mc_unsync net/core/dev_addr_lists.c:915 [inline]
 dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:909
 vlan_dev_stop+0x51/0x350 net/8021q/vlan_dev.c:315
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1599
 dev_close_many+0x238/0x650 net/core/dev.c:1624
 vlan_device_event+0x8ef/0x2010 net/8021q/vlan.c:450
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1628
 rollback_registered_many+0x3af/0xf60 net/core/dev.c:8945
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10113
 unregister_netdevice_many+0x36/0x50 net/core/dev.c:10112
 vlan_device_event+0x1ab5/0x2010 net/8021q/vlan.c:490
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 rollback_registered_many+0x665/0xf60 net/core/dev.c:8968
 rollback_registered net/core/dev.c:9013 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10094
 unregister_netdevice include/linux/netdevice.h:2754 [inline]
 nsim_destroy+0x35/0x60 drivers/net/netdevsim/netdev.c:330
 __nsim_dev_port_del+0x144/0x1e0 drivers/net/netdevsim/dev.c:941
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:954 [inline]
 nsim_dev_reload_destroy+0xff/0x1e0 drivers/net/netdevsim/dev.c:1130
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:711
 devlink_reload+0xc1/0x3a0 net/core/devlink.c:2797
 devlink_nl_cmd_reload+0x386/0x880 net/core/devlink.c:2832
 genl_family_rcv_msg_doit net/netlink/genetlink.c:691 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:736 [inline]
 genl_rcv_msg+0x61d/0x9e0 net/netlink/genetlink.c:753
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
RIP: 0033:0x45ca59
Code: Bad RIP value.
RSP: 002b:00007fbbcff89c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fdec0 RCX: 000000000045ca59
RDX: 0000000000000000 RSI: 0000000020000800 RDI: 0000000000000006
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000092d R14: 00000000004cbff2 R15: 00007fbbcff8a6d4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
