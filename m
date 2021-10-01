Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F270A41F66F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 22:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355514AbhJAUpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 16:45:16 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:59030 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355465AbhJAUpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 16:45:10 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru AD2F120A504D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-3-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <232c6ad6-c35b-76c0-2800-e05ca2631048@omp.ru>
Date:   Fri, 1 Oct 2021 23:43:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001150636.7500-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 6:06 PM, Biju Das wrote:

> Rename the variable "no_ptp_cfg_active" with "gptp" and

   This shouldn't be a rename but the extension of the meaning instead...

> "ptp_cfg_active" with "ccc_gac" to match the HW features.
> 
> There is no functional change.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> RFc->v1:
>  * Renamed the variable "no_ptp_cfg_active" with "gptp" and
>    "ptp_cfg_active" with "ccc_gac
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  4 ++--
>  drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++------------
>  2 files changed, 15 insertions(+), 15 deletions(-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 8f2358caef34..dc7654abfe55 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1274,7 +1274,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
>  	if (netif_running(ndev)) {
>  		netif_device_detach(ndev);
>  		/* Stop PTP Clock driver */
> -		if (info->no_ptp_cfg_active)
> +		if (info->gptp)

   Where have you lost !info->ccc_gac?

>  			ravb_ptp_stop(ndev);
>  		/* Wait for DMA stopping */
>  		error = ravb_stop_dma(ndev);
> @@ -1306,7 +1306,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
>  		ravb_emac_init(ndev);
>  
>  		/* Initialise PTP Clock driver */
> -		if (info->no_ptp_cfg_active)
> +		if (info->gptp)
>  			ravb_ptp_init(ndev, priv->pdev);

    The same question here...

>  		netif_device_attach(ndev);
> @@ -1446,7 +1446,7 @@ static int ravb_open(struct net_device *ndev)
>  	ravb_emac_init(ndev);
>  
>  	/* Initialise PTP Clock driver */
> -	if (info->no_ptp_cfg_active)
> +	if (info->gptp)

   ... and here.

>  		ravb_ptp_init(ndev, priv->pdev);
>  
>  	netif_tx_start_all_queues(ndev);
> @@ -1460,7 +1460,7 @@ static int ravb_open(struct net_device *ndev)
>  
>  out_ptp_stop:
>  	/* Stop PTP Clock driver */
> -	if (info->no_ptp_cfg_active)
> +	if (info->gptp)
>  		ravb_ptp_stop(ndev);

    ... and here.

>  out_free_irq_nc_tx:
>  	if (!info->multi_irqs)
> @@ -1508,7 +1508,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
>  	netif_tx_stop_all_queues(ndev);
>  
>  	/* Stop PTP Clock driver */
> -	if (info->no_ptp_cfg_active)
> +	if (info->gptp)

    ... and here.

>  		ravb_ptp_stop(ndev);
>  
>  	/* Wait for DMA stopping */
> @@ -1543,7 +1543,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
>  
>  out:
>  	/* Initialise PTP Clock driver */
> -	if (info->no_ptp_cfg_active)
> +	if (info->gptp)
>  		ravb_ptp_init(ndev, priv->pdev);

    ... and here.
 
>  	netif_tx_start_all_queues(ndev);
> @@ -1752,7 +1752,7 @@ static int ravb_close(struct net_device *ndev)
>  	ravb_write(ndev, 0, TIC);
>  
>  	/* Stop PTP Clock driver */
> -	if (info->no_ptp_cfg_active)
> +	if (info->gptp)

    ... and here.

>  		ravb_ptp_stop(ndev);
>  
>  	/* Set the config mode to stop the AVB-DMAC's processes */
> @@ -2018,7 +2018,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
>  	.internal_delay = 1,
>  	.tx_counters = 1,
>  	.multi_irqs = 1,
> -	.ptp_cfg_active = 1,

   Where is 'gptp'?

> +	.ccc_gac = 1,
>  };
>  
>  static const struct ravb_hw_info ravb_gen2_hw_info = {
[...]
> @@ -2080,7 +2080,7 @@ static void ravb_set_config_mode(struct net_device *ndev)
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	const struct ravb_hw_info *info = priv->info;
>  
> -	if (info->no_ptp_cfg_active) {
> +	if (info->gptp) {

   Where have you lost !info->ccc_gac?

>  		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
>  		/* Set CSEL value */
>  		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
[...]

MBR, Sergey
