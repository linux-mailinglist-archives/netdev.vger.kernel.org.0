Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1B51CA74
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbiEEUVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiEEUVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:21:53 -0400
Received: from mxout02.lancloud.ru (mxout02.lancloud.ru [45.84.86.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A68659976;
        Thu,  5 May 2022 13:18:11 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 56883202AD85
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 7/9] ravb: Add support for RZ/V2M
To:     Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-8-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <badc2174-6068-2a21-013b-4899e376e394@omp.ru>
Date:   Thu, 5 May 2022 23:18:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-8-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 5:54 PM, Phil Edworthy wrote:

> RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
> some small parts are the same as R-Car Gen2.

   You mean the absence of the interrupt enable/disable registers?

> Other differences are:

   Differences to gen3, you mean?

> * It has separate data (DI), error (Line 1) and management (Line 2) irqs
>   rather than one irq for all three.
> * Instead of using the High-speed peripheral bus clock for gPTP, it has a
>   separate gPTP reference clock.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> Note: gPTP was tested using an RZ/V2M EVK and an R-Car M3N Salvator-XS
> board, connected with a Summit X440 AVB switch, using ptp4l.

   Oh, that's good! :-)

> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 27 ++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index ded87cb51650..03b127faf52f 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2461,6 +2461,32 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
>  	.magic_pkt = 1,
>  };
>  
> +static const struct ravb_hw_info ravb_rzv2m_hw_info = {
> +	.rx_ring_free = ravb_rx_ring_free_rcar,
> +	.rx_ring_format = ravb_rx_ring_format_rcar,
> +	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
> +	.receive = ravb_rx_rcar,
> +	.set_rate = ravb_set_rate_rcar,
> +	.set_feature = ravb_set_features_rcar,
> +	.dmac_init = ravb_dmac_init_rcar,
> +	.emac_init = ravb_emac_init_rcar,
> +	.gstrings_stats = ravb_gstrings_stats,
> +	.gstrings_size = sizeof(ravb_gstrings_stats),
> +	.net_hw_features = NETIF_F_RXCSUM,
> +	.net_features = NETIF_F_RXCSUM,
> +	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
> +	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
> +	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
> +	.rx_max_buf_size = SZ_2K,

   What about .internal_delay and .tx_counters?

> +	.multi_irqs = 1,
> +	.err_mgmt_irqs = 1,
> +	.gptp = 1,

   Not .ccc_gac?

[...]

MBR. Sergey
