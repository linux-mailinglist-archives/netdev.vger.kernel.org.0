Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC4C51C998
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 21:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385374AbiEETvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238792AbiEETvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:51:40 -0400
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 12:47:58 PDT
Received: from mxout01.lancloud.ru (mxout01.lancloud.ru [45.84.86.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D75D64A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 12:47:58 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 674BB205EE8C
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 5/9] ravb: Support separate Line0 (Desc), Line1 (Err) and
 Line2 (Mgmt) irqs
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
 <20220504145454.71287-6-phil.edworthy@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <80099a39-5727-85fd-1988-01cef8793cc2@omp.ru>
Date:   Thu, 5 May 2022 22:40:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504145454.71287-6-phil.edworthy@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 5:54 PM, Phil Edworthy wrote:

> R-Car has a combined interrupt line, ch22 = Line0_DiA | Line1_A | Line2_A.

   R-Car gen3, you mean? Because R-Car gen2 has single IRQ...

> RZ/V2M has separate interrupt lines for each of these, so add a feature
> that allows the driver to get these interrupts and call the common handler.
> 
> We keep the "ch22" name for Line0_DiA and "ch24" for Line3 interrupts to
> keep the code simple.

   Not sure I agree with such simplification -- at least about "ch22"...

> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index d0b9688074ca..f12a23b9c391 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -2167,6 +2184,10 @@ static int ravb_close(struct net_device *ndev)
>  		free_irq(priv->rx_irqs[RAVB_BE], ndev);
>  		free_irq(priv->emac_irq, ndev);
>  	}
> +	if (info->err_mgmt_irqs) {
> +		free_irq(priv->erra_irq, ndev);
> +		free_irq(priv->mgmta_irq, ndev);
> +	}

   Shouldn't this be under:

	if (info->multi_irqs) {

above?

>  	free_irq(ndev->irq, ndev);
>  
>  	if (info->nc_queues)
> @@ -2665,6 +2686,22 @@ static int ravb_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	if (info->err_mgmt_irqs) {
> +		irq = platform_get_irq_byname(pdev, "err_a");
> +		if (irq < 0) {
> +			error = irq;
> +			goto out_release;
> +		}
> +		priv->erra_irq = irq;
> +
> +		irq = platform_get_irq_byname(pdev, "mgmt_a");
> +		if (irq < 0) {
> +			error = irq;
> +			goto out_release;
> +		}
> +		priv->mgmta_irq = irq;
> +	}
> +

   Same here... 

>  	priv->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(priv->clk)) {
>  		error = PTR_ERR(priv->clk);

MBR, Sergey
