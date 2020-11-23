Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318D12C03CF
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgKWLJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgKWLJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 06:09:02 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28FB220729;
        Mon, 23 Nov 2020 11:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606129740;
        bh=C45Y0mXjGSueWNqF/l54xtKGfyZKwY4yWk6oK3ScWCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gzy8N3KkE83YLQb7Gw5nZYkvg+AMMxgQb1ZXQHwp5lozL8Za/DpF6Z8Pe/vjn3Nly
         +YmJ5aNxY44o0mPDmLFZzxtha6OC5WWadcGQIUHfVak71kq1KW7uJ1Nif16z/dlaZW
         27aZpjO4oJYGFR9EdD8IPvgKHA6meSeZTiY4UXQw=
Date:   Mon, 23 Nov 2020 13:08:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201123110855.GD3159@unreal>
References: <20201117102341.GR47002@unreal>
 <20201117093325.78f1486d@gandalf.local.home>
 <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
 <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
 <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
 <20201118091257.2ee6757a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118091257.2ee6757a@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:12:57AM -0500, Steven Rostedt wrote:
>
> [ Adding netdev as perhaps someone there knows ]
>
> On Wed, 18 Nov 2020 12:09:59 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
> > > This CPU0 lock(_xmit_ETHER#2) -> hard IRQ -> lock(console_owner) is
> > > basically
> > > 	soft IRQ -> lock(_xmit_ETHER#2) -> hard IRQ -> printk()
> > >
> > > Then CPU1 spins on xmit, which is owned by CPU0, CPU0 spins on
> > > console_owner, which is owned by CPU1?
>
> It still looks to me that the target_list_lock is taken in IRQ, (which can
> be the case because printk calls write_msg() which takes that lock). And
> someplace there's a:
>
> 	lock(target_list_lock)
> 	lock(xmit_lock)
>
> which means you can remove the console lock from this scenario completely,
> and you still have a possible deadlock between target_list_lock and
> xmit_lock.
>
> >
> >
> > If this is true, it looks not a virtio-net specific issue but somewhere
> > else.
> >
> > I think all network driver will synchronize through bh instead of hardirq.
>
> I think the issue is where target_list_lock is held when we take xmit_lock.
> Is there anywhere in netconsole.c that can end up taking xmit_lock while
> holding the target_list_lock? If so, that's the problem. As
> target_list_lock is something that can be taken in IRQ context, which means
> *any* other lock that is taking while holding the target_list_lock must
> also protect against interrupts from happening while it they are held.

I increased printk buffer like Petr suggested and the splat is below.
It doesn't happening on x86, but on ARM65 and ppc64.

 [   10.027975] =====================================================
 [   10.027976] WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
 [   10.027976] 5.10.0-rc4_for_upstream_min_debug_2020_11_22_19_37 #1 Not tainted
 [   10.027977] -----------------------------------------------------
 [   10.027978] modprobe/638 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 [   10.027979] ffff0000c9f63c98 (_xmit_ETHER#2){+.-.}-{2:2}, at: virtnet_poll_tx+0x84/0x120
 [   10.027982]
 [   10.027982] and this task is already holding:
 [   10.027983] ffff800009007018 (target_list_lock){....}-{2:2}, at: write_msg+0x6c/0x120 [netconsole]
 [   10.027985] which would create a new lock dependency:
 [   10.027985]  (target_list_lock){....}-{2:2} -> (_xmit_ETHER#2){+.-.}-{2:2}
 [   10.027989]
 [   10.027989] but this new dependency connects a HARDIRQ-irq-safe lock:
 [   10.027990]  (console_owner){-...}-{0:0}
 [   10.027991]
 [   10.027992] ... which became HARDIRQ-irq-safe at:
 [   10.027992]   __lock_acquire+0xa78/0x1a94
 [   10.027993]   lock_acquire.part.0+0x170/0x360
 [   10.027993]   lock_acquire+0x68/0x8c
 [   10.027994]   console_unlock+0x1e8/0x6a4
 [   10.027994]   vprintk_emit+0x1c4/0x3c4
 [   10.027995]   vprintk_default+0x40/0x4c
 [   10.027995]   vprintk_func+0x10c/0x220
 [   10.027995]   printk+0x68/0x90
 [   10.027996]   crng_fast_load+0x1bc/0x1c0
 [   10.027997]   add_interrupt_randomness+0x280/0x290
 [   10.027997]   handle_irq_event+0x80/0x120
 [   10.027997]   handle_fasteoi_irq+0xac/0x200
 [   10.027998]   __handle_domain_irq+0x84/0xf0
 [   10.027999]   gic_handle_irq+0xd4/0x320
 [   10.027999]   el1_irq+0xd0/0x180
 [   10.028000]   arch_cpu_idle+0x24/0x44
 [   10.028000]   default_idle_call+0x48/0xa0
 [   10.028001]   do_idle+0x260/0x300
 [   10.028001]   cpu_startup_entry+0x30/0x6c
 [   10.028001]   rest_init+0x1b4/0x288
 [   10.028002]   arch_call_rest_init+0x18/0x24
 [   10.028002]   start_kernel+0x5cc/0x608
 [   10.028003]
 [   10.028003] to a HARDIRQ-irq-unsafe lock:
 [   10.028004]  (_xmit_ETHER#2){+.-.}-{2:2}
 [   10.028005]
 [   10.028006] ... which became HARDIRQ-irq-unsafe at:
 [   10.028006] ...  __lock_acquire+0x8bc/0x1a94
 [   10.028007]   lock_acquire.part.0+0x170/0x360
 [   10.028007]   lock_acquire+0x68/0x8c
 [   10.028008]   _raw_spin_trylock+0x80/0xd0
 [   10.028008]   virtnet_poll+0xac/0x360
 [   10.028009]   net_rx_action+0x1b0/0x4e0
 [   10.028010]   __do_softirq+0x1f4/0x638
 [   10.028010]   do_softirq+0xb8/0xcc
 [   10.028010]   __local_bh_enable_ip+0x18c/0x200
 [   10.028011]   virtnet_napi_enable+0xc0/0xd4
 [   10.028011]   virtnet_open+0x98/0x1c0
 [   10.028012]   __dev_open+0x12c/0x200
 [   10.028013]   __dev_change_flags+0x1a0/0x220
 [   10.028013]   dev_change_flags+0x2c/0x70
 [   10.028014]   do_setlink+0x214/0xe20
 [   10.028014]   __rtnl_newlink+0x514/0x820
 [   10.028015]   rtnl_newlink+0x58/0x84
 [   10.028015]   rtnetlink_rcv_msg+0x184/0x4b4
 [   10.028016]   netlink_rcv_skb+0x60/0x124
 [   10.028016]   rtnetlink_rcv+0x20/0x30
 [   10.028017]   netlink_unicast+0x1b4/0x270
 [   10.028017]   netlink_sendmsg+0x1f0/0x400
 [   10.028018]   sock_sendmsg+0x5c/0x70
 [   10.028018]   ____sys_sendmsg+0x24c/0x280
 [   10.028019]   ___sys_sendmsg+0x88/0xd0
 [   10.028019]   __sys_sendmsg+0x70/0xd0
 [   10.028020]   __arm64_sys_sendmsg+0x2c/0x40
 [   10.028021]   el0_svc_common.constprop.0+0x84/0x200
 [   10.028021]   do_el0_svc+0x2c/0x90
 [   10.028021]   el0_svc+0x18/0x50
 [   10.028022]   el0_sync_handler+0xe0/0x350
 [   10.028023]   el0_sync+0x158/0x180
 [   10.028023]
 [   10.028023] other info that might help us debug this:
 [   10.028024]
 [   10.028024] Chain exists of:
 [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2
 [   10.028028]
 [   10.028028]  Possible interrupt unsafe locking scenario:
 [   10.028029]
 [   10.028029]        CPU0                    CPU1
 [   10.028030]        ----                    ----
 [   10.028030]   lock(_xmit_ETHER#2);
 [   10.028032]                                local_irq_disable();
 [   10.028032]                                lock(console_owner);
 [   10.028034]                                lock(target_list_lock);
 [   10.028035]   <Interrupt>
 [   10.028035]     lock(console_owner);
 [   10.028036]
 [   10.028037]  *** DEADLOCK ***
 [   10.028037]
 [   10.028038] 3 locks held by modprobe/638:
 [   10.028038]  #0: ffff800011e1efe0 (console_lock){+.+.}-{0:0}, at: register_console+0x144/0x2f4
 [   10.028040]  #1: ffff800011e1f108 (console_owner){-...}-{0:0}, at: console_unlock+0x17c/0x6a4
 [   10.028043]  #2: ffff800009007018 (target_list_lock){....}-{2:2}, at: write_msg+0x6c/0x120 [netconsole]
 [   10.028045]
 [   10.028046] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
 [   10.028046]  -> (console_owner){-...}-{0:0} ops: 1574 {
 [   10.028049]     IN-HARDIRQ-W at:
 [   10.028050]                          __lock_acquire+0xa78/0x1a94
 [   10.028050]                          lock_acquire.part.0+0x170/0x360
 [   10.028051]                          lock_acquire+0x68/0x8c
 [   10.028051]                          console_unlock+0x1e8/0x6a4
 [   10.028052]                          vprintk_emit+0x1c4/0x3c4
 [   10.028052]                          vprintk_default+0x40/0x4c
 [   10.028053]                          vprintk_func+0x10c/0x220
 [   10.028054]                          printk+0x68/0x90
 [   10.028054]                          crng_fast_load+0x1bc/0x1c0
 [   10.028055]                          add_interrupt_randomness+0x280/0x290
 [   10.028056]                          handle_irq_event+0x80/0x120
 [   10.028056]                          handle_fasteoi_irq+0xac/0x200
 [   10.028057]                          __handle_domain_irq+0x84/0xf0
 [   10.028057]                          gic_handle_irq+0xd4/0x320
 [   10.028058]                          el1_irq+0xd0/0x180
 [   10.028058]                          arch_cpu_idle+0x24/0x44
 [   10.028059]                          default_idle_call+0x48/0xa0
 [   10.028060]                          do_idle+0x260/0x300
 [   10.028061]                          cpu_startup_entry+0x30/0x6c
 [   10.028061]                          rest_init+0x1b4/0x288
 [   10.028062]                          arch_call_rest_init+0x18/0x24
 [   10.028062]                          start_kernel+0x5cc/0x608
 [   10.028063]     INITIAL USE at:
 [   10.028064]                         __lock_acquire+0x2e0/0x1a94
 [   10.028064]                         lock_acquire.part.0+0x170/0x360
 [   10.028065]                         lock_acquire+0x68/0x8c
 [   10.028066]                         console_unlock+0x1e8/0x6a4
 [   10.028067]                         vprintk_emit+0x1c4/0x3c4
 [   10.028067]                         vprintk_default+0x40/0x4c
 [   10.028068]                         vprintk_func+0x10c/0x220
 [   10.028068]                         printk+0x68/0x90
 [   10.028069]                         start_kernel+0x8c/0x608
 [   10.028069]   }
 [   10.028070]   ... key      at: [<ffff800011e1f108>] console_owner_dep_map+0x0/0x28
 [   10.028071]   ... acquired at:
 [   10.028071]    lock_acquire.part.0+0x170/0x360
 [   10.028072]    lock_acquire+0x68/0x8c
 [   10.028072]    _raw_spin_lock_irqsave+0x88/0x15c
 [   10.028073]    write_msg+0x6c/0x120 [netconsole]
 [   10.028073]    console_unlock+0x3ec/0x6a4
 [   10.028074]    register_console+0x17c/0x2f4
 [   10.028075]    init_netconsole+0x20c/0x1000 [netconsole]
 [   10.028075]    do_one_initcall+0x8c/0x480
 [   10.028076]    do_init_module+0x60/0x270
 [   10.028076]    load_module+0x21f8/0x2734
 [   10.028077]    __do_sys_finit_module+0xbc/0x12c
 [   10.028077]    __arm64_sys_finit_module+0x28/0x34
 [   10.028078]    el0_svc_common.constprop.0+0x84/0x200
 [   10.028078]    do_el0_svc+0x2c/0x90
 [   10.028079]    el0_svc+0x18/0x50
 [   10.028079]    el0_sync_handler+0xe0/0x350
 [   10.028080]    el0_sync+0x158/0x180
 [   10.028080]
 [   10.028081] -> (target_list_lock){....}-{2:2} ops: 34 {
 [   10.028083]    INITIAL USE at:
 [   10.028084]                       __lock_acquire+0x2e0/0x1a94
 [   10.028084]                       lock_acquire.part.0+0x170/0x360
 [   10.028085]                       lock_acquire+0x68/0x8c
 [   10.028085]                       _raw_spin_lock_irqsave+0x88/0x15c
 [   10.028086]                       init_netconsole+0x148/0x1000 [netconsole]
 [   10.028087]                       do_one_initcall+0x8c/0x480
 [   10.028087]                       do_init_module+0x60/0x270
 [   10.028088]                       load_module+0x21f8/0x2734
 [   10.028088]                       __do_sys_finit_module+0xbc/0x12c
 [   10.028089]                       __arm64_sys_finit_module+0x28/0x34
 [   10.028090]                       el0_svc_common.constprop.0+0x84/0x200
 [   10.028090]                       do_el0_svc+0x2c/0x90
 [   10.028091]                       el0_svc+0x18/0x50
 [   10.028092]                       el0_sync_handler+0xe0/0x350
 [   10.028092]                       el0_sync+0x158/0x180
 [   10.028093]  }
 [   10.028093]  ... key      at: [<ffff800009007018>] target_list_lock+0x18/0xfffffffffffff000 [netconsole]
 [   10.028094]  ... acquired at:
 [   10.028094]    __lock_acquire+0x134c/0x1a94
 [   10.028095]    lock_acquire.part.0+0x170/0x360
 [   10.028095]    lock_acquire+0x68/0x8c
 [   10.028096]    _raw_spin_lock+0x64/0x90
 [   10.028096]    virtnet_poll_tx+0x84/0x120
 [   10.028097]    netpoll_poll_dev+0x12c/0x350
 [   10.028097]    netpoll_send_skb+0x39c/0x400
 [   10.028098]    netpoll_send_udp+0x2b8/0x440
 [   10.028098]    write_msg+0xfc/0x120 [netconsole]
 [   10.028099]    console_unlock+0x3ec/0x6a4
 [   10.028100]    register_console+0x17c/0x2f4
 [   10.028100]    init_netconsole+0x20c/0x1000 [netconsole]
 [   10.028101]    do_one_initcall+0x8c/0x480
 [   10.028101]    do_init_module+0x60/0x270
 [   10.028102]    load_module+0x21f8/0x2734
 [   10.028102]    __do_sys_finit_module+0xbc/0x12c
 [   10.028103]    __arm64_sys_finit_module+0x28/0x34
 [   10.028103]    el0_svc_common.constprop.0+0x84/0x200
 [   10.028104]    do_el0_svc+0x2c/0x90
 [   10.028104]    el0_svc+0x18/0x50
 [   10.028105]    el0_sync_handler+0xe0/0x350
 [   10.028105]    el0_sync+0x158/0x180
 [   10.028106]
 [   10.028106]
 [   10.028107] the dependencies between the lock to be acquired
 [   10.028107]  and HARDIRQ-irq-unsafe lock:
 [   10.028108] -> (_xmit_ETHER#2){+.-.}-{2:2} ops: 217 {
 [   10.028110]    HARDIRQ-ON-W at:
 [   10.028111]                        __lock_acquire+0x8bc/0x1a94
 [   10.028111]                        lock_acquire.part.0+0x170/0x360
 [   10.028112]                        lock_acquire+0x68/0x8c
 [   10.028113]                        _raw_spin_trylock+0x80/0xd0
 [   10.028113]                        virtnet_poll+0xac/0x360
 [   10.028114]                        net_rx_action+0x1b0/0x4e0
 [   10.028115]                        __do_softirq+0x1f4/0x638
 [   10.028115]                        do_softirq+0xb8/0xcc
 [   10.028116]                        __local_bh_enable_ip+0x18c/0x200
 [   10.028116]                        virtnet_napi_enable+0xc0/0xd4
 [   10.028117]                        virtnet_open+0x98/0x1c0
 [   10.028118]                        __dev_open+0x12c/0x200
 [   10.028118]                        __dev_change_flags+0x1a0/0x220
 [   10.028119]                        dev_change_flags+0x2c/0x70
 [   10.028119]                        do_setlink+0x214/0xe20
 [   10.028120]                        __rtnl_newlink+0x514/0x820
 [   10.028120]                        rtnl_newlink+0x58/0x84
 [   10.028121]                        rtnetlink_rcv_msg+0x184/0x4b4
 [   10.028122]                        netlink_rcv_skb+0x60/0x124
 [   10.028122]                        rtnetlink_rcv+0x20/0x30
 [   10.028123]                        netlink_unicast+0x1b4/0x270
 [   10.028124]                        netlink_sendmsg+0x1f0/0x400
 [   10.028124]                        sock_sendmsg+0x5c/0x70
 [   10.028125]                        ____sys_sendmsg+0x24c/0x280
 [   10.028125]                        ___sys_sendmsg+0x88/0xd0
 [   10.028126]                        __sys_sendmsg+0x70/0xd0
 [   10.028127]                        __arm64_sys_sendmsg+0x2c/0x40
 [   10.028128]                        el0_svc_common.constprop.0+0x84/0x200
 [   10.028128]                        do_el0_svc+0x2c/0x90
 [   10.028129]                        el0_svc+0x18/0x50
 [   10.028129]                        el0_sync_handler+0xe0/0x350
 [   10.028130]                        el0_sync+0x158/0x180
 [   10.028130]    IN-SOFTIRQ-W at:
 [   10.028131]                        __lock_acquire+0x894/0x1a94
 [   10.028132]                        lock_acquire.part.0+0x170/0x360
 [   10.028132]                        lock_acquire+0x68/0x8c
 [   10.028133]                        _raw_spin_lock+0x64/0x90
 [   10.028134]                        virtnet_poll_tx+0x84/0x120
 [   10.028134]                        net_rx_action+0x1b0/0x4e0
 [   10.028135]                        __do_softirq+0x1f4/0x638
 [   10.028135]                        do_softirq+0xb8/0xcc
 [   10.028136]                        __local_bh_enable_ip+0x18c/0x200
 [   10.028137]                        virtnet_napi_enable+0xc0/0xd4
 [   10.028137]                        virtnet_open+0x14c/0x1c0
 [   10.028138]                        __dev_open+0x12c/0x200
 [   10.028138]                        __dev_change_flags+0x1a0/0x220
 [   10.028139]                        dev_change_flags+0x2c/0x70
 [   10.028140]                        do_setlink+0x214/0xe20
 [   10.028140]                        __rtnl_newlink+0x514/0x820
 [   10.028141]                        rtnl_newlink+0x58/0x84
 [   10.028141]                        rtnetlink_rcv_msg+0x184/0x4b4
 [   10.028142]                        netlink_rcv_skb+0x60/0x124
 [   10.028142]                        rtnetlink_rcv+0x20/0x30
 [   10.028143]                        netlink_unicast+0x1b4/0x270
 [   10.028144]                        netlink_sendmsg+0x1f0/0x400
 [   10.028144]                        sock_sendmsg+0x5c/0x70
 [   10.028145]                        ____sys_sendmsg+0x24c/0x280
 [   10.028146]                        ___sys_sendmsg+0x88/0xd0
 [   10.028146]                        __sys_sendmsg+0x70/0xd0
 [   10.028147]                        __arm64_sys_sendmsg+0x2c/0x40
 [   10.028148]                        el0_svc_common.constprop.0+0x84/0x200
 [   10.028148]                        do_el0_svc+0x2c/0x90
 [   10.028149]                        el0_svc+0x18/0x50
 [   10.028149]                        el0_sync_handler+0xe0/0x350
 [   10.028150]                        el0_sync+0x158/0x180
 [   10.028150]    INITIAL USE at:
 [   10.028151]                       __lock_acquire+0x2e0/0x1a94
 [   10.028152]                       lock_acquire.part.0+0x170/0x360
 [   10.028153]                       lock_acquire+0x68/0x8c
 [   10.028153]                       _raw_spin_trylock+0x80/0xd0
 [   10.028154]                       virtnet_poll+0xac/0x360
 [   10.028154]                       net_rx_action+0x1b0/0x4e0
 [   10.028155]                       __do_softirq+0x1f4/0x638
 [   10.028155]                       do_softirq+0xb8/0xcc
 [   10.028156]                       __local_bh_enable_ip+0x18c/0x200
 [   10.028157]                       virtnet_napi_enable+0xc0/0xd4
 [   10.028157]                       virtnet_open+0x98/0x1c0
 [   10.028158]                       __dev_open+0x12c/0x200
 [   10.028158]                       __dev_change_flags+0x1a0/0x220
 [   10.028159]                       dev_change_flags+0x2c/0x70
 [   10.028159]                       do_setlink+0x214/0xe20
 [   10.028160]                       __rtnl_newlink+0x514/0x820
 [   10.028161]                       rtnl_newlink+0x58/0x84
 [   10.028161]                       rtnetlink_rcv_msg+0x184/0x4b4
 [   10.028162]                       netlink_rcv_skb+0x60/0x124
 [   10.028162]                       rtnetlink_rcv+0x20/0x30
 [   10.028163]                       netlink_unicast+0x1b4/0x270
 [   10.028163]                       netlink_sendmsg+0x1f0/0x400
 [   10.028164]                       sock_sendmsg+0x5c/0x70
 [   10.028165]                       ____sys_sendmsg+0x24c/0x280
 [   10.028165]                       ___sys_sendmsg+0x88/0xd0
 [   10.028166]                       __sys_sendmsg+0x70/0xd0
 [   10.028166]                       __arm64_sys_sendmsg+0x2c/0x40
 [   10.028167]                       el0_svc_common.constprop.0+0x84/0x200
 [   10.028168]                       do_el0_svc+0x2c/0x90
 [   10.028168]                       el0_svc+0x18/0x50
 [   10.028169]                       el0_sync_handler+0xe0/0x350
 [   10.028169]                       el0_sync+0x158/0x180
 [   10.028170]  }
 [   10.028171]  ... key      at: [<ffff80001312aef8>] netdev_xmit_lock_key+0x10/0x390
 [   10.028171]  ... acquired at:
 [   10.028172]    __lock_acquire+0x134c/0x1a94
 [   10.028172]    lock_acquire.part.0+0x170/0x360
 [   10.028173]    lock_acquire+0x68/0x8c
 [   10.028173]    _raw_spin_lock+0x64/0x90
 [   10.028174]    virtnet_poll_tx+0x84/0x120
 [   10.028174]    netpoll_poll_dev+0x12c/0x350
 [   10.028175]    netpoll_send_skb+0x39c/0x400
 [   10.028175]    netpoll_send_udp+0x2b8/0x440
 [   10.028176]    write_msg+0xfc/0x120 [netconsole]
 [   10.028176]    console_unlock+0x3ec/0x6a4
 [   10.028177]    register_console+0x17c/0x2f4
 [   10.028178]    init_netconsole+0x20c/0x1000 [netconsole]
 [   10.028178]    do_one_initcall+0x8c/0x480
 [   10.028179]    do_init_module+0x60/0x270
 [   10.028179]    load_module+0x21f8/0x2734
 [   10.028180]    __do_sys_finit_module+0xbc/0x12c
 [   10.028180]    __arm64_sys_finit_module+0x28/0x34
 [   10.028181]    el0_svc_common.constprop.0+0x84/0x200
 [   10.028181]    do_el0_svc+0x2c/0x90
 [   10.028182]    el0_svc+0x18/0x50
 [   10.028182]    el0_sync_handler+0xe0/0x350
 [   10.028183]    el0_sync+0x158/0x180
 [   10.028183]
 [   10.028183]
 [   10.028184] stack backtrace:
 [   10.028185] CPU: 14 PID: 638 Comm: modprobe Not tainted 5.10.0-rc4_for_upstream_min_debug_2020_11_22_19_37 #1
 [   10.028186] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 [   10.028186] Call trace:
 [   10.028186]  dump_backtrace+0x0/0x1d0
 [   10.028187]  show_stack+0x20/0x3c
 [   10.028187]  dump_stack+0xec/0x138
 [   10.028188]  check_irq_usage+0x6b8/0x6cc
 [   10.028188]  __lock_acquire+0x134c/0x1a94
 [   10.028189]  lock_acquire.part.0+0x170/0x360
 [   10.028189]  lock_acquire+0x68/0x8c
 [   10.028190]  _raw_spin_lock+0x64/0x90
 [   10.028191]  virtnet_poll_tx+0x84/0x120
 [   10.028191]  netpoll_poll_dev+0x12c/0x350
 [   10.028192]  netpoll_send_skb+0x39c/0x400
 [   10.028192]  netpoll_send_udp+0x2b8/0x440
 [   10.028193]  write_msg+0xfc/0x120 [netconsole]
 [   10.028193]  console_unlock+0x3ec/0x6a4
 [   10.028194]  register_console+0x17c/0x2f4
 [   10.028194]  init_netconsole+0x20c/0x1000 [netconsole]
 [   10.028195]  do_one_initcall+0x8c/0x480
 [   10.028195]  do_init_module+0x60/0x270
 [   10.028196]  load_module+0x21f8/0x2734
 [   10.028197]  __do_sys_finit_module+0xbc/0x12c
 [   10.028197]  __arm64_sys_finit_module+0x28/0x34
 [   10.028198]  el0_svc_common.constprop.0+0x84/0x200
 [   10.028198]  do_el0_svc+0x2c/0x90
 [   10.028199]  el0_svc+0x18/0x50
 [   10.028199]  el0_sync_handler+0xe0/0x350
 [   10.028200]  el0_sync+0x158/0x180
 [   10.073569] random: crng init done
 [   10.073964] printk: console [netcon0] enabled
 [   10.074704] random: 7 urandom warning(s) missed due to ratelimiting
 [   10.075340] netconsole: network logging started

>
> -- Steve
