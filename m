Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A103F7D5D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhHYUyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:54:31 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:41266 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhHYUya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:54:30 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru D5DE920C7A5F
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 05/13] ravb: Factorise ravb_ring_free function
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-6-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <92a268d0-91b3-9d88-1408-485764f12306@omp.ru>
Date:   Wed, 25 Aug 2021 23:53:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-6-biju.das.jz@bp.renesas.com>
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

> R-Car uses extended descriptor in RX, whereas RZ/G2L uses normal
> descriptor. Factorise ravb_ring_free function so that it can
> support later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 209e030935aa..7cb30319524a 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
[...]
> index 883db1049882..dc388a32496a 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -216,31 +216,42 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  	return free_num;
>  }
>  
> +static void ravb_rx_ring_free(struct net_device *ndev, int q)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	unsigned int ring_size;
> +	unsigned int i;
> +
> +	if (!priv->rx_ring[q])
> +		return;
> +
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
> +
> +		if (!dma_mapping_error(ndev->dev.parent,
> +				       le32_to_cpu(desc->dptr)))
> +			dma_unmap_single(ndev->dev.parent,
> +					 le32_to_cpu(desc->dptr),
> +					 RX_BUF_SZ,
> +					 DMA_FROM_DEVICE);

   I think we could reflow this argument list, so that it takes less lines...

> +	}
> +	ring_size = sizeof(struct ravb_ex_rx_desc) *
> +		    (priv->num_rx_ring[q] + 1);

   Here as well...

[...]

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

MBR, Sergey
