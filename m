Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8341659E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbhIWTJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:09:00 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:45668 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242812AbhIWTI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:08:59 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 7292B208EDDA
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
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
 <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <183fd9d2-353d-1985-7145-145a03967f6e@omp.ru>
Date:   Thu, 23 Sep 2021 22:07:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 5:07 PM, Biju Das wrote:

> Initialize GbEthernet dmac found on RZ/G2L SoC.
> This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar
> to be consistent with the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  4 ++
>  drivers/net/ethernet/renesas/ravb_main.c | 84 +++++++++++++++++++++++-
>  2 files changed, 85 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 0ce0c13ef8cb..bee05e6fb815 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -81,6 +81,7 @@ enum ravb_reg {
>  	RQC3	= 0x00A0,
>  	RQC4	= 0x00A4,
>  	RPC	= 0x00B0,
> +	RTC	= 0x00B4,	/* RZ/G2L only */

   My gen3 manual says the regiuster exists there...

>  	UFCW	= 0x00BC,
>  	UFCS	= 0x00C0,
>  	UFCV0	= 0x00C4,
> @@ -156,6 +157,7 @@ enum ravb_reg {
>  	TIS	= 0x037C,
>  	ISS	= 0x0380,
>  	CIE	= 0x0384,	/* R-Car Gen3 only */
> +	RIC3	= 0x0388,	/* RZ/G2L only */

   Again, this register (along with RIS3) exists on gen3...

>  	GCCR	= 0x0390,
>  	GMTT	= 0x0394,
>  	GPTC	= 0x0398,
> @@ -956,6 +958,8 @@ enum RAVB_QUEUE {
>  
>  #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
>  
> +#define RGETH_RX_BUFF_MAX 8192
> +
>  struct ravb_tstamp_skb {
>  	struct list_head list;
>  	struct sk_buff *skb;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 2422e74d9b4f..54c4d31a6950 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -83,6 +83,11 @@ static int ravb_config(struct net_device *ndev)
>  	return error;
>  }
>  
> +static void ravb_rgeth_set_rate(struct net_device *ndev)
> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_set_rate(struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -217,6 +222,11 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  	return free_num;
>  }
>  
> +static void ravb_rx_ring_free_rgeth(struct net_device *ndev, int q)
> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rx_ring_free(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -283,6 +293,11 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  	priv->tx_skb[q] = NULL;
>  }
>  
> +static void ravb_rx_ring_format_rgeth(struct net_device *ndev, int q)
> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rx_ring_format(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -356,6 +371,12 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  	desc->dptr = cpu_to_le32((u32)priv->tx_desc_dma[q]);
>  }
>  
> +static void *ravb_rgeth_alloc_rx_desc(struct net_device *ndev, int q)
> +{
> +	/* Place holder */
> +	return NULL;
> +}
> +
>  static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -426,6 +447,11 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  	return -ENOMEM;
>  }
>  
> +static void ravb_rgeth_emac_init(struct net_device *ndev)
> +{
> +	/* Place holder */
> +}
> +
>  static void ravb_rcar_emac_init(struct net_device *ndev)
>  {
>  	/* Receive frame limit set register */
> @@ -461,7 +487,32 @@ static void ravb_emac_init(struct net_device *ndev)
>  	info->emac_init(ndev);
>  }
>  
> -static void ravb_rcar_dmac_init(struct net_device *ndev)
> +static void ravb_dmac_init_rgeth(struct net_device *ndev)
> +{
> +	/* Set AVB RX */
> +	ravb_write(ndev, 0x60000000, RCR);
> +
> +	/* Set Max Frame Length (RTC) */
> +	ravb_write(ndev, 0x7ffc0000 | RGETH_RX_BUFF_MAX, RTC);

   Should be init'ed on gen3 as well?

> +
> +	/* Set FIFO size */
> +	ravb_write(ndev, 0x00222200, TGC);
> +
> +	ravb_write(ndev, 0, TCCR);
> +
> +	/* Frame receive */
> +	ravb_write(ndev, RIC0_FRE0, RIC0);
> +	/* Disable FIFO full warning */
> +	ravb_write(ndev, 0x0, RIC1);
> +	/* Receive FIFO full error, descriptor empty */
> +	ravb_write(ndev, RIC2_QFE0 | RIC2_RFFE, RIC2);
> +
> +	ravb_write(ndev, 0x0, RIC3);

   Should be init'ed on gen3 as well? Matter of a separate patch, I can do it prolly...

[...]

MBR, Sergey
