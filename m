Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DDC18DF36
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgCUJkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 05:40:17 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54327 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgCUJkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 05:40:15 -0400
Received: by mail-io1-f72.google.com with SMTP id f20so357297iof.21
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 02:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KmxQnGJBLUSsjJd4YIqhEUdYIXRrtUNA9oq90lM0pIQ=;
        b=eJYNm4MZJgUQqJTxgtEs5IWFrQUsj/CDo1ts73qnpS5rK0U4T34Jj4UAWyeK9zlvmA
         lQr9g9t8CBXZlC1OK2OM4sAOiXfUvM0MmCSJ75R5N+6UU1YruDvSn88MxjEmrZkNLXFd
         cXYs97nMupOsYpDZoUfs8MQ6qyIB1o6zyNfvK1mhcwb1MkSFMXbJtwPFtcy2whEPMocg
         wmmpPn0f0FFIwR0R9+2DAYAKTH66f2JnBg9s/yKzHH2EawAM6gcOnciGpMZvt9Z7cpxE
         vj4D4SnyaKsQi+xknGt7AfKQfAgffVxkqsK2Q3tM1hc54yOtOn9j8aFc7xc++BhEWBMw
         e9Fw==
X-Gm-Message-State: ANhLgQ0ikm1mGjSM67fU9uFF62cwQNpKk5g78uZzQ103EgK5Zcgv9Cti
        IpR89CAlcRlp7kfgvB8kNykv/2VRFxQSPI5ACzYN3gwT2FW8
X-Google-Smtp-Source: ADFU+vvbE4xKWA+UphocEErEuGNP+43V2BUsjb+m7Yo2JQ82kLdFE7pxA7j9Ywa3LfifIaF4QxuYVMRm0NqaU0BvM4VKv16XgLov
MIME-Version: 1.0
X-Received: by 2002:a02:90d0:: with SMTP id c16mr12190017jag.22.1584783612132;
 Sat, 21 Mar 2020 02:40:12 -0700 (PDT)
Date:   Sat, 21 Mar 2020 02:40:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f417405a15a30cd@google.com>
Subject: possible deadlock in peernet2id_alloc
From:   syzbot <syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        gnault@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    86e85bf6 sfc: fix XDP-redirect in this driver
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=111eda1de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5acf5ac38a50651
dashboard link: https://syzkaller.appspot.com/bug?extid=3f960c64a104eaa2c813
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3f960c64a104eaa2c813@syzkaller.appspotmail.com

bridge1: port 1(macsec0) entered blocking state
bridge1: port 1(macsec0) entered disabled state
device macsec0 entered promiscuous mode
=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
5.6.0-rc5-syzkaller #0 Not tainted
-----------------------------------------------------
syz-executor.1/11771 [HC0[0]:SC0[4]:HE1:SE0] is trying to acquire:
ffff8880714700e8 (&(&net->nsid_lock)->rlock){+.+.}, at: spin_lock include/linux/spinlock.h:338 [inline]
ffff8880714700e8 (&(&net->nsid_lock)->rlock){+.+.}, at: peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240

and this task is already holding:
ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: netif_addr_lock_bh include/linux/netdevice.h:4163 [inline]
ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: dev_uc_add+0x1f/0xb0 net/core/dev_addr_lists.c:588
which would create a new lock dependency:
 (&dev->addr_list_lock_key#188){+...} -> (&(&net->nsid_lock)->rlock){+.+.}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&mc->mca_lock)->rlock){+.-.}

... which became SOFTIRQ-irq-safe at:
  lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  mld_send_cr net/ipv6/mcast.c:1953 [inline]
  mld_ifc_timer_expire+0x2b5/0x920 net/ipv6/mcast.c:2477
  call_timer_fn+0x195/0x760 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1786
  __do_softirq+0x26c/0x99d kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x192/0x1d0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
  smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1146
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
  kmem_cache_free+0xa4/0x320 mm/slab.c:3695
  putname+0xe1/0x120 fs/namei.c:259
  filename_lookup+0x282/0x3e0 fs/namei.c:2475
  user_path_at include/linux/namei.h:58 [inline]
  vfs_statx+0x119/0x1e0 fs/stat.c:197
  vfs_stat include/linux/fs.h:3271 [inline]
  __do_sys_newstat+0x96/0x120 fs/stat.c:351
  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

to a SOFTIRQ-irq-unsafe lock:
 (&(&net->nsid_lock)->rlock){+.+.}

... which became SOFTIRQ-irq-unsafe at:
...
  lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
  dev_change_net_namespace+0x2a6/0xd30 net/core/dev.c:10066
  do_setlink+0x18b/0x35e0 net/core/rtnetlink.c:2501
  __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:672
  ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
  __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  &(&mc->mca_lock)->rlock --> &dev->addr_list_lock_key#188 --> &(&net->nsid_lock)->rlock

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&net->nsid_lock)->rlock);
                               local_irq_disable();
                               lock(&(&mc->mca_lock)->rlock);
                               lock(&dev->addr_list_lock_key#188);
  <Interrupt>
    lock(&(&mc->mca_lock)->rlock);

 *** DEADLOCK ***

3 locks held by syz-executor.1/11771:
 #0: ffffffff8a34fbc0 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a34fbc0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5437
 #1: ffff8880607f4bd0 (&(&br->hash_lock)->rlock){+.-.}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
 #1: ffff8880607f4bd0 (&(&br->hash_lock)->rlock){+.-.}, at: br_fdb_insert+0x24/0x50 net/bridge/br_fdb.c:553
 #2: ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: spin_lock_bh include/linux/spinlock.h:343 [inline]
 #2: ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: netif_addr_lock_bh include/linux/netdevice.h:4163 [inline]
 #2: ffff888060822280 (&dev->addr_list_lock_key#188){+...}, at: dev_uc_add+0x1f/0xb0 net/core/dev_addr_lists.c:588

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
 -> (&(&mc->mca_lock)->rlock){+.-.} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                      __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                      _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                      spin_lock_bh include/linux/spinlock.h:343 [inline]
                      mld_del_delrec+0x344/0x570 net/ipv6/mcast.c:786
                      __ipv6_dev_mc_inc+0x80c/0xc90 net/ipv6/mcast.c:930
                      ipv6_add_dev net/ipv6/addrconf.c:453 [inline]
                      ipv6_add_dev+0xa2e/0x10b0 net/ipv6/addrconf.c:363
                      addrconf_init+0xd3/0x39a net/ipv6/addrconf.c:7067
                      inet6_init+0x368/0x6dc net/ipv6/af_inet6.c:1071
                      do_one_initcall+0x10a/0x7d0 init/main.c:1152
                      do_initcall_level init/main.c:1225 [inline]
                      do_initcalls init/main.c:1241 [inline]
                      do_basic_setup init/main.c:1261 [inline]
                      kernel_init_freeable+0x501/0x5ae init/main.c:1445
                      kernel_init+0xd/0x1bb init/main.c:1352
                      ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
    IN-SOFTIRQ-W at:
                      lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                      __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                      _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                      spin_lock_bh include/linux/spinlock.h:343 [inline]
                      mld_send_cr net/ipv6/mcast.c:1953 [inline]
                      mld_ifc_timer_expire+0x2b5/0x920 net/ipv6/mcast.c:2477
                      call_timer_fn+0x195/0x760 kernel/time/timer.c:1404
                      expire_timers kernel/time/timer.c:1449 [inline]
                      __run_timers kernel/time/timer.c:1773 [inline]
                      __run_timers kernel/time/timer.c:1740 [inline]
                      run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1786
                      __do_softirq+0x26c/0x99d kernel/softirq.c:292
                      invoke_softirq kernel/softirq.c:373 [inline]
                      irq_exit+0x192/0x1d0 kernel/softirq.c:413
                      exiting_irq arch/x86/include/asm/apic.h:546 [inline]
                      smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1146
                      apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
                      arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
                      kmem_cache_free+0xa4/0x320 mm/slab.c:3695
                      putname+0xe1/0x120 fs/namei.c:259
                      filename_lookup+0x282/0x3e0 fs/namei.c:2475
                      user_path_at include/linux/namei.h:58 [inline]
                      vfs_statx+0x119/0x1e0 fs/stat.c:197
                      vfs_stat include/linux/fs.h:3271 [inline]
                      __do_sys_newstat+0x96/0x120 fs/stat.c:351
                      do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                      entry_SYSCALL_64_after_hwframe+0x49/0xbe
    INITIAL USE at:
                     lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                     _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                     spin_lock_bh include/linux/spinlock.h:343 [inline]
                     mld_del_delrec+0x344/0x570 net/ipv6/mcast.c:786
                     __ipv6_dev_mc_inc+0x80c/0xc90 net/ipv6/mcast.c:930
                     ipv6_add_dev net/ipv6/addrconf.c:453 [inline]
                     ipv6_add_dev+0xa2e/0x10b0 net/ipv6/addrconf.c:363
                     addrconf_init+0xd3/0x39a net/ipv6/addrconf.c:7067
                     inet6_init+0x368/0x6dc net/ipv6/af_inet6.c:1071
                     do_one_initcall+0x10a/0x7d0 init/main.c:1152
                     do_initcall_level init/main.c:1225 [inline]
                     do_initcalls init/main.c:1241 [inline]
                     do_basic_setup init/main.c:1261 [inline]
                     kernel_init_freeable+0x501/0x5ae init/main.c:1445
                     kernel_init+0xd/0x1bb init/main.c:1352
                     ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
  }
  ... key      at: [<ffffffff8cf734a0>] __key.78637+0x0/0x40
  ... acquired at:
   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
   spin_lock_bh include/linux/spinlock.h:343 [inline]
   netif_addr_lock_bh include/linux/netdevice.h:4163 [inline]
   __dev_mc_add+0x28/0xd0 net/core/dev_addr_lists.c:765
   igmp6_group_added+0x375/0x420 net/ipv6/mcast.c:672
   __ipv6_dev_mc_inc+0x814/0xc90 net/ipv6/mcast.c:931
   ipv6_add_dev net/ipv6/addrconf.c:456 [inline]
   ipv6_add_dev+0xa3d/0x10b0 net/ipv6/addrconf.c:363
   addrconf_notify+0x960/0x2310 net/ipv6/addrconf.c:3497
   notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
   call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
   call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
   call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
   call_netdevice_notifiers net/core/dev.c:1974 [inline]
   register_netdevice+0x69f/0xfc0 net/core/dev.c:9401
   macsec_newlink+0x2d4/0x1070 drivers/net/macsec.c:3875
   __rtnl_newlink+0xf18/0x1590 net/core/rtnetlink.c:3319
   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:672
   __sys_sendto+0x21a/0x330 net/socket.c:1998
   __do_sys_sendto net/socket.c:2010 [inline]
   __se_sys_sendto net/socket.c:2006 [inline]
   __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2006
   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> (&dev->addr_list_lock_key#188){+...} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                    _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                    spin_lock_bh include/linux/spinlock.h:343 [inline]
                    netif_addr_lock_bh include/linux/netdevice.h:4163 [inline]
                    __dev_mc_add+0x28/0xd0 net/core/dev_addr_lists.c:765
                    igmp6_group_added+0x375/0x420 net/ipv6/mcast.c:672
                    __ipv6_dev_mc_inc+0x814/0xc90 net/ipv6/mcast.c:931
                    ipv6_add_dev net/ipv6/addrconf.c:456 [inline]
                    ipv6_add_dev+0xa3d/0x10b0 net/ipv6/addrconf.c:363
                    addrconf_notify+0x960/0x2310 net/ipv6/addrconf.c:3497
                    notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
                    call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
                    call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
                    call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
                    call_netdevice_notifiers net/core/dev.c:1974 [inline]
                    register_netdevice+0x69f/0xfc0 net/core/dev.c:9401
                    macsec_newlink+0x2d4/0x1070 drivers/net/macsec.c:3875
                    __rtnl_newlink+0xf18/0x1590 net/core/rtnetlink.c:3319
                    rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
                    rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
                    netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
                    netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
                    netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
                    netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
                    sock_sendmsg_nosec net/socket.c:652 [inline]
                    sock_sendmsg+0xcf/0x120 net/socket.c:672
                    __sys_sendto+0x21a/0x330 net/socket.c:1998
                    __do_sys_sendto net/socket.c:2010 [inline]
                    __se_sys_sendto net/socket.c:2006 [inline]
                    __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2006
                    do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                    entry_SYSCALL_64_after_hwframe+0x49/0xbe
   INITIAL USE at:
                   lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
                   _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
                   spin_lock_bh include/linux/spinlock.h:343 [inline]
                   netif_addr_lock_bh include/linux/netdevice.h:4163 [inline]
                   __dev_mc_add+0x28/0xd0 net/core/dev_addr_lists.c:765
                   igmp6_group_added+0x375/0x420 net/ipv6/mcast.c:672
                   __ipv6_dev_mc_inc+0x814/0xc90 net/ipv6/mcast.c:931
                   ipv6_add_dev net/ipv6/addrconf.c:456 [inline]
                   ipv6_add_dev+0xa3d/0x10b0 net/ipv6/addrconf.c:363
                   addrconf_notify+0x960/0x2310 net/ipv6/addrconf.c:3497
                   notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
                   call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
                   call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
                   call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
                   call_netdevice_notifiers net/core/dev.c:1974 [inline]
                   register_netdevice+0x69f/0xfc0 net/core/dev.c:9401
                   macsec_newlink+0x2d4/0x1070 drivers/net/macsec.c:3875
                   __rtnl_newlink+0xf18/0x1590 net/core/rtnetlink.c:3319
                   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
                   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
                   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
                   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
                   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
                   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
                   sock_sendmsg_nosec net/socket.c:652 [inline]
                   sock_sendmsg+0xcf/0x120 net/socket.c:672
                   __sys_sendto+0x21a/0x330 net/socket.c:1998
                   __do_sys_sendto net/socket.c:2010 [inline]
                   __se_sys_sendto net/socket.c:2006 [inline]
                   __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2006
                   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                   entry_SYSCALL_64_after_hwframe+0x49/0xbe
 }
 ... key      at: [<ffff888060822b48>] 0xffff888060822b48
 ... acquired at:
   lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:338 [inline]
   peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
   rtnl_fill_link_netnsid net/core/rtnetlink.c:1565 [inline]
   rtnl_fill_ifinfo+0x1e7c/0x39b0 net/core/rtnetlink.c:1751
   rtmsg_ifinfo_build_skb+0xcd/0x1a0 net/core/rtnetlink.c:3685
   rtmsg_ifinfo_event.part.0+0x49/0xe0 net/core/rtnetlink.c:3717
   rtmsg_ifinfo_event net/core/rtnetlink.c:3728 [inline]
   rtmsg_ifinfo+0x7f/0xa0 net/core/rtnetlink.c:3726
   __dev_notify_flags+0x235/0x2c0 net/core/dev.c:8177
   __dev_set_promiscuity+0x191/0x210 net/core/dev.c:7953
   dev_set_promiscuity+0x4f/0xe0 net/core/dev.c:7973
   macsec_dev_change_rx_flags+0x13b/0x170 drivers/net/macsec.c:3423
   dev_change_rx_flags net/core/dev.c:7906 [inline]
   __dev_set_promiscuity.cold+0x2e3/0x340 net/core/dev.c:7950
   __dev_set_rx_mode+0x21f/0x300 net/core/dev.c:8055
   dev_uc_add+0xa1/0xb0 net/core/dev_addr_lists.c:592
   fdb_add_hw_addr+0xf3/0x280 net/bridge/br_fdb.c:165
   fdb_insert+0x173/0x1c0 net/bridge/br_fdb.c:542
   br_fdb_insert+0x35/0x50 net/bridge/br_fdb.c:554
   br_add_if+0xca2/0x1800 net/bridge/br_if.c:648
   do_set_master net/core/rtnetlink.c:2468 [inline]
   do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2441
   do_setlink+0xaa2/0x35e0 net/core/rtnetlink.c:2603
   __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:672
   ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
   __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe


the dependencies between the lock to be acquired
 and SOFTIRQ-irq-unsafe lock:
-> (&(&net->nsid_lock)->rlock){+.+.} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:338 [inline]
                    peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
                    dev_change_net_namespace+0x2a6/0xd30 net/core/dev.c:10066
                    do_setlink+0x18b/0x35e0 net/core/rtnetlink.c:2501
                    __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
                    rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
                    rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
                    netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
                    netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
                    netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
                    netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
                    sock_sendmsg_nosec net/socket.c:652 [inline]
                    sock_sendmsg+0xcf/0x120 net/socket.c:672
                    ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
                    ___sys_sendmsg+0x100/0x170 net/socket.c:2397
                    __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
                    do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                    entry_SYSCALL_64_after_hwframe+0x49/0xbe
   SOFTIRQ-ON-W at:
                    lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:338 [inline]
                    peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
                    dev_change_net_namespace+0x2a6/0xd30 net/core/dev.c:10066
                    do_setlink+0x18b/0x35e0 net/core/rtnetlink.c:2501
                    __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
                    rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
                    rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
                    netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
                    netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
                    netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
                    netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
                    sock_sendmsg_nosec net/socket.c:652 [inline]
                    sock_sendmsg+0xcf/0x120 net/socket.c:672
                    ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
                    ___sys_sendmsg+0x100/0x170 net/socket.c:2397
                    __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
                    do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                    entry_SYSCALL_64_after_hwframe+0x49/0xbe
   INITIAL USE at:
                   lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
                   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                   spin_lock include/linux/spinlock.h:338 [inline]
                   peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
                   dev_change_net_namespace+0x2a6/0xd30 net/core/dev.c:10066
                   do_setlink+0x18b/0x35e0 net/core/rtnetlink.c:2501
                   __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
                   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
                   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
                   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
                   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
                   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
                   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
                   sock_sendmsg_nosec net/socket.c:652 [inline]
                   sock_sendmsg+0xcf/0x120 net/socket.c:672
                   ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
                   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
                   __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
                   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
                   entry_SYSCALL_64_after_hwframe+0x49/0xbe
 }
 ... key      at: [<ffffffff8cf4d8c0>] __key.69268+0x0/0x40
 ... acquired at:
   lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:338 [inline]
   peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
   rtnl_fill_link_netnsid net/core/rtnetlink.c:1565 [inline]
   rtnl_fill_ifinfo+0x1e7c/0x39b0 net/core/rtnetlink.c:1751
   rtmsg_ifinfo_build_skb+0xcd/0x1a0 net/core/rtnetlink.c:3685
   rtmsg_ifinfo_event.part.0+0x49/0xe0 net/core/rtnetlink.c:3717
   rtmsg_ifinfo_event net/core/rtnetlink.c:3728 [inline]
   rtmsg_ifinfo+0x7f/0xa0 net/core/rtnetlink.c:3726
   __dev_notify_flags+0x235/0x2c0 net/core/dev.c:8177
   __dev_set_promiscuity+0x191/0x210 net/core/dev.c:7953
   dev_set_promiscuity+0x4f/0xe0 net/core/dev.c:7973
   macsec_dev_change_rx_flags+0x13b/0x170 drivers/net/macsec.c:3423
   dev_change_rx_flags net/core/dev.c:7906 [inline]
   __dev_set_promiscuity.cold+0x2e3/0x340 net/core/dev.c:7950
   __dev_set_rx_mode+0x21f/0x300 net/core/dev.c:8055
   dev_uc_add+0xa1/0xb0 net/core/dev_addr_lists.c:592
   fdb_add_hw_addr+0xf3/0x280 net/bridge/br_fdb.c:165
   fdb_insert+0x173/0x1c0 net/bridge/br_fdb.c:542
   br_fdb_insert+0x35/0x50 net/bridge/br_fdb.c:554
   br_add_if+0xca2/0x1800 net/bridge/br_if.c:648
   do_set_master net/core/rtnetlink.c:2468 [inline]
   do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2441
   do_setlink+0xaa2/0x35e0 net/core/rtnetlink.c:2603
   __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:672
   ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
   __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe


stack backtrace:
CPU: 0 PID: 11771 Comm: syz-executor.1 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_bad_irq_dependency kernel/locking/lockdep.c:2094 [inline]
 check_irq_usage.cold+0x586/0x6fe kernel/locking/lockdep.c:2292
 check_prev_add kernel/locking/lockdep.c:2479 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2033/0x3ca0 kernel/locking/lockdep.c:3954
 lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 peernet2id_alloc+0xcd/0x3f0 net/core/net_namespace.c:240
 rtnl_fill_link_netnsid net/core/rtnetlink.c:1565 [inline]
 rtnl_fill_ifinfo+0x1e7c/0x39b0 net/core/rtnetlink.c:1751
 rtmsg_ifinfo_build_skb+0xcd/0x1a0 net/core/rtnetlink.c:3685
 rtmsg_ifinfo_event.part.0+0x49/0xe0 net/core/rtnetlink.c:3717
 rtmsg_ifinfo_event net/core/rtnetlink.c:3728 [inline]
 rtmsg_ifinfo+0x7f/0xa0 net/core/rtnetlink.c:3726
 __dev_notify_flags+0x235/0x2c0 net/core/dev.c:8177
 __dev_set_promiscuity+0x191/0x210 net/core/dev.c:7953
 dev_set_promiscuity+0x4f/0xe0 net/core/dev.c:7973
 macsec_dev_change_rx_flags+0x13b/0x170 drivers/net/macsec.c:3423
 dev_change_rx_flags net/core/dev.c:7906 [inline]
 __dev_set_promiscuity.cold+0x2e3/0x340 net/core/dev.c:7950
 __dev_set_rx_mode+0x21f/0x300 net/core/dev.c:8055
 dev_uc_add+0xa1/0xb0 net/core/dev_addr_lists.c:592
 fdb_add_hw_addr+0xf3/0x280 net/bridge/br_fdb.c:165
 fdb_insert+0x173/0x1c0 net/bridge/br_fdb.c:542
 br_fdb_insert+0x35/0x50 net/bridge/br_fdb.c:554
 br_add_if+0xca2/0x1800 net/bridge/br_if.c:648
 do_set_master net/core/rtnetlink.c:2468 [inline]
 do_set_master+0x1d7/0x230 net/core/rtnetlink.c:2441
 do_setlink+0xaa2/0x35e0 net/core/rtnetlink.c:2603
 __rtnl_newlink+0xad5/0x1590 net/core/rtnetlink.c:3252
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5440
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007efdbe996c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007efdbe9976d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 000000000076bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f9 R14: 00000000004ccb17 R15: 000000000076bfac


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
