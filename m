Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819E6520593
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240709AbiEIUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbiEIUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:00:14 -0400
Received: from mxout02.lancloud.ru (mxout02.lancloud.ru [45.84.86.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B59A888C;
        Mon,  9 May 2022 12:56:16 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru D8B3B20C73DD
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH v2 2/5] ravb: Separate handling of irq enable/disable regs
 into feature
To:     Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20220509142431.24898-1-phil.edworthy@renesas.com>
 <20220509142431.24898-3-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <d500a003-f5bb-b7cb-2ad4-bfe0d4f8c87c@omp.ru>
Date:   Mon, 9 May 2022 22:56:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220509142431.24898-3-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/9/22 5:24 PM, Phil Edworthy wrote:

> Currently, when the HW has a single interrupt, the driver uses the
> GIC, TIC, RIC0 registers to enable and disable interrupts.
> When the HW has multiple interrupts, it uses the GIE, GID, TIE, TID,
> RIE0, RID0 registers.
> 
> However, other devices, e.g. RZ/V2M, have multiple irqs and only have
> the GIC, TIC, RIC0 registers.
> Therefore, split this into a separate feature.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2:
>  - Renamed irq_en_dis_regs to irq_en_dis
>  - Squashed use of GIC reg versus GIE/GID into this patch and got rid
>    of separate gptp_ptm_gic feature.
>  - Minor editing of the commit msg
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
>  drivers/net/ethernet/renesas/ravb_ptp.c  | 4 ++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 08062d73df10..0ec8256f7eef 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1027,6 +1027,7 @@ struct ravb_hw_info {
>  	unsigned tx_counters:1;		/* E-MAC has TX counters */
>  	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
> +	unsigned irq_en_dis_regs:1;	/* Has separate irq enable and disable regs */

   You forgot to actually rename it. ;-)

>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
>  	unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
> index c099656dd75b..a7726c2ed594 100644
> --- a/drivers/net/ethernet/renesas/ravb_ptp.c
> +++ b/drivers/net/ethernet/renesas/ravb_ptp.c

    I think you missed the check in ravb_ptp_extts()...

[...]

MBR, Sergey
