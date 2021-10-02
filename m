Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5858141FDE5
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 21:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhJBTow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 15:44:52 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:36080 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhJBTov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 15:44:51 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru E3B6C20C0450
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Adam Ford" <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
Date:   Sat, 2 Oct 2021 22:43:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 6:06 PM, Biju Das wrote:

> RZ/G2L SoC has Gigabit Ethernet IP consisting of Ethernet controller
> (E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct
> memory access controller (DMAC).
> 
> This patch adds compatible string for RZ/G2L and fills up the
> ravb_hw_info struct. Function stubs are added which will be used by
> gbeth_hw_info and will be filled incrementally.

   I've always been against this patch -- we get a support for the GbEther whihc doesn't work
after this patch. I believe we should have the GbEther support in the last patch. of the overall
series.

> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> RFC->v1:
>  * Added compatible string for RZ/G2L.
>  * Added feature bits max_rx_len, aligned_tx and tx_counters for RZ/G2L.
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  2 +
>  drivers/net/ethernet/renesas/ravb_main.c | 62 ++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index c91e93e5590f..f6398fdcead2 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 8bf13586e90a..dc817b4d95a1 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2073,12 +2120,27 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
>  	.nc_queue = 1,
>  };
>  
> +static const struct ravb_hw_info gbeth_hw_info = {
> +	.rx_ring_free = ravb_rx_ring_free_gbeth,
> +	.rx_ring_format = ravb_rx_ring_format_gbeth,
> +	.alloc_rx_desc = ravb_alloc_rx_desc_gbeth,
> +	.receive = ravb_rx_gbeth,
> +	.set_rate = ravb_set_rate_gbeth,
> +	.set_feature = ravb_set_features_gbeth,
> +	.dmac_init = ravb_dmac_init_gbeth,
> +	.emac_init = ravb_emac_init_gbeth,
> +	.max_rx_len = GBETH_RX_BUFF_MAX + RAVB_ALIGN - 1,

   ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN)?

> +	.aligned_tx = 1,
> +	.tx_counters = 1,
> +};
> +

[...]

MBR. Sergey
