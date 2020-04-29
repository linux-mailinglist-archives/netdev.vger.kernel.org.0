Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C000C1BE60E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgD2SQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:16:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60216 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2SQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=htNy/yZSV8dTTKaFzroif1bSJdhUGBMPffp1OI7OoVg=; b=vb+0Lti5y17+Y5ZcvB29hOcG29
        //qk7T77GMcVOPoie9JYtgjpm7Lvuq0gyycFfJx0p+HGeSpaeSb4x6Khm+1LMZjMy2i4nz3HvQ4hY
        8sPJmK0DeT1ltSal1sJStVMR0pkbGFm9uRSdJZ30pDchObPlWpy6ZVOHcEcTqnyV5uHs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTrFm-000IzQ-Jx; Wed, 29 Apr 2020 20:16:14 +0200
Date:   Wed, 29 Apr 2020 20:16:14 +0200
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
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200429181614.GL30459@lunn.ch>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428075308.2938-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 09:53:07AM +0200, Oleksij Rempel wrote:

Hi Oleksij

Sorry for taking a while to review this. I was busy fixing the FEC
driver which i broke :-(

> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -399,6 +399,8 @@ Kernel response contents:
>    ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
>    ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
>    ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
> +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``  u8      Master/slave port mode
> +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port mode
>    ====================================  ======  ==========================

I've not used Sphinx for a while. But it used to be, tables had to be
correctly aligned. I think you need to pad the other rows with spaces.

Also, the comments should differ. The first is how we want it
configured, the second is the current state.

>  
>  For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
> @@ -421,6 +423,7 @@ Request contents:
>    ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
>    ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
>    ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
> +  ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``  u8      Master/slave port mode
>    ====================================  ======  ==========================

Same table cleanup needed here.

> +static int genphy_read_master_slave(struct phy_device *phydev)
> +{
> +	int cfg, state = 0;
> +	u16 val;
> +
> +	phydev->master_slave_get = 0;
> +	phydev->master_slave_state = 0;

Could you use the _UNKNOWN #defined here?

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 92f737f101178..eb680e3d6bda5 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>  	return 0;
>  }
>  
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

Does this need to be an inline function? 

     Andrew
