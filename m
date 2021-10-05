Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707A0423077
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhJETBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:01:25 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:47558 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhJETBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:01:24 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru D49AE20747CF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-4-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <17eb621c-05f8-155b-24ed-5445f445c6ce@omp.ru>
Date:   Tue, 5 Oct 2021 21:59:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005110642.3744-4-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 2:06 PM, Biju Das wrote:

> Fillup ravb_set_features_gbeth() function to support RZ/G2L.
> Also set the net_hw_features bits supported by GbEthernet
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index ed0328a90200..37f50c041114 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2086,7 +2087,37 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
>  static int ravb_set_features_gbeth(struct net_device *ndev,
>  				   netdev_features_t features)
>  {
> -	/* Place holder */
> +	netdev_features_t changed = features ^ ndev->features;
> +	int error;
> +	u32 csr0;
> +
> +	csr0 = ravb_read(ndev, CSR0);
> +	ravb_write(ndev, csr0 & ~(CSR0_RPE | CSR0_TPE), CSR0);
> +	error = ravb_wait(ndev, CSR0, CSR0_RPE | CSR0_TPE, 0);
> +	if (error) {
> +		ravb_write(ndev, csr0, CSR0);
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

   Hm, the >linux/netdev_features.h> says those are contradictory to have both NETIF_F_HW_CSUM and
NETIF_F_CSUM_MASK set...

> +		} else {
> +			ravb_write(ndev, 0, CSR1);

   No need to mask off the 'features' field?

> +		}
> +	}
> +	ravb_write(ndev, csr0, CSR0);
> +
> +	ndev->features = features;

   Mhm, doesn't that clear NETIF_F_CSUM_MASK?

[...]

MBR, Sergey
