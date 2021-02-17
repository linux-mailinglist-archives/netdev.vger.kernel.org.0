Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E14731D79A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBQKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhBQKfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 05:35:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08686C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 02:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yoxmht9FiVsWs/1SokxDPwJj9TGkocbKsU7qDjFW8T0=; b=I2piXSV6yyx1b9gScBu3VNuV2
        +SLTc4Xe2fUgmGwXquMamncAfOQmUKzXEuDSwHLhCW9FR4bUwSKyJPqLAVCXeXRK/DSb1WSeOktQK
        93njrofbDi9SDLK0IuXBefkBjBDaLwR/I+pjWfcTbVv9qrxTHxyjVGZ3cRPe07nQtDZFL59/O+pKO
        Sy6h5/7XgLoOeZpITq3raZA4/bDnKnYmXUCV5IiF7YV+bUxZvsYHK7caWHlqL6UIbAJ6PZ/8j3hVR
        nQMpL2Ro5dXoM+RI//5hKn1Z/HeKaxK21yt5y9qJK4rJcOctsEdSF+okZB8Is1zH1YXvBwSbTk0FB
        qMrVcZ3IA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44560)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lCKAb-0002Wo-Rg; Wed, 17 Feb 2021 10:34:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lCKAZ-0003fR-Ic; Wed, 17 Feb 2021 10:34:55 +0000
Date:   Wed, 17 Feb 2021 10:34:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Hancock <robert.hancock@calian.com>, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] net: phy: Add is_on_sfp_module flag and
 phy_on_sfp helper
Message-ID: <20210217103455.GF1463@shell.armlinux.org.uk>
References: <20210216225454.2944373-1-robert.hancock@calian.com>
 <20210216225454.2944373-3-robert.hancock@calian.com>
 <YCyUYqPt1X37bqpI@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCyUYqPt1X37bqpI@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:58:26AM +0100, Andrew Lunn wrote:
> On Tue, Feb 16, 2021 at 04:54:53PM -0600, Robert Hancock wrote:
> > Add a flag and helper function to indicate that a PHY device is part of
> > an SFP module, which is set on attach. This can be used by PHY drivers
> > to handle SFP-specific quirks or behavior.
> > 
> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> > ---
> >  drivers/net/phy/phy_device.c |  2 ++
> >  include/linux/phy.h          | 11 +++++++++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 05261698bf74..d6ac3ed38197 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1377,6 +1377,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >  
> >  		if (phydev->sfp_bus_attached)
> >  			dev->sfp_bus = phydev->sfp_bus;
> > +		else if (dev->sfp_bus)
> > +			phydev->is_on_sfp_module = true;
> 
> I get lost here. It this correct?
> 
> We have setups with two PHY. The marvell10g PHY can play the role of
> media converter. It converts the signal from the MAC into signals
> which can be connected to an SFP cage.
> 
> And then inside the cage, we can have a copper module with a second
> PHY. It is this second PHY which we need to indicate is_on_sfp_module
> true.

We don't support that setup, at least at the moment. There's no support
for stacking PHYs precisely because we have the net_device structure
containing a pointer to the PHY (which will be the first PHY in the
chain.) That has the effect of making the second PHY inaccessible to the
normal network APIs.

> We probably want to media convert PHYs LEDs to work, since those
> possible are connected to the front panel. So this needs to be
> specific to the SFP module PHY, and i'm not sure it is. Russell?

The main reason I'm hessitant with using the net_device structure
to detect this is that we know that phylink has been converted to
work without the net_device structure - it will be NULL. This includes
attaching the "primary" PHY - phylib will be given a NULL net_device.

The good news is that if a SFP cage is attempted to be attached in
that situation, phylink will oops in phylink_sfp_attach(). So it
isn't something that we support. However, the point is that we can
end up in situations where phylib has a NULL net_device.

Florian mentioned in response to one of my previous emails that he's
working on sorting out the phylib dev_flags - I think we should wait
for that to be resolved first, so we can allocate a dev_flag (or
maybe we can do that already today?) that says "this PHY is part of
a SFP module". That will give us a clearly defined positive condition
that is more maintainable into the future.

I'm just worrying that if we sort out phylink_sfp_*tach() (which could
be trivial), if we introduce new dependencies into phylib on the
network device, we're moving backwards.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
