Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6273C646
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404028AbfFKIp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:45:26 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33567 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391273AbfFKIpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:45:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so8661254lfe.0;
        Tue, 11 Jun 2019 01:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y57jG1hTaYr//V6rbS7pGOghJQuFRY1IGCsOl42VTtw=;
        b=sG+5h+hDch9dcy+V7HourwlMxNveon6WvUpYb9Kv/I2kr37d5scsZ6MhMy8eWoUrjp
         4IxDSIAJddwRMIHfRUz0wadw/0hU/evqUnsc07C/zgUQRntRAzhw/kok91gIBJIFwFBT
         sA6WPnLEHNZgMOHjBYQZ6NXnZXZVzlnE8JgjBBvToRJOKX+YSoFEkzydmuz8bokE84jT
         1WpmnR/ov9p6X1LfR+mjS1VTesuZ2HlcFulbukFLRjGhjigNcZ5pCRszabvvskXT+oMH
         NA0Q1ufHt7o9u7VL4iA3CdAAgwVZTJIp/aG7dZKRaIf/1Igxr4f4ikf0TG8c9cGYOztZ
         XTfQ==
X-Gm-Message-State: APjAAAWvp3500zZ/iGjzHVwGvB13dnABjf7QV3waxNv7vszoTxREEzzU
        Tx8EeJhNYUbp3/7avocksiKPS0rijwjeG7ZPSFA=
X-Google-Smtp-Source: APXvYqxdEI+m9gpVR9aDf6TiX8mC2NIvGhVvINnkOeatfGs/HFjyi0AXbZ47oirabwL+5YNhqaUJ8bMV5DqFEmGW2bE=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr13628892lfn.23.1560242721494;
 Tue, 11 Jun 2019 01:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190607172958.20745-1-erosca@de.adit-jv.com> <87tvcxncuq.fsf@codeaurora.org>
 <20190610083012.GV5447@atomide.com>
In-Reply-To: <20190610083012.GV5447@atomide.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jun 2019 10:45:08 +0200
Message-ID: <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
To:     Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>, eyalr@ti.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC irqchip

Original thread at
https://lore.kernel.org/lkml/20190607172958.20745-1-erosca@de.adit-jv.com/

On Mon, Jun 10, 2019 at 10:30 AM Tony Lindgren <tony@atomide.com> wrote:
> * Kalle Valo <kvalo@codeaurora.org> [190610 07:01]:
> > Eugeniu Rosca <erosca@de.adit-jv.com> writes:
> >
> > > The wl1837mod datasheet [1] says about the WL_IRQ pin:
> > >
> > >  ---8<---
> > > SDIO available, interrupt out. Active high. [..]
> > > Set to rising edge (active high) on powerup.
> > >  ---8<---
> > >
> > > That's the reason of seeing the interrupt configured as:
> > >  - IRQ_TYPE_EDGE_RISING on HiKey 960/970
> > >  - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms
> > >
> > > We assert that all those platforms have the WL_IRQ pin connected
> > > to the SoC _directly_ (confirmed on HiKey 970 [2]).
> > >
> > > That's not the case for R-Car Kingfisher extension target, which carries
> > > a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
> > > between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
> > > reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
> > > configuration we would need to use IRQ_TYPE_EDGE_FALLING or
> > > IRQ_TYPE_LEVEL_LOW.
> > >
> > > Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
> > > support platform dependent interrupt types") made a special case out
> > > of these interrupt types. After this commit, it is impossible to provide
> > > an IRQ configuration via DTS which would describe an inverter present
> > > between the WL18* chip and the SoC, generating the need for workarounds
> > > like [3].
> > >
> > > Create a boolean OF property, called "invert-irq" to specify that
> > > the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.
> > >
> > > This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
> > > the DTS configuration [4] combined with the "invert-irq" property.
> > >
> > > [1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
> > > [2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
> > > [3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
> > > [4] https://patchwork.kernel.org/patch/10895879/
> > >     ("arm64: dts: ulcb-kf: Add support for TI WL1837")
> > >
> > > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> >
> > Tony&Eyal, do you agree with this?
>
> Yeah if there's some hardware between the WLAN device and the SoC
> inverting the interrupt, I don't think we have clear a way to deal
> with it short of setting up a separate irqchip that does the
> translation.

Yeah, inverting the interrupt type in DT works only for simple devices,
that don't need configuration.
A simple irqchip driver that just inverts the type sounds like a good
solution to me. Does something like that already exists?

> But in some cases we also do not want to invert the interrupt, so
> I think this property should take IRQ_TYPE_EDGE_RISING and
> IRQ_TYPE_EDGE_RISING values to override the setting for
> the WLAN end of the hardware?
>
> Let's wait a bit longer for comments from Eyal too.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
