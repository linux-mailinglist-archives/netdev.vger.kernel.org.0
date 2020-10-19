Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4869A2922AB
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 08:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgJSGx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 02:53:56 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:36413 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgJSGxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 02:53:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1603090431;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=kAXPWXn/V28vKUorUgYy18FRA3anHFBONzfmAMhglW8=;
        b=p8TzJmGhuXavgbWgKBAnF9OePul0JsJ3Cn3SZ7CvVf7IWK/xcSAQt3wc+kxsbr9bDl
        mBTAIGScbnYKIfovQt5KcCGrDtzqmRCKhPRVbQGRbIFuPbF1yRG1sH6a6wwvKY433/dE
        4QWuNgJxffHIu5PMsKgMCpkmUeFacdtShP6EZTGuzo6Q+gUk9m3Q5krvZ13rRLhfqxod
        HRhHfIv34MbX4tCMabVa36vIddVpIJEyOoPEukCP9K6aZcdIM77qMdxnJFu20vx9DnjI
        DX8Epp1+dU1I8cwQ7ydB3V3nNlDXSigs26LqmPZQjd8HjsxQw6B7Z4cw1FGVy+AWQANl
        HCVQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR8J8xpyF0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9J6rfhPc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 19 Oct 2020 08:53:41 +0200 (CEST)
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
 <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
 <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
 <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>
 <4e794974-8b87-9961-a144-fe9f5c236de6@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <be13fc56-ba1b-c56d-8992-420eea5024c6@hartkopp.net>
Date:   Mon, 19 Oct 2020 08:53:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4e794974-8b87-9961-a144-fe9f5c236de6@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19.10.20 08:28, Marc Kleine-Budde wrote:
> On 10/18/20 10:46 AM, Oliver Hartkopp wrote:
>> Oh, answering myself ...
>>
>> On 17.10.20 21:13, Oliver Hartkopp wrote:
>>>
>>>
>>> On 16.10.20 21:36, Marc Kleine-Budde wrote:
>>>> On 2/14/20 1:09 PM, Oleksij Rempel wrote:
>>>>> Hi all,
>>>>>
>>>>> any comments on this patch?
>>>>
>>>> I'm going to take this patch now for 5.10....Comments?
>>>
>>> Yes.
>>>
>>> Removing the sk reference will lead to the effect, that you will receive
>>> the CAN frames you have sent on that socket - which is disabled by default:
>>>
>>> https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L124
>>>
>>> See concept here:
>>>
>>> https://elixir.bootlin.com/linux/latest/source/Documentation/networking/can.rst#L560
>>>
>>>
>>> How can we maintain the CAN_RAW_RECV_OWN_MSGS to be disabled by default
>>> and fix the described problem?
>>
>>>>>> +    nskb = skb_clone(skb, GFP_ATOMIC);
>>>>>> +    if (unlikely(!nskb)) {
>>>>>> +        kfree_skb(skb);
>>>>>> +        return NULL;
>>>>>>        }
>>>>>> -    /* we can assume to have an unshared skb with proper owner */
>>>>>> -    return skb;
>>>>>> +    can_skb_set_owner(nskb, skb->sk);
>>
>> skb-> sk is still set here - so everything should be fine.
>>
>> Sorry for the noise.
> 
> Is this a Acked-by/Reviewed-by?

Yes.

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Marc!
