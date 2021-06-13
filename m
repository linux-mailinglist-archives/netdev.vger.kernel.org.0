Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C13A5A2E
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 21:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhFMTgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 15:36:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhFMTgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 15:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2BA4RNhCjaFpUPQyIKOReOdpzeXLB4MO8b4DhdboByk=; b=Hvbls+4iYDcRMKr8nnSZ7xITaW
        X8Xr2+wC4YJ9GhE2urjXkrjznFCjPKn47UoL4zdQthLLzh1tIo/YJ2RGQ4eks/ndXeWp9l1gmfprk
        1A54BC1s0+C5oBNipqnSCpmiqaJg8JxR+WLIWlL8kyDmage5XL5wcWsN1hpjM6O4hmCo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsVsE-009BuQ-1d; Sun, 13 Jun 2021 21:34:22 +0200
Date:   Sun, 13 Jun 2021 21:34:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
Message-ID: <YMZdvt4xlev3JQhF@lunn.ch>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-2-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613183520.2247415-2-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -336,7 +338,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  			dev_warn(&pdev->dev,
>  				 "unsupported number of clocks, limiting to the first "
>  				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
> -	} else {
> +	} else if (!has_acpi_companion(&pdev->dev)) {
>  		dev->clk[0] = clk_get(&pdev->dev, NULL);
>  		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
>  			ret = -EPROBE_DEFER;

Is this needed? As you said, there are no clocks when ACPI is used, So
doesn't clk_get() return -ENODEV? Since this is not EPRODE_DEFER, it
keeps going. The clk_prepare_enable() won't be called.

> -	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	if (pdev->dev.of_node)
> +		ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	else if (is_acpi_node(pdev->dev.fwnode))
> +		ret = acpi_mdiobus_register(bus, pdev->dev.fwnode);
> +	else
> +		ret = -EINVAL;
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
>  		goto out_mdio;
> @@ -383,6 +390,9 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  	if (dev->err_interrupt > 0)
>  		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
>  
> +	if (has_acpi_companion(&pdev->dev))
> +		return ret;
> +

I think this can also be removed for the same reason.

We should try to avoid adding has_acpi_companion() and
!pdev->dev.of_node whenever we can. It makes the driver code too much
of a maze.

   Andrew
