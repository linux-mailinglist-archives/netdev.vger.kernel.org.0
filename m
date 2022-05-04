Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4763551AF89
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378280AbiEDUoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378424AbiEDUoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:44:07 -0400
Received: from mxout04.lancloud.ru (mxout04.lancloud.ru [45.84.86.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51D71571F;
        Wed,  4 May 2022 13:40:28 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 324E720A560A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 3/9] ravb: Separate use of GIC reg for PTME from
 multi_irqs
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
 <20220504145454.71287-4-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <dd090d04-d2d7-4c9a-75cf-ba0c305de495@omp.ru>
Date:   Wed, 4 May 2022 23:40:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-4-phil.edworthy@renesas.com>
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

> When the HW has a single interrupt, the driver currently uses the
> PTME (Presentation Time Match Enable) bit in the GIC register to
> enable/disable the PTM irq. Otherwise, it uses the GIE/GID registers.
> 
> However, other SoCs, e.g. RZ/V2M, have multiple irqs and use the GIC
> register PTME bit, so separate it out as it's own feature.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 1 +
>  drivers/net/ethernet/renesas/ravb_ptp.c  | 4 ++--
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 08062d73df10..15aa09d93ff0 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1029,6 +1029,7 @@ struct ravb_hw_info {
>  	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
> +	unsigned gptp_ptm_gic:1;	/* gPTP enables Presentation Time Match irq via GIC */

   I think this needs to be controlled by the 'irq_en_dis' feature bit from the patch #4.

[...]

MBR, Sergey
