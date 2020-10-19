Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7B293027
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgJSVAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:00:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgJSVAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:00:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUcGW-002YOt-0E; Mon, 19 Oct 2020 23:00:24 +0200
Date:   Mon, 19 Oct 2020 23:00:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019210023.GU139700@lunn.ch>
References: <20201019204913.467287-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019204913.467287-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int m88e1111_finisar_config_init(struct phy_device *phydev)
> +{
> +	int err;
> +	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
> +
> +	if (extsr < 0)
> +		return extsr;
> +
> +	/* If using 1000BaseX and 1000BaseX auto-negotiation is disabled, enable it */
> +	if (phydev->interface == PHY_INTERFACE_MODE_1000BASEX &&
> +	    (extsr & MII_M1111_HWCFG_MODE_MASK) ==
> +	    MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN) {
> +		err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
> +				 MII_M1111_HWCFG_MODE_MASK |
> +				 MII_M1111_HWCFG_SERIAL_AN_BYPASS,
> +				 MII_M1111_HWCFG_MODE_COPPER_1000BX_AN |
> +				 MII_M1111_HWCFG_SERIAL_AN_BYPASS);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	return m88e1111_config_init(phydev);
> +}

Hi Robert

Is this really specific to the Finisar? It seems like any application
of the m88e1111 in 1000BaseX would benefit from this?

   Andrew
