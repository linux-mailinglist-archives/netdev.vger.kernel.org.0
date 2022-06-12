Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B75C547B24
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 19:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiFLRNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 13:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiFLRNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 13:13:51 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C44FF1;
        Sun, 12 Jun 2022 10:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1655054006;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=EocYAFQcyOsOHNYOtPDLZltnmSxJMwBedC8g9UxAB0k=;
    b=VifFVmIundfqm0uooUDEEUUVEaM7dA7JvbG0/e+jIELhH9d9xCyc4b/adUQ/m4uRe/
    zSXg1qF/7AVO2B5j2RnxQGsZq4xokCpBz1o970SEKHLnT+8tbn7bdjh4KmPiL2qQ+t+X
    FNJlhlF3BG7xubZ0tslXSQjU0jytwy+1oNwOMS0Cl5QL0mR9aTzGbiLE69Y0VF+Mg7us
    DBSYKIzeRAYnPZHoJ2mzUzjrVft7r/LDNw9GZVOSgpKq17JbtrdicluHz5mSN8tIMkoD
    W+45JzdXuEa2aHRIQsSUnB4o9Z1LO1enT06hTPSxpFyK0TS+fdMT55zhirJVrWYeKJW2
    XH7A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofov4eKq4TnA="
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy5CHDOKgn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 12 Jun 2022 19:13:24 +0200 (CEST)
Subject: Re: [PATCH v2 05/13] can: slcan: simplify the device de-allocation
To:     Max Staudt <max@enpas.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
 <20220608165116.1575390-6-dario.binacchi@amarulasolutions.com>
 <eae65531-bf9f-4e2e-97ca-a79a8aa833fc@hartkopp.net>
 <CABGWkvroJG16AOu8BODhVu068jacjHWbkkY9TCF4PQ7rgANVXA@mail.gmail.com>
 <20220612182302.36bdd9b9.max@enpas.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <aee0c161-5418-ad56-ab33-66e34a4f2a0d@hartkopp.net>
Date:   Sun, 12 Jun 2022 19:13:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220612182302.36bdd9b9.max@enpas.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.06.22 18:23, Max Staudt wrote:
> On Sat, 11 Jun 2022 12:46:04 +0200
> Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
> 
>>> As written before I would like to discuss this change out of your
>>> patch series "can: slcan: extend supported features" as it is no
>>> slcan feature extension AND has to be synchronized with the
>>> drivers/net/slip/slip.c implementation.
>>
>> Why do you need to synchronize it with  drivers/net/slip/slip.c
>> implementation ?
> 
> Because slcan.c is a derivative of slip.c and the code still looks
> *very* similar, so improvements in one file should be ported to the
> other and vice versa. This has happened several times now.
> 
> 
>>> When it has not real benefit and introduces more code and may create
>>> side effects, this beautification should probably be omitted at all.
>>>   
>>
>> I totally agree with you. I would have already dropped it if this
>> patch didn't make sense. But since I seem to have understood that
>> this is not the case, I do not understand why it cannot be improved
>> in this series.
> 
> This series is mostly about adding netlink support. If there is a point
> of contention about a beautification, it may be easier to discuss that
> separately, so the netlink code can be merged while the beautification
> is still being discussed.
> 
> 
> On another note, the global array of slcan_devs is really unnecessary
> and maintaining it is a mess - as seen in some of your patches, that
> have to account for it in tons of places and get complicated because of
> it.
> 
> slcan_devs is probably grandfathered from a very old kernel, since
> slip.c is about 30 years old, so I suggest to remove it entirely. In
> fact, it may be easier to patch slcan_devs away first, and that will
> simplify your open/close patches - your decision :)
> 
> 
> If you wish to implement the slcan_devs removal, here are some hints:
> 
> The private struct can just be allocated as part of struct can_priv in
> slcan_open(), like so:
> 
>    struct net_device *dev;
>    dev = alloc_candev(sizeof(struct slcan), 0);
> 
> And then accessed like so:
> 
>    struct slcan *sl = netdev_priv(dev);
> 
> Make sure to add struct can_priv as the first member of struct slcan:
> 
>    /* This must be the first member when using alloc_candev() */
>    struct can_priv can;
> 
> 
>> The cover letter highlighted positive reactions to the series because
>> the module had been requiring these kinds of changes for quite
>> some time. So, why not take the opportunity to finalize this patch in
>> this series even if it doesn't extend the supported features ?
> 
> Because... I can only speak for myself, but I'd merge all the
> unambiguous stuff first and discuss the difficult stuff later, if there
> are no interdependencies :)
> 
> 
> 
> Max
> 

Thanks for stepping in Max!

Couldn't have summarized it better ;-)

When I created slcan.c from slip.c this line discipline driver was just 
oriented at the SLIP idea including the user space tools to attach the 
network device to the serial tty.

Therefore the driver took most of the mechanics (like the slcan_devs 
array) and did *only* the 'struct canframe' to ASCII conversion (and 
vice versa).

@Dario: Implementing the CAN netlink API with open/close/bitrate-setting 
is a nice improvement. Especially as you wrote that you took care about 
the former/old API with slcan_attach/slcand.

Best regards,
Oliver
