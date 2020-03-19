Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C8418B317
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCSMO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:14:27 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43624 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSMO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 08:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cu0lWnoUWVpa/LNhXXQphRFoxTFVknGehFWmBEXDuXY=; b=NwPLZnn90NDnxkVrfbJIR7KX+
        16+VXJxPzzEhLwqfsRT2jWdD085HnPO5oP4+BFQinqOfEURrN/T2MI8D0BsByecWbu4Zxe3f5uXuH
        l+PRpzVJel2pooEWWBLKwnHyswc6oe5eGLA0wxxGBOddxzrr5I5tUbjr7Zven3td/XpQQeoiLeAlF
        xoZ5Bmaj/sykjP1U3oLHQIki9a3Dou+AT0Jg9A3ySh92zHL7acQov8CbkzaDqQ9dVMXdnSv60Z9t8
        HL167rm4ywS4pNWN09y/HuVQMly2iPU8UolF1kUBjpZ/A+xdshiE+IMRaCoCF8v2bI97A7jxK4ulD
        i8CG2kjig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38536)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEu44-00024u-BH; Thu, 19 Mar 2020 12:14:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEu42-0004lp-UI; Thu, 19 Mar 2020 12:14:18 +0000
Date:   Thu, 19 Mar 2020 12:14:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200319121418.GJ5827@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
 <20200317165422.GU25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317165422.GU25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 04:54:22PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Mar 17, 2020 at 05:38:02PM +0100, Andrew Lunn wrote:
> > On Tue, Mar 17, 2020 at 02:52:51PM +0000, Russell King wrote:
> > > *NOT FOR MERGING*
> > > 
> > > Add a separate set of PCS operations, which MAC drivers can use to
> > > couple phylink with their associated MAC PCS layer.  The PCS
> > > operations include:
> > > 
> > > - pcs_get_state() - reads the link up/down, resolved speed, duplex
> > >    and pause from the PCS.
> > > - pcs_config() - configures the PCS for the specified mode, PHY
> > >    interface type, and setting the advertisement.
> > > - pcs_an_restart() - restarts 802.3 in-band negotiation with the
> > >    link partner
> > > - pcs_link_up() - informs the PCS that link has come up, and the
> > >    parameters of the link. Link parameters are used to program the
> > >    PCS for fixed speed and non-inband modes.
> > 
> > Hi Russell
> > 
> > This API makes sense. But it seems quite common to have multiple
> > PCS's. Rather than have MAC drivers implement their own mux, i wonder
> > if there should be core support? Or at least a library to help the
> > implementation?
> 
> When each PCS has different characteristics, and may not even be
> available to be probed (because the hardware holds them in reset,
> so they don't even respond to MDIO cycles) that becomes very
> difficult.
> 
> That is the situation with LX2160A - when in 1G mode, the 10G C45
> PCS does not respond.  Already tested that.
> 
> So, determining when to switch can't be known by generic code.

Oh, I forgot to mention on the library point - that's what has already
been created in:

"net: phylink: pcs: add 802.3 clause 45 helpers"
"net: phylink: pcs: add 802.3 clause 22 helpers"

which add library implementations for the pcs_get_state(), pcs_config()
and pcs_an_restart() methods.

What remains is vendor specific - for pcs_link_up(), there is no
standard, since it requires fiddling with vendor specific registers to
program, e.g. the speed in SGMII mode when in-band is not being used.
The selection between different PCS is also vendor specific.

It would have been nice to use these helpers for Marvell DSA switches
too, but the complexities of DSA taking a multi-layered approach rather
than a library approach, plus the use of paging makes it very
difficult.

So, basically on the library point, "already considered and
implemented".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
