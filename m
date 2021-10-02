Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3014541FDBE
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhJBShq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:37:46 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:47532 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbhJBShm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:37:42 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 578722091F09
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
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
 <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <334a8156-0645-b29c-137b-1e76d524efb9@omp.ru>
Date:   Sat, 2 Oct 2021 21:35:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
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

> R-Car supports network control queue whereas RZ/G2L does not support
> it. Add nc_queue to struct ravb_hw_info, so that NC queue is handled
> only by R-Car.
> 
> This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

   One little nit below:

> ---
> RFC->v1:
>  * Handled NC queue only for R-Car.
> ---
>  drivers/net/ethernet/renesas/ravb.h      |   3 +-
>  drivers/net/ethernet/renesas/ravb_main.c | 140 +++++++++++++++--------
>  2 files changed, 94 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index a33fbcb4aac3..c91e93e5590f 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -986,7 +986,7 @@ struct ravb_hw_info {
>  	bool (*receive)(struct net_device *ndev, int *quota, int q);
>  	void (*set_rate)(struct net_device *ndev);
>  	int (*set_feature)(struct net_device *ndev, netdev_features_t features);
> -	void (*dmac_init)(struct net_device *ndev);
> +	int (*dmac_init)(struct net_device *ndev);
>  	void (*emac_init)(struct net_device *ndev);
>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>  	size_t gstrings_size;
> @@ -1002,6 +1002,7 @@ struct ravb_hw_info {
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
> +	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */

   Rather "queues" as there are RX and TX NC queues, no?

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index dc7654abfe55..8bf13586e90a 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -1698,28 +1717,38 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
>  
>  	nstats = &ndev->stats;
>  	stats0 = &priv->stats[RAVB_BE];
> -	stats1 = &priv->stats[RAVB_NC];
>  
>  	if (info->tx_counters) {
>  		nstats->tx_dropped += ravb_read(ndev, TROCR);
>  		ravb_write(ndev, 0, TROCR);	/* (write clear) */
>  	}
>  
> -	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
> -	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
> -	nstats->rx_bytes = stats0->rx_bytes + stats1->rx_bytes;
> -	nstats->tx_bytes = stats0->tx_bytes + stats1->tx_bytes;
> -	nstats->multicast = stats0->multicast + stats1->multicast;
> -	nstats->rx_errors = stats0->rx_errors + stats1->rx_errors;
> -	nstats->rx_crc_errors = stats0->rx_crc_errors + stats1->rx_crc_errors;
> -	nstats->rx_frame_errors =
> -		stats0->rx_frame_errors + stats1->rx_frame_errors;
> -	nstats->rx_length_errors =
> -		stats0->rx_length_errors + stats1->rx_length_errors;
> -	nstats->rx_missed_errors =
> -		stats0->rx_missed_errors + stats1->rx_missed_errors;
> -	nstats->rx_over_errors =
> -		stats0->rx_over_errors + stats1->rx_over_errors;
> +	nstats->rx_packets = stats0->rx_packets;
> +	nstats->tx_packets = stats0->tx_packets;
> +	nstats->rx_bytes = stats0->rx_bytes;
> +	nstats->tx_bytes = stats0->tx_bytes;
> +	nstats->multicast = stats0->multicast;
> +	nstats->rx_errors = stats0->rx_errors;
> +	nstats->rx_crc_errors = stats0->rx_crc_errors;
> +	nstats->rx_frame_errors = stats0->rx_frame_errors;
> +	nstats->rx_length_errors = stats0->rx_length_errors;
> +	nstats->rx_missed_errors = stats0->rx_missed_errors;
> +	nstats->rx_over_errors = stats0->rx_over_errors;
> +	if (info->nc_queue) {
> +		stats1 = &priv->stats[RAVB_NC];
> +
> +		nstats->rx_packets += stats1->rx_packets;
> +		nstats->tx_packets += stats1->tx_packets;
> +		nstats->rx_bytes += stats1->rx_bytes;
> +		nstats->tx_bytes += stats1->tx_bytes;
> +		nstats->multicast += stats1->multicast;
> +		nstats->rx_errors += stats1->rx_errors;
> +		nstats->rx_crc_errors += stats1->rx_crc_errors;
> +		nstats->rx_frame_errors += stats1->rx_frame_errors;
> +		nstats->rx_length_errors += stats1->rx_length_errors;
> +		nstats->rx_missed_errors += stats1->rx_missed_errors;
> +		nstats->rx_over_errors += stats1->rx_over_errors;
> +	}

   Good! :-)

[...]

MBR, Sergey
