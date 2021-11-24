Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B74245B5A8
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhKXHk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:40:59 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:21307 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhKXHk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:40:58 -0500
X-Greylist: delayed 39316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2021 02:40:57 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637739455;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=1+iJsG/OZ6lKeRsw7alYS7uTLjD9Sx+z2LOa8a+A83U=;
    b=qknR8RBGc7rQDJ1/nHXSvJ9HLHogFOsBNEb7/PKW2f4KlZ2GxdNj5ySwKl55r2qOXn
    8SLb1ymo0GoQJBSNlydxvF5xBpZr4zBJ48kuBlmYUTu+GAmLbQzK82FBumzIi3BEtM2W
    krbobvGTKh4haTRv8ZsHPJM6RphwlpkVwK/Hlwlaxb4MmsCFnycSDgogGg4eAhcopecj
    xLXMmy5ffFiwFbNEFD8GlS1oZ7G49yW8D8GYYSNQ7qim+nU1WleWh1Q8XZXRNx6QmpD/
    yUOK19MClZly8O2nhCV40YuBzezgxHWSkMCvpsmlTe37dEXWLyqnIbRFV2RD7phVjNoC
    Zp6Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xAO7bY7KW
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 24 Nov 2021 08:37:34 +0100 (CET)
Subject: Re: [PATCH v2 net] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Markus Plessing <plessing@ems-wuensche.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20211124065618.GA3970@kili>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <bccacc1b-4c04-98f5-7b97-85664c238ec4@hartkopp.net>
Date:   Wed, 24 Nov 2021 08:37:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211124065618.GA3970@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

On 24.11.21 07:56, Dan Carpenter wrote:
> If the last channel is not available then "dev" is freed.  Fortunately,
> we can just use "pdev->irq" instead.

But in the case that we do not find any channel the irq for the card is 
still requested (via pdev->irq).

> 
> Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: In the first version, I just failed the probe.  Sorry about that.
> 
>   drivers/net/can/sja1000/ems_pcmcia.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
> index e21b169c14c0..391a8253ed6f 100644
> --- a/drivers/net/can/sja1000/ems_pcmcia.c
> +++ b/drivers/net/can/sja1000/ems_pcmcia.c
> @@ -234,7 +234,7 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
>   			free_sja1000dev(dev);
>   	}
>   
> -	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,

When adding this check, we should be fine:

+	if (card->channels)

> +	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
>   			  DRV_NAME, card);
>   	if (!err)
>   		return 0;
> 

Thanks for checking this code after so many years!

I saved that 17 year old EMS PCMCIA Card from my former CAN hardware box 
two weeks ago and made a 5.16-rc2 run on a 2006 Samsung X20 with Pentium 
M 1.7GHz yesterday. My only machine here at home with a PCMCIA slot :-D

https://www.amazon.de/Samsung-Centrino-1-73GHz-Graphic-Accelerator/dp/B000AXSIRE

And it still works with the CAN card!

Best regards,
Oliver


