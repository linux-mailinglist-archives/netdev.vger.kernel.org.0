Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46BB124F09
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLRRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:22:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48666 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfLRRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:22:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PGAXZ+Vpip6nYAOhE2+KlSwKXVViqLSOyUaBMKdPNnc=; b=uVReGQAmWjnGXjCN95nkj3hTO
        odvEfBsLrMNwboubDJTWSsww2Cs+AHyxyeB0oeP8dq7ZuKEAuPT/1RXfFMR6Rjwk1q5nlR8luljfG
        x8/QUKPSJFlP51c52foxAPS27gAAr1kLSraGTw6ToWD6SzVxefKyEnOsR96HCQMV9aS+ZOcai0/K7
        cQwVw0mc0L4XCfO5iu9vbWNLGPutUsYxQFj/ngeTtcV97K1+xxImY5LwFokbK9blqVg2XAqGLa2Dy
        yC73IYxOMVe0iA9ikDRW/8GI5Ij0daizD+LD9NW2qjRTg3H9XsK9dGkNyEx2d5ckYV4pyygPezUfY
        gCC7LfHHw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50576)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihd21-0005P2-3b; Wed, 18 Dec 2019 17:22:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihd1w-0004YD-I1; Wed, 18 Dec 2019 17:22:36 +0000
Date:   Wed, 18 Dec 2019 17:22:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandru Marginean <alexandru.marginean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Message-ID: <20191218172236.GV25745@shell.armlinux.org.uk>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191218104008.GT25745@shell.armlinux.org.uk>
 <CA+h21hrbqggYxzd6SGhBmy3fUbmG2EFqbOHAnkDu8xPYRP7ewg@mail.gmail.com>
 <20191218132942.GU25745@shell.armlinux.org.uk>
 <e199162b-9b90-0a90-e74e-3b19e542f710@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e199162b-9b90-0a90-e74e-3b19e542f710@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 03:00:41PM +0000, Alexandru Marginean wrote:
> On 12/18/2019 2:29 PM, Russell King - ARM Linux admin wrote:
> > On Wed, Dec 18, 2019 at 03:21:02PM +0200, Vladimir Oltean wrote:
> >> - The at803x.c driver explicitly checks for the ACK from the MAC PCS,
> >> and prints "SGMII link is not ok" otherwise, and refuses to bring the
> >> link up. This hurts us in 4.19 because I think the check is a bit
> >> misplaced in the .aneg_done callback. To be precise, what we observe
> >> is that this function is not called by the state machine a second,
> >> third time etc to recheck if the AN has completed in the meantime. In
> >> current net-next, as far as I could figure out, at803x_aneg_done is
> >> dead code. What is ironic about the commit f62265b53ef3 ("at803x:
> >> double check SGMII side autoneg") that introduced this function is
> >> that it's for the gianfar driver (Freescale eTSEC), a MAC that has
> >> never supported reprogramming itself based on the in-band config word.
> >> In fact, if you look at gfar_configure_serdes, it even configures its
> >> register 0x4 with an advertisement for 1000Base-X, not SGMII (0x4001).
> >> So I really wonder if there is any real purpose to this check in
> >> at803x_aneg_done, and if not, I would respectfully remove it.
> > 
> > Please check whether at803x will pass data if the SGMII config exchange
> > has not completed - I'm aware of some PHYs that, although link comes up
> > on the copper side, if AN does not complete on the SGMII side, they
> > will not pass data, even if the MAC side is forced up.
> > 
> > I don't see any configuration bits in the 8031 that suggest the SGMII
> > config exchange can be bypassed.
> > 
> >> - The vsc8514 PHY driver configures SerDes AN in U-Boot, but not in
> >> Linux. So we observe that if we disable PHY configuration in U-Boot,
> >> in-band AN breaks in Linux. We are actually wondering how we should
> >> fix this: from what you wrote above, it seems ok to hardcode SGMII AN
> >> in the PHY driver, and just ignore it in the PCS if managed =
> >> "in-band-status" is not set with PHYLINK. But as you said, in the
> >> general case maybe not all PHYs work until they haven't received the
> >> ACK from the MAC PCS, which makes this insufficient as a general
> >> solution.
> >>
> >> But the 2 cases above illustrate the lack of consistency among PHY
> >> drivers w.r.t. in-band aneg.
> > 
> > Indeed - it's something of a mine field at the moment, because we aren't
> > quite sure whether "SGMII" means that the PHY requires in-band AN or
> > doesn't provide it. For the Broadcom case I mentioned, when it's used on
> > a SFP, I've had to add a quirk to phylink to work around it.
> > 
> > The problem is, it's not a case that the MAC can demand that the PHY
> > provides in-band config - some PHYs are incapable of doing so. Whatever
> > solution we come up with needs to be a "negotiation" between the PHY
> > driver and the MAC driver for it to work well in the known scenarios -
> > like the case with the Broadcom PHY on a SFP that can be plugged into
> > any SFP supporting network interface...
> 
> Some sort of capability negotiation does seem to be the proper solution.
> We can have a new capabilities field in phydev for system interface 
> capabilities and match that with MAC capabilities, configuration, factor 
> in the quirks.  The result would tell if a solution is possible, 
> especially with quirky PHYs, and if PHY drivers need to enable AN.
> 
> Until we have that in place, any recommended approach for PHY drivers, 
> is it acceptable to hardcode system side AN on as a short term fix?
> I've just tested VSC8514 and it doesn't allow traffic through if SI AN 
> is enabled but does not complete.  We do use it with AN on on NXP 
> systems, and it only works because U-Boot sets things up that way, but 
> relying on U-Boot isn't great.
> Aquantia PHYs we use also require AN to complete if enabled.  For them 
> Linux depends on U-Boot or on PHY firmware to enable AN.  I don't know 
> if anyone out there uses these PHYs with AN off.  Would a patch that 
> hardcodes AN on for any of these PHYs be acceptable?

I'm not sure why you're talking about hard-coding anything. As I've
already mentioned, phylink allows you to specify today whether you
want to use in-band AN or not, provided the MAC implements it as is
done with mvneta and mvpp2.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
