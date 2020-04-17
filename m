Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33871AE636
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgDQTuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:50:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbgDQTuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JrUP6g15FT5/8Geryp+mtn/Ve17rMbm00zVmqYtjaok=; b=PRngC387MEWoGSmi/62fiMKc/W
        s8qIp27u7t3SvWGg5kauH/BoHlTCv8envCE93lnCzRi2rzafZ644ts1IJOx3Hn9Y0eG39Aju8hrrO
        UQiF2/BrBdnjgpImxCrri7PFpvdEuBldJA6xXzvE5N2KwF5l79a7Hj/+PV5ZUQfdQ3HI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPWzz-003LJP-7i; Fri, 17 Apr 2020 21:50:03 +0200
Date:   Fri, 17 Apr 2020 21:50:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200417195003.GG785713@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417192858.6997-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Check if one PHY has already done the init of the parts common to all PHYs
> + * in the Quad PHY package.
> + */
> +static bool bcm54140_is_pkg_init(struct phy_device *phydev)
> +{
> +	struct mdio_device **map = phydev->mdio.bus->mdio_map;
> +	struct bcm54140_phy_priv *priv;
> +	struct phy_device *phy;
> +	int i, addr;
> +
> +	/* Quad PHY */
> +	for (i = 0; i < 4; i++) {
> +		priv = phydev->priv;
> +		addr = priv->base_addr + i;
> +
> +		if (!map[addr])
> +			continue;
> +
> +		phy = container_of(map[addr], struct phy_device, mdio);

I don't particularly like a PHY driver having knowledge of the mdio
bus core. Please add a helper in the core to get you the phydev for a
particular address.

There is also the question of locking. What happens if the PHY devices
is unbound while you have an instance of its phydev? What happens if
the base PHY is unbound? Are the three others then unusable?

I think we need to take a step back and look at how we handle quad
PHYs in general. The VSC8584 has many of the same issues.

    Andrew
