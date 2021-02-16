Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6B31CEA0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBPRFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBPRFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:05:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675ADC061786
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4oNM4z3lu8+faxhCt5T5JIhUExpKlOoqMPxliYhW12M=; b=LN/6wTHUtKq4YO0syGnhJS2kM
        sGBpGgdOLXPsSrBdFDdP+WGW0WCrSfWq8Pm8rYMkQ6rAVvXGcZRylM9WnEj0i3aDgT6fg2GT98hK4
        gqcbSt8a+MG6Ybfaaj6cG4QRIsmy61QKRnS5KP7jXZefWRIn7EtuofU/XmXYpKDtchmXwz/EGhAfk
        r4PRj8pMa4yK9HNLC00e2gpGwzW7mkRXDVrGPaNGkCQNhbduvKCgn9guBTOebSy1Mw+c4FVT2HfNv
        bpjW1GjRlLiICh5IBMFooe5K4UV6gzd/HVxiE2rwD9EQp6kY7FczJMyFIFnPyd5QBEoMCWCu3goWC
        5P3QOqsfw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44254)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lC3lo-00021Q-Kp; Tue, 16 Feb 2021 17:04:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lC3lm-0002uM-6f; Tue, 16 Feb 2021 17:04:14 +0000
Date:   Tue, 16 Feb 2021 17:04:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Message-ID: <20210216170414.GC1463@shell.armlinux.org.uk>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-3-robert.hancock@calian.com>
 <20210213104537.GP1463@shell.armlinux.org.uk>
 <fc3b75ed82a38b5fbf216893f52b3b24531db148.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3b75ed82a38b5fbf216893f52b3b24531db148.camel@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 04:52:13PM +0000, Robert Hancock wrote:
> On Sat, 2021-02-13 at 10:45 +0000, Russell King - ARM Linux admin wrote:
> > On Fri, Feb 12, 2021 at 08:18:40PM -0600, Robert Hancock wrote:
> > > +	if (!phydev->sfp_bus &&
> > > +	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {
> > 
> > First, do we want this to be repeated in every driver?
> > 
> > Second, are you sure this is the correct condition to be using for
> > this?  phydev->sfp_bus is non-NULL when _this_ PHY has a SFP bus
> > connected to its fibre side, it will never be set for a PHY on a
> > SFP. The fact that it is non-NULL or NULL shouldn't have a bearing
> > on whether we configure the LED register.
> 
> I think you're correct, the phydev->sfp_bus portion is probably not useful and
> could be dropped. What we're really concerned about is whether this PHY is on
> an SFP module or not. I'm not sure that a module-specific quirk makes sense
> here since there are probably other models which have a similar design where
> the LED outputs from the PHY are used for other purposes, and there's really no
> benefit to playing with the LED outputs on SFP modules in any case, so it would
> be safer to skip the LED reconfiguration for anything on an SFP. So we could
> either have a condition for "!phydev->attached_dev || !phydev->attached_dev-
> >sfp_bus" here and anywhere else that needs a similar check, or we do something
> different, like have a specific flag to indicate that this PHY is on an SFP
> module? What do people think is best here?

I don't think relying on phydev->attached_dev in any way is a good
idea, and I suspect a flag is going to be way better. One of the
problems is that phydev->dev_flags are PHY specific at the moment.
Not sure if we can do anything about that.

In the short term, at the very least, I think we should wrap whatever
test we use in a "phy_on_sfp(phydev)" helper so that we have a standard
helper for this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
