Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71493600BE4
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 12:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiJQKDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 06:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiJQKD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 06:03:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4885E660
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 03:03:22 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1okMxt-0001TU-8u; Mon, 17 Oct 2022 12:03:21 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1okMxq-0003Qz-Vy; Mon, 17 Oct 2022 12:03:18 +0200
Date:   Mon, 17 Oct 2022 12:03:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <20221017100318.GH9703@pengutronix.de>
References: <20221017105100.0cb33490@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221017105100.0cb33490@pc-8.home>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> I'm reaching out to discuss a PHY topic that we would like to see
> upstreamed, to support multiple ports attached to a MAC.
> 
> The end-goal is to achieve some redundancy in case of a physical link
> interruption, in a transparent manner, but using only one network
> interface (1 MAC).
> 
> We've been made aware that some products in the wild propose this
> feature-set, using 2 PHYs connected to the same MAC, using some custom
> logic to switch back and forth between the 2 PHYs, and that's the main
> use-case we'd like to see supported :
> 
>                             +-------+
>                      /----- |  PHY  | --- BaseT port
>  +-------+           |      +-------+
>  |  MAC  |-- RGMII --|
>  +-------+           |      +-------+
>                      \----- |  PHY  | --- BaseT port
>                             +-------+
> 

I can add more cases:

- case 1:
	Similar HW can be found in combination with AX88772B:
	https://cms.nacsemi.com/content/AuthDatasheets/ASIXS00048-1.pdf
	Page 6

	Current ASIX driver only takes care to power down internal PHY if
	external is present:
	https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/asix_devices.c#L659
	But I can image some one wants to implement hot switching between
	internal PHY and external PHY or direct RMII connection too.

- case 2:
	A $CUSTOMER of us has a system where the RGMII from the MAC is routed
	via a analog multiplexer to a PHY or to an optional external
	board where the RGMII connects to the host port of a switch chip
	supported by DSA.

> This configuration comes with quite a lot of challenges since we bend
> the existing standards in numerous ways :
> 
>  - We have 2 PHYs on the same xMII bus, and they can't be active on that
>    bus at the same time. To solve that, we have 2 strategies: 
>  
>    - Put the PHY in isolate mode when not in use, they can perform link
>      detection and reporting, but wont communicate on the MII bus.
>      This can have side effects if both links are connected to the same
>      network, which can be addressed through the use of gratuitous ARPs
>      to make sure the right link gets known by the spanning-tree.

Can we "announce" topology change/reseting by switch the link state?
Usually, switches should drop forwarding entry for a port with down
state. But the problem with get complicated if there are multiple
bridges... :/

>    - Put PHY down entirely when not is use, select an active PHY, and
>    when the link goes down on that PHY, switch to the other. This was
>    used on products that had PHYs were the isolate mode is broken.

This is probably better way to go. I assume the use cases where this
kind of redundancy is used, it is preferable to to reduce weight, cost
and power consumption.

> Upstream, we have one device that does something a bit similar, which is
> the macchiatobin, using the 88x3310 PHY. This PHY exports both an SFP
> interface as long as a copper BaseT interface. These 2 interfaces are
> connected to the same MAC and are mutually exclusive.
> 
> It looks like this :
> 
>  +-------+              +---------+   |---- Copper BaseT
>  |  MAC  | -- xxxMII -- |   PHY   |---|
>  +-------+              +---------+   |---- SFP
>  
> We don't have any way to control which port gets used, the first that
> has the link gets the link.
> 
> Ideally we would like to be able to configure every aspects of these
> 2 cases, like :
>  - Which link do we use
>  - Do we switch automatically from one to the other
>  - What are the links available
> 
> I see 4 different aspects of this that would need to be added for this
> whole mechanism to work :
> 
> 1) DT representation
> 
> To support that, we would need a way to give knowledge to the kernel
> about the numer of physical ports that are connected to a given MAC.
> In the dual-phy mode, it's pretty straightforward, since we would
> "just" need to pass multiple phy handles to the mac node. In the MCBin
> case, it's a bit more complex, since we don't have a clear view on the
> number of ports connected to a given phy.
> 
> The assumption is that we have only one port per phy, and it's nature is
> derived from the presence of an sfp=<> phandle in the DT, plus the
> driver itself specifying the phydev->port field (which to my knowledge
> isn't used that much ?)
> 
> The subject of describing the ports a PHY exposes in a sensible way that
> doesn't require changing all DTs out-there has been discussed in the
> past here :
> https://lore.kernel.org/netdev/20201119152246.085514e1@bootlin.com/
> 
> If we only focus on the dual-phy use-case - and not the single-phy
> dual-port - we might not have to deal with extensive DT changes at all.
> 
> 2) Changes in Phylink
> 
> This might be the tricky part, as we need to track several ports,
> possibly connected to different PHYs, to get their state. For now, I
> haven't prototyped any of this yet.
> 
> The goal would be to allow either automatic switching, as is already
> done by the 3310 driver, but at a higher level. Phylink might not be the
> right place to do that, so maybe we just want to expose an API to get
> the possible ports on a given interface, their repective state, and a
> way to select one
> 
> My idea would be to introduce a notion of a struct phy_port, that would
> describe a physical port. They would be controlled by a PHY (or a MAC,
> if the mac outputs 1000BaseX for example), one phy can
> possibly control multiple ports.
> 
> The whole link redundancy would then be done manipulating ports, giving
> a layer of abstraction on the hardware topology itself.
> 
> We would therefore abstract the logic by having :
>                          +--------+
>                      /---|  Port  |
>  +-------------+     |   +--------+
>  |  netdevice  | ----|
>  +-------------+     |
>                      |   +---------+
>                      \---|  Port   |
>                          +---------+
> 
> This is the representation the userspace would know about, without
> necessarily having to worry about the phys inbetween.
> 
> I don't see that as a breaking change, since as of today, most systems
> only have one port per netdevice. We would need to add a way to deal
> with multiple ports per netdevice.
> 
> 3) Adding a L2 bonding driver
> 
> If the link switching logic is deported outside of phylink, we might
> want a generic way of bonding ports on an interface, configuring the
> policy to use for the switching (automatic, manual selection, maybe
> more like trying to elect the link with the highest speed ?). This is
> where we would handle sending the gratuitous ARPs upon link switching
> too.
> 
> 3) UAPI
> 
> From userspace, we would need ways to list the ports, their state, and
> possibly to configure the bonding parameters. for now in ethtool, we
> don't have the notion of port at all, we just have 1 netdevice == 1
> port. Should we therefore create one netdevice per port ? or stick to
> that one interface and refer to its ports with some ethtool parameters ?
> 
> All of these are open questions, as this topic spans quite a lot of
> aspects in the stack. Any input, idea, comment, are very very welcome.

What about this use case:

MAC with > 1 PHYs. One PHY is active, you want to do cable testing
and/or to check the signal quality with SQI. Both are triggered
currently via ethtool on an interface.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
