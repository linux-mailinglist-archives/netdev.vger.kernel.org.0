Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA3B421869
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 22:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhJDUb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 16:31:29 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:52374 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhJDUb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 16:31:28 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru A0B7A206179C
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 2/8] ravb: Fillup ravb_rx_ring_free_gbeth() stub
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
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
 <20211001164305.8999-3-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <942afec6-6566-25ce-356a-f692f17b4153@omp.ru>
Date:   Mon, 4 Oct 2021 23:29:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001164305.8999-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 7:42 PM, Biju Das wrote:

> Fillup ravb_rx_ring_free_gbeth() function to support RZ/G2L.
> 
> This patch also renames ravb_rx_ring_free to ravb_rx_ring_free_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> RFC->v1:
>  * renamed "rgeth" to "gbeth".
>  * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 41 ++++++++++++++++++++----
>  2 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index b147c4a0dc0b..1a73f960d918 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1077,6 +1077,7 @@ struct ravb_private {
>  	unsigned int num_tx_desc;	/* TX descriptors per packet */
>  
>  	int duplex;
> +	struct ravb_rx_desc *gbeth_rx_ring[NUM_RX_QUEUE];

   GBEther only has 1 RX queue, right?
   And please move the declaration closer to ravb_private::rx_ring.

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 0d1e3f7d8c33..6ef55f1cf306 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -1084,16 +1104,25 @@ static int ravb_poll(struct napi_struct *napi, int budget)
>  	struct net_device *ndev = napi->dev;
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	const struct ravb_hw_info *info = priv->info;
> +	struct ravb_rx_desc *desc;
>  	unsigned long flags;
>  	int q = napi - priv->napi;
>  	int mask = BIT(q);
>  	int quota = budget;
> +	unsigned int entry;
> +	bool non_gptp = !(info->gptp || info->ccc_gac);

   Just no_gptp? Or maybe gptp, seems even better?

>  
> +	if (non_gptp) {
> +		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
> +		desc = &priv->gbeth_rx_ring[q][entry];
> +	}
>  	/* Processing RX Descriptor Ring */
>  	/* Clear RX interrupt */
>  	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
> -	if (ravb_rx(ndev, &quota, q))
> -		goto out;
> +	if (!non_gptp || desc->die_dt != DT_FEMPTY) {
> +		if (ravb_rx(ndev, &quota, q))
> +			goto out;
> +	}
>  
>  	/* Processing TX Descriptor Ring */
>  	spin_lock_irqsave(&priv->lock, flags);
[...]

MBR, Sergey
