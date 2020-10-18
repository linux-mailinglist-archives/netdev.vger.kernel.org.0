Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF429167A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 10:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgJRIqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 04:46:48 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:32037 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgJRIqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 04:46:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1603010805;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Dw0n2hwrjKjkfZguVc3gnKkizKQo0iOm9G/eHwg89x4=;
        b=aWv2lr3pWAXa0UHkoQm03i9yj0m07EZTccZ17l5FqkBtltKMWDcW/gs8nYhBxN7BZ+
        f64cXZm0vZnZFzZfu6XacrWNzPNt+BovaEbTHrqH56JSkMm/uvkaeWNEbpQPkpN99jfw
        wspJCptS7QaWy9iW68T/RrKIbwJdR9AMNnBOxcKcTGMdsMkueyKraznmrHx/JjisMFLC
        nT7UY5vNit+VrO1PDcdTLMTb0nE0rr7Ixe8CdRiYaE8vnchkz8GIrDMP5X/wwLmp6rFZ
        nLog4L7NLFAgV2w1AvoIl3YeOlohKlOYUpZDifZETwAFCYO4UKHk18OBkwY8pOeSdX86
        YqbA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVNiOMxqpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9I8keg8w
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 18 Oct 2020 10:46:40 +0200 (CEST)
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
 <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
 <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
Message-ID: <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>
Date:   Sun, 18 Oct 2020 10:46:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, answering myself ...

On 17.10.20 21:13, Oliver Hartkopp wrote:
> 
> 
> On 16.10.20 21:36, Marc Kleine-Budde wrote:
>> On 2/14/20 1:09 PM, Oleksij Rempel wrote:
>>> Hi all,
>>>
>>> any comments on this patch?
>>
>> I'm going to take this patch now for 5.10....Comments?
> 
> Yes.
> 
> Removing the sk reference will lead to the effect, that you will receive 
> the CAN frames you have sent on that socket - which is disabled by default:
> 
> https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L124
> 
> See concept here:
> 
> https://elixir.bootlin.com/linux/latest/source/Documentation/networking/can.rst#L560 
> 
> 
> How can we maintain the CAN_RAW_RECV_OWN_MSGS to be disabled by default 
> and fix the described problem?

>>>> +    nskb = skb_clone(skb, GFP_ATOMIC);
>>>> +    if (unlikely(!nskb)) {
>>>> +        kfree_skb(skb);
>>>> +        return NULL;
>>>>       }
>>>> -    /* we can assume to have an unshared skb with proper owner */
>>>> -    return skb;
>>>> +    can_skb_set_owner(nskb, skb->sk);

skb-> sk is still set here - so everything should be fine.

Sorry for the noise.

Regards,
Oliver

