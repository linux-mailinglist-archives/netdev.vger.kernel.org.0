Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0165E44614
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404275AbfFMQtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:49:07 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:47152 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfFMEhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:37:21 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=svr-ies-mbx-01.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hbHU5-0001Yz-Ai from Harish_Kandiga@mentor.com ; Wed, 12 Jun 2019 21:37:09 -0700
Received: from [10.0.3.15] (137.202.0.90) by svr-ies-mbx-01.mgc.mentorg.com
 (139.181.222.1) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Thu, 13 Jun
 2019 05:37:01 +0100
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
To:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
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
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
 <87tvcxncuq.fsf@codeaurora.org> <20190610083012.GV5447@atomide.com>
 <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
 <08bc4755-5f47-d792-8b5a-927b5fbe7619@arm.com>
 <20190612094538.GA16575@vmlxhi-102.adit-jv.com>
 <86d0jjglax.wl-marc.zyngier@arm.com>
 <20190612150644.GA22002@vmlxhi-102.adit-jv.com>
From:   Harish Jenny K N <harish_kandiga@mentor.com>
Message-ID: <e878bb37-3228-0055-bf6e-69be7f7a09df@mentor.com>
Date:   Thu, 13 Jun 2019 10:06:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612150644.GA22002@vmlxhi-102.adit-jv.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-04.mgc.mentorg.com (139.181.222.4) To
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/06/19 8:36 PM, Eugeniu Rosca wrote:
> Hi Marc,
>
> Thanks for your comment.
>
> On Wed, Jun 12, 2019 at 11:17:10AM +0100, Marc Zyngier wrote:
>> Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
>>> On Tue, Jun 11, 2019 at 10:00:41AM +0100, Marc Zyngier wrote:
> [..]
>>>> We already have plenty of that in the tree, the canonical example
>>>> probably being drivers/irqchip/irq-mtk-sysirq.c. It should be pretty
>>>> easy to turn this driver into something more generic.
>>> I don't think drivers/irqchip/irq-mtk-sysirq.c can serve the
>>> use-case/purpose of this patch. The MTK driver seems to be dealing with
>>> the polarity inversion of on-SoC interrupts which are routed to GiC,
>>> whereas in this patch we are talking about an off-chip interrupt
>>> wired to R-Car GPIO controller.
>> And how different is that? The location of the interrupt source is
>> pretty irrelevant here.
> The main difference which I sense is that a driver like irq-mtk-sysirq
> mostly (if not exclusively) deals with internal kernel implementation
> detail (tuned via DT) whilst adding an inverter for GPIO IRQs raises
> a whole bunch of new questions (e.g. how to arbitrate between
> kernel-space and user-space IRQ polarity configuration?).
>
>> The point is that there is already a general
>> scheme to deal with these "signal altering widgets", and that we
>> should try to reuse at least the concept, if not the code.
> Since Harish Jenny K N might be working on a new driver doing GPIO IRQ
> inversion, I have CC-ed him as well to avoid any overlapping work.


Sorry I am not completely aware of the background discussion.

But here is the link to my proposal for new consumer driver to provide a new virtual
gpio controller to configure the polarity of the gpio pins used by the userspace.

https://www.spinics.net/lists/linux-gpio/msg39681.html


>
>>> It looks to me that the nice DTS sketch shared by Linus Walleij in [5]
>>> might come closer to the concept proposed by Geert? FWIW, the
>>> infrastructure/implementation to make this possible is still not
>>> ready.
>> Which looks like what I'm suggesting.
> Then we are on the same page. Thanks.
>
>> 	M.
>>
>> -- 
>> Jazz is not dead, it just smells funny.

