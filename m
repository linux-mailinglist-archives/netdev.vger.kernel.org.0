Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E951B1624
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgDTTpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:45:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgDTTpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rv5fi03wTd6W6vN2TS3pT6WMDcAKEMyIH48OvO2LMy0=; b=I4RsX0LrXIEiuQhc2kVNy/dsaA
        /z9ehA8NallHkp8hqXIcmBTU6Aoik457k600kOAA0bPKfTUO8tV0LLHw9SVPMmO0vlj52lNrJuPOU
        YLIz3p8/RulOfqdsOnqUIO3M5qvuK/atqDmZE3nXn75QTH5t0g5jFiUuqiA03NG5ojkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQcLo-003tJe-RC; Mon, 20 Apr 2020 21:45:04 +0200
Date:   Mon, 20 Apr 2020 21:45:04 +0200
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
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH v2 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200420194504.GF917792@lunn.ch>
References: <20200420131508.1539-1-o.rempel@pengutronix.de>
 <20200420131508.1539-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420131508.1539-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -294,7 +294,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  			 phydev->advertising, autoneg == AUTONEG_ENABLE);
>  
>  	phydev->duplex = duplex;
> -
> +	phydev->master_slave_set = cmd->base.master_slave;

Shouldn't you validate what has been passed from userspace it before
setting it?

>  	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>  
>  	/* Restart the PHY */
> @@ -313,6 +313,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
>  
>  	cmd->base.speed = phydev->speed;
>  	cmd->base.duplex = phydev->duplex;
> +	cmd->base.master_slave = phydev->master_slave_get;
>  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>  		cmd->base.port = PORT_BNC;
>  	else

You had me confused for a while. You are packing multiple things into
master_slave_get. Some bits are configuration, some are current
state. I don't like this. I think this is so you can shoe-horn this
into the existing IOCTL API? There are limited spare bytes?

Maybe we should not support this via the IOCTL, only the netlink
ethtool?

> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -185,6 +185,7 @@ enum {
>  	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
>  	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
>  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
> +	ETHTOOL_A_LINKMODES_MASTER_SLAVE,	/* u8 */

We would want two enums here, one for configuration, one for state.

> @@ -119,7 +121,9 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
>  	}
>  
>  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE,
> +		       lsettings->master_slave))

Here we return both configuration and current state.

>  		return -EMSGSIZE;
>  
>  	return 0;
> @@ -248,6 +252,7 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
>  	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
>  	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
> +	[ETHTOOL_A_LINKMODES_MASTER_SLAVE]	= { .type = NLA_U8 },
>  };
>  
>  /* Set advertised link modes to all supported modes matching requested speed
> @@ -310,6 +315,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  			 mod);
>  	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
>  			mod);
> +	ethnl_update_u8(&lsettings->master_slave,
> +			tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE], mod);

Here we expect just configuration.

There actually is space for two fields in the ethtool_link_settings,
so i don't see why you actually did not use two.

   Andrew
