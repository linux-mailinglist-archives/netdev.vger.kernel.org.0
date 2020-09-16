Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65526BFD6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgIPIvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:51:24 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:35836 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPIvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:51:16 -0400
Received: by mail-il1-f207.google.com with SMTP id e16so5031694ilq.2
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JoOJcmxR+5JnUyTSynVCwlLkR/R0ZGglImbIlAMAtWI=;
        b=g8JwD+XfeGCPY9Uqikii9j0lBG/AgK7I3PCumiSx2YUhYzDSoCYJFqCeIkpRVT23q2
         va3SE23hzE3z0h6iwm0kdhn+vurIpjr68KgKn7RH+1xWYRCTrJg4uAhKixqt1DEMpG5i
         AW9GjlEe5PGSxrqKgBWn79+F+1G9Ps6rA4X+glH2p7UlHgMn/mwMZSXjn2+C1vQkR31J
         RRnDsrChyBs7kXeLnbOWNjt2UOhu3cc7RbmfQXXThdlnd1p/klXqP/2szmVyzYzpjqxW
         UI96rNqtCiHzZVyzRi4ZKuXqH5lxTByAUVSEOR/cEGzJmtXnv4bR6shOaJhP1r2o7LoY
         fXGw==
X-Gm-Message-State: AOAM533JxxD53m8QBfvLA68W9PceKNipsr6ztSqLyK35aSeJXPXl7Kc3
        anK+SB/TwRioZnkXsdk3h4c8Wz0N6hmKehWh43XrfZzXH5X7
X-Google-Smtp-Source: ABdhPJzwZGPUX4OQE6rjzkASQuxG9t0uaBZy0DdPxVWTeQYi4FKoNa2kaMm3UTeMDeU4KHfI2sU2oP2OheyCcf/AMISSBn7UrmD2
MIME-Version: 1.0
X-Received: by 2002:a6b:5a0d:: with SMTP id o13mr18547257iob.186.1600246274955;
 Wed, 16 Sep 2020 01:51:14 -0700 (PDT)
Date:   Wed, 16 Sep 2020 01:51:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c59e2c05af6a5e7e@google.com>
Subject: inconsistent lock state in xfrm_policy_lookup_inexact_addr
From:   syzbot <syzbot+f4d0f0f7c860608404c4@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=15888efd900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7086d0e9e44d4a14
dashboard link: https://syzkaller.appspot.com/bug?extid=f4d0f0f7c860608404c4
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4d0f0f7c860608404c4@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc5-next-20200915-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
kworker/1:1/23 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffff8880a6ff5f28 (&s->seqcount#12){+.+-}-{0:0}, at: xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
{SOFTIRQ-ON-W} state was registered at:
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
irq event stamp: 2041637
hardirqs last  enabled at (2041636): [<ffffffff86c293ab>] seqcount_lockdep_reader_access+0x14b/0x1a0 include/linux/seqlock.h:105
hardirqs last disabled at (2041637): [<ffffffff86c2937b>] seqcount_lockdep_reader_access+0x11b/0x1a0 include/linux/seqlock.h:102
softirqs last  enabled at (2041616): [<ffffffff84b3745b>] wg_socket_send_skb_to_peer+0x14b/0x220 drivers/net/wireguard/socket.c:183
softirqs last disabled at (2041617): [<ffffffff88200f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&s->seqcount#12);
  <Interrupt>
    lock(&s->seqcount#12);

 *** DEADLOCK ***

5 locks held by kworker/1:1/23:
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88809dff9938 ((wq_completion)wg-crypt-wg0#5){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2240
 #1: ffffc90000df7da8 ((work_completion)(&queue->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2244
 #2: ffffffff89e71c80 (rcu_read_lock){....}-{1:2}, at: __skb_unlink include/linux/skbuff.h:2067 [inline]
 #2: ffffffff89e71c80 (rcu_read_lock){....}-{1:2}, at: __skb_dequeue include/linux/skbuff.h:2082 [inline]
 #2: ffffffff89e71c80 (rcu_read_lock){....}-{1:2}, at: process_backlog+0x270/0x8e0 net/core/dev.c:6284
 #3: ffffffff89e71c80 (rcu_read_lock){....}-{1:2}, at: ip6_input_finish+0x0/0x160 net/ipv6/ip6_input.c:453
 #4: ffffffff89e71c80 (rcu_read_lock){....}-{1:2}, at: xfrm_policy_lookup_bytype+0x104/0xa40 net/xfrm/xfrm_policy.c:2082

stack backtrace:
CPU: 1 PID: 23 Comm: kworker/1:1 Not tainted 5.9.0-rc5-next-20200915-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:3694 [inline]
 valid_state kernel/locking/lockdep.c:3705 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3908 [inline]
 mark_lock.cold+0x13/0x10d kernel/locking/lockdep.c:4375
 mark_usage kernel/locking/lockdep.c:4252 [inline]
 __lock_acquire+0x1402/0x55d0 kernel/locking/lockdep.c:4750
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
 xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
 xfrm_policy_find_inexact_candidates+0xac/0x1d0 net/xfrm/xfrm_policy.c:1953
 xfrm_policy_lookup_bytype+0x4b8/0xa40 net/xfrm/xfrm_policy.c:2108
 xfrm_policy_lookup net/xfrm/xfrm_policy.c:2144 [inline]
 __xfrm_policy_check+0x110e/0x2650 net/xfrm/xfrm_policy.c:3572
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
 </IRQ>
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


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
