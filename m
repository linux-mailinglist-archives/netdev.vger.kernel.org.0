Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5DB52F453
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 22:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353432AbiETUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 16:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352457AbiETUUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 16:20:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E859187DBD
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NhkdzEAIcWq207vFnD0dd4g9837Pmprp8EVeDf6N94s=; b=TC6FC4l0BstLe2pusfWmavAE5b
        KXHWxIjkTUDWSY6z8GbXHZAA9DM9TTDPpXvUC8O6QEm9fcPO7Gx9arPHSx+cc5rnqd96in10z9Lg0
        KC2rZURc1N/En0D613V7fjYaj1bXzH0dHibpauM+zlX91Hp9KRTnX/JNj9hPOCom/vDw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns96c-003gas-11; Fri, 20 May 2022 22:20:14 +0200
Date:   Fri, 20 May 2022 22:20:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de
Subject: Re: [PATCH net-next RESEND] net: fec: Do proper error checking for
 enet_out clk
Message-ID: <Yof3/o46wXWXMsKo@lunn.ch>
References: <20220520062650.712561-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520062650.712561-1-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 11227f51404c..2512b68d8545 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3866,9 +3866,11 @@ fec_probe(struct platform_device *pdev)
>  	fep->itr_clk_rate = clk_get_rate(fep->clk_ahb);
>  
>  	/* enet_out is optional, depends on board */
> -	fep->clk_enet_out = devm_clk_get(&pdev->dev, "enet_out");
> -	if (IS_ERR(fep->clk_enet_out))
> -		fep->clk_enet_out = NULL;
> +	fep->clk_enet_out = devm_clk_get_optional(&pdev->dev, "enet_out");
> +	if (IS_ERR(fep->clk_enet_out)) {
> +		ret = PTR_ERR(fep->clk_enet_out);
> +		goto failed_clk;
> +	}
>  
>  	fep->ptp_clk_on = false;
>  	mutex_init(&fep->ptp_clk_mutex);

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This is O.K, as far as it goes. But directly after this we have:

	/* clk_ref is optional, depends on board */
	fep->clk_ref = devm_clk_get(&pdev->dev, "enet_clk_ref");
	if (IS_ERR(fep->clk_ref))
		fep->clk_ref = NULL;
	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);

It would be good to do the same to this clock as well.

    Andrew
