Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0E346A8CF
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349848AbhLFUyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349840AbhLFUym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:54:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9D8C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1LVTjeLujLeiYhcFnj+yt1QKqhOras3NyFleWbCbrkE=; b=ts87I26KXNo0APjYNy5TkN8qIe
        zgY/gDTKlnea8Nxj06A/mx1HfVTiP/l/pnSWUvyTlqetsNhFo+Yl3llgWK+erjNAZBENKHhKsth0O
        GMOimd1bmwdoU2CxBmEKI51zk8xADaHtP96j51ydeFMc/HER5c47QeB7fuXsqKbDTqfQ7hbzBfX+w
        xRENGljYDKW527GENxdvAPVhH4wXWWvOHpBAEouiayLoo74W/6fkXtYP2OmG0PHIWmys10gn5cv78
        AEt2Coql8WlLKe4uRVxx5k/ggNIPLYcinoy4bf5zZ2U+h7VIlT+QJhwi6aPLq5d8KCOSZPb+RI587
        oGffs71Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56114)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muKx4-0005JY-Ss; Mon, 06 Dec 2021 20:51:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muKx3-0004eJ-TJ; Mon, 06 Dec 2021 20:51:09 +0000
Date:   Mon, 6 Dec 2021 20:51:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
References: <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206202308.xoutfymjozfyhhkl@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:23:08PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 08:07:45PM +0000, Russell King (Oracle) wrote:
> > My conclusion from having read this thread is the CPU port is using PPU
> > polling, meaning that in mac_link_up():
> > 
> >         if ((!mv88e6xxx_phy_is_internal(ds, port) &&
> >              !mv88e6xxx_port_ppu_updates(chip, port)) ||
> >             mode == MLO_AN_FIXED) {
> > 
> > is false - because mv88e6xxx_port_ppu_updates() returns true, and
> > consequently we never undo this force-down.
> 
> We know that
> 1. A == mv88e6xxx_phy_is_internal(ds, port), B == mv88e6xxx_port_ppu_updates(chip, port), C == mode == MLO_AN_FIXED
> 2. (!A && !B) || C == false. This is due to the effect we observe: link is not forced up
> 2. C == false. This is due to the device tree.
> 3. !A && !B == false. This is due to statement (2), plus the rule that if X || Y == false and Y == false, then X must also be false.
> 4. We know that A is true, again due to device tree: port 4 < .num_internal_phys for MV88E6240 which is 5.
> 5. !A is false, due to 4.
> 
> So we have:
> 
> false && !B == false.
> 
> Therefore "!B" is "don't care". In other words we don't know whether
> mv88e6xxx_port_ppu_updates() is true or not.

With a bit of knowledge of how Marvell DSA switches work...

The "ppu" is the PHY polling unit. When the switch comes out of reset,
the PPU probes the MDIO bus, and sets the bit in the port status
register depending on whether it detects a PHY at the port address by
way of the PHY ID values. This bit is used to enable polling of the
PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
set for all internal PHYs unless we explicitly turn it off (we don't.)
Therefore, this is a reasonable assumption to make.

So, given that mv88e6xxx_port_ppu_updates() is most likely true as
I stated, it is also true that mv88e6xxx_phy_is_internal() is
"don't care".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
