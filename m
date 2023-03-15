Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196D76BB7F1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjCOPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjCOPew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:34:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275BE367F3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:34:50 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pcT9G-0003vH-Kw; Wed, 15 Mar 2023 16:34:42 +0100
Message-ID: <23ced57d-27d5-4faa-70bb-9732a357a3cc@pengutronix.de>
Date:   Wed, 15 Mar 2023 16:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <CACRpkdbowrfYZpNKA32S8GT=8x_h+ZW4gd2Kj6FZkP1SZmDEPw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CACRpkdbowrfYZpNKA32S8GT=8x_h+ZW4gd2Kj6FZkP1SZmDEPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On 15.03.23 14:15, Linus Walleij wrote:
> On Wed, Mar 15, 2023 at 2:09 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> 
>> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
>> with the expectation that priv has enough trailing space.
>>
>> However, only realtek-smi actually allocated this chip_data space.
>> Do likewise in realtek-mdio to fix out-of-bounds accesses.
>>
>> Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for the review.
 
> That this worked for so long is kind of scary, and the reason why we run Kasan
> over so much code, I don't know if Kasan would have found this one.

It still worked. I looked into it some more and for some reason, struct realtek_priv
has a char buf[4096] member that's unused. I assume it caused kmalloc to return a 8K
slab, where the out-of-bound writes didn't overwrite anything of value. That buffer
ought to be removed, but that's for net-next.

I just checked with KASAN and it does detect the OOB on ARM64. I first noticed the
bug on barebox though, which has a near verbatim port of the Linux driver, but a
TLSF allocator, which fits allocations more tightly, hence it crashes not long
after driver probe unlike Linux.

> Rewriting the whole world in Rust will fix this problem, but it will
> take a while...

^^'.

Cheers,
Ahmad



> 
> Yours,
> Linus Walleij
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

