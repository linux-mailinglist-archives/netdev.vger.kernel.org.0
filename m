Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FCB51C6D4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiEESRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383036AbiEESRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:17:04 -0400
Received: from mxout03.lancloud.ru (mxout03.lancloud.ru [45.84.86.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66425C373;
        Thu,  5 May 2022 11:13:21 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru ECC7A20326CC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 6/9] ravb: Use separate clock for gPTP
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
 <20220504145454.71287-7-phil.edworthy@renesas.com>
Organization: Open Mobile Platform
Message-ID: <1bbb8044-a8a8-3fa1-b90b-cae9dfbb64cd@omp.ru>
Date:   Thu, 5 May 2022 21:13:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-7-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/4/22 5:54 PM, Phil Edworthy wrote:

> RZ/V2M has a separate gPTP reference clock that is used when the
> AVB-DMAC Mode Register (CCC) gPTP Clock Select (CSEL) bits are
> set to "01: High-speed peripheral bus clock".
> Therefore, add a feature that allows this clock to be used for
> gPTP.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 73976a392457..f8706897ea41 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1032,6 +1032,7 @@ struct ravb_hw_info {
>  	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
>  	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
>  	unsigned gptp_ptm_gic:1;	/* gPTP enables Presentation Time Match irq via GIC */
> +	unsigned gptp_ref_clk:1;	/* gPTP has separate reference clock */

   Perhaps just gptp_clk?

[...]
> @@ -1043,6 +1044,7 @@ struct ravb_private {
>  	void __iomem *addr;
>  	struct clk *clk;
>  	struct clk *refclk;

   I wonder what that refclk feeds -- no word of it in the commit adding it...

> +	struct clk *gptp_clk;
>  	struct mdiobb_ctrl mdiobb;
>  	u32 num_rx_ring[NUM_RX_QUEUE];
>  	u32 num_tx_ring[NUM_TX_QUEUE];
[...]

MBR, Sergey
