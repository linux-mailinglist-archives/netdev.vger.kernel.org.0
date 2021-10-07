Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68524425417
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhJGNaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:30:21 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:46022 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241287AbhJGNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633613307; x=1665149307;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=OtxaPdc9nCj58wqh5NA9JcRznQexEFxjFLqqlEhFp7s=;
  b=xlM4FZm507dzzb3cT9lL2FMeDtFD0zmySCuMjckfQPr9jiUQcVTbjVGA
   /IaeOfTaLATFY6VEVDc87iSxe7R8rgDuGt18DHqrsvsWC6OxowzXuRRbW
   vhLZrXptHl750gjiEJDP1Io7q7RUJi5+yT8oZLA0UbUcRqom+hV8ejf2q
   zFBjATdttp8RHXwS+caR8shtWT2gA4f5R9tUIxmTn1Ii8Z+lTn84Xize6
   iO/KIVOoJOY6PeWhXBTk/9fqR32+tbP6i3PDo51bUZvqsDGezRTxFOl+c
   ThR0UxT+ljYKomRN1IKe4slbQkSsHPas0r0CT14R2YsH3e90cqFuTHTxJ
   w==;
IronPort-SDR: MY1/8bnyhRLbIxxiQe7hzBwhAEMc1kE0v0ibPOsaD04QOdYFArX+bXBNz2DACy4mxF3dzegbfo
 Udklacoj5AQwWFOTtJv3zVimz6gRI7/mbMCmg83n6cSY8R4DRSJv46cc+dcImX4MrULc1DyMqF
 UZ1WWH1WzBKUdNDjvhghyZTr6zMXCJSvg2/mcRdyjnPG/NBlitwz/z04LAhLTJ443GlfWsdzoY
 KIy600DHd3rcgvtmAUm3RqvrKssawB9tFI0ebLL0QMycT2vDi7Uqt3VqO0qAsItI6kaQrJ2OTx
 YLNsKHDqM8ZXEfj3F7POVBzI
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="147133223"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 06:28:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 06:28:26 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 7 Oct 2021 06:28:24 -0700
Subject: Re: [PATCH] can: at91_can: fix passive-state AERR flooding
To:     Brandon Maier <brandon.maier@rockwellcollins.com>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Ludovic Desroches" <ludovic.desroches@microchip.com>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Microchip (AT91) SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211005183023.109328-1-brandon.maier@rockwellcollins.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ac0aaa78-d258-fb22-300a-43851006b5c5@microchip.com>
Date:   Thu, 7 Oct 2021 15:28:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211005183023.109328-1-brandon.maier@rockwellcollins.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2021 at 20:30, Brandon Maier wrote:
> When the at91_can is a single node on the bus and a user attempts to
> transmit, the can state machine will report ack errors and increment the
> transmit error count until it reaches the passive-state. Per the
> specification, it will then transmit with a passive error, but will stop
> incrementing the transmit error count. This results in the host machine
> being flooded with the AERR interrupt forever, or until another node
> rejoins the bus.
> 
> To prevent the AERR flooding, disable the AERR interrupt when we are in
> passive mode.
> 
> Signed-off-by: Brandon Maier <brandon.maier@rockwellcollins.com>

Even if I'm not familiar with the matter, the explanation above makes sense:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Brandon, best regards,
   Nicolas

> ---
>   drivers/net/can/at91_can.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
> index b06af90a9964..2a8831127bd0 100644
> --- a/drivers/net/can/at91_can.c
> +++ b/drivers/net/can/at91_can.c
> @@ -804,8 +804,13 @@ static int at91_poll(struct napi_struct *napi, int quota)
>                  work_done += at91_poll_err(dev, quota - work_done, reg_sr);
> 
>          if (work_done < quota) {
> -               /* enable IRQs for frame errors and all mailboxes >= rx_next */
> +               /* enable IRQs for frame errors and all mailboxes >= rx_next,
> +                * disable the ack error in passive mode to avoid flooding
> +                * ourselves with interrupts
> +                */
>                  u32 reg_ier = AT91_IRQ_ERR_FRAME;
> +               if (priv->can.state == CAN_STATE_ERROR_PASSIVE)
> +                       reg_ier &= ~AT91_IRQ_AERR;
> 
>                  reg_ier |= get_irq_mb_rx(priv) & ~AT91_MB_MASK(priv->rx_next);
> 
> --
> 2.30.2
> 


-- 
Nicolas Ferre
