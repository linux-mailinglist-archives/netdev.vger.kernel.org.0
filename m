Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D144A2D3344
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgLHUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbgLHUNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:13:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmi2i-00Atz4-Vu; Tue, 08 Dec 2020 19:48:56 +0100
Date:   Tue, 8 Dec 2020 19:48:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 3/8] net: macb: add function to disable all macb clocks
Message-ID: <20201208184856.GM2475764@lunn.ch>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
 <1607343333-26552-4-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607343333-26552-4-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu

>  static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
>  			 struct clk **hclk, struct clk **tx_clk,
>  			 struct clk **rx_clk, struct clk **tsu_clk)
> @@ -3743,40 +3753,37 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
>  	err = clk_prepare_enable(*hclk);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to enable hclk (%d)\n", err);
> -		goto err_disable_pclk;
> +		hclk = NULL;
> +		tx_clk = NULL;
> +		rx_clk = NULL;
> +		goto err_disable_clks;
>  	}
>  
>  	err = clk_prepare_enable(*tx_clk);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to enable tx_clk (%d)\n", err);
> -		goto err_disable_hclk;
> +		tx_clk = NULL;
> +		rx_clk = NULL;
> +		goto err_disable_clks;
>  	}
>  
>  	err = clk_prepare_enable(*rx_clk);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to enable rx_clk (%d)\n", err);
> -		goto err_disable_txclk;
> +		rx_clk = NULL;
> +		goto err_disable_clks;
>  	}
>  
>  	err = clk_prepare_enable(*tsu_clk);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to enable tsu_clk (%d)\n", err);
> -		goto err_disable_rxclk;
> +		goto err_disable_clks;
>  	}
>  
>  	return 0;
>  
> -err_disable_rxclk:
> -	clk_disable_unprepare(*rx_clk);
> -
> -err_disable_txclk:
> -	clk_disable_unprepare(*tx_clk);
> -
> -err_disable_hclk:
> -	clk_disable_unprepare(*hclk);
> -
> -err_disable_pclk:
> -	clk_disable_unprepare(*pclk);
> +err_disable_clks:
> +	macb_clks_disable(*pclk, *hclk, *tx_clk, *rx_clk, NULL);

Personal taste, but i would of not changed this.

>  
>  	return err;
>  }
> @@ -4755,11 +4762,7 @@ static int macb_probe(struct platform_device *pdev)
>  	free_netdev(dev);
>  
>  err_disable_clocks:
> -	clk_disable_unprepare(tx_clk);
> -	clk_disable_unprepare(hclk);
> -	clk_disable_unprepare(pclk);
> -	clk_disable_unprepare(rx_clk);
> -	clk_disable_unprepare(tsu_clk);
> +	macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
>  	pm_runtime_disable(&pdev->dev);
>  	pm_runtime_set_suspended(&pdev->dev);
>  	pm_runtime_dont_use_autosuspend(&pdev->dev);
> @@ -4784,11 +4787,8 @@ static int macb_remove(struct platform_device *pdev)
>  		pm_runtime_disable(&pdev->dev);
>  		pm_runtime_dont_use_autosuspend(&pdev->dev);
>  		if (!pm_runtime_suspended(&pdev->dev)) {
> -			clk_disable_unprepare(bp->tx_clk);
> -			clk_disable_unprepare(bp->hclk);
> -			clk_disable_unprepare(bp->pclk);
> -			clk_disable_unprepare(bp->rx_clk);
> -			clk_disable_unprepare(bp->tsu_clk);
> +			macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk,
> +					  bp->rx_clk, bp->tsu_clk);
>  			pm_runtime_set_suspended(&pdev->dev);
>  		}
>  		phylink_destroy(bp->phylink);
> @@ -4966,14 +4966,16 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct macb *bp = netdev_priv(netdev);
> +	struct clk *pclk = NULL, *hclk = NULL, *tx_clk = NULL, *rx_clk = NULL;
>  
>  	if (!(device_may_wakeup(dev))) {
> -		clk_disable_unprepare(bp->tx_clk);
> -		clk_disable_unprepare(bp->hclk);
> -		clk_disable_unprepare(bp->pclk);
> -		clk_disable_unprepare(bp->rx_clk);
> +		pclk = bp->pclk;
> +		hclk = bp->hclk;
> +		tx_clk = bp->tx_clk;
> +		rx_clk = bp->rx_clk;
>  	}
> -	clk_disable_unprepare(bp->tsu_clk);
> +
> +	macb_clks_disable(pclk, hclk, tx_clk, rx_clk, bp->tsu_clk);

Maybe

  	if (!(device_may_wakeup(dev)))
		macb_clks_disable(bp->pclk, bp->hclk, pb->tx_clk, bp->rx_clk, bp->tsu_clk);
	else
		macb_clks_disable(NULL, NULL, NULL, NULL, bp->tsu_clk);

is more readable?

   Andrew
