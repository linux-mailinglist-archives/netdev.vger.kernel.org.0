Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7961D6BC6
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgEQShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:37:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgEQShT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 14:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Yd8ZhZiIqCXIzRFu64EbLTYC+uGshJdZ1LlSPDs33M=; b=lX0OesirDzW10jj0DGLSvQ2UFp
        SHUXQQrWM/82alGNX3HSlYwMN0zO7Qr2JGFTBB1dQG4n7xrVfs9VyHMTal6jqz7WgXQU/6fNI3vnB
        iIvi8EpH9YSZcEQZ/p/z2ZTspuLtmoZet7lQHad4U9xJ8DRNkGerK0vAwCcmRmVfc7yA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaO9u-002YLU-Gg; Sun, 17 May 2020 20:37:10 +0200
Date:   Sun, 17 May 2020 20:37:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link support
Message-ID: <20200517183710.GC606317@lunn.ch>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516192402.4201-1-rberg@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -946,6 +949,9 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>  {
>  	struct lan743x_adapter *adapter = netdev_priv(netdev);
>  	struct phy_device *phydev = netdev->phydev;
> +	struct device_node *phynode;
> +	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
> +	u32 data;
>  
>  	phy_print_status(phydev);
>  	if (phydev->state == PHY_RUNNING) {
> @@ -953,6 +959,48 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>  		int remote_advertisement = 0;
>  		int local_advertisement = 0;
>  
> +		/* check if a fixed-link is defined in device-tree */
> +		phynode = of_node_get(adapter->pdev->dev.of_node);
> +		if (phynode && of_phy_is_fixed_link(phynode)) {

Hi Roelof

The whole point for fixed link is that it looks like a PHY. You should
not need to care if it is a real PHY or a fixed link.


> +			/* Configure MAC to fixed link parameters */
> +			data = lan743x_csr_read(adapter, MAC_CR);
> +			/* Disable auto negotiation */
> +			data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);

Why does the MAC care about autoneg? In general, all the MAC needs to
know is the speed and duplex.

> +			/* Set duplex mode */
> +			if (phydev->duplex)
> +				data |= MAC_CR_DPX_;
> +			else
> +				data &= ~MAC_CR_DPX_;
> +			/* Set bus speed */
> +			switch (phydev->speed) {
> +			case 10:
> +				data &= ~MAC_CR_CFG_H_;
> +				data &= ~MAC_CR_CFG_L_;
> +				break;
> +			case 100:
> +				data &= ~MAC_CR_CFG_H_;
> +				data |= MAC_CR_CFG_L_;
> +				break;
> +			case 1000:
> +				data |= MAC_CR_CFG_H_;
> +				data |= MAC_CR_CFG_L_;
> +				break;
> +			}

The current code is unusual, in that it uses
phy_ethtool_get_link_ksettings(). That should do the right thing with
a fixed-link PHY, although i don't know if anybody uses it like
this. So in theory, the current code should take care of duplex, flow
control, and speed for you. Just watch out for bug/missing features in
fixed link.


> +			/* Set interface mode */
> +			of_get_phy_mode(phynode, &phyifc);
> +			if (phyifc == PHY_INTERFACE_MODE_RGMII ||
> +			    phyifc == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    phyifc == PHY_INTERFACE_MODE_RGMII_RXID ||
> +			    phyifc == PHY_INTERFACE_MODE_RGMII_TXID)
> +				/* RGMII */
> +				data &= ~MAC_CR_MII_EN_;
> +			else
> +				/* GMII */
> +				data |= MAC_CR_MII_EN_;
> +			lan743x_csr_write(adapter, MAC_CR, data);
> +		}
> +		of_node_put(phynode);

It is normal to do of_get_phy_mode when connecting to the PHY, and
store the value in the private structure. This is also not specific to
fixed link.

There is also a helper you can use phy_interface_mode_is_rgmii().

> +
>  		memset(&ksettings, 0, sizeof(ksettings));
>  		phy_ethtool_get_link_ksettings(netdev, &ksettings);
>  		local_advertisement =
> @@ -974,6 +1022,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
>  
>  	phy_stop(netdev->phydev);
>  	phy_disconnect(netdev->phydev);
> +	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
> +		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
>  	netdev->phydev = NULL;
>  }
>  
> @@ -982,18 +1032,44 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>  	struct lan743x_phy *phy = &adapter->phy;
>  	struct phy_device *phydev;
>  	struct net_device *netdev;
> +	struct device_node *phynode = NULL;
> +	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
>  	int ret = -EIO;

netdev uses reverse christmas tree, meaning the lines should be
sorted, longest first, getting shorter.

>  
>  	netdev = adapter->netdev;
> -	phydev = phy_find_first(adapter->mdiobus);
> -	if (!phydev)
> -		goto return_error;
>  
> -	ret = phy_connect_direct(netdev, phydev,
> -				 lan743x_phy_link_status_change,
> -				 PHY_INTERFACE_MODE_GMII);
> -	if (ret)
> -		goto return_error;
> +	/* check if a fixed-link is defined in device-tree */
> +	phynode = of_node_get(adapter->pdev->dev.of_node);
> +	if (phynode && of_phy_is_fixed_link(phynode)) {
> +		netdev_dbg(netdev, "fixed-link detected\n");

This is something which is useful during debug. But once it works can
be removed.

> +		ret = of_phy_register_fixed_link(phynode);
> +		if (ret) {
> +			netdev_err(netdev, "cannot register fixed PHY\n");
> +			goto return_error;
> +		}
> +
> +		of_get_phy_mode(phynode, &phyifc);
> +		phydev = of_phy_connect(netdev, phynode,
> +					lan743x_phy_link_status_change,
> +					0, phyifc);
> +		if (!phydev)
> +			goto return_error;
> +	} else {
> +		phydev = phy_find_first(adapter->mdiobus);
> +		if (!phydev)
> +			goto return_error;
> +
> +		ret = phy_connect_direct(netdev, phydev,
> +					 lan743x_phy_link_status_change,
> +					 PHY_INTERFACE_MODE_GMII);
> +		/* Note: We cannot use phyifc here because this would be SGMII
> +		 * on a standard PC.
> +		 */

I don't understand this comment.

