Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C0511E644
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfLMPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:12:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48442 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLMPM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:12:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=etZtC+NUJmFt0La0f5fEcO6a9gCWyqF9yIN69XBsKPo=; b=NeL3pLImR9UnTgW/U4UZlvJ1z
        S6I9iygAzPO+940RRDktu7yUXABmy8lGoVt02GNmQKT1Qa0+8Up0jfi8AwNzBRlC7C9vyMbOjUnHD
        Vt9lBrrVYE00DQBJgfQxGjQhCrnS+qD9P8X2tVApSjQY2wAMtfFYgKNv72HwAaUa5b8ATDEfXnGHF
        JhL5TwSE7C6JOsZvG083/KE7PC091BxmKEpiQythqLYSUfJaG+LOgo8cnStS2sD/tH33sNKMubo8T
        oDRhWnG8BSfRJrJluOhzfDY8qqWOALZW4+7H2jXpV2n1M4XobS2mxuEOTyWIooLeTZrnXh6RhCYOl
        c7cWIRgig==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40830)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifmcg-0005Wc-O6; Fri, 13 Dec 2019 15:12:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifmcg-0007zO-3X; Fri, 13 Dec 2019 15:12:54 +0000
Date:   Fri, 13 Dec 2019 15:12:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool pause mode clarifications
Message-ID: <20191213151254.GT25745@shell.armlinux.org.uk>
References: <20191213114935.GR25745@shell.armlinux.org.uk>
 <20191213142902.GB4286@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213142902.GB4286@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 03:29:02PM +0100, Andrew Lunn wrote:
> On Fri, Dec 13, 2019 at 11:49:35AM +0000, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > Please can someone explain the ethtool pause mode settings?  The man
> > page isn't particularly clear, it says:
> > 
> >        -A --pause
> >               Changes the pause parameters of the specified Ethernet device.
> > 
> >            autoneg on|off
> >                   Specifies whether pause autonegotiation should be enabled.
> > 
> >            rx on|off
> >                   Specifies whether RX pause should be enabled.
> > 
> >            tx on|off
> >                   Specifies whether TX pause should be enabled.
> > 
> > 
> > "autoneg" states whether pause autonegotiation should be enabled, but
> > how is this possible, when pause autonegotiation happens as part of the
> > rest of the autonegotiation as a matter of course, and the only control
> > we have at the PHY is the value of the pause and asym pause bits?
> 
> Hi Russell
> 
> Yah, this is not clear. How i've interpreted it is:
> 
> autoneg on:
> 
> The driver should validate rx and tx with its capabilities, and then
> tell the PHY what to advertise, kick off an auto-neg, and wait for the
> result to program the MAC with the negotiated value.
> 
> If autoneg in general is off, return an error.

That's similar to how I interpreted it - the ethtool uapi header
describes it this way:

 * struct ethtool_pauseparam - Ethernet pause (flow control) parameters
 * @cmd: Command number = %ETHTOOL_GPAUSEPARAM or %ETHTOOL_SPAUSEPARAM
 * @autoneg: Flag to enable autonegotiation of pause frame use
 * @rx_pause: Flag to enable reception of pause frames
 * @tx_pause: Flag to enable transmission of pause frames
 *
 * Drivers should reject a non-zero setting of @autoneg when
 * autoneogotiation is disabled (or not supported) for the link.
 *
 * If the link is autonegotiated, drivers should use
 * mii_advertise_flowctrl() or similar code to set the advertised
 * pause frame capabilities based on the @rx_pause and @tx_pause flags,
 * even if @autoneg is zero.  They should also allow the advertised
 * pause frame capabilities to be controlled directly through the
 * advertising field of &struct ethtool_cmd.
 *
 * If @autoneg is non-zero, the MAC is configured to send and/or
 * receive pause frames according to the result of autonegotiation.
 * Otherwise, it is configured directly based on the @rx_pause and
 * @tx_pause flags.

but my point is that this is perverse and counter-intuitive.

	ethtool -A ethN autoneg on rx on tx on

will advertise PAUSE but no ASYM PAUSE, which will only allow pause
resolutions to:
       	RX+TX enabled
	RX+TX disabled

depending on the link partner.

	ethtool -A ethN autoneg on rx on tx off

will advertise PAUSE and ASYM PAUSE, allowing pause resolutions to:
	RX+TX enabled
	RX enabled TX disabled
	RX+TX disabled

This seems utterly wrong to me.

Then we've got the issue that the advertisement can also be changed
via ethtool -s (as explicitly stated above), which means if we store
the ethtool rx/tx status separately, it will get out of sync with what
is being advertised.  If we try to update the rx/tx enablement status
from the advertisement, then we fall into a very similar trap - if
ASYM_PAUSE=1 PAUSE=1 that could be RX=1 TX=0 or RX=1 TX=1.  It is
completely ambiguous.

> autoneg off:
> 
> Forget about the PHY, program the MAC directly, and potentially shoot
> yourself in the foot. But it can be useful it auto-neg in general is
> off, or there is no PHY.

Yep, that's how I interpret it - autoneg off => manual control of the
MAC.

> > So, would it be possible to clarify what these settings mean in the
> > ethtool man page please?
> 
> I suspect the first step would be to survey current implementations
> and find out what is the most popular interpretation of this
> text. Then expand the document, and maybe list some of the alternative
> meanings which are currently in use?

I've looked at a number of implementations, and the result of the
vagueness of specification is that we have every driver doing something
different.

Some refuse set_pauseparam if autoneg=1.

Some set the PHY advertisement based on rx_pause/tx_pause in a way
that seems popular, but leads to the perverse outcome I highlight
above.

Some report the MAC enablement state via get_pauseparam rx_pause /
tx_pause - which means get_pauseparam followed by set_pauseparam
with no changes is not a no-op.

Some require pause autoneg to match the autoneg state in ksettings,
and then use tx_pause/rx_pause an "abilities mask" (which isn't
clear what effect it has.)

Some disappears off into firmware, so there's no clue there.

Some have a boolean pause state, which they update if tx_pause
doesn't match, else if rx_pause doesn't match, else return an
error if autoneg is on (which gives really odd behaviour.)  See
myri10ge_set_pauseparam() for that one.

skge_set_pauseparam() is another variation on randomness.  If
you change autoneg, you switch between none and symmetric mode.
Otherwise what you end up with depends on the rx/tx_pause values.

And then when you search the Internet, you very quickly come across
lots of people who struggle to cope with all these random driver
specific behaviours.  The whole thing seems to be one big trainwreck
of a mess - which I suspect comes down to the total lack of clear
specification about how this interface is supposed to work.

> Clearly, the more of this we can handle in phylink/phylib, the more
> uniform it will be. But there is also a trend at the moment for
> firmware to control the PHY, and it seems like a few MAC driver
> writers have no idea what their firmware is actually doing with the
> PHY for things like this.

Yes, and I have nothing good to say about that; firmware leads to
brokeness or restrictive implementations that are impossible to
work-around.  I'm pretty sure that for one of the platforms I have
here, it's downfall is going to be restrictive vendor firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
