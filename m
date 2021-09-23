Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E274415BD6
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 12:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbhIWKRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 06:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbhIWKRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 06:17:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88130C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 03:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=J5TbXMOMAMAu4PVfIS3LzrvRYhFVhhd4MZTyop/Z7rI=; b=y7sfDfak6PhHz4dezxJDkShBwe
        YW/cBTlpyVa21O9jotPM0xVsYslfR0RrxSjrRGGE+dnwAvup6aMsG0Hz1Vi6961aH+BkDpLHilGRh
        CHwBpcPkZWY1/qzfx3LpbL5pOITX2sFxavF+q8hisRS0AoknLhwPkd6Z1iN8ixZjgi4F3QxcliEse
        TKBDC+Zt1d2DejoXXLQ5wuvFYxq2DZUpyq11RSBFDxa/kz0kz1W0g7LQ5tyAkg785oVo4U60AydiF
        gGtksogEU84N7CM0rPuBkfCRIy7nCCmJh/OK0vu6sRXbEvPVhsankT3SBcbbJW+qoIDHpM45rZUMe
        QaT3uk6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54752)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mTLlH-0004qp-OA; Thu, 23 Sep 2021 11:15:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mTLlE-000596-Hq; Thu, 23 Sep 2021 11:15:24 +0100
Date:   Thu, 23 Sep 2021 11:15:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YUxTvC9QVI5bGLuF@shell.armlinux.org.uk>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
 <YUSp78o/vfZNFCJw@lunn.ch>
 <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
 <YUsa3z8KsuqS64k8@shell.armlinux.org.uk>
 <YUvCpjql8V4FGB2s@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUvCpjql8V4FGB2s@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 01:56:22AM +0200, Andrew Lunn wrote:
> On Wed, Sep 22, 2021 at 01:00:31PM +0100, Russell King (Oracle) wrote:
> > On Fri, Sep 17, 2021 at 03:58:01PM +0100, Russell King (Oracle) wrote:
> > > On Fri, Sep 17, 2021 at 04:45:03PM +0200, Andrew Lunn wrote:
> > > > > +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> > > > > +{
> > > > > +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> > > > > +	u16 val;
> > > > > +	int err;
> > > > > +
> > > > > +	if (!priv->has_downshift)
> > > > > +		return -EOPNOTSUPP;
> > > > > +
> > > > > +	if (ds == DOWNSHIFT_DEV_DISABLE)
> > > > > +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> > > > > +					  MV_PCS_DSC1_ENABLE);
> > > > > +
> > > > > +	/* FIXME: The default is disabled, so should we disable? */
> > > > > +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> > > > > +		ds = 2;
> > > > 
> > > > Hi Russell
> > > > 
> > > > Rather than a FIXME, maybe just document that the hardware default is
> > > > disabled, which does not make too much sense, so default to 2 attempts?
> > > 
> > > Sadly, the downshift parameters aren't documented at all in the kernel,
> > > and one has to dig into the ethtool source to find out what they mean:
> > > 
> > > DOWNSHIFT_DEV_DEFAULT_COUNT -
> > > 	ethtool --set-phy-tunable ethN downshift on
> > > DOWNSHIFT_DEV_DISABLE -
> > > 	ethtool --set-phy-tunable ethN downshift off
> > > otherwise:
> > > 	ethtool --set-phy-tunable ethN downshift count N
> > > 
> > > This really needs to be documented somewhere in the kernel.
> > 
> > I was hoping that this would cause further discussion on what the
> > exact meaning of "DOWNSHIFT_DEV_DEFAULT_COUNT" is. Clearly, it's
> > meant to turn downshift on, but what does "default" actually mean?
> 
> I guess this comes from the fact every other PHY has a bit to enable
> downshift, and a counter from saying how many attempts to make. And
> the counter has a documented default value.

Having looked at the data sheet again, the same is actually true here,
but the default settings are for a downshift of 2 but with the enable
bit in disabled mode.

Do other PHYs default to having the enabled bit set? It seems not, it
seems there's no difference here.

Marvell 88E151x documentation says that the downshift counter is set
to 3, which means it attempts 4 times (the value programmed into the
register is one less than the number of attempts, just like 88x3310.)
However, whenever the PHYs config_init() is called, the downshift is
force-set to 3 attempts, which sets the register value to 2. So it
seems that's a randomly picked value that's different from the
manufacturer default. I'm guessing the actual default depends on the
exact model of PHY - indeed, looking at 88E1111, the default appears
to be 7 attempts with a register value of 6.

Looking deeper, DOWNSHIFT_DEV_DEFAULT_COUNT is not handled at all.
This has a value of 255, and m88e1111_set_downshift() will error that
out:

        if (cnt > MII_M1111_PHY_EXT_CR_DOWNSHIFT_MAX)
                return -E2BIG;

where "MII_M1111_PHY_EXT_CR_DOWNSHIFT_MAX" is 8.

AR8035 on the other hand documents that "smartspeed" is enabled by
default, with a default of 5 attempts, which is exactly what the
driver implements.

The adin PHY driver is similar to the Marvell case.
adin_set_downshift() doesn't handle DOWNSHIFT_DEV_DEFAULT_COUNT,
erroring out if it is used. I don't have the datasheet to compare with,
but the code looks somewhat suspicious. It has a separate enable field
and a three bit counter. DOWNSHIFT_DEV_DISABLE is zero, and the logic
in the function means that the three-bit field can never be set to
zero. If programming a zero value were to disable downshift, there
would be no need for a separate ADIN1300_DOWNSPEEDS_EN bit.

aqr107_set_downshift(), dp83867_set_downshift() and
dp83869_set_downshift() are similarly buggy, rejecting
DOWNSHIFT_DEV_DEFAULT_COUNT.

bcm54140_set_downshift() looks like it is probably correct.

So, it seems most implementations are sadly buggy in one way or
another. Two implementations look like they're correct, one is probably
a compromise of various default values from the manufacturer, and four
reject DOWNSHIFT_DEV_DEFAULT_COUNT probably indicating that the feature
addition was never tested with "ethtool --set-phy-tunable ethN
downshift on".

So, some further questions: should we be calling the set_downshift
implementation from the .config_init as the Marvell driver does to
ensure that downshift is correctly enabled? Is .config_init really
the best place to do this? So many things with Marvell PHYs seem to
require a reset, which bounces the link. So if one brings up the
network interface, then sets EEE (you get a link bounce) and then
set downshift, you get another link bounce. Each link bounce takes
more than a second, which means the more features that need to be
configured after bringing the interface up, the longer it takes for
the network to become usable. Note that Marvell downshift will cause
the link to bounce even if the values programmed into the register
were already there - there is no check to see if we actually changed
anything before calling genphy_soft_reset() which seems suboptimal
given that we have phy_modify_changed() which can tell us that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
