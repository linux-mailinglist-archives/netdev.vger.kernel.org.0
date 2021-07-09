Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930FB3C2506
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhGINgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:36:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhGINgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 09:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=excJh9y2nqWqSJwKDj6JqEQH/BaiIN9As0xbYZ+rQAs=; b=nodDqgTyXeihHf9oM6rcjpTUir
        BSMu9L/auHJTJJGxaMcQY7y9jNp8pFI0kYMDJGqibwrSR3j8KTIdvRYMcv78tx3XhYE6nxgSvMxLM
        +g+Ef1PSNul+U1bK9GZ6HfvzwwmRLo/HMS5RmnHs0zWnT/diOHkn4AJNpP9cj4WMBl38=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1qcn-00Cm3w-2P; Fri, 09 Jul 2021 15:33:01 +0200
Date:   Fri, 9 Jul 2021 15:33:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: intel-xway: Add RGMII internal delay
 configuration
Message-ID: <YOhQDbYfWJnZhWz6@lunn.ch>
References: <20210709115726.11897-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709115726.11897-1-ms@dev.tdt.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* RX delay *must* be specified if internal delay of RX is used. */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		rx_int_delay = phy_get_internal_delay(phydev, dev,
> +						      &xway_internal_delay[0],
> +						      delay_size, true);
> +
> +		if (rx_int_delay < 0) {
> +			phydev_err(phydev, "rx-internal-delay-ps must be specified\n");
> +			return rx_int_delay;
> +		}
> +
> +		val &= ~XWAY_MDIO_MIICTRL_RXSKEW_MASK;
> +		val |= rx_int_delay << XWAY_MDIO_MIICTRL_RXSKEW_SHIFT;
> +	}

Please don't force the delay property to be present, use the default
of 2ns if it is missing.

> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +		err = phy_write(phydev, XWAY_MDIO_MIICTRL, val);
> +

This is the tricky bit. Do we want to act on PHY_INTERFACE_MODE_RGMII?
At the moment, i would say no, lets see how many patches we get
because of the warning you add. But i think it is worth adding a
comment here, briefly explaining why it is missing.

	Andrew
