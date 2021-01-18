Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564BB2FA891
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405491AbhARSTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393199AbhARPIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:08:43 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46981C0613ED
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:07:03 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id JF6z2400Q4C55Sk01F6z0a; Mon, 18 Jan 2021 16:07:02 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7O-004cpa-RE; Mon, 18 Jan 2021 16:06:58 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7N-003LF3-L3; Mon, 18 Jan 2021 16:06:57 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net v2 2/2] sh_eth: Make PHY access aware of Runtime PM to fix reboot crash
Date:   Mon, 18 Jan 2021 16:06:56 +0100
Message-Id: <20210118150656.796584-3-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118150656.796584-1-geert+renesas@glider.be>
References: <20210118150656.796584-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
v2:
  - Call mdiobb_{read,write}() now they are exported,
  - Use mii_bus.parent to avoid bb_info.dev copy,
  - Drop RFC state.
---
 drivers/net/ethernet/renesas/sh_eth.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index c633046329352601..9b52d350e21a9f2b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3034,6 +3034,28 @@ static int sh_mdio_release(struct sh_eth_private *mdp)
 	return 0;
 }
 
+static int sh_mdiobb_read(struct mii_bus *bus, int phy, int reg)
+{
+	int res;
+
+	pm_runtime_get_sync(bus->parent);
+	res = mdiobb_read(bus, phy, reg);
+	pm_runtime_put(bus->parent);
+
+	return res;
+}
+
+static int sh_mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	int res;
+
+	pm_runtime_get_sync(bus->parent);
+	res = mdiobb_write(bus, phy, reg, val);
+	pm_runtime_put(bus->parent);
+
+	return res;
+}
+
 /* MDIO bus init function */
 static int sh_mdio_init(struct sh_eth_private *mdp,
 			struct sh_eth_plat_data *pd)
@@ -3058,6 +3080,10 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	if (!mdp->mii_bus)
 		return -ENOMEM;
 
+	/* Wrap accessors with Runtime PM-aware ops */
+	mdp->mii_bus->read = sh_mdiobb_read;
+	mdp->mii_bus->write = sh_mdiobb_write;
+
 	/* Hook up MII support for ethtool */
 	mdp->mii_bus->name = "sh_mii";
 	mdp->mii_bus->parent = dev;
-- 
2.25.1

