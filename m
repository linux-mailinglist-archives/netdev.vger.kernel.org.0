Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D1CAFBC7
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfIKLtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:49:11 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55100 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbfIKLtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:49:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 464C828E68C
Message-ID: <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Ido Schimmel <idosch@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, bob.beckett@collabora.com
Date:   Wed, 11 Sep 2019 12:49:03 +0100
In-Reply-To: <20190911112134.GA20574@splinter>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
         <20190911112134.GA20574@splinter>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 11:21 +0000, Ido Schimmel wrote:
> On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli wrote:
> > +Ido, Jiri,
> > 
> > On 9/10/19 8:41 AM, Robert Beckett wrote:
> > > This patch-set adds support for some features of the Marvell
> > > switch
> > > chips that can be used to handle packet storms.
> > > 
> > > The rationale for this was a setup that requires the ability to
> > > receive
> > > traffic from one port, while a packet storm is occuring on
> > > another port
> > > (via an external switch with a deliberate loop). This is needed
> > > to
> > > ensure vital data delivery from a specific port, while mitigating
> > > any
> > > loops or DoS that a user may introduce on another port (can't
> > > guarantee
> > > sensible users).
> > 
> > The use case is reasonable, but the implementation is not really.
> > You
> > are using Device Tree which is meant to describe hardware as a
> > policy
> > holder for setting up queue priorities and likewise for queue
> > scheduling.
> > 
> > The tool that should be used for that purpose is tc and possibly an
> > appropriately offloaded queue scheduler in order to map the desired
> > scheduling class to what the hardware supports.
> > 
> > Jiri, Ido, how do you guys support this with mlxsw?
> 
> Hi Florian,
> 
> Are you referring to policing traffic towards the CPU using a policer
> on
> the egress of the CPU port? At least that's what I understand from
> the
> description of patch 6 below.
> 
> If so, mlxsw sets policers for different traffic types during its
> initialization sequence. These policers are not exposed to the user
> nor
> configurable. While the default settings are good for most users, we
> do
> want to allow users to change these and expose current settings.
> 
> I agree that tc seems like the right choice, but the question is
> where
> are we going to install the filters?
> 

Before I go too far down the rabbit hole of tc traffic shaping, maybe
it would be good to explain in more detail the problem I am trying to
solve.

We have a setup as follows:

Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port 1
(P1) is critical priority, no dropped packets allowed, all others can
be best effort.

CPU port of swtich chip is connected via phy to phy of intel i210 (igb
driver).

i210 is connected via pcie switch to imx6.

When too many small packets attempt to be delivered to CPU port (e.g.
during broadcast flood) we saw dropped packets.

The packets were being received by i210 in to rx descriptor buffer
fine, but the CPU could not keep up with the load. We saw
rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.


With this in mind, I am wondering whether any amount of tc traffic
shaping would help? Would tc shaping require that the packet reception
manages to keep up before it can enact its policies? Does the
infrastructure have accelerator offload hooks to be able to apply it
via HW? I dont see how it would be able to inspect the packets to apply
filtering if they were dropped due to rx descriptor exhaustion. (please
bear with me with the basic questions, I am not familiar with this part
of the stack).

Assuming that tc is still the way to go, after a brief look in to the
man pages and the documentation at largc.org, it seems like it would
need to use the ingress qdisc, with some sort of system to segregate
and priortise based on ingress port. Is this possible?



> > 
> > > 
> > > [patch 1/7] configures auto negotiation for CPU ports connected
> > > with
> > > phys to enable pause frame propogation.
> > > 
> > > [patch 2/7] allows setting of port's default output queue
> > > priority for
> > > any ingressing packets on that port.
> > > 
> > > [patch 3/7] dt-bindings for patch 2.
> > > 
> > > [patch 4/7] allows setting of a port's queue scheduling so that
> > > it can
> > > prioritise egress of traffic routed from high priority ports.
> > > 
> > > [patch 5/7] dt-bindings for patch 4.
> > > 
> > > [patch 6/7] allows ports to rate limit their egress. This can be
> > > used to
> > > stop the host CPU from becoming swamped by packet delivery and
> > > exhasting
> > > descriptors.
> > > 
> > > [patch 7/7] dt-bindings for patch 6.
> > > 
> > > 
> > > Robert Beckett (7):
> > >   net/dsa: configure autoneg for CPU port
> > >   net: dsa: mv88e6xxx: add ability to set default queue
> > > priorities per
> > >     port
> > >   dt-bindings: mv88e6xxx: add ability to set default queue
> > > priorities
> > >     per port
> > >   net: dsa: mv88e6xxx: add ability to set queue scheduling
> > >   dt-bindings: mv88e6xxx: add ability to set queue scheduling
> > >   net: dsa: mv88e6xxx: add egress rate limiting
> > >   dt-bindings: mv88e6xxx: add egress rate limiting
> > > 
> > >  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
> > >  drivers/net/dsa/mv88e6xxx/chip.c              | 122
> > > ++++++++++++---
> > >  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
> > >  drivers/net/dsa/mv88e6xxx/port.c              | 140
> > > +++++++++++++++++-
> > >  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
> > >  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
> > >  net/dsa/port.c                                |  10 ++
> > >  7 files changed, 327 insertions(+), 34 deletions(-)
> > >  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> > > 
> > 
> > 
> > -- 
> > Florian

