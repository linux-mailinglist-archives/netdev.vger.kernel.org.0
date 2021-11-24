Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AF45B72B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhKXJQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:16:32 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26396 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKXJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637745188;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=kbMW+MnZuNJbES0znDsm6k2IBOsSxcU/81nHRALbX10=;
    b=JP1xSB2MY8WSUmUpqwkbV++u/u7wDp6gGyW4Jhx4WEmO334wP31WIBYP4i9IaHz6xn
    C8SFoey6uqnMfKRJXR+1U88yvRgNdvLcHU+YBg5tfACWnx9SVWc2chsUugfEt+n0uSXQ
    NMHf3AA6oNUS5VKTKxvExieqCbXZPThAv8h7EGEBVAOotVp3JIakBbp+pZ+A/aNF7uh7
    8yh0njdxFCIAuAer2zLCo9i6aLFU2DEjwYZBnF3h6iiidxdAhqlyHei8xN6JgAUPdcv1
    xET7umQEg1jfhhpnf7re17EJLxUl29aEOgv6rq5Uv/cjDtDh/YRpQUMywep46WvGktVw
    629A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xAO9D77tz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 24 Nov 2021 10:13:07 +0100 (CET)
Subject: Re: [PATCH v2 net] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Markus Plessing <plessing@ems-wuensche.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20211124065618.GA3970@kili>
 <bccacc1b-4c04-98f5-7b97-85664c238ec4@hartkopp.net>
 <20211124085704.GA18178@kadam>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <6cbe3d6e-c3f1-9d85-ade6-57cd626bd4b8@hartkopp.net>
Date:   Wed, 24 Nov 2021 10:13:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211124085704.GA18178@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.11.21 09:57, Dan Carpenter wrote:
> On Wed, Nov 24, 2021 at 08:37:27AM +0100, Oliver Hartkopp wrote:
>> Hello Dan,
>>
>> On 24.11.21 07:56, Dan Carpenter wrote:
>>> If the last channel is not available then "dev" is freed.  Fortunately,
>>> we can just use "pdev->irq" instead.
>>
>> But in the case that we do not find any channel the irq for the card is
>> still requested (via pdev->irq).
>>
>>>
>>> Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> v2: In the first version, I just failed the probe.  Sorry about that.
>>>
>>>    drivers/net/can/sja1000/ems_pcmcia.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
>>> index e21b169c14c0..391a8253ed6f 100644
>>> --- a/drivers/net/can/sja1000/ems_pcmcia.c
>>> +++ b/drivers/net/can/sja1000/ems_pcmcia.c
>>> @@ -234,7 +234,7 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
>>>    			free_sja1000dev(dev);
>>>    	}
>>> -	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
>>
>> When adding this check, we should be fine:
>>
>> +	if (card->channels)
> 
> Sure,  I will send a v3 with that.

With these discussed changes you might directly add my

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks,
Oliver
