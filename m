Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6193F7D3B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbhHYUjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:39:23 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:37336 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhHYUjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:39:21 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 86C8520E0F1E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
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
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
Date:   Wed, 25 Aug 2021 23:38:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> There are some H/W differences for the gPTP feature between
> R-Car Gen3, R-Car Gen2, and RZ/G2L as below.
> 
> 1) On R-Car Gen3, gPTP support is active in config mode.
> 2) On R-Car Gen2, gPTP support is not active in config mode.
> 3) RZ/G2L does not support the gPTP feature.
> 
> Add a ptp_cfg_active hw feature bit to struct ravb_hw_info for
> supporting gPTP active in config mode for R-Car Gen3.

   Wait, we've just done this ion the previous patch!

> This patch also removes enum ravb_chip_id, chip_id from both
> struct ravb_hw_info and struct ravb_private, as it is unused.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  8 +-------
>  drivers/net/ethernet/renesas/ravb_main.c | 12 +++++-------
>  2 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 9ecf1a8c3ca8..209e030935aa 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -979,17 +979,11 @@ struct ravb_ptp {
>  	struct ravb_ptp_perout perout[N_PER_OUT];
>  };
>  
> -enum ravb_chip_id {
> -	RCAR_GEN2,
> -	RCAR_GEN3,
> -};
> -
>  struct ravb_hw_info {
>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
>  	size_t gstrings_size;
>  	netdev_features_t net_hw_features;
>  	netdev_features_t net_features;
> -	enum ravb_chip_id chip_id;
>  	int stats_len;
>  	size_t max_rx_len;

   I would put the above in a spearte patch...

>  	unsigned aligned_tx: 1;
> @@ -999,6 +993,7 @@ struct ravb_hw_info {
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
>  	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
> +	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */

   Huh?

>  };
>  
>  struct ravb_private {
[...]
> @@ -2216,7 +2213,7 @@ static int ravb_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&priv->ts_skb_list);
>  
>  	/* Initialise PTP Clock driver */
> -	if (info->chip_id != RCAR_GEN2)
> +	if (info->ptp_cfg_active)
>  		ravb_ptp_init(ndev, pdev);

   What's that? Didn't you touch this lie in patch #3?

   This seems lie a NAK bait... :-(

MBR, Sergey
