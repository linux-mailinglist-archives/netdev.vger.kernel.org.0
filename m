Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC022717D3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 22:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgITUWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 16:22:17 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:43031 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgITUWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 16:22:17 -0400
Received: by mail-io1-f78.google.com with SMTP id b73so8601167iof.10
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 13:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BYLuIp03AvPTwF1e//sj+jmkCFF30ZpgsoUeBxsGgtI=;
        b=fPcu5YyYWVnneHPlB2RnC3aMLELWJPqaoCC3hJ3+jPqd5jvjtspAbVgODrLSRH2XHJ
         XwhW4I7cw7XD+/jRSIBuKz5BQ/2uZkBBGk3aGBpTprQWJNNqrQDs5WgoVCd9lwYVEVFh
         uUOiACcIH25gzSre4AQVyH2itNmhYV81Yjn1kpj6/oui4ZegWQ8yqvL5WVSTHOlvY7V2
         pYp4HefuvDuWh8REnlQCG9nSiO2qUb6vl0CN+FVJEl8L3nyzWbKwY/oblwfj4bZLDEBu
         k3KjSFvqwcYDxnMZXuTBSod05Y8e4pG5eY5fMcsG3piJotfsXGs9vffPXQJb5f6ziUhC
         YV2g==
X-Gm-Message-State: AOAM530Hj0RSgeKNGwM/rueilZHgQ+7sViHpXaFpnlo+RWae7x/NSey+
        2+yj9vxLM5r0vDHBi/fIpt+JSCVXEnJu10nKmeFD2sEw5jLF
X-Google-Smtp-Source: ABdhPJxsiFb3i/SdqaGy/bdE+Ab4EbN3XnfGpIL/bqXu7m5jqYvDJJ7HnAme+0wNgw1ex+08jOZdSgmbMOekREj0X2FuLzOkuyEw
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6a6:: with SMTP id d6mr37464410jad.67.1600633334839;
 Sun, 20 Sep 2020 13:22:14 -0700 (PDT)
Date:   Sun, 20 Sep 2020 13:22:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056c1dc05afc47ddb@google.com>
Subject: possible deadlock in xfrm_policy_delete
From:   syzbot <syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5fa35f24 Add linux-next specific files for 20200916
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1122e2d9900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bdb7e39caf48f53
dashboard link: https://syzkaller.appspot.com/bug?extid=c32502fd255cb3a44048
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com

=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
5.9.0-rc5-next-20200916-syzkaller #0 Not tainted
-----------------------------------------------------
syz-executor.1/13775 [HC0[0]:SC0[4]:HE1:SE0] is trying to acquire:
ffff88805ee15a58 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
ffff88805ee15a58 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: xfrm_policy_delete+0x3a/0x90 net/xfrm/xfrm_policy.c:2236

and this task is already holding:
ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: tcp_close+0x6e3/0x1200 net/ipv4/tcp.c:2503
which would create a new lock dependency:
 (k-slock-AF_INET6){+.-.}-{2:2} -> (&net->xfrm.xfrm_policy_lock){+...}-{2:2}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (k-slock-AF_INET6){+.-.}-{2:2}

... which became SOFTIRQ-irq-safe at:
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  sctp_rcv+0xd96/0x2d50 net/sctp/input.c:231
  sctp6_rcv+0x12/0x30 net/sctp/ipv6.c:1056
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
  local_bh_enable include/linux/bottom_half.h:32 [inline]
  rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
  ip6_finish_output2+0x953/0x1770 net/ipv6/ip6_output.c:118
  __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
  __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
  ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
  ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
  dst_output include/net/dst.h:443 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  NF_HOOK include/linux/netfilter.h:295 [inline]
  ip6_xmit+0x1258/0x1e80 net/ipv6/ip6_output.c:280
  sctp_v6_xmit+0x339/0x650 net/sctp/ipv6.c:217
  sctp_packet_transmit+0x20d7/0x3240 net/sctp/output.c:629
  sctp_packet_singleton net/sctp/outqueue.c:773 [inline]
  sctp_outq_flush_ctrl.constprop.0+0x6d3/0xc40 net/sctp/outqueue.c:904
  sctp_outq_flush+0xfb/0x2380 net/sctp/outqueue.c:1186
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
  sctp_do_sm+0x4d0/0x4d80 net/sctp/sm_sideeffect.c:1156
  sctp_primitive_ASSOCIATE+0x98/0xc0 net/sctp/primitive.c:73
  __sctp_connect+0x9a7/0xc00 net/sctp/socket.c:1217
  __sctp_setsockopt_connectx net/sctp/socket.c:1319 [inline]
  __sctp_setsockopt_connectx+0xfa/0x140 net/sctp/socket.c:1294
  sctp_setsockopt_connectx_old net/sctp/socket.c:1330 [inline]
  sctp_setsockopt+0x1b69/0x97f0 net/sctp/socket.c:4482
  __sys_setsockopt+0x2db/0x610 net/socket.c:2132
  __do_sys_setsockopt net/socket.c:2143 [inline]
  __se_sys_setsockopt net/socket.c:2140 [inline]
  __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

to a SOFTIRQ-irq-unsafe lock:
 (&s->seqcount#12){+.+.}-{0:0}

... which became SOFTIRQ-irq-unsafe at:
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

Chain exists of:
  k-slock-AF_INET6 --> &net->xfrm.xfrm_policy_lock --> &s->seqcount#12

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->seqcount#12);
                               local_irq_disable();
                               lock(k-slock-AF_INET6);
                               lock(&net->xfrm.xfrm_policy_lock);
  <Interrupt>
    lock(k-slock-AF_INET6);

 *** DEADLOCK ***

4 locks held by syz-executor.1/13775:
 #0: ffff888056c2dc90 (&sb->s_type->i_mutex_key#12){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:782 [inline]
 #0: ffff888056c2dc90 (&sb->s_type->i_mutex_key#12){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:595
 #1: ffff8880535efd78 (&smc->clcsock_release_lock){+.+.}-{3:3}, at: smc_clcsock_release+0x71/0xe0 net/smc/smc_close.c:30
 #2: ffff8880a811b260 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1581 [inline]
 #2: ffff8880a811b260 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_close+0x25/0x1200 net/ipv4/tcp.c:2413
 #3: ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #3: ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: tcp_close+0x6e3/0x1200 net/ipv4/tcp.c:2503

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (k-slock-AF_INET6){+.-.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                    _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                    spin_lock_bh include/linux/spinlock.h:359 [inline]
                    lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
                    lock_sock include/net/sock.h:1581 [inline]
                    tcp_sock_set_nodelay+0x18/0xe0 net/ipv4/tcp.c:2916
                    rds_tcp_listen_init+0x132/0x4d0 net/rds/tcp_listen.c:275
                    rds_tcp_init_net+0x265/0x4e0 net/rds/tcp.c:559
                    ops_init+0xaf/0x470 net/core/net_namespace.c:151
                    __register_pernet_operations net/core/net_namespace.c:1140 [inline]
                    register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1217
                    register_pernet_device+0x26/0x70 net/core/net_namespace.c:1304
                    rds_tcp_init+0x77/0xe0 net/rds/tcp.c:717
                    do_one_initcall+0x103/0x6f0 init/main.c:1204
                    do_initcall_level init/main.c:1277 [inline]
                    do_initcalls init/main.c:1293 [inline]
                    do_basic_setup init/main.c:1313 [inline]
                    kernel_init_freeable+0x5e9/0x66d init/main.c:1512
                    kernel_init+0xd/0x1c0 init/main.c:1402
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
   IN-SOFTIRQ-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:354 [inline]
                    sctp_rcv+0xd96/0x2d50 net/sctp/input.c:231
                    sctp6_rcv+0x12/0x30 net/sctp/ipv6.c:1056
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
                    local_bh_enable include/linux/bottom_half.h:32 [inline]
                    rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
                    ip6_finish_output2+0x953/0x1770 net/ipv6/ip6_output.c:118
                    __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
                    __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
                    ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
                    NF_HOOK_COND include/linux/netfilter.h:290 [inline]
                    ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
                    dst_output include/net/dst.h:443 [inline]
                    NF_HOOK include/linux/netfilter.h:301 [inline]
                    NF_HOOK include/linux/netfilter.h:295 [inline]
                    ip6_xmit+0x1258/0x1e80 net/ipv6/ip6_output.c:280
                    sctp_v6_xmit+0x339/0x650 net/sctp/ipv6.c:217
                    sctp_packet_transmit+0x20d7/0x3240 net/sctp/output.c:629
                    sctp_packet_singleton net/sctp/outqueue.c:773 [inline]
                    sctp_outq_flush_ctrl.constprop.0+0x6d3/0xc40 net/sctp/outqueue.c:904
                    sctp_outq_flush+0xfb/0x2380 net/sctp/outqueue.c:1186
                    sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1801 [inline]
                    sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
                    sctp_do_sm+0x4d0/0x4d80 net/sctp/sm_sideeffect.c:1156
                    sctp_primitive_ASSOCIATE+0x98/0xc0 net/sctp/primitive.c:73
                    __sctp_connect+0x9a7/0xc00 net/sctp/socket.c:1217
                    __sctp_setsockopt_connectx net/sctp/socket.c:1319 [inline]
                    __sctp_setsockopt_connectx+0xfa/0x140 net/sctp/socket.c:1294
                    sctp_setsockopt_connectx_old net/sctp/socket.c:1330 [inline]
                    sctp_setsockopt+0x1b69/0x97f0 net/sctp/socket.c:4482
                    __sys_setsockopt+0x2db/0x610 net/socket.c:2132
                    __do_sys_setsockopt net/socket.c:2143 [inline]
                    __se_sys_setsockopt net/socket.c:2140 [inline]
                    __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
                    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   INITIAL USE at:
                   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                   spin_lock_bh include/linux/spinlock.h:359 [inline]
                   lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
                   lock_sock include/net/sock.h:1581 [inline]
                   tcp_sock_set_nodelay+0x18/0xe0 net/ipv4/tcp.c:2916
                   rds_tcp_listen_init+0x132/0x4d0 net/rds/tcp_listen.c:275
                   rds_tcp_init_net+0x265/0x4e0 net/rds/tcp.c:559
                   ops_init+0xaf/0x470 net/core/net_namespace.c:151
                   __register_pernet_operations net/core/net_namespace.c:1140 [inline]
                   register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1217
                   register_pernet_device+0x26/0x70 net/core/net_namespace.c:1304
                   rds_tcp_init+0x77/0xe0 net/rds/tcp.c:717
                   do_one_initcall+0x103/0x6f0 init/main.c:1204
                   do_initcall_level init/main.c:1277 [inline]
                   do_initcalls init/main.c:1293 [inline]
                   do_basic_setup init/main.c:1313 [inline]
                   kernel_init_freeable+0x5e9/0x66d init/main.c:1512
                   kernel_init+0xd/0x1c0 init/main.c:1402
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
 }
 ... key      at: [<ffffffff8d91b7c0>] af_family_kern_slock_keys+0xa0/0x300
 ... acquired at:
   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
   spin_lock_bh include/linux/spinlock.h:359 [inline]
   xfrm_policy_delete+0x3a/0x90 net/xfrm/xfrm_policy.c:2236
   xfrm_sk_free_policy include/net/xfrm.h:1192 [inline]
   inet_csk_destroy_sock+0x35b/0x490 net/ipv4/inet_connection_sock.c:887
   tcp_close+0xdb5/0x1200 net/ipv4/tcp.c:2570
   inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
   inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
   __sock_release net/socket.c:596 [inline]
   sock_release+0x87/0x1b0 net/socket.c:624
   smc_clcsock_release+0xb3/0xe0 net/smc/smc_close.c:34
   __smc_release+0x393/0x580 net/smc/af_smc.c:164
   smc_release+0x167/0x490 net/smc/af_smc.c:199
   __sock_release+0xcd/0x280 net/socket.c:596
   sock_close+0x18/0x20 net/socket.c:1277
   __fput+0x285/0x920 fs/file_table.c:281
   task_work_run+0xdd/0x190 kernel/task_work.c:141
   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
   exit_to_user_mode_prepare+0x1e2/0x1f0 kernel/entry/common.c:190
   syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:265
   entry_SYSCALL_64_after_hwframe+0x44/0xa9


the dependencies between the lock to be acquired
 and SOFTIRQ-irq-unsafe lock:
 -> (&s->seqcount#12){+.+.}-{0:0} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                      write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
                      write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
                      __xfrm_policy_inexact_prune_bin+0xbc/0x1040 net/xfrm/xfrm_policy.c:1077
                      xfrm_policy_inexact_insert+0x48c/0xbb0 net/xfrm/xfrm_policy.c:1205
                      xfrm_policy_insert+0x4f3/0x840 net/xfrm/xfrm_policy.c:1572
                      pfkey_spdadd+0xfb1/0x1550 net/key/af_key.c:2332
                      pfkey_process+0x66d/0x7a0 net/key/af_key.c:2841
                      pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3680
                      sock_sendmsg_nosec net/socket.c:651 [inline]
                      sock_sendmsg+0xcf/0x120 net/socket.c:671
                      ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
                      ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
                      __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
                      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                      entry_SYSCALL_64_after_hwframe+0x44/0xa9
    SOFTIRQ-ON-W at:
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
    INITIAL USE at:
                     lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                     write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
                     write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
                     __xfrm_policy_inexact_prune_bin+0xbc/0x1040 net/xfrm/xfrm_policy.c:1077
                     xfrm_policy_inexact_insert+0x48c/0xbb0 net/xfrm/xfrm_policy.c:1205
                     xfrm_policy_insert+0x4f3/0x840 net/xfrm/xfrm_policy.c:1572
                     pfkey_spdadd+0xfb1/0x1550 net/key/af_key.c:2332
                     pfkey_process+0x66d/0x7a0 net/key/af_key.c:2841
                     pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3680
                     sock_sendmsg_nosec net/socket.c:651 [inline]
                     sock_sendmsg+0xcf/0x120 net/socket.c:671
                     ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
                     ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
                     __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
                     do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    (null) at:
general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 13775 Comm: syz-executor.1 Not tainted 5.9.0-rc5-next-20200916-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc900075af7c8 EFLAGS: 00010002
RAX: 000000000000000c RBX: ffffffff8cc6d360 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff815c26b7 RDI: 0000000000000020
RBP: ffffc900075af980 R08: 0000000000000004 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 6c756e2820202020 R12: dffffc0000000000
R13: ffffffff8ca37188 R14: 0000000000000009 R15: 0000000000000001
FS:  0000000002f84940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000c40 CR3: 00000000937e4000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 print_bad_irq_dependency kernel/locking/lockdep.c:2402 [inline]
 check_irq_usage.cold+0x46b/0x5b0 kernel/locking/lockdep.c:2634
 check_prev_add kernel/locking/lockdep.c:2823 [inline]
 check_prevs_add kernel/locking/lockdep.c:2944 [inline]
 validate_chain kernel/locking/lockdep.c:3562 [inline]
 __lock_acquire+0x2800/0x55d0 kernel/locking/lockdep.c:4796
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 xfrm_policy_delete+0x3a/0x90 net/xfrm/xfrm_policy.c:2236
 xfrm_sk_free_policy include/net/xfrm.h:1192 [inline]
 inet_csk_destroy_sock+0x35b/0x490 net/ipv4/inet_connection_sock.c:887
 tcp_close+0xdb5/0x1200 net/ipv4/tcp.c:2570
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release net/socket.c:596 [inline]
 sock_release+0x87/0x1b0 net/socket.c:624
 smc_clcsock_release+0xb3/0xe0 net/smc/smc_close.c:34
 __smc_release+0x393/0x580 net/smc/af_smc.c:164
 smc_release+0x167/0x490 net/smc/af_smc.c:199
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e2/0x1f0 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f41
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffe6c10fe30 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000416f41
RDX: 0000000000000000 RSI: 00000000000009bb RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000020e589bb R09: 0000000020e589bf
R10: 00007ffe6c10ff20 R11: 0000000000000293 R12: 00000000011902c8
R13: 0000000000053600 R14: ffffffffffffffff R15: 000000000118cf4c
Modules linked in:
---[ end trace 71b6ce44d53da1fe ]---
RIP: 0010:print_lock_trace kernel/locking/lockdep.c:1751 [inline]
RIP: 0010:print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
RIP: 0010:print_shortest_lock_dependencies.cold+0x110/0x2af kernel/locking/lockdep.c:2263
Code: 48 8b 04 24 48 c1 e8 03 42 80 3c 20 00 74 09 48 8b 3c 24 e8 c1 2b d9 f9 48 8b 04 24 48 8b 00 48 8d 78 14 48 89 fa 48 c1 ea 03 <42> 0f b6 0c 22 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85
RSP: 0018:ffffc900075af7c8 EFLAGS: 00010002
RAX: 000000000000000c RBX: ffffffff8cc6d360 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff815c26b7 RDI: 0000000000000020
RBP: ffffc900075af980 R08: 0000000000000004 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 6c756e2820202020 R12: dffffc0000000000
R13: ffffffff8ca37188 R14: 0000000000000009 R15: 0000000000000001
FS:  0000000002f84940(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000c40 CR3: 00000000937e4000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
