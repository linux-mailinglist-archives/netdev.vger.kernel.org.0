Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0CDEC29F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbfKAMSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:18:08 -0400
Received: from foss.arm.com ([217.140.110.172]:34540 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfKAMSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 08:18:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 314F31F1;
        Fri,  1 Nov 2019 05:18:07 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BBFD3F6C4;
        Fri,  1 Nov 2019 05:18:06 -0700 (PDT)
Date:   Fri, 1 Nov 2019 12:18:04 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, axboe@kernel.dk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] net: stmmac: Split devicetree parse
Message-ID: <20191101121802.GD9723@e119886-lin.cambridge.arm.com>
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
 <20191030135347.3636-3-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030135347.3636-3-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 09:53:44PM +0800, Jiaxun Yang wrote:
> PCI based devices can share devicetree info parse with platform
> device based devices after split dt parse frpm dt probe.

s/frpm/from/

> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  .../ethernet/stmicro/stmmac/stmmac_platform.c | 63 ++++++++++++++-----
>  .../ethernet/stmicro/stmmac/stmmac_platform.h |  3 +
>  2 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 170c3a052b14..7e29bc76b7c3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -385,25 +385,19 @@ static int stmmac_of_get_mac_mode(struct device_node *np)
>  }
>  
>  /**
> - * stmmac_probe_config_dt - parse device-tree driver parameters
> - * @pdev: platform_device structure
> - * @mac: MAC address to use
> + * stmmac_parse_config_dt - parse device-tree driver parameters
> + * @np: device_mode structure
> + * @plat: plat_stmmacenet_data structure
>   * Description:
>   * this function is to read the driver parameters from device-tree and
>   * set some private fields that will be used by the main at runtime.
>   */
> -struct plat_stmmacenet_data *
> -stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
> +int stmmac_parse_config_dt(struct device_node *np,
> +				struct plat_stmmacenet_data *plat)
>  {
> -	struct device_node *np = pdev->dev.of_node;
> -	struct plat_stmmacenet_data *plat;
>  	struct stmmac_dma_cfg *dma_cfg;
>  	int rc;
>  
> -	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
> -	if (!plat)
> -		return ERR_PTR(-ENOMEM);
> -
>  	*mac = of_get_mac_address(np);
>  	if (IS_ERR(*mac)) {
>  		if (PTR_ERR(*mac) == -EPROBE_DEFER)
> @@ -414,7 +408,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  
>  	plat->phy_interface = of_get_phy_mode(np);
>  	if (plat->phy_interface < 0)
> -		return ERR_PTR(plat->phy_interface);
> +		return plat->phy_interface;
>  
>  	plat->interface = stmmac_of_get_mac_mode(np);
>  	if (plat->interface < 0)
> @@ -453,7 +447,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  	/* To Configure PHY by using all device-tree supported properties */
>  	rc = stmmac_dt_phy(plat, np, &pdev->dev);
>  	if (rc)
> -		return ERR_PTR(rc);
> +		return rc;
>  
>  	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
>  
> @@ -531,7 +525,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  			       GFP_KERNEL);
>  	if (!dma_cfg) {
>  		stmmac_remove_config_dt(pdev, plat);
> -		return ERR_PTR(-ENOMEM);
> +		return -ENOMEM;
>  	}
>  	plat->dma_cfg = dma_cfg;
>  
> @@ -560,7 +554,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  	rc = stmmac_mtl_setup(pdev, plat);
>  	if (rc) {
>  		stmmac_remove_config_dt(pdev, plat);
> -		return ERR_PTR(rc);
> +		return rc;
>  	}
>  
>  	/* clock setup */
> @@ -604,14 +598,43 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  		plat->stmmac_rst = NULL;
>  	}
>  
> -	return plat;
> +	return 0;
>  
>  error_hw_init:
>  	clk_disable_unprepare(plat->pclk);
>  error_pclk_get:
>  	clk_disable_unprepare(plat->stmmac_clk);
>  
> -	return ERR_PTR(-EPROBE_DEFER);
> +	return -EPROBE_DEFER;
> +}
> +
> +/**
> + * stmmac_probe_config_dt - probe and setup stmmac platform data by devicetree
> + * @pdev: platform_device structure
> + * @mac: MAC address to use
> + * Description:
> + * this function is to set up plat_stmmacenet_data  private structure
> + * for platform drivers.
> + */
> +struct plat_stmmacenet_data *
> +stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct plat_stmmacenet_data *plat;
> +	int rc;
> +
> +	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
> +	if (!plat)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rc = stmmac_parse_config_dt(np, plat);
> +
> +	if (rc) {
> +		free(plat);

Given the devm_kzalloc - is the free really needed here?

Thanks,

Andrew Murray

> +		return ERR_PTR(rc);
> +	}
> +
> +	return plat;
>  }
>  
>  /**
> @@ -628,6 +651,11 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
>  	of_node_put(plat->mdio_node);
>  }
>  #else
> +int stmmac_parse_config_dt(struct device_node *np,
> +				struct plat_stmmacenet_data *plat)
> +{
> +	return -EINVAL;
> +}
>  struct plat_stmmacenet_data *
>  stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  {
> @@ -639,6 +667,7 @@ void stmmac_remove_config_dt(struct platform_device *pdev,
>  {
>  }
>  #endif /* CONFIG_OF */
> +EXPORT_SYMBOL_GPL(stmmac_parse_config_dt);
>  EXPORT_SYMBOL_GPL(stmmac_probe_config_dt);
>  EXPORT_SYMBOL_GPL(stmmac_remove_config_dt);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
> index 3a4663b7b460..0e4aec1f502a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
> @@ -11,6 +11,9 @@
>  
>  #include "stmmac.h"
>  
> +int stmmac_parse_config_dt(struct device_node *np,
> +				struct plat_stmmacenet_data *plat);
> +
>  struct plat_stmmacenet_data *
>  stmmac_probe_config_dt(struct platform_device *pdev, const char **mac);
>  void stmmac_remove_config_dt(struct platform_device *pdev,
> -- 
> 2.23.0
> 
