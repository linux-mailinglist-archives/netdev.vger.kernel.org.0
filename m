Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C69584E6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0OwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:52:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56741 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0OwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:52:23 -0400
Received: from [5.158.153.52] (helo=mitra)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hgVl5-0006zq-Ff; Thu, 27 Jun 2019 16:52:19 +0200
Date:   Thu, 27 Jun 2019 16:43:07 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190627164307.568ae3a3@mitra>
In-Reply-To: <20190627134929.GE31189@lunn.ch>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
        <20190627101506.19727-1-b.spranger@linutronix.de>
        <20190627101506.19727-2-b.spranger@linutronix.de>
        <20190627134929.GE31189@lunn.ch>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Thu, 27 Jun 2019 15:49:29 +0200
schrieb Andrew Lunn <andrew@lunn.ch>:

> On Thu, Jun 27, 2019 at 12:15:06PM +0200, Benedikt Spranger wrote:
> 
> Hi Benedikt
> 
> > +Configuration with tagging support
> > +----------------------------------
> > +
> > +The tagging based configuration is desired.
> > +
> > +To use the b53 DSA driver some configuration need to be performed. As
> > +example configuration the following scenarios are used:
> > +
> > +*single port*
> > +  Every switch port acts as a different configurable ethernet port
> > +
> > +*bridge*
> > +  Every switch port is part of one configurable ethernet bridge
> > +
> > +*gateway*
> > +  Every switch port except one upstream port is part of a configurable
> > +  ethernet bridge.
> > +  The upstream port acts as different configurable ethernet port.
> > +
> > +All configurations are performed with tools from iproute2, wich is available at
> > +https://www.kernel.org/pub/linux/utils/net/iproute2/
> > +
> > +In this documentation the following ethernet ports are used:
> > +
> > +*eth0*
> > +  CPU port  
> 
> In DSA terminology, this is the master interface. The switch port
> which the master is connected to is called the CPU port. So you are
> causing confusion with DSA terms here.

Changed the whole section to:

Through DSA every port of a switch is handled like a normal linux ethernet
interface. The CPU port is the switch port connected to an ethernet MAC chip.
The corresponding linux ethernet interface is called the master interface.
All other corresponding linux interfaces are called slave interfaces.

The slave interfaces depend on the master interface. They can only brought up,
when the master interface is up.

In this documentation the following ethernet interfaces are used:

*eth0*
  the master interface

*LAN1*
  a slave interface

*LAN2*
  another slave interface

*WAN*
  A slave interface dedicated for upstream traffic

> > +bridge
> > +~~~~~~
> > +
> > +.. code-block:: sh
> > +
> > +  # create bridge
> > +  ip link add name br0 type bridge
> > +
> > +  # add ports to bridge
> > +  ip link set dev wan master br0
> > +  ip link set dev lan1 master br0
> > +  ip link set dev lan2 master br0
> > +
> > +  # configure the bridge
> > +  ip addr add 192.0.2.129/25 dev br0
> > +
> > +  # The master interface needs to be brought up before the slave ports.
> > +  ip link set eth0 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up  
> 
> I would probably do this in a different order. Bring the master up
> first, then the slaves. Then enslave the slaves to bridge, and lastly
> configure the bridge.

No objection. Will change the order.

> > +
> > +  # bring up the bridge
> > +  ip link set dev br0 up
> > +
> > +gateway
> > +~~~~~~~
> > +
> > +.. code-block:: sh
> > +
> > +  # create bridge
> > +  ip link add name br0 type bridge
> > +
> > +  # add ports to bridge
> > +  ip link set dev lan1 master br0
> > +  ip link set dev lan2 master br0
> > +
> > +  # configure the bridge
> > +  ip addr add 192.0.2.129/25 dev br0
> > +
> > +  # configure the upstream port
> > +  ip addr add 192.0.2.1/30 dev wan
> > +
> > +  # The master interface needs to be brought up before the slave ports.
> > +  ip link set eth0 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up
> > +
> > +  # bring up the bridge
> > +  ip link set dev br0 up  
> 
> It would be good to add a note that there is nothing specific to the
> B53 here. This same process will work for all DSA drivers which
> support tagging, which is actually the majority.
Will state that.

> I also tell people that once you configure the master interface up,
> they should just use the slave interfaces a normal linux
> interfaces. The fact they are on a switch does not matter, and should
> not matter. Just use them as normal.
OK.

Regards
    Bene Spranger
