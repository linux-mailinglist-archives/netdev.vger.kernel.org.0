Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AC02CD1C0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbgLCIvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgLCIvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:51:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333E2C061A4D
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 00:50:22 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kkkJZ-00036l-PQ; Thu, 03 Dec 2020 09:50:13 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kkkJX-0003ti-Nr; Thu, 03 Dec 2020 09:50:11 +0100
Date:   Thu, 3 Dec 2020 09:50:11 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201203085011.GA3606@pengutronix.de>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
 <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:35:24 up 20:59, 34 users,  load average: 1.16, 1.92, 1.89
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub and Andrew,

> Ah, I missed the v3 (like most reviewers it seems :)).

No problem, I moved your replies from v2 tread to this mail.

On Wed, Dec 02, 2020 at 10:42:07AM -0800, Jakub Kicinski wrote:
> On Wed,  2 Dec 2020 15:09:04 +0100 Oleksij Rempel wrote:
> > Add stats support for the ar9331 switch.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

I added dump_stack() to the stats64 function, so we can see how it is
used.

@Andrew

> You could update the stats here, after the interface is down. You then
> know the stats are actually up to date and correct!

stats are automatically read on __dev_notify_flags(), for example here:

[   11.049289] [<80069ce0>] show_stack+0x9c/0x140
[   11.053651] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   11.058820] [<80526584>] dev_get_stats+0x58/0xfc
[   11.063385] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   11.068293] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   11.073274] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   11.078799] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   11.083782] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   11.088378] [<80534380>] __dev_notify_flags+0x50/0xd8
[   11.093365] [<80534ca0>] dev_change_flags+0x60/0x80
[   11.098273] [<80c13fa4>] ic_close_devs+0xcc/0xdc
[   11.102810] [<80c15200>] ip_auto_config+0x1144/0x11e4
[   11.107847] [<80060f14>] do_one_initcall+0x110/0x2b4
[   11.112871] [<80bf31bc>] kernel_init_freeable+0x220/0x258
[   11.118248] [<80739a2c>] kernel_init+0x24/0x11c
[   11.122707] [<8006306c>] ret_from_kernel_thread+0x14/0x1c

Do we really need an extra read within the ar9331 driver?

@Jakub,

> You can't take sleeping locks from .ndo_get_stats64.
> 
> Also regmap may sleep?
> 
> +	ret = regmap_read(priv->regmap, reg, &val);

Yes. And underling layer is mdio bus which is by default sleeping as
well.

> Am I missing something?

In this log, the  ar9331_get_stats64() was never called from atomic or
irq context. Why it should not be sleeping?

[    0.000000] Linux version 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty (ptxdist@ptxdist) (mips-softfloat-linux-gnu-gcc (OSELAS.Toolchain-2020.08.0 10-20200822) 10.2.1 20200822, GNU ld (GNU Binutils) 2.35) #28 PREEMPT 2020-12-03T08:20:00+00:00
[    0.000000] printk: bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019374 (MIPS 24Kc)
[    0.000000] MIPS: machine is DPTechnics DPT-Module
[    0.000000] SoC: Atheros AR9330 rev 1
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x000000001fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000]   node   0: [mem 0x0000000080000000-0x0000000083ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000083ffffff]
[    0.000000] On node 0 totalpages: 16384
[    0.000000]   Normal zone: 1024 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16384 pages, LIFO batch:3
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 15360
[    0.000000] Kernel command line: ip=dhcp root=/dev/nfs nfsroot=192.168.1.100:/home/none/nfsroot/som9331-board,v3,tcp
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes, linear)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes, linear)
[    0.000000] Writing ErrCtl register=00000000
[    0.000000] Readback ErrCtl register=00000000
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 41424K/65536K available (7045K kernel code, 2555K rwdata, 2240K rodata, 1336K init, 6706K bss, 24112K reserved, 0K cma-reserved)
[    0.000000] random: get_random_u32 called from cache_random_seq_create+0xa0/0x198 with crng_init=0
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] ftrace: allocating 22486 entries in 44 pages
[    0.000000] ftrace: allocated 44 pages with 3 groups
[    0.000000] Running RCU self tests
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu: 	RCU lockdep checking is enabled.
[    0.000000] 	Trampoline variant of Tasks RCU enabled.
[    0.000000] 	Rude variant of Tasks RCU enabled.
[    0.000000] 	Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.000000] NR_IRQS: 51
[    0.000000] CPU clock: 400.000 MHz
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 9556302233 ns
[    0.000021] sched_clock: 32 bits at 200MHz, resolution 5ns, wraps every 10737418237ns
[    0.008709] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.015475] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.019645] ... MAX_LOCK_DEPTH:          48
[    0.023728] ... MAX_LOCKDEP_KEYS:        8192
[    0.028071] ... CLASSHASH_SIZE:          4096
[    0.032476] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.036846] ... MAX_LOCKDEP_CHAINS:      65536
[    0.041276] ... CHAINHASH_SIZE:          32768
[    0.045767]  memory used by lock dependency info: 4317 kB
[    0.051092]  memory used for stack traces: 2112 kB
[    0.055932]  per task-struct memory footprint: 2304 bytes
[    0.061438] Calibrating delay loop... 265.42 BogoMIPS (lpj=1327104)
[    0.141175] pid_max: default: 32768 minimum: 301
[    0.147302] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.153243] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.186518] rcu: Hierarchical SRCU implementation.
[    0.201252] devtmpfs: initialized
[    0.257151] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.267232] futex hash table entries: 256 (order: 1, 14336 bytes, linear)
[    0.274830] pinctrl core: initialized pinctrl subsystem
[    0.316846] NET: Registered protocol family 16
[    0.344984] cpuidle: using governor ladder
[    1.008106] clocksource: Switched to clocksource MIPS
[    2.794282] random: fast init done
[    5.314857] NET: Registered protocol family 2
[    5.322775] tcp_listen_portaddr_hash hash table entries: 128 (order: 0, 6656 bytes, linear)
[    5.330472] TCP established hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    5.337413] TCP bind hash table entries: 1024 (order: 3, 49152 bytes, linear)
[    5.345354] TCP: Hash tables configured (established 1024 bind 1024)
[    5.351554] UDP hash table entries: 256 (order: 2, 28672 bytes, linear)
[    5.357671] UDP-Lite hash table entries: 256 (order: 2, 28672 bytes, linear)
[    5.365883] NET: Registered protocol family 1
[    5.371317] RPC: Registered named UNIX socket transport module.
[    5.375822] RPC: Registered udp transport module.
[    5.380882] RPC: Registered tcp transport module.
[    5.385200] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.400983] workingset: timestamp_bits=30 max_order=14 bucket_order=0
[    5.450863] NFS: Registering the id_resolver key type
[    5.454601] Key type id_resolver registered
[    5.459780] Key type id_legacy registered
[    5.463358] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    5.472412] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.480267] io scheduler mq-deadline registered
[    5.483378] io scheduler kyber registered
[    5.505480] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    5.519609] 18020000.serial: ttyATH0 at MMIO 0x18020000 (irq = 9, base_baud = 1562500) is a AR933X UART
[    5.532099] printk: console [ttyATH0] enabled
[    5.539649] printk: bootconsole [early0] disabled
[    5.558790] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
[    5.565214] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
[    5.589324] libphy: Fixed MDIO Bus: probed
[    6.373379] libphy: ag71xx_mdio: probed
[    6.377959] ag71xx 19000000.ethernet eth0: Atheros AG71xx at 0xb9000000, irq 4, mode:mii
[    6.391117] ag71xx 1a000000.ethernet (unnamed net_device) (uninitialized): invalid MAC address, using random address
[    7.082076] libphy: ag71xx_mdio: probed
[    7.093837] ag71xx 1a000000.ethernet eth1: Atheros AG71xx at 0xba000000, irq 5, mode:gmii
[    7.113705] NET: Registered protocol family 10
[    7.125014] Segment Routing with IPv6
[    7.127562] NET: Registered protocol family 17
[    7.133333] 8021q: 802.1Q VLAN Support v1.8
[    7.136246] Key type dns_resolver registered
[    7.143108] batman_adv: B.A.T.M.A.N. advanced 2020.4 (compatibility version 15) loaded
[    7.182826] libphy: switch@10: probed
[    7.203983] ar9331_switch ethernet.1:10: configuring for fixed/gmii link mode
[    7.213026] ar9331_switch ethernet.1:10: Link is Up - 1Gbps/Full - flow control rx/tx
[    7.288774] ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
[    7.306788] CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[    7.316618] Workqueue: events deferred_probe_work_func
[    7.320606] Stack : 80980000 80980000 8089ffb0 80bd0000 00000000 80bc6e20 00000cc0 00000000
[    7.328877]         00000000 800d1268 00000000 ffffffde 00000017 804eea2c 81943908 365b91c5
[    7.337032]         00000000 00000000 8089ffb0 00000000 81943fe0 00000000 00000000 00000000
[    7.345539]         819439b4 809879b0 fffffffd 66657272 80980000 00000000 8092d5e8 80bd0000
[    7.353774]         00000000 80bc6e20 00000cc0 00000000 8097ca9c 365b91c5 00000000 80d40000
[    7.362098]         ...
[    7.364486] Call Trace:
[    7.366940] [<80069ce0>] show_stack+0x9c/0x140
[    7.371432] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[    7.376488] [<80526584>] dev_get_stats+0x58/0xfc
[    7.381173] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[    7.385961] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[    7.391055] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[    7.396468] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[    7.401562] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[    7.406024] [<80536548>] register_netdevice+0x510/0x538
[    7.411302] [<806c1bd4>] dsa_slave_create+0x4c0/0x578
[    7.416296] [<806bc56c>] dsa_register_switch+0x934/0xa20
[    7.421634] [<804ef638>] ar9331_sw_probe+0x364/0x37c
[    7.426524] [<804eb48c>] mdio_probe+0x44/0x70
[    7.430932] [<8049e3b4>] really_probe+0x30c/0x4f4
[    7.435564] [<8049ea10>] driver_probe_device+0x264/0x26c
[    7.440915] [<8049bc10>] bus_for_each_drv+0xb4/0xd8
[    7.445725] [<8049e684>] __device_attach+0xe8/0x18c
[    7.450647] [<8049ce58>] bus_probe_device+0x48/0xc4
[    7.455455] [<8049db70>] deferred_probe_work_func+0xdc/0xf8
[    7.461093] [<8009ff64>] process_one_work+0x2e4/0x4a0
[    7.466059] [<800a0770>] worker_thread+0x2a8/0x354
[    7.470900] [<800a774c>] kthread+0x16c/0x174
[    7.475094] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[    7.480523] 
[    7.558770] ar9331_switch ethernet.1:10 lan1 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:02] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
[    7.578331] CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[    7.586440] Workqueue: events deferred_probe_work_func
[    7.593196] Stack : 80980000 80980000 8089ffb0 80bd0000 00000000 80bc6e20 00000cc0 00000000
[    7.600535]         00000000 800d1268 00000000 ffffffde 00000017 804eea2c 81943908 365b91c5
[    7.608806]         00000000 00000000 8089ffb0 00000000 81943fe0 00000000 00000000 00000000
[    7.616961]         819439b4 809879b0 fffffffd 00000005 80980000 00000000 8092d5e8 80bd0000
[    7.625466]         00000000 80bc6e20 00000cc0 00000000 8097ca9c 365b91c5 00000000 80d40000
[    7.633703]         ...
[    7.636075] Call Trace:
[    7.638582] [<80069ce0>] show_stack+0x9c/0x140
[    7.642965] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[    7.648134] [<80526584>] dev_get_stats+0x58/0xfc
[    7.652705] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[    7.657549] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[    7.662644] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[    7.668113] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[    7.673095] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[    7.677612] [<80536548>] register_netdevice+0x510/0x538
[    7.682891] [<806c1bd4>] dsa_slave_create+0x4c0/0x578
[    7.687886] [<806bc56c>] dsa_register_switch+0x934/0xa20
[    7.693223] [<804ef638>] ar9331_sw_probe+0x364/0x37c
[    7.698169] [<804eb48c>] mdio_probe+0x44/0x70
[    7.702469] [<8049e3b4>] really_probe+0x30c/0x4f4
[    7.707152] [<8049ea10>] driver_probe_device+0x264/0x26c
[    7.712505] [<8049bc10>] bus_for_each_drv+0xb4/0xd8
[    7.717314] [<8049e684>] __device_attach+0xe8/0x18c
[    7.722234] [<8049ce58>] bus_probe_device+0x48/0xc4
[    7.727044] [<8049db70>] deferred_probe_work_func+0xdc/0xf8
[    7.732682] [<8009ff64>] process_one_work+0x2e4/0x4a0
[    7.737646] [<800a0770>] worker_thread+0x2a8/0x354
[    7.742488] [<800a774c>] kthread+0x16c/0x174
[    7.746683] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[    7.752112] 
[    7.755552] DSA: tree 0 setup
[    7.762387] ag71xx 1a000000.ethernet eth1: configuring for fixed/gmii link mode
[    7.772511] ag71xx 1a000000.ethernet eth1: Link is Up - 1Gbps/Full - flow control rx/tx
[    7.858775] ag71xx 19000000.ethernet eth0: PHY [!ahb!ethernet@1a000000!mdio!switch@10:04] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
[    7.871990] ag71xx 19000000.ethernet eth0: configuring for phy/mii link mode
[    7.881779] ar9331_switch ethernet.1:10 lan0: configuring for phy/internal link mode
[    7.890327] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[    7.897953] Stack : 808f0000 80885ffc 818bdaf4 00000000 00000000 9b06e2c0 80980000 818c55c8
[    7.906288]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 818bdaa0 9b06e2c0
[    7.914674]         00000000 00000000 8089ffb0 818bd918 ffffffea 00000000 00000000 00000000
[    7.923014]         818bdb4c 0000004c 00000033 72393333 80980000 00000000 8092d5e8 80bd0000
[    7.931354]         00000000 80bc6e20 00000a20 00000000 00000000 804ee9f4 00000000 80d40000
[    7.939693]         ...
[    7.942082] Call Trace:
[    7.944538] [<80069ce0>] show_stack+0x9c/0x140
[    7.949028] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[    7.954083] [<80526584>] dev_get_stats+0x58/0xfc
[    7.958768] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[    7.963557] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[    7.968650] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[    7.974064] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[    7.979158] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[    7.983642] [<80534380>] __dev_notify_flags+0x50/0xd8
[    7.988714] [<80534ca0>] dev_change_flags+0x60/0x80
[    7.993541] [<80c143c8>] ip_auto_config+0x30c/0x11e4
[    7.998532] [<80060f14>] do_one_initcall+0x110/0x2b4
[    8.003447] [<80bf31bc>] kernel_init_freeable+0x220/0x258
[    8.008878] [<80739a2c>] kernel_init+0x24/0x11c
[    8.013335] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[    8.018764] 
[    8.021475] ar9331_switch ethernet.1:10 lan1: configuring for phy/internal link mode
[    8.031453] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[    8.039179] Stack : 808f0000 80885ffc 818bdaf4 00000000 00000000 9b06e2c0 80980000 818c55c8
[    8.047412]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 818bdaa0 9b06e2c0
[    8.055798]         00000000 00000000 8089ffb0 818bd918 ffffffea 00000000 00000000 00000000
[    8.064139]         818bdb4c 0000004c 00000033 72393333 80980000 00000000 8092d5e8 80bd0000
[    8.072477]         00000000 80bc6e20 00000a20 00000000 00000000 804ee9f4 00000000 80d40000
[    8.080940]         ...
[    8.083205] Call Trace:
[    8.085659] [<80069ce0>] show_stack+0x9c/0x140
[    8.090182] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[    8.095206] [<80526584>] dev_get_stats+0x58/0xfc
[    8.099886] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[    8.104679] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[    8.109774] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[    8.115188] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[    8.120281] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[    8.124762] [<80534380>] __dev_notify_flags+0x50/0xd8
[    8.129838] [<80534ca0>] dev_change_flags+0x60/0x80
[    8.134662] [<80c143c8>] ip_auto_config+0x30c/0x11e4
[    8.139655] [<80060f14>] do_one_initcall+0x110/0x2b4
[    8.144567] [<80bf31bc>] kernel_init_freeable+0x220/0x258
[    8.150000] [<80739a2c>] kernel_init+0x24/0x11c
[    8.154458] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[    8.159888] 
[    8.188460] Sending DHCP requests .
[    8.965250] ar9331_switch ethernet.1:10 lan1: Link is Up - 100Mbps/Full - flow control rx/tx
[    8.978440] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
[    8.983872] CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[    8.992995] Workqueue: events linkwatch_event
[    8.997091] Stack : 80980000 80980000 8089ffb0 80bd0000 00000000 80bc6e20 00000cc0 00000000
[    9.005495]         00000000 800d1268 00000000 ffffffde 00000017 804eea2c 81943b30 365b91c5
[    9.013877]         00000000 00000000 8089ffb0 81943990 ffffffea 00000000 00000000 00000000
[    9.022184]         81943bdc ffffffff 00000000 6e6b7761 80980000 00000000 8092d5e8 80bd0000
[    9.030558]         00000000 80bc6e20 00000cc0 00000000 00000000 365b91c5 00000000 80d40000
[    9.038853]         ...
[    9.041224] Call Trace:
[    9.043674] [<80069ce0>] show_stack+0x9c/0x140
[    9.048233] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[    9.053225] [<80526584>] dev_get_stats+0x58/0xfc
[    9.057850] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[    9.062764] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[    9.067734] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[    9.073324] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[    9.078602] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[    9.082769] [<80529d38>] netdev_state_change+0x70/0x98
[    9.087887] [<8054b688>] linkwatch_do_dev+0x7c/0xb8
[    9.093020] [<8054b890>] __linkwatch_run_queue+0xd4/0x20c
[    9.098368] [<8054ba04>] linkwatch_event+0x3c/0x48
[    9.102940] [<8009ff64>] process_one_work+0x2e4/0x4a0
[    9.107959] [<800a0770>] worker_thread+0x2a8/0x354
[    9.112937] [<800a774c>] kthread+0x16c/0x174
[    9.116996] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[    9.122445] 
[    9.285927] ag71xx 19000000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
[    9.294386] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.768065] ., OK
[   10.808789] IP-Config: Got DHCP answer from 192.168.1.100, my address is 192.168.1.87
[   10.816457] IP-Config: Complete:
[   10.820388]      device=eth0, hwaddr=00:03:7f:be:f4:57, ipaddr=192.168.1.87, mask=255.255.255.0, gw=192.168.1.100
[   10.830141]      host=192.168.1.87, domain=example.org, nis-domain=(none)
[   10.836703]      bootserver=192.168.1.100, rootserver=192.168.1.100, rootpath=
[   10.836724]      nameserver0=192.168.1.100
[   10.850094] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   10.857725] Stack : 808f0000 80885ffc 818bdac4 00000000 00000000 9b06e2c0 80980000 818c55c8
[   10.866295]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 818bda70 9b06e2c0
[   10.874551]         00000000 00000000 8089ffb0 818bd8e8 ffffffea 00000000 00000000 00000000
[   10.882873]         818bdb1c 80987858 fffffffd 72393333 80980000 00000000 8092d5e8 80bd0000
[   10.891131]         00000000 80bc6e20 00000a20 00000000 00000000 804ee9f4 00000000 80d40000
[   10.899461]         ...
[   10.901850] Call Trace:
[   10.904306] [<80069ce0>] show_stack+0x9c/0x140
[   10.908798] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   10.913852] [<80526584>] dev_get_stats+0x58/0xfc
[   10.918646] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   10.923326] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   10.928437] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   10.933833] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   10.938926] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   10.943410] [<80534380>] __dev_notify_flags+0x50/0xd8
[   10.948484] [<80534ca0>] dev_change_flags+0x60/0x80
[   10.953309] [<80c13fa4>] ic_close_devs+0xcc/0xdc
[   10.957899] [<80c15200>] ip_auto_config+0x1144/0x11e4
[   10.962995] [<80060f14>] do_one_initcall+0x110/0x2b4
[   10.967906] [<80bf31bc>] kernel_init_freeable+0x220/0x258
[   10.973337] [<80739a2c>] kernel_init+0x24/0x11c
[   10.977796] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[   10.983225] 
[   10.987029] ar9331_switch ethernet.1:10 lan1: Link is Down
[   10.995008] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   11.002737] Stack : 808f0000 80885ffc 818bdac4 00000000 00000000 9b06e2c0 80980000 818c55c8
[   11.011134]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 818bda70 9b06e2c0
[   11.019481]         00000000 00000000 8089ffb0 818bd8e8 ffffffea 00000000 00000000 00000000
[   11.027648]         818bdb1c 80987858 fffffffd 72393333 80980000 00000000 8092d5e8 80bd0000
[   11.036141]         00000000 80bc6e20 00000a20 00000000 00000000 804ee9f4 00000000 80d40000
[   11.044520]         ...
[   11.046762] Call Trace:
[   11.049289] [<80069ce0>] show_stack+0x9c/0x140
[   11.053651] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   11.058820] [<80526584>] dev_get_stats+0x58/0xfc
[   11.063385] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   11.068293] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   11.073274] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   11.078799] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   11.083782] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   11.088378] [<80534380>] __dev_notify_flags+0x50/0xd8
[   11.093365] [<80534ca0>] dev_change_flags+0x60/0x80
[   11.098273] [<80c13fa4>] ic_close_devs+0xcc/0xdc
[   11.102810] [<80c15200>] ip_auto_config+0x1144/0x11e4
[   11.107847] [<80060f14>] do_one_initcall+0x110/0x2b4
[   11.112871] [<80bf31bc>] kernel_init_freeable+0x220/0x258
[   11.118248] [<80739a2c>] kernel_init+0x24/0x11c
[   11.122707] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[   11.128150] 
[   11.163593] VFS: Mounted root (nfs filesystem) readonly on device 0:11.
[   11.172370] devtmpfs: mounted
[   11.223234] Freeing unused kernel memory: 1336K
[   11.226348] This architecture does not have kernel memory protection.
[   11.232897] Run /sbin/init as init process
[   11.236859]   with arguments:
[   11.239863]     /sbin/init
[   11.242501]   with environment:
[   11.245630]     HOME=/
[   11.247974]     TERM=linux
[   12.999446] systemd[1]: System time before build time, advancing clock.
[   13.458800] systemd[1]: systemd 246.3 running in system mode. (-PAM -AUDIT -SELINUX -IMA -APPARMOR -SMACK -SYSVINIT -UTMP -LIBCRYPTSETUP -GCRYPT -GNUTLS -ACL -XZ +LZ4 +ZSTD +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 -IDN -PCRE2 default-hierarchy=unified)
[   13.481353] systemd[1]: Detected architecture mips.
[   13.564447] systemd[1]: Set hostname to <AccessBox>.
[   15.915796] systemd[1]: Queued start job for default target multi-user.target.
[   15.935214] random: systemd: uninitialized urandom read (16 bytes read)
[   15.950998] systemd[1]: Created slice system-serial\x2dgetty.slice.
[   15.965076] random: systemd: uninitialized urandom read (16 bytes read)
[   15.970916] systemd[1]: Reached target paths.target.
[   16.039242] random: systemd: uninitialized urandom read (16 bytes read)
[   16.044713] systemd[1]: Reached target remote-fs.target.
[   16.109136] systemd[1]: Reached target slices.target.
[   16.179490] systemd[1]: Reached target swap.target.
[   16.296748] systemd[1]: Listening on systemd-coredump.socket.
[   16.399675] systemd[1]: Condition check resulted in systemd-journald-audit.socket being skipped.
[   16.414345] systemd[1]: Listening on systemd-journald-dev-log.socket.
[   16.482298] systemd[1]: Listening on systemd-journald.socket.
[   16.554415] systemd[1]: Listening on systemd-networkd.socket.
[   16.625357] systemd[1]: Listening on systemd-udevd-control.socket.
[   16.691077] systemd[1]: Listening on systemd-udevd-kernel.socket.
[   16.761941] systemd[1]: Condition check resulted in dev-hugepages.mount being skipped.
[   16.771550] systemd[1]: Condition check resulted in dev-mqueue.mount being skipped.
[   16.789492] systemd[1]: Mounting sys-kernel-debug.mount...
[   16.881382] systemd[1]: Mounting sys-kernel-tracing.mount...
[   16.974520] systemd[1]: Starting kmod-static-nodes.service...
[   17.076169] systemd[1]: Starting systemd-journald.service...
[   17.160586] systemd[1]: Condition check resulted in systemd-modules-load.service being skipped.
[   17.181747] systemd[1]: Condition check resulted in sys-fs-fuse-connections.mount being skipped.
[   17.201014] systemd[1]: Condition check resulted in sys-kernel-config.mount being skipped.
[   17.250839] systemd[1]: Starting systemd-remount-fs.service...
[   17.370692] systemd[1]: Starting systemd-sysctl.service...
[   17.496266] systemd[1]: Starting systemd-udev-trigger.service...
[   17.715202] systemd[1]: Mounted sys-kernel-debug.mount.
[   17.852047] systemd[1]: Mounted sys-kernel-tracing.mount.
[   18.006398] systemd[1]: Finished kmod-static-nodes.service.
[   18.170651] systemd[1]: Starting systemd-tmpfiles-setup-dev.service...
[   18.290900] systemd[1]: Finished systemd-remount-fs.service.
[   18.408573] systemd[1]: Finished systemd-sysctl.service.
[   18.898580] systemd[1]: Finished systemd-tmpfiles-setup-dev.service.
[   18.981444] systemd[1]: Reached target local-fs-pre.target.
[   19.094770] systemd[1]: Mounting tmp.mount...
[   19.199189] systemd[1]: var.mount: Directory /var to mount over is not empty, mounting anyway.
[   19.225148] systemd[1]: Mounting var.mount...
[   19.461304] systemd[1]: Starting systemd-udevd.service...
[   19.736222] systemd[1]: Mounted tmp.mount.
[   20.501277] systemd[1]: Mounting run-varoverlayfs.mount...
[   20.686990] systemd[1]: Mounted run-varoverlayfs.mount.
[   21.760832] systemd[1]: Unmounting run-varoverlayfs.mount...
[   21.988694] systemd[1]: Started systemd-journald.service.
[   25.103434] CPU: 0 PID: 558 Comm: systemd-udevd Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   25.238275] Stack : 808f0000 80885ffc 821c7a0c 00000000 00000000 92cedeab 80980000 81b193c8
[   25.245369]         80980ca7 80d43358 00000000 821b3000 ffffffff 804eea2c 821c79b8 92cedeab
[   25.408200]         00000000 00000000 8089ffb0 00000000 821c7fe0 00000000 00000000 00000000
[   25.415282]         821c7a64 00000007 00000005 00000000 80980000 80000000 8092d5e8 80bd0000
[   25.574160]         00000000 821b3000 ffffffff 00000000 8097ca9c 92cedeab 00000000 80d40000
[   25.648289]         ...
[   25.649354] Call Trace:
[   25.651810] [<80069ce0>] show_stack+0x9c/0x140
[   25.656244] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   25.788333] [<80526584>] dev_get_stats+0x58/0xfc
[   25.791569] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   25.796411] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   25.891720] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   25.895018] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   25.951801] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   25.956011] [<80591190>] netlink_unicast+0x154/0x200
[   26.013389] [<80591578>] netlink_sendmsg+0x33c/0x374
[   26.017707] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   26.071923] [<80509038>] __sys_sendto+0xdc/0x128
[   26.075157] [<80071aa4>] syscall_common+0x34/0x58
[   26.118366] 
[   26.122380] CPU: 0 PID: 559 Comm: systemd-udevd Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   26.158313] Stack : 808f0000 80885ffc 82323a0c 00000000 00000000 accd16e0 80980000 81b18348
[   26.165407]         80980ca7 80d43358 00000000 821b3cc0 ffffffff 804eea2c 823239b8 accd16e0
[   26.228272]         00000000 00000000 8089ffb0 00000000 82323fe0 00000000 00000000 00000000
[   26.235355]         82323a64 9777010b 00000001 00000000 80980000 80000000 8092d5e8 80bd0000
[   26.288310]         00000000 821b3cc0 ffffffff 00000000 8097ca9c accd16e0 00000000 80d40000
[   26.295401]         ...
[   26.297834] Call Trace:
[   26.348262] [<80069ce0>] show_stack+0x9c/0x140
[   26.351311] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   26.356419] [<80526584>] dev_get_stats+0x58/0xfc
[   26.398351] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   26.401826] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   26.406857] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   26.448346] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   26.452093] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   26.456940] [<80591190>] netlink_unicast+0x154/0x200
[   26.518265] [<80591578>] netlink_sendmsg+0x33c/0x374
[   26.521836] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   26.526867] [<80509038>] __sys_sendto+0xdc/0x128
[   26.558261] [<80071aa4>] syscall_common+0x34/0x58
[   26.561563] 
[   26.572134] CPU: 0 PID: 558 Comm: systemd-udevd Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   26.618463] Stack : 808f0000 80885ffc 821c7a0c 00000000 00000000 92cedeab 80980000 81b193c8
[   26.625550]         80980ca7 80d43358 00000000 821b3540 ffffffff 804eea2c 821c79b8 92cedeab
[   26.678342]         00000000 00000000 8089ffb0 00000000 821c7fe0 00000000 00000000 00000000
[   26.685431]         821c7a64 808e457c 00000007 00000000 80980000 80000000 8092d5e8 80bd0000
[   26.718203]         00000000 821b3540 ffffffff 00000000 8097ca9c 92cedeab 00000000 80d40000
[   26.725288]         ...
[   26.727722] Call Trace:
[   26.758292] [<80069ce0>] show_stack+0x9c/0x140
[   26.761350] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   26.766456] [<80526584>] dev_get_stats+0x58/0xfc
[   26.808277] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   26.811760] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   26.816790] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   26.848285] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   26.852035] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   26.856881] [<80591190>] netlink_unicast+0x154/0x200
[   26.888297] [<80591578>] netlink_sendmsg+0x33c/0x374
[   26.891870] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   26.896900] [<80509038>] __sys_sendto+0xdc/0x128
[   26.938270] [<80071aa4>] syscall_common+0x34/0x58
[   26.941566] 
[   26.953297] CPU: 0 PID: 559 Comm: systemd-udevd Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   27.010784] Stack : 808f0000 80885ffc 82323a0c 00000000 00000000 accd16e0 80980000 81b18348
[   27.017874]         80980ca7 80d43358 00000000 821b3000 ffffffff 804eea2c 823239b8 accd16e0
[   27.045205]         00000000 00000000 8089ffb0 00000000 82323fe0 00000000 00000000 00000000
[   27.090415]         82323a64 77b11dc0 00000000 77e739a0 80980000 80000000 8092d5e8 80bd0000
[   27.105401]         00000000 821b3000 ffffffff 00000000 8097ca9c accd16e0 00084a1f 00000001
[   27.170328]         ...
[   27.171923] Call Trace:
[   27.173854] [<80069ce0>] show_stack+0x9c/0x140
[   27.218222] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   27.221956] [<80526584>] dev_get_stats+0x58/0xfc
[   27.226577] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   27.268363] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   27.272011] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   27.276699] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   27.318350] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   27.321826] [<80591190>] netlink_unicast+0x154/0x200
[   27.326773] [<80591578>] netlink_sendmsg+0x33c/0x374
[   27.378217] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   27.381866] [<80509038>] __sys_sendto+0xdc/0x128
[   27.386476] [<80071aa4>] syscall_common+0x34/0x58
[   27.441718] 
[   28.638918] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   28.658222] Stack : 808f0000 80885ffc 82195994 00000000 00000000 dad083d8 80980000 81b1e648
[   28.665309]         80980ca7 80d43358 00000000 82218200 00000000 804eea2c 82195940 dad083d8
[   28.698176]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   28.705262]         821959ec 80987858 fffffffd 77ad30bc 80980000 80000000 8092d5e8 80bd0000
[   28.728221]         00000000 82218200 00000000 00000000 8097ca9c dad083d8 00000000 80d40000
[   28.735310]         ...
[   28.737744] Call Trace:
[   28.758277] [<80069ce0>] show_stack+0x9c/0x140
[   28.761326] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   28.766433] [<80526584>] dev_get_stats+0x58/0xfc
[   28.786022] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   28.790931] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   28.794575] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   28.808338] [<8058f418>] netlink_dump+0x188/0x338
[   28.811640] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   28.816595] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   28.838276] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   28.841577] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   28.846191] [<80071aa4>] syscall_common+0x34/0x58
[   28.868233] 
[   28.870809] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   28.898220] Stack : 808f0000 80885ffc 82195994 00000000 00000000 dad083d8 80980000 81b1e648
[   28.905310]         80980ca7 80d43358 00000000 82218200 00000000 804eea2c 82195940 dad083d8
[   28.928217]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   28.935298]         821959ec 00000007 00000000 00000000 80980000 80000000 8092d5e8 80bd0000
[   28.962561]         00000000 82218200 00000000 00000000 8097ca9c dad083d8 00000000 80d40000
[   28.988264]         ...
[   28.989326] Call Trace:
[   28.991783] [<80069ce0>] show_stack+0x9c/0x140
[   28.996217] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   29.018881] [<80526584>] dev_get_stats+0x58/0xfc
[   29.022111] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   29.026958] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   29.048236] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   29.051897] [<8058f418>] netlink_dump+0x188/0x338
[   29.056571] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   29.078267] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   29.081749] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   29.086430] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   29.098305] [<80071aa4>] syscall_common+0x34/0x58
[   29.101600] 
[   29.104383] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   29.138125] Stack : 808f0000 80885ffc 82195994 00000000 00000000 dad083d8 80980000 81b1e648
[   29.145217]         80980ca7 80d43358 00000000 82218200 00000000 804eea2c 82195940 dad083d8
[   29.168214]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   29.175299]         821959ec 00000007 00000000 00000000 80980000 80000000 8092d5e8 80bd0000
[   29.208158]         00000000 82218200 00000000 00000000 8097ca9c dad083d8 00000000 80d40000
[   29.215243]         ...
[   29.217678] Call Trace:
[   29.228269] [<80069ce0>] show_stack+0x9c/0x140
[   29.231323] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   29.236430] [<80526584>] dev_get_stats+0x58/0xfc
[   29.258373] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   29.261850] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   29.266878] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   29.277702] [<8058f418>] netlink_dump+0x188/0x338
[   29.285232] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   29.291673] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   29.296643] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   29.309710] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   29.319552] [<80071aa4>] syscall_common+0x34/0x58
[   29.322846] 
[   29.396059] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   29.407030] Stack : 808f0000 80885ffc 82195a0c 00000000 00000000 dad083d8 80980000 81b1e648
[   29.430248]         80980ca7 80d43358 00000000 819bcc00 ffffffff 804eea2c 821959b8 dad083d8
[   29.443605]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   29.457756]         82195a64 000d5102 00000000 00000000 80980000 80000000 8092d5e8 80bd0000
[   29.469324]         00000000 819bcc00 ffffffff 00000000 8097ca9c dad083d8 00000000 80d40000
[   29.481601]         ...
[   29.485120] Call Trace:
[   29.487370] [<80069ce0>] show_stack+0x9c/0x140
[   29.496608] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   29.503160] [<80526584>] dev_get_stats+0x58/0xfc
[   29.510455] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   29.517564] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   29.538385] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   29.541687] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   29.546818] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   29.568620] [<80591190>] netlink_unicast+0x154/0x200
[   29.572179] [<80591578>] netlink_sendmsg+0x33c/0x374
[   29.577134] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   29.598241] [<80509038>] __sys_sendto+0xdc/0x128
[   29.601468] [<80071aa4>] syscall_common+0x34/0x58
[   29.607616] 
[   29.625134] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   29.658330] Stack : 808f0000 80885ffc 82195a0c 00000000 00000000 dad083d8 80980000 81b1e648
[   29.665423]         80980ca7 80d43358 00000000 819bcd80 ffffffff 804eea2c 821959b8 dad083d8
[   29.682160]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   29.699257]         82195a64 7d3d3ae5 74e00000 00000000 80980000 80000000 8092d5e8 80bd0000
[   29.720074]         00000000 819bcd80 ffffffff 00000000 8097ca9c dad083d8 00000000 80d40000
[   29.732223]         ...
[   29.733282] Call Trace:
[   29.735738] [<80069ce0>] show_stack+0x9c/0x140
[   29.743452] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   29.747182] [<80526584>] dev_get_stats+0x58/0xfc
[   29.754403] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   29.757880] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   29.765705] [<805498f4>] rtnl_getlink+0x2ac/0x36c
[   29.770336] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   29.774142] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   29.781229] [<80591190>] netlink_unicast+0x154/0x200
[   29.784790] [<80591578>] netlink_sendmsg+0x33c/0x374
[   29.797947] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   29.803937] [<80509038>] __sys_sendto+0xdc/0x128
[   29.807947] [<80071aa4>] syscall_common+0x34/0x58
[   29.819952] 
[   30.027065] ar9331_switch ethernet.1:10 lan1: configuring for phy/internal link mode
[   30.047116] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   30.055929] Stack : 808f0000 80885ffc 82195884 00000000 00000000 dad083d8 80980000 81b1e648
[   30.066504]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 82195830 dad083d8
[   30.074972]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   30.083455]         821958dc 0000004c 00000033 6262372d 80980000 80000000 8092d5e8 80bd0000
[   30.094397]         00000000 80bc6e20 00000a20 00000000 8097ca9c dad083d8 00000000 80d40000
[   30.106987]         ...
[   30.120557] Call Trace:
[   30.122764] [<80069ce0>] show_stack+0x9c/0x140
[   30.127194] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   30.136087] [<80526584>] dev_get_stats+0x58/0xfc
[   30.141248] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   30.145433] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   30.152730] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   30.156809] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   30.164125] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   30.167274] [<80534380>] __dev_notify_flags+0x50/0xd8
[   30.174629] [<80534ca0>] dev_change_flags+0x60/0x80
[   30.179482] [<80546710>] do_setlink+0x540/0x924
[   30.182618] [<80548e84>] rtnl_setlink+0xe8/0x158
[   30.187220] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   30.195546] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   30.204900] [<80591190>] netlink_unicast+0x154/0x200
[   30.211884] [<80591578>] netlink_sendmsg+0x33c/0x374
[   30.228391] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   30.232047] [<80509038>] __sys_sendto+0xdc/0x128
[   30.236657] [<80071aa4>] syscall_common+0x34/0x58
[   30.248792] 
[   30.257851] ar9331_switch ethernet.1:10 lan0: configuring for phy/internal link mode
[   30.288020] CPU: 0 PID: 556 Comm: systemd-network Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   30.299406] Stack : 808f0000 80885ffc 82195884 00000000 00000000 dad083d8 80980000 81b1e648
[   30.307244]         80980ca7 80d43358 00000000 80bc6e20 00000a20 804eea2c 82195830 dad083d8
[   30.317863]         00000000 00000000 8089ffb0 00000000 82195fe0 00000000 00000000 00000000
[   30.325293]         821958dc 0000004c 00000033 6262372d 80980000 80000000 8092d5e8 80bd0000
[   30.335871]         00000000 80bc6e20 00000a20 00000000 8097ca9c dad083d8 00000000 80d40000
[   30.344360]         ...
[   30.345418] Call Trace:
[   30.347874] [<80069ce0>] show_stack+0x9c/0x140
[   30.361686] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   30.366528] [<80526584>] dev_get_stats+0x58/0xfc
[   30.375877] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   30.381540] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   30.385190] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   30.392930] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   30.396574] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   30.403442] [<80534380>] __dev_notify_flags+0x50/0xd8
[   30.407088] [<80534ca0>] dev_change_flags+0x60/0x80
[   30.414301] [<80546710>] do_setlink+0x540/0x924
[   30.417423] [<80548e84>] rtnl_setlink+0xe8/0x158
[   30.424427] [<805484c8>] rtnetlink_rcv_msg+0x2d8/0x338
[   30.434132] [<805919bc>] netlink_rcv_skb+0xc4/0x148
[   30.438008] [<80591190>] netlink_unicast+0x154/0x200
[   30.444398] [<80591578>] netlink_sendmsg+0x33c/0x374
[   30.450850] [<805067fc>] sock_sendmsg_nosec+0x1c/0x40
[   30.455473] [<80509038>] __sys_sendto+0xdc/0x128
[   30.462351] [<80071aa4>] syscall_common+0x34/0x58
[   30.465648] 
[   31.547591] ar9331_switch ethernet.1:10 lan1: Link is Up - 100Mbps/Full - flow control rx/tx
[   31.590784] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
[   31.633871] CPU: 0 PID: 335 Comm: kworker/0:2 Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   31.668169] Workqueue: events linkwatch_event
[   31.671131] Stack : 80980000 80980000 8089ffb0 80bd0000 00000000 80bc6e20 00000cc0 00000000
[   31.698212]         00000000 800d1268 00000000 ffffffde 00000017 804eea2c 81b4db30 be8417ff
[   31.705304]         00000000 00000000 8089ffb0 81b4d990 ffffffea 00000000 00000000 00000000
[   31.768311]         81b4dbdc 000017c4 0000001d 6e6b7761 80980000 00000000 8092d5e8 80bd0000
[   31.775399]         00000000 80bc6e20 00000cc0 00000000 00000000 be8417ff 00000000 80d40000
[   31.814234]         ...
[   31.815504] Call Trace:
[   31.817961] [<80069ce0>] show_stack+0x9c/0x140
[   31.839487] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   31.860041] [<80526584>] dev_get_stats+0x58/0xfc
[   31.865785] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   31.891483] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   31.895133] [<8054a4d4>] rtmsg_ifinfo_build_skb+0xbc/0x134
[   31.919685] [<8054a5d4>] rtmsg_ifinfo_event+0x4c/0x84
[   31.929505] [<8054a6c8>] rtmsg_ifinfo+0x2c/0x38
[   31.932644] [<80529d38>] netdev_state_change+0x70/0x98
[   31.937757] [<8054b688>] linkwatch_do_dev+0x7c/0xb8
[   31.968371] [<8054b890>] __linkwatch_run_queue+0xd4/0x20c
[   31.972368] [<8054ba04>] linkwatch_event+0x3c/0x48
[   31.977171] [<8009ff64>] process_one_work+0x2e4/0x4a0
[   31.998383] [<800a0770>] worker_thread+0x2a8/0x354
[   32.001781] [<800a774c>] kthread+0x16c/0x174
[   32.006027] [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[   32.028330] 
[   34.423264] random: crng init done
[   34.426731] random: 7 urandom warning(s) missed due to ratelimiting
[   34.827026] CPU: 0 PID: 574 Comm: systemd-resolve Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   34.835835] Stack : 808f0000 80885ffc 8237f994 00000000 00000000 dbbe505e 80980000 82304548
[   34.846348]         80980ca7 80d43358 00000000 82218800 00000000 804eea2c 8237f940 dbbe505e
[   34.855271]         00000000 00000000 8089ffb0 00000000 8237ffe0 00000000 00000000 00000000
[   34.863654]         8237f9ec 77ad5030 00000000 6262372d 80980000 80000000 8092d5e8 80bd0000
[   34.872116]         00000000 82218800 00000000 00000000 8097ca9c dbbe505e 00000000 80d40000
[   34.880567]         ...
[   34.881628] Call Trace:
[   34.884085] [<80069ce0>] show_stack+0x9c/0x140
[   34.891666] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   34.895398] [<80526584>] dev_get_stats+0x58/0xfc
[   34.902311] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   34.905784] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   34.913108] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   34.916764] [<8058f418>] netlink_dump+0x188/0x338
[   34.928396] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   34.931961] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   34.936819] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   34.949532] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   34.952756] [<80071aa4>] syscall_common+0x34/0x58
[   34.957427] 
[   34.962234] CPU: 0 PID: 574 Comm: systemd-resolve Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   34.972517] Stack : 808f0000 80885ffc 8237f994 00000000 00000000 dbbe505e 80980000 82304548
[   34.983372]         80980ca7 80d43358 00000000 82218800 00000000 804eea2c 8237f940 dbbe505e
[   34.991832]         00000000 00000000 8089ffb0 00000000 8237ffe0 00000000 00000000 00000000
[   35.000212]         8237f9ec 08000000 03bd0000 6262372d 80980000 80000000 8092d5e8 80bd0000
[   35.007297]         00000000 82218800 00000000 00000000 8097ca9c dbbe505e 00000000 80d40000
[   35.017904]         ...
[   35.020298] Call Trace:
[   35.021426] [<80069ce0>] show_stack+0x9c/0x140
[   35.025855] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   35.034126] [<80526584>] dev_get_stats+0x58/0xfc
[   35.037358] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   35.044712] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   35.049734] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   35.053403] [<8058f418>] netlink_dump+0x188/0x338
[   35.060232] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   35.063799] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   35.070851] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   35.074149] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   35.081067] [<80071aa4>] syscall_common+0x34/0x58
[   35.084360] 
[   35.087198] CPU: 0 PID: 574 Comm: systemd-resolve Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[   35.100389] Stack : 808f0000 80885ffc 8237f994 00000000 00000000 dbbe505e 80980000 82304548
[   35.107477]         80980ca7 80d43358 00000000 82218800 00000000 804eea2c 8237f940 dbbe505e
[   35.117978]         00000000 00000000 8089ffb0 00000000 8237ffe0 00000000 00000000 00000000
[   35.125354]         8237f9ec 77bbfdc0 56c32450 77e859a0 80980000 80000000 8092d5e8 80bd0000
[   35.135694]         00000000 82218800 00000000 00000000 8097ca9c dbbe505e 000859df 00000001
[   35.144054]         ...
[   35.145208] Call Trace:
[   35.147664] [<80069ce0>] show_stack+0x9c/0x140
[   35.155190] [<804eea2c>] ar9331_get_stats64+0x38/0x394
[   35.160297] [<80526584>] dev_get_stats+0x58/0xfc
[   35.163550] [<805428c8>] rtnl_fill_stats+0x6c/0x14c
[   35.170840] [<8054703c>] rtnl_fill_ifinfo+0x548/0xcec
[   35.174482] [<80547b88>] rtnl_dump_ifinfo+0x3a8/0x498
[   35.182042] [<8058f418>] netlink_dump+0x188/0x338
[   35.185345] [<8058f7b8>] netlink_recvmsg+0x1f0/0x354
[   35.192736] [<80506ad0>] ____sys_recvmsg+0x8c/0x128
[   35.196216] [<805098c8>] ___sys_recvmsg+0x84/0xc8
[   35.203120] [<8050a0a4>] __sys_recvmsg+0x64/0xa4
[   35.206346] [<80071aa4>] syscall_common+0x34/0x58
 
Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
