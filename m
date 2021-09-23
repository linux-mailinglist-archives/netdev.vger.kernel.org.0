Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D036B415C64
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbhIWLBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:01:55 -0400
Received: from mail-ua1-f54.google.com ([209.85.222.54]:38520 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240442AbhIWLBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:01:54 -0400
Received: by mail-ua1-f54.google.com with SMTP id 42so3984623uar.5;
        Thu, 23 Sep 2021 04:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgarIMV3d2Y0uwFmShy8IL/1sLsQ5s6li7/ed4hIYHE=;
        b=vNCt0tctQuBgoPu79HfPx1vxj2ucdoymrVexqM5hc1vjNND9DP30a4qVrOKpjVuFfB
         YIvycye8zAtn17fUktRNRZHRcBLQtzfz2jmoQtURWmg21Ig7pT2sOqP6imyov8PCrs5O
         BN6YhSxFcjdh4u+ErF5nYTxPvtKt3EZpYFa1ylA5hZBMqWnSVei55LILs9k7QzuJ7qIY
         LLVh7wPX6WS1U4RifZPimz9Tl4w/+vmRSHX8A2KwT8+95k7CZViNdqmUVkA5PmejQL+W
         WkZQk5ForElxAEAUYv4IkuXGnsWFxsXrL1VHYgtgNNaMNTFbZuKzYWlhcAEECW3lBqVB
         doDw==
X-Gm-Message-State: AOAM532aYfCBSH2cJkr0TtbgvLBgLzDwXEE1bj3jax+PZmBTRlabm5oN
        2K8wTuwyNh9QpgmIEG/c0AAjwGZTb+i39Jhqq4s=
X-Google-Smtp-Source: ABdhPJzNWqI9ro9lFSqVuKoYP6xDJJtX9u6Rm1mWrFuto2PRgg1nm5xAY9/c30ZfqBFTvHFQ07vhKKJ438C3DRVONmA=
X-Received: by 2002:a9f:30d8:: with SMTP id k24mr3267164uab.89.1632394822739;
 Thu, 23 Sep 2021 04:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631174218.git.geert+renesas@glider.be>
In-Reply-To: <cover.1631174218.git.geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Sep 2021 13:00:11 +0200
Message-ID: <CAMuHMdU6Mrfina3+2iW+RKaujk57JSRtmixRPn1b0d2w5dZ3eA@mail.gmail.com>
Subject: Re: [PATCH 0/9] renesas: Add compatible properties to Ethernet PHY nodes
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 10:49 AM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> If an Ethernet PHY reset is asserted when the Ethernet driver is
> initialized, the PHY cannot be probed:
>
>     mdio_bus ee700000.ethernet-ffffffff: MDIO device at address 1 is missing
>
> This happens because the Linux PHY subsystem tries to read the PHY
> Identifier registers before handling PHY reset.  Hence if the PHY reset
> was asserted before, identification fails.
>
> An easy way to reproduce this issue is by using kexec to launch a new
> kernel (the PHY reset will be asserted before starting the new kernel),
> or by unbinding and rebinding the Ethernet driver (the PHY reset will be
> asserted during unbind), e.g. on koelsch:
>
>     echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/unbind
>     $ echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/bind
>
> The recommended approach[1][2] seems to be working around this issue by
> adding compatible values to all ethernet-phy nodes, so Linux can
> identify the PHY at any time, without reading the PHY ID from the
> device, and regardless of the state of the PHY reset line.
>
> Hence this patch series adds such compatible values to all Ethernet PHY
> subnodes representing PHYs on all boards with Renesas ARM and ARM64
> SoCs.  For easier review, I have split the series in one patch per PHY
> model.
>
> On most boards, I could verify the actual PHY ID at runtime[3], on other
> boards I had to resort to schematics.
>
> Kexec and Ethernet driver rebind have been tested on Koelsch and
> Salvator-XS.
>
> I plan to queue these in renesas-devel for v5.16.
>
> Thanks for your comments!

I'd be very grateful for comments (e.g. Acked-by) from the Ethernet
PHY people.
Thanks again!

> [1] "Re: [PATCH] RFC: net: phy: of phys probe/reset issue"
>     https://lore.kernel.org/r/ade12434-adf2-6ea7-24ce-ce45ad2e1b5e@gmail.com/
> [2] "PHY reset may still be asserted during MDIO probe"
>     https://lore.kernel.org/r/CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com
> [3] The easiest way to obtain the PHY ID is by adding a debug print to
>     drivers/net/phy/phy_device.c:get_phy_c22_id(), _before_ applying
>     this patch.
>
> Geert Uytterhoeven (9):
>   ARM: dts: renesas: Add compatible properties to KSZ8041 Ethernet PHYs
>   ARM: dts: renesas: Add compatible properties to KSZ8081 Ethernet PHYs
>   ARM: dts: renesas: Add compatible properties to KSZ9031 Ethernet PHYs
>   iARM: dts: renesas: Add compatible properties to LAN8710A Ethernet
>     PHYs
>   ARM: dts: renesas: Add compatible properties to RTL8201FL Ethernet
>     PHYs
>   ARM: dts: renesas: Add compatible properties to uPD6061x Ethernet PHYs
>   arm64: dts: renesas: Add compatible properties to AR8031 Ethernet PHYs
>   arm64: dts: renesas: Add compatible properties to KSZ9031 Ethernet
>     PHYs
>   arm64: dts: renesas: Add compatible properties to RTL8211E Ethernet
>     PHYs

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
