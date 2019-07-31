Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65F57B83D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 05:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfGaDcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 23:32:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGaDcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 23:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/PRBSjjzZGNNa9kAWUv68TK+FZFcHYZiK63wl+1TixQ=; b=SRfNb0JbfHkfL9RKCMGHN1hd9p
        wxZhYIk+cBm4osChEaesCfMC/4r2t0sfxyoiqSEWiiOUDs2PammaebjYjB+CnsTzGhcfUUXbHrPaO
        BnDNFkr5XM2odvN687G8yCemddTdEWE9VUd3D5A15digeB09pu7CA9ooylADxB38nb98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsfLI-0003yQ-R0; Wed, 31 Jul 2019 05:31:56 +0200
Date:   Wed, 31 Jul 2019 05:31:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190731033156.GE9523@lunn.ch>
References: <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
 <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730143400.GO28552@lunn.ch>
 <20190730190000.diacyjw6owqkf7uf@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730190000.diacyjw6owqkf7uf@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Our plan was to implement this in pure SW, and then look at how to HW offload
> it.

Great.

> But this will take some time before we have anything meaning full to show.
> 
> > Make it an alternative to the STP code?
> I'm still working on learning the details of DLR, but I actually believe that it
> in some situations may co-exists with STP ;-)

The PDF you linked to suggests this as well. But i think you will need
to make some core changes to the bridge. At the moment, STP is a
bridge level property. But you are going to need it to be a per-port
option. You can then use DLR on the ring ports, and optionally STP on
the other ports.

> But what we are looking at here, is to offload a
> non-aware-(DLR|MRP)-switch which happens to be placed in a network
> with these protocols running.

So we need to think about why we are passing traffic to the CPU port,
and under what conditions can it be blocked.

1) The interface is not part of a bridge. In this case, we only need
the switch to pass to the CPU port MC addresses which have been set
via set_rx_mode().

I think this case does not apply for what you want. You have two ports
bridges together as part of the ring.

2) The interface is part of a bridge. There are a few sub-cases

a) IGMP snooping is being performed. We can block multicast where
there is no interest in the group. But this is limited to IP
multicast.

b) IGMP snooping is not being used and all interfaces in the bridge
are ports of the switch. IP Multicast can be blocked to the CPU.

c) IGMP snooping is not being used and there is a non-switch interface
in the bridge. Multicast needed is needed, so it can be flooded out
this port.

d) set_rx_mode() has been called on the br0 interface, indicating
there is interest in the packets on the host. They must be sent to the
CPU so they can be delivered locally.

e) ????

Does the Multicast MAC address being used by DLR also map to an IP
mmulticast address? 01:21:6C:00:00:0[123] appear to be the MAC
addresses used by DLR. IPv4 multicast MAC addresses are
01:00:5E:XX:XX:XX. IPv6 multicast MAC addresses are 33:33:XX:XX:XX:XX.

So one possibility here is to teach the SW bridge about non-IP
multicast addresses. Initially the switch should forward all MAC
multicast frames to the CPU. If the frame is not an IPv4 or IPv6
frame, and there has not been a call to set_rx_mode() for the MAC
address on the br0 interface, and the bridge only contains switch
ports, switchdev could be used to block the multicast to the CPU
frame, but forward it out all other ports of the bridge.

      Andrew
