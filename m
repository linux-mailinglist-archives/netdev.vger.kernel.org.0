Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DBF2B9591
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgKSOzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgKSOzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:55:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6D7C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X/tuZ3qCYU6i+8iH3SvrLFZREiCgObeJQ5rd89C2IkE=; b=fZ45m8HhuFvLssAMeW0vhrkps
        Yzqsv0RPvGDrHEGaA9xmY48r1SMmHKyKZm3jQC6YTMPCcuTKkSK3IA5+jpBQidbI0nb0zbLeicXed
        wMlKXcnDXJgZzXCgxpBKrB5f9d+G7uzJCzx+QiUXowW63Jse4ojxPHjCZivf1+dKSpY7F++PwHDeR
        mHkGDn9vYz+Lxob+cOGl3EG52NjFkTPgJgytN5Oxm0CAyeqK0iTGqfkCQuccfeysa+UIr2qPkol4k
        TCvV27+xqHc3bHd0vn9IPDJ99BfhCJj1hzGA+p1yeW+KRwsGRkB26OUvm0yiuV2FRBobbYsQOsLVg
        l48qcqv8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33438)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kflKw-0002Jm-8y; Thu, 19 Nov 2020 14:55:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kflKu-0002Ca-V4; Thu, 19 Nov 2020 14:55:00 +0000
Date:   Thu, 19 Nov 2020 14:55:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201119145500.GL1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119152246.085514e1@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:46PM +0100, Maxime Chevallier wrote:
> Hello everyone,
> 
> I'm reaching out to discuss an issue I'm currently having, while working
> on a Marvell 88E1543 PHY.
> 
> This PHY is very similar to the 88E1545 we already support upstream, but
> with an added "dual-port mode" feature that I'm currently using in a
> project, and that might be interesting to have upstream.
> 
> As a quick remainder, the 88E154x family are 4-ports PHYs that support
> Fiber (SFP) or RJ45 Copper interfaces on the media side, and QSGMII/SGMII
> on the host side.
> 
> A datasheet for this PHY family can be found here [1] but unfortunately,
> this public datasheet doesn't explain the mode I'm going to discuss...
> 
> The specificity of the 88E1543 is that is can be configured as a 2-port
> PHY, each port having the ability to have both a Copper RJ45 interface and
> a Fiber interface with automatic media detection, very much like the
> 88x3310 that we support, and that is used on the MacchiatoBin.
> 
> This auto-media detection is the specific mode i'm interested in.
> 
> The way this works is that the PHY is internally configured by chaining
> 2 internal PHYs back to back. One PHY deals with the Host interface and
> is configured as an SGMII to QSGMII converter (the QSGMII is only used
> from within the PHY), and the other PHY acts as the Media-side PHY,
> configured in QSGMII to auto-media (RJ45 or Fiber (SFP)) :
> 
>                 +- 88e1543 -----------------------+
> +-----+         | +--------+          +--------+  |  /-- Copper (RJ45)
> |     |--SGMII----| Port 0 |--QSGMII--| Port 1 |----<
> |     |         | +--------+          +--------+  |  \--- Fiber
> | MAC |         |                                 |
> |     |         | +--------+          +--------+  |  /-- Copper (RJ45)
> |     |--SGMII----| Port 2 |--QSGMII--| Port 3 |----<
> +-----+         | +--------+          +--------+  |  \-- Fiber
>                 +---------------------------------+

Yes, this is somewhat like the 88x3310 - the 88x3310 PHY is actually a
collection of different PHY blocks integrated together, with a chunk of
firmware controlling the whole thing, enabling the appropriate PHY
blocks and routing the data paths amongst them as required.

With the 88x3310, we don't care very much about the MAC-facing blocks
(PHYXS in Clause 45 terminology). We certainly do not check the PHYXS
for link before reporting that the PHY as a whole has link - this is
actually very important, since with the 88x3310, we have to report to
the MAC that the link is up so the MAC can configure its PHY facing
interface correctly before that part of the link will come up.

Also, if we look at 88e1512 when used in SGMII to copper mode, this
PHY re-uses its fiber side for the MAC facing SGMII interface, so can
be regarded similar to your above diagram.

So, a question for you: does the above setup for ports 0 and 2 require
any software configuration of the PHY, or is that all achieved by
hardware strapping the PHY for the appropriate mode?

If it's all done by hardware strapping with no software configuration
requirement for ports 0 and 2, I would suggest that we ignore the
complexities here, and just represent ports 1 and 3 as normal, as a
SGMII-to-{copper,fibre}.

If we were to let phylib to drive ports 0 and 2 as well, we're going
to introduce a whole raft of entirely new problems. phylib is only
really designed for the last-step media facing PHY.

> I have two main concerns about how to deal with that (if we are interested
> in having such a support upstream at all).
> 
> The first one, is how to represent that in the DT.
> 
> One approach could be to really represents what's going on, by representing
> the 2 PHYs chained together. In this case, only the MAC-facing PHY
> will report the link state, so we are basically representing the internal
> wiring of the PHY, can we consider that as a description of the hardware ?
> 
> Besides that, I don't think that today, we are able to represent link
> composed of multiple PHYs daisy-chained together, but this is something
> that we might want to support one day, since it could benefit other types
> of use-cases.
> 
> Another approach could be to pretend the 88E1543 is a 2-port SGMII to
> Auto-media PHY. This is also a bit tricky, since we need a way to detect
> that we want the whole 4-ports PHY to act as a 2-port PHY. (or 3-port, if
> we only want to use one pair of ports in that mode, and the other ports
> as SGMII - Copper or SGMII - Fiber PHYs).

Aren't each of the four ports at a different MDIO address, which means
each has to be described separately?

> The second concern I have is that all of this is made even harder by the
> fact that this 88E1543 PHY seems indistinguishable from the 88E1545 by
> reading the PHY ID, they both report 0x01410eaX :/ I guess we would also
> need some DT indication that we are in fact dealing with a 88E1543.
> 
> So I'd like you opinions on how we might want to deal with such scenarios,
> and if we do want to bother supporting that at all :(
> 
> Thanks in advance,
> 
> Maxime
> 
> [1] :
> https://www.marvell.com/content/dam/marvell/en/public-collateral/transceivers/marvell-phys-transceivers-alaska-88e154x-datasheet.pdf
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
