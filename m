Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90A52BC1F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiERNKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbiERNKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:10:49 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C622517;
        Wed, 18 May 2022 06:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652879444;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=6TMF40b1ulLF+Snq+k1FxHMJfQT/QbJmSUwGUPENt/A=;
    b=MjS6sLULLYotqBREueexxg3tM61MnhbxRILC/AcAgTTW8LJWA5JLXqx/RXsoPYHx9Z
    76lIH7sldeDkaBgsvkMursM8nMz0w30DcgE0p1XKajFlctskn7ydBEMavo8VK8uX5CRk
    7NRKcY82gYCSx73FsG23C+GFFBySdKGYus7DAC/J62jIJDhwwAL5vG1FXxPR13V9IO4/
    pST4Ocf0MbNQ68o4maftQ8CkitzeWNhwZfdwzsRatojM4xAnMyzlJevuU1d2KhtdyEud
    QWAPfGDDlyh0E1C0WE4EHRLid9fskgjNUGSAmZuQfpugEvnTO6mp5sYG6P53vuUDfTve
    mQWw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4IDAiHUw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 18 May 2022 15:10:44 +0200 (CEST)
Message-ID: <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
Date:   Wed, 18 May 2022 15:10:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Max Staudt <max@enpas.org>, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.05.22 14:03, Vincent MAILHOL wrote:
> I didn't think this would trigger such a passionate discussion!

:-D

Maybe your change was the drop that let the bucket run over ;-)

>> But e.g. the people that are running Linux instances in a cloud only
>> using vcan and vxcan would not need to carry the entire infrastructure
>> of CAN hardware support and rx-offload.
> 
> Are there really some people running custom builds of the Linux kernel
> in a cloud environment? The benefit of saving a few kilobytes by not
> having to carry the entire CAN hardware infrastructure is blown away
> by the cost of having to maintain a custom build.

When looking to the current Kconfig and Makefile content in 
drivers/net/can(/dev) there is also some CONFIG_CAN_LEDS which "depends 
on BROKEN" and builds a leds.o from a non existing leds.c ?!?

Oh leds.c is in drivers/net/can/leds.c but not in 
drivers/net/can/dev/leds.c where it could build ... ?

So what I would suggest is that we always build a can-dev.ko when a CAN 
driver is needed.

Then we have different options that may be built-in:

1. netlink hw config interface
2. bitrate calculation
3. rx-offload
4. leds

E.g. having the netlink interface without bitrate calculation does not 
make sense to me too.

> I perfectly follow the idea to split rx-offload. Integrators building
> some custom firmware for an embedded device might want to strip out
> any unneeded piece. But I am not convinced by this same argument when
> applied to v(x)can.

It does. I've seen CAN setups (really more than one or two!) in VMs and 
container environments that are fed by Ethernet tunnels - sometimes also 
in embedded devices.

> A two level split (with or without rx-offload) is what makes the most
> sense to me.
> 
> Regardless, having the three level split is not harmful. And because
> there seems to be a consensus on that, I am fine to continue in this
> direction.

Thanks!

Should we remove the extra option for the bitrate calculation then?

And what about the LEDS support depending on BROKEN?
That was introduced by commit 30f3b42147ba6f ("can: mark led trigger as 
broken") from Uwe as it seems there were some changes in 2018.

Best regards,
Oliver
