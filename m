Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637F33F42E3
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 03:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhHWBPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 21:15:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhHWBO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 21:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wbnAYhyJCCQuqsnRX8KSLXK76ZWOG7IY6CLRzf1Po2Q=; b=tiPUNZsMUQZ4OP0ZbMfGArMxe1
        gchNctkkyBaMZwvNDnNZZWxzQk39DUdfnuQ2IECyNi4kOJT2T2bTGXWimrgt55WcFpEJayDhnhDZV
        +sZ1Oz73FocHoMk0qJwIAhKbjtyqC300H15jxG0eX/MZZCC4sbTpInXyIW+duu6XNeio=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHyXN-003OwD-5x; Mon, 23 Aug 2021 03:14:05 +0200
Date:   Mon, 23 Aug 2021 03:14:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <YSL2XcUmb7PO5H0y@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <YSLX7qhyZ4YGec83@lunn.ch>
 <283675c4-90cf-6e5c-8178-5e3eba7592ba@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <283675c4-90cf-6e5c-8178-5e3eba7592ba@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just to clarify, this means I should set the physical port number in the 
> reg field of the device tree? i.e.:
> 
> 	port@4 {
> 		reg = <6>; /* <--- instead of <4>? */
> 		label = "cpu";
> 		ethernet = <&fec1>;
> 		phy-mode = "rgmii-id";
> 		fixed-link {
> 			speed = <1000>;
> 			full-duplex;
> 			pause;
> 		};
> 	};

Yes, this is fine.

> >> +static int rtl8365mb_port_enable(struct dsa_switch *ds, int port,
> >> +				 struct phy_device *phy)
> >> +{
> >> +	struct realtek_smi *smi = ds->priv;
> >> +	int val;
> >> +
> >> +	if (dsa_is_user_port(ds, port)) {
> >> +		/* Power up the internal PHY and restart autonegotiation */
> >> +		val = rtl8365mb_phy_read(smi, port, MII_BMCR);
> >> +		if (val < 0)
> >> +			return val;
> >> +
> >> +		val &= ~BMCR_PDOWN;
> >> +		val |= BMCR_ANRESTART;
> >> +
> >> +		return rtl8365mb_phy_write(smi, port, MII_BMCR, val);
> >> +	}
> > 
> > There should not be any need to do this. phylib should do it. In
> > generally, you should not need to touch any PHY registers, you just
> > need to allow access to the PHY registers.
> 
> Will phylib also the opposite when the interface is administratively put 
> down (e.g. ip link set dev swp2 down)? The switch doesn't seem to have 
> any other handle for stopping the flow of packets from a port except to 
> power down the internal PHY, hence why I put this in for port_disable. 
> For port_enable I just did the opposite but I can see why it's not 
> necessary.

When the MAC and PHY are attached phy_attach_direct() gets called,
which calls phy_resume(phydev); The generic implementation clears the
BMCR_PDOWN bit.

phy_detach() will suspend the PHY, which sets the BMCR_PDOWN bit.

But there are two different schemes for doing this.  Some MAC drivers
connect the PHY during probe. Others do it at open. DSA does it at
probe. So this is generic feature is not going to work for you. You
might want to put some printk() in phy_suspend and phy_resume to check
that.

So, setting/clearing the PDOWN bit does seems reasonable. But please
document in the functions why you are doing this. Also, don't restart
autoneg. That really should be up to phylib, and it should be
triggered by phylink_start() which should be called directly after
port_enable().

	Andrew
