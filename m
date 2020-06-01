Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C41E9AF8
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgFAA2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 20:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgFAA2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 20:28:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C6C061A0E;
        Sun, 31 May 2020 17:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NhRpyX34DYSeXWeSmmPa0MQkzAPlaFT25NL05/24rqs=; b=z4BKajiIsAPrKZrM9ZW8nXfU7
        pbxQ67sS/MGOtN1e/QlAY2ZcNQ/Q9OOB6DavbqBX1ABc04nDfNt8Jb3leneTVDjcqC161bnLoy3cS
        0S3BWP3AOGtLbrVvq5CG3Q9YT3BKvUbTIBGi0DBJBGQswp/l1C6g3eaxcjyd8uZj0XKymcbKFZlYa
        ne4KHi8mG24S6kQxT915Ii30ygqbL2PWUa+OE2yxObJU0uobH1sL9WJg6Uu2kKvPJGqOer1Zm9sYk
        9rWR6da9+FpjwSpUk4AJK8bxyN2yrsblzb66762b+VLddr5/4ZQuyAZ/JeMg2B360uml1FwykXjHY
        o62iZCebg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37288)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jfYJ6-0006v2-PS; Mon, 01 Jun 2020 01:28:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jfYIz-0002kH-C7; Mon, 01 Jun 2020 01:27:53 +0100
Date:   Mon, 1 Jun 2020 01:27:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, zefir.kurtisi@neratec.com
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
Message-ID: <20200601002753.GH1551@shell.armlinux.org.uk>
References: <20200530214315.1051358-1-olteanv@gmail.com>
 <20200531001849.GG1551@shell.armlinux.org.uk>
 <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 12:00:16AM +0300, Vladimir Oltean wrote:
> On Sun, 31 May 2020 at 03:19, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Sun, May 31, 2020 at 12:43:15AM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > In kernel 4.19 (and probably earlier too) there are issues surrounding
> > > the PHY_AN state.
> > >
> > > For example, if a PHY is in PHY_AN state and AN has not finished, then
> > > what is supposed to happen is that the state machine gets rescheduled
> > > until it is, or until the link_timeout reaches zero which triggers an
> > > autoneg restart process.
> > >
> > > But actually the rescheduling never works if the PHY uses interrupts,
> > > because the condition under which rescheduling occurs is just if
> > > phy_polling_mode() is true. So basically, this whole rescheduling
> > > functionality works for AN-not-yet-complete just by mistake. Let me
> > > explain.
> > >
> > > Most of the time the AN process manages to finish by the time the
> > > interrupt has triggered. One might say "that should always be the case,
> > > otherwise the PHY wouldn't raise the interrupt, right?".
> > > Well, some PHYs implement an .aneg_done method which allows them to tell
> > > the state machine when the AN is really complete.
> > > The AR8031/AR8033 driver (at803x.c) is one such example. Even when
> > > copper autoneg completes, the driver still keeps the "aneg_done"
> > > variable unset until in-band SGMII autoneg finishes too (there is no
> > > interrupt for that). So we have the premises of a race condition.
> >
> > Why do we care whether SGMII autoneg has completed - is that not the
> > domain of the MAC side of the link?
> >
> > It sounds like things are a little confused.  The PHY interrupt is
> > signalling that the copper side has completed its autoneg.  If we're
> > in SGMII mode, the PHY can now start the process of informing the
> > MAC about the negotiation results across the SGMII link.  When the
> > MAC receives those results, and sends the acknowledgement back to the
> > PHY, is it not the responsibility of the MAC to then say "the link is
> > now up" ?
> >
> 
> Things are not at all confused on my end, Russell.

When I say "It sounds like things are a little confused." I am
referring to the damn PHY/driver, not to you - that should be
obvious because I then describe what _should_ be happening there
in the same damn paragraph.

> The "803x_aneg_done: SGMII link is not ok" log message had made me
> aware of the existence of this piece of code for a very long while
> now, but to be honest I hadn't actually read the commit message in
> full detail until I replied to Heiner above. Especially this part:
> 
>     It prints a warning on failure but
>     intentionally does not try to recover from this
>     state. As a result, if you ever see a warning
>     '803x_aneg_done: SGMII link is not ok' you will
>     end up having an Ethernet link up but won't get
>     any data through. This should not happen, if it
>     does, please contact the module maintainer.

Yes, I read that after sending my reply - it seems there's a problem
with this PHY not being able to complete the SGMII side of the link,
but it's unclear what the problem actually is.  I don't know the
background, but it sounds like Zefir was hoping someone would make
contact soon after the commit was added so that further debug could
happen, maybe?  If that was the intention, the warning message could
have been better.  In any case, as we're now four years on before
someone has tripped over it...

> The author highlighted a valid issue, but then came up with a BS
> solution for it. It solves no problem, and it creates a problem for
> some who originally had none.
> When used in poll mode, the at803x.c driver would occasionally catch
> the in-band AN in a state where it wasn't yet complete, so it would
> print this message once, but all was ok in the end since the state
> machine would get rescheduled and the link would come up. So I
> genuinely thought that the intention of the patch was to be helpful.
> But according to his own words, it is just trying to throw its hands
> up in the air and lay the blame on somebody else [ the gianfar
> maintainer ]. So in that sense, maybe it's my 'fault' for trying to
> make the link come up with 803x_aneg_done in place. Maybe I should
> just respectfully revert the patch
> f62265b53ef34a372b657c99e23d32e95b464316, and replace it with some
> other framework. The trouble is, what to replace it with?

Maybe it's how you say it is, or maybe it isn't... unless we get
input from those involved, it's going to need to be re-investigated.

> > That's how we deal with it elsewhere with phylink integration, which
> > is what has to be done when you have to cope with PHYs that switch
> > their host interface mode between SGMII, 2500BASE-X, 5GBASE-R and
> > 10GBASE-R - the MAC side needs to be dynamically reconfigured depending
> > on the new host-side operating mode of the PHY.  Only when the MAC
> > subsequently reports that the link has been established is the whole
> > link from the MAC to the media deemed to be operational.
> 
> This sounds to me like 'phylink has this one figured out', but I would
> beg to differ.

phylink has this case figured out for a PHY that does bring up
the SGMII side according to the specs.  That's precisely how
copper SFPs work, which are fully supported - that's not opinion,
that's a fact.  In the case of a PHY which doesn't reliably
complete SGMII, then no, phylink doesn't have that worked out.

However, yet again, you've taken my comments completely the wrong
way - what you quote was meant to illustrate _why_ waiting for
the SGMII side to come up before reporting link up from the PHY
is wrong.

> My opinion is that it's not obvious that it would be the MAC's
> responsibility to determine whether the overall link is operational
> (applied in this case to in-band AN), but the system's responsibility,
> and for a simple reason: it takes 2 to negotiate. The MAC PCS and the
> PHY have to agree on whether they perform in-band AN or not.

Right, and if you configure phylink to use "in-band-status" in
DT, you will be telling phylink that this in-band status is to be
used.  If that's not what you want, then you don't specify that,
and use PHY or fixed-link modes... and why phylink integrates the
whole system status when using "in-band-status" mode.

> And
> that's wild jungle right there, with some PHY drivers capable of
> in-band AN keeping it enabled and some disabled (and even worse, PHY
> drivers that don't enable it in Linux but enable it in U-Boot, and
> since the setting is sticky, it changes the default behavior), and
> phylink hasn't done anything to add some rules to it, just some
> MAC-side knobs to turn for a particular MAC-PHY combination until
> something works.

... because there hasn't been a /need/ to do add this yet; no one
has asked for it, no one has provided me hardware that requires it,
and I don't have oodles of spare time to hack randomly on stuff that
maybe no one wants right now.

When I set out with phylink, it was to solve the problem of getting
SFPs to work with all the in-band complexities that they have, while
keeping compatibility with phylib and it does that reasonably well.

It seems that you're expecting it to also solve this Coronavirus
pandemic, world hunger, etc.

> This is all relevant because our options for the stable trees boil
> down to 2 choices:
> - Revert f62265b53ef34a372b657c99e23d32e95b464316, fix an API misuse
> and a bug, but lose an (admittedly ad-hoc, but still) useful way of
> troubleshooting a system misconfiguration (hide the problem that Zefir
> Kurtisi was seeing).

Or maybe just allow at803x_aneg_done() to return non-zero but still
print the warning (preferably identifying the affected PHY) so
your hard-to-debug problem still gets a useful kernel message pointing
out what the problem is?

> - Apply this patch which make the PHY state machine work even with
> this bent interpretation of the API. It's not as if all phylib users
> could migrate to phylink in stable trees, and even phylink doesn't
> catch all possible configuration cases currently.

I wasn't even proposing that as a solution.

And yes, I do have some copper SFP modules that have an (inaccessible)
AR803x PHY on them - Microtik S-RJ01 to be exact.  I forget exactly
which variant it is, and no, I haven't seen any of this "SGMII fails
to come up" - in fact, the in-band SGMII status is the only way to
know what the PHY negotiated with its link partner... and this SFP
module works with phylink with no issues.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
