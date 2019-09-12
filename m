Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4803FB12FD
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbfILQqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:46:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45714 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbfILQqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 12:46:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 32AD328E9D5
Message-ID: <4943d80defe5458701311a0da03bf44d2a61baac.camel@collabora.com>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, bob.beckett@collabora.com
Date:   Thu, 12 Sep 2019 17:46:24 +0100
In-Reply-To: <68676250-17df-b0bb-521a-64877f198647@gmail.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
         <20190911112134.GA20574@splinter>
         <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
         <20190912090339.GA16311@splinter>
         <68676250-17df-b0bb-521a-64877f198647@gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-12 at 09:25 -0700, Florian Fainelli wrote:
> On 9/12/19 2:03 AM, Ido Schimmel wrote:
> > On Wed, Sep 11, 2019 at 12:49:03PM +0100, Robert Beckett wrote:
> > > On Wed, 2019-09-11 at 11:21 +0000, Ido Schimmel wrote:
> > > > On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli
> > > > wrote:
> > > > > +Ido, Jiri,
> > > > > 
> > > > > On 9/10/19 8:41 AM, Robert Beckett wrote:
> > > > > > This patch-set adds support for some features of the
> > > > > > Marvell
> > > > > > switch
> > > > > > chips that can be used to handle packet storms.
> > > > > > 
> > > > > > The rationale for this was a setup that requires the
> > > > > > ability to
> > > > > > receive
> > > > > > traffic from one port, while a packet storm is occuring on
> > > > > > another port
> > > > > > (via an external switch with a deliberate loop). This is
> > > > > > needed
> > > > > > to
> > > > > > ensure vital data delivery from a specific port, while
> > > > > > mitigating
> > > > > > any
> > > > > > loops or DoS that a user may introduce on another port
> > > > > > (can't
> > > > > > guarantee
> > > > > > sensible users).
> > > > > 
> > > > > The use case is reasonable, but the implementation is not
> > > > > really.
> > > > > You
> > > > > are using Device Tree which is meant to describe hardware as
> > > > > a
> > > > > policy
> > > > > holder for setting up queue priorities and likewise for queue
> > > > > scheduling.
> > > > > 
> > > > > The tool that should be used for that purpose is tc and
> > > > > possibly an
> > > > > appropriately offloaded queue scheduler in order to map the
> > > > > desired
> > > > > scheduling class to what the hardware supports.
> > > > > 
> > > > > Jiri, Ido, how do you guys support this with mlxsw?
> > > > 
> > > > Hi Florian,
> > > > 
> > > > Are you referring to policing traffic towards the CPU using a
> > > > policer
> > > > on
> > > > the egress of the CPU port? At least that's what I understand
> > > > from
> > > > the
> > > > description of patch 6 below.
> > > > 
> > > > If so, mlxsw sets policers for different traffic types during
> > > > its
> > > > initialization sequence. These policers are not exposed to the
> > > > user
> > > > nor
> > > > configurable. While the default settings are good for most
> > > > users, we
> > > > do
> > > > want to allow users to change these and expose current
> > > > settings.
> > > > 
> > > > I agree that tc seems like the right choice, but the question
> > > > is
> > > > where
> > > > are we going to install the filters?
> > > > 
> > > 
> > > Before I go too far down the rabbit hole of tc traffic shaping,
> > > maybe
> > > it would be good to explain in more detail the problem I am
> > > trying to
> > > solve.
> > > 
> > > We have a setup as follows:
> > > 
> > > Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port
> > > 1
> > > (P1) is critical priority, no dropped packets allowed, all others
> > > can
> > > be best effort.
> > > 
> > > CPU port of swtich chip is connected via phy to phy of intel i210
> > > (igb
> > > driver).
> > > 
> > > i210 is connected via pcie switch to imx6.
> > > 
> > > When too many small packets attempt to be delivered to CPU port
> > > (e.g.
> > > during broadcast flood) we saw dropped packets.
> > > 
> > > The packets were being received by i210 in to rx descriptor
> > > buffer
> > > fine, but the CPU could not keep up with the load. We saw
> > > rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.
> > > 
> > > 
> > > With this in mind, I am wondering whether any amount of tc
> > > traffic
> > > shaping would help? Would tc shaping require that the packet
> > > reception
> > > manages to keep up before it can enact its policies? Does the
> > > infrastructure have accelerator offload hooks to be able to apply
> > > it
> > > via HW? I dont see how it would be able to inspect the packets to
> > > apply
> > > filtering if they were dropped due to rx descriptor exhaustion.
> > > (please
> > > bear with me with the basic questions, I am not familiar with
> > > this part
> > > of the stack).
> > > 
> > > Assuming that tc is still the way to go, after a brief look in to
> > > the
> > > man pages and the documentation at largc.org, it seems like it
> > > would
> > > need to use the ingress qdisc, with some sort of system to
> > > segregate
> > > and priortise based on ingress port. Is this possible?
> > 
> > Hi Robert,
> > 
> > As I see it, you have two problems here:
> > 
> > 1. Classification: Based on ingress port in your case
> > 
> > 2. Scheduling: How to schedule between the different transmission
> > queues
> > 
> > Where the port from which the packets should egress is the CPU
> > port,
> > before they cross the PCI towards the imx6.
> > 
> > Both of these issues can be solved by tc. The main problem is that
> > today
> > we do not have a netdev to represent the CPU port and therefore
> > can't
> > use existing infra like tc. I believe we need to create one.
> > Besides
> > scheduling, we can also use it to permit/deny certain traffic from
> > reaching the CPU and perform policing.
> 
> We do not necessarily have to create a CPU netdev, we can overlay
> netdev
> operations onto the DSA master interface (fec in that case), and
> whenever you configure the DSA master interface, we also call back
> into
> the switch side for the CPU port. This is not necessarily the
> cleanest
> way to do things, but that is how we support ethtool operations (and
> some netdev operations incidentally), and it works

After reading up on tc, I am not sure how this would work given the
semantics of the tool currently.

My initial thought was to model the switch's 4 output queues using an
mqprio qdisc for the CPU port, and then use either iptables's classify
module on the input ports to set which queue it egresses from on the
CPU port, or use vlan tagging with id 0 and priority set. (with the
many detail of how to implement them still left to discover).

However, it looks like the mqprio qdisc could only be used for egress,
so without a netdev representing the CPU port, I dont know how it could
be used.

Another thing I thought of using was just to use iptable's TOS module
to set the minimal delay bit and rely on default behaviours, but Ive
yet to find anything in the Marvell manual that indicates it could set
that bit on all frames entering a port.

Another option might be to use vlans with their priority bits being
used to steer to output queues, but I really dont want to introduce
more virtual interfaces in to the setup, and I cant see how to
configure an enforce default vlan tag with id 0 and priority bits set
via linux userland tools.


It does look like tc would be quite nice for configuring the egress
rate limiting assuming we a netdev to target with the rate controls of
the qdisc.


So far, this seems like I am trying to shoe horn this stuff in to tc.
It seems like tc is meant to configure how the ip stack  configures
flow within the stack, whereas in a switch chip, the packets go nowhere
near the CPUs kernel ip stack. I cant help thinking that it would be
good have a specific utility for configuring switches that operates on
the port level for manage flow within the chip, or maybe simple sysfs
attributes to set the ports priority.

