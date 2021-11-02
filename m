Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4C4439E3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKBXlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKBXlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 19:41:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111AC061714;
        Tue,  2 Nov 2021 16:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZHrRv9lRDnhzq0Dx7ta3YDH1jFpjaiR1Oe9RJjBQ2nk=; b=QMUCqtaR5NG5SISenJY5o1X1mu
        ovO4VVdO1Xb5uxYcUTjggnYBDDyDFtxds5lICBgAoVvBOzCloiPdyBiHSiuwzR0+/TY7H9sZMD7QX
        CadmBjPzaMZ34BvbwSPa0p8AjNf9UnTzRmLxY99vc2Avtd+Zwsk6OsaswRfMHkpyddtp1unYN9m/x
        vL7KG+LaAzpnF4747CXXrORkzjHQwOByo1amtlH4jdsvv3lml4oFNQf6Q8FxRA2M5Oygk/ZXfXCuR
        rr/0YW02HkBAAKKgTkF8tKXH46nI+wYlWR71R13hXIEca9upeUrT5NWRvyKQ5Rl4Tg25r4Mef5Mhd
        YwtaRr/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55448)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mi3MK-0004Og-Qz; Tue, 02 Nov 2021 23:38:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mi3MJ-0005nF-2q; Tue, 02 Nov 2021 23:38:27 +0000
Date:   Tue, 2 Nov 2021 23:38:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYHL82nNuh3ylXlq@shell.armlinux.org.uk>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <YYFx0YJ2KlDhbfQB@lunn.ch>
 <ff601233-0b54-b0ad-37ce-1c18f0b7ca47@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff601233-0b54-b0ad-37ce-1c18f0b7ca47@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 03:46:13PM -0400, Sean Anderson wrote:
> I have not found this to be the case. As soon as you need to access
> something using phylink, the emulated registers make the ioctls useless
> (especially because there may be multiple phy-like devices for one
> interface).

I think you're fundamentally misunderstanding something there.

If there is a PHY present, phylink presents no different an interface
from phylib - it does no emulation what so ever, and you can access any
address. I use this on Macchiatobin when researching the 88x3310 PHY. I
have a tool that allows me to view part of the register set in any MMD
in almost real-time - and I can access either of the two PHYs on the
xmdio bus from either of their network interfaces. Same for the clause
22 mdio bus. There is no emulation in this case, and you get full
access to the MDIO/XMDIO bus just like via phylib. There is absolutely
no difference.

If there is no PHY connected, then phylink will emulate the accesses
in just the same way as the fixed-phy support emulates accesses, and
in a bug-compatible way with fixed-phy. It only emulates for PHY
address 0. As there is no PHY, there is no MII bus known to phylink,
so it there is no MII bus for phylink to pass any non-zero address on
to.

Split PCS support is relatively new, and this brings with it a whole
host of issues:

1) the PCS may not be on a MII bus, and may not even have a PHY-like
   set of registers. How do we export that kind of setup through the
   MII ioctls?

2) when we have a copper SFP plugged in with its own PHY, we export it
   through the MII ioctls because phylink now has a PHY (so it falls
   in the "PHY present" case above). If we also have a PCS on a MII
   bus, we now have two completely different MII buses. Which MII bus
   do we export?

3) in the non-SFP case, the PHY and PCS may be sitting on different
   MII buses. Again, which MII bus do we export?

The MII ioctls have no way to indicate which MII bus should be
accessed.  We can't just look at the address - what if the PHY and PCS
are at the same address but on different buses?

We may have cases where the PHY and PCS are sitting on the same MII bus
- and in that case, phylink does not restrict whether you can access
the PCS through the MII ioctls.

Everything other case is "complicated" and unless we can come up with
a sane way to fit everything into two or more buses into these
antequated ioctls that are designed for a single MII bus, it's probably
best not to even bodge something at the phylink level - it probably
makes more sense for the network driver to do it. After all, the
network driver probably has more knowledge about the hardware around it
than phylink does.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
