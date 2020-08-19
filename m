Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85642249295
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHSB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:58:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSB6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 21:58:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8DMy-00A1Dq-O5; Wed, 19 Aug 2020 03:58:28 +0200
Date:   Wed, 19 Aug 2020 03:58:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v3 3/3] smsc95xx: add phylib support
Message-ID: <20200819015828.GB2347062@lunn.ch>
References: <20200818111127.176422-1-andre.edich@microchip.com>
 <20200818111127.176422-4-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818111127.176422-4-andre.edich@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -553,32 +554,21 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
>  static int smsc95xx_link_reset(struct usbnet *dev)
>  {
>  	struct smsc95xx_priv *pdata = dev->driver_priv;
> -	struct mii_if_info *mii = &dev->mii;
> -	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
> +	struct ethtool_link_ksettings cmd;
>  	unsigned long flags;
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
> -	mii_check_media(mii, 1, 1);
> -	mii_ethtool_gset(&dev->mii, &ecmd);
> -	lcladv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
> -	rmtadv = smsc95xx_mdio_read(dev->net, mii->phy_id, MII_LPA);
> -
> -	netif_dbg(dev, link, dev->net,
> -		  "speed: %u duplex: %d lcladv: %04x rmtadv: %04x\n",
> -		  ethtool_cmd_speed(&ecmd), ecmd.duplex, lcladv, rmtadv);
> +	phy_ethtool_ksettings_get(pdata->phydev, &cmd);
> +	lcladv = phy_read(pdata->phydev, MII_ADVERTISE);
> +	rmtadv = phy_read(pdata->phydev, MII_LPA);

The MAC driver should not be making phy_read() calls. Please look at
how other driver handle flow control.

    Andrew
