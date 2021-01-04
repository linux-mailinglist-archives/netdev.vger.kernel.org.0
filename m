Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1302E9821
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 16:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhADPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 10:11:55 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:42335 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbhADPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 10:11:54 -0500
Received: by mail-oi1-f173.google.com with SMTP id l200so32400817oig.9;
        Mon, 04 Jan 2021 07:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0O6BGra8D+uGJ3gOL3w2hoiJ00DgPb5mbMvo+qerEF0=;
        b=ofrlhCk2BhxKVGLU6sC8ziLUb29NKN7ua5GiXWLL2WmY2IHZdTHw9457oaK01O8y1V
         JisZ8OfSpMlB6K3kCize0TOojiGSRrB4d3ts6G8+7/kztZDI+xdZS5hkAVGMzK31xEBm
         +tWjJk8m0F/a8HsguZ9sZ/idgHDEKeQKHAcM73UX0jXLFgWvInrGhjwWhnT5ZQC77r4P
         XJXDFfMS8g1GQQ9lu94A+tORs1j+cKgQzNMgb85RqPNnfLR/S3bgIzgdDphEiWZMLREr
         647AEu5cJQUNGbkRBWWEJuze/NZde1lEDcgBng3KpVx4DFq4CrtAMXyoGJhhrsIRMj+W
         Ld8g==
X-Gm-Message-State: AOAM533lVaF774o9cJsDJ5BnI4sJAD5o4HbmtgcYGIQwf2jY/XWh/R8b
        fBWL3Vy7Q3Lg5xcUtmdKnolhbE0++Q6Bk5ck1Io=
X-Google-Smtp-Source: ABdhPJwMgpuLL17EMltjqEd5Bl9Ucak+kZiHLVQlzuyeFw81ebslzKGwPwXnawLO+2ClOLL+lQ6b3jtKoqXtjcqv+0Y=
X-Received: by 2002:aca:ec09:: with SMTP id k9mr18208727oih.153.1609773073136;
 Mon, 04 Jan 2021 07:11:13 -0800 (PST)
MIME-Version: 1.0
References: <20210104122415.1263541-1-geert+renesas@glider.be> <20210104145331.tlwjwbzey5i4vgvp@skbuf>
In-Reply-To: <20210104145331.tlwjwbzey5i4vgvp@skbuf>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jan 2021 16:11:02 +0100
Message-ID: <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not set
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Mon, Jan 4, 2021 at 3:53 PM Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
> On Mon, Jan 04, 2021 at 01:24:15PM +0100, Geert Uytterhoeven wrote:
> > Wolfram reports that his R-Car H2-based Lager board can no longer be
> > rebooted in v5.11-rc1, as it crashes with an imprecise external abort.
> > The issue can be reproduced on other boards (e.g. Koelsch with R-Car
> > M2-W) too, if CONFIG_IP_PNP is disabled:
>
> What kind of PHYs are used on these boards?

Micrel KSZ8041RNLI

> >     Unhandled fault: imprecise external abort (0x1406) at 0x00000000
> >     pgd = (ptrval)
> >     [00000000] *pgd=422b6835, *pte=00000000, *ppte=00000000
> >     Internal error: : 1406 [#1] ARM
> >     Modules linked in:
> >     CPU: 0 PID: 1105 Comm: init Tainted: G        W         5.10.0-rc1-00402-ge2f016cf7751 #1048
> >     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> >     PC is at sh_mdio_ctrl+0x44/0x60
> >     LR is at sh_mmd_ctrl+0x20/0x24
> >     ...
> >     Backtrace:
> >     [<c0451f30>] (sh_mdio_ctrl) from [<c0451fd4>] (sh_mmd_ctrl+0x20/0x24)
> >      r7:0000001f r6:00000020 r5:00000002 r4:c22a1dc4
> >     [<c0451fb4>] (sh_mmd_ctrl) from [<c044fc18>] (mdiobb_cmd+0x38/0xa8)
> >     [<c044fbe0>] (mdiobb_cmd) from [<c044feb8>] (mdiobb_read+0x58/0xdc)
> >      r9:c229f844 r8:c0c329dc r7:c221e000 r6:00000001 r5:c22a1dc4 r4:00000001
> >     [<c044fe60>] (mdiobb_read) from [<c044c854>] (__mdiobus_read+0x74/0xe0)
> >      r7:0000001f r6:00000001 r5:c221e000 r4:c221e000
> >     [<c044c7e0>] (__mdiobus_read) from [<c044c9d8>] (mdiobus_read+0x40/0x54)
> >      r7:0000001f r6:00000001 r5:c221e000 r4:c221e458
> >     [<c044c998>] (mdiobus_read) from [<c044d678>] (phy_read+0x1c/0x20)
> >      r7:ffffe000 r6:c221e470 r5:00000200 r4:c229f800
> >     [<c044d65c>] (phy_read) from [<c044d94c>] (kszphy_config_intr+0x44/0x80)
> >     [<c044d908>] (kszphy_config_intr) from [<c044694c>] (phy_disable_interrupts+0x44/0x50)
> >      r5:c229f800 r4:c229f800
> >     [<c0446908>] (phy_disable_interrupts) from [<c0449370>] (phy_shutdown+0x18/0x1c)
> >      r5:c229f800 r4:c229f804
> >     [<c0449358>] (phy_shutdown) from [<c040066c>] (device_shutdown+0x168/0x1f8)
> >     [<c0400504>] (device_shutdown) from [<c013de44>] (kernel_restart_prepare+0x3c/0x48)
> >      r9:c22d2000 r8:c0100264 r7:c0b0d034 r6:00000000 r5:4321fedc r4:00000000
> >     [<c013de08>] (kernel_restart_prepare) from [<c013dee0>] (kernel_restart+0x1c/0x60)
> >     [<c013dec4>] (kernel_restart) from [<c013e1d8>] (__do_sys_reboot+0x168/0x208)
> >      r5:4321fedc r4:01234567
> >     [<c013e070>] (__do_sys_reboot) from [<c013e2e8>] (sys_reboot+0x18/0x1c)
> >      r7:00000058 r6:00000000 r5:00000000 r4:00000000
> >     [<c013e2d0>] (sys_reboot) from [<c0100060>] (ret_fast_syscall+0x0/0x54)
> >
> > Calling phy_disable_interrupts() unconditionally means that the PHY
> > registers may be accessed while the device is suspended, causing
> > undefined behavior, which may crash the system.
> >
> > Fix this by calling phy_disable_interrupts() only when the PHY has been
> > started.
> >
> > Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > Fixes: e2f016cf775129c0 ("net: phy: add a shutdown procedure")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > Marked RFC as I do not know if this change breaks the use case fixed by
> > the faulty commit.
>
> I haven't tested it yet but most probably this change would partially
> revert the behavior to how things were before adding the shutdown
> procedure.
>
> And this is because the interrupts are enabled at phy_connect and not at
> phy_start so we would want to disable any PHY interrupts even though the
> PHY has not been started yet.

Makes sense.

> > Alternatively, the device may have to be started
> > explicitly first.
>
> Have you actually tried this out and it worked?

No, I haven't tested restarting the device first.
I would like to avoid starting the device during shutdown, unless it is
absolutely necessary.

> I am asking this because I would much rather expect this to be a problem
> with how the sh_eth driver behaves if the netdevice did not connect to
> the PHY (this is done in .open() alongside the phy_start()) and it
> suddently has to interract with it through the mdiobb_ops callbacks.
>
> Also, I just re-tested this use case in which I do not start the
> interface and just issue a reboot, and it behaves as expected.

It depends on the hardware: the sh_eth device is powered down when its
module clock is stopped. When powered down, any access to the sh_eth
registers or to the PHY connected to it will cause a crash.

On most other hardware, you can access the PHY regardless, and no crash
will happen.

> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -2962,7 +2962,8 @@ static void phy_shutdown(struct device *dev)
> >  {
> >       struct phy_device *phydev = to_phy_device(dev);
> >
> > -     phy_disable_interrupts(phydev);
> > +     if (phy_is_started(phydev))
> > +             phy_disable_interrupts(phydev);
> >  }
> >
> >  /**

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
