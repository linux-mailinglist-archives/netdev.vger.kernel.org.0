Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0547746A6BF
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348774AbhLFUWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbhLFUWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:22:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A95C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yFo3GFJiCOixATwkO4rELaD/uVOTyTWW+cOrVpoynD8=; b=NulCrdTVyDom17526kqtv6hm5N
        kIgA9Qet1KXBt8+OBBiB0ULV8lif/05+1hoQC+SNnrqq16KEolX4a8Y3k6wGXqrH+txBEeFbGNImb
        o3QTEb+zyF6vJoKIoo8cxRANN1YwIRfK5ahTBGIMBAO+C7hWeccPsftEst/B00vKVD4YeZRhpwGpM
        vB955cQLZY4tvmUkI3dJ0ArURsJ103SPWA0LLLebPAQ77DKtwZL90is59iAbNDoG9v4PxCVSn1PWc
        1MCBq3bbjzVwBRpjVRlwKGKeDGQWP/OmyufTGnm3daMQ5aUPJaDdLY+nUFvQ7h3lLRhJjzcyzNMBv
        s4XVDfvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56112)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muKRS-0005H9-RP; Mon, 06 Dec 2021 20:18:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muKRS-0004cG-DW; Mon, 06 Dec 2021 20:18:30 +0000
Date:   Mon, 6 Dec 2021 20:18:30 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
References: <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
 <20211206200111.3n4mtfz25fglhw4y@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206200111.3n4mtfz25fglhw4y@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:01:11PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 08:53:46PM +0100, Andrew Lunn wrote:
> > So i suspect something is missing when phylink sometime later does
> > bring the interface up. It is not fully undoing what this down
> > does. Maybe enable the dev_dbg() in mv88e6xxx_port_set_link() and see
> > what value it has in both the good and bad case?
> 
> Andrew, here is mv88e6xxx_mac_link_down():
> 
> 	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
> 	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
> 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
> 		err = ops->port_sync_link(chip, port, mode, false);
> 
> and here is mv88e6xxx_mac_link_up():
> 
> 	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
> 	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
> 	    mode == MLO_AN_FIXED) {
> 		(...)
> 		if (ops->port_sync_link)
> 			err = ops->port_sync_link(chip, port, mode, true);
> 
> This is the CPU port from Martyn's device tree:
> 
> 	port@4 {
> 		reg = <4>;
> 		label = "cpu";
> 		ethernet = <&switch_nic>;
> 		phy-handle = <&switchphy4>;
> 	};
> 
> It has an internal PHY, so mv88e6xxx_phy_is_internal() will return true.
> True negated is false, so the AND with the other PPU condition is always
> false. BUT: the logic is: "force the link IF it doesn't have an internal
> PHY OR it is a fixed link".
> 
> DSA fabricates a mv88e6xxx_mac_link_down call with MLO_AN_FIXED. So
> ->port_sync_link is called with false even if the PHY is internal, due
> to the right hand operand to the || operator.
> 
> Then the real phylink, not the impersonator, comes along and calls
> mv88e6xxx_mac_link_up with MLO_AN_PHY. The same check is now not
> satisfied, because the input data has changed!
> 
> If we're going to impersonate phylink we could at least provide the same
> arguments as phylink will.

What is going on here in terms of impersonation is entirely reasonable.

The only things in this respect that phylink guarantees are:

1) The MAC/PCS configuration will not be substantially reconfigured
   unless a call to mac_link_down() was made if a call to mac_link_up()
   was previously made.

2) The arguments to mac_link_down() will be the same as the preceeding
   mac_link_up() call - in other words, the "mode" and "interface".

Phylink does *not* guarantee that a call to mac_link_up() or
mac_config() will have the same "mode" as a preceeding call to
mac_link_down(), in the same way that "interface" is not guaranteed.
This has been true for as long as we've had SFPs that need to switch
between MLO_AN_INBAND and MLO_AN_PHY - e.g. because the PHY doesn't
supply in-band information.

So, this has uncovered a latent bug in the Marvell DSA code - and
that is that mac_config() needs to take care of the forcing state
after completing its configuration as I suggested in my previous
reply.

There is also the question whether the automatic fetching of PHY
status information by the hardware should be regarded as a form of
in-band by phylink, even though it isn't true in-band - but from
the software point of view, the PPU's automatic fetching is not
materially different from what happens with SGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
