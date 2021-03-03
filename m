Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075FC32B3E6
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840281AbhCCEHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhCCBYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 20:24:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHGEp-0096tc-It; Wed, 03 Mar 2021 02:23:43 +0100
Date:   Wed, 3 Mar 2021 02:23:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org
Subject: Re: [RFC V2 resend net-next 1/3] net: stmmac: add clocks management
 for gmac driver
Message-ID: <YD7lHzFxPPYA3M04@lunn.ch>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
 <20210301102529.18573-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301102529.18573-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 06:25:27PM +0800, Joakim Zhang wrote:
> @@ -121,11 +132,22 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
>  
>  	/* Wait until any existing MII operation is complete */
>  	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
> -			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
> -		return -EBUSY;
> +			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
> +		ret = -EBUSY;
> +		goto err_disable_clks;
> +	}
>  
>  	/* Read the data from the MII data register */
> -	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
> +	data = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
> +
> +	pm_runtime_put(priv->device);
> +
> +	return data;
> +
> +err_disable_clks:
> +	pm_runtime_put(priv->device);
> +
> +	return ret;

Hi Joakim

You could do

	ret = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);

err_disable_clks:
	pm_runtime_put(priv->device);

	return ret;

Slightly simpler.

>  
>  	/* Read the data from the MII data register */
>  	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
>  
> +	pm_runtime_put(priv->device);
> +
>  	return data;
> +
> +err_disable_clks:
> +	pm_runtime_put(priv->device);
> +
> +	return ret;
>  }

Same here.

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
