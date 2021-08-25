Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79E3F7C6E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbhHYSuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:50:06 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:33658 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbhHYSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:50:05 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru F328020A515B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH net-next 02/13] ravb: Add multi_irq to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-3-biju.das.jz@bp.renesas.com>
Organization: Open Mobile Platform
Message-ID: <e68993e6-add4-dcd1-3ae2-0f4b3f768d3e@omp.ru>
Date:   Wed, 25 Aug 2021 21:49:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> R-Car Gen3 supports separate interrupts for E-MAC and DMA queues,
> whereas R-Car Gen2 and RZ/G2L have a single interrupt instead.
> 
> Add a multi_irq hw feature bit to struct ravb_hw_info to enable

   So you have 'multi_irq' in the patch subject/description but 'multi_irqs'?
Not very consistent...

> this only for R-Car Gen3.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 22 ++++++++++++++--------
>  drivers/net/ethernet/renesas/ravb_ptp.c  |  8 +++++---
>  3 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 84700a82a41c..da486e06b322 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -997,6 +997,7 @@ struct ravb_hw_info {
>  	/* hardware features */
>  	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
> +	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */

   It's generally written IRQs but we can live with that. :-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
> index 6984bd5b7da9..c099656dd75b 100644
> --- a/drivers/net/ethernet/renesas/ravb_ptp.c
> +++ b/drivers/net/ethernet/renesas/ravb_ptp.c
[...]
> @@ -252,7 +254,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
>  		error = ravb_ptp_update_compare(priv, (u32)start_ns);
>  		if (!error) {
>  			/* Unmask interrupt */
> -			if (priv->chip_id == RCAR_GEN2)
> +			if (!info->multi_irqs)
>  				ravb_modify(ndev, GIC, GIC_PTME, GIC_PTME);
>  			else
>  				ravb_write(ndev, GIE_PTMS0, GIE);
> @@ -264,7 +266,7 @@ static int ravb_ptp_perout(struct ptp_clock_info *ptp,
>  		perout->period = 0;
>  
>  		/* Mask interrupt */
> -		if (priv->chip_id == RCAR_GEN2)
> +		if (!info->multi_irqs)
>  			ravb_modify(ndev, GIC, GIC_PTME, 0);
>  		else
>  			ravb_write(ndev, GID_PTMD0, GID);

   Hm... Let's assume GIE/GID are a part of multi-IRQ feature...

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
