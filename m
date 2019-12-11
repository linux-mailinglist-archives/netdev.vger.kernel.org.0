Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E34211A766
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfLKJha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:37:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38408 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfLKJha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 04:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vZ8AAeqCS6rZME8/pxpiwhUe7+fsvG83j4ZENf4+91w=; b=Jx77aYkh3ZMJ89+UQZY0pKA2v
        qTQwejWZVzdEPk3E5RpVuZEbH+rAqXQNBEJKrNNlcdSbhbxbcIsYJssFXgwba/IyfaPwkmV77EHjv
        LCMWfe+OT/5+Q46J9iNFHgzF8HUMaAQmsWu1BjKXN/hAY4f1Osv3akSPhT2tMrqVQOAye5Ylxntij
        nOO3DJVsskJNDywxAh9xNwvJMZtgfhqzCqA04xvhrtxSydR6QodgyEM0fv7mLGGWX7lO0K5jvKIs6
        dp4PT8jDpCNMqOW8XB0qFpSCiizdZr3SoiwTSuBJ6p5oSAwzXZAM1+BP60hNfliOFQ6zJ2KKBmPF6
        filbXLslA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47332)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieyQj-0007Vj-Mw; Wed, 11 Dec 2019 09:37:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieyQe-0005ju-Lv; Wed, 11 Dec 2019 09:37:08 +0000
Date:   Wed, 11 Dec 2019 09:37:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: Re: [PATCH 3/3] net: macb: add support for high speed interface
Message-ID: <20191211093708.GZ25745@shell.armlinux.org.uk>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
 <20191209113606.GF25745@shell.armlinux.org.uk>
 <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191210114053.GU25745@shell.armlinux.org.uk>
 <BY5PR07MB65147AEF32345E351E920188D35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR07MB65147AEF32345E351E920188D35A0@BY5PR07MB6514.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[private email content deleted, added Cc list back since this is
important.]

I'm still not getting a good enough view of what you are doing and
how my understanding of your hardware fits with what you're doing
with the software.

My understanding is it's something like:

	----+
        SOC |             PCS
	MAC --(USXGMII)-- PHY ----- PHY or SFP
	    |
	----+

And you are just modelling the MAC part in phylink, where as phylink
has so far been used on systems which have this model - where phylink
knows about both the MAC and the PCS PHY:

	---------------+
	         PCS   |
	MAC ---- PHY ----- PHY or SFP
	     SOC       |
      	---------------+

This is why I recently renamed mac_link_state() to mac_pcs_get_state()
to make it clearer that it reads from the PCS not from the current
settings of the MAC.  So far, all such setups do not implement the PCS
PHY as an 802.3 register set; they implement it as part of the MAC
register set.

In the former case, if phylink is used to manage the connection between
the MAC and the PCS PHY, phylink has nothing to do with the SFP at all.

In the latter case, phylink is used to manage the connection between the
PCS PHY and external device, controlling the MAC as appropriate.

My problem is I believe your hardware is the former case, but you are
trying to implement the latter case by ignoring in-band mode.  As SFPs
rely on in-band mode, that isn't going to work.

The options for the former case are:

1) implement phylink covering both the MAC and the external PCS PHY
2) implement phylink just for the MAC to PCS PHY connection but not
   SFPs, and implement SFP support separately in the PCS PHY driver.

Maybe phylink needs to split mac_pcs_get_state() so it can be supplied
by a separate driver, or by the MAC driver as appropriate - but that
brings with it other problems; phylink with a directly attached SFP
considers the state of the link between the PCS PHY and the external
device - not only speed but also interface mode for that part of the
link.  What you'd see in the mac_config() callback are interface modes
for that part of the link, not between the MAC and the PCS PHY.

To change that would require reworking almost every driver that has
already converted over to somehow remodel the built-in PCS and
COMPHY as a separate PCS PHY for phylink. I'm not entirely clear
whether that would work though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
