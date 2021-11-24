Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD50545CA8C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349439AbhKXRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:05:42 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:10344 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349427AbhKXRF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637773321;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=YsI+Uvcu2mVZnzCbUX/g3GOSJ+GVB0keq4LPcWcaHrc=;
    b=lw7Y6IBSz+jeqjfo6igH/NgRAfaRw/UfuBI7modV3LcIJbF/B/ZW1JH/pNL7Haswxh
    lzb67OT3Wc0aIM9R92Xl3uSn4vL8IpUnjo4VdH1bhZlathwAMlIs1FNosJCj11Y/5lEd
    iYz/OUmVLXcg1nf6h/fwtTHsv/iOacmRwRWtVdrXxXnNRHdgnx/FOXBB+3qtmwP8Dy+a
    /paUm2erq5xWPFMMPaE3iNscJFYv9H1SBX+7LtrmKGuI8DDg9feV2DnEMqdqs5jqmZpz
    c6FiE72zt/0TrafSqBjQh4hFkeLaSg8mhrNARNRENLW9Pxmi1Cx0VZQZ1HEaFJpVbLsQ
    0nyQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.10 AUTH)
    with ESMTPSA id c09e88xAOH210PZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 24 Nov 2021 18:02:01 +0100 (CET)
Subject: Re: [PATCH v3 net] can: sja1000: fix use after free in
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
References: <20211124145041.GB13656@kili>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <7a217190-1a4e-dfdd-65be-a751bf8403ff@hartkopp.net>
Date:   Wed, 24 Nov 2021 18:01:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211124145041.GB13656@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.11.21 15:50, Dan Carpenter wrote:
> If the last channel is not available then "dev" is freed.  Fortunately,
> we can just use "pdev->irq" instead.
> 
> Also we should check if at least one channel was set up.
> 
> Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Dan!


> ---
> v3: add a check for if there is a channel.
> v2: fix a bug in v1.  Only one channel is required but my patch returned
>      if any channel was unavailable.
> 
>   drivers/net/can/sja1000/ems_pcmcia.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
> index e21b169c14c0..4642b6d4aaf7 100644
> --- a/drivers/net/can/sja1000/ems_pcmcia.c
> +++ b/drivers/net/can/sja1000/ems_pcmcia.c
> @@ -234,7 +234,12 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
>   			free_sja1000dev(dev);
>   	}
>   
> -	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
> +	if (!card->channels) {
> +		err = -ENODEV;
> +		goto failure_cleanup;
> +	}
> +
> +	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
>   			  DRV_NAME, card);
>   	if (!err)
>   		return 0;
> 
