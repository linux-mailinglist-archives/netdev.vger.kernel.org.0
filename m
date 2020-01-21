Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C12143C5D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgAULzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:55:19 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50502 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAULzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3ZboEu5XWm0Gj/rVyRF+DBjIGPcA63w9RtOzjImGPZo=; b=lkNktxqAMS+JC/SmegmLV564K
        X0MC8QXirgtXyX2GVjg34p0nAwYU/6ZknyniqoCVZ5pGaazVaL98tPlqLWsBVxgDoC09sXwhSm40Y
        vhFV/4JmcfJBx0EMjjQrBmOgk2idb8ZNKUszgvepat/PBgi09SCNZyjt5mqNPaTKvBJNHidP9Vz1A
        SVJ1Wj8M/J23zbAv8+PuZX8u2zPmAoF28ZQ0Cbq1FTpsEuAAzlpEqwlNRPhrGCZWmx9mlTNETRI2E
        96DGCZnyphy2LjwTCVHTT/eMGRjBX4DC/amUg/YMDhd7cuXZKaR+U2ZtluUc/GqBJZu6t2WsVcKHB
        pN5UNqcBg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:57862)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1its7h-0004Jr-04; Tue, 21 Jan 2020 11:55:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1its7c-0003nt-3P; Tue, 21 Jan 2020 11:55:04 +0000
Date:   Tue, 21 Jan 2020 11:55:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandru Marginean <alexandru.marginean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: felix: Handle PAUSE RX regardless
 of AN result
Message-ID: <20200121115503.GF25745@shell.armlinux.org.uk>
References: <20200116181933.32765-1-olteanv@gmail.com>
 <20200116181933.32765-2-olteanv@gmail.com>
 <20200120094304.GZ25745@shell.armlinux.org.uk>
 <0c72bde9-f22a-b9da-d6a6-8b9dd2bbf579@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c72bde9-f22a-b9da-d6a6-8b9dd2bbf579@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 08:18:10AM +0000, Alexandru Marginean wrote:
> resent from NXP account, apparently google thinks this is just spam.
> 
> On 1/20/2020 10:43 AM, Russell King - ARM Linux admin wrote:
> > On Thu, Jan 16, 2020 at 08:19:32PM +0200, Vladimir Oltean wrote:
> >> From: Alex Marginean <alexandru.marginean@nxp.com>
> >>
> >> Flow control is used with 2500Base-X and AQR PHYs to do rate adaptation
> >> between line side 100/1000 links and MAC running at 2.5G.
> >>
> >> This is independent of the flow control configuration settled on line
> >> side though AN.
> >>
> >> In general, allowing the MAC to handle flow control even if not
> >> negotiated with the link partner should not be a problem, so the patch
> >> just enables it in all cases.
> >>
> >> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > I think this is not the best approach - you're working around the
> > issue in your network driver, rather than recognising that it's a
> > larger problem than just your network driver.
> 
> Both are true, this is a work-around so our system isn't functionally 
> broken and it's clear that the general issue has to be handled elsewhere.
> 
> 
> > Rate adaption is present in other PHYs using exactly the same
> > mechanism so why do we want to hack around this in each network
> > driver?  It is a property of the PHY, not of the network driver.
> > 
> > Surely it not be better to address this in phylib/phylink - after
> > all, there are several aspects to this:
> > 
> > 1) separation of the MAC configuration (reported to the MAC) from
> >     the negotiation results (reported to the user).
> > 2) we need the MAC to be able to receive and act on flow control.
> > 3) we need to report the correct speed setting to the MAC.
> > 
> > I already have patches to improve the current phylib method of
> > reporting the flow control information to MAC drivers with the resolved
> > flow state rather than just the current link partner advertisement
> > bits, which should make (2) fairly easy to achieve.  (1) and (3) will
> > require additional work.
> 
> I think this won't be trivial to address, let's see how it will go.

I think you're trying to inflate the complexity of the problem.

We've had "rate adaption" in ethernet networks for years. Consider a
10/100/1G switch, where some devices are connected at 1G speed and
others at a slower speed.

The switch has to do "rate adaption" to allow devices operating at
dis-similar speeds to communicate with each other.

Whether flow control is used or not depends on the supported
capabilities of each end of each link, and also the user configuration
of the interface.

So, rate adaption itself is nothing new.  However, where it is being
performed is new.

> At the PHY level we would add a capability indicating that flow control 
> can be used as a way to do rate adaptation.  If that's just a capability 
> bit declared at probing, it should probably imply that the PHY driver 
> also provides run-time configuration.  This way flow control can be 
> enabled/disabled so that the PHY configuration is adjusted based on 
> phylink resolved state, this is probably the ideal case.
> 
> I'm not sure how many PHYs are going to be that flexible though, we may 
> need quirks for:
> - the PHY supports flow control but it's not configurable, potentially 
> baked into the firmware,

That isn't a problem.

We have situations today where the user disables flow control on the
interface despite it having been negotiated with the link partner.  An
example of this is a buggy switch, which advertises flow control, but
if it's used, the switch misbehaves.  The normal solution adopted is
to disable flow control via ethtool -A.  This may or may not change
the interface's advertisement (that seems to be driver specific).

So we can already end up with flow control advertised and negotiated,
but disabled at the interface.  No one has complained about that.

Let me present a couple of examples:

 MAC <--10GBASE-R--> PHY <--1G--> SWITCH <--100M--> PARTNER

If the MAC is flow control capable, the PHY performs rate adaption,
but the switch is not flow control capable.  Whether or not the
partner supports flow control is irrelevent to my scenario.

Flow control receive is force-enabled at the MAC as we've decided
that should happen when the PHY is performing rate adaption.

The MAC sends packets, and fills the PHY rate adaption buffer.  The
PHY sends flow control packets to the MAC to stop transmission.  No
packet loss occurs at this stage.

The PHY sends the packets out at 1G line rate to the switch, which
fills its own rate adaption buffer for sending on to the 100M partner.
There is no flow control, so the switch starts dropping packets.

Now consider:

 MAC <--10GBASE-R--> PHY <--10G--> SWITCH <--100M--> PARTNER

with the same capabilities.  The PHY is not performing rate adaption.
Let's say that the PHY doesn't have that capability.

The MAC sends packets, which are passed through by the PHY to the
switch, filling its rate adaption buffer.  As the switch has no flow
control, it starts dropping packets.

Both scenarios are not very different - packets get lost in both
situations, but there are two differences:

1) where they are lost is slightly different.
2) the latency of the connection is different.

To think about the second point, consider that the higher layers on
the MAC side want to send a retrainsmission of some of the packets
that were dropped.

In the first case, the MAC is stalled from sending packets until the
PHY permits it, meaning that there's packets held at the MAC until
the PHY can send them at 1G speed - and probably many of them will
be dropped by the switch.  So, we have to wait for these to be sent
at 1G speed, assuming that the retransmission is sent out in queued
packet order.

In the second case, all packets will be sent at 10G speed and
discarded by the switch once the switch has filled its buffers, but
the retransmission is not delayed.

That said, I'm not sufficiently into the details of networking to know
whether one situation is better than the other, I suspect that depends
on how the protocol that is suffering packet loss has been designed.

> - flow control is available for certain interface types but not for others,
> - flow control is available for certain link speeds but not for others, 
> or other restrictions like these.

Given that flow control is fundamentally just a normal ethernet packet
with a certain destination address, I don't see that being an issue.
In any case, if flow control were not available, this is no different
from Ethernet without flow control.

> Should PHY level indication of flow control support be a static flag, or 
> a function of interface type/link speed?  The latter would allow the PHY 
> driver to address any quirkiness internally.

It depends on the configuration of the PHY.  For the Marvell 88x3310,
the host interface can be configured in several modes, which include:

1) switching between 10GBASE-R, 5GBASE-R, 2500BASE-X and SGMII on the
   fly depending on the negotiated link speed (the MAC side interface
   changes.)

2) fixed 10GBASE-R with rate adaption, which *may* include the PHY
   sending flow control when the rate adaption buffers fill up.  Rate
   adaption will only be used if there are dis-similar speeds.  From
   what I read, some PHYs may not be capable of flow control in this
   mode, and where flow control is not used, apparently the IPG
   "should" be extended.

So:
- rate adaption is a function of how the PHY is configured and the
  negotiated link speed.
- whether flow control should be used is a separate property from
  whether rate adaption is enabled.
- if flow control is not used, the IPG in use by the MAC "should" be
  extended to match the PHY egress rate.

> We've been working with Aquantia PHYs and they are somewhat quirky, it 
> would be useful to hear about other PHYs if anyone has any first-hand 
> experience with other PHYs doing flow control.
> 
> Phylink should then take in MAC capabilites, PHY capabilities and if:
> - MAC supports flow control configuration or Rx is always on, and
> - PHY supports flow control (either as a generic capability flag plus 
> optional quirks, or as a function of interface type/link speed), and
> - the current interface type does not allow dealing with rate adaptation 
> internally (like XFI, 2500base-x as currently used in the kernel), and maybe
> - link speed on line side is below the capacity of the system interface,
> then instruct the PHY to do rate adaptation using flow control and 
> enable flow control Rx in the MAC.
> 
> If the conditions aren't met maybe phylink should issue a warning or 
> some sort of indication to the user.  If the system ends up with a 1G 
> link on line side, XFI and no rate adaptation, some networking protocols 
> aren't going to work too well.

If a system has 1G on the line side but XFI on the MAC side, and no
rate adaption, then it simply can't work.  Rate adaption is providing
themechanism to allow dis-similar speeds on either side of the block
doing rate adaption to be able to communicate.  So, I think you
actually mean flow control here.

I'd say the networking protocols haven't been well designed then -
Ethernet without flow control is a lossy networking system.

> At the user level I think we're going to have to present more 
> information, what the peers advertised during AN, what the result of the 
> AN was and also what the configuration of the MAC is, as now this could 
> be different due to rate adaptation.  That way the user can tell for 
> instance that flow control was disabled as part of AN but it is enabled 
> in the MAC for the purpose of doing rate adaptation between MAC and PHY.

Ethtool gives the following information:

- via ksettings API, access to the negotiation link modes.  Ethtool
  reports the link modes that each end advertised, and also via
  ethtool -a, calculates the resolution from the advertised link
  modes reported via the ksettings API.  In no way does this reflect
  how the MAC was configured.

- via the pauseparam API, access to the manual configuration of the
  MAC - whether the results of AN are configured to be used, and the
  forced flow control settings if pause AN is disabled.

So, there is already no way today to actually tell what the MAC is
doing with respect to flow control.

> ethtool -A should probably not control the actual MAC configuration 
> either, to keep rate adaptation sane, but rather be part of the phylink 
> algorithm.  This is a little tricky to do, given that ethtool ops are 
> now implemented by Eth drivers.

ethtool -A should _definitely_ continue to control the MAC
configuration, so that the user can decide to have flow control
disabled if there is a switch that causes problems when flow
control is in use (they exist), and without that ability, the users
only other solution is to throw out the problematical switch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
