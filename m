Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2F41F316
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355394AbhJAR3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:29:46 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:36176 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355340AbhJAR3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:29:45 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru BAC552033887
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [RFC/PATCH 16/18] ravb: Add Packet receive function for Gigabit
 Ethernet
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
 <20210923140813.13541-17-biju.das.jz@bp.renesas.com>
Organization: Open Mobile Platform
Message-ID: <82f58946-b88b-8990-8788-a58f8d1468c2@omp.ru>
Date:   Fri, 1 Oct 2021 20:27:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-17-biju.das.jz@bp.renesas.com>
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

> This patch series adds RX(packet receive) function for
> Gigabit Ethernet found on RZ/G2L SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |   1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 157 ++++++++++++++++++++++-
>  2 files changed, 156 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index b0e067a6a8ee..85260f89e1cd 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1092,6 +1092,7 @@ struct ravb_private {
>  
>  	int duplex;
>  	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
> +	struct sk_buff *rxtop_skb;

   I'd prefer for this one declared earler in the *struct*, as well. And why not e.g 'rx_1st_skb'?

>  
>  	const struct ravb_hw_info *info;
>  	struct reset_control *rstc;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index a08da7a37b92..867e180e6655 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -705,6 +705,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
>  	}
>  }
>  
> +static void ravb_rx_csum_rgeth(struct sk_buff *skb)
> +{
> +	u8 *hw_csum;
> +
> +	/* The hardware checksum is contained in sizeof(__sum16) (2) bytes
> +	 * appended to packet data
> +	 */
> +	if (unlikely(skb->len < sizeof(__sum16)))
> +		return;
> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
> +
> +	if (*hw_csum == 0)
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	else
> +		skb->ip_summed = CHECKSUM_NONE;

   Mhm, what's the point of this whole function then? Why it can't be a copy of the R-Car analog?

[...]
> @@ -720,11 +737,147 @@ static void ravb_rx_csum(struct sk_buff *skb)
[...]
>  /* Packet receive function for Gigabit Ethernet */
>  static bool ravb_rgeth_rx(struct net_device *ndev, int *quota, int q)
>  {
> -	/* Place holder */
> -	return true;
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
> +	int boguscnt = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
> +	struct net_device_stats *stats = &priv->stats[q];

   [q] should be dropped, as we've agreed...

> +	struct ravb_rx_desc *desc;
> +	struct sk_buff *skb;
> +	dma_addr_t dma_addr;
> +	u8  desc_status;
> +	u8  die_dt;
> +	u16 pkt_len;
> +	int limit;
> +
> +	boguscnt = min(boguscnt, *quota);
> +	limit = boguscnt;
> +	desc = &priv->rgeth_rx_ring[q][entry];
> +	while (desc->die_dt != DT_FEMPTY) {
> +		/* Descriptor type must be checked before all other reads */
> +		dma_rmb();
> +		desc_status = desc->msc;
> +		pkt_len = le16_to_cpu(desc->ds_cc) & RX_DS;
> +
> +		if (--boguscnt < 0)
> +			break;
> +
> +		/* We use 0-byte descriptors to mark the DMA mapping errors */
> +		if (!pkt_len)
> +			continue;
> +
> +		if (desc_status & MSC_MC)
> +			stats->multicast++;
> +
> +		if (desc_status & (MSC_CRC | MSC_RFE | MSC_RTSF | MSC_RTLF | MSC_CEEF)) {
> +			stats->rx_errors++;
> +			if (desc_status & MSC_CRC)
> +				stats->rx_crc_errors++;
> +			if (desc_status & MSC_RFE)
> +				stats->rx_frame_errors++;
> +			if (desc_status & (MSC_RTLF | MSC_RTSF))
> +				stats->rx_length_errors++;
> +			if (desc_status & MSC_CEEF)
> +				stats->rx_missed_errors++;
> +		} else {
> +			die_dt = desc->die_dt & 0xF0;
> +			switch (die_dt) {
> +			case DT_FSINGLE:
> +				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
> +				skb_put(skb, pkt_len);
> +				skb->protocol = eth_type_trans(skb, ndev);
> +				if (ndev->features & NETIF_F_RXCSUM)
> +					ravb_rx_csum_rgeth(skb);
> +				napi_gro_receive(&priv->napi[q], skb);
> +				stats->rx_packets++;
> +				stats->rx_bytes += pkt_len;
> +				break;
> +			case DT_FSTART:
> +				priv->rxtop_skb = ravb_get_skb_rgeth(ndev, q, entry, desc);

   But don't you need to  copy the data in this case?

> +				skb_put(priv->rxtop_skb, pkt_len);
> +				break;
> +			case DT_FMID:
> +				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
> +				skb_copy_to_linear_data_offset(priv->rxtop_skb,
> +							       priv->rxtop_skb->len,
> +							       skb->data,
> +							       pkt_len);
> +				skb_put(priv->rxtop_skb, pkt_len);
> +				dev_kfree_skb(skb);
> +				break;
> +			case DT_FEND:
> +				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
> +				skb_copy_to_linear_data_offset(priv->rxtop_skb,
> +							       priv->rxtop_skb->len,
> +							       skb->data,
> +							       pkt_len);
> +				skb_put(priv->rxtop_skb, pkt_len);
> +				dev_kfree_skb(skb);
> +				priv->rxtop_skb->protocol =
> +					eth_type_trans(priv->rxtop_skb, ndev);
> +				if (ndev->features & NETIF_F_RXCSUM)
> +					ravb_rx_csum_rgeth(skb);
> +				napi_gro_receive(&priv->napi[q],
> +						 priv->rxtop_skb);
> +				stats->rx_packets++;
> +				stats->rx_bytes += priv->rxtop_skb->len;
> +				break;
> +			}
> +		}
> +
> +		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
> +		desc = &priv->rgeth_rx_ring[q][entry];
> +	}
> +
> +	/* Refill the RX ring buffers. */
> +	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
> +		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
> +		desc = &priv->rgeth_rx_ring[q][entry];
> +		desc->ds_cc = cpu_to_le16(RGETH_RX_DESC_DATA_SIZE);
> +
> +		if (!priv->rx_skb[q][entry]) {
> +			skb = netdev_alloc_skb(ndev,
> +					       RGETH_RX_BUFF_MAX + RAVB_ALIGN - 1);

   ALIGN(RGETH_RX_BUFF_MAX, RAVB_ALIGN)?

[...]

MBR, Sergey
