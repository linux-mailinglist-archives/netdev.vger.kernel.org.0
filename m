Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417465A1D3
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1RHL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 13:07:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36872 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfF1RHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:07:11 -0400
Received: from [5.158.153.52] (helo=mitra)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hguL4-0002OO-CQ; Fri, 28 Jun 2019 19:07:06 +0200
Date:   Fri, 28 Jun 2019 18:57:51 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190628185751.2fe9e0da@mitra>
In-Reply-To: <5fe6c1b8-6273-be3d-cf75-6efdd7f9b27d@gmail.com>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
        <20190627101506.19727-1-b.spranger@linutronix.de>
        <20190627101506.19727-2-b.spranger@linutronix.de>
        <5fe6c1b8-6273-be3d-cf75-6efdd7f9b27d@gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Thu, 27 Jun 2019 09:38:16 -0700
schrieb Florian Fainelli <f.fainelli@gmail.com>:

> On 6/27/19 3:15 AM, Benedikt Spranger wrote:
> > Document the different needs of documentation for the b53 driver.
> > 
> > Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> > ---
> >  Documentation/networking/dsa/b53.rst | 300
> > +++++++++++++++++++++++++++ 1 file changed, 300 insertions(+)
> >  create mode 100644 Documentation/networking/dsa/b53.rst
> > 
> > diff --git a/Documentation/networking/dsa/b53.rst
> > b/Documentation/networking/dsa/b53.rst new file mode 100644
> > index 000000000000..5838cf6230da
> > --- /dev/null
> > +++ b/Documentation/networking/dsa/b53.rst
> > @@ -0,0 +1,300 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==========================================
> > +Broadcom RoboSwitch Ethernet switch driver
> > +==========================================
> > +
> > +The Broadcom RoboSwitch Ethernet switch family is used in quite a
> > range of +xDSL router, cable modems and other multimedia devices.
> > +
> > +The actual implementation supports the devices BCM5325E, BCM5365,
> > BCM539x, +BCM53115 and BCM53125 as well as BCM63XX.
> > +
> > +Implementation details
> > +======================
> > +
> > +The driver is located in ``drivers/net/dsa/bcm_sf2.c`` and is
> > implemented as a +DSA driver; see
> > ``Documentation/networking/dsa/dsa.rst`` for details on the
> > +subsystemand what it provides.  
> 
> The driver is under drivers/net/dsa/b53/
Fixed.

> s/ethernet/Ethernet/ for your global submission.
OK.
 
> What you are describing is not entirely specific to the B53 driver
> (maybe with the exception of having a VLAN tag on the DSA master
> network device, since B53 puts the CPU port tagged in all VLANs by
> default), and therefore the entire document should be written with
> the general DSA devices in mind, and eventually pointing out where
> B53 differs in a separate document.

I have split up the Documentation into 
Documentation/networking/dsa/configuration.rst
and
Documentation/networking/dsa/b53.rst

> There are largely two kinds of behavior:
> 
> - switches that are configured with DSA_TAG_PROTO_NONE, which behave
> in a certain way and require a bridge with VLAN filtering even when
> ports are intended to be used as standalone devices.
> 
> - switches that are configured with a tagging protocol other than
> DSA_TAG_PROTO_NONE, which behave more like traditional network devices
> people are used to use.
OK.

> > +bridge
> > +~~~~~~  
> 
> I would add something like:
> 
> All ports being part of a single bridge/broadcast domain or something
> along those lines. Seeing the "wan" interface being added to a bridge
> is a bit confusing.

 
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
> > +  # The master interface needs to be brought up before the slave
> > ports.
> > +  ip link set eth0 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up
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
> > +  # The master interface needs to be brought up before the slave
> > ports.
> > +  ip link set eth0 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up
> > +
> > +  # bring up the bridge
> > +  ip link set dev br0 up
> > +
> > +Configuration without tagging support
> > +-------------------------------------
> > +
> > +Older models (5325, 5365) support a different tag format that is
> > not supported +yet. 539x and 531x5 require managed mode and some
> > special handling, which is +also not yet supported. The tagging
> > support is disabled in these cases and the +switch need a different
> > configuration.  
> 
> On that topic, did the patch I sent you ended up working the way you
> wanted it with ifupdown-scripts or are you still chasing some other
> issues with it?
Your patch is needed and working. Stumbled over my own feed.

I have a hackary solution by now. Hackary in terms of not tracking the
master interface state (just *up* it unconditionally).

> > +
> > +single port
> > +~~~~~~~~~~~
> > +The configuration can only be set up via VLAN tagging and bridge
> > setup. +By default packages are tagged with vid 1:
> > +
> > +.. code-block:: sh
> > +
> > +  # tag traffic on CPU port
> > +  ip link add link eth0 name eth0.1 type vlan id 1
> > +  ip link add link eth0 name eth0.2 type vlan id 2
> > +  ip link add link eth0 name eth0.3 type vlan id 3  
> 
> That part is indeed a B53 implementation specific detail because B53
> tags the CPU port in all VLANs, since otherwise any PVID untagged VLAN
> programming would basically change the CPU port's default PVID and
> make it untagged, undesirable.
OK.

> > +
> > +  # create bridges
> > +  ip link add name br0 type bridge
> > +  ip link add name br1 type bridge
> > +  ip link add name br2 type bridge
> > +
> > +  # activate VLAN filtering
> > +  ip link set dev br0 type bridge vlan_filtering 1
> > +  ip link set dev br1 type bridge vlan_filtering 1
> > +  ip link set dev br2 type bridge vlan_filtering 1
> > +
> > +  # add ports to bridges
> > +  ip link set dev wan master br0
> > +  ip link set eth0.1 master br0
> > +  ip link set dev lan1 master br1
> > +  ip link set eth0.2 master br1
> > +  ip link set dev lan2 master br2
> > +  ip link set eth0.3 master br2  
> 
> I don't think you need one bridge for each port you want to isolate
> with DSA_PROTO_TAG_NONE, you can just have a single bridge and assign
> the ports a different VLAN with the commands below:

Tried that out:

  # tag traffic on CPU port
  ip link add link eth0 name eth0.1 type vlan id 1
  ip link add link eth0 name eth0.2 type vlan id 2
  ip link add link eth0 name eth0.3 type vlan id 3

  # The master interface needs to be brought up before the slave ports.
  ip link set eth0 up
  ip link set eth0.1 up
  ip link set eth0.2 up
  ip link set eth0.3 up

  # bring up the slave interfaces
  ip link set wan up
  ip link set lan1 up
  ip link set lan2 up

  # create bridge
  ip link add name br0 type bridge

  # activate VLAN filtering
  ip link set dev br0 type bridge vlan_filtering 1

  # add ports to bridges
  ip link set dev wan master br0
  ip link set dev lan1 master br0
  ip link set dev lan2 master br0

  # tag traffic on ports
  bridge vlan add dev lan1 vid 2 pvid untagged
  bridge vlan del dev lan1 vid 1
  bridge vlan add dev lan2 vid 3 pvid untagged
  bridge vlan del dev lan2 vid 1

  # configure the VLANs
  ip addr add 192.0.2.1/30 dev eth0.1
  ip addr add 192.0.2.5/30 dev eth0.2
  ip addr add 192.0.2.9/30 dev eth0.3

  # bring up the bridge devices
  ip link set br0 up

Works quite well :)

> > +
> > +  # tag traffic on ports
> > +  bridge vlan add dev lan1 vid 2 pvid untagged
> > +  bridge vlan del dev lan1 vid 1
> > +  bridge vlan add dev lan2 vid 3 pvid untagged
> > +  bridge vlan del dev lan2 vid 1  
> 
> And also permit the different VLANs that you created on the bridge
> master device itself:
> 
> bridge vlan add vid 2 dev br0 self
> bridve vlan add vid 3 dev br0 self
> 
> Maybe that last part above ^^ was missing and that's why people tend
> to create multiple bridge devices?

From my side there was some tree in the woods problem...

> > +
> > +  # configure the bridges
> > +  ip addr add 192.0.2.1/30 dev br0
> > +  ip addr add 192.0.2.5/30 dev br1
> > +  ip addr add 192.0.2.9/30 dev br2
> > +
> > +  # The master interface needs to be brought up before the slave
> > ports.
> > +  ip link set eth0 up
> > +  ip link set eth0.1 up
> > +  ip link set eth0.2 up
> > +  ip link set eth0.3 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up
> > +
> > +  # bring up the bridge devices
> > +  ip link set br0 up
> > +  ip link set br1 up
> > +  ip link set br2 up
> > +
> > +bridge
> > +~~~~~~
> > +
> > +.. code-block:: sh
> > +
> > +  # tag traffic on CPU port
> > +  ip link add link eth0 name eth0.1 type vlan id 1
> > +
> > +  # create bridge
> > +  ip link add name br0 type bridge
> > +
> > +  # activate VLAN filtering
> > +  ip link set dev br0 type bridge vlan_filtering 1
> > +
> > +  # add ports to bridge
> > +  ip link set dev wan master br0
> > +  ip link set dev lan1 master br0
> > +  ip link set dev lan2 master br0
> > +  ip link set eth0.1 master br0
> > +
> > +  # configure the bridge
> > +  ip addr add 192.0.2.129/25 dev br0
> > +
> > +  # The master interface needs to be brought up before the slave
> > ports.
> > +  ip link set eth0 up
> > +  ip link set eth0.1 up
> > +
> > +  # bring up the slave interfaces
> > +  ip link set wan up
> > +  ip link set lan1 up
> > +  ip link set lan2 up
> > +
> > +  # bring up the bridge
> > +  ip link set dev br0 up
> > +
> > +gateway
> > +~~~~~~~
> > +
> > +.. code-block:: sh
> > +
> > +  # tag traffic on CPU port
> > +  ip link add link eth0 name eth0.1 type vlan id 1
> > +  ip link add link eth0 name eth0.2 type vlan id 2
> > +
> > +  # create bridges
> > +  ip link add name br0 type bridge
> > +  ip link add name br1 type bridge  
> 
> Likewise, I have seen claims of people telling me they used two bridge
> devices, but AFAICT this is only because the bridge master did not
> have VID 2 programmed to it, so if you did the following:
> 
> bridge vlan add vid 2 dev br0 self

I tried the following:
  # tag traffic on CPU port
  ip link add link eth0 name eth0.1 type vlan id 1
  ip link add link eth0 name eth0.2 type vlan id 2

  # The master interface needs to be brought up before the slave ports.
  ip link set eth0 up
  ip link set eth0.1 up
  ip link set eth0.2 up

  # bring up the slave interfaces
  ip link set wan up
  ip link set lan1 up
  ip link set lan2 up

  # create bridge
  ip link add name br0 type bridge

  # activate VLAN filtering
  ip link set dev br0 type bridge vlan_filtering 1

  # add ports to bridges
  ip link set dev wan master br0
  ip link set eth0.1 master br0
  ip link set dev lan1 master br0
  ip link set dev lan2 master br0

  # tag traffic on ports
  bridge vlan add dev wan vid 2 pvid untagged
  bridge vlan del dev wan vid 1

  # configure the VLANs
  ip addr add 192.0.2.1/30 dev eth0.2
  ip addr add 192.0.2.129/25 dev br0

  # bring up the bridge devices
  ip link set br0 up

Maybe I got it fundamently wrong:
I try to seperate the traffic. If i bound everything to the bridge the
separation will not work out. To split it up like above on the other
hand makes it very clear (at least for me).

I have separate interfaces (here br0 and eth0.2) for the different
networks.

But I am open and grateful for any help and suggestions in that area.

> you should be able to get away with a single bridge master device, can
> you try that?
Done. See above. Works!

> Overall this is fills a lot of gaps and questions that were being
> asked on the lamobo R1 threads on various forums, thanks a lot for
> doing that!
Thx.

Regards
    Bene Spranger
