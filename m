Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9214DA3F5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbiCOU1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351698AbiCOU1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:27:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4132A4FC40;
        Tue, 15 Mar 2022 13:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mcJOribsJXhQyj45Qe1vGD7+4oE6RrBmBG5ytviDikg=; b=bno/Pnw2cLnL83fTu0OZi2cU8N
        rMcAMSmWV5ssRAAuhv9qzRn5qTgeRXqZX8y2f9segAAblySf6EGvDSTLErm8+P4SZvxF+AhR5vd5I
        Nn5MBIq3Gb/+AOq62KqMN4MuwoxHPUu+Nb09wptUchqKYCwIX/MhmsK6PqrDRjuG0rkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUDkS-00B2He-No; Tue, 15 Mar 2022 21:26:28 +0100
Date:   Tue, 15 Mar 2022 21:26:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.comf
Cc:     kuba@kernel.org, sebastian.hesselbarth@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: mv643xx_eth: undo some opreations in
 mv643xx_eth_probe
Message-ID: <YjD2dFwpF+esPs33@lunn.ch>
References: <20220315023019.2118163-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315023019.2118163-1-chi.minghao@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 02:30:19AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Cannot directly return platform_get_irq return irq, there
> are operations that need to be undone.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index e6cd4e214d79..6cd81737786e 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -3189,8 +3189,11 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>  
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (WARN_ON(irq < 0))
> +	if (WARN_ON(irq < 0)) {
> +		clk_disable_unprepare(mp->clk);
> +		free_netdev(dev);
>  		return irq;
> +	}

Isn't this where i said you should:

	goto out;

You need to set err first.

	Andrew
