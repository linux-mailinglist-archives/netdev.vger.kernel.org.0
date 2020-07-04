Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2834B2148F8
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 23:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgGDV4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 17:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDV4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 17:56:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B75C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Cl37HdWqV7BvTPK5tRwFegLPQhTjFZEKSQBAYHmnvXk=; b=QIERoMUk0VTwzqGVV++7vwQbZ
        Evt7fvaSbTnFV4Fa7BkWZpvb77dUnzkMxy8WRFi6/PuAAuPW1MXRDaPyjVqD/SIxobDtAfgQfWe91
        1li+4UxAJp0HOVhbTBx8igrb8PiFoWbs4ubS7u1mEL+w6kwzUhZtEPTuRYMLv5Zpctj6PKAf2dOYU
        LcZI320dPxkYUSlUY7Fom4398SYPEXg/zF4OSdcI3WX28p/P/aVro4NvWWF5ZwUmkbE+8+CYvurTH
        Tj2zb6175NQCMvQ2HoKOuvRSbajwsaB+ycr3x8CnnmvA3TrVXQ9+JRSXnE7av2e5rJ7Q751sT0xgw
        HtloCAucg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35366)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jrq8g-0004pD-G5; Sat, 04 Jul 2020 22:56:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jrq8c-0004EI-P8; Sat, 04 Jul 2020 22:55:58 +0100
Date:   Sat, 4 Jul 2020 22:55:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200704215558.GT1551@shell.armlinux.org.uk>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200704124507.3336497-6-olteanv@gmail.com>
 <20200704145613.GR1551@shell.armlinux.org.uk>
 <20200704155048.nsrzn4byujvkab3q@skbuf>
 <20200704181401.GS1551@shell.armlinux.org.uk>
 <20200704202918.larwj762pwbephhb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704202918.larwj762pwbephhb@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 11:29:18PM +0300, Vladimir Oltean wrote:
> I will try to address those points centrally, here, by asking 2
> questions.
> 
> 1. In various topics you have brought up a certain copper SFP module
>    from Mikrotik which embeds an inaccessible Atheros SGMII PHY. Mind
>    you, I have never interacted with that SFP, but, I have a question
>    out of sheer curiosity. How does ethtool -r currently work for such a
>    system?

It does not, but we should probably error out if we're in SGMII mode
and we have no PHY, so userspace knows that the request could not be
satisfied.

>    [ I am not going to use this argument to lean this particular
>    discussion in either direction (read: even if my hunch is right and
>    restarting AN on the MAC PCS _could_ be the only way to implement
>    ethtool -r there, I still don't care enough about that one-off case
>    to change the phylink API, for the time being), but I _would_ like
>    to know ]

Even if we did, it will not cause the media side of the Atheros PHY to
renegotiate - the Atheros PHY makes no mention that restarting the
SGMII exchange has any effect on the media side.  I've just tried it
(again) this time with the module plugged in the LX2160A rather than
a Marvell platform - here's the PCS register dump:

00: 0x1140 0x002d 0x0083 0xe400 0x4001 0xd801 0x0006 0x0000
08: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
10: 0x0000 0x0001 0x0d40 0x0003 0x0003 0xdab6 0x0000 0x0000
18: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000

If I write 0x1340 to the BMCR, nothing happens on the media side - it
remains linked with the switch the RJ45 cable is plugged in to, which
means nothing happened on the media side.

> 2. There are some 1000Base-T PHYs, such as VSC8234 (which I know from
>    first-hand experience, in fact there's even a comment in
>    felix_vsc9959.c about it), which restart their MDI-side AN when they
>    detect a transition of the system side from data mode to
>    configuration mode [ initiated by the MAC ].
>    Is this behavior implied by any standard (probably IEEE)? That I
>    didn't check. Is this behavior also at least consistent with the
>    non-SFP SGMII Atheros PHYs I have? I didn't check that either.
>    Anyway, food for thought.

The first thing to straighten out in your comment above is that SGMII
is a Cisco modification of IEEE 802.3 1000BASE-X.  SGMII has not been
incorporated into IEEE 802.3.

I'm going to start with a description of the two - which will aid the
later explanation, so please bear with me.

1000BASE-X deals with gigabit ethernet over Fibre media - and what you
have there (from a practical point, rather than the ISO levels that
are shown in IEEE 802.3) is:

MAC <-> PCS <-> Serdes <-> Optical media <-> Serdes <-> PCS <-> MAC

Each PCS transmits the abilities of its respective end, and receives
the abilities from the remote end. The abilities consists only of
duplex and pause modes, since speed is fixed at gigabit.  Negotiation
can be restarted by either end.

Cisco SGMII took this, and decided to make several modifications to
support a PHY instead of optical media, the most important being:

1) addition of symbol replication for 100M and 10M over the gigabit
   path without changing the bitrate of the path.
2) changed the contents of the configuration word to allow the PHY
   to inform the MAC of the current speed and duplex.

So we end up with:

MAC <-> PCS <-> Serdes <-> PHY <-> Media ...

Given that this is the case, IEEE 802.3 does not cover this setup -
having a PHY attached is beyond the 1000BASE-X specification that
it covers.  So there is nothing in there to mandate that a SGMII PHY
should restart its media side negotiation due to the SGMII side
restarting.

If it were required, it would be in the Cisco SGMII specification. As
it doesn't even make explicit mention of restarting the SGMII exchange
from the MAC end, I really doubt that it would make any comment about
a restart of the SGMII exchange restarting the media side.

So, we're down to the vaguaries of the various PHY manufacturers.

As I've shown, Atheros AR803x do not restart their media side on SGMII
side "negotiation" events.  I've just tested with the Marvell 88E1111,
which is probably the most popular PHY for copper gigabit SFPs out
there, and that also does not restart the media side either.

As for VSC8234, the comment you refer to is:

	Some PHYs like VSC8234 don't like it when AN restarts on
	their system side and they restart line side AN too, going
	into an endless link up/down loop.

However, without knowing in detail what is happening on the SGMII link,
it would be difficult to really know what is going on. It could be that
the implementation in the PHY is fine but has this additional vendor
feature, but the host side always triggers a second exchange of the
configuration word each time that the PHY notifies the MAC PCS of an
updated configuration word.  It could also be a misfeature of the PHY
itself.

It is possible to detect which mode the VSC8234 PHY is in when
connected to the Lynx PCS by looking at the link-partner advertisement
register (register 5) when an AN exchange has completed. Bit 0 is a good
indicator whether the PHY is operating in SGMII mode (1) or 1000BASE-X
mode (0).

There is another possibility, however.  That is the VSC8234 is not in
SGMII mode, but is in 1000BASE-X.  I'm aware of some copper SFPs that
use 1000BASE-X rather than SGMII, where the advertisement from the MAC
PCS to the SFP affects the media side duplex and pause advertisement,
and so any change on the host side causes the media side to restart.
It is, however, unlikely that a PHY configured in 1000BASE-X will be
able to complete negotiation with a host in SGMII mode - the duplex
bits will both be zero leading to an invalid resolution.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
