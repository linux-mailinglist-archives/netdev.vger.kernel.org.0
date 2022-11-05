Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8A961D8F1
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 10:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKEJBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 05:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKEJBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 05:01:31 -0400
X-Greylist: delayed 66788 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Nov 2022 02:01:28 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7CD1D0D2;
        Sat,  5 Nov 2022 02:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667638881;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=8GPoNWCoEi+P8snicppefnRlPeC5bI51GQlmNHRdgRg=;
    b=JJjMCPIEpRP0lnMm+5+UssuEagtchhJ18CuKDCC88HTEIXwUtlTeLAfjx+CSIPWc6t
    RnUQtXJzaOnYl4NxmXLJB9LM/qXkhBw6ccd7s2jY8lpECGlUIoZBTNIWCDyVZwJXhvah
    3z/2XjzN4cLt8HVUALot4DyVZDYTuOCHo7oUPhE7bexzAWII7m2vLjBdJad5aLdSTGOK
    S7nmP9GciBvm9bRsK2KKj0RsACvLzZHxGsEnr5++NYssX2XE/b0H9VRZyIg2QHutK9k7
    qDXZUNfJC6aUwiYqtNT9zooaByBi2zNdoh1MqlA5yZw/cteQcW1beylRUcUCjLrUBu5C
    J6FA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA591KRs1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 5 Nov 2022 10:01:20 +0100 (CET)
Message-ID: <f7389601-40aa-2372-b185-387bd20fe701@hartkopp.net>
Date:   Sat, 5 Nov 2022 10:01:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net 4/5] can: dev: fix skb drop check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org
References: <20221104130535.732382-1-mkl@pengutronix.de>
 <20221104130535.732382-5-mkl@pengutronix.de>
 <20221104115059.429412fb@kernel.org>
 <68896ba9-68c6-1f7a-3c6c-c3ee3c98e32f@hartkopp.net>
 <20221104153611.53758e3a@kernel.org>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221104153611.53758e3a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.11.22 23:36, Jakub Kicinski wrote:
> On Fri, 4 Nov 2022 21:33:16 +0100 Oliver Hartkopp wrote:
>> On 04.11.22 19:50, Jakub Kicinski wrote:
>>> On Fri,  4 Nov 2022 14:05:34 +0100 Marc Kleine-Budde wrote:
>>>> -	if (can_dropped_invalid_skb(ndev, skb))
>>>> +	if (can_dev_dropped_skb(dev, skb))
>>>
>>> Compiler says "Did you mean ndev"?
>>
>> Your compiler is a smart buddy! Sorry!
>>
>> Marc added that single change to my patch for the pch_can.c driver
>> (which is removed in net-next but not in 6.1-rc).
>>
>> And in pch_can.c the netdev is named ndev.
>>
>> Would you like to fix this up on your own or should we send an updated
>> PR for the series?
> 
> Updated PR would be better, if possible.
> We don't edit patches locally much (at all?) when applying to netdev.

Ok, thanks!

I have posted another patch which could be added to the updated PR too then.

https://lore.kernel.org/linux-can/20221104142551.16924-1-socketcan@hartkopp.net/T/#u

Best regards,
Oliver
