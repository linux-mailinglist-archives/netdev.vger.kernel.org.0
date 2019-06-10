Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138123B0BE
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388228AbfFJIaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:30:18 -0400
Received: from muru.com ([72.249.23.125]:52442 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbfFJIaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 04:30:18 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id AEF5E807E;
        Mon, 10 Jun 2019 08:30:36 +0000 (UTC)
Date:   Mon, 10 Jun 2019 01:30:12 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>, eyalr@ti.com
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
Message-ID: <20190610083012.GV5447@atomide.com>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
 <87tvcxncuq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvcxncuq.fsf@codeaurora.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Kalle Valo <kvalo@codeaurora.org> [190610 07:01]:
> Eugeniu Rosca <erosca@de.adit-jv.com> writes:
> 
> > The wl1837mod datasheet [1] says about the WL_IRQ pin:
> >
> >  ---8<---
> > SDIO available, interrupt out. Active high. [..]
> > Set to rising edge (active high) on powerup.
> >  ---8<---
> >
> > That's the reason of seeing the interrupt configured as:
> >  - IRQ_TYPE_EDGE_RISING on HiKey 960/970
> >  - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms
> >
> > We assert that all those platforms have the WL_IRQ pin connected
> > to the SoC _directly_ (confirmed on HiKey 970 [2]).
> >
> > That's not the case for R-Car Kingfisher extension target, which carries
> > a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
> > between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
> > reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
> > configuration we would need to use IRQ_TYPE_EDGE_FALLING or
> > IRQ_TYPE_LEVEL_LOW.
> >
> > Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
> > support platform dependent interrupt types") made a special case out
> > of these interrupt types. After this commit, it is impossible to provide
> > an IRQ configuration via DTS which would describe an inverter present
> > between the WL18* chip and the SoC, generating the need for workarounds
> > like [3].
> >
> > Create a boolean OF property, called "invert-irq" to specify that
> > the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.
> >
> > This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
> > the DTS configuration [4] combined with the "invert-irq" property.
> >
> > [1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
> > [2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
> > [3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
> > [4] https://patchwork.kernel.org/patch/10895879/
> >     ("arm64: dts: ulcb-kf: Add support for TI WL1837")
> >
> > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> 
> Tony&Eyal, do you agree with this?

Yeah if there's some hardware between the WLAN device and the SoC
inverting the interrupt, I don't think we have clear a way to deal
with it short of setting up a separate irqchip that does the
translation.

But in some cases we also do not want to invert the interrupt, so
I think this property should take IRQ_TYPE_EDGE_RISING and
IRQ_TYPE_EDGE_RISING values to override the setting for
the WLAN end of the hardware?

Let's wait a bit longer for comments from Eyal too.

Regards,

Tony
