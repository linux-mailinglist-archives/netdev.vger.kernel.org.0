Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F4320AA
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFAULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 16:11:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52298 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfFAULC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 16:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j6seBH5nwaDlQJNR3CpPDhbn7MofJMRie3jxnSZGW2A=; b=JwdnhwUnpcVSW+HJQAB4uoQg3
        72X9mIXxVs23Vyqou5ML+wmK/4/8BMQYQK5vuXlXr84qqUTci5uXhKKfTZ+cFSRjdOc+/p2ULX+cR
        CoxoSIV80s9GX7LiLKHL0prIMvZeitbJnYb9j7S7Mg8vAp1ldMohzOOfhwXB7mCfA2qsdm78qeOip
        zyuBU2Z6w/VMYf10K3necEzFNd4v3grJ6rlK+Q9gmnbRQPCso1MghyB6lzyK8xt+uTYr00ixaoI0Y
        poNWQXbCOJyLAL93MmB+w2QUZQgX/UP7Ir+PtHwJbnlbocZrHymWQpPAIUanocaotY23jXKKFgZ32
        hHe4XoJMg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38448)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hXALC-0000m8-C1; Sat, 01 Jun 2019 21:10:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hXALA-0007YZ-1h; Sat, 01 Jun 2019 21:10:56 +0100
Date:   Sat, 1 Jun 2019 21:10:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY in
 fixed or 802.3z mode
Message-ID: <20190601201055.isqcqj4psps3fafr@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
 <20190531203131.skdlic6ub2esyw3o@shell.armlinux.org.uk>
 <1cb5994f-cb70-e2ec-7f72-2e7828813150@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cb5994f-cb70-e2ec-7f72-2e7828813150@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 06:33:32PM -0600, Robert Hancock wrote:
> On 2019-05-31 2:31 p.m., Russell King - ARM Linux admin wrote:
> > On Fri, May 31, 2019 at 01:18:05PM -0600, Robert Hancock wrote:
> >> The Xilinx AXI Ethernet controller supports SFP modules in 1000BaseX
> >> mode in a somewhat unusual manner: it still exposes a PHY device which
> >> needs some PHY-level initialization for the PCS/PMA layer to work properly,
> >> and which provides some link status/control information.
> >>
> >> In this case, we want to use the phylink layer to support proper
> >> communication with the SFP module, but in most other respects we want to
> >> use the PHY attached to the controller.
> >>
> >> Currently the phylink driver does not initialize or use a controller PHY
> >> even if it exists for fixed-link or 802.3z PHY modes, and doesn't
> >> support SFP module attachment in those modes.
> > 
> > Sorry, I'm having a hard time following this description.  Please draw
> > an ASCII diagram of the setup you have - a picture is worth 1000 words,
> > and I think that is very much the case here.
> >
> > We do have boards where the SFP is connected to a real PHY, where the
> > real PHY offers a RJ45 copper socket and a fiber interface,
> > automatically switching between the two.  In this case, we do not
> > use phylink to represent the link between the PHY and the SFP cage,
> > but instead the PHY binds directly to the SFP cage.
> >
> 
> It sounds like the setup you're describing has the PHY being smarter and
> doing more of the SFP module handling internally. In our setup, the
> situation is something like this:
> 
> Xilinx MAC		I2C	GPIO
> |
> |GMII			|	|
> |			|	|
> Xilinx PHY		|	|
> |			|	|
> |1000BaseX		|	|
> |			|	|
> SFP -----------------------------

That is very similar, except the Marvell 88x3310 uses a 10GBASE-R
protocol to a SFP+ module, but can be switched to either SGMII or
1000BASE-X mode (neither of which we currently support, but work is
in progress, if it turns out that these boards with strong pullups
can work with SFP modules.)

With the 88x3310, I have a couple of patches that "bolt on" to the
PHY driver, so we end up with this setup from the DT, kernel and
hardware point of view:

                 ,-----> Copper RJ45
   MAC -----> PHY
                 `-----> SFP

Hence, the PHY driver is responsible for registering itself as an
"upstream" of the SFP cage without involving phylink - phylink gets
used for the MAC <-> PHY part of the connection.

There's an awkward problem though: the PHY driver doesn't really have
much clue whether the network interface is up or down, which SFP
really needs to know so it can control whether the SFP module's laser
is emitting or not.  One of the patches tweaks the phylink code to
pass this information over to the SFP cage, around phylib, but the
proper solution would be for phylib to propagate that information to
the phylib driver, so that it can in turn pass that on to the SFP cage.

However, there's a slightly bigger problem looming here, which is that
phylib and the network layers in general do _not_ support having two
PHYs actively bound to one network interface, and without radically
reworking phylib and how phylib is bolted into the network layer, that
is not easy to get around.

> So in this case the Xilinx PHY is just really doing PCS/PMA, etc.
> conversions. The I2C and GPIO lines for the SFP socket are routed back
> to the host separately and the Xilinx PHY has no interaction with them
> (other than that I believe the LOS signal from the SFP socket is
> connected into the PHY to provide some link status indication back to it).

So, very similar situation as on the Macchiatobin with the 88x3310
PHYs.

> In this setup, phylink is basically allowing us to communicate with the
> SFP module over I2C and manage the LOS, TX enable, etc. control lines
> properly, but the Xilinx PHY does need to be initialized as well for the
> actual link traffic to pass through.

I think what you're missing is that the design is a layered one.
All the SFP cage stuff is interfaced through the sfp layer, and is
made accessible independently via the sfp-bus layer (which is needed
to avoid sfp being a hard dependency for the MAC driver - especially
important when we have SoCs such as Armada 8040 where one hardware
module provides multiple network ports.)

phylink provides a mechanism to separate PHYs from the MAC driver
such that we can hot-plug PHYs (necessary for the PHYs on SFP modules),
and deal with dynamically reconfiguring the MAC's hardware interface
mode according to what the module supports.  It isn't intended to
always be closely bound to the SFP cage side.

One of the reasons we have this design is because the early boards I
had access to when designing this setup were direct MAC to SFP cage
setups - there was no intermediate PHY.  Then came the Macchiatobin
board which does have a PHY, which brings with it additional
complexities, but various hardware problems have stood in the way of
having SFP modules in the 10G slots.

> In our case the controller is supporting 1000BaseX only and is mainly
> intended for fiber modules. We do want to be able to get copper modules
> to work - obviously only ones that are set up for 1000BaseX mode are
> possible.

So, what I say below applies:

> > If the former, then I'm pretty certain you're going about it the wrong
> > way - as I've said before, there is nothing in the EEPROM that
> > indicates definitively what format the control word is (and therefore
> > whether it is SGMII or 1000base-X.)
> > 
> > Some network controllers may be able to tell the difference, but that
> > is not true of all controllers.
> > 
> > The only way I can see to support such modules would be to have a table
> > of quirks to set the interface mode accordingly, and not try this "lets
> > pick one, try to validate it with the network controller, otherwise try
> > the other."
> > 
> > In any case, the format of the connection between the SFP module and
> > the network controller isn't one that should appear in the ethtool link
> > modes - I view what you've done there as a hack rather than proper
> > design.

I do have the beginnings of a quirk system for the sfp-bus layer,
since I've been conversing with someone with a GPON module that
does appear to follow the SFP MSA, in particular with regard to the
time it takes the module to start responding on I2C, and in regard
of the speeds it actually supports (basically, the EEPROM is
misleading.)  So, that should be useful for you as well.

http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=phy

is my playground of patches for SFP, which are in various stages of
maturity, some which have been posted for inclusion (and merged)
others that have been waiting some time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
