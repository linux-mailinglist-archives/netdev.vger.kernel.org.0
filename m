Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31D61C354C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 11:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgEDJKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 05:10:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:38692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEDJKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 05:10:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D8EDFAC7D;
        Mon,  4 May 2020 09:10:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 43276604EE; Mon,  4 May 2020 11:10:44 +0200 (CEST)
Date:   Mon, 4 May 2020 11:10:44 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200504091044.GA8237@lion.mk-sys.cz>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504071214.5890-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 09:12:13AM +0200, Oleksij Rempel wrote:
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
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ac2784192472f..42dda9d2082ee 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1768,6 +1768,90 @@ int genphy_setup_forced(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_setup_forced);
>  
> +static int genphy_setup_master_slave(struct phy_device *phydev)
> +{
> +	u16 ctl = 0;
> +
> +	if (!phydev->is_gigabit_capable)
> +		return 0;

Why did you revert to silently ignoring requests in this case? On the
other hand, we might rather want to do a more generic check which would
handle all drivers not supporting the feature, see below.

[...]
> @@ -287,14 +308,37 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
>  			     __ETHTOOL_LINK_MODE_MASK_NBITS);
>  }
>  
> +static int ethnl_validate_master_slave_cfg(u8 cfg)
> +{
> +	switch (cfg) {
> +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> +		return 1;
> +	}
> +
> +	return 0;
> +}

Nitpick: bool would be more appropriate as return value.

> +
>  static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  				  struct ethtool_link_ksettings *ksettings,
>  				  bool *mod)
>  {
>  	struct ethtool_link_settings *lsettings = &ksettings->base;
>  	bool req_speed, req_duplex;
> +	const struct nlattr *master_slave_cfg;
>  	int ret;
>  
> +	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
> +	if (master_slave_cfg) {
> +		u8 cfg = nla_get_u8(master_slave_cfg);
> +		if (!ethnl_validate_master_slave_cfg(cfg)) {
> +			GENL_SET_ERR_MSG(info, "LINKMODES_MASTER_SLAVE_CFG contains not valid value");
> +			return -EOPNOTSUPP;
> +		}
> +	}

Please set also the "bad attribute" in extack, it may help
non-interactive clients.

Also, it would be nice to report error if client wants to set master/slave but
driver does not support it. How about this?

	if (master_slave_cfg) {
		u8 cfg = nla_get_u8(master_slave_cfg);

		if (lsettings->master_slave_cfg == MASTER_SLAVE_CFG_UNSUPPORTED) {
			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
					    "master/slave configuration not supported by device");
			return -EOPNOTSUPP;
		}
		if (!ethnl_validate_master_slave_cfg(cfg)) {
			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
					    "master/slave value is invalid");
			return -EOPNOTSUPP;
		}
	}


Do you plan to allow handling master/slave also via ioctl()? If yes, we should
also add the sanity checks to ioctl code path. If not, we should prevent
passing non-zero values from userspace to driver.

Other than this, the patch looks good to me.

Michal

>  	*mod = false;
>  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
>  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
> @@ -311,6 +355,7 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  			 mod);
>  	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
>  			mod);
> +	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
>  
>  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
>  	    (req_speed || req_duplex) &&
> -- 
> 2.26.2
> 
