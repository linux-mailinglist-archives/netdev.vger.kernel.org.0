Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD54D2BA64E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgKTJgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:36:09 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56449 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgKTJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:36:07 -0500
X-Greylist: delayed 64216 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 04:36:06 EST
X-Originating-IP: 90.55.104.168
Received: from bootlin.com (atoulouse-258-1-33-168.w90-55.abo.wanadoo.fr [90.55.104.168])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 71CEEE0046;
        Fri, 20 Nov 2020 09:36:02 +0000 (UTC)
Date:   Fri, 20 Nov 2020 10:36:01 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120103601.313a166b@bootlin.com>
In-Reply-To: <87eekoanvj.fsf@waldekranz.com>
References: <20201119152246.085514e1@bootlin.com>
        <20201119145500.GL1551@shell.armlinux.org.uk>
        <20201119162451.4c8d220d@bootlin.com>
        <87k0uh9dd0.fsf@waldekranz.com>
        <20201119231613.GN1551@shell.armlinux.org.uk>
        <87eekoanvj.fsf@waldekranz.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Fri, 20 Nov 2020 01:11:12 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

>On Thu, Nov 19, 2020 at 23:16, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
>> On Thu, Nov 19, 2020 at 11:43:39PM +0100, Tobias Waldekranz wrote:  
>>> On Thu, Nov 19, 2020 at 16:24, Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:  
>>> > I don't think we have a way to distinguish from the DT if we are in
>>> > SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
>>> > the same, we don't have any information in DT about wether or not the
>>> > PHY is wired to a Copper RJ45 port.
>>> >
>>> > Maybe we should have a way to indicate if a PHY is wired to a Copper
>>> > port in DT ?  
>>> 
>>> Do you mean something like:
>>> 
>>> SGMII->SGMII (Fibre):
>>> ethernet-phy@0 {
>>>    sfp = <&sfp0>;
>>> };
>>> 
>>> SGMII->MDI (Copper):
>>> ethernet-phy@0 {
>>>     mdi;
>>> };
>>> 
>>> SGMII->Auto Media Detect
>>> ethernet-phy@0 {
>>>     mdi;
>>>     sfp = <&sfp0>;
>>> };  
>>
>> This isn't something we could realistically do - think about how many
>> DT files are out there today which would not have this for an existing
>> PHY. The default has to be that today's DT descriptions continue to work
>> as-is, and that includes ones which already support copper and fibre
>> either with or without a sfp property.
>>
>> So, we can't draw any conclusion about whether the fiber interface is
>> wired from whether there is a sfp property or not.
>>
>> We also can't draw a conclusion about whether the copper side is wired
>> using a "mdi" property, or whether there is a "sfp" property or not.
>>
>> The only thing we could realistically do today is to introduce a
>> property like:
>>
>> 	mdi = "disabled" | "okay";
>>
>> to indicate whether the copper port can be used, and maybe something
>> similar for the fiber interface.  Maybe as you suggest, not "okay"
>> but specifying the number of connected pairs would be a good idea,
>> or maybe that should be a separate property?  
>
>Maybe you could have optional media nodes under the PHY instead, so that
>you don't involve the SFP property in the logic (SGMII can be connected
>to lots of things after all):
>
>    ethernet-phy@0 {
>        ...
>
>        sgmii {
>            status = "okay";
>            preferred;
>        };
>
>        mdi {
>           status = "okay";
>           pairs = <2>;
>        };
>    };

I like that approach too, and I agree that we do need to be very careful
with not breaking existing PHYs, where most of the time we assume that
a PHY simply has a 8P8C (RJ45) connector.

Maybe the term MDI is a bit misused here, my understanding was that MDI,
standing for "Media Dependent Interface" represents the media-side
interface in general, and not a particular technology such as
xxxBaseT/X/K or Copper of Fibre.

So maybe we could be a bit more generic, with something along these lines :

    ethernet-phy@0 {
        ...

        mdi {
            port@0 {
                media = "10baseT", "100baseT", "1000baseT";
                pairs = <1>;
	    };

            port@1 {
                media = "1000baseX", "10gbaseR"
            };
        };
    };

This would allow us to explicitely indicate which modes are supported
by each port.

And in absence of the mdi node, we indeed fallback to the usual behaviour.

>In the absence of any media declarations, you fall back to the driver's
>default behavior (keeping compatibility with older DTs). But you can
>still add support for more configurations if the information is
>available.

I also like the idea of having a way to express the "preferred" media,
although I wonder if that's something we want to include in DT or that
we would want to tweak at runtime, through ethtool for example.

What do you think ?

Thanks,

Maxime

