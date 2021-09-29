Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF9041E2B2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbhI3UfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:35:05 -0400
Received: from gloria.sntech.de ([185.11.138.130]:59008 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347824AbhI3UfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 16:35:04 -0400
Received: from ip5f5a6e92.dynamic.kabel-deutschland.de ([95.90.110.146] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1mVgir-0000Wl-UD; Wed, 29 Sep 2021 23:02:37 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     netdev@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>
Cc:     linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        kuba@kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices
Date:   Wed, 29 Sep 2021 23:02:35 +0200
Message-ID: <12744188.XEzkDOsqEc@diego>
In-Reply-To: <20210929135049.3426058-1-punitagrawal@gmail.com>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, 29. September 2021, 15:50:49 CEST schrieb Punit Agrawal:
> Commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
> while getting rid of a runtime PM warning ended up breaking ethernet
> on rk3399 based devices. By dropping an extra reference to the device,
> the commit ends up enabling suspend / resume of the ethernet device -
> which appears to be broken.
> 
> While the issue with runtime pm is being investigated, partially
> revert commit 2d26f6e39afb to restore the network on rk3399.
> 
> Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
> Suggested-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
> Cc: Michael Riesch <michael.riesch@wolfvision.net>

On a rk3399-puma which has the described issue,
Tested-by: Heiko Stuebner <heiko@sntech.de>


> ---
> Hi,
> 
> There's been a few reports of broken ethernet on rk3399 based
> boards. The issue got introduced due to a late commit in the 5.14
> cycle.
> 
> It would be great if this commit can be taken as a fix for the next rc
> as well as applied to the 5.14 stable releases.
> 
> Thanks,
> Punit
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index ed817011a94a..6924a6aacbd5 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -21,6 +21,7 @@
>  #include <linux/delay.h>
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
> +#include <linux/pm_runtime.h>
>  
>  #include "stmmac_platform.h"
>  
> @@ -1528,6 +1529,8 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
>  		return ret;
>  	}
>  
> +	pm_runtime_get_sync(dev);
> +
>  	if (bsp_priv->integrated_phy)
>  		rk_gmac_integrated_phy_powerup(bsp_priv);
>  
> @@ -1539,6 +1542,8 @@ static void rk_gmac_powerdown(struct rk_priv_data *gmac)
>  	if (gmac->integrated_phy)
>  		rk_gmac_integrated_phy_powerdown(gmac);
>  
> +	pm_runtime_put_sync(&gmac->pdev->dev);
> +
>  	phy_power_on(gmac, false);
>  	gmac_clk_enable(gmac, false);
>  }
> 




