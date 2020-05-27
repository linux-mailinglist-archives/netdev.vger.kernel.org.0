Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8F1E342B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgE0Awc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:52:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgE0Awb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 20:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4g+QjcgqBBdlXj9GuROVX7jykU64LcaF7oK4MUdO6AA=; b=xXwdGwbBnqIBLc/16cfVjN1+Yt
        C9bj+FYw41raWFKql2omrQ41YijjzVsTBJ/dha95qgn+uIti6GoufaTkdYIJSCg+YGLvYp/oFTrxj
        iP5nIuGu0luNDbB4Vw6wh19ExYMOrLYfOWdoXUiBZGoZtgjIEGHvfPTLSnx62OSl/UUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdkIy-003LDU-4D; Wed, 27 May 2020 02:52:24 +0200
Date:   Wed, 27 May 2020 02:52:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: dp83869: Add RGMII internal delay
 configuration
Message-ID: <20200527005224.GF782807@lunn.ch>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526174716.14116-5-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -218,6 +224,7 @@ static int dp83869_of_init(struct phy_device *phydev)
>  		ret = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_STRAP_STS1);
>  		if (ret < 0)
>  			return ret;
> +
>  		if (ret & DP83869_STRAP_MIRROR_ENABLED)
>  			dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
>  		else

This random white space change does not belong in this patch.

> @@ -232,6 +239,20 @@ static int dp83869_of_init(struct phy_device *phydev)
>  				 &dp83869->tx_fifo_depth))
>  		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>  
> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
> +				   &dp83869->rx_id_delay);
> +	if (ret) {
> +		dp83869->rx_id_delay = ret;
> +		ret = 0;
> +	}

This looks odd.

If this optional property is not found, -EINVAL will be returned. It
could also return -ENODATA. You then assign this error value to
dp83869->rx_id_delay? I would of expected you to assign 2000, the
default value?

> +
> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
> +				   &dp83869->tx_id_delay);
> +	if (ret) {
> +		dp83869->tx_id_delay = ret;
> +		ret = 0;
> +	}
> +
>  	return ret;
>  }
>  #else
> @@ -367,10 +388,45 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>  	return ret;
>  }
>  
> +static int dp83869_get_delay(struct phy_device *phydev)
> +{
> +	struct dp83869_private *dp83869 = phydev->priv;
> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
> +	int tx_delay = 0;
> +	int rx_delay = 0;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		tx_delay = phy_get_delay_index(phydev,
> +					       &dp83869_internal_delay[0],
> +					       delay_size, dp83869->tx_id_delay,
> +					       false);
> +		if (tx_delay < 0) {
> +			phydev_err(phydev, "Tx internal delay is invalid\n");
> +			return tx_delay;
> +		}
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		rx_delay = phy_get_delay_index(phydev,
> +					       &dp83869_internal_delay[0],
> +					       delay_size, dp83869->rx_id_delay,
> +					       false);
> +		if (rx_delay < 0) {
> +			phydev_err(phydev, "Rx internal delay is invalid\n");
> +			return rx_delay;
> +		}
> +	}

So any PHY using these properties is going to pretty much reproduce
this code. Meaning is should all be in a helper.

     Andrew
