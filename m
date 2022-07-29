Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095A5585039
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbiG2NAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiG2NAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:00:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E6E74;
        Fri, 29 Jul 2022 06:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XdavFnr3NTOj35v811lVkK4EGAq0Y5wwPjr+y4ndjCw=; b=CE5z5DIMlo9rn/DMcpohrXqlYG
        6QfY03YNNAJsM0kpVtPhwFXZ/rmRPGaz2vwq4blCLgMfpDKamSZ6uanPwiKrhdbm/hIVy8VsmNhCT
        DaqgCFtwq4AbHj5XeTE6snAEBIdiN3jbUmwze3HoQJ/ht+mTK8/mqLhs104ihMWNmgrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHPb3-00BuuW-Tw; Fri, 29 Jul 2022 15:00:05 +0200
Date:   Fri, 29 Jul 2022 15:00:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/4] net: phy: Add helper to derive the number
 of ports from a phy mode
Message-ID: <YuPZ1YOJl5Xof5ae@lunn.ch>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
 <20220728145252.439201-4-maxime.chevallier@bootlin.com>
 <YuMAdACnRKsL8/xD@lunn.ch>
 <20220729093252.50977d5c@pc-10.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729093252.50977d5c@pc-10.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 09:32:52AM +0200, Maxime Chevallier wrote:
> On Thu, 28 Jul 2022 23:32:36 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +int phy_interface_num_ports(phy_interface_t interface)
> > > +{
> > > +	switch (interface) {
> > > +	case PHY_INTERFACE_MODE_NA:
> > > +	case PHY_INTERFACE_MODE_INTERNAL:
> > > +		return 0;  
> > 
> > I've not yet looked at how this is used. Returning 0 could have
> > interesting effects i guess? INTERNAL clearly does have some sort of
> > path between the MAC and the PHY, so i think 1 would be a better
> > value. NA is less clear, it generally means Don't touch. But again,
> > there still needs to be a path between the MAC and PHY, otherwise
> > there would not be any to touch.
> > 
> > Why did you pick 0?
> > 
> > > +
> > > +	case PHY_INTERFACE_MODE_MII:
> > > +	case PHY_INTERFACE_MODE_GMII:
> > > +	case PHY_INTERFACE_MODE_TBI:
> > > +	case PHY_INTERFACE_MODE_REVMII:
> > > +	case PHY_INTERFACE_MODE_RMII:
> > > +	case PHY_INTERFACE_MODE_REVRMII:
> > > +	case PHY_INTERFACE_MODE_RGMII:
> > > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > > +	case PHY_INTERFACE_MODE_RTBI:
> > > +	case PHY_INTERFACE_MODE_XGMII:
> > > +	case PHY_INTERFACE_MODE_XLGMII:
> > > +	case PHY_INTERFACE_MODE_MOCA:
> > > +	case PHY_INTERFACE_MODE_TRGMII:
> > > +	case PHY_INTERFACE_MODE_USXGMII:
> > > +	case PHY_INTERFACE_MODE_SGMII:
> > > +	case PHY_INTERFACE_MODE_SMII:
> > > +	case PHY_INTERFACE_MODE_1000BASEX:
> > > +	case PHY_INTERFACE_MODE_2500BASEX:
> > > +	case PHY_INTERFACE_MODE_5GBASER:
> > > +	case PHY_INTERFACE_MODE_10GBASER:
> > > +	case PHY_INTERFACE_MODE_25GBASER:
> > > +	case PHY_INTERFACE_MODE_10GKR:
> > > +	case PHY_INTERFACE_MODE_100BASEX:
> > > +	case PHY_INTERFACE_MODE_RXAUI:
> > > +	case PHY_INTERFACE_MODE_XAUI:
> > > +		return 1;
> > > +	case PHY_INTERFACE_MODE_QSGMII:
> > > +	case PHY_INTERFACE_MODE_QUSGMII:
> > > +		return 4;
> > > +
> > > +	default:
> > > +		return 0;
> > > +	}
> > > +}  
> > 
> > Have you tried without a default: ? I _think_ gcc will then warn about
> > missing enum values, which will help future developers when they add
> > further values to the enum.
> 
> Without the default clause, I get an error about the missing
> PHY_INTERFACE_MODE_MAX case, which I don't think belongs here...

  case PHY_INTERFACE_MODE_MAX:
	WARN_ONCE()
	return 0;
	break;

Being passed PHY_INTERFACE_MODE_MAX is a bug in itself, so warning
seems sensible.

      Andrew
