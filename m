Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F8C1BE7C3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD2Tw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:52:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:60218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2Tw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 15:52:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 979CEADFF;
        Wed, 29 Apr 2020 19:52:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 56810604EB; Wed, 29 Apr 2020 21:52:22 +0200 (CEST)
Date:   Wed, 29 Apr 2020 21:52:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200429195222.GA17581@lion.mk-sys.cz>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428075308.2938-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 09:53:07AM +0200, Oleksij Rempel wrote:
> This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> auto-negotiation support, we needed to be able to configure the
> MASTER-SLAVE role of the port manually or from an application in user
> space.
> 
> The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> force MASTER or SLAVE role. See IEEE 802.3-2018:
> 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> 40.5.2 MASTER-SLAVE configuration resolution
> 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> 
> The MASTER-SLAVE role affects the clock configuration:
> 
> -------------------------------------------------------------------------------
> When the  PHY is configured as MASTER, the PMA Transmit function shall
> source TX_TCLK from a local clock source. When configured as SLAVE, the
> PMA Transmit function shall source TX_TCLK from the clock recovered from
> data stream provided by MASTER.
> 
> iMX6Q                     KSZ9031                XXX
> ------\                /-----------\        /------------\
>       |                |           |        |            |
>  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
>       |<--- 125 MHz ---+-<------/  |        | \          |
> ------/                \-----------/        \------------/
>                                                ^
>                                                 \-TX_TCLK
> 
> -------------------------------------------------------------------------------
> 
> Since some clock or link related issues are only reproducible in a
> specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> to provide generic (not 100BASE-T1 specific) interface to the user space
> for configuration flexibility and trouble shooting.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
[...]
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 72c69a9c8a98a..a6a774beb2f90 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -285,6 +285,9 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  	      duplex != DUPLEX_FULL)))
>  		return -EINVAL;
>  
> +	if (!ethtool_validate_master_slave_cfg(cmd->base.master_slave_cfg))
> +		return -EINVAL;
> +

Unless we can/want to pass extack down here, I would prefer to have the
sanity check in ethtool_update_linkmodes() or ethtool_set_linkmodes() so
that we can set meaningful error message and offending attribute in
extack. (It could be even part of the policy.) Also, with the check only
here, drivers/devices not calling phy_ethtool_set_link_ksettings()
(directly or via phy_ethtool_set_link_ksettings()) and not handling the
new members themselves would silently ignore any value from userspace.

>  	phydev->autoneg = autoneg;
>  
>  	phydev->speed = speed;
[...]
> +static int genphy_setup_master_slave(struct phy_device *phydev)
> +{
> +	u16 ctl = 0;
> +
> +	if (!phydev->is_gigabit_capable)
> +		return 0;

Shouldn't we rather return -EOPNOTSUPP if value different from
CFG_UNKNOWN was requested?

> +
> +	switch (phydev->master_slave_set) {
> +	case PORT_MODE_CFG_MASTER_PREFERRED:
> +		ctl |= CTL1000_PREFER_MASTER;
> +		break;
> +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> +		break;
> +	case PORT_MODE_CFG_MASTER_FORCE:
> +		ctl |= CTL1000_AS_MASTER;
> +		/* fallthrough */
> +	case PORT_MODE_CFG_SLAVE_FORCE:
> +		ctl |= CTL1000_ENABLE_MASTER;
> +		break;
> +	case PORT_MODE_CFG_UNKNOWN:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return 0;
> +	}
[...]
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 92f737f101178..eb680e3d6bda5 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  	return 0;
>  }
>  
> +/* Port mode */
> +#define PORT_MODE_CFG_UNKNOWN		0
> +#define PORT_MODE_CFG_MASTER_PREFERRED	1
> +#define PORT_MODE_CFG_SLAVE_PREFERRED	2
> +#define PORT_MODE_CFG_MASTER_FORCE	3
> +#define PORT_MODE_CFG_SLAVE_FORCE	4
> +#define PORT_MODE_STATE_UNKNOWN		0
> +#define PORT_MODE_STATE_MASTER		1
> +#define PORT_MODE_STATE_SLAVE		2
> +#define PORT_MODE_STATE_ERR		3

You have "MASTER_SLAVE" or "master_slave" everywhere but "PORT_MODE" in
these constants which is inconsistent.

> +
> +static inline int ethtool_validate_master_slave_cfg(__u8 cfg)
> +{
> +	switch (cfg) {
> +	case PORT_MODE_CFG_MASTER_PREFERRED:
> +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> +	case PORT_MODE_CFG_MASTER_FORCE:
> +	case PORT_MODE_CFG_SLAVE_FORCE:
> +	case PORT_MODE_CFG_UNKNOWN:
> +		return 1;
> +	}
> +
> +	return 0;
> +}

Should we really allow CFG_UNKNOWN in client requests? As far as I can
see, this value is handled as no-op which should be rather expressed by
absence of the attribute. Allowing the client to request a value,
keeping current one and returning 0 (success) is IMHO wrong.

Also, should this function be in UAPI header?

[...]
> @@ -119,7 +123,12 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
>  	}
>  
>  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> +		       lsettings->master_slave_cfg) ||
> +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> +		       lsettings->master_slave_state))
> +
>  		return -EMSGSIZE;

From the two handlers you introduced, it seems we only get CFG_UNKNOWN
or STATE_UNKNOWN if driver or device does not support the feature at all
so it would be IMHO more appropriate to omit the attribute in such case.

Michal

>  
>  	return 0;
