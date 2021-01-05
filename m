Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FBA2EA826
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbhAEKCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAEKCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:02:37 -0500
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D922BC061795
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 02:01:56 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by andre.telenet-ops.be with bizsmtp
        id Cy1s240064C55Sk01y1scu; Tue, 05 Jan 2021 11:01:53 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kwj9z-001GzC-V7; Tue, 05 Jan 2021 11:01:51 +0100
Date:   Tue, 5 Jan 2021 11:01:51 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, Andrew Lunn <andrew@lunn.ch>
cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is
 not set
In-Reply-To: <20210104184341.szvnl24wnfnxg4k7@skbuf>
Message-ID: <alpine.DEB.2.22.394.2101051038550.302140@ramsan.of.borg>
References: <20210104122415.1263541-1-geert+renesas@glider.be> <20210104145331.tlwjwbzey5i4vgvp@skbuf> <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com> <20210104170112.hn6t3kojhifyuaf6@skbuf> <X/NNS3FUeSNxbqwo@lunn.ch> <X/NQ2fYdBygm3CYc@lunn.ch>
 <20210104184341.szvnl24wnfnxg4k7@skbuf>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Ioana, Andrew,

On Mon, 4 Jan 2021, Ioana Ciornei wrote:
> On Mon, Jan 04, 2021 at 06:31:05PM +0100, Andrew Lunn wrote:
>>> The basic rules here should be, if the MDIO bus is registered, it is
>>> usable. There are things like PHY statistics, HWMON temperature
>>> sensors, etc, DSA switches, all which have a life cycle separate to
>>> the interface being up.
>>
>> [Goes and looks at the code]
>>
>> Yes, this is runtime PM which is broken.
>>
>> sh_mdio_init() needs to wrap the mdp->mii_bus->read and
>> mdp->mii_bus->write calls with calls to
>>
>> pm_runtime_get_sync(&mdp->pdev->dev);
>>
>> and
>>
>> pm_runtime_put_sync(&mdp->pdev->dev);

pm_runtime_put().

Thanks, that works (see patch below), but I'm still wondering if that is
the right fix...

> Agree. Thanks for actually looking into it.. I'm not really well versed
> in runtime PM.
>
>> The KSZ8041RNLI supports statistics, which ethtool --phy-stats can
>> read, and these will also going to cause problems.
>>
>
> Not really, this driver connects to the PHY on .ndo_open(), thus any
> try to actually dump the PHY statistics before an ifconfig up would get
> an -EOPNOTSUPP since the dev->phydev is not yet populated.

I added a statically-linked ethtool binary to my initramfs, and can
confirm that retrieving the PHY statistics does not access the PHY
registers when the device is suspended:

     # ethtool --phy-statistics eth0
     no stats available
     # ifconfig eth0 up
     # ethtool --phy-statistics eth0
     PHY statistics:
 	 phy_receive_errors: 0
 	 phy_idle_errors: 0
     #

In the past, we've gone to great lengths to avoid accessing the PHY
registers when the device is suspended, usually in the statistics
handling (see e.g. [1][2]).  Hence I'm wondering if we should do the
same here, and handle this at a higher layer than the individual network
device driver (other drivers than sh_eth may be affected, too)?

Thanks!

[1] 124eee3f6955f7aa ("net: linkwatch: add check for netdevice being present to linkwatch_do_dev")
[2] https://lore.kernel.org/netdev/11beeaa9-57d5-e641-9486-f2ba202d0998@gmail.com/

From b3cc15e56bddbe65e0196ce04604e5e6c78abd7a Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue, 5 Jan 2021 10:29:22 +0100
Subject: [PATCH] [RFC] sh_eth: Make PHY access aware of Runtime PM to fix
  reboot crash

Wolfram reports that his R-Car H2-based Lager board can no longer be
rebooted in v5.11-rc1, as it crashes with an imprecise external abort.
The issue can be reproduced on other boards (e.g. Koelsch with R-Car
M2-W) too, if CONFIG_IP_PNP is disabled, and the Ethernet interface is
down at reboot time:

     Unhandled fault: imprecise external abort (0x1406) at 0x00000000
     pgd = (ptrval)
     [00000000] *pgd=422b6835, *pte=00000000, *ppte=00000000
     Internal error: : 1406 [#1] ARM
     Modules linked in:
     CPU: 0 PID: 1105 Comm: init Tainted: G        W         5.10.0-rc1-00402-ge2f016cf7751 #1048
     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
     PC is at sh_mdio_ctrl+0x44/0x60
     LR is at sh_mmd_ctrl+0x20/0x24
     ...
     Backtrace:
     [<c0451f30>] (sh_mdio_ctrl) from [<c0451fd4>] (sh_mmd_ctrl+0x20/0x24)
      r7:0000001f r6:00000020 r5:00000002 r4:c22a1dc4
     [<c0451fb4>] (sh_mmd_ctrl) from [<c044fc18>] (mdiobb_cmd+0x38/0xa8)
     [<c044fbe0>] (mdiobb_cmd) from [<c044feb8>] (mdiobb_read+0x58/0xdc)
      r9:c229f844 r8:c0c329dc r7:c221e000 r6:00000001 r5:c22a1dc4 r4:00000001
     [<c044fe60>] (mdiobb_read) from [<c044c854>] (__mdiobus_read+0x74/0xe0)
      r7:0000001f r6:00000001 r5:c221e000 r4:c221e000
     [<c044c7e0>] (__mdiobus_read) from [<c044c9d8>] (mdiobus_read+0x40/0x54)
      r7:0000001f r6:00000001 r5:c221e000 r4:c221e458
     [<c044c998>] (mdiobus_read) from [<c044d678>] (phy_read+0x1c/0x20)
      r7:ffffe000 r6:c221e470 r5:00000200 r4:c229f800
     [<c044d65c>] (phy_read) from [<c044d94c>] (kszphy_config_intr+0x44/0x80)
     [<c044d908>] (kszphy_config_intr) from [<c044694c>] (phy_disable_interrupts+0x44/0x50)
      r5:c229f800 r4:c229f800
     [<c0446908>] (phy_disable_interrupts) from [<c0449370>] (phy_shutdown+0x18/0x1c)
      r5:c229f800 r4:c229f804
     [<c0449358>] (phy_shutdown) from [<c040066c>] (device_shutdown+0x168/0x1f8)
     [<c0400504>] (device_shutdown) from [<c013de44>] (kernel_restart_prepare+0x3c/0x48)
      r9:c22d2000 r8:c0100264 r7:c0b0d034 r6:00000000 r5:4321fedc r4:00000000
     [<c013de08>] (kernel_restart_prepare) from [<c013dee0>] (kernel_restart+0x1c/0x60)
     [<c013dec4>] (kernel_restart) from [<c013e1d8>] (__do_sys_reboot+0x168/0x208)
      r5:4321fedc r4:01234567
     [<c013e070>] (__do_sys_reboot) from [<c013e2e8>] (sys_reboot+0x18/0x1c)
      r7:00000058 r6:00000000 r5:00000000 r4:00000000
     [<c013e2d0>] (sys_reboot) from [<c0100060>] (ret_fast_syscall+0x0/0x54)

As of commit e2f016cf775129c0 ("net: phy: add a shutdown procedure"),
system reboot calls phy_disable_interrupts() during shutdown.  As this
happens unconditionally, the PHY registers may be accessed while the
device is suspended, causing undefined behavior, which may crash the
system.

Fix this by wrapping the PHY bitbang accessors in the sh_eth driver by
wrappers that take care of Runtime PM, to resume the device when needed.

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
  drivers/net/ethernet/renesas/sh_eth.c | 34 +++++++++++++++++++++++++++
  1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index c633046329352601..f8b306fa61bc25ca 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1162,7 +1162,10 @@ static void read_mac_address(struct net_device *ndev, unsigned char *mac)

  struct bb_info {
  	void (*set_gate)(void *addr);
+	int (*read)(struct mii_bus *bus, int addr, int regnum);
+	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
  	struct mdiobb_ctrl ctrl;
+	struct device *dev;
  	void *addr;
  };

@@ -3034,6 +3037,30 @@ static int sh_mdio_release(struct sh_eth_private *mdp)
  	return 0;
  }

+static int sh_mdiobb_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct bb_info *bb = container_of(bus->priv, struct bb_info, ctrl);
+	int res;
+
+	pm_runtime_get_sync(bb->dev);
+	res = bb->read(bus, phy, reg);
+	pm_runtime_put(bb->dev);
+
+	return res;
+}
+
+static int sh_mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct bb_info *bb = container_of(bus->priv, struct bb_info, ctrl);
+	int res;
+
+	pm_runtime_get_sync(bb->dev);
+	res = bb->write(bus, phy, reg, val);
+	pm_runtime_put(bb->dev);
+
+	return res;
+}
+
  /* MDIO bus init function */
  static int sh_mdio_init(struct sh_eth_private *mdp,
  			struct sh_eth_plat_data *pd)
@@ -3052,12 +3079,19 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
  	bitbang->addr = mdp->addr + mdp->reg_offset[PIR];
  	bitbang->set_gate = pd->set_mdio_gate;
  	bitbang->ctrl.ops = &bb_ops;
+	bitbang->dev = dev;

  	/* MII controller setting */
  	mdp->mii_bus = alloc_mdio_bitbang(&bitbang->ctrl);
  	if (!mdp->mii_bus)
  		return -ENOMEM;

+	/* Wrap accessors with Runtime PM-aware ops */
+	bitbang->read = mdp->mii_bus->read;
+	bitbang->write = mdp->mii_bus->write;
+	mdp->mii_bus->read = sh_mdiobb_read;
+	mdp->mii_bus->write = sh_mdiobb_write;
+
  	/* Hook up MII support for ethtool */
  	mdp->mii_bus->name = "sh_mii";
  	mdp->mii_bus->parent = dev;
-- 
2.25.1

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
