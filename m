Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F037030C
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhD3VjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:39:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55091 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhD3VjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:39:08 -0400
Received: by mail-io1-f72.google.com with SMTP id m7-20020a0566023147b02903c31e071e26so39596225ioy.21
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 14:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lBiAPcI1av+VyTDoVfR379O0UTkg7++CELnSDZJCurs=;
        b=p1IYENL88P6+VAXKQjmLcN6rytIALW7LGYGyicvd7SW21Mea6AKY9pJ+Cs+swUx+4C
         XbobuqPq6H0hvnMlbeCkid1z7iFbJq0ojxxGsVUg2rL46LX5HORZFTymzxuv6I8B+Rmf
         6YqClqWenVozxFC/BWn8Y1tAcE3/lHBBVYpjsguMjvQR4wDhtIOP54RBy7YYM4Z25nUX
         /+ORlxnTbjqL81SuPR1KYZXY/7GsB/qnafwcPpLIg6rRGTAdt4c0Zw68KQIDyNUzuRpg
         z/oMAyLsz46XOZnXqU1+C7V6z4wiiSSziVZu0DEtXVLxDITF6b3ckh7wxJY+3srTNk1F
         Bzpw==
X-Gm-Message-State: AOAM533+HCbs4nevma5Ym/RIVu/i3KeTijcLCPu3bsfoxjPNsGDtlpxJ
        BPPfHLzRSHjJQnAVw2szs1MSymfnBHiHotMfV5P97peTlxJQ
X-Google-Smtp-Source: ABdhPJy+/+jk7CA47dGgSdDEa1SIEFiaMMnboZ4EEH+JPt2o5kqt3/d1pzHZZpsoMkxov9EdRy227SSXf7+LB1Xd21kpnAZgTySM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:10c6:: with SMTP id s6mr6114219ilj.15.1619818698022;
 Fri, 30 Apr 2021 14:38:18 -0700 (PDT)
Date:   Fri, 30 Apr 2021 14:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018a59e05c1376ea3@google.com>
Subject: [syzbot] possible deadlock in ieee80211_tx_frags
From:   syzbot <syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        johannes.berg@intel.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e7679c55 net: phy: marvell: fix m88e1111_set_downshift
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=106f9d61d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=339c2ecce8fdd1d0
dashboard link: https://syzkaller.appspot.com/bug?extid=69ff9dff50dcfe14ddd4

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com

=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
5.12.0-rc7-syzkaller #0 Not tainted
-----------------------------------------------------
syz-executor.0/5017 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
ffffffff8d6faaf8 (nl_table_lock){.+.?}-{2:2}, at: netlink_lock_table net/netlink/af_netlink.c:466 [inline]
ffffffff8d6faaf8 (nl_table_lock){.+.?}-{2:2}, at: netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517

and this task is already holding:
ffff88801d779340 (&local->queue_stop_reason_lock){..-.}-{2:2}, at: ieee80211_do_stop+0xb37/0x20e0 net/mac80211/iface.c:562
which would create a new lock dependency:
 (&local->queue_stop_reason_lock){..-.}-{2:2} -> (nl_table_lock){.+.?}-{2:2}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&local->queue_stop_reason_lock){..-.}-{2:2}

... which became SOFTIRQ-irq-safe at:
  lock_acquire kernel/locking/lockdep.c:5511 [inline]
  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
  ieee80211_tx_frags+0x160/0x970 net/mac80211/tx.c:1625
  __ieee80211_tx+0x1ad/0x640 net/mac80211/tx.c:1726
  ieee80211_tx+0x32f/0x430 net/mac80211/tx.c:1909
  ieee80211_xmit+0x339/0x420 net/mac80211/tx.c:2002
  __ieee80211_subif_start_xmit+0x7e0/0xcb0 net/mac80211/tx.c:3999
  ieee80211_subif_start_xmit+0xee/0xee0 net/mac80211/tx.c:4135
  __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
  netdev_start_xmit include/linux/netdevice.h:4839 [inline]
  xmit_one net/core/dev.c:3605 [inline]
  dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3621
  sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
  qdisc_restart net/sched/sch_generic.c:376 [inline]
  __qdisc_run+0x4ba/0x15f0 net/sched/sch_generic.c:384
  qdisc_run include/net/pkt_sched.h:136 [inline]
  qdisc_run include/net/pkt_sched.h:128 [inline]
  __dev_xmit_skb net/core/dev.c:3807 [inline]
  __dev_queue_xmit+0x14b9/0x2e00 net/core/dev.c:4162
  neigh_resolve_output net/core/neighbour.c:1495 [inline]
  neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1475
  neigh_output include/net/neighbour.h:510 [inline]
  ip6_finish_output2+0x6ee/0x1700 net/ipv6/ip6_output.c:117
  __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
  __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
  ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
  ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
  dst_output include/net/dst.h:448 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  NF_HOOK include/linux/netfilter.h:295 [inline]
  mld_sendpack+0x92a/0xdb0 net/ipv6/mcast.c:1679
  mld_send_cr net/ipv6/mcast.c:1975 [inline]
  mld_ifc_timer_expire+0x60a/0xf10 net/ipv6/mcast.c:2474
  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
  expire_timers kernel/time/timer.c:1476 [inline]
  __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
  __run_timers kernel/time/timer.c:1726 [inline]
  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
  invoke_softirq kernel/softirq.c:221 [inline]
  __irq_exit_rcu kernel/softirq.c:422 [inline]
  irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
  lock_acquire+0x1ef/0x740 kernel/locking/lockdep.c:5479
  rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
  rcu_read_lock include/linux/rcupdate.h:656 [inline]
  batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:404 [inline]
  batadv_nc_worker+0x12d/0xe50 net/batman-adv/network-coding.c:715
  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
  kthread+0x3b1/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

to a SOFTIRQ-irq-unsafe lock:
 (nl_table_lock){.+.?}-{2:2}

... which became SOFTIRQ-irq-unsafe at:
...
  lock_acquire kernel/locking/lockdep.c:5511 [inline]
  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
  __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
  _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
  netlink_lock_table net/netlink/af_netlink.c:466 [inline]
  netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
  netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
  nlmsg_multicast include/net/netlink.h:1033 [inline]
  genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
  genl_ctrl_event.isra.0+0x42e/0xa40 net/netlink/genetlink.c:1101
  genl_register_family net/netlink/genetlink.c:438 [inline]
  genl_register_family+0xb09/0x12d0 net/netlink/genetlink.c:392
  thermal_init+0x12/0x25f drivers/thermal/thermal_core.c:1520
  do_one_initcall+0x103/0x650 init/main.c:1226
  do_initcall_level init/main.c:1299 [inline]
  do_initcalls init/main.c:1315 [inline]
  do_basic_setup init/main.c:1335 [inline]
  kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
  kernel_init+0xd/0x1b8 init/main.c:1424
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(nl_table_lock);
                               local_irq_disable();
                               lock(&local->queue_stop_reason_lock);
                               lock(nl_table_lock);
  <Interrupt>
    lock(&local->queue_stop_reason_lock);

 *** DEADLOCK ***

5 locks held by syz-executor.0/5017:
 #0: ffffffff8d6fcd30 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d66bfe8 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0x23/0x5c0 net/wireless/nl80211.c:14805
 #2: ffff88801d7785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5269 [inline]
 #2: ffff88801d7785e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit+0x391/0x5c0 net/wireless/nl80211.c:14849
 #3: ffff88801d779340 (&local->queue_stop_reason_lock){..-.}-{2:2}, at: ieee80211_do_stop+0xb37/0x20e0 net/mac80211/iface.c:562
 #4: ffffffff8bf74360 (rcu_read_lock){....}-{1:2}, at: ieee80211_report_ack_skb net/mac80211/status.c:630 [inline]
 #4: ffffffff8bf74360 (rcu_read_lock){....}-{1:2}, at: ieee80211_report_used_skb+0xcd2/0x14c0 net/mac80211/status.c:719

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&local->queue_stop_reason_lock){..-.}-{2:2} {
   IN-SOFTIRQ-W at:
                    lock_acquire kernel/locking/lockdep.c:5511 [inline]
                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                    _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                    ieee80211_tx_frags+0x160/0x970 net/mac80211/tx.c:1625
                    __ieee80211_tx+0x1ad/0x640 net/mac80211/tx.c:1726
                    ieee80211_tx+0x32f/0x430 net/mac80211/tx.c:1909
                    ieee80211_xmit+0x339/0x420 net/mac80211/tx.c:2002
                    __ieee80211_subif_start_xmit+0x7e0/0xcb0 net/mac80211/tx.c:3999
                    ieee80211_subif_start_xmit+0xee/0xee0 net/mac80211/tx.c:4135
                    __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
                    netdev_start_xmit include/linux/netdevice.h:4839 [inline]
                    xmit_one net/core/dev.c:3605 [inline]
                    dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3621
                    sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
                    qdisc_restart net/sched/sch_generic.c:376 [inline]
                    __qdisc_run+0x4ba/0x15f0 net/sched/sch_generic.c:384
                    qdisc_run include/net/pkt_sched.h:136 [inline]
                    qdisc_run include/net/pkt_sched.h:128 [inline]
                    __dev_xmit_skb net/core/dev.c:3807 [inline]
                    __dev_queue_xmit+0x14b9/0x2e00 net/core/dev.c:4162
                    neigh_resolve_output net/core/neighbour.c:1495 [inline]
                    neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1475
                    neigh_output include/net/neighbour.h:510 [inline]
                    ip6_finish_output2+0x6ee/0x1700 net/ipv6/ip6_output.c:117
                    __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
                    __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
                    ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
                    NF_HOOK_COND include/linux/netfilter.h:290 [inline]
                    ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
                    dst_output include/net/dst.h:448 [inline]
                    NF_HOOK include/linux/netfilter.h:301 [inline]
                    NF_HOOK include/linux/netfilter.h:295 [inline]
                    mld_sendpack+0x92a/0xdb0 net/ipv6/mcast.c:1679
                    mld_send_cr net/ipv6/mcast.c:1975 [inline]
                    mld_ifc_timer_expire+0x60a/0xf10 net/ipv6/mcast.c:2474
                    call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
                    expire_timers kernel/time/timer.c:1476 [inline]
                    __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
                    __run_timers kernel/time/timer.c:1726 [inline]
                    run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
                    __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
                    invoke_softirq kernel/softirq.c:221 [inline]
                    __irq_exit_rcu kernel/softirq.c:422 [inline]
                    irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
                    sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
                    lock_acquire+0x1ef/0x740 kernel/locking/lockdep.c:5479
                    rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
                    rcu_read_lock include/linux/rcupdate.h:656 [inline]
                    batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:404 [inline]
                    batadv_nc_worker+0x12d/0xe50 net/batman-adv/network-coding.c:715
                    process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
                    worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
                    kthread+0x3b1/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5511 [inline]
                   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                   _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                   ieee80211_do_open+0x1586/0x23f0 net/mac80211/iface.c:1268
                   ieee80211_open net/mac80211/iface.c:361 [inline]
                   ieee80211_open+0x1a0/0x240 net/mac80211/iface.c:347
                   __dev_open+0x2bc/0x4d0 net/core/dev.c:1563
                   __dev_change_flags+0x583/0x750 net/core/dev.c:8688
                   dev_change_flags+0x93/0x170 net/core/dev.c:8759
                   devinet_ioctl+0x15e6/0x1c90 net/ipv4/devinet.c:1142
                   inet_ioctl+0x1ea/0x330 net/ipv4/af_inet.c:971
                   sock_do_ioctl+0xcb/0x2d0 net/socket.c:1039
                   sock_ioctl+0x477/0x6a0 net/socket.c:1179
                   vfs_ioctl fs/ioctl.c:48 [inline]
                   __do_sys_ioctl fs/ioctl.c:753 [inline]
                   __se_sys_ioctl fs/ioctl.c:739 [inline]
                   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
                   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                   entry_SYSCALL_64_after_hwframe+0x44/0xae
 }
 ... key      at: [<ffffffff901e4520>] __key.19+0x0/0x40
 ... acquired at:
   lock_acquire kernel/locking/lockdep.c:5511 [inline]
   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
   __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
   _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
   netlink_lock_table net/netlink/af_netlink.c:466 [inline]
   netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
   netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
   nlmsg_multicast include/net/netlink.h:1033 [inline]
   genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
   nl80211_frame_tx_status+0x929/0xb20 net/wireless/nl80211.c:16960
   cfg80211_mgmt_tx_status+0x3b/0x50 net/wireless/nl80211.c:16980
   ieee80211_report_ack_skb net/mac80211/status.c:650 [inline]
   ieee80211_report_used_skb+0xf41/0x14c0 net/mac80211/status.c:719
   ieee80211_free_txskb+0x1e/0x30 net/mac80211/status.c:1243
   ieee80211_do_stop+0xd17/0x20e0 net/mac80211/iface.c:568
   ieee80211_runtime_change_iftype net/mac80211/iface.c:1640 [inline]
   ieee80211_if_change_type+0x2c5/0x6e0 net/mac80211/iface.c:1678
   ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
   rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
   cfg80211_change_iface+0x335/0xf30 net/wireless/util.c:1067
   nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3916
   genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
   genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
   genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
   genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
   netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
   sock_sendmsg_nosec net/socket.c:654 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:674
   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
   ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae


the dependencies between the lock to be acquired
 and SOFTIRQ-irq-unsafe lock:
-> (nl_table_lock){.+.?}-{2:2} {
   HARDIRQ-ON-R at:
                    lock_acquire kernel/locking/lockdep.c:5511 [inline]
                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                    __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                    _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                    netlink_lock_table net/netlink/af_netlink.c:466 [inline]
                    netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
                    netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
                    nlmsg_multicast include/net/netlink.h:1033 [inline]
                    genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
                    genl_ctrl_event.isra.0+0x42e/0xa40 net/netlink/genetlink.c:1101
                    genl_register_family net/netlink/genetlink.c:438 [inline]
                    genl_register_family+0xb09/0x12d0 net/netlink/genetlink.c:392
                    thermal_init+0x12/0x25f drivers/thermal/thermal_core.c:1520
                    do_one_initcall+0x103/0x650 init/main.c:1226
                    do_initcall_level init/main.c:1299 [inline]
                    do_initcalls init/main.c:1315 [inline]
                    do_basic_setup init/main.c:1335 [inline]
                    kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
                    kernel_init+0xd/0x1b8 init/main.c:1424
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   IN-SOFTIRQ-R at:
                    lock_acquire kernel/locking/lockdep.c:5511 [inline]
                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                    __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                    _raw_read_lock+0x36/0x70 kernel/locking/spinlock.c:223
                    netlink_lock_table net/netlink/af_netlink.c:466 [inline]
                    netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
                    netlink_broadcast net/netlink/af_netlink.c:1544 [inline]
                    nlmsg_multicast include/net/netlink.h:1033 [inline]
                    nlmsg_notify+0x90/0x250 net/netlink/af_netlink.c:2545
                    __neigh_notify+0xdc/0x160 net/core/neighbour.c:3372
                    neigh_update_notify net/core/neighbour.c:2524 [inline]
                    __neigh_update+0x1196/0x2690 net/core/neighbour.c:1410
                    arp_process+0xa3a/0x24e0 net/ipv4/arp.c:911
                    NF_HOOK include/linux/netfilter.h:301 [inline]
                    NF_HOOK include/linux/netfilter.h:295 [inline]
                    arp_rcv net/ipv4/arp.c:967 [inline]
                    arp_rcv+0x3d7/0x540 net/ipv4/arp.c:942
                    __netif_receive_skb_list_ptype net/core/dev.c:5432 [inline]
                    __netif_receive_skb_list_ptype net/core/dev.c:5416 [inline]
                    __netif_receive_skb_list_core+0x6c7/0x8e0 net/core/dev.c:5475
                    __netif_receive_skb_list net/core/dev.c:5527 [inline]
                    netif_receive_skb_list_internal+0x777/0xd70 net/core/dev.c:5637
                    gro_normal_list net/core/dev.c:5791 [inline]
                    gro_normal_list net/core/dev.c:5787 [inline]
                    napi_complete_done+0x1f1/0x880 net/core/dev.c:6494
                    virtqueue_napi_complete+0x2c/0xc0 drivers/net/virtio_net.c:334
                    virtnet_poll+0xae2/0xd90 drivers/net/virtio_net.c:1459
                    __napi_poll+0xaf/0x440 net/core/dev.c:6913
                    napi_poll net/core/dev.c:6980 [inline]
                    net_rx_action+0x801/0xb40 net/core/dev.c:7067
                    __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
                    invoke_softirq kernel/softirq.c:221 [inline]
                    __irq_exit_rcu kernel/softirq.c:422 [inline]
                    irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
                    common_interrupt+0xa4/0xd0 arch/x86/kernel/irq.c:240
                    asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:623
                    check_kcov_mode kernel/kcov.c:165 [inline]
                    __sanitizer_cov_trace_pc+0x37/0x60 kernel/kcov.c:197
                    string_nocheck lib/vsprintf.c:614 [inline]
                    string+0x13e/0x3d0 lib/vsprintf.c:693
                    vsnprintf+0x71b/0x14f0 lib/vsprintf.c:2651
                    snprintf+0xbb/0xf0 lib/vsprintf.c:2784
                    tomoyo_init_log+0x1485/0x1ee0 security/tomoyo/audit.c:283
                    tomoyo_supervisor+0x34d/0xf00 security/tomoyo/common.c:2097
                    tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
                    tomoyo_env_perm+0x17f/0x1f0 security/tomoyo/environ.c:63
                    tomoyo_environ security/tomoyo/domain.c:672 [inline]
                    tomoyo_find_next_domain+0x1438/0x1f80 security/tomoyo/domain.c:879
                    tomoyo_bprm_check_security security/tomoyo/tomoyo.c:101 [inline]
                    tomoyo_bprm_check_security+0x121/0x1a0 security/tomoyo/tomoyo.c:91
                    security_bprm_check+0x45/0xa0 security/security.c:842
                    search_binary_handler fs/exec.c:1708 [inline]
                    exec_binprm fs/exec.c:1761 [inline]
                    bprm_execve fs/exec.c:1830 [inline]
                    bprm_execve+0x764/0x19a0 fs/exec.c:1792
                    do_execveat_common+0x626/0x7c0 fs/exec.c:1919
                    do_execve fs/exec.c:1987 [inline]
                    __do_sys_execve fs/exec.c:2063 [inline]
                    __se_sys_execve fs/exec.c:2058 [inline]
                    __x64_sys_execve+0x8f/0xc0 fs/exec.c:2058
                    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                    entry_SYSCALL_64_after_hwframe+0x44/0xae
   SOFTIRQ-ON-R at:
                    lock_acquire kernel/locking/lockdep.c:5511 [inline]
                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                    __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                    _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                    netlink_lock_table net/netlink/af_netlink.c:466 [inline]
                    netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
                    netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
                    nlmsg_multicast include/net/netlink.h:1033 [inline]
                    genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
                    genl_ctrl_event.isra.0+0x42e/0xa40 net/netlink/genetlink.c:1101
                    genl_register_family net/netlink/genetlink.c:438 [inline]
                    genl_register_family+0xb09/0x12d0 net/netlink/genetlink.c:392
                    thermal_init+0x12/0x25f drivers/thermal/thermal_core.c:1520
                    do_one_initcall+0x103/0x650 init/main.c:1226
                    do_initcall_level init/main.c:1299 [inline]
                    do_initcalls init/main.c:1315 [inline]
                    do_basic_setup init/main.c:1335 [inline]
                    kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
                    kernel_init+0xd/0x1b8 init/main.c:1424
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5511 [inline]
                   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                   __raw_write_lock_irq include/linux/rwlock_api_smp.h:196 [inline]
                   _raw_write_lock_irq+0x32/0x50 kernel/locking/spinlock.c:311
                   netlink_table_grab+0x2a/0x70 net/netlink/af_netlink.c:434
                   netlink_add_usersock_entry net/netlink/af_netlink.c:2805 [inline]
                   netlink_proto_init+0x1cb/0x320 net/netlink/af_netlink.c:2896
                   do_one_initcall+0x103/0x650 init/main.c:1226
                   do_initcall_level init/main.c:1299 [inline]
                   do_initcalls init/main.c:1315 [inline]
                   do_basic_setup init/main.c:1335 [inline]
                   kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
                   kernel_init+0xd/0x1b8 init/main.c:1424
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   INITIAL READ USE at:
                        lock_acquire kernel/locking/lockdep.c:5511 [inline]
                        lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
                        __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                        _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                        netlink_lock_table net/netlink/af_netlink.c:466 [inline]
                        netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
                        netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
                        nlmsg_multicast include/net/netlink.h:1033 [inline]
                        genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
                        genl_ctrl_event.isra.0+0x42e/0xa40 net/netlink/genetlink.c:1101
                        genl_register_family net/netlink/genetlink.c:438 [inline]
                        genl_register_family+0xb09/0x12d0 net/netlink/genetlink.c:392
                        thermal_init+0x12/0x25f drivers/thermal/thermal_core.c:1520
                        do_one_initcall+0x103/0x650 init/main.c:1226
                        do_initcall_level init/main.c:1299 [inline]
                        do_initcalls init/main.c:1315 [inline]
                        do_basic_setup init/main.c:1335 [inline]
                        kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
                        kernel_init+0xd/0x1b8 init/main.c:1424
                        ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
 }
 ... key      at: [<ffffffff8d6faaf8>] nl_table_lock+0x18/0x60
 ... acquired at:
   lock_acquire kernel/locking/lockdep.c:5511 [inline]
   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
   __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
   _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
   netlink_lock_table net/netlink/af_netlink.c:466 [inline]
   netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
   netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
   nlmsg_multicast include/net/netlink.h:1033 [inline]
   genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
   nl80211_frame_tx_status+0x929/0xb20 net/wireless/nl80211.c:16960
   cfg80211_mgmt_tx_status+0x3b/0x50 net/wireless/nl80211.c:16980
   ieee80211_report_ack_skb net/mac80211/status.c:650 [inline]
   ieee80211_report_used_skb+0xf41/0x14c0 net/mac80211/status.c:719
   ieee80211_free_txskb+0x1e/0x30 net/mac80211/status.c:1243
   ieee80211_do_stop+0xd17/0x20e0 net/mac80211/iface.c:568
   ieee80211_runtime_change_iftype net/mac80211/iface.c:1640 [inline]
   ieee80211_if_change_type+0x2c5/0x6e0 net/mac80211/iface.c:1678
   ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
   rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
   cfg80211_change_iface+0x335/0xf30 net/wireless/util.c:1067
   nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3916
   genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
   genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
   genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
   genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
   netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
   sock_sendmsg_nosec net/socket.c:654 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:674
   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
   ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae


stack backtrace:
CPU: 0 PID: 5017 Comm: syz-executor.0 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_bad_irq_dependency kernel/locking/lockdep.c:2461 [inline]
 check_irq_usage.cold+0x50d/0x744 kernel/locking/lockdep.c:2690
 check_prev_add kernel/locking/lockdep.c:2941 [inline]
 check_prevs_add kernel/locking/lockdep.c:3060 [inline]
 validate_chain kernel/locking/lockdep.c:3675 [inline]
 __lock_acquire+0x2b2c/0x54c0 kernel/locking/lockdep.c:4901
 lock_acquire kernel/locking/lockdep.c:5511 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
 __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
 _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
 netlink_lock_table net/netlink/af_netlink.c:466 [inline]
 netlink_broadcast_filtered+0x76/0xdc0 net/netlink/af_netlink.c:1517
 netlink_broadcast+0x35/0x40 net/netlink/af_netlink.c:1544
 nlmsg_multicast include/net/netlink.h:1033 [inline]
 genlmsg_multicast_netns include/net/genetlink.h:311 [inline]
 nl80211_frame_tx_status+0x929/0xb20 net/wireless/nl80211.c:16960
 cfg80211_mgmt_tx_status+0x3b/0x50 net/wireless/nl80211.c:16980
 ieee80211_report_ack_skb net/mac80211/status.c:650 [inline]
 ieee80211_report_used_skb+0xf41/0x14c0 net/mac80211/status.c:719
 ieee80211_free_txskb+0x1e/0x30 net/mac80211/status.c:1243
 ieee80211_do_stop+0xd17/0x20e0 net/mac80211/iface.c:568
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1640 [inline]
 ieee80211_if_change_type+0x2c5/0x6e0 net/mac80211/iface.c:1678
 ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x335/0xf30 net/wireless/util.c:1067
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3916
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f62f03ea188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000006
RBP: 00000000004bfbb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffdaa41090f R14: 00007f62f03ea300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
