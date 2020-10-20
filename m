Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE5829401D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437093AbgJTQAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:00:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437088AbgJTQAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 12:00:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUu3z-002gSq-GG; Tue, 20 Oct 2020 18:00:39 +0200
Date:   Tue, 20 Oct 2020 18:00:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH russell-kings-net-queue v2 1/3] net: phy: mdio-i2c:
 support I2C MDIO protocol for RollBall SFP modules
Message-ID: <20201020160039.GI139700@lunn.ch>
References: <20201020150615.11969-1-kabel@kernel.org>
 <20201020150615.11969-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020150615.11969-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This extends the mdio-i2c driver so that when SFP PHY address 17 is used
> (which in mdio-i2c terms corresponds to I2C address 0x51), then this
> different protocol is used for MDIO access.

Hi Marek

I don't see that being very scalable. What happens when the next SFP
comes along which has a different protocol at address 0x51. Since you
can identify the SFP via the EEPROM information, i would prefer you
explicitly tell it to use the rollball protocol when instantiating the
MDIO bus.

>   * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
>   * specified to be present in SFP modules.  These correspond with PHY
> - * addresses 16 and 17.  Disallow access to these "phy" addresses.
> + * addresses 16 and 17.  Disallow access to 0x50 "phy" address.
> + * Use RollBall protocol when accessing via the 0x51 address.
>   */
>  static bool i2c_mii_valid_phy_id(int phy_id)
>  {
> -	return phy_id != 0x10 && phy_id != 0x11;
> +	return phy_id != 0x10;
> +}

I'm not sure that is safe. It means that we will scan address 0x11 to
see if there is a PHY there. And if the SFP does have diagnostics
registers, that might be enough that phylib thinks there is a PHY
there.

I think you only need to allow access to 0x11 if rollball protocol has
been enabled.

     Andrew
