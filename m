Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552CA2B961B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgKSPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:25:02 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44653 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgKSPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:25:01 -0500
X-Originating-IP: 90.55.104.168
Received: from bootlin.com (atoulouse-258-1-33-168.w90-55.abo.wanadoo.fr [90.55.104.168])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 1AB6E6000B;
        Thu, 19 Nov 2020 15:24:54 +0000 (UTC)
Date:   Thu, 19 Nov 2020 16:24:51 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201119162451.4c8d220d@bootlin.com>
In-Reply-To: <20201119145500.GL1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com>
        <20201119145500.GL1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Thu, 19 Nov 2020 14:55:00 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

>On Thu, Nov 19, 2020 at 03:22:46PM +0100, Maxime Chevallier wrote:
>> Hello everyone,
>> 
>> I'm reaching out to discuss an issue I'm currently having, while working
>> on a Marvell 88E1543 PHY.
>> 
>> This PHY is very similar to the 88E1545 we already support upstream, but
>> with an added "dual-port mode" feature that I'm currently using in a
>> project, and that might be interesting to have upstream.
>> 
>> As a quick remainder, the 88E154x family are 4-ports PHYs that support
>> Fiber (SFP) or RJ45 Copper interfaces on the media side, and QSGMII/SGMII
>> on the host side.
>> 
>> A datasheet for this PHY family can be found here [1] but unfortunately,
>> this public datasheet doesn't explain the mode I'm going to discuss...
>> 
>> The specificity of the 88E1543 is that is can be configured as a 2-port
>> PHY, each port having the ability to have both a Copper RJ45 interface and
>> a Fiber interface with automatic media detection, very much like the
>> 88x3310 that we support, and that is used on the MacchiatoBin.
>> 
>> This auto-media detection is the specific mode i'm interested in.
>> 
>> The way this works is that the PHY is internally configured by chaining
>> 2 internal PHYs back to back. One PHY deals with the Host interface and
>> is configured as an SGMII to QSGMII converter (the QSGMII is only used
>> from within the PHY), and the other PHY acts as the Media-side PHY,
>> configured in QSGMII to auto-media (RJ45 or Fiber (SFP)) :
>> 
>>                 +- 88e1543 -----------------------+
>> +-----+         | +--------+          +--------+  |  /-- Copper (RJ45)
>> |     |--SGMII----| Port 0 |--QSGMII--| Port 1 |----<
>> |     |         | +--------+          +--------+  |  \--- Fiber
>> | MAC |         |                                 |
>> |     |         | +--------+          +--------+  |  /-- Copper (RJ45)
>> |     |--SGMII----| Port 2 |--QSGMII--| Port 3 |----<
>> +-----+         | +--------+          +--------+  |  \-- Fiber
>>                 +---------------------------------+  
>
>Yes, this is somewhat like the 88x3310 - the 88x3310 PHY is actually a
>collection of different PHY blocks integrated together, with a chunk of
>firmware controlling the whole thing, enabling the appropriate PHY
>blocks and routing the data paths amongst them as required.
>
>With the 88x3310, we don't care very much about the MAC-facing blocks
>(PHYXS in Clause 45 terminology). We certainly do not check the PHYXS
>for link before reporting that the PHY as a whole has link - this is
>actually very important, since with the 88x3310, we have to report to
>the MAC that the link is up so the MAC can configure its PHY facing
>interface correctly before that part of the link will come up.
>
>Also, if we look at 88e1512 when used in SGMII to copper mode, this
>PHY re-uses its fiber side for the MAC facing SGMII interface, so can
>be regarded similar to your above diagram.
>
>So, a question for you: does the above setup for ports 0 and 2 require
>any software configuration of the PHY, or is that all achieved by
>hardware strapping the PHY for the appropriate mode?
>
>If it's all done by hardware strapping with no software configuration
>requirement for ports 0 and 2, I would suggest that we ignore the
>complexities here, and just represent ports 1 and 3 as normal, as a
>SGMII-to-{copper,fibre}.

I gave it a look, and indeed ports 0 and 2 don't need any particular
software configuration, all the config is done on ports 1 and 3. So,
you're right this simplifies a lot the situation :)

There's one thing though, ports 1 and 3 can be used as
SGMII-to-Copper, SGMII-to-Fibre (in that case, ports 0 and 2 are
also available to use), or as SGMII-to-{Copper + Fibre} with
autodetection, in that case ports 0/2 act as the MAC facing side.

In the latter case, we need to configure a few registers on port 1/3 to
configure the internal circuitry. (but we do leave ports 0/2 untouched).

I don't think we have a way to distinguish from the DT if we are in
SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
the same, we don't have any information in DT about wether or not the
PHY is wired to a Copper RJ45 port.

Maybe we should have a way to indicate if a PHY is wired to a Copper
port in DT ?

>If we were to let phylib to drive ports 0 and 2 as well, we're going
>to introduce a whole raft of entirely new problems. phylib is only
>really designed for the last-step media facing PHY.
>
>> I have two main concerns about how to deal with that (if we are interested
>> in having such a support upstream at all).
>> 
>> The first one, is how to represent that in the DT.
>> 
>> One approach could be to really represents what's going on, by representing
>> the 2 PHYs chained together. In this case, only the MAC-facing PHY
>> will report the link state, so we are basically representing the internal
>> wiring of the PHY, can we consider that as a description of the hardware ?
>> 
>> Besides that, I don't think that today, we are able to represent link
>> composed of multiple PHYs daisy-chained together, but this is something
>> that we might want to support one day, since it could benefit other types
>> of use-cases.
>> 
>> Another approach could be to pretend the 88E1543 is a 2-port SGMII to
>> Auto-media PHY. This is also a bit tricky, since we need a way to detect
>> that we want the whole 4-ports PHY to act as a 2-port PHY. (or 3-port, if
>> we only want to use one pair of ports in that mode, and the other ports
>> as SGMII - Copper or SGMII - Fiber PHYs).  
>
>Aren't each of the four ports at a different MDIO address, which means
>each has to be described separately?

Yes indeed

>> The second concern I have is that all of this is made even harder by the
>> fact that this 88E1543 PHY seems indistinguishable from the 88E1545 by
>> reading the PHY ID, they both report 0x01410eaX :/ I guess we would also
>> need some DT indication that we are in fact dealing with a 88E1543.
>> 
>> So I'd like you opinions on how we might want to deal with such scenarios,
>> and if we do want to bother supporting that at all :(
>> 
>> Thanks in advance,
>> 
>> Maxime
>> 
>> [1] :
>> https://www.marvell.com/content/dam/marvell/en/public-collateral/transceivers/marvell-phys-transceivers-alaska-88e154x-datasheet.pdf
>>   
>



-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
