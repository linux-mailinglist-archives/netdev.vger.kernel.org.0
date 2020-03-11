Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4D1818D6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgCKMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:54:53 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53812 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbgCKMyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Xq/Lk9qjPnInPMwYlfmfZHgx+/L7h0xz5hcaz1tuQk=; b=jV456mBqrwlr/yp9oiVMbhw8e
        ugAbXfx9R7g5/qQjwQ12+0KRIJfFudG13IhNet5FnuKfSDWMbZAxZ8Vc44ZmeH09c9hDZV226Mlfy
        rEOPGhU660cdBJp6JwWBkvJRDyqoHFpSXDDt0Knn0JsowK0YumDGkqP/zR1I7v81BAY4ysi67Qb5d
        BBydOvcUJufXkSOUfFLNQOhjnyJoEWVRG6XWOQwyYh+Hd+OyeQZpnndBc4K2eI8goRz9YHZjDzzOU
        fkxR9lCentl5+1YQ4t7hFI2ZLT9kxeO5IINNN01DoAPbHmZTnxKBWanIy/sT9vlr0zy9fI7PqYcts
        sJhhboMbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35002)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC0so-0003LZ-9U; Wed, 11 Mar 2020 12:54:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC0sn-0005Kj-5Y; Wed, 11 Mar 2020 12:54:45 +0000
Date:   Wed, 11 Mar 2020 12:54:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] add phylink support for PCS
Message-ID: <20200311125445.GO25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
 <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 02:46:33PM +0200, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Wed, 11 Mar 2020 at 14:09, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > Hi,
> >
> > This series adds support for IEEE 802.3 register set compliant PCS
> > for phylink.  In order to do this, we:
> >
> > 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
> >    to a linkmode variant.
> > 2. add a helper for clause 37 advertisements, supporting both the
> >    1000baseX and defacto 2500baseX variants. Note that ethtool does
> >    not support half duplex for either of these, and we make no effort
> >    to do so.
> > 3. add accessors for modifying a MDIO device register, and use them in
> >    phylib, rather than duplicating the code from phylib.
> 
> Have you considered accessing the PCS as a phy_device structure, a la
> drivers/net/dsa/ocelot/felix_vsc9959.c?

I don't want to tie this into phylib, because I don't think phylib
should be dealing with PCS.  It brings with it many problems, such as:

1. how do we know whether the Clause 22 registers are supposed to be
   Clause 37 format.
2. how do we program the PCS appropriately for the negotiation results
   (which phylib doesn't support).
3. how do we deal with selecting the appropriate device for the mode
   selected (LX2160A has multiple different PCS which depend on the
   mode selected.)

Note that a phy_device structure embeds a mdio_device structure, and
so these helpers can be used inside phylib if one desires - so this
approach is more flexible than "bolt it into phylib" approach would
be.

> > 4. add support for decoding the advertisement from clause 22 compatible
> >    register sets for clause 37 advertisements and SGMII advertisements.
> > 5. add support for clause 45 register sets for 10GBASE-R PCS.
> >
> > These have been tested on the LX2160A Clearfog-CX platform.
> >
> >  drivers/net/phy/mdio_bus.c |  55 +++++++++++
> >  drivers/net/phy/phy-core.c |  31 ------
> >  drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mdio.h       |   4 +
> >  include/linux/mii.h        |  57 +++++++----
> >  include/linux/phy.h        |  19 ++++
> >  include/linux/phylink.h    |   8 ++
> >  include/uapi/linux/mii.h   |   5 +
> >  8 files changed, 366 insertions(+), 49 deletions(-)
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
