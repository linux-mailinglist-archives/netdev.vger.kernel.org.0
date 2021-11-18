Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D60455D1C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhKROA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhKROA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:00:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA76C61A8A;
        Thu, 18 Nov 2021 13:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637243849;
        bh=MKJOxiXLN78PZfs0x0zwYjIATISUo5JsSyqaA0k94So=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rt5VflZjZbgfXuvqOWfV9VEP8WKU5okc0aw2wRmKp3vX6Bp6eDdxKf2m+rG/uozzO
         arMzypv/DwE/t1DMInXUNZF27mrUXcTT0Jtne8YIe+D2dZtAQB7/61uAtz8dbCMLmP
         UXn1840S7EEg7NUiGqlLMblOqvlYRJjGaxR82GOG9Q5gNpYEbGCabjSFIK1Cbn+V+W
         fb7sYhXk/4fxIyAgPrZKnxtpw4GtHUH7uvOUfeH0S1CFI7vluuw7ZTd6l1BI//OoyH
         gGFFCFt9tafaZk1ukkBtxkcieLxbcqzzpjOF5meOS7KTGqyIJ1NtnXXsAmOGKhWfLc
         mwg3RGH0RriCQ==
Date:   Thu, 18 Nov 2021 14:56:58 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host
 interface configuration
Message-ID: <20211118145658.2a8b0498@thinkpad>
In-Reply-To: <20211118120334.jjujutp5cnjgwjq2@skbuf>
References: <20211117225050.18395-1-kabel@kernel.org>
        <20211117225050.18395-9-kabel@kernel.org>
        <20211118120334.jjujutp5cnjgwjq2@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 14:03:34 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> Hello,
> 
> > +static int mv3310_select_mactype(unsigned long *interfaces)
> > +{
> > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > +	else
> > +		return -1;
> > +}
> > +  
> 
> I would like to understand this heuristic better. Both its purpose and
> its implementation.
> 
> It says:
> (a) If the intersection between interface modes supported by the MAC and
>     the PHY contains USXGMII, then use USXGMII as a MACTYPE
> (b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
>     use 10GBaseR as MACTYPE
> (...)
> (c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
>     use 10GBaseR with rate matching as MACTYPE
> (...)
> (d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
>     use 10GBaseR as MACTYPE (no rate matching).
> 
> First of all, what is MACTYPE exactly? And what is the purpose of
> changing it? What would happen if this configuration remained fixed, as
> it were?
> 
> I see there is no MACTYPE definition for SGMII. Why is that? How does
> the PHY choose to use SGMII?
> 
> Why is item (d) correct - use 10GBaseR as MACTYPE if the intersection
> only supports SGMII?
> 
> A breakdown per link speed might be helpful in understanding the
> configurations being performed here.

Russell already explained this. I will put a better explanation into
the commit message in v2.

> >  static int mv2110_init_interface(struct phy_device *phydev, int mactype)
> >  {
> >  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > @@ -674,10 +764,16 @@ static int mv3310_config_init(struct phy_device *phydev)
> >  {
> >  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> >  	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
> > +	DECLARE_PHY_INTERFACE_MASK(interfaces);
> >  	int err, mactype;
> >  
> > -	/* Check that the PHY interface type is compatible */
> > -	if (!test_bit(phydev->interface, priv->supported_interfaces))
> > +	/* In case host didn't provide supported interfaces */
> > +	__set_bit(phydev->interface, phydev->host_interfaces);  
> 
> Shouldn't phylib populate phydev->host_interfaces with
> phydev->interface, rather than requiring PHY drivers to do it?

I will look into this.

Marek
