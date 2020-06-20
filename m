Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1F2024BC
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgFTPVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:21:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgFTPVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 11:21:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmfJO-001PND-Rz; Sat, 20 Jun 2020 17:21:42 +0200
Date:   Sat, 20 Jun 2020 17:21:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC
 support
Message-ID: <20200620152142.GN304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619122300.2510533-7-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Retrieve the shared load/save GPIO. Request it as non exclusive as
> +	 * the same GPIO can be requested by all the PHYs of the same package.
> +	 * Ths GPIO must be used with the phc_lock taken (the lock is shared
> +	 * between all PHYs).
> +	 */
> +	vsc8531->load_save = devm_gpiod_get_optional(&phydev->mdio.dev, "load-save",
> +						     GPIOD_FLAGS_BIT_NONEXCLUSIVE |
> +						     GPIOD_OUT_LOW);
> +	if (IS_ERR(vsc8531->load_save)) {
> +		phydev_err(phydev, "Can't get load-save GPIO (%ld)\n",
> +			   PTR_ERR(vsc8531->load_save));
> +		return PTR_ERR(vsc8531->load_save);
> +	}
> +

I can understand the GPIO being optional, it is only needed when PTP
is being used. But i don't see a test anywhere that when PTP is being
used the GPIO is provided. What actually happens if it is missing and
somebody tries to use the PTP? Maybe only register the PTP parts with
the core if the GPIO has been found in DT?

    Andrew
