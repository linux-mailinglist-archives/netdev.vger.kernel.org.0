Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F122718B6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIUACX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:02:23 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:52630 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIUACX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 20:02:23 -0400
Received: by mail-il1-f206.google.com with SMTP id m1so9796835iln.19
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 17:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HS0K3xdS76R9AgZj0Oh3zJuLPvtOQkwKkABf3WHaO/4=;
        b=TqEF44F4F+KMOocSC24Hb3SC6yYD7HjOSMO1vSaHvB6TKgm3gYmoxasQxQ9nXN2QjY
         QTaY9vQeNw1lLq3ncHnOTkm863nbqPhhi/6JPFrY9D76IJNcq266CPpoQiMkjgbg5Rek
         ldca+I/CQmnMg6v04i6CWvWMvsXmOkdh3N3/m1UVtcVkq5NY/PFhzrXEtr4vhPb179Ms
         WOyahxu2w5Wg39X8NWkjIdr64aL3rf0IEuPMDrBOgU3fTXjSEnIQO8X25vY+UPZ8stGX
         WKSHf8CF7g77bBXcLfoptHG6ZJtqU6t4lHyuGmTrroX+p/vpEvc+Svev7XfHtegqOdo9
         Ya6Q==
X-Gm-Message-State: AOAM531MyxHroZ8n4g7J9F7Wt7eq+FGR+fv6xqWuNqPXgWI8c6E0mGMi
        z694wBjkhJzg0qaqAE3YTx/SXR8tmnFCWNMooz3xZYgxgDJF
X-Google-Smtp-Source: ABdhPJxCKArnOZIQ+LLX6CadNqL4STklksJzKsF8O0mS0/8xtE9XCyOwo/wWyaqPxWm+Tv7V+GeacPLLm4imxccMu+KOFSv/4h4F
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4ca:: with SMTP id f10mr14042002ils.139.1600646541163;
 Sun, 20 Sep 2020 17:02:21 -0700 (PDT)
Date:   Sun, 20 Sep 2020 17:02:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f44e005afc790bf@google.com>
Subject: possible deadlock in xfrm_user_rcv_msg
From:   syzbot <syzbot+537fc2e3dff863640cc1@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=141e8701900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=619bde85d9eaaed5
dashboard link: https://syzkaller.appspot.com/bug?extid=537fc2e3dff863640cc1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+537fc2e3dff863640cc1@syzkaller.appspotmail.com

========================================================
WARNING: possible irq lock inversion dependency detected
5.9.0-rc5-next-20200916-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor.1/16600 just changed the state of lock:
ffff88809ec85750
 (&s->seqcount#11){+.+.}-{0:0}, at: xfrm_user_rcv_msg+0x41e/0x720 net/xfrm/xfrm_user.c:2684
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (slock-AF_INET){+.-.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->seqcount#11);
                               local_irq_disable();
                               lock(slock-AF_INET);
                               lock(&s->seqcount#11);
  <Interrupt>
    lock(slock-AF_INET);

 *** DEADLOCK ***

2 locks held by syz-executor.1/16600:
 #0: ffff88809ec85ae8 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3}
, at: xfrm_netlink_rcv+0x5c/0x90 net/xfrm/xfrm_user.c:2691
 #1: ffff88809ec85798 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #1: ffff88809ec85798 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: write_seqlock include/linux/seqlock.h:882 [inline]
 #1: ffff88809ec85798 (&(&net->xfrm.policy_hthresh.lock)->lock){+.+.}-{2:2}, at: xfrm_set_spdinfo+0x2b8/0x660 net/xfrm/xfrm_user.c:1185

the shortest dependencies between 2nd lock and 1st lock:
 -> (
slock-AF_INET){+.-.}-{2:2} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                      __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                      _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                      spin_lock_bh include/linux/spinlock.h:359 [inline]
                      lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
                      lock_sock include/net/sock.h:1581 [inline]
                      inet_autobind+0x1a/0x190 net/ipv4/af_inet.c:180
                      inet_dgram_connect+0x245/0x2d0 net/ipv4/af_inet.c:575
                      __sys_connect_file+0x155/0x1a0 net/socket.c:1852
                      __sys_connect+0x161/0x190 net/socket.c:1869
                      __do_sys_connect net/socket.c:1879 [inline]
                      __se_sys_connect net/socket.c:1876 [inline]
                      __x64_sys_connect+0x6f/0xb0 net/socket.c:1876
                      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                      entry_SYSCALL_64_after_hwframe+0x44/0xa9
    IN-SOFTIRQ-W
 at:
                      lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      spin_lock include/linux/spinlock.h:354 [inline]
                      sk_clone_lock+0x2a1/0x10b0 net/core/sock.c:1881
                      inet_csk_clone_lock+0x21/0x480 net/ipv4/inet_connection_sock.c:830
                      tcp_create_openreq_child+0x2d/0x1700 net/ipv4/tcp_minisocks.c:460
                      tcp_v4_syn_recv_sock+0xb6/0x1370 net/ipv4/tcp_ipv4.c:1514
                      tcp_check_req+0x607/0x17b0 net/ipv4/tcp_minisocks.c:773
                      tcp_v4_rcv+0x21ba/0x3750 net/ipv4/tcp_ipv4.c:1973
                      ip_protocol_deliver_rcu+0x5c/0x8a0 net/ipv4/ip_input.c:204
                      ip_local_deliver_finish+0x20a/0x370 net/ipv4/ip_input.c:231
                      NF_HOOK include/linux/netfilter.h:301 [inline]
                      NF_HOOK include/linux/netfilter.h:295 [inline]
                      ip_local_deliver+0x1b3/0x200 net/ipv4/ip_input.c:252
                      dst_input include/net/dst.h:449 [inline]
                      ip_sublist_rcv_finish+0x9a/0x2c0 net/ipv4/ip_input.c:550
                      ip_list_rcv_finish.constprop.0+0x514/0x6e0 net/ipv4/ip_input.c:600
                      ip_sublist_rcv net/ipv4/ip_input.c:608 [inline]
                      ip_list_rcv+0x34e/0x490 net/ipv4/ip_input.c:643
                      __netif_receive_skb_list_ptype net/core/dev.c:5330 [inline]
                      __netif_receive_skb_list_core+0x549/0x8e0 net/core/dev.c:5378
                      __netif_receive_skb_list net/core/dev.c:5430 [inline]
                      netif_receive_skb_list_internal+0x777/0xd70 net/core/dev.c:5535
                      gro_normal_list net/core/dev.c:5689 [inline]
                      gro_normal_list net/core/dev.c:5685 [inline]
                      napi_complete_done+0x1f1/0x940 net/core/dev.c:6414
                      virtqueue_napi_complete+0x2c/0xc0 drivers/net/virtio_net.c:329
                      virtnet_poll+0xae2/0xd90 drivers/net/virtio_net.c:1455
                      napi_poll net/core/dev.c:6730 [inline]
                      net_rx_action+0x587/0x1320 net/core/dev.c:6800
                      __do_softirq+0x203/0xab6 kernel/softirq.c:298
                      asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
                      __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
                      run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
                      do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
                      invoke_softirq kernel/softirq.c:393 [inline]
                      __irq_exit_rcu kernel/softirq.c:423 [inline]
                      irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
                      common_interrupt+0xa3/0x1f0 arch/x86/kernel/irq.c:239
                      asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:622
                      x2apic_send_IPI+0x5f/0x120 arch/x86/kernel/apic/x2apic_phys.c:38
                      __smp_call_single_queue kernel/smp.c:270 [inline]
                      generic_exec_single+0x122/0x450 kernel/smp.c:303
                      smp_call_function_single+0x186/0x500 kernel/smp.c:509
                      smp_call_function_many_cond+0x1a4/0xa10 kernel/smp.c:648
                      smp_call_function_many kernel/smp.c:711 [inline]
                      smp_call_function kernel/smp.c:733 [inline]
                      on_each_cpu+0x4c/0x1f0 kernel/smp.c:832
                      text_poke_sync arch/x86/kernel/alternative.c:999 [inline]
                      text_poke_bp_batch+0x1a7/0x550 arch/x86/kernel/alternative.c:1184
                      text_poke_flush arch/x86/kernel/alternative.c:1338 [inline]
                      text_poke_flush arch/x86/kernel/alternative.c:1335 [inline]
                      text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1345
                      arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:126
                      jump_label_update kernel/jump_label.c:814 [inline]
                      jump_label_update+0x1b3/0x3a0 kernel/jump_label.c:793
                      static_key_disable_cpuslocked+0x152/0x1b0 kernel/jump_label.c:207
                      static_key_disable+0x16/0x20 kernel/jump_label.c:215
                      once_deferred+0x64/0x90 lib/once.c:18
                      process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
                      worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
                      kthread+0x3af/0x4a0 kernel/kthread.c:292
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
    INITIAL USE at:
                     lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                     _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                     spin_lock_bh include/linux/spinlock.h:359 [inline]
                     lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
                     lock_sock include/net/sock.h:1581 [inline]
                     inet_autobind+0x1a/0x190 net/ipv4/af_inet.c:180
                     inet_dgram_connect+0x245/0x2d0 net/ipv4/af_inet.c:575
                     __sys_connect_file+0x155/0x1a0 net/socket.c:1852
                     __sys_connect+0x161/0x190 net/socket.c:1869
                     __do_sys_connect net/socket.c:1879 [inline]
                     __se_sys_connect net/socket.c:1876 [inline]
                     __x64_sys_connect+0x6f/0xb0 net/socket.c:1876
                     do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                     entry_SYSCALL_64_after_hwframe+0x44/0xa9
  }
  ... key      at: [<ffffffff8e18f900>] af_family_slock_keys+0x20/0x300
  ... acquired at:
   seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
   xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
   xfrm_policy_find_inexact_candidates+0xac/0x1d0 net/xfrm/xfrm_policy.c:1953
   xfrm_policy_lookup_bytype+0x4b8/0xa40 net/xfrm/xfrm_policy.c:2108
   xfrm_policy_lookup net/xfrm/xfrm_policy.c:2144 [inline]
   xfrm_bundle_lookup net/xfrm/xfrm_policy.c:2944 [inline]
   xfrm_lookup_with_ifid+0xab3/0x2130 net/xfrm/xfrm_policy.c:3085
   xfrm_lookup net/xfrm/xfrm_policy.c:3177 [inline]
   xfrm_lookup_route+0x36/0x1e0 net/xfrm/xfrm_policy.c:3188
   ip_route_output_flow+0xa6/0xc0 net/ipv4/route.c:2771
   ip_route_output_ports include/net/route.h:169 [inline]
   ip4_datagram_release_cb+0x701/0xaa0 net/ipv4/datagram.c:119
   release_sock+0xb4/0x1b0 net/core/sock.c:3057
   ip4_datagram_connect+0x36/0x40 net/ipv4/datagram.c:91
   inet_dgram_connect+0x14a/0x2d0 net/ipv4/af_inet.c:577
   __sys_connect_file+0x155/0x1a0 net/socket.c:1852
   __sys_connect+0x161/0x190 net/socket.c:1869
   __do_sys_connect net/socket.c:1879 [inline]
   __se_sys_connect net/socket.c:1876 [inline]
   __x64_sys_connect+0x6f/0xb0 net/socket.c:1876
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> (
&s->seqcount
#11){+.+.}-{0:0} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                    write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
                    write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
                    __xfrm_policy_inexact_prune_bin+0xbc/0x1040 net/xfrm/xfrm_policy.c:1077
                    xfrm_policy_inexact_insert+0x49b/0xbd0 net/xfrm/xfrm_policy.c:1205
                    xfrm_policy_insert+0x502/0x870 net/xfrm/xfrm_policy.c:1572
                    pfkey_spdadd+0xfb1/0x1550 net/key/af_key.c:2332
                    pfkey_process+0x68b/0x800 net/key/af_key.c:2841
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
                    xfrm_user_rcv_msg+0x41e/0x720 net/xfrm/xfrm_user.c:2684
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
   INITIAL USE
 at:
                   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
                   write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
                   write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
                   __xfrm_policy_inexact_prune_bin+0xbc/0x1040 net/xfrm/xfrm_policy.c:1077
                   xfrm_policy_inexact_insert+0x49b/0xbd0 net/xfrm/xfrm_policy.c:1205
                   xfrm_policy_insert+0x502/0x870 net/xfrm/xfrm_policy.c:1572
                   pfkey_spdadd+0xfb1/0x1550 net/key/af_key.c:2332
                   pfkey_process+0x68b/0x800 net/key/af_key.c:2841
                   pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3680
                   sock_sendmsg_nosec net/socket.c:651 [inline]
                   sock_sendmsg+0xcf/0x120 net/socket.c:671
                   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
                   ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
                   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
                   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                   entry_SYSCALL_64_after_hwframe+0x44/0xa9
   (null) at:
================================================================================
UBSAN: array-index-out-of-bounds in kernel/locking/lockdep.c:2240:40
index 9 is out of range for type 'lock_trace *[9]'
CPU: 1 PID: 16600 Comm: syz-executor.1 Not tainted 5.9.0-rc5-next-20200916-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
 print_lock_class_header kernel/locking/lockdep.c:2240 [inline]
 print_shortest_lock_dependencies.cold+0x11c/0x2e2 kernel/locking/lockdep.c:2263
 print_irq_inversion_bug.part.0+0x2c6/0x2ee kernel/locking/lockdep.c:3769
 print_irq_inversion_bug kernel/locking/lockdep.c:3694 [inline]
 check_usage_backwards kernel/locking/lockdep.c:3838 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3928 [inline]
 mark_lock.cold+0x1a/0x74 kernel/locking/lockdep.c:4375
 mark_usage kernel/locking/lockdep.c:4278 [inline]
 __lock_acquire+0x886/0x56d0 kernel/locking/lockdep.c:4750
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
 write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
 write_seqlock include/linux/seqlock.h:883 [inline]
 xfrm_set_spdinfo+0x302/0x660 net/xfrm/xfrm_user.c:1185
 xfrm_user_rcv_msg+0x41e/0x720 net/xfrm/xfrm_user.c:2684
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
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc0b86b3c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002cf80 RCX: 000000000045d5f9
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffd902a0b1f R14: 00007fc0b86b49c0 R15: 000000000118cf4c
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
