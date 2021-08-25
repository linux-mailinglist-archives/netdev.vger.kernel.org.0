Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B20C3F7765
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241724AbhHYObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:31:09 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:59812 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhHYObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 10:31:08 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru E5BB320BF7D9
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 01/13] ravb: Remove the macros
 NUM_TX_DESC_GEN[23]
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
 <20210825070154.14336-2-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <08405c60-fd9c-cc9b-0256-eb3ce80f7372@omp.ru>
Date:   Wed, 25 Aug 2021 17:30:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 8/25/21 10:01 AM, Biju Das wrote:

> For addressing 4 bytes alignment restriction on transmission
> buffer for R-Car Gen2 we use 2 descriptors whereas it is a single
> descriptor for other cases.
> Replace the macros NUM_TX_DESC_GEN[23] with magic number and
> add a comment to explain it.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 02842b980a7f..073e690ab830 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2160,8 +2160,12 @@ static int ravb_probe(struct platform_device *pdev)
>  	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
>  	ndev->min_mtu = ETH_MIN_MTU;
>  
> -	priv->num_tx_desc = info->aligned_tx ?
> -		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
> +	/* FIXME: R-Car Gen2 has 4byte alignment restriction for tx buffer

   Mhm, what are you going to fix here?

> +	 * Use two descriptor to handle such situation. First descriptor to
> +	 * handle aligned data buffer and second descriptor to handle the
> +	 * overflow data because of alignment.
> +	 */
> +	priv->num_tx_desc = info->aligned_tx ? 2 : 1;
>  
>  	/* Set function */
>  	ndev->netdev_ops = &ravb_netdev_ops;

   Other than that:

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
