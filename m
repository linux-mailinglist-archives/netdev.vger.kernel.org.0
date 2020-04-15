Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F181AB38C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 23:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbgDOV54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 17:57:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbgDOV5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 17:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/DDL832SIa6ewJd6AH9+hvXp4h67AEELea1fNLlGnfE=; b=2o2+x54G1B6hPauGpycJml6b4s
        dCrlPmosPmh9Wasj+uvWAbFYJKUnWutjtxvJvINdd23DwlFbkNSh0jNz0rVgMJzEJ1+79RF55ZMI6
        L8GyGcM5ZNVOMS4CD0uJ7bswnjsqI3T4U2C0+x6JXZiG4kJE6ZtQveNhT37nni+aZNJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOq2N-002xX6-By; Wed, 15 Apr 2020 23:57:39 +0200
Date:   Wed, 15 Apr 2020 23:57:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415215739.GI657811@lunn.ch>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415121209.12197-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes. If
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d76e038cf2cb5..9f48141f1e701 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -294,7 +294,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  			 phydev->advertising, autoneg == AUTONEG_ENABLE);
>  
>  	phydev->duplex = duplex;
> -
> +	phydev->master_slave = cmd->base.master_slave;
>  	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>  
>  	/* Restart the PHY */
> @@ -313,6 +313,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
>  
>  	cmd->base.speed = phydev->speed;
>  	cmd->base.duplex = phydev->duplex;
> +	cmd->base.master_slave = phydev->master_slave;
>  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>  		cmd->base.port = PORT_BNC;
>  	else
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index c8b0c34030d32..d5edf2bc40e43 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>  	dev->asym_pause = 0;
>  	dev->link = 0;
>  	dev->interface = PHY_INTERFACE_MODE_GMII;
> +	dev->master_slave = PORT_MODE_UNKNOWN;

phydev->master_slave is how we want the PHY to be configured. I don't
think PORT_MODE_UNKNOWN makes any sense in that contest. 802.3 gives
some defaults. 9.12 should be 0, meaning manual master/slave
configuration is disabled. The majority of linux devices are end
systems. So we should default to a single point device. So i would
initialise PORT_MODE_SLAVE, or whatever we end up calling that.
>  
>  	dev->autoneg = AUTONEG_ENABLE;
>  
> @@ -1772,6 +1773,68 @@ int genphy_setup_forced(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_setup_forced);
>  
> +static int genphy_setup_master_slave(struct phy_device *phydev)
> +{
> +	u16 ctl = 0;
> +
> +	if (!phydev->is_gigabit_capable)
> +		return 0;
> +
> +	switch (phydev->master_slave) {
> +	case PORT_MODE_MASTER:
> +		ctl |= CTL1000_PREFER_MASTER;
> +		/* fallthrough */
> +	case PORT_MODE_SLAVE:
> +		/* CTL1000_ENABLE_MASTER is zero */
> +		break;
> +	case PORT_MODE_MASTER_FORCE:
> +		ctl |= CTL1000_AS_MASTER;
> +		/* fallthrough */
> +	case PORT_MODE_SLAVE_FORCE:
> +		ctl |= CTL1000_ENABLE_MASTER;
> +		break;
> +	case PORT_MODE_UNKNOWN:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return 0;
> +	}
> +
> +	return phy_modify_changed(phydev, MII_CTRL1000,
> +				  (CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER |
> +				   CTL1000_PREFER_MASTER), ctl);
> +}
> +
> +static int genphy_read_master_slave(struct phy_device *phydev)
> +{
> +	u16 ctl, stat;
> +
> +	if (!phydev->is_gigabit_capable)
> +		return 0;
> +
> +	ctl = phy_read(phydev, MII_CTRL1000);
> +	if (ctl < 0)
> +		return ctl;
> +
> +	stat = phy_read(phydev, MII_STAT1000);
> +	if (stat < 0)
> +		return stat;
> +
> +	if (ctl & CTL1000_ENABLE_MASTER) {
> +		if (stat & LPA_1000MSRES)
> +			phydev->master_slave = PORT_MODE_MASTER_FORCE;
> +		else
> +			phydev->master_slave = PORT_MODE_SLAVE_FORCE;
> +	} else {
> +		if (stat & LPA_1000MSRES)
> +			phydev->master_slave = PORT_MODE_MASTER;
> +		else
> +			phydev->master_slave = PORT_MODE_SLAVE;
> +	}

This seems wrong. phydev->master_slave should be about how we want the
PHY to be configured. genphy_read_master_slave() should be about what
we actually ended up using. It should not be over-writing
phydev->master_slave, it needs to put it into some other variable.

phy_ethtool_ksettings_set() should allow us to set how we want the
device to behave. phy_ethtool_ksettings_get() should return both how
we have configured it, and if master/slave has been resolved, what the
result of the resolution is. Here something like PORT_MODE_UNKNOWN
does make sense, when the link is down, to resolution has not yet
completed.

       Andrew
