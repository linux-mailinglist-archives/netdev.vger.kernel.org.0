Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1315431AD46
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBMQy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMQyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 11:54:23 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289FEC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 08:53:43 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2CCCF23E55;
        Sat, 13 Feb 2021 17:53:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613235221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBPyjWvzRQ0rkigRDAH3wEFS0yVsnmFxvcjs86ss2b8=;
        b=krmH4H25Kqnwl8/lpya9h57kmi7UPFIaWXnCW+8YLR7Jm3WXt3r56dKsazgsJS5cQJAxqS
        ZhJzkw5fCSxugvF6tt90+tnOCve10Wd0IZnPYD/NNqbNVlgQp6NoVWKaUA6B/cK8O86Twt
        Ehn9VW5lfpQIcpo4lAME58lULiT/pPI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 13 Feb 2021 17:53:41 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
In-Reply-To: <20210213003641.gybb6gstjpkcwr6z@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-13 01:36, schrieb Vladimir Oltean:
> On Fri, Feb 12, 2021 at 11:40:59PM +0100, Michael Walle wrote:
>> Am 2021-02-12 18:23, schrieb Vladimir Oltean:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > Currently Linux has no control over whether a MAC-to-PHY interface uses
>> > in-band signaling or not, even though phylink has the
>> > 	managed = "in-band-status";
>> > property which denotes that the MAC expects in-band signaling to be
>> > used.
>> >
>> > The problem is really that if the in-band signaling is configurable in
>> > both the PHY and the MAC, there is a risk that they are out of sync
>> > unless phylink manages them both. Most if not all in-band autoneg state
>> > machines follow IEEE 802.3 clause 37, which means that they will not
>> > change the operating mode of the SERDES lane from control to data mode
>> > unless in-band AN completed successfully. Therefore traffic will not
>> > work.
>> >
>> > It is particularly unpleasant that currently, we assume that PHYs which
>> > have configurable in-band AN come pre-configured from a prior boot stage
>> > such as U-Boot, because once the bootloader changes, all bets are off.
>> 
>> Fun fact, now it may be the other way around. If the bootloader 
>> doesn't
>> configure it and the PHY isn't reset by the hardware, it won't work in
>> the bootloader after a reboot ;)
> 
> My understanding is that this is precisely the reason why the U-Boot
> people don't want to support booting from RAM, and want to assume that
> the nothing else ran between Power On Reset and the bootloader:
> https://www.denx.de/wiki/view/DULG/CanUBootBeConfiguredSuchThatItCanBeStartedInRAM
> [ that does make me wonder what they think about ARM TF-A ]

It isn't that easy sometimes. Eg. there might be boards without a proper
reset of the peripherals, maybe the SoC will just generate an internal
reset, whatever. One might conisder that a broken board. But, for
example, on the kontron sl28, we deliberatly chose not to do a PHY
reset (well it is actually configurable) because this will also prevent
WoL by the PHY.

>> > Let's introduce a new PHY driver method for configuring in-band autoneg,
>> > and make phylink be its first user. The main PHY library does not call
>> > phy_config_inband_autoneg, because it does not know what to configure it
>> > to. Presumably, non-phylink drivers can also call
>> > phy_config_inband_autoneg
>> > individually.
>> 
>> If you disable aneg between MAC and PHY, what would be the actual 
>> speed
>> setting/duplex mode then? I guess it have to match the external speed?
>> 
>> I'm trying this on the AT8031. I've removed 'managed = 
>> "in-band-status";'
>> for the PHY. Confirmed that it won't work and then I've implemented 
>> your
>> new callback. That will disable the SGMII aneg (which is done via the
>> BMCR of fiber page if I'm not entirely mistaken); ethernet will then
>> work again. But only for gigabit. I presume because the speed setting
>> of the SGMII link is set to gigabit.
> 
> Which MAC driver are you testing on?

enetc

> Are you saying that it doesn't
> force the link to the speed resolved over MDIO and passed to
> .phylink_mac_link_up, or that the speed communicated to it is 
> incorrect?

That seem to work:

[ 5313.852406] fsl_enetc 0000:00:00.0 gbe0: phy link down 
sgmii/Unknown/Unknown
[ 5313.852414] fsl_enetc 0000:00:00.0 gbe0: Link is Down
[ 5315.900687] fsl_enetc 0000:00:00.0 gbe0: phy link up 
sgmii/100Mbps/Full
[ 5315.916816] fsl_enetc 0000:00:00.0 gbe0: Link is Up - 100Mbps/Full - 
flow control rx/tx

But the Atheros PHY seems to have a problem with the SGMII link
if there is no autoneg.
No matter what I do, I can't get any traffic though if its not
gigabit on the copper side. Unfortunately, I don't have access
to an oscilloscope right now to see whats going on on the SGMII
link.

-michael
