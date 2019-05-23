Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672B928CB8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388303AbfEWVzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:55:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48060 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387709AbfEWVzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W/7rkUCUOcIU7dvxZuAXfjIH8qXo+SEKmbkRjxFIpoY=; b=KXZOOxufvuYKWp5gaz55X9n6i
        iy312kucMQV1I2U/YbnPk6W+h/4hsj/3OiEmQPTH9lE8g4eNNoOmXzRrPAeSJgR3kaiEXj3rjSuvZ
        npXpKvqlEKbdNgw/IPSOy9QAGg/midYCJ00mRrBRu7Yf2Ulp2jLBK0PrFdM6AFVAAb5K/XKFl/udO
        ikpfAgDoPKfS6tB1QAljuJ/twsj8NU6VlyGOePgX8o2uq1p2QuKsUnq2eU5W1CwMPIYKdmSqWQfXR
        6SW83onJJSX4wqVAUYdWZyH/4qL5lskH4CUC4bwwwvRpZdVu90P9Jh6dUkGDg6udy8jS/Q+07N/sj
        HydUCyRUg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38266)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hTvgM-0008LE-2s; Thu, 23 May 2019 22:55:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hTvgJ-0007uV-0m; Thu, 23 May 2019 22:55:23 +0100
Date:   Thu, 23 May 2019 22:55:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
Message-ID: <20190523215522.gnz6l342zhzpi2ld@shell.armlinux.org.uk>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523011958.14944-6-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:20:40AM +0000, Ioana Ciornei wrote:
> +	if (pl->ops) {
> +		pl->ops->mac_link_up(ndev, pl->link_an_mode,
>  			     pl->phy_state.interface,
>  			     pl->phydev);
>  
> +		netif_carrier_on(ndev);
>  
> +		netdev_info(ndev,
> +			    "Link is Up - %s/%s - flow control %s\n",
> +			    phy_speed_to_str(link_state.speed),
> +			    phy_duplex_to_str(link_state.duplex),
> +			    phylink_pause_to_str(link_state.pause));
> +	} else {
> +		blocking_notifier_call_chain(&pl->notifier_chain,
> +					     PHYLINK_MAC_LINK_UP, &info);
> +		phydev_info(pl->phydev,
> +			    "Link is Up - %s/%s - flow control %s\n",
> +			    phy_speed_to_str(link_state.speed),
> +			    phy_duplex_to_str(link_state.duplex),
> +			    phylink_pause_to_str(link_state.pause));
> +	}

So if we don't have pl->ops, what happens when we call phydev_info()
with a NULL phydev, which is a very real possibility: one of phylink's
whole points is to support dynamic presence of a PHY.

What will happen in that case is this will oops, due to dereferencing
an offset NULL pointer via:

#define phydev_info(_phydev, format, args...)	\
	dev_info(&_phydev->mdio.dev, format, ##args)

You can't just decide that if there's no netdev, we will be guaranteed
a phy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
