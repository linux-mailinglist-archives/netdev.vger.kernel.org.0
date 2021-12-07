Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CC946AF83
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378885AbhLGBBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbhLGBBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:01:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D3FC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6nVNHRglR06T7hB2GVJ22utosOGPxI8z9KkfUMqAdDA=; b=BXCnrcRi2GB0dWNPt0RGwuAg30
        fXr/ZmwuzoaN88O24cGPD1jP+gOjX0oQfLsF+tlmwJsMMgsgpTp1nlPVmsAhsowD+AIqQpfKBXHWl
        d9rp+DiLN7xO29jfOzh+4g/BFWHDAG25rikQQBtSeTjmulnQddIUd39uQNnePtWkV4z+k+EXqo96h
        LimmM43zI1t0vEHEoMRspnPWAyd9/0TsPMDoZufLNLerLFon+HQKJmzTLUwgR8zhc/4DXeEJgA0Hc
        zFZNyF0vnk9DdesLHeGtYpTtagBKQU6nOgs1m3U5PPc8uNvi/0gsTtBMFHc0LG4v+2exs2tnH6QqV
        Z5nMHGYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56132)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muOoI-0005bk-BQ; Tue, 07 Dec 2021 00:58:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muOoG-0004ot-2m; Tue, 07 Dec 2021 00:58:20 +0000
Date:   Tue, 7 Dec 2021 00:58:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
References: <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
 <20211206232735.vvjgm664y67nggmm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211206232735.vvjgm664y67nggmm@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 01:27:35AM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 09:49:37PM +0000, Russell King (Oracle) wrote:
> > On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> > > We used to just rely on the PPU bit for making the decision, but when
> > > I introduced that helper, I forgot that the PPU bit doesn't exist on
> > > the 6250 family, which resulted in commit 4a3e0aeddf09. Looking at
> > > 4a3e0aeddf09, I now believe the fix there to be wrong. It should
> > > have made mv88e6xxx_port_ppu_updates() follow
> > > mv88e6xxx_phy_is_internal() for internal ports only for the 6250 family
> > > that has the link status bit in that position, especially as one can
> > > disable the PPU bit in DSA switches such as 6390, which for some ports
> > > stops the PHY being used and switches the port to serdes mode.
> > > "Internal" ports aren't always internal on these switches.
> > 
> > Here's the situation I'm concerned about. The 88E6390X has two serdes
> > each with four lanes. Let's just think about one serdes. Lane 0 is
> > assigned to port 9 and lane 1 to port 4. We don't need to consider
> > any others.
> > 
> > If the PHY_DETECT bit (effectively PPU poll enable) is set for port 4,
> > which is an "internal" port, then the port is in auto-media mode, and
> > the PPU will poll the internal PHY and the serdes, and configure
> > according to which has link.
> >
> > If the PPU bit is clear, then the port is forced to serdes mode.
> > However, in this configuration, we end up with:
> > 
> > 	mv88e6xxx_phy_is_internal(ds, port) = true
> > 	mv88e6xxx_port_ppu_updates(chip, port) = false
> > 
> > which results in:
> > 
> >         if ((!mv88e6xxx_phy_is_internal(ds, port) &&
> >              !mv88e6xxx_port_ppu_updates(chip, port)) ||
> >             mode == MLO_AN_FIXED) {
> > 
> > being false since we have (!true && !false) || false. So, in actual
> > fact, when we have a PHY_DETECT bit, we _do_ need to take note of it
> > whether the port is "internal" or not. Essentially, that means that
> > for DSA switches that are not part of the 6250, we should be using
> > the PHY_DETECT bit.
> > 
> > For the 6250 family, the problem is that there's no PHY_DETECT bit,
> > and that's the link status. So I've started a separate discussion
> > with Maarten to find out which Marvell switch is being used and
> > whether an alterative approach would work for him.
> 
> I hope that you understand that it is getting very difficult for me to
> follow, especially when faced with contradictory information about
> hardware that I am not familiar with, and which may well be very
> different from one family to another for all I know.
> 
> Commit 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use PHY_DETECT on
> internal PHY's") says nothing about the 6250, and I have nothing through
> which I can cross-check your statement about the change only being
> applicable/needed for 6250.
> 
> The documentation I happen to have access to, which is for the 6097,
> says about "Forcing Link, Speed, Duplex in the MAC":
> 
> | These bits change the port's MAC mode only! It does not change the mode
> | of the PHY for ports where a PHY is connected. These bits are intended
> | to be used for the following situations only:
> | 
> | - When the PHY Polling Unit (PPU) is disabled on the port (PHYDetect
> |   equal to zero in Port offset 0x00) and software needs to copy the
> |   PHY’s Link, Speed and Duplex values to the port’s MAC (this is not
> |   required for internal PHYs as this information is communicated between
> |   the PHY and MAC even if the PPU is disabled on the port).
> | 
> | - When no PHY is connected to the port. This includes ports that connect
> |   to a CPU (typically using a digital interface like MII or GMII) and
> |   ports connected to another switch device (typically using a SERDES
> |   interface).  SERDES ports connected to a fiber module will get their
> |   Link from the port’s SDET pin and its Speed and Duplex is set to
> |   1000BASE full-duplex (assuming the Px_MODE has been set correctly –
> |   see the C_Mode bits, Port offset 0x00).
> 
> So the first paragraph is pretty clear to me: the PPU could be disabled
> (PHY_DETECT bit unset) and yet there would still be no reason to force
> the link for internal PHY ports. So the change still makes some level of
> sense to me, even if not for the cited reason from the commit message.
> 
> As for your auto-media comment, you say that on 6390X, port 4 is an
> auto-media port only if the PPU is enabled - otherwise it falls back to
> SERDES mode and not to internal PHY mode. Again, no way to cross-check,
> but so be it. The problem that you cite here is that we are in SERDES
> mode with PPU disabled, and that we should* (should we?) force the link,
> yet we don't, because the mv88e6xxx_phy_is_internal() function only
> conveys static information that doesn't properly reflect the current
> state of an auto-media port. The question is: did this use to work
> properly before the commit 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use
> PHY_DETECT on internal PHY's") that you mention? This is the same as
> asking: if the PPU is disabled on an auto media port, the old code (via
> your commit 5d5b231da7ac ("net: dsa: mv88e6xxx: use PHY_DETECT in
> mac_link_up/mac_link_down")) would always force the link. Is that ok for
> an internal PHY port? Is it ok for a fiber port with clause 37 in-band
> autoneg? More below.
> 
> * would it not matter whether this SERDES port is used in SGMII vs
>   1000base-X mode? According to the documentation I have access to, only
>   SGMII would need forcing without a PPU - see second quoted paragraph.
> 
> Anyway, so be it. Essentially, what is the most frustrating is that I
> haven't been doing anything else for the past 4 hours, and I still
> haven't understood enough of what you're saying to even understand why
> it is _relevant_ to Martyn's report. All I understand is that you're
> also looking in that area of the code for a completely unrelated reason
> which you've found adequate to mention here and now.

I hope you realise that _your_ attitude here is frustrating and
inflamatory. This is _not_ a "completely unrelated reason" - this
is about getting the right solution to Martyn's problem. I thought
about doing another detailed reply, but when I got to the part
about you wanting to check 6390X, I discarded that reply and
wrote this one instead. You clearly have a total distrust for
everything that I write in any email, so I just won't bother.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
