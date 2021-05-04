Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EAB372E0A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhEDQ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:29:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:60126 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhEDQ3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 12:29:07 -0400
IronPort-SDR: CHl7en0B3MCUHQ33mRniRrK06LUtD2Y/Ew631LJlUEqWFhRCVdYTT6CdgiB/8237jNqs11OWsf
 sBRy2UsQofLw==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="198078070"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="198078070"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 09:24:30 -0700
IronPort-SDR: ksnl94US5zV7wxorR1fpKupw+gIL6HJ80Kn96PxESxFCNlW8HfN0d4lkZ+EvWzvgC2M2AbI7z0
 pO1fzsovqJzQ==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="468578697"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 09:24:26 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ldxqQ-009a1w-MH; Tue, 04 May 2021 19:24:22 +0300
Date:   Tue, 4 May 2021 19:24:22 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Timo =?iso-8859-1?B?U2NobPzfbGVy?= <schluessler@krause.de>,
        Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
Message-ID: <YJF1NlQd8xtnUBSG@smile.fi.intel.com>
References: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 06:01:48PM +0200, Schrempf Frieder wrote:
> Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
> resuming after suspend, even when the interface was not previously
> enabled. This causes a null dereference error as the workqueue is
> only allocated and initialized in mcp251x_open().
> 
> To fix this we move the workqueue init to mcp251x_can_probe() as
> there is no reason to do it later and repeat it whenever
> mcp251x_open() is called.

AFAIU the IRQ is freed at ->ndo_stop() which is guaranteed to be called before
->remove(). If it's the case, we are fine.

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  drivers/net/can/spi/mcp251x.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index a57da43680d8..42e8e5791c9f 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -956,8 +956,6 @@ static int mcp251x_stop(struct net_device *net)
>  
>  	priv->force_quit = 1;
>  	free_irq(spi->irq, priv);
> -	destroy_workqueue(priv->wq);
> -	priv->wq = NULL;
>  
>  	mutex_lock(&priv->mcp_lock);
>  
> @@ -1224,15 +1222,6 @@ static int mcp251x_open(struct net_device *net)
>  		goto out_close;
>  	}
>  
> -	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
> -				   0);
> -	if (!priv->wq) {
> -		ret = -ENOMEM;
> -		goto out_clean;
> -	}
> -	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
> -	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
> -
>  	ret = mcp251x_hw_wake(spi);
>  	if (ret)
>  		goto out_free_wq;
> @@ -1373,6 +1362,15 @@ static int mcp251x_can_probe(struct spi_device *spi)
>  	if (ret)
>  		goto out_clk;
>  
> +	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
> +				   0);
> +	if (!priv->wq) {
> +		ret = -ENOMEM;
> +		goto out_clk;
> +	}
> +	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
> +	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
> +
>  	priv->spi = spi;
>  	mutex_init(&priv->mcp_lock);
>  
> @@ -1417,6 +1415,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
>  	return 0;
>  
>  error_probe:
> +	destroy_workqueue(priv->wq);
> +	priv->wq = NULL;
>  	mcp251x_power_enable(priv->power, 0);
>  
>  out_clk:
> @@ -1438,6 +1438,9 @@ static int mcp251x_can_remove(struct spi_device *spi)
>  
>  	mcp251x_power_enable(priv->power, 0);
>  
> +	destroy_workqueue(priv->wq);
> +	priv->wq = NULL;
> +
>  	clk_disable_unprepare(priv->clk);
>  
>  	free_candev(net);
> -- 
> 2.25.1
> 
> 

-- 
With Best Regards,
Andy Shevchenko


