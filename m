Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66012A6656
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgKDO1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:27:08 -0500
Received: from foss.arm.com ([217.140.110.172]:37946 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgKDO1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:27:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88D57139F;
        Wed,  4 Nov 2020 06:27:07 -0800 (PST)
Received: from [10.57.54.223] (unknown [10.57.54.223])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 085C53F719;
        Wed,  4 Nov 2020 06:27:05 -0800 (PST)
Subject: Re: [PATCH] net: stmmac: Don't log error message in case of
 -EPROBE_DEFER.
To:     Markus Bauer <mb@karo-electronics.de>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20201104141524.13044-1-mb@karo-electronics.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <05031e00-18b0-ae43-2345-9f7eaf679828@arm.com>
Date:   Wed, 4 Nov 2020 14:27:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104141524.13044-1-mb@karo-electronics.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-04 14:15, Markus Bauer wrote:
> Remove error messages that might confuse users when error is just -517 / -EPROBE_DEFER.
> 
> [...]
> imx-dwmac 30bf0000.ethernet: Cannot register the MDIO bus
> imx-dwmac 30bf0000.ethernet: stmmac_dvr_probe: MDIO bus (id: 0) registration failed
> [...]

FYI we have dev_err_probe() for this now.

Robin.

> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++++---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 ++++--
>   2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 33272a12989a..7d1cdd576b91 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4857,9 +4857,10 @@ int stmmac_dvr_probe(struct device *device,
>   		/* MDIO bus Registration */
>   		ret = stmmac_mdio_register(ndev);
>   		if (ret < 0) {
> -			dev_err(priv->device,
> -				"%s: MDIO bus (id: %d) registration failed",
> -				__func__, priv->plat->bus_id);
> +			if (ret != -EPROBE_DEFER)
> +				dev_err(priv->device,
> +					"%s: MDIO bus (id: %d) registration failed, err=%d",
> +					__func__, priv->plat->bus_id, ret);
>   			goto error_mdio_register;
>   		}
>   	}
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 226e5a4bf21c..8e202f63da31 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -401,8 +401,10 @@ int stmmac_mdio_register(struct net_device *ndev)
>   	new_bus->parent = priv->device;
>   
>   	err = of_mdiobus_register(new_bus, mdio_node);
> -	if (err != 0) {
> -		dev_err(dev, "Cannot register the MDIO bus\n");
> +	if (err) {
> +		if (err != -EPROBE_DEFER)
> +			dev_err(dev,
> +				"Cannot register the MDIO bus, err=%d\n", err);
>   		goto bus_register_fail;
>   	}
>   
> 
