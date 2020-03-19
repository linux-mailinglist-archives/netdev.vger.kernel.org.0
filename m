Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7176218C201
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCSVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:00:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50050 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSVAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6kt5jyhqcoy8UyqhROafcoTOOf676pkncWS8mQoZsQw=; b=Tb5jR51Am74CjafhxC+pUKOXx
        ngP7OMBUCq3mts77ln3MG4e/Dcm4UbGe/u9mzkZUKYD0aA+YhY9PKScqYChffpXZ7cFG36OUtNIj2
        Aa5G9CqNYBoxGwnKBJ43Jfu3zgCb3ncvI88pUof0fhOq8d70LhqYYTX3zE2djtKTKCiCirFgMUPZT
        /3io7I+KljCbHol8w16OYyPHongpKJY2aE0v66sCZIVGgQJuW1EP/Ko8/NQHCpq5CDUg/Ax3dHW81
        hixpBW+OoiTM78NTHeFsOFIDhLCH6BmMz8Z6aY/pJmJuIhbKU96rZUmmY8RENcctn0OeQlv6sshiE
        u9fJYluCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38698)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jF2Gn-0004P8-8p; Thu, 19 Mar 2020 21:00:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jF2Gj-00055o-E4; Thu, 19 Mar 2020 20:59:57 +0000
Date:   Thu, 19 Mar 2020 20:59:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200319205957.GH25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
 <20200317165422.GU25745@shell.armlinux.org.uk>
 <20200319121418.GJ5827@shell.armlinux.org.uk>
 <20200319150652.GA27807@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319150652.GA27807@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 04:06:52PM +0100, Andrew Lunn wrote:
> > Oh, I forgot to mention on the library point - that's what has already
> > been created in:
> > 
> > "net: phylink: pcs: add 802.3 clause 45 helpers"
> > "net: phylink: pcs: add 802.3 clause 22 helpers"
> > 
> > which add library implementations for the pcs_get_state(), pcs_config()
> > and pcs_an_restart() methods.
> > 
> > What remains is vendor specific - for pcs_link_up(), there is no
> > standard, since it requires fiddling with vendor specific registers to
> > program, e.g. the speed in SGMII mode when in-band is not being used.
> > The selection between different PCS is also vendor specific.
> > 
> > It would have been nice to use these helpers for Marvell DSA switches
> > too, but the complexities of DSA taking a multi-layered approach rather
> > than a library approach, plus the use of paging makes it very
> > difficult.
> > 
> > So, basically on the library point, "already considered and
> > implemented".
> 
> Hi Russell
> 
> The 6390X family of switches has two PCSs, one for 1000BaseX/SGMII and
> a second one for 10GBaseR. So at some point there is going to be a
> mux, but maybe it will be internal to mv88e6xxx and not shareable. Or
> internal to DSA, and shareable between DSA drivers. We will see.

Looking at the 6390X functional specifications, it looks like it will
be rather simple:

In mv88e6390_serdes_pcs_get_state(), we detect if state->interface is
10GBASER (or 10GBASEX2/X4 if we ever support those), and read from the
10G PCS offset.  We only need to be concerned with the link up/down
status there as there is no negotiation present - however, state->speed
and state->duplex still need to be set.

mv88e6390_serdes_pcs_an_restart() won't do anything for 10G speeds -
there is no autonegotiation to restart, and at the moment phylink will
not call that function anyway for 10GBASE* anyway.

mv88e6390_serdes_pcs_link_up() needs a bit of rework to pass the
interface to it, and ignore 10GBASE* modes altogether, rather than
trying to fiddle with the not-currently-in-use 1G PCS.

However, what I can say is that on the ZII rev C, it seems to sort-of
work for the 3310 PHY.  The PHY XS (operating in XAUI mode) reports
that all four lanes are synchronised and the link is established
with the switch.  The switch reports 0x94c in the port status register,
indicating that it's in 10G XAUI mode, link up, but 100M/Half - which
is where things get odd - the 3310 seems not to negotiate correctly,
the copper side is operating at 100M/Half at both ends as reported by
the PHYs at both ends - it looks like the advertisement is not being
sent or received correctly.  The other complexity here is that the
3310 on the ZII rev C is in "XAUI with rate adaption" mode and we
have no support for such a thing.  Consequently, I can't pass traffic
over the link.

So, as far as I can tell, apart from the modifications to the
mv88e6390_serdes_*() functions above, it should be mostly in a
working state.

However, what I said previously applies: the 6390X 1G/10G PCS are
"vendor specific" - similar to the 3310 PHY with its multiple
sub-PHYs at various register offsets, the 6390X PCS are accessed
through the PHYXS MMD rather than the PCS MMD.  The 1G PHY has
a clause 22 compatible register layout, but is in the PHYXS MMD
at offset 0x2000.  The 10G PHY has a clause 45 PCS compatible
register layout, but is in the PHYXS MMD at offset 0x1000.

So, generic code isn't going to be able to access those, just like
we can't use generic phylib code to access the offset PHY blocks
in the 3310.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
