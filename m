Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6270652BE4C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiEROeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbiEROeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:34:04 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB13D1B176E;
        Wed, 18 May 2022 07:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652884439;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=86Er3ONQXvEiKRTEscf9XSc+0dLxP7J1WFsKTN+NR7Y=;
    b=i1avzboQzaCFQYlGeiJHzoKUOtnu19aVV5TgRWHiydIoKKTiRHz01fvGISWyQAtONV
    LQkHCaL5aqDXGc3mZzc9FMkgd8oNjKUOhuoOMjNl3p4lk7xvwXTsRwN8W6vL4QWI7JGB
    xwNrWY45pRRF55AmRNyYg3FVU6h/h8wVw4KIgjPh3UR6qj9KfNCetyFap23XYibJDMZz
    j5mK/WefllBmtBU/dtdDPNNjv2iK3CJMWN9McEpY3ejUyjVI6H/DVYbNZOGbvtHm0ThQ
    TsSNQC6R9wezY5HihYUaXmGDdZanLyPlCFxIDdAsjfghlxxy14BISecl6iykT5MW8yOv
    3/VA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4IEXxHnS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 18 May 2022 16:33:59 +0200 (CEST)
Message-ID: <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net>
Date:   Wed, 18 May 2022 16:33:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
 <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
 <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.05.22 16:07, Vincent MAILHOL wrote:

>>> It does. I've seen CAN setups (really more than one or two!) in VMs and
>>> container environments that are fed by Ethernet tunnels - sometimes also in
>>> embedded devices.
> 
> Are those VM running custom builds of the kernel in which all the CAN
> hardware devices have been removed? Also, isn't it hard to keep those
> up to date with all the kernel security patches?

AFAIK all kind of BSPs create custom configured kernels. And to remove 
attack surfaces the idea is to minimize the code size. That's not only 
to save some flash space.

>>>> A two level split (with or without rx-offload) is what makes the most
>>>> sense to me.
>>>>
>>>> Regardless, having the three level split is not harmful. And because
>>>> there seems to be a consensus on that, I am fine to continue in this
>>>> direction.
>>>
>>> Thanks!
>>>
>>> Should we remove the extra option for the bitrate calculation then?
>>
>> +1
> 
> I can imagine people wanting to ship a product with the bitrate
> calculation removed. For example, an infotainment unit designed for
> one specific vehicle platform (i.e. baudrate is fixed). In that case,
> the integrator might decide to remove bittiming calculation and
> hardcode all hand calculated bittiming parameters instead.
> 
> So that one, I prefer to keep it. I just didn't mention it in my
> previous message because it was already splitted out.

Ok. Interesting that we have such different expectations.

>>> And what about the LEDS support depending on BROKEN?
>>> That was introduced by commit 30f3b42147ba6f ("can: mark led trigger as
>>> broken") from Uwe as it seems there were some changes in 2018.
>>
>> There's a proper generic LED trigger now for network devices. So remove
>> LED triggers, too.
> 
> Yes, the broken LED topic also popped-up last year:
> 
> https://lore.kernel.org/linux-can/20210906143057.zrpor5fkh67uqwi2@pengutronix.de/ > I am OK to add one patch to the series for LED removal.

Hm. We have several drivers that support LED triggers:

$ git grep led.h
at91_can.c:#include <linux/can/led.h>
c_can/c_can_main.c:#include <linux/can/led.h>
ctucanfd/ctucanfd_base.c:#include <linux/can/led.h>
dev/dev.c:#include <linux/can/led.h>
flexcan/flexcan-core.c:#include <linux/can/led.h>
led.c:#include <linux/can/led.h>
m_can/m_can.h:#include <linux/can/led.h>
rcar/rcar_can.c:#include <linux/can/led.h>
rcar/rcar_canfd.c:#include <linux/can/led.h>
sja1000/sja1000.c:#include <linux/can/led.h>
spi/hi311x.c:#include <linux/can/led.h>
spi/mcp251x.c:#include <linux/can/led.h>
sun4i_can.c:#include <linux/can/led.h>
ti_hecc.c:#include <linux/can/led.h>
usb/mcba_usb.c:#include <linux/can/led.h>
usb/usb_8dev.c:#include <linux/can/led.h>
xilinx_can.c:#include <linux/can/led.h>

And I personally like the ability to be able to fire some LEDS (either 
as GPIO or probably in a window manager).

I would suggest to remove the Kconfig entry but not all the code inside 
the drivers, so that a volunteer can convert the LED support based on 
the existing trigger points in the drivers code later.

Our would it make sense to just leave some comment at those places like:

/* LED TX trigger here */

??

> Just some
> heads-up: I will take my time, it will definitely not be ready for the
> v5.19 merge window. And I also expect that there will be at least one
> more round of discussion.
> 
> While I am at it, anything else to add to the wish list before I start
> to working it?

Not really. IMO we already share a common picture now. Thanks for 
picking this up!

Best regards,
Oliver
