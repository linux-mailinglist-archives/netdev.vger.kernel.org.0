Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7D14A540
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgA0NlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:41:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgA0NlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 08:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8DUWXRMC6eXB4R1lEtwnYFrFoKL0TP4Nq+V+t/GeupA=; b=1dSLpR/pv47pAlbfZR7XfSgjcn
        o1+O18PuM6jZyW8W70pnXZ7d8qP+e5nKqaOxI6rZcvcnidYS9FgnYPoLr9dM2LDMgEPmXAM+EmFBP
        nba/A+PJcIE++cUEpoBRogAjJUQ9U6KVEug3A78kZCFgJvxlCA6CAjzqARbazKQCrbNc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iw4dJ-0006TU-RO; Mon, 27 Jan 2020 14:40:53 +0100
Date:   Mon, 27 Jan 2020 14:40:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 09/10] net: bridge: mrp: Integrate MRP into the
 bridge
Message-ID: <20200127134053.GG12816@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-10-horatiu.vultur@microchip.com>
 <20200125161615.GD18311@lunn.ch>
 <20200126130111.o75gskwe2fmfd4g5@soft-dev3.microsemi.net>
 <20200126171251.GK18311@lunn.ch>
 <20200127105746.i2txggfnql4povje@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127105746.i2txggfnql4povje@lx-anielsen.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > 'Thinking allowed' here.
> > 
> >     +------------------------------------------+
> >     |                                          |
> >     +-->|H1|<---------->|H2|<---------->|H3|<--+
> >     eth0    eth1    eth0    eth1    eth0    eth1
> >      ^
> >      |
> >   Blocked
> > 
> > 
> > There are three major classes of user case here:
> > 
> > 1) Pure software solution
> > You need the software bridge in the client to forward these frames
> > from the left side to the right side.

> As far as I understand it is not the bridge which forward these frames -
> it is the user-space tool. This was to put as much functionality in
> user-space and only use the kernel to configure the HW. We can (and
> should) discuss if this is the right decision.

So i need to flip the point around. How does the software switch know
not to forward the frames? Are you adding an MDB?

> We would properly have better performance if we do this in kernel-space.

Yes, that is what i think. And if you can do it without any additional
code, using the forwarding tables, so much the better.

> BTW: It is not only from left to right, it is also from right to left.
> The MRM will inject packets on both ring ports, and monitor both.

Using the same MAC address in both directions? I need to think what
that implies for MDB entries. It probably just works, since you never
flood back out the ingress port.

> Again, I do not know how other HW is designed, but all the SOC's we are
> working with, does allow us to add a TCAM rule which can redirect these
> frames to the CPU even on a blocked port.

It is not in scope for what you are doing, but i wonder how we
describe this in a generic Linux way? And then how we push it down to
the hardware?

For the Marvell Switches, it might be possible to do this without the
TCAM. You can add forwarding DB entries marked as Management. It is
unclear if this overrides the blocked state, but it would be a bit odd
if it did not.

> > You could avoid this by adding MDB entries to the bridge. However,
> > this does not scale to more then one ring.
> I would prefer a solution where the individual drivers can do what is
> best on the given HW.

The nice thing about adding MDB is that it is making use of the
software bridge facilities. In general, the software bridge and
hardware bridges are pretty similar. If you can solve the problem
using generic software bridge features, not additional special cases
in code, you have good chance of being able to offload it to a
hardware bridge which is not MRP aware. The switchdev API for MRP
specific features should then allow you to make use of any additional
features the hardware might have.

> Yes, the solution Horatiu has chosen, is not to forward MRP frames,
> received in MRP ring ports at all. This is done by the user-space tool.
> 
> Again, not sure if this is the right way to do it, but it is what patch
> v3 does.
> 
> The alternative to this would be to learn the bridge how to forward MRP
> frames when it is a MRC. The user-space tool then never needs to do
> this, it know that the kernel will take care of this part (either in SW
> or in HW).

I think that should be considered. I'm not saying it is the best way,
just that some thought should be put into it to figure out what it
actually implies.

	 Andrew
