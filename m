Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7520A782
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391179AbgFYVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390931AbgFYVcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 17:32:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D1C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ooj5TPxRoYB2CL4cxppXvIRxjuTy5SE0FWwYlaa3hd0=; b=S/xGhRcsvUJ8MuYef/LVB8E6z
        d4SsXrsjkMc5VZmRF9N0KU57/fj/uojDHEBgNhea4hnL/BIudbvP836eqwQOuOrK9vxz+llmfeZBk
        QwpNx1aYHJBq9v3/xR+yDnzlUBEQEgyPK3gETj5MN5T6gwNs6EXH5KzJA/MxqilxyvzSFeBJONEKF
        y2jjcjqqC0DG5IlOLdi/6J2xdgQuP/ran85f+Cu/lXEGDB1I8VpLiQOiAjBO4QFn+wAuawZ9ODpYa
        8U4I46NwSPGEA/RSHpClzvlsKzu2DxhpL2YSJr1q+XDMCOhehY/l1MSnjDTm7UHCbYy5YxmDfMvFK
        j6vWDOSVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59738)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1joZTV-0004l3-Cy; Thu, 25 Jun 2020 22:32:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1joZTU-0003Ma-FP; Thu, 25 Jun 2020 22:32:00 +0100
Date:   Thu, 25 Jun 2020 22:32:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>
Subject: Re: [PATCH] net: phy: marvell10g: support XFI rate matching mode
Message-ID: <20200625213200.GO1605@shell.armlinux.org.uk>
References: <79ca4ba3129a92e20943516b4af0dca510e938b3.1593105561.git.baruch@tkos.co.il>
 <20200625175012.GL1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625175012.GL1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 06:50:12PM +0100, Russell King - ARM Linux admin wrote:
> On Thu, Jun 25, 2020 at 08:19:21PM +0300, Baruch Siach wrote:
> > When the hardware MACTYPE hardware configuration pins are set to "XFI
> > with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
> > MAC buffer packets in both directions to match various wire speeds.
> > 
> > Read the MAC Type field in the Port Control register, and set the MAC
> > interface speed accordingly.
> 
> Rate matching brings with it a whole host of issues, not just the
> interface type, but also the phydev->speed, which is commonly used
> to program the MAC.
> 
> Rate matching is also used with the unsupported 3310 PHY on the ZII
> devel rev C board, and there we need the PHY to also report a speed
> of 10G as well as the interface type correctly.  The whole thing
> gets quite yucky when you have a 10baseT link on a 3310 PHY with
> the host interface running with 10GBASE-R but the MAC programmed for
> 10Mbps.
> 
> The approach I hacked up was to split the current link_state into
> media_state and mac_state, and then do this:
> 
> +       /* If the PHY supports rate-matching, it will report slower speeds
> +        * for these fixed-speed interface modes. Force the MAC side to
> +        * full speed.
> +        */
> +       if (mac_state.interface == PHY_INTERFACE_MODE_XAUI ||
> +           mac_state.interface == PHY_INTERFACE_MODE_RXAUI ||
> +           mac_state.interface == PHY_INTERFACE_MODE_10GBASER) {
> +               mac_state.speed = SPEED_10000;
> +               mac_state.duplex = DUPLEX_FULL;
> +       }
> 
> which is really a dirty hack.  I'd need to re-read the switch
> documentation and review what we're doing to check whether such a
> thing is really necessary, or whether merely using 10GBASE-R but
> programming the MAC to 10Mbps (e.g.) is actually acceptable.
> 
> What I'm basically saying is, there could be way more to this than
> just setting the interface mode.
> 
> We also /should/ be setting the 3310's interface mode according to
> how the PHY is configured - but that is slightly complicated by the
> various different modes presented by different variants of the PHY
> (the P variant vs the non-P variant.)  I seem to remember that
> disambiguating them requires looking at the revision bits in the
> PHY ID registers, and I've been debating whether we should not be
> using the standard mask when matching them.

Okay, it's not P vs non-P, it's 3310 vs 3340, which use bit 3 in
register 3 to disambiguate between the two.

For both, yes, value 6 is the 10G with rate matching setting, but
there's some variance between the 3310 and 3340 for the other host
interface codes.  So let's not worry about that too much.

Can I suggest that we read this field at probe time or config_init
time, as an efficiency measure?

The 3310 on the ZII rev C (sorry) is operating in XAUI mode (== 1).
Having just played around with the switch configuration for this PHY,
even though the switch port is in XAUI mode, the speed needs to be
set to 10G in the switch, even if the media side is running at
(e.g.) 100M.

That brings up the question - where should that be handled - phylink
will currently report for 100M on the media side with an XAUI or
10GBASE-R interface mode a speed of 100M to the MAC.  Is that
reasonable?

I've also remembered that how rate matching mode works is dependent
on other configuration in the 3310 - not all devices are capable of
producing pause frames in rate matching mode, and the PHY expects
the host to limit the egress packet rate.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
