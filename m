Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0767A4D4044
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbiCJE2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiCJE2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:28:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8361B12D081;
        Wed,  9 Mar 2022 20:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD21617F0;
        Thu, 10 Mar 2022 04:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23485C340E8;
        Thu, 10 Mar 2022 04:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886423;
        bh=pT1PYqLDp52fgi2//UsDbBjzOfc8PYo2JLHYPEn0yWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WytsdwfEM+aQD1yO9lXC6ftFai4p5bX0wRexkU4t2y+brnGSsAVXDy5QHDgHO/Bfa
         /A95tM+42gAv4U0YRKgk8EXUkLWmEbo4ziPuUhhlLI5EIVx6ZuIcRK5IcEu6r0CJ24
         B2r7ReRAAOljuWiWu9WiEQgA/tasgFeWzvjTNTGOOkRtzp+uGuRSFSRb/ORd2cElUx
         U/kqBynLwDvLm8xXSYLp+7gylyGzN09aQgU2G8mh9QYSza9qhqe+cmiBcD7Vof/Oob
         PtoTvBCJLLT3esZxr43N7fpVeBqe7IZKC0SKkY0rhuV9ezKW7a4i0D9feyWisRGCYu
         jRqXgsX5uZpfQ==
Date:   Wed, 9 Mar 2022 20:27:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net:mv643xx_eth: use platform_get_irq() instead of
 platform_get_resource()
Message-ID: <20220309202701.185c8779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309035438.2080808-1-chi.minghao@zte.com.cn>
References: <20220309035438.2080808-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 03:54:38 +0000 cgel.zte@gmail.com wrote:
> Subject: [PATCH] net:mv643xx_eth: use platform_get_irq() instead of platform_get_resource()

Add a space after "net:" please.

> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
> 
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
> 
> It also makes code simpler because we're getting "int" value right away
> and no conversion from resource to int is required.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 143ca8be5eb5..125d18430296 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -3092,8 +3092,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>  	struct mv643xx_eth_private *mp;
>  	struct net_device *dev;
>  	struct phy_device *phydev = NULL;
> -	struct resource *res;
> -	int err;
> +	int err, irq;
>  
>  	pd = dev_get_platdata(&pdev->dev);
>  	if (pd == NULL) {
> @@ -3189,9 +3188,9 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>  	timer_setup(&mp->rx_oom, oom_timer_wrapper, 0);
>  
>  
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	BUG_ON(!res);
> -	dev->irq = res->start;
> +	irq = platform_get_irq(pdev, 0);
> +	BUG_ON(irq < 0);

Let's also get rid of this BUG_ON() while at it and handle the error
gracefully.

> +	dev->irq = irq;
>  
>  	dev->netdev_ops = &mv643xx_eth_netdev_ops;
>  

