Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84F419F1F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhI0TaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:30:03 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:54652 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhI0TaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:30:01 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 065E02027C67
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 13/18] ravb: Add rx_ring_free function support for
 GbEthernet
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-14-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <6d6c1a5d-fcaa-4af9-0ed8-51920c237bde@omp.ru>
Date:   Mon, 27 Sep 2021 22:28:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-14-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:08 PM, Biju Das wrote:

> This patch adds rx_ring_free function support for GbEthernet
> found on RZ/G2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 2c375002ebcb..038af36141bb 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -236,7 +236,27 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  
>  static void ravb_rx_ring_free_rgeth(struct net_device *ndev, int q)
>  {
> -	/* Place holder */
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	unsigned int ring_size;
> +	unsigned int i;
> +
> +	if (!priv->rgeth_rx_ring[q])

   Is the network control queue present on your hardware at all? Perhaps we can ignore q for now?

> +		return;
> +
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		struct ravb_rx_desc *desc = &priv->rgeth_rx_ring[q][i];

   Looks like patch #12 should come after this one, not before...

> +
> +		if (!dma_mapping_error(ndev->dev.parent,
> +				       le32_to_cpu(desc->dptr)))
> +			dma_unmap_single(ndev->dev.parent,
> +					 le32_to_cpu(desc->dptr),
> +					 RGETH_RX_BUFF_MAX,
> +					 DMA_FROM_DEVICE);
> +	}
> +	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
> +	dma_free_coherent(ndev->dev.parent, ring_size, priv->rgeth_rx_ring[q],
> +			  priv->rx_desc_dma[q]);
> +	priv->rgeth_rx_ring[q] = NULL;
>  }
>  
>  static void ravb_rx_ring_free(struct net_device *ndev, int q)

MBR, Sergey
