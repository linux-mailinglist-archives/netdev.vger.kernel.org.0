Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A862F1AFC2F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgDSQuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:50:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgDSQuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 12:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iLAOKXvu+P1RpppWXR9M05UcEWZPbpw6tXNqCN4/N04=; b=AYTfGWLB3TVTMutJPh8x2r1/zK
        Tz1RrO27h+few0z0ptmLJ7SdDsScsB5MG5+tIeVvOz6+nyeutxhMb2m7aDcYjsMtUGntwkj0ySyq1
        bnq4SwasyR1sJ4xcDgJGDjckMqNcWRxVdvruJk5DmGaaVI12+mHLhAoPqDBSRknGWGnI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQD8o-003ezm-62; Sun, 19 Apr 2020 18:49:58 +0200
Date:   Sun, 19 Apr 2020 18:49:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 2/3] net: phy: add Broadcom BCM54140 support
Message-ID: <20200419164958.GN836632@lunn.ch>
References: <20200419101249.28991-1-michael@walle.cc>
 <20200419101249.28991-2-michael@walle.cc>
 <20200419154943.GJ836632@lunn.ch>
 <d40eafc5ed95b62886e10159dcb7a509@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d40eafc5ed95b62886e10159dcb7a509@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 06:33:40PM +0200, Michael Walle wrote:
> > > +static int bcm54140_phy_probe(struct phy_device *phydev)
> > > +{
> > > +	struct bcm54140_phy_priv *priv;
> > > +	int ret;
> > > +
> > > +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> > > +	if (!priv)
> > > +		return -ENOMEM;
> > > +
> > > +	phydev->priv = priv;
> > > +
> > > +	ret = bcm54140_get_base_addr_and_port(phydev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	dev_info(&phydev->mdio.dev,
> > > +		 "probed (port %d, base PHY address %d)\n",
> > > +		 priv->port, priv->base_addr);
> > 
> > phydev_dbg() ? Do we need to see this message four times?
> 
> ok. every phy will have a different port. And keep in mind,
> that you might have less than four ports/PHYs here. So I'd
> like to keep that as a phydev_dbg() if you agree.

phydev_dbg() is fine.


> 
> > 
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int bcm54140_config_init(struct phy_device *phydev)
> > > +{
> > > +	u16 reg = 0xffff;
> > > +	int ret;
> > > +
> > > +	/* Apply hardware errata */
> > > +	ret = bcm54140_b0_workaround(phydev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* Unmask events we are interested in. */
> > > +	reg &= ~(BCM54140_RDB_INT_DUPLEX |
> > > +		 BCM54140_RDB_INT_SPEED |
> > > +		 BCM54140_RDB_INT_LINK);
> > > +	ret = bcm_phy_write_rdb(phydev, BCM54140_RDB_IMR, reg);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* LED1=LINKSPD[1], LED2=LINKSPD[2], LED3=ACTIVITY */
> > > +	ret = bcm_phy_modify_rdb(phydev, BCM54140_RDB_SPARE1,
> > > +				 0, BCM54140_RDB_SPARE1_LSLM);
> > > +	if (ret)
> > > +		return ret;
> > 
> > What are the reset default for LEDs? Can the LEDs be configured via
> > strapping pins? There is currently no good solution for this. Whatever
> > you pick will be wrong for somebody else. At minimum, strapping pins,
> > if they exist, should not be overridden.
> 
> Fair enough. There are no strapping options, just the "default behaviour",
> where LED1/2 indicates the speed, and LED3 just activity (no link
> indication). And I just noticed that in this case the comment above is
> wrong, because it is actually link/activity. Further, there are myriad
> configuration options which I didn't want to encode altogether. So I've
> just chosen the typical one (which actually matches our hardware), ie.
> to have the "activity/led mode". The application note mentions some other
> concrete modes, but I don't know if its worth implementing them. Maybe we
> can have a enumeration of some distinct modes? Ie.
> 
>    broadcom,led-mode = <BCM54140_NO_CHANGE>;
>    broadcom,led-mode = <BCM54140_ACT_LINK_MODE>;

Configuring LEDs is a mess at the moment. No two PHYs do it the
same. For a long time i've had a TODO item to make PHY LEDs work just
like every other LED in linux, and you can set trigger actions which
are then implemented in hardware.

We have been pushing back on adding DT properties, it just makes the
problem worse. If reset defaults are good enough for you, please leave
it at that.

Thanks
   Andrew
