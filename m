Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809A442145
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437648AbfFLJpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:45:50 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:35281 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437298AbfFLJpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:45:50 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 57F603C00C6;
        Wed, 12 Jun 2019 11:45:47 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uyfoQNArz41o; Wed, 12 Jun 2019 11:45:41 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 3178E3C00BE;
        Wed, 12 Jun 2019 11:45:41 +0200 (CEST)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 12 Jun
 2019 11:45:41 +0200
Date:   Wed, 12 Jun 2019 11:45:38 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>
CC:     Simon Horman <horms+renesas@verge.net.au>,
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
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
Message-ID: <20190612094538.GA16575@vmlxhi-102.adit-jv.com>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
 <87tvcxncuq.fsf@codeaurora.org>
 <20190610083012.GV5447@atomide.com>
 <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
 <08bc4755-5f47-d792-8b5a-927b5fbe7619@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <08bc4755-5f47-d792-8b5a-927b5fbe7619@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.72.93.184]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

cc: Linus Walleij

On Tue, Jun 11, 2019 at 10:00:41AM +0100, Marc Zyngier wrote:
> On 11/06/2019 09:45, Geert Uytterhoeven wrote:
> > CC irqchip
> > 
> > Original thread at
> > https://lore.kernel.org/lkml/20190607172958.20745-1-erosca@de.adit-jv.com/
> > 
> > On Mon, Jun 10, 2019 at 10:30 AM Tony Lindgren <tony@atomide.com> wrote:
> >> * Kalle Valo <kvalo@codeaurora.org> [190610 07:01]:
> >>> Eugeniu Rosca <erosca@de.adit-jv.com> writes:
> >>>
> >>>> The wl1837mod datasheet [1] says about the WL_IRQ pin:
> >>>>
> >>>>  ---8<---
> >>>> SDIO available, interrupt out. Active high. [..]
> >>>> Set to rising edge (active high) on powerup.
> >>>>  ---8<---
> >>>>
> >>>> That's the reason of seeing the interrupt configured as:
> >>>>  - IRQ_TYPE_EDGE_RISING on HiKey 960/970
> >>>>  - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms
> >>>>
> >>>> We assert that all those platforms have the WL_IRQ pin connected
> >>>> to the SoC _directly_ (confirmed on HiKey 970 [2]).
> >>>>
> >>>> That's not the case for R-Car Kingfisher extension target, which carries
> >>>> a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
> >>>> between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
> >>>> reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
> >>>> configuration we would need to use IRQ_TYPE_EDGE_FALLING or
> >>>> IRQ_TYPE_LEVEL_LOW.
> >>>>
> >>>> Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
> >>>> support platform dependent interrupt types") made a special case out
> >>>> of these interrupt types. After this commit, it is impossible to provide
> >>>> an IRQ configuration via DTS which would describe an inverter present
> >>>> between the WL18* chip and the SoC, generating the need for workarounds
> >>>> like [3].
> >>>>
> >>>> Create a boolean OF property, called "invert-irq" to specify that
> >>>> the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.
> >>>>
> >>>> This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
> >>>> the DTS configuration [4] combined with the "invert-irq" property.
> >>>>
> >>>> [1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
> >>>> [2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
> >>>> [3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
> >>>> [4] https://patchwork.kernel.org/patch/10895879/
> >>>>     ("arm64: dts: ulcb-kf: Add support for TI WL1837")
> >>>>
> >>>> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> >>>
> >>> Tony&Eyal, do you agree with this?
> >>
> >> Yeah if there's some hardware between the WLAN device and the SoC
> >> inverting the interrupt, I don't think we have clear a way to deal
> >> with it short of setting up a separate irqchip that does the
> >> translation.
> > 
> > Yeah, inverting the interrupt type in DT works only for simple devices,
> > that don't need configuration.
> > A simple irqchip driver that just inverts the type sounds like a good
> > solution to me. Does something like that already exists?
> 
> We already have plenty of that in the tree, the canonical example
> probably being drivers/irqchip/irq-mtk-sysirq.c. It should be pretty
> easy to turn this driver into something more generic.

I don't think drivers/irqchip/irq-mtk-sysirq.c can serve the
use-case/purpose of this patch. The MTK driver seems to be dealing with
the polarity inversion of on-SoC interrupts which are routed to GiC,
whereas in this patch we are talking about an off-chip interrupt
wired to R-Car GPIO controller.

It looks to me that the nice DTS sketch shared by Linus Walleij in [5]
might come closer to the concept proposed by Geert? FWIW, the
infrastructure/implementation to make this possible is still not ready.

One question to the wlcore/wl18xx maintainers: Why exactly do you give
freedom to users to set the interrupt as LEVEL_LOW/EDGE_FALLING [6]?
Apparently, this:
 - complicates the wl18xx driver, thus increasing the chance for bugs
 - is not supposed to reflect any HW differences between boards using
   LEVEL_LOW/EDGE_FALLING and the boards using LEVEL_HIGH/EDGE_RISING
 - doesn't bring any obvious advantage to the users, who are expected to
   sense the same behavior regardless of the IRQ type set in DTS
 - prevent the users to set IRQ type to LEVEL_LOW/EDGE_FALLING when
   there is an inverter present between WL_IRQ and SoC
 - seems to be not used almost at all, as 99% of mainline DTS set the
   IRQ type to the canonical/NLCP LEVEL_HIGH/EDGE_RISING

[5] https://patchwork.ozlabs.org/patch/1095690/#2167076
  ("[V1,1/2] gpio: make it possible to set active-state on GPIO lines")
 --------------------8<-------------------
 gpio0: gpio {
    compatible = "foo,chip";
    gpio-controller;
    (...)
 };

 inv0: inverter {
     compatible = "inverter";
     gpio-controller;
     gpios = <&gpio0 0 GPIO_ACTIVE_HIGH>;
 };

 consumer {
    compatible = "bar";
    gpios = <&inv0 0 GPIO_ACTIVE_HIGH>;
 };
 --------------------8<-------------------

[6] bd763482c82ea2 ("wl18xx: wlan_irq: support platform dependent interrupt types")

-- 
Best Regards,
Eugeniu.
