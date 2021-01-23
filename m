Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B7A3012EC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhAWECs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:02:48 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:41356 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbhAWECn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 23:02:43 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 4923E82100;
        Sat, 23 Jan 2021 07:02:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611374538; bh=WHEh+0qCimHzSrX83j5XvO6M/LtzwPinUAoYjgm/CkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+Rvbqx+bPJnsrr0IyrIjkuMUHQ4oKrnkrWxL9AKKH4nZ/Wj11Fu24xQ8ramyawOU
         zidNKvntOE/wOc3BqEbdSoXhgtk9DfLzWZLqMYOvA9lfUkm4RPIwpMWxwwj0pYUufB
         twHDXl0d/ArXOnLY85m+GDpNzWz/4afOtk55+VI6T4MT4mimue13xZ7Dsho4Nodo54
         ZxoBqgFDBMXfgnZoaLWbnWbMzlYRjAx9Y/hXyAwKLbbSK1CR2Okwqj27nl3Bp3xLYh
         L8IF8eDOInABI4VSSoYt6CPYMKzobrXKgy3FPi5ePSXHhFTaP+7GxbHjZ8tk3yURHE
         NDJPevqxuXuvA==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Date:   Sat, 23 Jan 2021 07:01:26 +0300
Message-ID: <4350412.Q8nadHgH4j@metabook>
In-Reply-To: <YAt8trmR1FjGnCeF@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su> <4496952.bab7Homqhv@metabook> <YAt8trmR1FjGnCeF@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

resending answer to all:
On Saturday, January 23, 2021 4:32:38 AM MSK Andrew Lunn wrote:
> > it migth be helpful for developers work on userspace networking tools with
> > PHY-less lan743x
> 
> (the interface even could not be brought up)
> 
> > of course, there nothing much to do without TP port but the difference is
> > representative.
> > 
> > sbauer@metamini ~$ sudo ethtool eth7
> > Settings for eth7:
> > Cannot get device settings: No such device
> > 
> >         Supports Wake-on: pumbag
> >         Wake-on: d
> >         Current message level: 0x00000137 (311)
> >         
> >                                drv probe link ifdown ifup tx_queued
> >         
> >         Link detected: no
> > 
> > sbauer@metamini ~$ sudo ifup eth7
> > sbauer@metamini ~$ sudo ethtool eth7
> > 
> > Settings for eth7:
> >         Supported ports: [ MII ]
> >         Supported link modes:   10baseT/Full
> >         
> >                                 100baseT/Full
> >                                 1000baseT/Full
> >         
> >         Supported pause frame use: Symmetric Receive-only
> >         Supports auto-negotiation: Yes
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  10baseT/Full
> >         
> >                                 100baseT/Full
> >                                 1000baseT/Full
> >         
> >         Advertised pause frame use: Symmetric Receive-only
> >         Advertised auto-negotiation: Yes
> >         Advertised FEC modes: Not reported
> >         Speed: 1000Mb/s
> >         Duplex: Full
> >         Port: MII
> >         PHYAD: 0
> >         Transceiver: internal
> >         Auto-negotiation: on
> >         Supports Wake-on: pumbag
> >         Wake-on: d
> >         Current message level: 0x00000137 (311)
> >         
> >                                drv probe link ifdown ifup tx_queued
> >         
> >         Link detected: yes
> > 
> > sbauer@metamini ~$ sudo mii-tool -vv eth7
> > Using SIOCGMIIPHY=0x8947
> > eth7: negotiated 1000baseT-FD, link ok
> > 
> >   registers for MII PHY 0:
> >     5140 512d 7431 0011 4140 4140 000d 0000
> >     0000 0200 7800 0000 0000 0000 0000 2000
> >     0000 0000 0000 0000 0000 0000 0000 0000
> >     0000 0000 0000 0000 0000 0000 0000 0000
> >   
> >   product info: vendor 1d:0c:40, model 1 rev 1
> >   basic mode:   loopback, autonegotiation enabled
> >   basic status: autonegotiation complete, link ok
> >   capabilities: 1000baseT-FD 100baseTx-FD 10baseT-FD
> >   advertising:  1000baseT-FD 100baseTx-FD 10baseT-FD
> >   link partner: 1000baseT-FD 100baseTx-FD 10baseT-FD
> 
> You have not shown anything i cannot do with the ethernet interfaces i
> have in my laptop. And since ethtool is pretty standardized, what
> lan743x offers should be pretty much the same as any 1G Ethernet MAC
> using most 1G PHYs.
> 
>       Andrew

Andrew, I can reproduce segfault with following changes:
sbauer@metamini ~/devel/kernel-works/net-next.git master$ git diff .
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/
ethernet/microchip/lan743x_main.c
index 3804310c853a..6e2961f47211 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1001,6 +1001,8 @@ static void lan743x_phy_close(struct lan743x_adapter 
*adapter)
 
        phy_stop(netdev->phydev);
        phy_disconnect(netdev->phydev);
+       if (phy_is_pseudo_fixed_link(netdev->phydev))
+               fixed_phy_unregister(netdev->phydev);
        netdev->phydev = NULL;
 }
 
@@ -1018,9 +1020,21 @@ static int lan743x_phy_open(struct lan743x_adapter 
*adapter)
        if (!phydev) {
                /* try internal phy */
                phydev = phy_find_first(adapter->mdiobus);
-               if (!phydev)
-                       goto return_error;
-
+               if (!phydev) {
+                       struct fixed_phy_status status = {
+                               .link = 1,
+                               .speed = SPEED_1000,
+                               .duplex = DUPLEX_FULL,
+                               .asym_pause = 1,
+                       };
+
+                       phydev = fixed_phy_register(PHY_POLL, &status, NULL);
+                       if (!phydev || IS_ERR(phydev)) {
+                               netif_err(adapter, probe, netdev,
+                                         "Failed to register fixed PHY 
device\n");
+                               goto return_error;
+                       }
+               }
                ret = phy_connect_direct(netdev, phydev,
                                         lan743x_phy_link_status_change,
                                         PHY_INTERFACE_MODE_GMII);

sbauer@metamini ~/devel/kernel-works/net-next.git master$ sudo modprobe 
lan743x
sbauer@metamini ~/devel/kernel-works/net-next.git master$ sudo ifup eth7
sbauer@metamini ~/devel/kernel-works/net-next.git master$ ethtool eth7
Settings for eth7:
        Supported ports: [ TP MII ]
        Supported link modes:   1000baseT/Full 
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full 
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
Cannot get wake-on-lan settings: Operation not permitted
        Current message level: 0x00000137 (311)
                               drv probe link ifdown ifup tx_queued
        Link detected: yes
sbauer@metamini ~/devel/kernel-works/net-next.git master$ sudo ifdown eth7
Killed
---

dmesg:
[  365.856455] lan743x 0000:06:00.0 eth7: Link is Down
[  365.856542] BUG: kernel NULL pointer dereference, address: 00000000000003c4
[  365.856611] #PF: supervisor read access in kernel mode
[  365.856705] #PF: error_code(0x0000) - not-present page
[  365.856772] PGD 0 P4D 0 
[  365.856832] Oops: 0000 [#1] SMP NOPTI
[  365.856898] CPU: 0 PID: 21779 Comm: ip Tainted: G           O      5.11.0-
rc4net-next+ #4
[  365.857018] Hardware name: Gigabyte Technology Co., Ltd. H110-D3/H110-D3-
CF, BIOS F24 04/11/2018
[  365.857111] RIP: 0010:lan743x_phy_close.isra.26+0x28/0x50 [lan743x]
[  365.857208] Code: c3 90 0f 1f 44 00 00 53 48 89 fb 48 8b bf 28 08 00 00 e8 
ab 3e da ff 48 8b bb 28 08 00 00 e8 bf 67 da ff 48 8b bb 28 08 00 00 <f6> 87 c4 
03 00 00 04 75 0d 48 c7 83 28 08 00 00 00 00 00 00 5b c3
[  365.857332] RSP: 0018:ffffb6560468b508 EFLAGS: 00010246
[  365.857397] RAX: 0000000000000003 RBX: ffff8cfacbe30000 RCX: 0000000000000000
[  365.857466] RDX: ffffffffc00ae2d8 RSI: 0000000000000001 RDI: 0000000000000000
[  365.857537] RBP: 0000000000000008 R08: 0000000000000000 R09: ffffffffb2d6dee0
[  365.857632] R10: ffff8cfb45f69bff R11: ffff8cfb057c829b R12: ffff8cfacbe308c0
[  365.857697] R13: ffff8cfacbe310b8 R14: ffff8cfacbe31050 R15: ffff8cfacbe308c0
[  365.857762] FS:  00007f4318318e40(0000) GS:ffff8cfbf6c00000(0000) knlGS:
0000000000000000
[  365.857844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  365.857907] CR2: 00000000000003c4 CR3: 0000000145a80001 CR4: 
00000000003706f0
[  365.857972] Call Trace:
[  365.858029]  lan743x_netdev_close+0x223/0x250 [lan743x]
[  365.858094]  __dev_close_many+0x96/0x100
[  365.858170]  __dev_change_flags+0xdc/0x210
[  365.858264]  dev_change_flags+0x21/0x60
[  365.858325]  do_setlink+0x347/0x10e0
[  365.858385]  ? __nla_validate_parse+0x5f/0xaf0
[  365.858447]  __rtnl_newlink+0x541/0x8d0
[  365.858508]  ? get_page_from_freelist+0x1194/0x1310
[  365.858574]  ? mutex_spin_on_owner+0x5c/0xb0
[  365.858635]  ? __mutex_lock.isra.9+0x46e/0x4b0
[  365.858696]  ? asm_exc_page_fault+0x1e/0x30
[  365.858757]  rtnl_newlink+0x43/0x60
[  365.858817]  rtnetlink_rcv_msg+0x134/0x380
[  365.858878]  ? _cond_resched+0x15/0x30
[  365.858937]  ? kmem_cache_alloc+0x3cf/0x7d0
[  365.858997]  ? rtnl_calcit.isra.38+0x110/0x110
[  365.859058]  netlink_rcv_skb+0x50/0x100
[  365.859118]  netlink_unicast+0x1a5/0x280
[  365.859178]  netlink_sendmsg+0x23d/0x470
[  365.859237]  sock_sendmsg+0x5b/0x60
[  365.859298]  ____sys_sendmsg+0x1ef/0x260
[  365.859358]  ? copy_msghdr_from_user+0x5c/0x90
[  365.859418]  ? mntput_no_expire+0x47/0x240
[  365.859478]  ___sys_sendmsg+0x7c/0xc0
[  365.859537]  ? tomoyo_path_number_perm+0x68/0x1e0
[  365.859600]  ? __sk_destruct+0x129/0x1b0
[  365.859660]  ? var_wake_function+0x20/0x20
[  365.859720]  ? fsnotify_grab_connector+0x46/0x80
[  365.859782]  __sys_sendmsg+0x57/0xa0
[  365.859841]  do_syscall_64+0x33/0x80
[  365.859900]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
--- 
(gdb) l *lan743x_netdev_close+0x223
0x1f43 is in lan743x_netdev_close (drivers/net/ethernet/microchip//
lan743x_main.c:2521).
2516
2517            lan743x_ptp_close(adapter);
2518
2519            lan743x_phy_close(adapter);
2520
2521            lan743x_mac_close(adapter);
2522
2523            lan743x_intr_close(adapter);
2524
2525            return 0;
(gdb)



