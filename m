Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9DA41A02B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhI0Uea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:34:30 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:56574 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbhI0Ue3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:34:29 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 875082014E5E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 14/18] ravb: Add rx_ring_format function for
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
 <20210923140813.13541-15-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c50f22d3-4741-f0a0-2664-34910d6c5ea4@omp.ru>
Date:   Mon, 27 Sep 2021 23:32:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-15-biju.das.jz@bp.renesas.com>
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

> This patch adds rx_ring_format function for GbEthernet found on
> RZ/G2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 27 +++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 2505de5d4a28..b0e067a6a8ee 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -982,6 +982,7 @@ enum CSR0_BIT {
>  #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
>  
>  #define RGETH_RX_BUFF_MAX 8192
> +#define RGETH_RX_DESC_DATA_SIZE 4080
>  
>  struct ravb_tstamp_skb {
>  	struct list_head list;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 038af36141bb..ee1066fedc4a 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -327,7 +327,32 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  
>  static void ravb_rx_ring_format_rgeth(struct net_device *ndev, int q)
>  {
> -	/* Place holder */
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	struct ravb_rx_desc *rx_desc;
> +	unsigned int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
> +	dma_addr_t dma_addr;
> +	unsigned int i;
> +
> +	memset(priv->rgeth_rx_ring[q], 0, rx_ring_size);
> +	/* Build RX ring buffer */
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		/* RX descriptor */
> +		rx_desc = &priv->rgeth_rx_ring[q][i];

   Looks like this patch shold come bafore the patch #12 as well...

> +		rx_desc->ds_cc = cpu_to_le16(RGETH_RX_DESC_DATA_SIZE);
> +		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
> +					  RGETH_RX_BUFF_MAX,

    Allocation buffer size more then the real data size? Does that make sense?

> +					  DMA_FROM_DEVICE);
> +		/* We just set the data size to 0 for a failed mapping which
> +		 * should prevent DMA from happening...
> +		 */
> +		if (dma_mapping_error(ndev->dev.parent, dma_addr))
> +			rx_desc->ds_cc = cpu_to_le16(0);
> +		rx_desc->dptr = cpu_to_le32(dma_addr);
> +		rx_desc->die_dt = DT_FEMPTY;
> +	}
> +	rx_desc = &priv->rgeth_rx_ring[q][i];
> +	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
> +	rx_desc->die_dt = DT_LINKFIX; /* type */
>  }
>  
>  static void ravb_rx_ring_format(struct net_device *ndev, int q)

MBR, Sergey
