Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0431446BF45
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhLGPbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhLGPbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:31:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B4C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sl+n4v5IEj4OXUIpB0YBUWHl85O8P7qXjD2vgwmoeIk=; b=ePvGEAfcvyGdXOhv/5eY3OuZE2
        R+qmDJPuQZDlLhZ/H/bktAT9kMa2XLh9LXDNnu3AD88AbGelQFMniuauJfgd3p808h5YZa2qZFVZK
        ZWnlmsFkUHDVN/noe6PM5QfbAqa+drqD0xwDSuzCHG1q3xKnUBT6ry1HkB7SdJNKSJ2vqit+mgaak
        XNgvHHI8rto6DDV2gdt8on3XljrIjnnyXK+zTPWL6BALuPSSuCjqIKVU/ekqvYO2v2Qrify0v1CUD
        nsHpw7zc2vsXaV/25Ej7uA7akLcBZZE8rS4Wb66g5ojTQYz5KyR9DhMUyeKAQ+ZTdPEvFX/U3tTTO
        1qSsyOMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56164)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mucO1-0006NJ-Bv; Tue, 07 Dec 2021 15:28:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mucNz-0005RW-NH; Tue, 07 Dec 2021 15:28:07 +0000
Date:   Tue, 7 Dec 2021 15:28:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya99h4RmUMmqYrSR@shell.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
 <Ya91rX5acIKQk7W0@lunn.ch>
 <Ya92klnTqoUpFvpo@shell.armlinux.org.uk>
 <Ya94roatTK0y7t70@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya94roatTK0y7t70@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 04:07:26PM +0100, Andrew Lunn wrote:
> On Tue, Dec 07, 2021 at 02:58:26PM +0000, Russell King (Oracle) wrote:
> > On Tue, Dec 07, 2021 at 03:54:37PM +0100, Andrew Lunn wrote:
> > > On Tue, Dec 07, 2021 at 10:59:19AM +0000, Russell King (Oracle) wrote:
> > > > Martyn Welch reports that his CPU port is unable to link where it has
> > > > been necessary to use one of the switch ports with an internal PHY for
> > > > the CPU port. The reason behind this is the port control register is
> > > > left forcing the link down, preventing traffic flow.
> > > > 
> > > > This occurs because during initialisation, phylink expects the link to
> > > > be down, and DSA forces the link down by synthesising a call to the
> > > > DSA drivers phylink_mac_link_down() method, but we don't touch the
> > > > forced-link state when we later reconfigure the port.
> > > > 
> > > > Resolve this by also unforcing the link state when we are operating in
> > > > PHY mode and the PPU is set to poll the PHY to retrieve link status
> > > > information.
> > > > 
> > > > Reported-by: Martyn Welch <martyn.welch@collabora.com>
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > 
> > > Hi Russell
> > > 
> > > It would be good to have a Fixes: tag here, to help with back porting.
> > 
> > Oh, I thought this was a new development, not a regression. Do you have
> > a pointer to the earlier bits of the thread please, e.g. the message ID
> > of the original report.
> 
> This all seems to be part of:
> 
> b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com
> 
> It looks like 5.15-rc3 has issues, but i suspect it goes back further.
> I'm also assuming it is a regression, not that it never worked in the
> first place. Maybe i'm wrong?

Thanks.

It looks like DT support for this was added in e26dead44268, which is
in v4.16-rc1.

The introduction of the phylink_mac_link_down() in net/dsa/port.c was
in 3be98b2d5fbc, v5.7-rc2, as was the addition of MLO_AN_FIXED in
mv88e6xxx DSA link down/up functions in 34b5e6a33c1a (these are
consecutive commits.)

Thankfully, the addition of mv88e6xxx_port_ppu_updates was in v5.7-rc1.

Now, this patch can't simply be backported without the update to
mv88e6xxx_port_ppu_updates(), so I feel we need to invent a Requires:
or Depends: tag so stable people don't backport this without the other
patch - my recent experience with stable is that patches get picked up
quite randomly.

I think I'd be tempted to go with:

Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")

I think we also need:

Cc: <stable@vger.kernel.org> # v5.7-rc2: xxxxx: net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"

which seems to be a thing according to stable-kernel-rules.rst...
with the xxxxx replaced with the proper sha1 ID once the dependent
patch has been applied to the net tree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
