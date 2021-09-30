Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41B41E2C0
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348264AbhI3UlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:41:14 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:37806 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhI3UlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:41:13 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 22BE920A5C5E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
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
 <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
Date:   Thu, 30 Sep 2021 23:39:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
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

> This patch adds set_feature support for RZ/G2L.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 32 ++++++++++++++
>  drivers/net/ethernet/renesas/ravb_main.c | 56 +++++++++++++++++++++++-
>  2 files changed, 87 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index d42e8ea981df..2275f27c0672 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -209,6 +209,8 @@ enum ravb_reg {
>  	CXR56	= 0x0770,	/* Documented for RZ/G2L only */
>  	MAFCR	= 0x0778,
>  	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
> +	CSR1     = 0x0804,	/* Documented for RZ/G2L only */
> +	CSR2     = 0x0808,	/* Documented for RZ/G2L only */

   These are the TOE regs (CSR0 included), they only exist on RZ/G2L, no?

[...]
> @@ -978,6 +980,36 @@ enum CSR0_BIT {
>  	CSR0_RPE	= 0x00000020,
>  };
>  

   *enum* CSR0_BIT should be here (as we concluded).

> +enum CSR1_BIT {
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 72aea5875bc5..641ae5553b64 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2290,7 +2308,38 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
>  static int ravb_set_features_rgeth(struct net_device *ndev,
>  				   netdev_features_t features)
>  {
> -	/* Place holder */
> +	netdev_features_t changed = features ^ ndev->features;
> +	unsigned int reg;

   u32 reg;

> +	int error;
> +
> +	reg = ravb_read(ndev, CSR0);

   ... as this function returns u32.

> +
> +	ravb_write(ndev, reg & ~(CSR0_RPE | CSR0_TPE), CSR0);
> +	error = ravb_wait(ndev, CSR0, CSR0_RPE | CSR0_TPE, 0);
> +	if (error) {
> +		ravb_write(ndev, reg, CSR0);
> +		return error;
> +	}
> +
> +	if (changed & NETIF_F_RXCSUM) {
> +		if (features & NETIF_F_RXCSUM)
> +			ravb_write(ndev, CSR2_ALL, CSR2);
> +		else
> +			ravb_write(ndev, 0, CSR2);
> +	}
> +
> +	if (changed & NETIF_F_HW_CSUM) {
> +		if (features & NETIF_F_HW_CSUM) {
> +			ravb_write(ndev, CSR1_ALL, CSR1);
> +			ndev->features |= NETIF_F_CSUM_MASK;

   Hm, I don't understand this... it would be nice if someone knowledgeable about the offloads
would look at this... Although, without the register documentation it's possibly vain...

> +		} else {
> +			ravb_write(ndev, 0, CSR1);
> +		}
> +	}
> +	ravb_write(ndev, reg, CSR0);
> +
> +	ndev->features = features;
> +
>  	return 0;
>  }
>  
> @@ -2432,6 +2481,11 @@ static const struct ravb_hw_info rgeth_hw_info = {
>  	.set_feature = ravb_set_features_rgeth,
>  	.dmac_init = ravb_dmac_init_rgeth,
>  	.emac_init = ravb_emac_init_rgeth,
> +	.net_hw_features = (NETIF_F_HW_CSUM | NETIF_F_RXCSUM),
> +	.gstrings_stats = ravb_gstrings_stats_rgeth,
> +	.gstrings_size = sizeof(ravb_gstrings_stats_rgeth),
> +	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_rgeth),

    These seem unrelated, couldn't it be moved to a spearate patch?

> +	.max_rx_len = RGETH_RX_BUFF_MAX + RAVB_ALIGN - 1,

   This seems unrelsated and misplaced too.

[...]

MBR, Sergey
