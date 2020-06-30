Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B2520EADD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgF3B0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:26:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgF3B0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:26:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jq52n-002v63-MU; Tue, 30 Jun 2020 03:26:41 +0200
Date:   Tue, 30 Jun 2020 03:26:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next 5/8] smsc95xx: use PAL framework read/write
 functions
Message-ID: <20200630012641.GF597495@lunn.ch>
References: <574a2386c1b9ed6c18ce0f20d7afbae0826faaae.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <574a2386c1b9ed6c18ce0f20d7afbae0826faaae.camel@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 01:12:37PM +0000, Andre.Edich@microchip.com wrote:
> Use functions phy_read and phy_write instead of smsc95xx_mdio_read and
> smsc95xx_mdio_write respectively.
> 
> Signed-off-by: Andre Edich <andre.edich@microchip.com>
> ---
>  drivers/net/usb/smsc95xx.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 3b8f7e439f44..11af5d5ece60 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -574,7 +574,7 @@ static int smsc95xx_link_reset(struct usbnet *dev)
>  	int ret;
>  
>  	/* clear interrupt status */
> -	ret = smsc95xx_mdio_read(dev->net, mii->phy_id, PHY_INT_SRC);
> +	ret = phy_read(pdata->phydev, PHY_INT_SRC);
>  	if (ret < 0)
>  		return ret;

The PHY driver should be clearing the interrupt status before it
enables interrupts.

>  
> @@ -584,8 +584,8 @@ static int smsc95xx_link_reset(struct usbnet *dev)
>  
>  	mii_check_media(mii, 1, 1);
>  	mii_ethtool_gset(&dev->mii, &ecmd);
> -	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id,
> MII_ADVERTISE);
> -	rmtadv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_LPA);
> +	lcladv = phy_read(pdata->phydev, MII_ADVERTISE);
> +	rmtadv = phy_read(pdata->phydev, MII_LPA);
>  
>  	netif_dbg(dev, link, dev->net,
>  		  "speed: %u duplex: %d lcladv: %04x rmtadv: %04x\n",

One of your previous patches added a link change handler which prints
the current speed, duplex, etc. I think you can remove this code.

> @@ -753,10 +753,11 @@ static int smsc95xx_ethtool_set_wol(struct
> net_device *net,
>  static int get_mdix_status(struct net_device *net)
>  {

The PHY driver should be providing this information, not the MAC.

When using phylib, the MAC driver should never need to directly access
the PHY. The PHY driver does all the work. The MAC driver might need
to call into phylib to request the work is done.

   Andrew
