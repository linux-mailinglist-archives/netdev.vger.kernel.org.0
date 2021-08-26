Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFD53F8E46
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbhHZSzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:55:48 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:47268 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243300AbhHZSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 14:55:47 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 0C5DA208AB6E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 06/13] ravb: Factorise ravb_ring_format function
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
 <20210825070154.14336-7-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <2ba347ab-ff1a-68c3-a577-2ce1b4a35392@omp.ru>
Date:   Thu, 26 Aug 2021 21:54:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-7-biju.das.jz@bp.renesas.com>
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

> The ravb_ring_format function uses an extended descriptor in RX
> for R-Car compared to the normal descriptor for RZ/G2L. Factorise
> RX ring buffer buildup to extend the support for later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index dc388a32496a..e52e36ccd1c6 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -321,6 +310,26 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  	rx_desc = &priv->rx_ring[q][i];
>  	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
>  	rx_desc->die_dt = DT_LINKFIX; /* type */
> +}
> +
> +/* Format skb and descriptor buffer for Ethernet AVB */
> +static void ravb_ring_format(struct net_device *ndev, int q)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_hw_info *info = priv->info;
> +	unsigned int num_tx_desc = priv->num_tx_desc;
> +	struct ravb_tx_desc *tx_desc;
> +	struct ravb_desc *desc;
> +	unsigned int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
> +				    num_tx_desc;
> +	unsigned int i;
> +
> +	priv->cur_rx[q] = 0;
> +	priv->cur_tx[q] = 0;
> +	priv->dirty_rx[q] = 0;
> +	priv->dirty_tx[q] = 0;
> +
> +	info->rx_ring_format(ndev, q);
>  
>  	memset(priv->tx_ring[q], 0, tx_ring_size);
>  	/* Build TX ring buffer */

   That's all fine but the fragment that sets up TX descriptor ring base address was left in ravb_rx_ring_formet()...

[...]

MBR, Sergey
