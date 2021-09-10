Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6964067CF
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 09:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhIJHjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 03:39:33 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57259 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhIJHid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 03:38:33 -0400
Received: by mail-il1-f199.google.com with SMTP id d11-20020a92d78b000000b0022c670da306so1416116iln.23
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 00:37:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ECLq3Tlj41/7XypHMCkWQxWJKVcEKsiokaHShYEAAaQ=;
        b=Az1sms+HF40a/y8f7kIzrkL+pethhaFnnSsQGDteq+afUzkOH2qagx54jdL/FH5m53
         ilhvWQy9srIGvHMmM1SnZ8VwVAQYlRaLJO8AQFDUu7Z73jI8E/2aZQv0RcC8V9jNRdtU
         mxXEZ9OimAYEbheXrNAWSrksGbNA2i6ceDgdJA+BqooXFYui43JXxEZ4Vlqy18lZd4M9
         Evi8A9C08XBHeaPfXI0wEIdwJ48p2DtKd2/1Iwlg4gJe9Syhm6eVPc7NUbgcn8Q1dP8H
         KZ8EfvgwJavkkOcb9+i1uogNLrqXQjl5U0ZfsKjkyvdQxi4fFzKwtG8LAE2X8Xw/cAC6
         mApg==
X-Gm-Message-State: AOAM532BguaLKpJ+SoQSckiY1p477krRdlD1ES7+FzPUdV6dPvVYDXwF
        xUrEgLH48+VGRzBc1n8MDIQbeZGdkFKkWqoKmHl9wPcVJsdU
X-Google-Smtp-Source: ABdhPJy6YaCc3ZbPvzSaaW6EpQweOPkAAUSAOu1tvQ1CxeZUwbvoAHLnDoL8vIVzUrcrEzhbuxaa4XpgByYCXGz84BwmLa7XnAZb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:730:: with SMTP id g16mr5895756iox.138.1631259441979;
 Fri, 10 Sep 2021 00:37:21 -0700 (PDT)
Date:   Fri, 10 Sep 2021 00:37:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000936c3c05cb9f2ff8@google.com>
Subject: [syzbot] possible deadlock in br_multicast_rcv (2)
From:   syzbot <syzbot+1f749b80a78ec45502f8@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    57f780f1c433 atlantic: Fix driver resume flow.
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13fb836d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=1f749b80a78ec45502f8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f749b80a78ec45502f8@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.14.0-rc7-syzkaller #0 Not tainted
--------------------------------------------
ksoftirqd/0/13 is trying to acquire lock:
ffff888029d18fd0 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888029d18fd0 (&br->multicast_lock){+.-.}-{2:2}, at: br_ip6_multicast_query net/bridge/br_multicast.c:3000 [inline]
ffff888029d18fd0 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_ipv6_rcv net/bridge/br_multicast.c:3393 [inline]
ffff888029d18fd0 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_rcv+0x2e31/0x5b90 net/bridge/br_multicast.c:3425

but task is already holding lock:
ffff8880748c4fd0 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880748c4fd0 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_port_query_expired+0x40/0x170 net/bridge/br_multicast.c:1588

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&br->multicast_lock);
  lock(&br->multicast_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

10 locks held by ksoftirqd/0/13:
 #0: ffffc90000d27c58 ((&port->ip6_own_query.timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #0: ffffc90000d27c58 ((&port->ip6_own_query.timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1411
 #1: ffff8880748c4fd0 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #1: ffff8880748c4fd0 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_port_query_expired+0x40/0x170 net/bridge/br_multicast.c:1588
 #2: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #3: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #4: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: is_netpoll_tx_blocked include/net/bonding.h:109 [inline]
 #4: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: bond_start_xmit+0x88/0x1220 drivers/net/bonding/bond_main.c:4878
 #5: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #6: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: is_netpoll_tx_blocked include/net/bonding.h:109 [inline]
 #6: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: bond_start_xmit+0x88/0x1220 drivers/net/bonding/bond_main.c:4878
 #7: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #8: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #9: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: br_dev_xmit+0x0/0x16a0 net/bridge/br_device.c:305

stack backtrace:
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 br_ip6_multicast_query net/bridge/br_multicast.c:3000 [inline]
 br_multicast_ipv6_rcv net/bridge/br_multicast.c:3393 [inline]
 br_multicast_rcv+0x2e31/0x5b90 net/bridge/br_multicast.c:3425
 br_dev_xmit+0x6bf/0x16a0 net/bridge/br_device.c:85
 __netdev_start_xmit include/linux/netdevice.h:4948 [inline]
 netdev_start_xmit include/linux/netdevice.h:4962 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 vlan_dev_hard_start_xmit+0x1b3/0x670 net/8021q/vlan_dev.c:124
 __netdev_start_xmit include/linux/netdevice.h:4948 [inline]
 netdev_start_xmit include/linux/netdevice.h:4962 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 bond_dev_queue_xmit+0xc3/0x170 drivers/net/bonding/bond_main.c:304
 bond_do_alb_xmit+0x5ca/0x8b0 drivers/net/bonding/bond_alb.c:1327
 __bond_start_xmit drivers/net/bonding/bond_main.c:4859 [inline]
 bond_start_xmit+0xaad/0x1220 drivers/net/bonding/bond_main.c:4883
 __netdev_start_xmit include/linux/netdevice.h:4948 [inline]
 netdev_start_xmit include/linux/netdevice.h:4962 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 bond_dev_queue_xmit+0xc3/0x170 drivers/net/bonding/bond_main.c:304
 bond_3ad_xor_xmit drivers/net/bonding/bond_main.c:4621 [inline]
 __bond_start_xmit drivers/net/bonding/bond_main.c:4855 [inline]
 bond_start_xmit+0xb01/0x1220 drivers/net/bonding/bond_main.c:4883
 __netdev_start_xmit include/linux/netdevice.h:4948 [inline]
 netdev_start_xmit include/linux/netdevice.h:4962 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 macvlan_queue_xmit drivers/net/macvlan.c:543 [inline]
 macvlan_start_xmit+0x156/0x5e0 drivers/net/macvlan.c:567
 __netdev_start_xmit include/linux/netdevice.h:4948 [inline]
 netdev_start_xmit include/linux/netdevice.h:4962 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 br_dev_queue_push_xmit+0x252/0x730 net/bridge/br_forward.c:51
 NF_HOOK include/linux/netfilter.h:307 [inline]
 __br_multicast_send_query+0xf7e/0x39f0 net/bridge/br_multicast.c:1527
 br_multicast_send_query+0x27c/0x420 net/bridge/br_multicast.c:1572
 br_multicast_port_query_expired+0x118/0x170 net/bridge/br_multicast.c:1596
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_1 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth1_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
