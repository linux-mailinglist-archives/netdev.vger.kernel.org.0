Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46C066DBAE
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbjAQK7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbjAQK7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:59:47 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067E6B46D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:59:46 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso22640214ilj.17
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=me+Je8kmcZhn3uq9cVLdpKdyIZiYx93bWzsZXt1zVVI=;
        b=iYTL8o4HD84KQ9I2D6vV0qv62o98JGLcTPDCGbDxxWnZPEXvory1dAz1Qaq9aq6d4D
         NOaXa07CB1A1Q9gzY3pPBWXswoVhZeoWHGPJJmV/Jlx//RfvaSo4fVMtjVrXc4RJLgXd
         I/B/Cieqa8nYG43v9NybDdtCSrZ0cwHvX0qZdy4alFARydLCmcebQ4bTP7vmSrvGz2QW
         SVn8rbL3LywtX0/tRSYVDWydPtcwu0lTkYPAmkj/X2MJbpy9+4ke3VcjJYFNNtcC+xTU
         M6dpe9T2j2nhd4U+AOEJylJjevoYHmTu5GgFCGGIwN9+om8wyvtJmnIscFRlufE777Hx
         4VqA==
X-Gm-Message-State: AFqh2ko/WNLkdTiIgcQ0ZS/THO5mOs3xJJW2VUqRiz9/CElvwj2FLj3U
        y9CmWNmnRkPX97MiLxAWoEoJFVFQhafyKHxNjBsv11RLsta8
X-Google-Smtp-Source: AMrXdXuOw7CiDv56WGbgw0bNr6FmFp+TYXTZKhwJzodm6A4AE+5mkago341OSLGjJY6/Xl5D/QL/8tl5kzTPlYMJCkUxSV9jcDJ0
MIME-Version: 1.0
X-Received: by 2002:a6b:fc16:0:b0:6e2:f56b:adfe with SMTP id
 r22-20020a6bfc16000000b006e2f56badfemr160615ioh.106.1673953185344; Tue, 17
 Jan 2023 02:59:45 -0800 (PST)
Date:   Tue, 17 Jan 2023 02:59:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fbb2d505f27398cb@google.com>
Subject: [syzbot] possible deadlock in release_sock
From:   syzbot <syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com>
To:     cong.wang@bytedance.com, davem@davemloft.net, edumazet@google.com,
        gnault@redhat.com, jakub@cloudflare.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    87b93b678e95 octeontx2-pf: Avoid use of GFP_KERNEL in atom..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1032dd91480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=bbd35b345c7cab0d9a08
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1716b3a1480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e57a91480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/191e8cc30fff/disk-87b93b67.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d34dd6d2fffd/vmlinux-87b93b67.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ad9344e76aaf/bzImage-87b93b67.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc3-syzkaller-00197-g87b93b678e95 #0 Not tainted
------------------------------------------------------
syz-executor131/5064 is trying to acquire lock:
ffff888017b6b370 (slock-AF_INET){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffff888017b6b370 (slock-AF_INET){+.-.}-{2:2}, at: release_sock+0x1f/0x1b0 net/core/sock.c:3483

but task is already holding lock:
ffff888017b6b678 (clock-AF_INET){++..}-{2:2}, at: l2tp_tunnel_register+0x2be/0x11e0 net/l2tp/l2tp_core.c:1484

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (clock-AF_INET){++..}-{2:2}:
       __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
       _raw_read_lock_bh+0x3f/0x70 kernel/locking/spinlock.c:252
       sock_i_uid+0x1f/0xb0 net/core/sock.c:2564
       sk_reuseport_match net/ipv4/inet_connection_sock.c:401 [inline]
       inet_csk_get_port+0x85f/0x2660 net/ipv4/inet_connection_sock.c:532
       inet_csk_listen_start+0x1ad/0x440 net/ipv4/inet_connection_sock.c:1237
       inet_listen+0x235/0x640 net/ipv4/af_inet.c:228
       __sys_listen+0x181/0x250 net/socket.c:1810
       __do_sys_listen net/socket.c:1819 [inline]
       __se_sys_listen net/socket.c:1817 [inline]
       __x64_sys_listen+0x54/0x80 net/socket.c:1817
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (&tcp_hashinfo.bhash[i].lock){+.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:350 [inline]
       __inet_inherit_port+0x2b5/0x1840 net/ipv4/inet_hashtables.c:230
       tcp_v4_syn_recv_sock+0xb5b/0x1450 net/ipv4/tcp_ipv4.c:1628
       tcp_check_req+0x632/0x1aa0 net/ipv4/tcp_minisocks.c:803
       tcp_v4_rcv+0x2120/0x3280 net/ipv4/tcp_ipv4.c:2070
       ip_protocol_deliver_rcu+0x9f/0x460 net/ipv4/ip_input.c:205
       ip_local_deliver_finish+0x2ec/0x4c0 net/ipv4/ip_input.c:233
       NF_HOOK include/linux/netfilter.h:302 [inline]
       NF_HOOK include/linux/netfilter.h:296 [inline]
       ip_local_deliver+0x1ae/0x200 net/ipv4/ip_input.c:254
       dst_input include/net/dst.h:454 [inline]
       ip_sublist_rcv_finish+0x9a/0x2c0 net/ipv4/ip_input.c:580
       ip_list_rcv_finish net/ipv4/ip_input.c:630 [inline]
       ip_sublist_rcv+0x533/0x980 net/ipv4/ip_input.c:638
       ip_list_rcv+0x31e/0x470 net/ipv4/ip_input.c:673
       __netif_receive_skb_list_ptype net/core/dev.c:5525 [inline]
       __netif_receive_skb_list_core+0x548/0x8f0 net/core/dev.c:5573
       __netif_receive_skb_list net/core/dev.c:5625 [inline]
       netif_receive_skb_list_internal+0x75f/0xd90 net/core/dev.c:5716
       gro_normal_list include/net/gro.h:433 [inline]
       gro_normal_list include/net/gro.h:429 [inline]
       napi_complete_done+0x243/0x960 net/core/dev.c:6056
       virtqueue_napi_complete drivers/net/virtio_net.c:405 [inline]
       virtnet_poll+0xd08/0x1300 drivers/net/virtio_net.c:1682
       __napi_poll+0xb8/0x770 net/core/dev.c:6485
       napi_poll net/core/dev.c:6552 [inline]
       net_rx_action+0xa00/0xde0 net/core/dev.c:6663
       __do_softirq+0x1fb/0xadc kernel/softirq.c:571
       invoke_softirq kernel/softirq.c:445 [inline]
       __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
       irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
       sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
       asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
       native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
       arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
       acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
       acpi_idle_do_entry+0x1fd/0x2a0 drivers/acpi/processor_idle.c:570
       acpi_idle_enter+0x368/0x510 drivers/acpi/processor_idle.c:707
       cpuidle_enter_state+0x1af/0xd40 drivers/cpuidle/cpuidle.c:239
       cpuidle_enter+0x4e/0xa0 drivers/cpuidle/cpuidle.c:356
       call_cpuidle kernel/sched/idle.c:155 [inline]
       cpuidle_idle_call kernel/sched/idle.c:236 [inline]
       do_idle+0x3f7/0x590 kernel/sched/idle.c:303
       cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:400
       start_secondary+0x256/0x300 arch/x86/kernel/smpboot.c:264
       secondary_startup_64_no_verify+0xce/0xdb

-> #0 (slock-AF_INET){+.-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
       __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
       _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
       spin_lock_bh include/linux/spinlock.h:355 [inline]
       release_sock+0x1f/0x1b0 net/core/sock.c:3483
       l2tp_tunnel_register+0x3db/0x11e0 net/l2tp/l2tp_core.c:1487
       l2tp_nl_cmd_tunnel_create+0x3d6/0x8b0 net/l2tp/l2tp_netlink.c:245
       genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
       genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
       genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
       netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
       netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
       netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
       netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xd3/0x120 net/socket.c:734
       ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
       ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
       __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

Chain exists of:
  slock-AF_INET --> &tcp_hashinfo.bhash[i].lock --> clock-AF_INET

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(clock-AF_INET);
                               lock(&tcp_hashinfo.bhash[i].lock);
                               lock(clock-AF_INET);
  lock(slock-AF_INET);

 *** DEADLOCK ***

4 locks held by syz-executor131/5064:
 #0: ffffffff8e159a10 (cb_lock){++++}-{3:3}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1075
 #1: ffffffff8e159ac8 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8e159ac8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x51a/0x7e0 net/netlink/genetlink.c:1063
 #2: ffff888017b6b3f0 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1725 [inline]
 #2: ffff888017b6b3f0 (sk_lock-AF_INET){+.+.}-{0:0}, at: l2tp_tunnel_register+0x2aa/0x11e0 net/l2tp/l2tp_core.c:1483
 #3: ffff888017b6b678 (clock-AF_INET){++..}-{2:2}, at: l2tp_tunnel_register+0x2be/0x11e0 net/l2tp/l2tp_core.c:1484

stack backtrace:
CPU: 0 PID: 5064 Comm: syz-executor131 Not tainted 6.2.0-rc3-syzkaller-00197-g87b93b678e95 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 release_sock+0x1f/0x1b0 net/core/sock.c:3483
 l2tp_tunnel_register+0x3db/0x11e0 net/l2tp/l2tp_core.c:1487
 l2tp_nl_cmd_tunnel_create+0x3d6/0x8b0 net/l2tp/l2tp_netlink.c:245
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f82e5a4fbe9
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
