Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D261C2C4DAE
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 04:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgKZDK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 22:10:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgKZDK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 22:10:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ki7fp-008urs-Ix; Thu, 26 Nov 2020 04:10:21 +0100
Date:   Thu, 26 Nov 2020 04:10:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Lukasz Majewski <lukma@denx.de>, Peng Fan <peng.fan@nxp.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, stefan.agner@toradex.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzk@kernel.org, "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201126031021.GK2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126000049.GL2073444@lunn.ch>
 <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 05:30:04PM -0800, Florian Fainelli wrote:
> 
> 
> On 11/25/2020 4:00 PM, Andrew Lunn wrote:
> > On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote:
> >> This is the first attempt to add support for L2 switch available on some NXP
> >> devices - i.e. iMX287 or VF610. This patch set uses common FEC and DSA code.
> > 
> > Interesting. I need to take another look at the Vybrid manual. Last
> > time i looked, i was more thinking of a pure switchdev driver, not a
> > DSA driver. So i'm not sure this is the correct architecture. But has
> > been a while since i looked at the datasheet.
> 
> Agreed the block diagram shows one DMA for each "switch port" which
> definitively fits more within the switchdev model than the DSA model
> that re-purposes an existing Ethernet MAC controller as-is and bolts on
> an integrated or external switch IC.

Hi Florian

I'm not sure it is that simple. I'm looking at the Vybrid
datasheet. There are two major configurations.

1) The switch is pass through, and does nothing. Then two DMA channels
are used, one per external port. You basically just have two Ethernet
interfaces

2) The switch is active. You then have a 3 port switch, 2 ports for
the external interfaces, and one port connected to a single DMA
channel.

So when in an active mode, it does look more like a DSA switch.

What is not yet clear to me is how you direct frames out specific
interfaces. This is where i think we hit problems. I don't see a
generic mechanism, which is probably why Lukasz put tagger as None. It
does appear you can control the output of BPDUs, but it is not very
friendly. You write a register with the port you would like the next
BPDU to go out, queue the frame up on the DMA, and then poll a bit in
the register which flips when the frame is actually processed in the
switch. I don't see how you determine what port a BPDU came in on!
Maybe you have to use the learning interface?

Ah, the ESW_FFEN register can be used to send a frame out a specific
port. Write this register with the destination port, DMA a frame, and
it goes out the specific port. You then need to write the register
again for the next frame.

I get the feeling this is going to need a very close relationship
between the 'tagger' and the DMA engine. I don't see how this can be
done using the DSA architecture, the coupling is too loose.

It seems like the HW design assumes frames from the CPU will be
switched using the switch internal FDB, making Linux integration
"interesting"

It does not look like this is a classic DSA switch with a tagging
protocol. It might be possible to do VLAN per port, in order to direct
frames out a specific port?

       Andrew
