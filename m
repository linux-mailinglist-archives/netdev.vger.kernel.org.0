Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27CD2FAC86
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394559AbhARVWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:22:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394613AbhARVWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:22:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1bxS-001Lp3-Tt; Mon, 18 Jan 2021 22:21:06 +0100
Date:   Mon, 18 Jan 2021 22:21:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] sh_eth: Make PHY access aware of Runtime PM
 to fix reboot crash
Message-ID: <YAX7wt+100RGmUvg@lunn.ch>
References: <20210118150656.796584-1-geert+renesas@glider.be>
 <20210118150656.796584-3-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118150656.796584-3-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 04:06:56PM +0100, Geert Uytterhoeven wrote:
> Wolfram reports that his R-Car H2-based Lager board can no longer be
> rebooted in v5.11-rc1, as it crashes with an imprecise external abort.
> The issue can be reproduced on other boards (e.g. Koelsch with R-Car
> M2-W) too, if CONFIG_IP_PNP is disabled, and the Ethernet interface is
> down at reboot time:
> 
>     Unhandled fault: imprecise external abort (0x1406) at 0x00000000
>     pgd = (ptrval)
>     [00000000] *pgd=422b6835, *pte=00000000, *ppte=00000000
>     Internal error: : 1406 [#1] ARM
>     Modules linked in:
>     CPU: 0 PID: 1105 Comm: init Tainted: G        W         5.10.0-rc1-00402-ge2f016cf7751 #1048
>     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
>     PC is at sh_mdio_ctrl+0x44/0x60
>     LR is at sh_mmd_ctrl+0x20/0x24
>     ...
>     Backtrace:
>     [<c0451f30>] (sh_mdio_ctrl) from [<c0451fd4>] (sh_mmd_ctrl+0x20/0x24)
>      r7:0000001f r6:00000020 r5:00000002 r4:c22a1dc4
>     [<c0451fb4>] (sh_mmd_ctrl) from [<c044fc18>] (mdiobb_cmd+0x38/0xa8)
>     [<c044fbe0>] (mdiobb_cmd) from [<c044feb8>] (mdiobb_read+0x58/0xdc)
>      r9:c229f844 r8:c0c329dc r7:c221e000 r6:00000001 r5:c22a1dc4 r4:00000001
>     [<c044fe60>] (mdiobb_read) from [<c044c854>] (__mdiobus_read+0x74/0xe0)
>      r7:0000001f r6:00000001 r5:c221e000 r4:c221e000
>     [<c044c7e0>] (__mdiobus_read) from [<c044c9d8>] (mdiobus_read+0x40/0x54)
>      r7:0000001f r6:00000001 r5:c221e000 r4:c221e458
>     [<c044c998>] (mdiobus_read) from [<c044d678>] (phy_read+0x1c/0x20)
>      r7:ffffe000 r6:c221e470 r5:00000200 r4:c229f800
>     [<c044d65c>] (phy_read) from [<c044d94c>] (kszphy_config_intr+0x44/0x80)
>     [<c044d908>] (kszphy_config_intr) from [<c044694c>] (phy_disable_interrupts+0x44/0x50)
>      r5:c229f800 r4:c229f800
>     [<c0446908>] (phy_disable_interrupts) from [<c0449370>] (phy_shutdown+0x18/0x1c)
>      r5:c229f800 r4:c229f804
>     [<c0449358>] (phy_shutdown) from [<c040066c>] (device_shutdown+0x168/0x1f8)
>     [<c0400504>] (device_shutdown) from [<c013de44>] (kernel_restart_prepare+0x3c/0x48)
>      r9:c22d2000 r8:c0100264 r7:c0b0d034 r6:00000000 r5:4321fedc r4:00000000
>     [<c013de08>] (kernel_restart_prepare) from [<c013dee0>] (kernel_restart+0x1c/0x60)
>     [<c013dec4>] (kernel_restart) from [<c013e1d8>] (__do_sys_reboot+0x168/0x208)
>      r5:4321fedc r4:01234567
>     [<c013e070>] (__do_sys_reboot) from [<c013e2e8>] (sys_reboot+0x18/0x1c)
>      r7:00000058 r6:00000000 r5:00000000 r4:00000000
>     [<c013e2d0>] (sys_reboot) from [<c0100060>] (ret_fast_syscall+0x0/0x54)
> 
> As of commit e2f016cf775129c0 ("net: phy: add a shutdown procedure"),
> system reboot calls phy_disable_interrupts() during shutdown.  As this
> happens unconditionally, the PHY registers may be accessed while the
> device is suspended, causing undefined behavior, which may crash the
> system.
> 
> Fix this by wrapping the PHY bitbang accessors in the sh_eth driver by
> wrappers that take care of Runtime PM, to resume the device when needed.
> 
> Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
