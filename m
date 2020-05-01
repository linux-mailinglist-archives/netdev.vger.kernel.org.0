Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708241C1A16
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbgEAPwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:52:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:54644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgEAPwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:52:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E432ACC3;
        Fri,  1 May 2020 15:52:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E2FD5602E9; Fri,  1 May 2020 17:52:10 +0200 (CEST)
Date:   Fri, 1 May 2020 17:52:10 +0200
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
Subject: Re: [PATCH net-next v4 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200501155210.GD8976@lion.mk-sys.cz>
References: <20200501074633.24421-1-o.rempel@pengutronix.de>
 <20200501074633.24421-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501074633.24421-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 09:46:32AM +0200, Oleksij Rempel wrote:
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
>  
> +#define MASTER_SLAVE_CFG_UNKNOWN		0
> +#define MASTER_SLAVE_CFG_MASTER_PREFERRED	1
> +#define MASTER_SLAVE_CFG_SLAVE_PREFERRED	2
> +#define MASTER_SLAVE_CFG_MASTER_FORCE		3
> +#define MASTER_SLAVE_CFG_SLAVE_FORCE		4
> +#define MASTER_SLAVE_CFG_UNSUPPORTED		5
> +#define MASTER_SLAVE_STATE_UNKNOWN		0
> +#define MASTER_SLAVE_STATE_MASTER		1
> +#define MASTER_SLAVE_STATE_SLAVE		2
> +#define MASTER_SLAVE_STATE_ERR			3
> +#define MASTER_SLAVE_STATE_UNSUPPORTED		4

Drivers not adapted to fill the new fields will leave 0 in them, we also
get 0 when new userspace is used with older kernel not supporting the
feature. It would be IMHO more convenient to use 0 for *_UNSUPPORTED
rather than for *_UNKNOWN.

[...]
> @@ -122,6 +131,20 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
>  	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
>  		return -EMSGSIZE;
>  
> +	if (lsettings->master_slave_cfg != MASTER_SLAVE_CFG_UNSUPPORTED) {
> +		ret = nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> +				 lsettings->master_slave_cfg);
> +		if (ret < 0)
> +			return -EMSGSIZE;
> +	}

Nitpick: this could be simplified as

	if (lsettings->master_slave_cfg != MASTER_SLAVE_CFG_UNSUPPORTED &&
	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
		       lsettings->master_slave_cfg))
			return -EMSGSIZE;

and possibly also combined with the previous nla_put_u8(). But it's
a matter of taste, I guess.

> +
> +	if (lsettings->master_slave_state != MASTER_SLAVE_STATE_UNSUPPORTED) {
> +		ret = nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> +				 lsettings->master_slave_state);
> +		if (ret < 0)
> +			return -EMSGSIZE;
> +	}
> +
>  	return 0;
>  }
>  
[...]
>  static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  				  struct ethtool_link_ksettings *ksettings,
>  				  bool *mod)
>  {
>  	struct ethtool_link_settings *lsettings = &ksettings->base;
>  	bool req_speed, req_duplex;
> +	const struct nlattr *attr;
>  	int ret;
>  
> +	attr = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
> +	if (attr) {

Introducing the variable makes little sense if this is the only place
where it is used. But if you decide to use it also in the two other
places working with the attribute, it should probably have more
descriptive name.

Michal

> +		u8 cfg = nla_get_u8(tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]);
> +		if (!ethnl_validate_master_slave_cfg(cfg))
> +			return -EOPNOTSUPP;
> +	}
> +
>  	*mod = false;
>  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
>  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
> @@ -311,6 +357,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  			 mod);
>  	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
>  			mod);
> +	ethnl_update_u8(&lsettings->master_slave_cfg,
> +			tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG], mod);
>  
>  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
>  	    (req_speed || req_duplex) &&
> -- 
> 2.26.2
> 
