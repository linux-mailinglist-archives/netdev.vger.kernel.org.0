Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172D52E94D0
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbhADMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbhADMZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 07:25:02 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1436C061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 04:24:21 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id CcQG2400w4C55Sk01cQGKE; Mon, 04 Jan 2021 13:24:18 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kwOuG-00169y-EN; Mon, 04 Jan 2021 13:24:16 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kwOuF-005IiT-Vv; Mon, 04 Jan 2021 13:24:15 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not set
Date:   Mon,  4 Jan 2021 13:24:15 +0100
Message-Id: <20210104122415.1263541-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wolfram reports that his R-Car H2-based Lager board can no longer be
rebooted in v5.11-rc1, as it crashes with an imprecise external abort.
The issue can be reproduced on other boards (e.g. Koelsch with R-Car
M2-W) too, if CONFIG_IP_PNP is disabled:

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

Calling phy_disable_interrupts() unconditionally means that the PHY
registers may be accessed while the device is suspended, causing
undefined behavior, which may crash the system.

Fix this by calling phy_disable_interrupts() only when the PHY has been
started.

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Fixes: e2f016cf775129c0 ("net: phy: add a shutdown procedure")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Marked RFC as I do not know if this change breaks the use case fixed by
the faulty commit.  Alternatively, the device may have to be started
explicitly first.
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c0934311..5985061b00128f8a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2962,7 +2962,8 @@ static void phy_shutdown(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
-	phy_disable_interrupts(phydev);
+	if (phy_is_started(phydev))
+		phy_disable_interrupts(phydev);
 }
 
 /**
-- 
2.25.1

