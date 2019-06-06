Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB937590
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfFFNpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:45:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfFFNpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sVhxnuTEL+ASO8R37ZHCwQE4/QWOi4bshU6Rq9FdZC4=; b=26rWKdQreTTF7+VEn7aEMEjhr7
        P2Q5uT7VzDHA0TBoOd6hQ8KZo9YfeTEb4vcqLvg/LS9WwBU5UpjdbF82NDDL//Yc0BNu6uc5f8a0F
        XYO1giz9jk+OgwmPpuHg2tSqB0si1SXLz06rxH1w5BvctFO+tAI0pAVbs1H/jlejo77s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYshI-0006Hm-0s; Thu, 06 Jun 2019 15:44:52 +0200
Date:   Thu, 6 Jun 2019 15:44:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 net-next] net: stmmac: move reset gpio parse & request
 to stmmac_mdio_register
Message-ID: <20190606134452.GD19590@lunn.ch>
References: <20190606182244.422e187f@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606182244.422e187f@xhacker.debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:31:56AM +0000, Jisheng Zhang wrote:
> Move the reset gpio dt parse and request to stmmac_mdio_register(),
> thus makes the mdio code straightforward.
> 
> This patch also replace stack var mdio_bus_data with data to simplify
> the code.

Hi Jisheng

Please split this into two patches.

> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
> Since v1:
>  - rebase on the latest net-next tree
> 
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 58 ++++++++-----------
>  1 file changed, 25 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 093a223fe408..7d1562ec1149 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -250,28 +250,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
>  	struct stmmac_mdio_bus_data *data = priv->plat->mdio_bus_data;
>  
>  #ifdef CONFIG_OF
> -	if (priv->device->of_node) {
> -		if (data->reset_gpio < 0) {
> -			struct device_node *np = priv->device->of_node;
> -
> -			if (!np)
> -				return 0;
> -
> -			data->reset_gpio = of_get_named_gpio(np,
> -						"snps,reset-gpio", 0);
> -			if (data->reset_gpio < 0)
> -				return 0;
> -
> -			data->active_low = of_property_read_bool(np,
> -						"snps,reset-active-low");
> -			of_property_read_u32_array(np,
> -				"snps,reset-delays-us", data->delays, 3);
> -
> -			if (devm_gpio_request(priv->device, data->reset_gpio,
> -					      "mdio-reset"))
> -				return 0;
> -		}
> -
> +	if (gpio_is_valid(data->reset_gpio)) {
>  		gpio_direction_output(data->reset_gpio,
>  				      data->active_low ? 1 : 0);
>  		if (data->delays[0])
> @@ -313,24 +292,38 @@ int stmmac_mdio_register(struct net_device *ndev)
>  	int err = 0;
>  	struct mii_bus *new_bus;
>  	struct stmmac_priv *priv = netdev_priv(ndev);
> -	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
> +	struct stmmac_mdio_bus_data *data = priv->plat->mdio_bus_data;
>  	struct device_node *mdio_node = priv->plat->mdio_node;
>  	struct device *dev = ndev->dev.parent;
>  	int addr, found, max_addr;
>  
> -	if (!mdio_bus_data)
> +	if (!data)
>  		return 0;
>  
>  	new_bus = mdiobus_alloc();
>  	if (!new_bus)
>  		return -ENOMEM;
>  
> -	if (mdio_bus_data->irqs)
> -		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
> +	if (data->irqs)
> +		memcpy(new_bus->irq, data->irqs, sizeof(new_bus->irq));
>  
>  #ifdef CONFIG_OF
> -	if (priv->device->of_node)
> -		mdio_bus_data->reset_gpio = -1;
> +	if (priv->device->of_node) {
> +		struct device_node *np = priv->device->of_node;
> +
> +		data->reset_gpio = of_get_named_gpio(np, "snps,reset-gpio", 0);
> +		if (gpio_is_valid(data->reset_gpio)) {
> +			data->active_low = of_property_read_bool(np,
> +						"snps,reset-active-low");
> +			of_property_read_u32_array(np,
> +				"snps,reset-delays-us", data->delays, 3);
> +
> +			devm_gpio_request(priv->device, data->reset_gpio,
> +					  "mdio-reset");
> +		}
> +	} else {
> +		data->reset_gpio = -1;
> +	}

This seems like a good candidate to be a small helper
function. Quoting the coding style:

6) Functions
------------

Functions should be short and sweet, and do just one thing.  They should
fit on one or two screenfuls of text (the ISO/ANSI screen size is 80x24,
as we all know), and do one thing and do that well.

stmmac_mdio_register() is not short and sweet, and this is making it
bigger.

	Andrew
