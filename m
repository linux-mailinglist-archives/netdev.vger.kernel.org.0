Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C12416593
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242801AbhIWTBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:01:49 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:33640 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhIWTBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:01:46 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 55E7A20A61CC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
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
 <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
Date:   Thu, 23 Sep 2021 22:00:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
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

> R-Car supports gPTP feature whereas RZ/G2L does not support it.
> This patch excludes gtp feature support for RZ/G2L by enabling
> no_gptp feature bit.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 46 ++++++++++++++----------
>  1 file changed, 28 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index d38fc33a8e93..8663d83507a0 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -953,7 +954,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
>  	}
>  
>  	/* gPTP interrupt status summary */
> -	if (iss & ISS_CGIS) {

   Isn't this bit always 0 on RZ/G2L?

> +	if (!info->no_gptp && (iss & ISS_CGIS)) {
>  		ravb_ptp_interrupt(ndev);
>  		result = IRQ_HANDLED;
>  	}
> @@ -1378,6 +1379,7 @@ static int ravb_get_ts_info(struct net_device *ndev,
>  			    struct ethtool_ts_info *info)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_hw_info *hw_info = priv->info;
>  
>  	info->so_timestamping =
>  		SOF_TIMESTAMPING_TX_SOFTWARE |
> @@ -1391,7 +1393,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
>  		(1 << HWTSTAMP_FILTER_NONE) |
>  		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
>  		(1 << HWTSTAMP_FILTER_ALL);
> -	info->phc_index = ptp_clock_index(priv->ptp.clock);
> +	if (!hw_info->no_gptp)
> +		info->phc_index = ptp_clock_index(priv->ptp.clock);
>  
>  	return 0;
>  }
> @@ -2116,6 +2119,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
>  	.emac_init = ravb_rgeth_emac_init,
>  	.aligned_tx = 1,
>  	.tx_counters = 1,
> +	.no_gptp = 1,

   Mhm, I definitely don't like the way you "extend" the GbEthernet info structure. All the applicable flags
should be set in the last patch of the series, not amidst of it.

[...]

MBR, Sergey
