Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32018315119
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhBIOA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:00:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhBIN7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:59:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9TX8-0057fl-I8; Tue, 09 Feb 2021 14:58:26 +0100
Date:   Tue, 9 Feb 2021 14:58:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
Message-ID: <YCKVAtu2Y8DAInI+@lunn.ch>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
 <20210203165458.28717-6-vadym.kochan@plvision.eu>
 <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9b249oq.fsf@waldekranz.com>
 <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> At the same time some FW is necessary. Certain chip functions, are 
> best driven by a micro-controller running a tight control loop. 

For a smart NIC, i could agree. But a switch? The data path is in
hardware. The driver is all about configuring this hardware, and then
it is idle. Polls the PHYs once a second, maybe gather statistics,
allows the network stack to perform STP, but otherwise it does
nothing.

So for me, i don't see that being a valid argument for this driver.

By putting their SDK inside the CPU on the switch, and adding an RPC
interface, Marvell can quickly get some sort of support working in the
Linux ecosystem. But this solution has all the problems of a binary
blob in userspace.

I doubt there is going to be any community engagement with this
driver. Marvell is going to have to add all the features. If a user
wants a feature which is not currently supported, they have little
chance of being able to add it themselves. There is no documentation
of the RPC interface. So even if the firmware has support for more
than what the Linux driver implements, only Marvell knows about it.

Products based around this driver are going to find it hard to
differentiate on switch features. The switch can do what Marvell
allows you to do. All differentiation is going to be limited to above
that, the user interface.

For some market segments, that might be enough. You don't see
community based patches adding new features to the Mellanex/nvidia
hardware. But when you look at the DSA drivers, a lot of the features
there are from the community. There is probably space for both.

Looking into my crystal ball, Marvell will probably have the base
features of their switch implemented before Microchip does, simply
because they are reusing code hidden away in the CPU. But then
development will stagnate. Microchip will take a bit longer to get the
base features implemented. But then because of the openness, users
will start using the hardware in different ways, and implement
features which are important to them. And contribute bug fixes. The
driver will keep gaining new features and mature, and in the end, the
device built from it will be a lot more divers and interesting.

What i'm not sure is how we as a community push back. Marvells whole
strategy is black box. I doubt we can make them open up the firmware.
Do we want to throw out the driver from the kernel? I don't think it
is that bad. We can point out the problems with Marvell's model. We
can put in review effort for Microchip, make their driver better. And
we can encourage the 3rd and 4th vendors in the enterprise switch
space to follow Microchips lead.

      Andrew
