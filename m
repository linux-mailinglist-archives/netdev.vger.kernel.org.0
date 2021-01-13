Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE372F4711
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbhAMJDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:03:35 -0500
Received: from mail-oo1-f44.google.com ([209.85.161.44]:33712 "EHLO
        mail-oo1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbhAMJDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:03:34 -0500
Received: by mail-oo1-f44.google.com with SMTP id k7so347585ooa.0;
        Wed, 13 Jan 2021 01:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0P5oXwciG7rvWzFIp9uw4gFqSPn1af+OY8OLTrEVgSg=;
        b=Z5clb8Dp9pEQ7pE5YxBbwCJkjgPzLxGAN80Rnqa/kR1ZpR+csjmliLcYhAXg6IuUM8
         dBWpO3JmBjBTC32/JmEnubJyKlk9kV4exaLUAJQBiMrYcnLCZVSACr98PnSNWzzXrWr+
         KAsC8lzp77VF8JtTtWtKu4AlLylb6LH2easl0XPVrVlqM//3AxVmbUZW0Qh8S7r50za0
         AEU799iG8/2qtxl83JbvSJjLQK2QOlW4F1mpLyRd+Bsscphm2B3JSLdZPUGFkMPZNFaD
         x0JOYe4OSe+FlbYDo87TVKO9qo5W0EmgoOh3H6+fnk50JC9R1CkemJfbi0DkONf/2aZ6
         Mhdw==
X-Gm-Message-State: AOAM532nQN91c/uQga+whCZi78l0MLdWL73gpT1wABdKgrHg2cYsJMaT
        MYQf5EdIRb2pg6ym0IMEkbbMr7E5TmQTF7OmDG7zwbJeBYw=
X-Google-Smtp-Source: ABdhPJxZ8b1O01Slp8YgOfIrQOdXZ1RkGQvggnEfMIOYHGBIozCu9m/bS5q+SWZZ3QaEoKRSzoS5eDJ12Pi8Dt0T+uw=
X-Received: by 2002:a4a:ca14:: with SMTP id w20mr546580ooq.11.1610528573224;
 Wed, 13 Jan 2021 01:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf> <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
 <20210104170112.hn6t3kojhifyuaf6@skbuf> <X/NNS3FUeSNxbqwo@lunn.ch>
 <X/NQ2fYdBygm3CYc@lunn.ch> <20210104184341.szvnl24wnfnxg4k7@skbuf>
 <alpine.DEB.2.22.394.2101051038550.302140@ramsan.of.borg> <X/RzRd0zXHzAqLDl@lunn.ch>
In-Reply-To: <X/RzRd0zXHzAqLDl@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 Jan 2021 10:02:42 +0100
Message-ID: <CAMuHMdVhOWQiZNBmq8aH-pPS64AoFAEEHQTmVAsse2W4rxBuMA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not set
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Jan 5, 2021 at 3:10 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > I added a statically-linked ethtool binary to my initramfs, and can
> > confirm that retrieving the PHY statistics does not access the PHY
> > registers when the device is suspended:
> >
> >     # ethtool --phy-statistics eth0
> >     no stats available
> >     # ifconfig eth0 up
> >     # ethtool --phy-statistics eth0
> >     PHY statistics:
> >        phy_receive_errors: 0
> >        phy_idle_errors: 0
> >     #
> >
> > In the past, we've gone to great lengths to avoid accessing the PHY
> > registers when the device is suspended, usually in the statistics
> > handling (see e.g. [1][2]).
>
> I would argue that is the wrong approach. The PHY device is a
> device. It has its own lifetime. You would not suspend a PCI bus
> controller without first suspending all PCI devices on the bus etc.

Makes sense.  So perhaps the PHY devices should become full citizens
instead, and start using Runtime PM theirselves? Then the device
framework will take care of it automatically through the devices'
parent/child relations.

This would be similar to e.g. commit 3a611e26e958b037 ("net/smsc911x:
Add minimal runtime PM support"), but now for PHYs w.r.t. their parent
network controller device, instead of for the network controller device
w.r.t. its parent bus.

> > +static int sh_mdiobb_read(struct mii_bus *bus, int phy, int reg)
> > +{
> > +     struct bb_info *bb = container_of(bus->priv, struct bb_info, ctrl);
>
> mii_bus->parent should give you dev, so there is no need to add it to
> bb_info.

OK.

> > +     /* Wrap accessors with Runtime PM-aware ops */
> > +     bitbang->read = mdp->mii_bus->read;
> > +     bitbang->write = mdp->mii_bus->write;
> > +     mdp->mii_bus->read = sh_mdiobb_read;
> > +     mdp->mii_bus->write = sh_mdiobb_write;
>
> I did wonder about just exporting the two functions so you can
> directly call them.

I did consider that. Do you prefer exporting the functions?

> Otherwise, this looks good.

Thanks. Do you want me to submit (with the above changed) as an interim
solution?

Note that the same issue seems to be present in the Renesas EtherAVB
driver.  But that is more difficult to reproduce, as I don't have any arm32
boards that use RAVB, and on arm64 register access while a device is
suspended doesn't cause a crash, but continues silently without any effect.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
