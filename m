Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9583AB546
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhFQN7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:59:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhFQN7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 09:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QEhOpyUKLUFmzaCTtQRdlV6kirtwhgYFJOhhPYtpMXM=; b=eCtFSi/umQPuyxsDXYTRhe0mTE
        jv7ggg5jLrQUV/9kndPCmysHsiTYEf9Cp3t197K6JWJ/CZI6QQd0EZ4WQ8CkOIbXuqQqkE7L3omPe
        ttxfoolOVwKV02IJ4pZm2TMfSLUmzhzq1UUhtABnvCDSB0S1lXMSDwbuJJcyDUAi4Dq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltsWU-009v5j-MR; Thu, 17 Jun 2021 15:57:34 +0200
Date:   Thu, 17 Jun 2021 15:57:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <YMtUzkV8ox2wUHre@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126123027.ocsykutucnhpmqbt@skbuf>
 <20201127003549.3753d64a@jawa>
 <20201127010811.GR2075216@lunn.ch>
 <20210617130821.465c7522@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617130821.465c7522@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 01:08:21PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > > I would push back and say that the switch offers bridge
> > > > acceleration for the FEC.   
> > > 
> > > Am I correct, that the "bridge acceleration" means in-hardware
> > > support for L2 packet bridging?   
> > 
> > You should think of the hardware as an accelerator, not a switch. The
> > hardware is there to accelerate what linux can already do. You setup a
> > software bridge in linux, and then offload L2 switching to the
> > accelerator. You setup vlans in linux, and then offload the filtering
> > of them to the accelerator. If there is something linux can do, but
> > the hardware cannot accelerate, you leave linux to do it in software.
> > 
> > > Do you propose to catch some kind of notification when user calls:
> > > 
> > > ip link add name br0 type bridge; ip link set br0 up;
> > > ip link set lan1 up; ip link set lan2 up;
> > > ip link set lan1 master br0; ip link set lan2 master br0;
> > > bridge link
> 
> ^^^^^^^^^^^^^ [*]
> 
> > > 
> > > And then configure the FEC driver to use this L2 switch driver?  
> > 
> > That is what switchdev does. There are various hooks in the network
> > stack which call into switchdev to ask it to offload operations to the
> > accelerator.
> 
> I'm a bit confused about the interfaces that pop up when I do enable
> bridging acceleration.
> 
> Without bridge I do have:
> - eth0 (this is a 'primary' interface -> it also controls MII/PHY for
>   eth1)
> - eth1 (it uses the MII/PHY control from eth0)

You need to be careful with wording here. eth0 might provide an MDIO
bus which eth1 PHY is connected to, but eth1 is controlling the PHY,
not eth0.

> 
> Both interfaces works correctly.
> 
> And after starting the bridge (and switchdev) with commands from [*] I
> do have:

You don't start switchdev. switchdev is just an API between the
network stack and the hardware accelerator.

> - br0 (created bridge - need to assign IP to it to communicate outside,
>   even when routing is set via eth0, and eth0 has the same IP address)

The IP address should only be on the bridge.

> - eth0 (just is used to control PHY - ifconfig up/down)
> - eth1 (just is used to control PHY - ifconfig up/down)

It is more than that. You can still send on these interfaces. e.g. if
you are using ldap, or L2 PTP, the daemons will use these interfaces,
not the bridge, since they want to send frames out a specific
interface.

> And now the question, how internally shall I tackle the transmission
> (i.e. DMA setups)?
>
> Now, I do use some hacks to re-use code for eth0 to perform the
> transmission from/to imx28 L2 switch.

Avoid hacks. Always. Step back. Look at the hardware. How is the
hardware meant to be used when using the switch?

You have two choices. 

1) A DSA style driver. The SoC has an Ethernet interface connect to
one port of the switch. In this case, there should be two additional
ports of the switch connected to the outside world, i.e. the switch
has 3 ports.

2) A pure switchdev driver. You DMA frames directly to the switch
ingree/egress queues for each port connected to the outside world.  In
this case, you have a 2 port switch.

Once you get the architecture correct, then you can think about the
driver. Maybe you can reuse parts of the FEC? Maybe not.

	Andrew
