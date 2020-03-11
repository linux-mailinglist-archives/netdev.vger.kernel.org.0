Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37C4181485
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgCKJR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:17:27 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38286 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgCKJRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 05:17:22 -0400
Received: by mail-ot1-f66.google.com with SMTP id i14so1184850otp.5;
        Wed, 11 Mar 2020 02:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rvu2wq6L7cDE7hL6tvDHxFsplTLAIH45fU5iEHgqS2M=;
        b=lWyQGedIWMaOGzC3Brn452zcK7eTgOikP24wnD8heLs4RtcesajvqFYLdmMTP8h+Lp
         ighuIVGcuHU/Q4e/9ngAtIUMhTVTJL6pLGy//AKwDfp+e48Huf7DkKdYGG6Dua7F4nOE
         YO+6zSpH0geuvk78++C0JXlYXGPGESE5z6K1Re7f3roFh8QkVqvV2ExZwBovz/pULtIq
         yre1SUUqxw7spzDvuCopgmhqXmVJGUHdv5YhZBwfqJk61wGe/UcRkNe8g/suPooggEzY
         Fj31GglWbsRGHJ7IkIXMDmUGdtkYFgZCY3aYq7DOCo5X2zDwEbCPSwF6K3/Io6vjWjWi
         ZRhQ==
X-Gm-Message-State: ANhLgQ3kxuJ6IqbUHBE8VjPeF3oLqTMTqAVfea3/+a3M7rxbf+JsW/QJ
        frUSRWMoiRKH8YFPAFVUS7fHUq0IZPPMmfWrmQo=
X-Google-Smtp-Source: ADFU+vurMX1TBb2LbwR48anEMdh/Z0UhZIiQ6sBsCWyzWJOmgi1sbQq+hHLjY+kkZy2egeaHRHSwDAbZI1I2oMtjzk4=
X-Received: by 2002:a9d:1708:: with SMTP id i8mr1589448ota.250.1583918240450;
 Wed, 11 Mar 2020 02:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200220233454.31514-1-f.fainelli@gmail.com> <20200223.205911.1667092059432885700.davem@davemloft.net>
 <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com> <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
In-Reply-To: <c2a4edcb-dbf9-bc60-4399-3eaec9a20fe7@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 11 Mar 2020 10:17:09 +0100
Message-ID: <CAMuHMdUMM0Q6W7A0mVgSf7XmF8yROZb3uzHPU1ETbMAfvTtfow@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 5:47 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 3/10/20 7:16 AM, Geert Uytterhoeven wrote:
> > Hi Florian, David,
> >
> > On Mon, Feb 24, 2020 at 5:59 AM David Miller <davem@davemloft.net> wrote:
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >> Date: Thu, 20 Feb 2020 15:34:53 -0800
> >>
> >>> It is currently possible for a PHY device to be suspended as part of a
> >>> network device driver's suspend call while it is still being attached to
> >>> that net_device, either via phy_suspend() or implicitly via phy_stop().
> >>>
> >>> Later on, when the MDIO bus controller get suspended, we would attempt
> >>> to suspend again the PHY because it is still attached to a network
> >>> device.
> >>>
> >>> This is both a waste of time and creates an opportunity for improper
> >>> clock/power management bugs to creep in.
> >>>
> >>> Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
> >>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>
> >> Applied, and queued up for -stable, thanks Florian.
> >
> > This patch causes a regression on r8a73a4/ape6evm and sh73a0/kzm9g.
> > After resume from s2ram, Ethernet no longer works:
> >
> >         PM: suspend exit
> >         nfs: server aaa.bbb.ccc.ddd not responding, still trying
> >         ...
> >
> > Reverting commit 503ba7c6961034ff ("net: phy: Avoid multiple suspends")
> > fixes the issue.
> >
> > On both boards, an SMSC LAN9220 is connected to a power-managed local
> > bus.
> >
> > I added some debug code to check when the clock driving the local bus
> > is stopped and started, but I see no difference before/after.  Hence I
> > suspect the Ethernet chip is no longer reinitialized after resume.
>
> Can you provide a complete log?

With some debug info:

    SDHI0 Vcc: disabling
    PM: suspend entry (deep)
    Filesystems sync: 0.002 seconds
    Freezing user space processes ... (elapsed 0.001 seconds) done.
    OOM killer disabled.
    Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
    PM: ==== a3sp/ee120000.sd: stop
    PM: ==== a3sp/ee100000.sd: stop
    smsc911x 8000000.ethernet: smsc911x_suspend:2577
    smsc911x 8000000.ethernet: smsc911x_suspend:2579 running
    smsc911x 8000000.ethernet: smsc911x_suspend:2584
    PM: ==== a3sp/ee200000.mmc: stop
    PM: ==== c4/fec10000.bus: stop
    PM: ==== a3sp/e6c40000.serial: stop
    PM: ==== c5/e61f0000.thermal: stop
    PM: ==== c4/e61c0200.interrupt-controller: stop
    PM: == a3sp: power off
    rmobile_pd_power_down: a3sp
    Disabling non-boot CPUs ...
    PM: ==== c4/e61c0200.interrupt-controller: start
    PM: ==== c5/e61f0000.thermal: start
    PM: ==== a3sp/e6c40000.serial: start
    PM: ==== c4/fec10000.bus: start
    PM: ==== a3sp/ee200000.mmc: start
    smsc911x 8000000.ethernet: smsc911x_resume:2606
    smsc911x 8000000.ethernet: smsc911x_resume:2625 running
    PM: ==== a3sp/ee100000.sd: start
    OOM killer enabled.
    Restarting tasks ... done.
    PM: ==== a3sp/ee120000.sd: start
    PM: suspend exit
    nfs: server aaa.bbb.ccc.ddd not responding, still trying
    ...

But no difference between the good and the bad case, except for the nfs
failures.

> Do you use the Generic PHY driver or a
> specialized one?

CONFIG_FIXED_PHY=y
CONFIG_SMSC_PHY=y

Just the smsc,lan9115 node, cfr. arch/arm/boot/dts/r8a73a4-ape6evm.dts

> Do you have a way to dump the registers at the time of
> failure and see if BMCR.PDOWN is still set somehow?

Added a hook into "nfs: server not responding", which prints:

    MII_BMCR = 0x1900

i.e. BMCR_PDOWN = 0x0800 is still set.

> Does the following help:
>
> diff --git a/drivers/net/ethernet/smsc/smsc911x.c
> b/drivers/net/ethernet/smsc/smsc911x.c
> index 49a6a9167af4..df17190c76c0 100644
> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -2618,6 +2618,7 @@ static int smsc911x_resume(struct device *dev)
>         if (netif_running(ndev)) {
>                 netif_device_attach(ndev);
>                 netif_start_queue(ndev);
> +               phy_resume(dev->phydev);
>         }
>

Yes i does, after s/dev->/ndev->/.
Thanks!


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
