Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A978326C00D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIPJCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:02:40 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:48874 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgIPJCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 05:02:22 -0400
Received: by mail-il1-f205.google.com with SMTP id v16so5021153ilh.15
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 02:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JDWpp59qrceGjiK2sx6esLeJTjLog9XQAuQqSBQuTzI=;
        b=BMi72U08S0QMRyfa8S72RH5bIbM66Pu69d5I5atjCKO9mpdQt98OkYzVn1rme6d2QY
         jzLZCEoGPFpTVQgHKFE1EiyMVb8/+vQ5uNZ1ckO81g4oY7/Kyql0lCSZkaYX/t6HXibj
         At2iVWTSoHzlwzuP7JYBkd71UCL/n0VoQfEMhhXrmraS7n4lVARvdnfRcyBcuBHqB2dY
         cY8XNwXqDszrEzuoQ5TC4aBQLbMOKLiErY3uckGr/Iaqo7+5EkgrVe0qdeG5oGtYYgds
         T+OS7qRSuRjYFo2E3DmV+e+ZL7zNoMD3dgaGcb+hSE3U8q9HbCOY4NPL3v2yqwIjYrRJ
         LPBQ==
X-Gm-Message-State: AOAM532IgVnRSlYzGxmc9YKCDVAie9OgcPC7m7+/pQdSNvAI3rn2frkX
        C2yatXKcrcitKy3ZOPyuBzM2Wo60o5PmQ00H5DesX9YVlsYg
X-Google-Smtp-Source: ABdhPJyZi97mrMfNRmqs9NwHMvujl/+uLTzfJmfOdDblNsVAUXPJxeeyNv/zKLq9XdZnQr3HZ/0mJ6ZfA1zYzsXU28zadTLzOCt/
MIME-Version: 1.0
X-Received: by 2002:a05:6638:cdc:: with SMTP id e28mr21510076jak.100.1600246940962;
 Wed, 16 Sep 2020 02:02:20 -0700 (PDT)
Date:   Wed, 16 Sep 2020 02:02:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007815da05af6a86f3@google.com>
Subject: WARNING: SOFTIRQ-READ-safe -> SOFTIRQ-READ-unsafe lock order detected
From:   syzbot <syzbot+9b6f24d0e72fbed27319@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6b02addb Add linux-next specific files for 20200915
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1148b901900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7086d0e9e44d4a14
dashboard link: https://syzkaller.appspot.com/bug?extid=9b6f24d0e72fbed27319
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b6f24d0e72fbed27319@syzkaller.appspotmail.com

=====================================================
WARNING: SOFTIRQ-READ-safe -> SOFTIRQ-READ-unsafe lock order detected
5.9.0-rc5-next-20200915-syzkaller #0 Not tainted
-----------------------------------------------------
kworker/0:17/14303 [HC0[0]:SC0[2]:HE1:SE0] is trying to acquire:
ffff88809ff56128 (&s->seqcount#11){+.+.}-{0:0}, at: xfrm_policy_inexact_insert+0xb9/0xbb0 net/xfrm/xfrm_policy.c:1189

and this task is already holding:
ffffffff8ae7a108 (&s->seqcount#12){+..-}-{0:0}, at: process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
which would create a new lock dependency:
 (&s->seqcount#12){+..-}-{0:0} -> (&s->seqcount#11){+.+.}-{0:0}

but this new dependency connects a SOFTIRQ-READ-irq-safe lock:
 (&s->seqcount#12){+..-}-{0:0}

... which became SOFTIRQ-READ-irq-safe at:
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
  xfrm_policy_lookup_bytype+0x183/0xa40 net/xfrm/xfrm_policy.c:2088
  xfrm_policy_lookup net/xfrm/xfrm_policy.c:2139 [inline]
  __xfrm_policy_check+0xb53/0x2650 net/xfrm/xfrm_policy.c:3572
  __xfrm_policy_check2 include/net/xfrm.h:1097 [inline]
  xfrm_policy_check include/net/xfrm.h:1106 [inline]
  xfrm6_policy_check include/net/xfrm.h:1116 [inline]
  udpv6_queue_rcv_one_skb+0x570/0x15c0 net/ipv6/udp.c:660
  udpv6_queue_rcv_skb net/ipv6/udp.c:744 [inline]
  udp6_unicast_rcv_skb+0x259/0x490 net/ipv6/udp.c:886
  __udp6_lib_rcv+0xb35/0x2750 net/ipv6/udp.c:970
  ip6_protocol_deliver_rcu+0x2e8/0x1660 net/ipv6/ip6_input.c:433
  ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
  NF_HOOK include/linux/netfilter.h:301 [inline]
  NF_HOOK include/linux/netfilter.h:295 [inline]
  ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
  dst_input include/net/dst.h:449 [inline]
  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  NF_HOOK include/linux/netfilter.h:295 [inline]
  ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
  __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
  process_backlog+0x2e1/0x8e0 net/core/dev.c:6286
  napi_poll net/core/dev.c:6730 [inline]
  net_rx_action+0x572/0x1300 net/core/dev.c:6800
  __do_softirq+0x202/0xa42 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  do_softirq kernel/softirq.c:343 [inline]
  do_softirq+0x154/0x1b0 kernel/softirq.c:330
  __local_bh_enable_ip+0x196/0x1f0 kernel/softirq.c:195
  wg_socket_send_skb_to_peer+0x14b/0x220 drivers/net/wireguard/socket.c:183
  wg_packet_create_data_done drivers/net/wireguard/send.c:252 [inline]
  wg_packet_tx_worker+0x2f9/0x980 drivers/net/wireguard/send.c:280
  process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
  kthread+0x3af/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

to a SOFTIRQ-READ-irq-unsafe lock:
 (&s->seqcount#11){+.+.}-{0:0}

... which became SOFTIRQ-READ-irq-unsafe at:
...
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
  write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
  write_seqlock include/linux/seqlock.h:883 [inline]
  xfrm_set_spdinfo+0x302/0x660 net/xfrm/xfrm_user.c:1185
  xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2684
  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2692
  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:671
  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
  ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->seqcount#11);
                               local_irq_disable();
                               lock(&s->seqcount#12);
                               lock(&s->seqcount#11);
  <Interrupt>
    lock(&s->seqcount#12);

 *** DEADLOCK ***

5 locks held by kworker/0:17/14303:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2240
 #1: ffffc90008a3fda8 ((work_completion)(&net->xfrm.policy_hthresh.work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2244
 #2: ffffffff8abc5f08 (hash_resize_mutex){+.+.}-{3:3}, at: xfrm_hash_rebuild+0x54/0x1110 net/xfrm/xfrm_policy.c:1225
 #3: ffff8880a6b45a18 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #3: ffff8880a6b45a18 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: xfrm_hash_rebuild+0x1e4/0x1110 net/xfrm/xfrm_policy.c:1237
 #4: ffffffff8ae7a108 (&s->seqcount#12){+..-}-{0:0}, at: process_one_work+0x933/0x15a0 kernel/workqueue.c:2269

the dependencies between SOFTIRQ-READ-irq-safe lock and the holding lock:
-> (&s->seqcount#12){+..-}-{0:0} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
                    write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
                    xfrm_hash_rebuild+0x261/0x1110 net/xfrm/xfrm_policy.c:1238
                    process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
                    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
                    kthread+0x3af/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   IN-SOFTIRQ-R at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
                    xfrm_policy_lookup_bytype+0x183/0xa40 net/xfrm/xfrm_policy.c:2088
                    xfrm_policy_lookup net/xfrm/xfrm_policy.c:2139 [inline]
                    __xfrm_policy_check+0xb53/0x2650 net/xfrm/xfrm_policy.c:3572
                    __xfrm_policy_check2 include/net/xfrm.h:1097 [inline]
                    xfrm_policy_check include/net/xfrm.h:1106 [inline]
                    xfrm6_policy_check include/net/xfrm.h:1116 [inline]
                    udpv6_queue_rcv_one_skb+0x570/0x15c0 net/ipv6/udp.c:660
                    udpv6_queue_rcv_skb net/ipv6/udp.c:744 [inline]
                    udp6_unicast_rcv_skb+0x259/0x490 net/ipv6/udp.c:886
                    __udp6_lib_rcv+0xb35/0x2750 net/ipv6/udp.c:970
                    ip6_protocol_deliver_rcu+0x2e8/0x1660 net/ipv6/ip6_input.c:433
                    ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
                    NF_HOOK include/linux/netfilter.h:301 [inline]
                    NF_HOOK include/linux/netfilter.h:295 [inline]
                    ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
                    dst_input include/net/dst.h:449 [inline]
                    ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
                    NF_HOOK include/linux/netfilter.h:301 [inline]
                    NF_HOOK include/linux/netfilter.h:295 [inline]
                    ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
                    __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
                    __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
                    process_backlog+0x2e1/0x8e0 net/core/dev.c:6286
                    napi_poll net/core/dev.c:6730 [inline]
                    net_rx_action+0x572/0x1300 net/core/dev.c:6800
                    __do_softirq+0x202/0xa42 kernel/softirq.c:298
                    asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
                    __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
                    run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
                    do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
                    do_softirq kernel/softirq.c:343 [inline]
                    do_softirq+0x154/0x1b0 kernel/softirq.c:330
                    __local_bh_enable_ip+0x196/0x1f0 kernel/softirq.c:195
                    wg_socket_send_skb_to_peer+0x14b/0x220 drivers/net/wireguard/socket.c:183
                    wg_packet_create_data_done drivers/net/wireguard/send.c:252 [inline]
                    wg_packet_tx_worker+0x2f9/0x980 drivers/net/wireguard/send.c:280
                    process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
                    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
                    kthread+0x3af/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   INITIAL USE at:
                   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                   seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
                   xfrm_policy_lookup_bytype+0x183/0xa40 net/xfrm/xfrm_policy.c:2088
                   xfrm_policy_lookup net/xfrm/xfrm_policy.c:2139 [inline]
                   __xfrm_policy_check+0xb53/0x2650 net/xfrm/xfrm_policy.c:3572
                   __xfrm_policy_check2 include/net/xfrm.h:1097 [inline]
                   xfrm_policy_check include/net/xfrm.h:1106 [inline]
                   xfrm6_policy_check include/net/xfrm.h:1116 [inline]
                   udpv6_queue_rcv_one_skb+0x570/0x15c0 net/ipv6/udp.c:660
                   udpv6_queue_rcv_skb net/ipv6/udp.c:744 [inline]
                   udp6_unicast_rcv_skb+0x259/0x490 net/ipv6/udp.c:886
                   __udp6_lib_rcv+0xb35/0x2750 net/ipv6/udp.c:970
                   ip6_protocol_deliver_rcu+0x2e8/0x1660 net/ipv6/ip6_input.c:433
                   ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
                   NF_HOOK include/linux/netfilter.h:301 [inline]
                   NF_HOOK include/linux/netfilter.h:295 [inline]
                   ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
                   dst_input include/net/dst.h:449 [inline]
                   ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
                   NF_HOOK include/linux/netfilter.h:301 [inline]
                   NF_HOOK include/linux/netfilter.h:295 [inline]
                   ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
                   __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
                   __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
                   process_backlog+0x2e1/0x8e0 net/core/dev.c:6286
                   napi_poll net/core/dev.c:6730 [inline]
                   net_rx_action+0x572/0x1300 net/core/dev.c:6800
                   __do_softirq+0x202/0xa42 kernel/softirq.c:298
                   asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
                   __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
                   run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
                   do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
                   do_softirq kernel/softirq.c:343 [inline]
                   do_softirq+0x154/0x1b0 kernel/softirq.c:330
                   __local_bh_enable_ip+0x196/0x1f0 kernel/softirq.c:195
                   wg_socket_send_skb_to_peer+0x14b/0x220 drivers/net/wireguard/socket.c:183
                   wg_packet_create_data_done drivers/net/wireguard/send.c:252 [inline]
                   wg_packet_tx_worker+0x2f9/0x980 drivers/net/wireguard/send.c:280
                   process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
                   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
                   kthread+0x3af/0x4a0 kernel/kthread.c:292
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   (null) at:
general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 14303 Comm: kworker/0:17 Not tainted 5.9.0-rc5-next-20200915-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events xfrm_hash_rebuild
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 b1 21 d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90008a3f6e8 EFLAGS: 00010002
RAX: 000000000000000c RBX: ffffc90008a3f840 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff815c26a7 RDI: 0000000000000020
RBP: ffffc90008a3f840 R08: 0000000000000004 R09: ffff8880ae620f8b
R10: 0000000000000000 R11: 6c6c756e28202020 R12: dffffc0000000000
R13: ffffffff8ca46f40 R14: 0000000000000009 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000744138 CR3: 000000004e370000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 print_bad_irq_dependency kernel/locking/lockdep.c:2395 [inline]
 check_irq_usage.cold+0x42d/0x5b0 kernel/locking/lockdep.c:2634
 check_prev_add kernel/locking/lockdep.c:2823 [inline]
 check_prevs_add kernel/locking/lockdep.c:2944 [inline]
 validate_chain kernel/locking/lockdep.c:3562 [inline]
 __lock_acquire+0x2800/0x55d0 kernel/locking/lockdep.c:4796
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
 write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
 xfrm_policy_inexact_alloc_chain.isra.0+0x3c6/0x9b0 net/xfrm/xfrm_policy.c:1145
 xfrm_policy_inexact_insert+0xb9/0xbb0 net/xfrm/xfrm_policy.c:1189
 xfrm_hash_rebuild+0xdca/0x1110 net/xfrm/xfrm_policy.c:1327
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Modules linked in:
---[ end trace fb36ab3ee2fc8525 ]---
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 b1 21 d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc90008a3f6e8 EFLAGS: 00010002
RAX: 000000000000000c RBX: ffffc90008a3f840 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff815c26a7 RDI: 0000000000000020
RBP: ffffc90008a3f840 R08: 0000000000000004 R09: ffff8880ae620f8b
R10: 0000000000000000 R11: 6c6c756e28202020 R12: dffffc0000000000
R13: ffffffff8ca46f40 R14: 0000000000000009 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000744138 CR3: 000000004e370000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
