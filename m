Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21146AA6F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351600AbhLFVbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348959AbhLFVbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:31:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277EAC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SODSJEdWeiaN5N92rw2Jc+mX4AQ8pYsz+IwYygV/Mvo=; b=gczA89bG81EjVmFTqtWiF7CxW7
        i0elng7me0QTzMuCsa2MZLoZryeT/JPLRzm74KlsxBXtyphTn3DBxzVFJ6dgZZJIuDvdd8UQdcHGx
        ngWW22ZiVNVkl7J2rs9bao+u7vs3nfJLCvcnsTXZhHRGp2YP92aLt4TKBTz9JksgkJ4pxNJAenvZG
        k0oTqt4l34KHCd8QXGuzNH3OWL8z3GUPUAmfV0jjLa5QZls8mK/S03X8RtaQoVZOnxupKsgfltOr6
        faA0fdC/lUhVga939OcGbtxwYCrAP+8R8uE4Fs+/Be8v+CWW/5QncfWmU6cdEnMFg0mSMfiF5a6AN
        ORafLCMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56116)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muLWI-0005N9-Lb; Mon, 06 Dec 2021 21:27:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muLWH-0004fQ-Mb; Mon, 06 Dec 2021 21:27:33 +0000
Date:   Mon, 6 Dec 2021 21:27:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
References: <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206211341.ppllxa7ve2jdyzt4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 11:13:41PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 08:51:09PM +0000, Russell King (Oracle) wrote:
> > With a bit of knowledge of how Marvell DSA switches work...
> > 
> > The "ppu" is the PHY polling unit. When the switch comes out of reset,
> > the PPU probes the MDIO bus, and sets the bit in the port status
> > register depending on whether it detects a PHY at the port address by
> > way of the PHY ID values. This bit is used to enable polling of the
> > PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
> > set for all internal PHYs unless we explicitly turn it off (we don't.)
> > Therefore, this is a reasonable assumption to make.
> > 
> > So, given that mv88e6xxx_port_ppu_updates() is most likely true as
> > I stated, it is also true that mv88e6xxx_phy_is_internal() is
> > "don't care".
> 
> And the reason why you bring the PPU into the discussion is because?
> If the issue manifests itself with or without it, and you come up with a
> proposal to set LINK_UNFORCED in mv88e6xxx_mac_config if the PPU is
> used, doesn't that, logically speaking, still leave the issue unsolved
> if the PPU is _not_ used for whatever reason?
> The bug has nothing to do with the PPU. It can be solved by checking for
> PPU in-band status as you say. Maybe. But I've got no idea why we don't
> address the elephant in the room, which is in dsa_port_link_register_of()?

I think I've covered that in the other sub-thread.

It could be that a previous configuration left the port forced down.
For example, if one were to kexec from one kernel that uses a
fixed-link that forced the link down, into the same kernel with a
different DT that uses PHY mode.

The old kernel may have called mac_link_down(MLO_AN_FIXED), and the
new kernel wouldn't know that. It comes along, and goes through the
configuration process and calls mac_link_up(MLO_AN_PHY)... and from
what you're suggesting, because these two calls use different MLO_AN_xxx
constants that's a bug.

An alternative: the hardware boots up with the link forced down. The
boot loader doesn't touch it. The kernel boots and calls
mac_link_up(MLO_AN_PHY).

This all works as expected with e.g. mvneta. It doesn't work with
Marvell DSA because we have all these additional extra exceptional
cases to deal with the PPU (which is what _actually_ transfers the
PHY status to the port registers for all PHYs.)

We used to just rely on the PPU bit for making the decision, but when
I introduced that helper, I forgot that the PPU bit doesn't exist on
the 6250 family, which resulted in commit 4a3e0aeddf09. Looking at
4a3e0aeddf09, I now believe the fix there to be wrong. It should
have made mv88e6xxx_port_ppu_updates() follow
mv88e6xxx_phy_is_internal() for internal ports only for the 6250 family
that has the link status bit in that position, especially as one can
disable the PPU bit in DSA switches such as 6390, which for some ports
stops the PHY being used and switches the port to serdes mode.
"Internal" ports aren't always internal on these switches.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
