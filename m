Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E10300FAC
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbhAVWMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:12:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbhAVWJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:09:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l34b5-0029Gh-PB; Fri, 22 Jan 2021 23:08:03 +0100
Date:   Fri, 22 Jan 2021 23:08:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Message-ID: <YAtMw5Yk1QYp28rJ@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122214247.6536-1-sbauer@blackbox.su>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 12:42:41AM +0300, Sergej Bauer wrote:
> From: sbauer@blackbox.su
> 
> v1->v2:
> 	switch to using of fixed_phy as was suggested by Andrew and Florian
> 	also features-related parts are removed

This is not using fixed_phy, at least not in the normal way.

Take a look at bgmac_phy_connect_direct() for example. Call
fixed_phy_register(), and then phy_connect_direct() with the
phydev. End of story. Done.

> +int lan743x_set_link_ksettings(struct net_device *netdev,
> +			       const struct ethtool_link_ksettings *cmd)
> +{
> +	if (!netdev->phydev)
> +		return -ENETDOWN;
> +
> +	return phy_is_pseudo_fixed_link(netdev->phydev) ?
> +			lan743x_set_virtual_link_ksettings(netdev, cmd)
> +			: phy_ethtool_set_link_ksettings(netdev, cmd);
> +}

There should not be any need to do something different. The whole
point of fixed_phy is it looks like a PHY. So calling
phy_ethtool_set_link_ksettings() should work, nothing special needed.

> @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
>  	struct net_device *netdev = adapter->netdev;
>  
>  	phy_stop(netdev->phydev);
> -	phy_disconnect(netdev->phydev);
> -	netdev->phydev = NULL;
> +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> +		lan743x_virtual_phy_disconnect(netdev->phydev);
> +	else
> +		phy_disconnect(netdev->phydev);

phy_disconnect() should work. You might want to call
fixed_phy_unregister() afterwards, so you do not leak memory.

> +		if (phy_is_pseudo_fixed_link(phydev)) {
> +			ret = phy_connect_direct(netdev, phydev,
> +						 lan743x_virtual_phy_status_change,
> +						 PHY_INTERFACE_MODE_MII);
> +		} else {
> +			ret = phy_connect_direct(netdev, phydev,
> +						 lan743x_phy_link_status_change,

There should not be any need for a special link change
callback. lan743x_phy_link_status_change() should work fine, the MAC
should have no idea it is using a fixed_phy.

> +						 PHY_INTERFACE_MODE_GMII);
> +		}
> +
>  		if (ret)
>  			goto return_error;
>  	}
> @@ -1031,6 +1049,15 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>  	/* MAC doesn't support 1000T Half */
>  	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
>  
> +	if (phy_is_pseudo_fixed_link(phydev)) {
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_TP_BIT);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +				 phydev->supported);
> +		phy_advertise_supported(phydev);
> +	}

The fixed PHY driver will set these bits depending on the speed it has
been configured for. No need to change them. The MAC should also not
care if it is TP, AUI, Fibre or smoke signals.

     Andrew
