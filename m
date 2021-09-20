Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990784119FC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbhITQoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:44:08 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39836 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbhITQnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:43:53 -0400
Received: by mail-il1-f200.google.com with SMTP id x7-20020a920607000000b002302afca41bso40908332ilg.6
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 09:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=C9bgPJJAKHZiTjYRUGh1pKnUCuslcmnrFsmX6UN6yz8=;
        b=0IYAnca0KKbBMMNcm2tRl+2pUHS2txzKzLo0Ps3ZujVS7zAlCbMx2d4GAIiWhLmbc0
         IzC3sBBzd43kc4smiXGSx+P1aSVRXNOFivQ6dEYOiNBQkQ4cqSkZeGM1qx3snArktyMa
         ulWdyKc+qoW3iGHykXqjzc9BtQcMiMtX4XJNpAlqj9cg8mXSUZZIKkF1OfPiujQZOg1P
         4na+5lOWeRHa3hcuseW+MwfdJyMDJI3CgFYPXohoU3dn5L2B6wrLLf3wLR0Sny9xdlTw
         E8uqwrANdmCQak8/NBoMOgSFo/wVHyXaB54S41eyWE8hG1AmH5JwfigCypQeMzS5Tm/6
         Q5pA==
X-Gm-Message-State: AOAM533ffAXdTLR3QPKC/EYSnEOgYJzYD70+gsmmsw/2rrWEx+eCqQSg
        QHZG6mUIjaHKYJ4o9qr9eCvxnSa171ZBSiqLjSycl9hZ5rDx
X-Google-Smtp-Source: ABdhPJzSwr9wgDAY+h7m1h+cIo2EGzmzJEkTDbW+AkixhabT/QDe4yuZWFgW1FMalsYYogbJDrNztfGD1xu4tRIgH/FcZIU7C7K+
MIME-Version: 1.0
X-Received: by 2002:a5d:8715:: with SMTP id u21mr19933674iom.1.1632156146651;
 Mon, 20 Sep 2021 09:42:26 -0700 (PDT)
Date:   Mon, 20 Sep 2021 09:42:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056d7e405cc6ff799@google.com>
Subject: [syzbot] possible deadlock in rlb_choose_channel
From:   syzbot <syzbot+0d07f7d98d8d2774f1ce@syzkaller.appspotmail.com>
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

HEAD commit:    02319bf15acf net: dsa: bcm_sf2: Fix array overrun in bcm_s..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=129d5527300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=0d07f7d98d8d2774f1ce
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d07f7d98d8d2774f1ce@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.15.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.3/31558 is trying to acquire lock:
ffff88802cb74cd8 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:363 [inline]
ffff88802cb74cd8 (&bond->mode_lock){+.-.}-{2:2}, at: rlb_choose_channel+0x2e/0x12e0 drivers/net/bonding/bond_alb.c:560

but task is already holding lock:
ffff8880789f4cd8 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
ffff8880789f4cd8 (&bond->mode_lock){+.-.}-{2:2}, at: bond_3ad_unbind_slave+0xae/0x1fe0 drivers/net/bonding/bond_3ad.c:2104

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&bond->mode_lock);
  lock(&bond->mode_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

8 locks held by syz-executor.3/31558:
 #0: ffffffff8d0e38e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e38e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 #1: ffff8880789f4cd8 (&bond->mode_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:368 [inline]
 #1: ffff8880789f4cd8 (&bond->mode_lock){+.-.}-{2:2}, at: bond_3ad_unbind_slave+0xae/0x1fe0 drivers/net/bonding/bond_3ad.c:2104
 #2: ffffffff8b97fdc0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1d5/0x36e0 net/core/dev.c:4136
 #3: ffff888075d89258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+.-.}-{2:2}, at: spin_trylock include/linux/spinlock.h:373 [inline]
 #3: ffff888075d89258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+.-.}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:173 [inline]
 #3: ffff888075d89258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+.-.}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3790 [inline]
 #3: ffff888075d89258 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+.-.}-{2:2}, at: __dev_queue_xmit+0x1222/0x36e0 net/core/dev.c:4170
 #4: ffffffff8b97fdc0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8b97fdc0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x28b/0x2140 net/ipv4/ip_output.c:207
 #5: ffffffff8b97fdc0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1d5/0x36e0 net/core/dev.c:4136
 #6: ffff888019d8e148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: arp_xmit_finish net/ipv4/arp.c:632 [inline]
 #6: ffff888019d8e148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: NF_HOOK include/linux/netfilter.h:307 [inline]
 #6: ffff888019d8e148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: NF_HOOK include/linux/netfilter.h:301 [inline]
 #6: ffff888019d8e148 (dev->qdisc_running_key ?: &qdisc_running_key){+...}-{0:0}, at: arp_xmit+0x8d/0xc0 net/ipv4/arp.c:641
 #7: ffffffff8b97fe20 (rcu_read_lock){....}-{1:2}, at: is_netpoll_tx_blocked include/net/bonding.h:109 [inline]
 #7: ffffffff8b97fe20 (rcu_read_lock){....}-{1:2}, at: bond_start_xmit+0x88/0x1220 drivers/net/bonding/bond_main.c:5091

stack backtrace:
CPU: 1 PID: 31558 Comm: syz-executor.3 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:363 [inline]
 rlb_choose_channel+0x2e/0x12e0 drivers/net/bonding/bond_alb.c:560
 rlb_arp_xmit drivers/net/bonding/bond_alb.c:680 [inline]
 bond_xmit_alb_slave_get+0x794/0x1ae0 drivers/net/bonding/bond_alb.c:1457
 bond_alb_xmit+0x20/0x40 drivers/net/bonding/bond_alb.c:1492
 __bond_start_xmit drivers/net/bonding/bond_main.c:5072 [inline]
 bond_start_xmit+0xaad/0x1220 drivers/net/bonding/bond_main.c:5096
 __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3592
 sch_direct_xmit+0x19f/0xbc0 net/sched/sch_generic.c:342
 qdisc_restart net/sched/sch_generic.c:407 [inline]
 __qdisc_run+0x4bc/0x1700 net/sched/sch_generic.c:415
 __dev_xmit_skb net/core/dev.c:3861 [inline]
 __dev_queue_xmit+0x1f9c/0x36e0 net/core/dev.c:4170
 arp_xmit_finish net/ipv4/arp.c:632 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 arp_xmit+0x8d/0xc0 net/ipv4/arp.c:641
 arp_send_dst net/ipv4/arp.c:319 [inline]
 arp_send_dst+0x1f2/0x230 net/ipv4/arp.c:300
 arp_solicit+0x471/0x1230 net/ipv4/arp.c:391
 neigh_probe+0xc2/0x110 net/core/neighbour.c:1011
 __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1172
 neigh_event_send include/net/neighbour.h:444 [inline]
 neigh_resolve_output+0x538/0x820 net/core/neighbour.c:1476
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x813/0x2140 net/ipv4/ip_output.c:221
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x396/0x640 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x196/0x310 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x628/0xa50 net/ipv4/ip_tunnel_core.c:82
 ip_tunnel_xmit+0x10a6/0x2b60 net/ipv4/ip_tunnel.c:810
 gre_tap_xmit+0x4ff/0x630 net/ipv4/ip_gre.c:740
 __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3592
 sch_direct_xmit+0x19f/0xbc0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3803 [inline]
 __dev_queue_xmit+0x1489/0x36e0 net/core/dev.c:4170
 ad_lacpdu_send+0x577/0x6c0 drivers/net/bonding/bond_3ad.c:869
 bond_3ad_unbind_slave+0x88c/0x1fe0 drivers/net/bonding/bond_3ad.c:2123
 __bond_release_one+0x52a/0x5f0 drivers/net/bonding/bond_main.c:2333
 bond_uninit+0x107/0x170 drivers/net/bonding/bond_main.c:5456
 unregister_netdevice_many+0xc85/0x1790 net/core/dev.c:11056
 rtnl_delete_link net/core/rtnetlink.c:3063 [inline]
 rtnl_dellink+0x354/0xa80 net/core/rtnetlink.c:3115
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb82d9dc739
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb82aef0188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb82dae11a8 RCX: 00007fb82d9dc739
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000006
RBP: 00007fb82da36cc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb82dae11a8
R13: 00007ffd300c52ef R14: 00007fb82aef0300 R15: 0000000000022000
bond9 (unregistering): (slave gretap1): Releasing backup interface
bond9 (unregistering): Released all slaves
syz-executor.3 (31558) used greatest stack depth: 20712 bytes left


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
