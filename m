Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F93181EA7
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgCKRFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:05:51 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56844 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbgCKRFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lCyLyQbAx+/6/YozDA4HsqC4Rn9WmZtZmuBBn2Xgt+4=; b=Jt00twOM9TCGZA9oLYKD8dYpK
        N9uyYHrt+IWHokSbPRJ5scVxXIIYJbf+LDx+QvqjVOb+1G95X9hw3D/j11Sfva4AZz6Xarg2M3bHk
        TJ5rOSTw7l83rd02oZpRzDzGNf71vJWUUFVubyJjpT8isvOxi77e+hnkANdvmv1+sKvC9w59VAOq4
        ye7VOHB1z+KAMPYWhbPfyESoUoGxWllzGR3MZvHiSnYOhKsbB08/U0aXLUqe6DNTP072Cb1y7PnOR
        fYIOMeOKWC+pdKoTWEirc3/uXMHQyemsJsWXYYGcx8N7jhvNDyaCgxlsfzmUTowNcjbtU+CTzQSa9
        TVVSBH9SA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:51650)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC4nf-0004Sv-9y; Wed, 11 Mar 2020 17:05:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC4nd-0005TS-3W; Wed, 11 Mar 2020 17:05:41 +0000
Date:   Wed, 11 Mar 2020 17:05:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] add phylink support for PCS
Message-ID: <20200311170541.GP25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
 <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
 <20200311125445.GO25745@shell.armlinux.org.uk>
 <CA+h21hpk+TMofHFjg_Z-UZOPp+7zn29ZNLFP+JKreJtbZouiZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpk+TMofHFjg_Z-UZOPp+7zn29ZNLFP+JKreJtbZouiZQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:57:18PM +0200, Vladimir Oltean wrote:
> On Wed, 11 Mar 2020 at 14:54, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Mar 11, 2020 at 02:46:33PM +0200, Vladimir Oltean wrote:
> > > Hi Russell,
> > >
> > > On Wed, 11 Mar 2020 at 14:09, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > Hi,
> > > >
> > > > This series adds support for IEEE 802.3 register set compliant PCS
> > > > for phylink.  In order to do this, we:
> > > >
> > > > 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
> > > >    to a linkmode variant.
> > > > 2. add a helper for clause 37 advertisements, supporting both the
> > > >    1000baseX and defacto 2500baseX variants. Note that ethtool does
> > > >    not support half duplex for either of these, and we make no effort
> > > >    to do so.
> > > > 3. add accessors for modifying a MDIO device register, and use them in
> > > >    phylib, rather than duplicating the code from phylib.
> > >
> > > Have you considered accessing the PCS as a phy_device structure, a la
> > > drivers/net/dsa/ocelot/felix_vsc9959.c?
> >
> > I don't want to tie this into phylib, because I don't think phylib
> > should be dealing with PCS.  It brings with it many problems, such as:
> >
> 
> Agree that the struct mdio_device -> struct phy_device diff is pretty
> much useless to a PCS.
> 
> > 1. how do we know whether the Clause 22 registers are supposed to be
> >    Clause 37 format.
> 
> Well, they are, aren't they?

For a PCS, yes, but phylib generally deals with clause 22 format
registers (which define the copper capabilities rather than 1000baseX
which clause 37 covers.)

> 
> > 2. how do we program the PCS appropriately for the negotiation results
> >    (which phylib doesn't support).
> 
> You mean how to read the LPA and logically-AND it with ADV?
> The PCS doesn't need to be "programmed" according to the resolved link
> state. Maybe the MAC does.

No, I'm talking about configuring the PCS for SGMII mode when in-band
AN is not being used.

> > 3. how do we deal with selecting the appropriate device for the mode
> >    selected (LX2160A has multiple different PCS which depend on the
> >    mode selected.)
> 
> What I've been doing is to call get_phy_device with an is_c45 argument
> depending on the PHY interface type.
> Actually the real problem in your case is that the LX2160A doesn't
> expose a valid PHY ID in registers 2&3 (unlike other Layerscape PCS
> implementations), so get_phy_device is likely going to fail unless
> some sort of PHY ID fixup is not done.

What SolidRun are pressing NXP for on the LX2160A is to move the
networking support to a more dynamic arrangement than it is at
present - I know there was a conference call on Monday about this,
but I only found out about it too late to be part of it, and so far
no one has filled me in on what was discussed.

However, SolidRun wish the networking to be more dynamically
configurable on the LX2160A - right now, we have a problem that we
can either configure _all_ the QSFP+ and SFP ports (e.g.) to 10G
mode, or _all_ QSFP+ and SFP ports to 1G mode - which basically
makes the QSFP+ useless.  It's too inflexible.

What I would like to see are individual ports or groups of ports
being able to be reconfigured on the fly, which means sticking to
one particular PCS will not be possible.

Other platforms do support dynamically switching between different
components depending on the speed, and I see no reason to prevent
such flexibility in phylink by designing into it a "you can only
have one PCS device" assumption.

> > Note that a phy_device structure embeds a mdio_device structure, and
> > so these helpers can be used inside phylib if one desires - so this
> > approach is more flexible than "bolt it into phylib" approach would
> > be.
> >
> 
> It's hard to really say without seeing more than one caller of these
> new helpers.
> For example the sja1105 DSA switch has a PCS for SGMII (not supported
> yet in mainline) that kind-of-emulates a C22 register map, except that
> it's accessed over SPI, and that the "pcs_get_state" needs to look at
> some vendor-specific registers too.

I don't think "it's accessed over SPI" is much of an issue at all.
The solution to that is trivial - as has been already shown with
PHYs that are accessed over I2C.

> From that perspective, I was
> thinking that PHYLINK could be given a phy_device structure with the
> advertising, supported and lp_advertising linkmode bit fields
> populated who-knows-how, and PHYLINK just resolves that into its
> phylink_link_state structure.
> But then I guess that sort of hardware is not among your target
> candidates for the generic helpers. Whoever can't expose an MDIO bus
> or needs to access any vendor-specific register just shouldn't use
> these functions. And maybe you're right, I don't really know what the
> balance in practice will be.

I don't see why you'd think that having a phy_device structure would
make it easier to access a SPI based PHY.  If you can't access the
PHY over MDIO, none of the phylib helpers can be used, so you're
just using struct phy_device as a container and wrapping it with a
load of custom code.

As long as the phy_device structure is registered with the device
model, phy drivers can potentially bind with the "special" phy device
and attempt to access it via the MDIO bus - it sounds like that's
something you don't want to happen.

So, I'd question whether it makes any sense to (ab)use struct phy_device
for something that is not going to use phylib at all.

It seems way more sensible to have a "struct pcs_device" that operates
entirely separately to phylib - and maybe we can lift some of the phylib
functionality to mdio_device level (such as what I've done with
accessors, but maybe more stuff) so it can be spared between PCS and
conventional phylib users.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
