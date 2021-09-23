Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC05041668D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbhIWUVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:21:30 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:57612 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243136AbhIWUV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 16:21:29 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru A9D3B20AB973
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
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
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-7-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <9aa57bf1-44a5-6016-5445-4f2b8518ddfe@omp.ru>
Date:   Thu, 23 Sep 2021 23:19:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-7-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:08 PM, Biju Das wrote:

> R-Car AVB-DMAC has 4 Transmit start Request queues, whereas
> RZ/G2L has only 1 Transmit start Request queue(Best Effort)
> 
> Add a multi_tsrq hw feature bit to struct ravb_hw_info to enable
> this only for R-Car. This will allow us to add single TSRQ support for
> RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index bb92469d770e..c043ee555be4 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1006,6 +1006,7 @@ struct ravb_hw_info {
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
>  	unsigned no_gptp:1;		/* AVB-DMAC does not support gPTP feature */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
> +	unsigned multi_tsrq:1;		/* AVB-DMAC has MULTI TSRQ */

   Maybe 'single_tx_q' instead?

>  };
>  
>  struct ravb_private {
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 8663d83507a0..d37d73f6d984 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -776,11 +776,17 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
>  /* function for waiting dma process finished */
>  static int ravb_stop_dma(struct net_device *ndev)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_hw_info *info = priv->info;
>  	int error;
>  
>  	/* Wait for stopping the hardware TX process */
> -	error = ravb_wait(ndev, TCCR,
> -			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
> +	if (info->multi_tsrq)
> +		error = ravb_wait(ndev, TCCR,
> +				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
> +	else
> +		error = ravb_wait(ndev, TCCR, TCCR_TSRQ0, 0);

   Aren't the TSRQ1/2/3 bits reserved on RZ/G2L? If so, this new flag adds a little value, I think... unless
you plan to use this flag further in the series?

MBR, Sergei
