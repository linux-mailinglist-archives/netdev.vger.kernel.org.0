Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABEA4420E0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 20:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhKATgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 15:36:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhKATgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 15:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8x/WQ9gVs8Xb1wXlf+BUiBeF7va4QTCMKiyuXcRdSQI=; b=44Veb7J9Vn7x0tAwe5nqK3s0HM
        nr9tWRakPFkXJxDEzEd/mYy41LSNOW/zPk9ztkmxd5uAb0JvX8j5fF6OQl8p5fskKeJTAqMPL08On
        kcIOtq2x4Nwv0v/fRFNxUqaFCrpBKQtgI+TVhfTcAmj1hRolo9lYyLsaIBa0x2VXreSo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhd42-00CKZd-Ps; Mon, 01 Nov 2021 20:33:50 +0100
Date:   Mon, 1 Nov 2021 20:33:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYBBHsFEwGdPJw3b@lunn.ch>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101182859.24073-1-grygorii.strashko@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 08:28:59PM +0200, Grygorii Strashko wrote:
> This patch enables access to C22 PHY MMD address space through

I'm not sure the terminology is correct here. I think it actually
enables access to C45 address space, making use of C45 over C22.

> phy_mii_ioctl() SIOCGMIIREG/SIOCSMIIREG IOCTLs. It checks if R/W request is
> received with C45 flag enabled while MDIO bus doesn't support C45 and, in
> this case, tries to treat prtad as PHY MMD selector and use MMD API.
> 
> With this change it's possible to r/w PHY MMD registers with phytool, for
> example, before:
> 
>   phytool read eth0/0x1f:0/0x32
>   0xffea
> 
> after:
>   phytool read eth0/0x1f:0/0x32
>   0x00d1
> @@ -300,8 +300,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>  			prtad = mii_data->phy_id;
>  			devad = mii_data->reg_num;
>  		}
> -		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
> -						 devad);
> +		if (mdio_phy_id_is_c45(mii_data->phy_id) &&
> +		    phydev->mdio.bus->probe_capabilities <= MDIOBUS_C22) {
> +			phy_lock_mdio_bus(phydev);
> +
> +			mii_data->val_out = __mmd_phy_read(phydev->mdio.bus,
> +							   mdio_phy_id_devad(mii_data->phy_id),
> +							   prtad,
> +							   mii_data->reg_num);
> +
> +			phy_unlock_mdio_bus(phydev);
> +		} else {
> +			mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
> +		}

The layering look wrong here. You are trying to perform MDIO bus
operation here, so it seems odd to perform __mmd_phy_read(). I wonder
if it would be cleaner to move C45 over C22 down into the mdiobus_
level API?

      Andrew
