Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00A741544D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbhIVX57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:57:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238631AbhIVX55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 19:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zqD1G9bG2/r+O+hBeEr/nyWacbzUh1+NrgW2dIOn62o=; b=1xakWK6plu+TLbKlULUR5cvP+f
        xyie3mAVuMLRtzsdyRy1BwzcS5/uE1o15ssAXDaPyKtI8e26nRfK/eeR25djg/eC2dcklDgmR7Xi+
        LwlolTuo9WVfJ+jdu+3Z6jkA/JFFr2oPHl0swSCIlgWfQzOZGclI8OyFel8KQuY01tnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mTC6A-007qe3-2X; Thu, 23 Sep 2021 01:56:22 +0200
Date:   Thu, 23 Sep 2021 01:56:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YUvCpjql8V4FGB2s@lunn.ch>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
 <YUSp78o/vfZNFCJw@lunn.ch>
 <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
 <YUsa3z8KsuqS64k8@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUsa3z8KsuqS64k8@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 01:00:31PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 17, 2021 at 03:58:01PM +0100, Russell King (Oracle) wrote:
> > On Fri, Sep 17, 2021 at 04:45:03PM +0200, Andrew Lunn wrote:
> > > > +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> > > > +{
> > > > +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > > > +	u16 val;
> > > > +	int err;
> > > > +
> > > > +	if (!priv->has_downshift)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	if (ds == DOWNSHIFT_DEV_DISABLE)
> > > > +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> > > > +					  MV_PCS_DSC1_ENABLE);
> > > > +
> > > > +	/* FIXME: The default is disabled, so should we disable? */
> > > > +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> > > > +		ds = 2;
> > > 
> > > Hi Russell
> > > 
> > > Rather than a FIXME, maybe just document that the hardware default is
> > > disabled, which does not make too much sense, so default to 2 attempts?
> > 
> > Sadly, the downshift parameters aren't documented at all in the kernel,
> > and one has to dig into the ethtool source to find out what they mean:
> > 
> > DOWNSHIFT_DEV_DEFAULT_COUNT -
> > 	ethtool --set-phy-tunable ethN downshift on
> > DOWNSHIFT_DEV_DISABLE -
> > 	ethtool --set-phy-tunable ethN downshift off
> > otherwise:
> > 	ethtool --set-phy-tunable ethN downshift count N
> > 
> > This really needs to be documented somewhere in the kernel.
> 
> I was hoping that this would cause further discussion on what the
> exact meaning of "DOWNSHIFT_DEV_DEFAULT_COUNT" is. Clearly, it's
> meant to turn downshift on, but what does "default" actually mean?

I guess this comes from the fact every other PHY has a bit to enable
downshift, and a counter from saying how many attempts to make. And
the counter has a documented default value.

> If we define "default" as "whatever the hardware defaults to" then
> for this phy, that would be turning off downshift.

Which does not make sense.

> So, should we rename "DOWNSHIFT_DEV_DEFAULT_COUNT" to be
> "DOWNSHIFT_DEV_ENABLE" rather than trying to imply that it's
> some kind of default that may need to be made up?

The value is made up anyway. Normally the silicon vendor picks a
value, and that is what you get after a reset. Does it make that much
difference if in this case if you pick the value, rather than Marvell?
None of this is standardised as far as i know, there is no correct
value.

	Andrew
