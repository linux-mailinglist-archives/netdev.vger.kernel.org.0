Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA56021C5E0
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgGKSy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:54:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgGKSy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 14:54:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juKdh-004eJR-8P; Sat, 11 Jul 2020 20:54:21 +0200
Date:   Sat, 11 Jul 2020 20:54:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: DP83822: Add ability to
 advertise Fiber connection
Message-ID: <20200711185421.GS1014141@lunn.ch>
References: <20200710143733.30751-1-dmurphy@ti.com>
 <20200710143733.30751-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710143733.30751-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -302,6 +357,48 @@ static int dp83822_config_init(struct phy_device *phydev)
>  		}
>  	}
>  
> +	if (dp83822->fx_enabled) {
> +		err = phy_modify(phydev, MII_DP83822_CTRL_2,
> +				 DP83822_FX_ENABLE, 1);
> +		if (err < 0)
> +			return err;
> +
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->advertising);
> +
> +		/* Auto neg is not supported in fiber mode */
> +		bmcr = phy_read(phydev, MII_BMCR);
> +		if (bmcr < 0)
> +			return bmcr;
> +
> +		if (bmcr & BMCR_ANENABLE) {
> +			err =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> +			if (err < 0)
> +				return err;
> +		}
> +		phydev->autoneg = AUTONEG_DISABLE;

You should also be removing ETHTOOL_LINK_MODE_Autoneg_BIT from
phydev->supported, to make it clear autoneg is not supported. Assuming
genphy_read_abilities() cannot figure this out for itself.

			Andrew
