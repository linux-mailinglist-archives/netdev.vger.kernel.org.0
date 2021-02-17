Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1411831D456
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 04:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBQD70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 22:59:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBQD7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 22:59:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCDys-006oIM-MY; Wed, 17 Feb 2021 04:58:26 +0100
Date:   Wed, 17 Feb 2021 04:58:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] net: phy: Add is_on_sfp_module flag and
 phy_on_sfp helper
Message-ID: <YCyUYqPt1X37bqpI@lunn.ch>
References: <20210216225454.2944373-1-robert.hancock@calian.com>
 <20210216225454.2944373-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216225454.2944373-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 04:54:53PM -0600, Robert Hancock wrote:
> Add a flag and helper function to indicate that a PHY device is part of
> an SFP module, which is set on attach. This can be used by PHY drivers
> to handle SFP-specific quirks or behavior.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/phy/phy_device.c |  2 ++
>  include/linux/phy.h          | 11 +++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 05261698bf74..d6ac3ed38197 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1377,6 +1377,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  
>  		if (phydev->sfp_bus_attached)
>  			dev->sfp_bus = phydev->sfp_bus;
> +		else if (dev->sfp_bus)
> +			phydev->is_on_sfp_module = true;

I get lost here. It this correct?

We have setups with two PHY. The marvell10g PHY can play the role of
media converter. It converts the signal from the MAC into signals
which can be connected to an SFP cage.

And then inside the cage, we can have a copper module with a second
PHY. It is this second PHY which we need to indicate is_on_sfp_module
true.

We probably want to media convert PHYs LEDs to work, since those
possible are connected to the front panel. So this needs to be
specific to the SFP module PHY, and i'm not sure it is. Russell?

	Andrew
