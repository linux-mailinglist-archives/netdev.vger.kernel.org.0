Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13F1E17EA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgEYWl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYWl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:41:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030EFC061A0E;
        Mon, 25 May 2020 15:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I1jsfxQxg8/0M8jxBoZOf8MeHDidrG9cd+KR/1LiYCE=; b=eM2jHiGkN5ZuTNjWg/5E6Ol/d
        Kb4twahmdSvxv+d5YKtJYE3AsebccbeHrF2fLqXP8yQwFIVjlJgPPSRB8doMKiKoP5HWW/hKjmreb
        8YAQubVU/ftfMuRN9yOBwqFusjByhhIZ3tc/xYF2APiSesM0yfHjzzcIXIzO4y0kzkRDVCAoTgnkY
        ZISQ1ppDKzanXOC4fbDYc7n558VAqW+R8bV1vpGfsplyH08vZ6S5RIqJZ8p+X9QGZcoOlUUK6Qx1C
        POrbiyHytvQLrL0HaZw07qVkoyrH5w2skWm2NcizcLqdDXG36eUS7Q7AboGqX3eVKCCvfwwTYpyxd
        G/yIXIFUA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34514)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdLn2-0006AM-GS; Mon, 25 May 2020 23:41:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdLmx-0004k4-AM; Mon, 25 May 2020 23:41:43 +0100
Date:   Mon, 25 May 2020 23:41:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
Message-ID: <20200525224143.GP1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-9-jeremy.linton@arm.com>
 <20200524144449.GP610998@lunn.ch>
 <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
 <20200525082510.GH1551@shell.armlinux.org.uk>
 <8567710f-b4d3-5ce6-225f-b932b4ffc97c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8567710f-b4d3-5ce6-225f-b932b4ffc97c@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 05:09:56PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/25/20 3:25 AM, Russell King - ARM Linux admin wrote:
> > On Sun, May 24, 2020 at 11:28:52PM -0500, Jeremy Linton wrote:
> > > Hi,
> > > 
> > > On 5/24/20 9:44 AM, Andrew Lunn wrote:
> > > > > +++ b/include/linux/phy.h
> > > > > @@ -275,6 +275,11 @@ struct mii_bus {
> > > > >    	int reset_delay_us;
> > > > >    	/* RESET GPIO descriptor pointer */
> > > > >    	struct gpio_desc *reset_gpiod;
> > > > > +	/* bus capabilities, used for probing */
> > > > > +	enum {
> > > > > +		MDIOBUS_C22_ONLY = 0,
> > > > > +		MDIOBUS_C45_FIRST,
> > > > > +	} probe_capabilities;
> > > > >    };
> > > > 
> > > > 
> > > > I'm not so keen on _FIRST. It suggest _LAST would also be valid.  But
> > > > that then suggests this is not a bus property, but a PHY property, and
> > > > some PHYs might need _FIRST and other phys need _LAST, and then you
> > > > have a bus which has both sorts of PHY on it, and you have a problem.
> > > > 
> > > > So i think it would be better to have
> > > > 
> > > > 	enum {
> > > > 		MDIOBUS_UNKNOWN = 0,
> > > > 		MDIOBUS_C22,
> > > > 		MDIOBUS_C45,
> > > > 		MDIOBUS_C45_C22,
> > > > 	} bus_capabilities;
> > > > 
> > > > Describe just what the bus master can support.
> > > 
> > > Yes, the naming is reasonable and I will update it in the next patch. I went
> > > around a bit myself with this naming early on, and the problem I saw was
> > > that a C45 capable master, can have C45 electrical phy's that only respond
> > > to c22 requests (AFAIK).
> > 
> > If you have a master that can only generate clause 45 cycles, and
> > someone is daft enough to connect a clause 22 only PHY to it, the
> > result is hardware that doesn't work - there's no getting around
> > that.  The MDIO interface can't generate the appropriate cycles to
> > access the clause 22 PHY.  So, this is not something we need care
> > about.
> > 
> > > So the MDIOBUS_C45 (I think I was calling it
> > > C45_ONLY) is an invalid selection. Not, that it wouldn't be helpful to have
> > > a C45_ONLY case, but that the assumption is that you wouldn't try and probe
> > > c22 registers, which I thought was a mistake.
> > 
> > MDIOBUS_C45 means "I can generate clause 45 cycles".
> > MDIOBUS_C22 means "I can generate clause 22 cycles".
> > MDIOBUS_C45_C22 means "I can generate both clause 45 and clause 22
> > cycles."
> 
> Hi, to be clear, we are talking about c45 controllers that can access the
> c22 register space via c45, or controllers which are electrically/level
> shifting to be compatible with c22 voltages/etc?

To me, Andrew was quite clear that these flags should describe what
the MDIO controller can support, and what I understand from Andrew's
email is:

If it can't support clause 45 accesses, then it should not advertise
MDIOBUS_C45 nor MDIOBUS_C45_C22.

If it can't support clause 22 accesses, then it should not advertise
MDIOBUS_C22.

And that's all there is to it.

If you want to talk about clause 45 access via the clause 22 register
set, that is a property of the PHY, not of the MDIO controller, and
the MDIO controller has no business attempting to describe that
property in any shape or form since it is a PHY property.

If you have access to clause 22 registers, then you likely have the
clause 22 ID registers, and the way phylib currently works, that will
also match a PHY driver.

Once we have a PHY and a driver bound, then even if it is a C45
driver, accesses using the phy_*_mmd() functions will _automatically_
switch to using C22 cycles to the indirect C45 access registers if
the PHY has not been detected as a C45 PHY (phydev->is_c45 is false.)

So, I'm coming to the conclusion that you're making way more work
here than is necessary, your changes to gratuitously change the way
stuff in phylib work which is not risk-free are completely unnecessary
and really not a risk worth taking when it's likely that we already
have the code mostly in place to be able to support your PHY.

I think there are some questionable uses of phydev->is_c45 that
your point about accessing C45 PHYs through C22 indirect registers
brings up which need to be resolved, but I really don't think that's
a completely separate issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
