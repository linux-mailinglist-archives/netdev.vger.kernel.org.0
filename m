Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226DB1BD17A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgD2A7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:59:20 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37323 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgD2A7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:59:17 -0400
Received: by mail-il1-f199.google.com with SMTP id v9so795008iln.4
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 17:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=alzlnHvzElgkFCcj9uAJH09B1mPJhI3S0t6xX3E/1RQ=;
        b=cM1oRbY5Kw0Vet5RmGZdRc7rxq5LV84RdbPfaCr7inNW2gWlJZnceRDWrO98wH81DG
         EM2oeAqK+nS2DD1qpa9aAYFFswBIz1PN++A5F32N4xaa5cPMBM3jNyILFmwSD0qwKAAf
         /zBsUFB7NJzu46piuCAK0pa/f/xazCIM2lbFFmNZLVlHXN0aKVIxx80L9IgR3Dy+Mu1o
         gHlSrGqu4C4vuoCnJplt8ZrMFgZtce9jQSnWBG2d23kJbRGZKrtkAjplTz56P/tG6Wle
         Af9GzKfUuSKbUC0toCO4Is2JNKoGYD6KL1rncaFSoW94jNjXjLs3+6FFipWcbu2PCK5H
         cwww==
X-Gm-Message-State: AGi0PuaGNGdeWf/bgIum0mXroyp212EI0EvfdqYeUEmM6A2/mXvFhtmr
        Dlf6PUEQ1EEAk1RS+Azz4Ym2IzkF43M1RqWEQq37Z9F9C0E/
X-Google-Smtp-Source: APiQypLGe/+0Cj2mey0OG0f0/zV3JhbTyVZrmB4JcWybFiNeQI7OHje5oxbKCJnGHX9UaSqJG8j5No8nK+yYYXRMZRNFZvFWNDmy
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3d2:: with SMTP id r18mr28949634jaq.6.1588121954311;
 Tue, 28 Apr 2020 17:59:14 -0700 (PDT)
Date:   Tue, 28 Apr 2020 17:59:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f2771905a46374fe@google.com>
Subject: possible deadlock in sch_direct_xmit (2)
From:   syzbot <syzbot+e18ac85757292b7baf96@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3f2eaebb bpf, riscv: Fix tail call count off by one in RV3..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=120d1808100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b755b963c64ac09
dashboard link: https://syzkaller.appspot.com/bug?extid=e18ac85757292b7baf96
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e18ac85757292b7baf96@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.7.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/13161 is trying to acquire lock:
ffff8880978ed498 (&dev->qdisc_xmit_lock_key#292){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
ffff8880978ed498 (&dev->qdisc_xmit_lock_key#292){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4055 [inline]
ffff8880978ed498 (&dev->qdisc_xmit_lock_key#292){+.-.}-{2:2}, at: sch_direct_xmit+0x2be/0xc20 net/sched/sch_generic.c:311

but task is already holding lock:
ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4055 [inline]
ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: __dev_queue_xmit+0x26ba/0x30a0 net/core/dev.c:4048

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       spin_lock include/linux/spinlock.h:353 [inline]
       __netif_tx_lock include/linux/netdevice.h:4055 [inline]
       __dev_queue_xmit+0x26ba/0x30a0 net/core/dev.c:4048
       neigh_output include/net/neighbour.h:510 [inline]
       ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
       __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
       ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
       NF_HOOK_COND include/linux/netfilter.h:296 [inline]
       ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
       dst_output include/net/dst.h:435 [inline]
       ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
       ip6_send_skb+0xb4/0x340 net/ipv6/ip6_output.c:1865
       ip6_push_pending_frames+0xbd/0xe0 net/ipv6/ip6_output.c:1885
       icmpv6_push_pending_frames+0x33a/0x530 net/ipv6/icmp.c:304
       icmp6_send+0x1b0b/0x23b0 net/ipv6/icmp.c:617
       icmpv6_send+0xde/0x210 net/ipv6/ip6_icmp.c:43
       ip6_link_failure+0x26/0x520 net/ipv6/route.c:2640
       dst_link_failure include/net/dst.h:418 [inline]
       ip_tunnel_xmit+0x15fc/0x2a65 net/ipv4/ip_tunnel.c:820
       erspan_xmit+0x90d/0x2910 net/ipv4/ip_gre.c:683
       __netdev_start_xmit include/linux/netdevice.h:4574 [inline]
       netdev_start_xmit include/linux/netdevice.h:4588 [inline]
       xmit_one net/core/dev.c:3477 [inline]
       dev_hard_start_xmit+0x1a4/0x9b0 net/core/dev.c:3493
       sch_direct_xmit+0x345/0xc20 net/sched/sch_generic.c:313
       qdisc_restart net/sched/sch_generic.c:376 [inline]
       __qdisc_run+0x4d1/0x17b0 net/sched/sch_generic.c:384
       qdisc_run include/net/pkt_sched.h:134 [inline]
       qdisc_run include/net/pkt_sched.h:126 [inline]
       __dev_xmit_skb net/core/dev.c:3668 [inline]
       __dev_queue_xmit+0x2115/0x30a0 net/core/dev.c:4021
       neigh_resolve_output net/core/neighbour.c:1489 [inline]
       neigh_resolve_output+0x566/0x930 net/core/neighbour.c:1469
       neigh_output include/net/neighbour.h:510 [inline]
       ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
       __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
       ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
       NF_HOOK_COND include/linux/netfilter.h:296 [inline]
       ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
       dst_output include/net/dst.h:435 [inline]
       NF_HOOK include/linux/netfilter.h:307 [inline]
       rawv6_send_hdrinc net/ipv6/raw.c:687 [inline]
       rawv6_sendmsg+0x20f6/0x3900 net/ipv6/raw.c:944
       inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:807
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
       ___sys_sendmsg+0x100/0x170 net/socket.c:2416
       __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
       do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
       entry_SYSCALL_64_after_hwframe+0x49/0xb3

-> #0 (&dev->qdisc_xmit_lock_key#292){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2515 [inline]
       check_prevs_add kernel/locking/lockdep.c:2620 [inline]
       validate_chain kernel/locking/lockdep.c:3237 [inline]
       __lock_acquire+0x2ab1/0x4c50 kernel/locking/lockdep.c:4355
       lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       spin_lock include/linux/spinlock.h:353 [inline]
       __netif_tx_lock include/linux/netdevice.h:4055 [inline]
       sch_direct_xmit+0x2be/0xc20 net/sched/sch_generic.c:311
       qdisc_restart net/sched/sch_generic.c:376 [inline]
       __qdisc_run+0x4d1/0x17b0 net/sched/sch_generic.c:384
       qdisc_run include/net/pkt_sched.h:134 [inline]
       qdisc_run include/net/pkt_sched.h:126 [inline]
       __dev_xmit_skb net/core/dev.c:3668 [inline]
       __dev_queue_xmit+0x2115/0x30a0 net/core/dev.c:4021
       neigh_resolve_output net/core/neighbour.c:1489 [inline]
       neigh_resolve_output+0x566/0x930 net/core/neighbour.c:1469
       neigh_output include/net/neighbour.h:510 [inline]
       ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
       __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
       ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
       NF_HOOK_COND include/linux/netfilter.h:296 [inline]
       ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
       dst_output include/net/dst.h:435 [inline]
       NF_HOOK include/linux/netfilter.h:307 [inline]
       ndisc_send_skb+0xf40/0x14b0 net/ipv6/ndisc.c:506
       ndisc_send_ns+0x3b0/0x860 net/ipv6/ndisc.c:648
       ndisc_solicit+0x2ed/0x470 net/ipv6/ndisc.c:740
       neigh_probe+0xcc/0x110 net/core/neighbour.c:1009
       __neigh_event_send+0x3d4/0x16d0 net/core/neighbour.c:1170
       neigh_event_send include/net/neighbour.h:444 [inline]
       neigh_resolve_output+0x590/0x930 net/core/neighbour.c:1473
       neigh_output include/net/neighbour.h:510 [inline]
       ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
       __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
       ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
       NF_HOOK_COND include/linux/netfilter.h:296 [inline]
       ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
       dst_output include/net/dst.h:435 [inline]
       ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
       ip6_send_skb+0xb4/0x340 net/ipv6/ip6_output.c:1865
       ip6_push_pending_frames+0xbd/0xe0 net/ipv6/ip6_output.c:1885
       icmpv6_push_pending_frames+0x33a/0x530 net/ipv6/icmp.c:304
       icmp6_send+0x1b0b/0x23b0 net/ipv6/icmp.c:617
       icmpv6_send+0xde/0x210 net/ipv6/ip6_icmp.c:43
       ip6_link_failure+0x26/0x520 net/ipv6/route.c:2640
       dst_link_failure include/net/dst.h:418 [inline]
       vti6_xmit net/ipv6/ip6_vti.c:537 [inline]
       vti6_tnl_xmit+0xfd4/0x1d30 net/ipv6/ip6_vti.c:576
       __netdev_start_xmit include/linux/netdevice.h:4574 [inline]
       netdev_start_xmit include/linux/netdevice.h:4588 [inline]
       xmit_one net/core/dev.c:3477 [inline]
       dev_hard_start_xmit+0x1a4/0x9b0 net/core/dev.c:3493
       __dev_queue_xmit+0x25e1/0x30a0 net/core/dev.c:4052
       packet_snd net/packet/af_packet.c:2979 [inline]
       packet_sendmsg+0x23cc/0x5ce0 net/packet/af_packet.c:3004
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xcf/0x120 net/socket.c:672
       ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
       ___sys_sendmsg+0x100/0x170 net/socket.c:2416
       __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
       do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
       entry_SYSCALL_64_after_hwframe+0x49/0xb3

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dev->qdisc_xmit_lock_key#303);
                               lock(&dev->qdisc_xmit_lock_key#292);
                               lock(&dev->qdisc_xmit_lock_key#303);
  lock(&dev->qdisc_xmit_lock_key#292);

 *** DEADLOCK ***

11 locks held by syz-executor.4/13161:
 #0: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x214/0x30a0 net/core/dev.c:3987
 #1: ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:353 [inline]
 #1: ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4055 [inline]
 #1: ffff888099bcc898 (&dev->qdisc_xmit_lock_key#303){+.-.}-{2:2}, at: __dev_queue_xmit+0x26ba/0x30a0 net/core/dev.c:4048
 #2: ffffffff899bed00 (rcu_read_lock){....}-{1:2}, at: icmpv6_send+0x0/0x210 net/ipv6/ip6_icmp.c:31
 #3: ffff888087823260 (k-slock-AF_INET6){+.-.}-{2:2}, at: spin_trylock include/linux/spinlock.h:363 [inline]
 #3: ffff888087823260 (k-slock-AF_INET6){+.-.}-{2:2}, at: icmpv6_xmit_lock net/ipv6/icmp.c:117 [inline]
 #3: ffff888087823260 (k-slock-AF_INET6){+.-.}-{2:2}, at: icmp6_send+0xde8/0x23b0 net/ipv6/icmp.c:538
 #4: ffffffff899bed00 (rcu_read_lock){....}-{1:2}, at: icmp6_send+0x13cd/0x23b0 net/ipv6/icmp.c:598
 #5: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #5: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x215/0x25b0 net/ipv6/ip6_output.c:103
 #6: ffffffff899bed00 (rcu_read_lock){....}-{1:2}, at: ip6_nd_hdr net/ipv6/ndisc.c:464 [inline]
 #6: ffffffff899bed00 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x80a/0x14b0 net/ipv6/ndisc.c:500
 #7: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:92 [inline]
 #7: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x215/0x25b0 net/ipv6/ip6_output.c:103
 #8: ffffffff899beca0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x214/0x30a0 net/core/dev.c:3987
 #9: ffff8880a208d258 (&dev->qdisc_tx_busylock_key#45){+...}-{2:2}, at: spin_trylock include/linux/spinlock.h:363 [inline]
 #9: ffff8880a208d258 (&dev->qdisc_tx_busylock_key#45){+...}-{2:2}, at: qdisc_run_begin include/net/sch_generic.h:159 [inline]
 #9: ffff8880a208d258 (&dev->qdisc_tx_busylock_key#45){+...}-{2:2}, at: qdisc_run include/net/pkt_sched.h:128 [inline]
 #9: ffff8880a208d258 (&dev->qdisc_tx_busylock_key#45){+...}-{2:2}, at: __dev_xmit_skb net/core/dev.c:3668 [inline]
 #9: ffff8880a208d258 (&dev->qdisc_tx_busylock_key#45){+...}-{2:2}, at: __dev_queue_xmit+0x27d6/0x30a0 net/core/dev.c:4021
 #10: ffff8880a208d148 (&dev->qdisc_running_key#168){+...}-{0:0}, at: neigh_resolve_output net/core/neighbour.c:1489 [inline]
 #10: ffff8880a208d148 (&dev->qdisc_running_key#168){+...}-{0:0}, at: neigh_resolve_output+0x566/0x930 net/core/neighbour.c:1469

stack backtrace:
CPU: 1 PID: 13161 Comm: syz-executor.4 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1846
 check_prev_add kernel/locking/lockdep.c:2515 [inline]
 check_prevs_add kernel/locking/lockdep.c:2620 [inline]
 validate_chain kernel/locking/lockdep.c:3237 [inline]
 __lock_acquire+0x2ab1/0x4c50 kernel/locking/lockdep.c:4355
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:353 [inline]
 __netif_tx_lock include/linux/netdevice.h:4055 [inline]
 sch_direct_xmit+0x2be/0xc20 net/sched/sch_generic.c:311
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4d1/0x17b0 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:134 [inline]
 qdisc_run include/net/pkt_sched.h:126 [inline]
 __dev_xmit_skb net/core/dev.c:3668 [inline]
 __dev_queue_xmit+0x2115/0x30a0 net/core/dev.c:4021
 neigh_resolve_output net/core/neighbour.c:1489 [inline]
 neigh_resolve_output+0x566/0x930 net/core/neighbour.c:1469
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0xf40/0x14b0 net/ipv6/ndisc.c:506
 ndisc_send_ns+0x3b0/0x860 net/ipv6/ndisc.c:648
 ndisc_solicit+0x2ed/0x470 net/ipv6/ndisc.c:740
 neigh_probe+0xcc/0x110 net/core/neighbour.c:1009
 __neigh_event_send+0x3d4/0x16d0 net/core/neighbour.c:1170
 neigh_event_send include/net/neighbour.h:444 [inline]
 neigh_resolve_output+0x590/0x930 net/core/neighbour.c:1473
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0x1091/0x25b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
 ip6_send_skb+0xb4/0x340 net/ipv6/ip6_output.c:1865
 ip6_push_pending_frames+0xbd/0xe0 net/ipv6/ip6_output.c:1885
 icmpv6_push_pending_frames+0x33a/0x530 net/ipv6/icmp.c:304
 icmp6_send+0x1b0b/0x23b0 net/ipv6/icmp.c:617
 icmpv6_send+0xde/0x210 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x26/0x520 net/ipv6/route.c:2640
 dst_link_failure include/net/dst.h:418 [inline]
 vti6_xmit net/ipv6/ip6_vti.c:537 [inline]
 vti6_tnl_xmit+0xfd4/0x1d30 net/ipv6/ip6_vti.c:576
 __netdev_start_xmit include/linux/netdevice.h:4574 [inline]
 netdev_start_xmit include/linux/netdevice.h:4588 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x1a4/0x9b0 net/core/dev.c:3493
 __dev_queue_xmit+0x25e1/0x30a0 net/core/dev.c:4052
 packet_snd net/packet/af_packet.c:2979 [inline]
 packet_sendmsg+0x23cc/0x5ce0 net/packet/af_packet.c:3004
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff9339b0c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000500880 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f7 R14: 00000000004ccae4 R15: 00007ff9339b16d4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
