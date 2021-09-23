Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB264166D9
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhIWUn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:43:58 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:36210 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhIWUn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 16:43:57 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 77D7D20AAC93
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 07/18] ravb: Add magic_pkt to struct ravb_hw_info
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
 <20210923140813.13541-8-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <6bb4004f-2770-b67e-10ce-a438cb939148@omp.ru>
Date:   Thu, 23 Sep 2021 23:42:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-8-biju.das.jz@bp.renesas.com>
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

> E-MAC on R-Car supports magic packet detection, whereas RZ/G2L
> do not support this feature. Add magic_pkt to struct ravb_hw_info
> and enable this feature only for R-Car.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index d37d73f6d984..529364d8f7fb 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -811,12 +811,13 @@ static int ravb_stop_dma(struct net_device *ndev)
>  static void ravb_emac_interrupt_unlocked(struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_hw_info *info = priv->info;
>  	u32 ecsr, psr;
>  
>  	ecsr = ravb_read(ndev, ECSR);
>  	ravb_write(ndev, ecsr, ECSR);	/* clear interrupt */
>  
> -	if (ecsr & ECSR_MPD)
> +	if (info->magic_pkt && (ecsr & ECSR_MPD))

   I think masking the MPD interrupt would be enough.

>  		pm_wakeup_event(&priv->pdev->dev, 0);
>  	if (ecsr & ECSR_ICD)
>  		ndev->stats.tx_carrier_errors++;
> @@ -1416,8 +1417,9 @@ static void ravb_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)

   Didn't you miss ravb_get_wol() -- it needs a change as well...

>  static int ravb_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_hw_info *info = priv->info;
>  
> -	if (wol->wolopts & ~WAKE_MAGIC)
> +	if (!info->magic_pkt || (wol->wolopts & ~WAKE_MAGIC))
>  		return -EOPNOTSUPP;
>  
>  	priv->wol_enabled = !!(wol->wolopts & WAKE_MAGIC);
[...]

MBR, Sergey
