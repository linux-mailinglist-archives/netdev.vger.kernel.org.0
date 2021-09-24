Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1335C417C70
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhIXUpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 16:45:52 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:44112 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhIXUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 16:45:51 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 9D303205E48D
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 10/18] ravb: Initialize GbEthernet E-MAC
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
 <20210923140813.13541-11-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <98225e6e-54e2-f3fe-d2df-50f173ff2fd8@omp.ru>
Date:   Fri, 24 Sep 2021 23:44:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-11-biju.das.jz@bp.renesas.com>
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

> Initialize GbEthernet E-MAC found on RZ/G2L SoC.
> This patch also renames ravb_set_rate to ravb_set_rate_rcar and
> ravb_rcar_emac_init to ravb_emac_init_rcar to be consistent with
> the naming convention used in sh_eth driver.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 15 ++++--
>  drivers/net/ethernet/renesas/ravb_main.c | 64 +++++++++++++++++++-----
>  2 files changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 7f68f9b8349c..7532cb51d7b8 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -204,6 +204,7 @@ enum ravb_reg {
>  	TLFRCR	= 0x0758,
>  	RFCR	= 0x0760,
>  	MAFCR	= 0x0778,
> +	CSR0     = 0x0800,	/* Documented for RZ/G2L only */

   Ah, the CSR0 bit *enum* belongs here! :-) 

[...]
> @@ -827,6 +829,7 @@ enum ECSR_BIT {
>  	ECSR_MPD	= 0x00000002,
>  	ECSR_LCHNG	= 0x00000004,
>  	ECSR_PHYI	= 0x00000008,
> +	ECSR_PFRI	= 0x00000010,

   It's not documented on gen2, perhaps it just doesn't exist there...

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 04bff44b7660..7f06adbd00e1 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -447,12 +459,38 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  	return -ENOMEM;
>  }
>  
> -static void ravb_rgeth_emac_init(struct net_device *ndev)
> +static void ravb_emac_init_rgeth(struct net_device *ndev)
>  {
> -	/* Place holder */
> +	struct ravb_private *priv = netdev_priv(ndev);
> +
> +	/* Receive frame limit set register */
> +	ravb_write(ndev, RGETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
> +
> +	/* PAUSE prohibition */
> +	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
> +			 ECMR_TE | ECMR_RE | ECMR_RCPT |
> +			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
> +
> +	ravb_set_rate_rgeth(ndev);
> +
> +	/* Set MAC address */
> +	ravb_write(ndev,
> +		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
> +		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
> +	ravb_write(ndev, (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
> +
> +	/* E-MAC status register clear */
> +	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
> +	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
> +
> +	/* E-MAC interrupt enable register */
> +	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
> +
> +	ravb_write(ndev, ravb_read(ndev, CXR31) & ~CXR31_SEL_LINK1, CXR31);
> +	ravb_write(ndev, ravb_read(ndev, CXR31) | CXR31_SEL_LINK0, CXR31);

   We have ravb_modify() for that, it'll help to avoid the double read/write...

[...]

MBR, Sergey
