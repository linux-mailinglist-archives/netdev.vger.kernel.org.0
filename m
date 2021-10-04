Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508594215D6
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhJDSCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:02:25 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:34728 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbhJDSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 14:02:23 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 5126D20A6900
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
Date:   Mon, 4 Oct 2021 21:00:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
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

> R-Car AVB-DMAC has 4 Transmit start request queues, whereas
> RZ/G2L has only 1 Transmit start request queue.

   The TCCR bits are called transmit start request (queue 0/1), not transmit start request queue 0/1.
I think you've read too much value into them for what is just TX queue 0/1.

> Add a tsrq variable to struct ravb_hw_info to handle this
> difference.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> RFC->v1:
>  * Added tsrq variable instead of multi_tsrq feature bit.
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 9cd3a15743b4..c586070193ef 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -997,6 +997,7 @@ struct ravb_hw_info {
>  	netdev_features_t net_features;
>  	int stats_len;
>  	size_t max_rx_len;
> +	u32 tsrq;

   I'd call it 'tccr_value' instead.

>  	unsigned aligned_tx: 1;
>  
>  	/* hardware features */
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index ac141a491ca2..4784832bd93c 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -790,11 +790,13 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
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
> +	error = ravb_wait(ndev, TCCR, info->tsrq, 0);
> +
>  	if (error)
>  		return error;
>  
> @@ -2128,6 +2130,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
>  	.net_features = NETIF_F_RXCSUM,
>  	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
>  	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
> +	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
>  	.internal_delay = 1,
>  	.tx_counters = 1,
>  	.multi_irqs = 1,
> @@ -2150,6 +2153,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
>  	.net_features = NETIF_F_RXCSUM,
>  	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
>  	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
> +	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
>  	.aligned_tx = 1,
>  	.gptp = 1,
>  	.nc_queue = 1,
> @@ -2165,6 +2169,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
>  	.dmac_init = ravb_dmac_init_gbeth,
>  	.emac_init = ravb_emac_init_gbeth,
>  	.max_rx_len = GBETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
> +	.tsrq = TCCR_TSRQ0,
>  	.aligned_tx = 1,
>  	.tx_counters = 1,
>  };
> 

[...]

MBR, Sergey
