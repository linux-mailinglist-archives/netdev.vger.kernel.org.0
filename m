Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515D9D93B7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392426AbfJPOZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:25:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:40786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726750AbfJPOZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 10:25:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3437BB44C;
        Wed, 16 Oct 2019 14:25:08 +0000 (UTC)
Date:   Wed, 16 Oct 2019 16:25:01 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 07:16:53PM +0200, Daniel Wagner wrote:
> Could it be that the networking interface is still running (from
> u-boot and PXE) when the drivers is setting it up and the workqueue is
> premature kicked to work?

I've dump the registers before the device is setup and verified with
the manual. So the device is in reset state as documented in the
FIGURE 13-1 http://ww1.microchip.com/downloads/en/DeviceDoc/LAN7800-Data-Sheet-DS00001992G.pdf

After being burned several times I'd like to check such things
first. Anyway, rules out my boot setup.

> Anyway, I keep trying to get some trace out of it.

After adding ignore_loglevel to command line, I finally get the a
trace on the console. Note with the WARN_ON the system boots. Though
there seems to be still something wrong the the network, because there
is no reliable connetion to the NFS server.

[    3.743559] lan78xx 1-1.1.1:1.0 (unnamed net_device) (uninitialized): No External EEPROM. Setting MAC Speed
[    3.754941] libphy: lan78xx-mdiobus: probed
[    3.815609] ------------[ cut here ]------------
[    3.820316] WARNING: CPU: 3 PID: 1 at drivers/net/phy/phy.c:496 phy_queue_state_machine+0xc/0x30
[    3.829226] Modules linked in:
[    3.832329] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc3-00018-g5bc52f64e884-dirty #32
[    3.840974] Hardware name: Raspberry Pi 3 Model B+ (DT)
[    3.846273] pstate: 60000005 (nZCv daif -PAN -UAO)
[    3.851132] pc : phy_queue_state_machine+0xc/0x30
[    3.855903] lr : phy_start+0x88/0xa0
[    3.859524] sp : ffff800010023b80
[    3.862882] x29: ffff800010023b80 x28: ffff000037c34000 
[    3.868270] x27: ffff8000111ac178 x26: 0000000000001002 
[    3.873657] x25: 0000000000000001 x24: 0000000000000000 
[    3.879046] x23: 0000000000001002 x22: ffff800010e3d850 
[    3.884433] x21: ffff000037c34800 x20: ffff000037328438 
[    3.889820] x19: ffff000037328000 x18: 000000000000000e 
[    3.895209] x17: 0000000000000001 x16: 0000000000000019 
[    3.900596] x15: 0000000000000000 x14: 0000000000000000 
[    3.905985] x13: 0000000000000000 x12: 0000000000001da9 
[    3.911372] x11: 0000000000000000 x10: 0000000000000000 
[    3.916759] x9 : ffff0000383b2750 x8 : ffff0000383b1dc0 
[    3.922148] x7 : ffff000037e900c0 x6 : 0000000000000002 
[    3.927535] x5 : 0000000000000001 x4 : ffff000037e90028 
[    3.932923] x3 : 0000000000000000 x2 : 0000000000000001 
[    3.938311] x1 : 0000000000000000 x0 : ffff000037328000 
[    3.943698] Call trace:
[    3.946179]  phy_queue_state_machine+0xc/0x30
[    3.950597]  phy_start+0x88/0xa0
[    3.953870]  lan78xx_open+0x30/0x140
[    3.957499]  __dev_open+0xc0/0x170
[    3.960950]  __dev_change_flags+0x160/0x1b8
[    3.965192]  dev_change_flags+0x20/0x60
[    3.969083]  ip_auto_config+0x254/0xe54
[    3.972974]  do_one_initcall+0x50/0x190
[    3.976865]  kernel_init_freeable+0x194/0x22c
[    3.981285]  kernel_init+0x10/0x100
[    3.984822]  ret_from_fork+0x10/0x18
[    3.988445] ---[ end trace a7b6e745fa28cd56 ]---
[    4.025682] random: crng init done
[    6.401142] ------------[ cut here ]------------
[    6.405854] irq 79 handler irq_default_primary_handler+0x0/0x8 enabled interrupts
[    6.413468] WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x150/0x170
[    6.422642] Modules linked in:
[    6.425744] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.4.0-rc3-00018-g5bc52f64e884-dirty #32
[    6.435799] Hardware name: Raspberry Pi 3 Model B+ (DT)
[    6.441099] pstate: 60000005 (nZCv daif -PAN -UAO)
[    6.445957] pc : __handle_irq_event_percpu+0x150/0x170
[    6.451168] lr : __handle_irq_event_percpu+0x150/0x170
[    6.456375] sp : ffff800010003cc0
[    6.459732] x29: ffff800010003cc0 x28: 0000000000000060 
[    6.465120] x27: ffff8000110929a8 x26: ffff80001192d86b 
[    6.470508] x25: ffff800011782d40 x24: ffff0000374cde00 
[    6.475897] x23: 000000000000004f x22: ffff800010003d64 
[    6.481285] x21: 0000000000000000 x20: 0000000000000002 
[    6.486672] x19: ffff0000372ee180 x18: 0000000000000010 
[    6.492060] x17: 0000000000000001 x16: 0000000000000007 
[    6.497448] x15: ffff8000117831b0 x14: 747075727265746e 
[    6.502835] x13: 692064656c62616e x12: 65203878302f3078 
[    6.508223] x11: 302b72656c646e61 x10: 685f7972616d6972 
[    6.513611] x9 : 705f746c75616665 x8 : ffff800011952000 
[    6.518999] x7 : ffff80001066dce0 x6 : 0000000000000106 
[    6.524387] x5 : 0000000000000000 x4 : 0000000000000000 
[    6.529775] x3 : 00000000ffffffff x2 : ffff800011792440 
[    6.535163] x1 : 190f5ab71e843000 x0 : 0000000000000000 
[    6.540550] Call trace:
[    6.543032]  __handle_irq_event_percpu+0x150/0x170
[    6.547890]  handle_irq_event_percpu+0x30/0x88
[    6.552394]  handle_irq_event+0x44/0xc8
[    6.556283]  handle_simple_irq+0x90/0xc0
[    6.560260]  generic_handle_irq+0x24/0x38
[    6.564328]  intr_complete+0xb0/0xe0
[    6.567955]  __usb_hcd_giveback_urb+0x58/0xf8
[    6.572374]  usb_giveback_urb_bh+0xac/0x108
[    6.576618]  tasklet_action_common.isra.0+0x154/0x1a0
[    6.581742]  tasklet_hi_action+0x24/0x30
[    6.585720]  __do_softirq+0x120/0x23c
[    6.589434]  irq_exit+0xb8/0xd8
[    6.592617]  __handle_domain_irq+0x64/0xb8
[    6.596770]  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
[    6.601892]  el1_irq+0xb8/0x180
[    6.605078]  arch_cpu_idle+0x10/0x18
[    6.608704]  do_idle+0x200/0x280
[    6.611975]  cpu_startup_entry+0x24/0x40
[    6.615954]  rest_init+0xd4/0xe0
[    6.619230]  arch_call_rest_init+0xc/0x14
[    6.623294]  start_kernel+0x420/0x44c
[    6.627004] ---[ end trace a7b6e745fa28cd57 ]---
[    6.631779] ------------[ cut here ]------------
[    6.636476] WARNING: CPU: 2 PID: 129 at drivers/net/phy/phy.c:496 phy_queue_state_machine+0xc/0x30
[    6.645561] Modules linked in:
[    6.648661] CPU: 2 PID: 129 Comm: irq/79-usb-001: Tainted: G        W         5.4.0-rc3-00018-g5bc52f64e884-dirty #32
[    6.659422] Hardware name: Raspberry Pi 3 Model B+ (DT)
[    6.664720] pstate: 40000005 (nZcv daif -PAN -UAO)
[    6.669580] pc : phy_queue_state_machine+0xc/0x30
[    6.674351] lr : phy_interrupt+0x94/0xa8
[    6.678325] sp : ffff800011d43d70
[    6.681682] x29: ffff800011d43d70 x28: ffff0000374b8dc0 
[    6.687071] x27: ffff0000374b8dc0 x26: ffff80001013d670 
[    6.692459] x25: 0000000000000001 x24: ffff80001013d760 
[    6.697848] x23: ffff0000374b8dc0 x22: ffff0000374cde00 
[    6.703235] x21: ffff0000372ee180 x20: ffff0000374cde00 
[    6.708623] x19: ffff000037328000 x18: 0000000000000014 
[    6.714011] x17: 0000000007ec1044 x16: 0000000059730e39 
[    6.719400] x15: 0000000024786c56 x14: 003d090000000000 
[    6.724787] x13: 00003d08ffff9c00 x12: 0000000000000000 
[    6.730175] x11: 0000000000000000 x10: 0000000000000990 
[    6.735564] x9 : ffff800011d43d20 x8 : ffff0000374b97b0 
[    6.740952] x7 : ffff0000383de780 x6 : ffff0000383ddd40 
[    6.746340] x5 : 000000000000b958 x4 : 0000000000000000 
[    6.751728] x3 : 0000000000000000 x2 : ffff8000107af9a0 
[    6.757115] x1 : 0000000000000000 x0 : ffff000037328000 
[    6.762501] Call trace:
[    6.764983]  phy_queue_state_machine+0xc/0x30
[    6.769402]  phy_interrupt+0x94/0xa8
[    6.773027]  irq_thread_fn+0x28/0x98
[    6.776651]  irq_thread+0x148/0x240
[    6.780190]  kthread+0xf0/0x120
[    6.783375]  ret_from_fork+0x10/0x18
[    6.786996] ---[ end trace a7b6e745fa28cd58 ]---
[    6.816767] Sending DHCP requests ..., OK
[   13.644910] IP-Config: Got DHCP answer from 192.168.19.2, my address is 192.168.19.53
[   13.652888] IP-Config: Complete:
[   13.656175]      device=eth0, hwaddr=b8:27:eb:85:c7:c9, ipaddr=192.168.19.53, mask=255.255.255.0, gw=192.168.19.1
[   13.666616]      host=192.168.19.53, domain=, nis-domain=(none)
[   13.672650]      bootserver=192.168.19.2, rootserver=192.168.19.2, rootpath=
[   13.672655]      nameserver0=192.168.19.2
[   13.684179] ALSA device list:
[   13.687214]   No soundcards found.
[   13.700948] VFS: Mounted root (nfs filesystem) on device 0:19.
[   13.707424] devtmpfs: mounted
[   13.716523] Freeing unused kernel memory: 5056K
[   13.736832] Run /sbin/init as init process
[  134.108849] nfs: server 192.168.19.2 not responding, still trying
[  134.108854] nfs: server 192.168.19.2 not responding, still trying
[  134.109781] nfs: server 192.168.19.2 not responding, still trying
[  134.109786] nfs: server 192.168.19.2 OK
[  134.132312] nfs: server 192.168.19.2 not responding, still trying
[  134.132316] nfs: server 192.168.19.2 OK
[  134.143314] nfs: server 192.168.19.2 OK
[  134.143345] nfs: server 192.168.19.2 not responding, still trying
[  134.154328] nfs: server 192.168.19.2 not responding, still trying
[  134.154332] nfs: server 192.168.19.2 OK
[  134.165397] nfs: server 192.168.19.2 OK
[  134.166306] nfs: server 192.168.19.2 OK
[  134.166319] nfs: server 192.168.19.2 OK
[  134.166362] nfs: server 192.168.19.2 OK
[  139.585336] systemd[1]: System time before build time, advancing clock.

Welcome to Debian GNU/Linux 9 (stretch)!
