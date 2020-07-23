Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B7222B9C6
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGWWj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:39:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgGWWj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 18:39:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyjsa-006alr-VJ; Fri, 24 Jul 2020 00:39:56 +0200
Date:   Fri, 24 Jul 2020 00:39:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v2 3/6] smsc95xx: add PAL support to use
 external PHY drivers
Message-ID: <20200723223956.GL1553578@lunn.ch>
References: <20200723115507.26194-1-andre.edich@microchip.com>
 <20200723115507.26194-4-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723115507.26194-4-andre.edich@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 01:55:04PM +0200, Andre Edich wrote:
> Generally, each PHY has their own configuration and it can be done
> through an external PHY driver.  The smsc95xx driver uses only the
> hard-coded internal PHY configuration.
> 
> This patch adds PAL (PHY Abstraction Layer) support to probe external
> PHY drivers for configuring external PHYs.

Hi Andre

We call it phylib, not PAL.

>  static int __must_check smsc95xx_wait_eeprom(struct usbnet *dev)
>  {
>  	unsigned long start_time = jiffies;
> @@ -559,15 +580,20 @@ static int smsc95xx_link_reset(struct usbnet *dev)
>  	u16 lcladv, rmtadv;
>  	int ret;
>  
> -	/* clear interrupt status */
> -	ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
> -	if (ret < 0)
> -		return ret;
> -
>  	ret = smsc95xx_write_reg(dev, INT_STS, INT_STS_CLEAR_ALL_);
>  	if (ret < 0)
>  		return ret;
>  
> +	if (pdata->internal_phy) {
> +		/* clear interrupt status */
> +		ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
> +		if (ret < 0)
> +			return ret;
> +
> +		smsc95xx_mdio_write(dev->net, mii->phy_id, PHY_INT_MASK,
> +				    PHY_INT_MASK_DEFAULT_);
> +	}

The PHY driver should do this, not the MAC driver.

Which PHY driver is used for the internal PHY? In theory, you should
not need to know if it is internal or external, it is just a PHY. That
might mean you need to move some code from this driver into the PHY
driver, if it is currently missing in the PHY driver.

> +
>  	mii_check_media(mii, 1, 1);
>  	mii_ethtool_gset(&dev->mii, &ecmd);
>  	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
> @@ -851,10 +877,10 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
>  	int retval;
>  
>  	retval = usbnet_get_link_ksettings(net, cmd);
> -
> -	cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
> -	cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
> -
> +	if (pdata->internal_phy) {
> +		cmd->base.eth_tp_mdix = pdata->mdix_ctrl;
> +		cmd->base.eth_tp_mdix_ctrl = pdata->mdix_ctrl;
> +	}

Again, they PHY driver should take care of this. You need to set
phydev->mdix_ctrl before starting the PHY. The PHY driver should set
phdev->mdix to the current status. 

> +static void smsc95xx_handle_link_change(struct net_device *net)
> +{
> +	phy_print_status(net->phydev);

So the MAC does not care about the speed? The pause configuration?
Duplex?

	Andrew
