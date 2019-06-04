Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A470E351FB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFDVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:36:31 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45910 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFDVga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e+1a2algu3HVP0zhb1JaWXTIGA5moOj+hZzfxYy5Fi8=; b=n/3VgjMZiCzSLLcozb330viyy
        zIcw7xfJglzky/tppYzOE0d53c+iP1fm62wbdI69Wbl22n21Z7Z5t95JZtt8eDGBYVG6eB2/g/BoB
        jlvvYeifWrQCxPY6ojAkndtBYlSRf6iESd4YbzWmluIvQdlwyDrUCfirbgyEOS3lJ6g2IN9vkfRug
        7dWVra5qf0BYjaOnHGfWESQVjrQgFjcvY9nX5PncvppfRBtloQ3plDetVrPXsLRk9yd8hWl/51LjY
        b5yRoKvH/wQcgZ8cvTKNTjV5H7v+7d04qqEkU3YTJJJGVxVowOAbxEB6eCHUZ5mrssSXiDgL7S3B3
        BuoNFhbjw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56200)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYH6Y-0003kC-Ji; Tue, 04 Jun 2019 22:36:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYH6W-0001oE-SR; Tue, 04 Jun 2019 22:36:24 +0100
Date:   Tue, 4 Jun 2019 22:36:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604213624.yw72vzdxarksxk33@shell.armlinux.org.uk>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
> Hi,
> 
> I've been wondering what is the correct approach to cut the Ethernet link
> when the user requests it to be administratively down (aka ip link set dev
> eth0 down).
> Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.

The first requirement is that phylink_start() is required to be called
in the ndo_open callback, and phylink_stop() is required to be called
in the ndo_stop callback - this is because when a SFP is used, it has
other effects beyond managing the PHY.

phylink_start() and phylink_stop() call the appropriately phylib
functions, and what happens to the PHY is up to phylib.

Whether a PHY has its link brought down or not is not set in stone:
some network cards, particularly those that do not use phylib, do not
bring the link down when the interface is brought down - doing so,
allows for (eg) a faster boot, and of course bringing an interface
up is faster if the link is already established.

Then there's the question about when the PHY is attached to the
network device.  Some drivers attach the PHY in their probe
function, others attach the PHY in their ndo_open method.  If the
PHY is attached in the ndo_open method, then the PHY must be
detached(disconnected) in the ndo_stop method - basically, ndo_stop
must reverse everything that ndo_open did.

> I see the ability to be able to put the PHY link administratively down a
> desirable feat. If it's left to negotiate/receive traffic etc while the MAC
> driver isn't completely set up and ready, in theory a lot of processing can
> happen outside of the operating system's control.

Normally the PHY receives traffic, and passes it to the MAC which
just ignores the signals it receives from the PHY, so no processing
beyond the PHY receiving the traffic happens.

Ultimately, whether you want the PHY to stay linked or not linked
is, imho, a policy that should be set by the administrator (consider
where a system needs to become available quickly after boot vs a
system where power saving is important.)  We don't, however, have
a facility to specify that policy though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
