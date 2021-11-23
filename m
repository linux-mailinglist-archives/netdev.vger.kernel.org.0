Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7F45AD8A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbhKWUse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:48:34 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:32262 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhKWUse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637700138;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=vJxhfLbcral0UOweOEsyvR1QrhSyAJnoXf+Ogyf1Vao=;
    b=bbxTuVrs5A11wSnNA10BNer2c0q2Xpr1Dw9f3V7+Glpi9HBbbZOZZLCRCoE26huja0
    W5Xir2T/b4Hab/75B6VAdS9vWYjjbzHKvObrTaTptL4pDoD8JG8v61efpdtLWnKj9FQz
    0OwtV+oDUs2bHPikgY4Feb60IeY83BuWItaQs7DENmKgo3Ar71+VNXrazX0nOXTge75r
    ddKKIT+W5L2VwtgRWsO1pFkfdwt/cCjUzzr43TKVlWuJmso7I9nEDvuZdrnFfZ8Mkwop
    6wwQGKiGv8xPyaUD+gLZrMYjKMBWiTiqS+2TtPiW9ZEMz5ueLLEGjZuSKyWMv1hoZ3jV
    pqDw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xANKgI6YC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 21:42:18 +0100 (CET)
Subject: Re: [PATCH net-next] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20211122075614.GB6581@kili>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <72ed48e9-0659-78f9-1b31-be54b118ab76@hartkopp.net>
Date:   Tue, 23 Nov 2021 21:42:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122075614.GB6581@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

On 22.11.21 08:56, Dan Carpenter wrote:
> In the original code if ems_pcmcia_check_chan() returned false then
> it called free_sja1000dev(dev) but did not set the error code or jump
> to the clean up code.  This frees "dev" and leads to a use after free.
> 
> I flipped the ems_pcmcia_check_chan() check around to make the error
> handling more consistent and readable.  That lets us pull the rest of
> the code in one tab.
> 
> Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

I do not think, that you are fixing something here.

The loop

for (i = 0; i < EMS_PCMCIA_MAX_CHAN; i++) { ...

checks with

if (ems_pcmcia_check_chan(priv))

whether this channel is 'available' or not.

As this hardware could come with only ONE channel it is just wrong to 
tag a missing channel as error and finally kill the entire setup process 
(including the potentially working channel we already initialized).

So thanks for the patch but NACK ;-)

Best regards,
Oliver


> ---
>   drivers/net/can/sja1000/ems_pcmcia.c | 44 +++++++++++++++-------------
>   1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
> index e21b169c14c0..271fe9444827 100644
> --- a/drivers/net/can/sja1000/ems_pcmcia.c
> +++ b/drivers/net/can/sja1000/ems_pcmcia.c
> @@ -210,28 +210,30 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
>   			(i * EMS_PCMCIA_CAN_CTRL_SIZE);
>   
>   		/* Check if channel is present */
> -		if (ems_pcmcia_check_chan(priv)) {
> -			priv->read_reg  = ems_pcmcia_read_reg;
> -			priv->write_reg = ems_pcmcia_write_reg;
> -			priv->can.clock.freq = EMS_PCMCIA_CAN_CLOCK;
> -			priv->ocr = EMS_PCMCIA_OCR;
> -			priv->cdr = EMS_PCMCIA_CDR;
> -			priv->flags |= SJA1000_CUSTOM_IRQ_HANDLER;
> -
> -			/* Register SJA1000 device */
> -			err = register_sja1000dev(dev);
> -			if (err) {
> -				free_sja1000dev(dev);
> -				goto failure_cleanup;
> -			}
> -
> -			card->channels++;
> -
> -			printk(KERN_INFO "%s: registered %s on channel "
> -			       "#%d at 0x%p, irq %d\n", DRV_NAME, dev->name,
> -			       i, priv->reg_base, dev->irq);
> -		} else
> +		if (!ems_pcmcia_check_chan(priv)) {
> +			err = -EINVAL;
>   			free_sja1000dev(dev);
> +			goto failure_cleanup;
> +		}
> +		priv->read_reg  = ems_pcmcia_read_reg;
> +		priv->write_reg = ems_pcmcia_write_reg;
> +		priv->can.clock.freq = EMS_PCMCIA_CAN_CLOCK;
> +		priv->ocr = EMS_PCMCIA_OCR;
> +		priv->cdr = EMS_PCMCIA_CDR;
> +		priv->flags |= SJA1000_CUSTOM_IRQ_HANDLER;
> +
> +		/* Register SJA1000 device */
> +		err = register_sja1000dev(dev);
> +		if (err) {
> +			free_sja1000dev(dev);
> +			goto failure_cleanup;
> +		}
> +
> +		card->channels++;
> +
> +		printk(KERN_INFO "%s: registered %s on channel "
> +		       "#%d at 0x%p, irq %d\n", DRV_NAME, dev->name,
> +		       i, priv->reg_base, dev->irq);
>   	}
>   
>   	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
> 
