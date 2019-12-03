Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A433E10FB2C
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 10:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLCJzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 04:55:09 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:48474 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLCJzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 04:55:08 -0500
Received: by mail-io1-f69.google.com with SMTP id e15so2002608ioh.15
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 01:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bRVPJYxVJKQcYwA+gQ6WPDZdzXEVmV0aqa8OHhQhGOM=;
        b=EG7FXasXz28nvlqv3aZL/dQQ0jTnYejNajIvjSNPt5CUwn8vihgFwsXIZPkTjbwL4s
         TGyd09n2NeyXl6O2x+skU/qiAKXlLngS3YSWc3wCFoBZqNjEBBFBFZTwESHDUfV09s1W
         EeogEhVH3wjDVgQxC7bhCn1FHc6UDDs6TRg9HjAjszYRONRHwux4rawJu3nmTQhB1tLP
         1KOYiNVG+9cwX/CaWb1fqngpS+pC1E2hD70whhpNFOSXyKb8zAioPwmoUiq/n1Y1x0r+
         b49YuISK7Cbrnitp7RnWnN5wAyMKeTD1IRZORfujJBeWzDvuXH+OcurOO8NpxvK4GrTX
         O2ow==
X-Gm-Message-State: APjAAAUO94Ytrfh1AFbA7EexSoApD3zfrB8AyFwNpD7dY1qnRhXtI4DH
        kChTauw+9j65gASVy+ZR/jLd0I1LmGxPvQ6OxPhUjo/TW3Ef
X-Google-Smtp-Source: APXvYqwFKt0qoy7uD36l5bn/ZcG+6QR/ZtvUAq8iWV3M17Sh+WWda33OjZJ9eKmlPeQ3ii5xqnd50Mowcjj1Qjf8TOCqBgk3wslU
MIME-Version: 1.0
X-Received: by 2002:a92:1f16:: with SMTP id i22mr4038062ile.206.1575366907559;
 Tue, 03 Dec 2019 01:55:07 -0800 (PST)
Date:   Tue, 03 Dec 2019 01:55:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea90600598c9b089@google.com>
Subject: possible deadlock in __dev_queue_xmit (3)
From:   syzbot <syzbot+3b165dac15094065651e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    419593da Add linux-next specific files for 20191129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14709712e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f4b95d6f8310863
dashboard link: https://syzkaller.appspot.com/bug?extid=3b165dac15094065651e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3b165dac15094065651e@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.4.0-next-20191129-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/2879 is trying to acquire lock:
ffff88809435b218 (&dev->qdisc_tx_busylock_key#71){+...}, at: spin_lock  
include/linux/spinlock.h:338 [inline]
ffff88809435b218 (&dev->qdisc_tx_busylock_key#71){+...}, at: __dev_xmit_skb  
net/core/dev.c:3644 [inline]
ffff88809435b218 (&dev->qdisc_tx_busylock_key#71){+...}, at:  
__dev_queue_xmit+0x2dce/0x35c0 net/core/dev.c:3982

but task is already holding lock:
ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at: spin_lock  
include/linux/spinlock.h:338 [inline]
ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at: __netif_tx_lock  
include/linux/netdevice.h:3929 [inline]
ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at:  
sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dev->qdisc_xmit_lock_key#312){+.-.}:
        __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
        _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
        spin_lock include/linux/spinlock.h:338 [inline]
        __netif_tx_lock include/linux/netdevice.h:3929 [inline]
        sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311
        __dev_xmit_skb net/core/dev.c:3621 [inline]
        __dev_queue_xmit+0x270a/0x35c0 net/core/dev.c:3982
        dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
        neigh_resolve_output net/core/neighbour.c:1490 [inline]
        neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
        neigh_output include/net/neighbour.h:511 [inline]
        ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
        __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
        ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
        NF_HOOK_COND include/linux/netfilter.h:296 [inline]
        ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
        dst_output include/net/dst.h:436 [inline]
        NF_HOOK include/linux/netfilter.h:307 [inline]
        NF_HOOK include/linux/netfilter.h:301 [inline]
        mld_sendpack+0x9c2/0xed0 net/ipv6/mcast.c:1682
        mld_send_cr net/ipv6/mcast.c:1978 [inline]
        mld_ifc_timer_expire+0x454/0x950 net/ipv6/mcast.c:2477
        call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
        expire_timers kernel/time/timer.c:1449 [inline]
        __run_timers kernel/time/timer.c:1773 [inline]
        __run_timers kernel/time/timer.c:1740 [inline]
        run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
        __do_softirq+0x262/0x98c kernel/softirq.c:292
        invoke_softirq kernel/softirq.c:373 [inline]
        irq_exit+0x19b/0x1e0 kernel/softirq.c:413
        exiting_irq arch/x86/include/asm/apic.h:536 [inline]
        smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
        apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
        arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
        slab_alloc mm/slab.c:3313 [inline]
        __do_kmalloc mm/slab.c:3654 [inline]
        __kmalloc+0x2b8/0x770 mm/slab.c:3665
        kmalloc include/linux/slab.h:561 [inline]
        tomoyo_realpath_from_path+0xc5/0x660 security/tomoyo/realpath.c:252
        tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
        tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
        tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:341
        security_file_ioctl+0x77/0xc0 security/security.c:1409
        ksys_ioctl+0x57/0xd0 fs/ioctl.c:747
        __do_sys_ioctl fs/ioctl.c:756 [inline]
        __se_sys_ioctl fs/ioctl.c:754 [inline]
        __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
        do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&dev->qdisc_tx_busylock_key#71){+...}:
        check_prev_add kernel/locking/lockdep.c:2476 [inline]
        check_prevs_add kernel/locking/lockdep.c:2581 [inline]
        validate_chain kernel/locking/lockdep.c:2971 [inline]
        __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
        lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
        __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
        _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
        spin_lock include/linux/spinlock.h:338 [inline]
        __dev_xmit_skb net/core/dev.c:3644 [inline]
        __dev_queue_xmit+0x2dce/0x35c0 net/core/dev.c:3982
        dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
        neigh_resolve_output net/core/neighbour.c:1490 [inline]
        neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
        neigh_output include/net/neighbour.h:511 [inline]
        ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
        __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
        ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
        NF_HOOK_COND include/linux/netfilter.h:296 [inline]
        ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
        dst_output include/net/dst.h:436 [inline]
        NF_HOOK include/linux/netfilter.h:307 [inline]
        ndisc_send_skb+0xf1f/0x1490 net/ipv6/ndisc.c:505
        ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:647
        ndisc_solicit+0x2ed/0x470 net/ipv6/ndisc.c:739
        neigh_probe+0xd0/0x120 net/core/neighbour.c:1012
        __neigh_event_send+0x3e3/0x17c0 net/core/neighbour.c:1172
        neigh_event_send include/net/neighbour.h:445 [inline]
        neigh_resolve_output+0x5ee/0x990 net/core/neighbour.c:1474
        neigh_output include/net/neighbour.h:511 [inline]
        ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
        __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
        ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
        NF_HOOK_COND include/linux/netfilter.h:296 [inline]
        ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
        dst_output include/net/dst.h:436 [inline]
        ip6_local_out+0xbb/0x1b0 net/ipv6/output_core.c:179
        ip6_send_skb+0xbb/0x350 net/ipv6/ip6_output.c:1795
        ip6_push_pending_frames+0xc8/0xf0 net/ipv6/ip6_output.c:1815
        icmpv6_push_pending_frames+0x34b/0x540 net/ipv6/icmp.c:285
        icmp6_send+0x1a7f/0x1f90 net/ipv6/icmp.c:598
        icmpv6_send+0xec/0x220 net/ipv6/ip6_icmp.c:43
        ip6_link_failure+0x2b/0x530 net/ipv6/route.c:2641
        dst_link_failure include/net/dst.h:419 [inline]
        ip_tunnel_xmit+0x1738/0x2d0c net/ipv4/ip_tunnel.c:824
        __gre_xmit+0x5e9/0x9a0 net/ipv4/ip_gre.c:448
        erspan_xmit+0x912/0x28f0 net/ipv4/ip_gre.c:683
        __netdev_start_xmit include/linux/netdevice.h:4442 [inline]
        netdev_start_xmit include/linux/netdevice.h:4456 [inline]
        xmit_one net/core/dev.c:3420 [inline]
        dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3436
        sch_direct_xmit+0x372/0xd30 net/sched/sch_generic.c:313
        __dev_xmit_skb net/core/dev.c:3660 [inline]
        __dev_queue_xmit+0x1cc9/0x35c0 net/core/dev.c:3982
        dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
        neigh_resolve_output net/core/neighbour.c:1490 [inline]
        neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
        neigh_output include/net/neighbour.h:511 [inline]
        ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
        __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
        ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
        NF_HOOK_COND include/linux/netfilter.h:296 [inline]
        ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
        dst_output include/net/dst.h:436 [inline]
        NF_HOOK include/linux/netfilter.h:307 [inline]
        rawv6_send_hdrinc net/ipv6/raw.c:687 [inline]
        rawv6_sendmsg+0x203b/0x3860 net/ipv6/raw.c:944
        inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
        sock_sendmsg_nosec net/socket.c:639 [inline]
        sock_sendmsg+0xd7/0x130 net/socket.c:659
        sock_write_iter+0x27c/0x3e0 net/socket.c:991
        call_write_iter include/linux/fs.h:1902 [inline]
        aio_write+0x2f2/0x540 fs/aio.c:1580
        __io_submit_one fs/aio.c:1812 [inline]
        io_submit_one+0xfbd/0x2ec0 fs/aio.c:1859
        __do_sys_io_submit fs/aio.c:1918 [inline]
        __se_sys_io_submit fs/aio.c:1888 [inline]
        __x64_sys_io_submit+0x1bd/0x540 fs/aio.c:1888
        do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&dev->qdisc_xmit_lock_key#312);
                                lock(&dev->qdisc_tx_busylock_key#71);
                                lock(&dev->qdisc_xmit_lock_key#312);
   lock(&dev->qdisc_tx_busylock_key#71);

  *** DEADLOCK ***

12 locks held by syz-executor.3/2879:
  #0: ffffffff891ad880 (rcu_read_lock){....}, at: l3mdev_l3_out  
include/net/l3mdev.h:179 [inline]
  #0: ffffffff891ad880 (rcu_read_lock){....}, at: l3mdev_ip6_out  
include/net/l3mdev.h:200 [inline]
  #0: ffffffff891ad880 (rcu_read_lock){....}, at: rawv6_send_hdrinc  
net/ipv6/raw.c:677 [inline]
  #0: ffffffff891ad880 (rcu_read_lock){....}, at:  
rawv6_sendmsg+0x1e28/0x3860 net/ipv6/raw.c:944
  #1: ffffffff891ad840 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #1: ffffffff891ad840 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #2: ffffffff891ad840 (rcu_read_lock_bh){....}, at:  
__dev_queue_xmit+0x20a/0x35c0 net/core/dev.c:3948
  #3: ffff88809435b138 (&dev->qdisc_running_key#128){+...}, at:  
dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  #4: ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at: spin_lock  
include/linux/spinlock.h:338 [inline]
  #4: ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at:  
__netif_tx_lock include/linux/netdevice.h:3929 [inline]
  #4: ffff8880a9b9cc98 (&dev->qdisc_xmit_lock_key#312){+.-.}, at:  
sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311
  #5: ffffffff891ad880 (rcu_read_lock){....}, at: icmpv6_send+0x0/0x220  
net/ipv6/ip6_icmp.c:31
  #6: ffff88806e2194e0 (k-slock-AF_INET6){+.-.}, at: spin_trylock  
include/linux/spinlock.h:348 [inline]
  #6: ffff88806e2194e0 (k-slock-AF_INET6){+.-.}, at: icmpv6_xmit_lock  
net/ipv6/icmp.c:117 [inline]
  #6: ffff88806e2194e0 (k-slock-AF_INET6){+.-.}, at: icmp6_send+0xde8/0x1f90  
net/ipv6/icmp.c:519
  #7: ffffffff891ad880 (rcu_read_lock){....}, at: icmp6_send+0x13cd/0x1f90  
net/ipv6/icmp.c:579
  #8: ffffffff891ad840 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #8: ffffffff891ad840 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #9: ffffffff891ad880 (rcu_read_lock){....}, at: ip6_nd_hdr  
net/ipv6/ndisc.c:463 [inline]
  #9: ffffffff891ad880 (rcu_read_lock){....}, at:  
ndisc_send_skb+0x7fe/0x1490 net/ipv6/ndisc.c:499
  #10: ffffffff891ad840 (rcu_read_lock_bh){....}, at: lwtunnel_xmit_redirect  
include/net/lwtunnel.h:92 [inline]
  #10: ffffffff891ad840 (rcu_read_lock_bh){....}, at:  
ip6_finish_output2+0x214/0x25c0 net/ipv6/ip6_output.c:102
  #11: ffffffff891ad840 (rcu_read_lock_bh){....}, at:  
__dev_queue_xmit+0x20a/0x35c0 net/core/dev.c:3948

stack backtrace:
CPU: 0 PID: 2879 Comm: syz-executor.3 Not tainted  
5.4.0-next-20191129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1685
  check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1809
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  __dev_xmit_skb net/core/dev.c:3644 [inline]
  __dev_queue_xmit+0x2dce/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  ndisc_send_skb+0xf1f/0x1490 net/ipv6/ndisc.c:505
  ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:647
  ndisc_solicit+0x2ed/0x470 net/ipv6/ndisc.c:739
  neigh_probe+0xd0/0x120 net/core/neighbour.c:1012
  __neigh_event_send+0x3e3/0x17c0 net/core/neighbour.c:1172
  neigh_event_send include/net/neighbour.h:445 [inline]
  neigh_resolve_output+0x5ee/0x990 net/core/neighbour.c:1474
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  ip6_local_out+0xbb/0x1b0 net/ipv6/output_core.c:179
  ip6_send_skb+0xbb/0x350 net/ipv6/ip6_output.c:1795
  ip6_push_pending_frames+0xc8/0xf0 net/ipv6/ip6_output.c:1815
  icmpv6_push_pending_frames+0x34b/0x540 net/ipv6/icmp.c:285
  icmp6_send+0x1a7f/0x1f90 net/ipv6/icmp.c:598
  icmpv6_send+0xec/0x220 net/ipv6/ip6_icmp.c:43
  ip6_link_failure+0x2b/0x530 net/ipv6/route.c:2641
  dst_link_failure include/net/dst.h:419 [inline]
  ip_tunnel_xmit+0x1738/0x2d0c net/ipv4/ip_tunnel.c:824
  __gre_xmit+0x5e9/0x9a0 net/ipv4/ip_gre.c:448
  erspan_xmit+0x912/0x28f0 net/ipv4/ip_gre.c:683
  __netdev_start_xmit include/linux/netdevice.h:4442 [inline]
  netdev_start_xmit include/linux/netdevice.h:4456 [inline]
  xmit_one net/core/dev.c:3420 [inline]
  dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3436
  sch_direct_xmit+0x372/0xd30 net/sched/sch_generic.c:313
  __dev_xmit_skb net/core/dev.c:3660 [inline]
  __dev_queue_xmit+0x1cc9/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  rawv6_send_hdrinc net/ipv6/raw.c:687 [inline]
  rawv6_sendmsg+0x203b/0x3860 net/ipv6/raw.c:944
  inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  sock_write_iter+0x27c/0x3e0 net/socket.c:991
  call_write_iter include/linux/fs.h:1902 [inline]
  aio_write+0x2f2/0x540 fs/aio.c:1580
  __io_submit_one fs/aio.c:1812 [inline]
  io_submit_one+0xfbd/0x2ec0 fs/aio.c:1859
  __do_sys_io_submit fs/aio.c:1918 [inline]
  __se_sys_io_submit fs/aio.c:1888 [inline]
  __x64_sys_io_submit+0x1bd/0x540 fs/aio.c:1888
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fbd60c44c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a679
RDX: 0000000020356ff0 RSI: 0000000000000001 RDI: 00007fbd60c24000
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbd60c456d4
R13: 00000000004c1d83 R14: 00000000004d6060 R15: 00000000ffffffff
syz-executor.3 (2879) used greatest stack depth: 20000 bytes left


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
