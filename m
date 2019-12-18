Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A0C1244D3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfLRKka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:40:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43450 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRKka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:40:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=35708Wq5f0WAEsS1FUw9qLs77w8UkH9mIwciITdlJzM=; b=sGbs0Fvai2BT+meHpX05l16Iu
        Rrdj373/LMZBsSa/T7INNFVOArwg7zkWsSERAMVZNIhaU8FmcgQB3/g6/Q1yyqeOnzflmO9++wVvX
        3ILDWjkDAE4PHi4X6xSQq2wGnN1VfrTHwvJfu5zPeLd84bQRZQkHmuJA2PL4QFRPBqjuiKQRP1m2P
        tsKs/tyzYUrJtyeCw71YyWog/6UDmX8M4T03jqqsopijJGzE/thJSt5GAwqgKNm4QVkMrG4dujZYH
        IKC+K02JyzQBUS3YbfRiSMivtJnM+roIVRqVT0jOFjk/POtKw7DmOW1GRx+CZxndSCnb7OHblo2cd
        OpxOSi3xA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42938)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihWkY-0003Tw-7i; Wed, 18 Dec 2019 10:40:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihWkS-0004KA-JR; Wed, 18 Dec 2019 10:40:08 +0000
Date:   Wed, 18 Dec 2019 10:40:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Message-ID: <20191218104008.GT25745@shell.armlinux.org.uk>
References: <20191217221831.10923-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:18:23AM +0200, Vladimir Oltean wrote:
> The SerDes protocol which the driver calls 2500Base-X mode (a misnomer) is more
> interesting. There is a description of how it works and what can be done with
> it in patch 8/8 (in a comment above vsc9959_pcs_init_2500basex).
> In short, it is a fixed speed protocol with no auto-negotiation whatsoever.
> From my research of the SGMII-2500 patent [1], it has nothing to do with
> SGMII-2500. That one:
> * does not define any change to the AN base page compared to plain 10/100/1000
>   SGMII. This implies that the 2500 speed is not negotiable, but the other
>   speeds are. In our case, when the SerDes is configured for this protocol it's
>   configured for good, there's no going back to SGMII.
> * runs at a higher base frequency than regular SGMII. So SGMII-2500 operating
>   at 1000 Mbps wouldn't interoperate with plain SGMII at 1000 Mbps. Strange,
>   but ok..
> * Emulates lower link speeds than 2500 by duplicating the codewords twice, then
>   thrice, then twice again etc (2.5/25/250 times on average). The Layerscape
>   PCS doesn't do that (it is fixed at 2500 Mbaud).
> 
> But on the other hand it isn't Base-X either, since it doesn't do 802.3z /
> clause 37 auto negotiation (flow control, local/remote fault etc).

Most documentation I've seen for these 2.5Gbps modes from a few vendors
suggests that every vendor has its own ideas.

With Marvell, for example, whether the gigabit MAC is operating at 1G
or 2.5G is controlled by the serdes "comphy" block, and from what I can
tell merely increases the clocking rate by 2.5x when 2.5G mode is
selected.

I suspect all the features of conventional 1G mode are also available
when running at this higher speed, but many don't make sense. For
example, if the MAC (there's no distinction of the PCS there) was
configured for 100Mbps, but the comphy was configured for 2.5G, we'd
end up with 250Mbps by 10x replication on the link. This has never been
tested though.

Whether in-band AN is enabled or not is separately configurable,
although the Marvell Armada 370 documentation states that when the port
is configured for 1000Base-X, in-band AN must be enabled. I suspect the
same is stated for later devices. However, practical testing seems to
suggest that it will work without in-band AN enabled if the other side
doesn't want in-band AN.

> So it is a protocol in its own right (a rather fixed one). If reviewers think
> it should have its own phy-mode, different than 2500base-x, I'm in favor of
> that. It's just that I couldn't find a suitable name for it. quarter-xaui?
> 3125mhz-8b10b?

I think just call it 2500base-x without in-band negotiation.

> When inter-operating with the Aquantia AQR112 and AQR412 PHYs in this mode (for
> which the PHY uses a proprietary name "OCSGMII"), we do still need to support
> the lower link speeds negotiated by the PHY on copper side. So what we
> typically do is we enable rate adaptation in the PHY firmware, with pause
> frames and a fixed link speed on the system side. Raising this as a discussion
> item to understand how we can model this quirky operating mode in Linux without
> imposing limitations on others (we have some downstream patches on the Aquantia
> PHY driver as well).
> 
> Another item to discuss is whether we should be able to disable AN in the PCS
> independently of whether we have a PHY as a peer or not. With an SGMII PHY-less
> connection, there may be no auto-negotiation master so the link partners will
> bounce for a while and then they'll settle on 10 Mbps as link speed. For those
> connections (such as an SGMII link to a downstream switch) we need to disable
> AN in the PCS and force the speed to 1000.

With Marvell, there's the in-band AN enable bit, but there's also an
in-band AN bypass bit, which allows the in-band AN to time out when
the 16-bit configuration word is not received after a certain period
of time after the link has been established.

As for disabling AN... see below.

> So:
> * If we have a PHY we want to do auto-neg
> * If we don't have a PHY, maybe we want AN, maybe we don't
> * In the 2500Base-X mode, we can't do AN because the hardware doesn't support it
> 
> I have found the 'managed = "in-band-status"' DTS binding to somewhat address
> this concern, but I am a bit reluctant to disable SGMII AN if it isn't set.

I believe the in-band-status thing came from mvneta prior to phylink.
mvneta supports operating in SGMII with no in-band AN, and the default
setup that the driver adopted in SGMII mode was without in-band AN
enabled. When in-band AN was required, that's when this DT property
came about.

mvneta was the basis for phylink creation (as it was the first platform
I had that we needed to support SFPs). Compatibility with mvneta had to
be maintained to avoid regressions, so that got built-in to phylink.

When we are not operating in in-band AN mode, then yes, we do disable
in-band AN at the MAC for mvneta and mvpp2. What others do, I haven't
delved into. However, it is important - I have a SFP that uses a
Broadcom PHY that does not provide any in-band AN when in SGMII mode.
It is SGMII mode, because it supports the symbol replication for 100
and 10Mbps - but Broadcom's expectation is that the MAC is forced to
the appropriate speed after reading the PHY registers.

I think the reason it does this is because it's a NBASE-T PHY, and you
have to read the PHY registers to know what protocol its using on the
serdes lane, which could be one of 10GBASE-R, 5000BASE-X, 2500BASE-X
or SGMII at 1G, 100M or 10M depending on the copper side negotiation
results.

This works with mvneta and mvpp2 since, when operating in fixed or
phy mode in phylink, we disable in-band AN and force the MAC
settings.

Keeping this consistent across drivers (where possible) would be my
preference to avoid different behaviours and surprises.

> We have boards with device trees that need to be migrated from PHYLIB and I
> am concerned that changing the behavior w.r.t. in-band AN (when the
> "in-band-status" property is not present) is not going to be pleasant.
> I do understand that the "in-band-status" property is primarily intended to be
> used with PHY-less setups, and it looks like the fact it does work with PHYs as
> well is more of an oversight (as patch 2/8 shows). So I'm not sure who else
> really uses it with a phy-handle.

That partly depends on the PHY. Given what I've said above, some PHYs
require in-band AN to complete before they will pass data, other MACs
will not establish a link if in-band AN is enabled but there is no
in-band control word, even if the bypass bit is enabled.

Using in-band AN with a PHY results in faster link establishment, and
also has the advantage that when the link goes down, the MAC responds
a lot quicker than the 1sec phylib poll to stop transmitting.

I tend to run my boards with in-band AN enabled even for on-board PHYs
although I've not pushed those patches upstream.  Most PHYs on these
boards come up with in-band AN bypass enabled, so it doesn't matter
whether in-band AN is enabled or disabled.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
