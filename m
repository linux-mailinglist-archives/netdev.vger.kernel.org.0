Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E24411E37
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346081AbhITR2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 13:28:02 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52146 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347471AbhITRZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 13:25:58 -0400
Received: by mail-il1-f200.google.com with SMTP id f16-20020a92cb50000000b002376905517dso41060012ilq.18
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=szW7gdFAOHZy2bLhqrEBYtVYWa5ODoAyvKWMsAnCIgE=;
        b=7sEGi4MI8Wudz5rFH66r4z4ZUpMuOahS3SLaI98w4IFTMUQxkd4Ua2gdSPktyYwE1h
         JquygA6bOupUQRrKnBKg5hEaEQiFls2TG3TiewWbu2/MYNiI2NSGhXdu4zblqmdB33C0
         a71bgDsnsYHf+UIazu1wqnaJFroK9TEVUIohGobR4Q739YZTdRzr4gSDP8ZDQGmTU8jp
         v9lJ8swrsfvD5BAejTbbBcSkS0N3iarIFPnIDvHSXasFWY4BDviUyzVvp9fdi4pSBvPq
         gciLWHJF4vRT+6KWUVeB32AkpKJFz6dOcO6fQLUKsXnHPYSnbqmbVNXHGVwbqxJFgKil
         MLEA==
X-Gm-Message-State: AOAM5328GR2ntJyPggw881XCoX31ND8IPaQxWDjbIOgxpP9JuSF++MJL
        hJ5cSaahpizUbbw7nUgkRDkdwRAzWStxtQr03bf+LCTjFAuN
X-Google-Smtp-Source: ABdhPJzxE3F+JIpMqceOqPa/rS5mPO6/aQ9Mzm/1QL26hKygaLRnXbQVjzwYLu+4zBuo+9fLQYB+c4mv15DMa6Rn2SrRpInP1QIR
MIME-Version: 1.0
X-Received: by 2002:a6b:6a14:: with SMTP id x20mr19000658iog.177.1632158670074;
 Mon, 20 Sep 2021 10:24:30 -0700 (PDT)
Date:   Mon, 20 Sep 2021 10:24:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf39a905cc708daf@google.com>
Subject: [syzbot] possible deadlock in bond_xmit_tlb_slave_get
From:   syzbot <syzbot+86111bc0ec8ab90759ba@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73367f05b25d Merge tag 'nfsd-5.14-1' of git://linux-nfs.or..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1197cde1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=86111bc0ec8ab90759ba
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+86111bc0ec8ab90759ba@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.14.0-rc7-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.5/28166 is trying to acquire lock:
ffff8880383d8c98 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880383d8c98 (&bond->mode_lock){+.-.}-{2:2}, at: tlb_choose_channel drivers/net/bonding/bond_alb.c:236 [inline]
ffff8880383d8c98 (&bond->mode_lock){+.-.}-{2:2}, at: bond_xmit_tlb_slave_get.part.0+0xb0/0x4f0 drivers/net/bonding/bond_alb.c:1359

but task is already holding lock:
ffff88807b208c98 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffff88807b208c98 (&bond->mode_lock){+.-.}-{2:2}, at: bond_3ad_unbind_slave+0xae/0x1fe0 drivers/net/bonding/bond_3ad.c:2103

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&bond->mode_lock);
  lock(&bond->mode_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by syz-executor.5/28166:
 #0: ffffffff8d0cd528 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0cd528 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5572
 #1: ffff88807b208c98 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #1: ffff88807b208c98 (&bond->mode_lock){+.-.}-{2:2}, at: bond_3ad_unbind_slave+0xae/0x1fe0 drivers/net/bonding/bond_3ad.c:2103
 #2: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #3: ffff88802d7a3258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:364 [inline]
 #3: ffff88802d7a3258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:173 [inline]
 #3: ffff88802d7a3258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3873 [inline]
 #3: ffff88802d7a3258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x122c/0x3620 net/core/dev.c:4253
 #4: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #4: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x290/0x2220 net/ipv4/ip_output.c:216
 #5: ffffffff8b97c220 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3620 net/core/dev.c:4219
 #6: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: is_netpoll_tx_blocked include/net/bonding.h:109 [inline]
 #6: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at: bond_start_xmit+0x88/0x1220 drivers/net/bonding/bond_main.c:4878

stack backtrace:
CPU: 1 PID: 28166 Comm: syz-executor.5 Not tainted 5.14.0-rc7-syzkaller #0
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
 tlb_choose_channel drivers/net/bonding/bond_alb.c:236 [inline]
 bond_xmit_tlb_slave_get.part.0+0xb0/0x4f0 drivers/net/bonding/bond_alb.c:1359
 bond_xmit_tlb_slave_get drivers/net/bonding/bond_alb.c:1384 [inline]
 bond_tlb_xmit+0x169/0x1a0 drivers/net/bonding/bond_alb.c:1383
 __bond_start_xmit drivers/net/bonding/bond_main.c:4861 [inline]
 bond_start_xmit+0x831/0x1220 drivers/net/bonding/bond_main.c:4883
 __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
 netdev_start_xmit include/linux/netdevice.h:4958 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 __dev_queue_xmit+0x2988/0x3620 net/core/dev.c:4285
 neigh_resolve_output net/core/neighbour.c:1496 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1476
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x804/0x2220 net/ipv4/ip_output.c:230
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x396/0x640 net/ipv4/ip_output.c:290
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x196/0x310 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:448 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x5a3/0x9c0 net/ipv4/ip_tunnel_core.c:82
 ip_tunnel_xmit+0x10a6/0x2b60 net/ipv4/ip_tunnel.c:810
 gre_tap_xmit+0x577/0x6a0 net/ipv4/ip_gre.c:737
 __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
 netdev_start_xmit include/linux/netdevice.h:4958 [inline]
 xmit_one net/core/dev.c:3659 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3675
 sch_direct_xmit+0x19f/0xbb0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3886 [inline]
 __dev_queue_xmit+0x1493/0x3620 net/core/dev.c:4253
 ad_lacpdu_send+0x577/0x6c0 drivers/net/bonding/bond_3ad.c:869
 bond_3ad_unbind_slave+0x88c/0x1fe0 drivers/net/bonding/bond_3ad.c:2122
 __bond_release_one+0x401/0x4d0 drivers/net/bonding/bond_main.c:2262
 bond_uninit+0x107/0x170 drivers/net/bonding/bond_main.c:5073
 unregister_netdevice_many+0xc85/0x1790 net/core/dev.c:11110
 rtnl_delete_link net/core/rtnetlink.c:3066 [inline]
 rtnl_dellink+0x354/0xa80 net/core/rtnetlink.c:3118
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5575
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3d889d5188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c0f0 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000005
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c0f0
R13: 00007ffc3091fedf R14: 00007f3d889d5300 R15: 0000000000022000
bond5 (unregistering): (slave gretap5): Releasing backup interface
bond5 (unregistering): Released all slaves


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
