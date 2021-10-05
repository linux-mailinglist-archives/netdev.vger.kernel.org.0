Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67F842309A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhJETQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:16:44 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:45026 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJETQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:16:43 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 8976E202418D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 04/12] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
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
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-5-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <207bfde9-2b34-a582-408c-1def6ceec031@omp.ru>
Date:   Tue, 5 Oct 2021 22:14:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-5-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

> Fillup ravb_alloc_rx_desc_gbeth() function to support RZ/G2L.
> 
> This patch also renames ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 37f50c041114..31de4e544525 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> -static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
> +static void *ravb_alloc_rx_desc_rcar(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	unsigned int ring_size;
> @@ -1085,16 +1092,25 @@ static int ravb_poll(struct napi_struct *napi, int budget)
>  	struct net_device *ndev = napi->dev;
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	const struct ravb_hw_info *info = priv->info;
> +	bool gptp = info->gptp || info->ccc_gac;
> +	struct ravb_rx_desc *desc;
>  	unsigned long flags;
>  	int q = napi - priv->napi;
>  	int mask = BIT(q);
>  	int quota = budget;
> +	unsigned int entry;
>  
> +	if (!gptp) {
> +		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
> +		desc = &priv->gbeth_rx_ring[entry];
> +	}
>  	/* Processing RX Descriptor Ring */
>  	/* Clear RX interrupt */
>  	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
> -	if (ravb_rx(ndev, &quota, q))
> -		goto out;
> +	if (gptp || desc->die_dt != DT_FEMPTY) {
> +		if (ravb_rx(ndev, &quota, q))
> +			goto out;
> +	}

   Not sure I understand this new logic around the ravb_rx() call, care to explain?

[...]

MBR, Sergey
