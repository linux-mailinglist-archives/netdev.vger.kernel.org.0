Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A814E398DCB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFBPFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:05:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhFBPFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WEjzdT1K9N/i7mrDHuJGeWQegSBmwOjCS27olR29tFk=; b=ISRzAwpaGAYYYqy4KR0GnG3irm
        ntifB42kf2MY+Gy3u5hucy2Ro2iU5gWNvNBNqLgKQrJVIWg8Ez9bMHWeIXEcYE2cqwvb5BWGFgof1
        7xD2gCV+l69WU7jTW3CUS58Epu+3CwIOUEKZo/W6TIoOUVkV9eUJMGvFohKco2t2aokk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loSPQ-007TeB-FA; Wed, 02 Jun 2021 17:03:52 +0200
Date:   Wed, 2 Jun 2021 17:03:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YLed2G1iDRTbA9eT@lunn.ch>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
 <YLbqv0Sy/3E2XaVU@lunn.ch>
 <20210602141557.GA29554@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602141557.GA29554@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I took a look at how most ethernet drivers implement their "bus->read"
> function. Most of them either return -EIO or -ENODEV.
> 
> I think it safe to drop the return error type when we try with C45 access:
> 
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1539ea021ac0..282d16fdf6e1 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -870,6 +870,18 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
>         if (r)
>                 return ERR_PTR(r);
> 
> +       /* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
> +        * of 0 when probed using get_phy_c22_id() with no error. Proceed to
> +        * probe with C45 to see if we're able to get a valid PHY ID in the C45
> +        * space, if successful, create the C45 PHY device.
> +        */
> +       if ((!is_c45) && (phy_id == 0)) {
> +               r = get_phy_c45_ids(bus, addr, &c45_ids);
> +               if (!r)
> +                       return phy_device_create(bus, addr, phy_id,
> +                                                true, &c45_ids);
> +       }

This is getting better. But look at for example
drivers/net/mdio/mdio-bcm-unimac.c. What will happen when you ask it
to do get_phy_c45_ids()?

   Andrew
