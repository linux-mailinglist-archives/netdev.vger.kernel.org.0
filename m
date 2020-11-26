Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87042C574D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390878AbgKZOpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:45:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389847AbgKZOpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 09:45:50 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiIWo-008zJb-AI; Thu, 26 Nov 2020 15:45:46 +0100
Date:   Thu, 26 Nov 2020 15:45:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Peng Fan <peng.fan@nxp.com>, Fugang Duan <fugang.duan@nxp.com>,
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
Message-ID: <20201126144546.GN2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126000049.GL2073444@lunn.ch>
 <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
 <20201126031021.GK2075216@lunn.ch>
 <20201126111014.5a6a2049@jawa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126111014.5a6a2049@jawa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > What is not yet clear to me is how you direct frames out specific
> > interfaces. This is where i think we hit problems. I don't see a
> > generic mechanism, which is probably why Lukasz put tagger as None. 
> 
> I've put the "None" tag just to share the "testable" RFC code.

Tagging is a core feature of DSA. Without being able to direct a
packet out a specific port, it is not really a DSA driver.  It is also
core requirement of integrating a switch into Linux. A DSA driver, or
a pure switchdev driver expects to be able to forward frames out
specific ports.

> It is possible to "tag" frames - at least from the manual [0]:
> Chapter: "29.4.9.2 Forced Forwarding".
> 
> With using register HW_ENET_SWI_FORCE_FWD_P0
> 29.9.34 ENET SWI Enable forced forwarding for a frame processed
> from port 0 (HW_ENET_SWI_FORCE_FWD_P0)
> 
> One can "tag" the packet going from port0 (internal one from SoC) to be
> forwarded to port1 (ENET-MAC0) or port2 (ENET-MAC1).
> 
> According to the legacy driver [1]:
> "* It only replace the MAC lookup function,
>  * all other filtering(eg.VLAN verification) act as normal"

This might solve your outgoing frame problems. But you need to dive
deep into how the FEC driver works, especially in a DSA like
setup. The normal path would be, the slave interface passes a frame to
the tagger driver, living in net/dsa/tag_*.c. Normally, it adds a
header/trailer which the switch looks at. It then hands to packet over
to the master Ethernet driver, which at some point will send the
frame. Because the frame is self contained, we don't care what that
ethernet driver actually does. It can add it to a queue and send it
later. It can look at the QoS tags and send it with low priority after
other frames, or could put it to the head of the queue and send it
before other frames etc.

Since you don't have self contained frames, this is a problem. After
writing to this register, you need to ensure what is transmitted next
is the specific frame you intend. It cannot be added to an existing
queue etc. You need to know when the frame has been sent, so you can
re-write this register for the next frame.

This is why i said i don't know if the DSA architecture will work. You
need a close coupling between the tagger setting the force bits, and
the DMA engine sending the frame.

The other option is you totally ignore most of this and statically
assign VLANs. Frames sent with VLAN 1 are forwarded out port 1. Frames
sent with VLAN 2 are sent out port 2. You need the port to
append/strip these VLAN tags for ingress/egress. tag_8021q.c gives you
some code to help with this. But can you still use the hardware to
switch frames between ports 1 and 2 without them going via the CPU?

       Andrew.
