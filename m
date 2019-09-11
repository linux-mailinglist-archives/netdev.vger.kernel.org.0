Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D1DAF947
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfIKJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:44:00 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53738 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKJoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:44:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 4338228C55C
Message-ID: <ad14d3b2712a8b6bca423727a935924962d80938.camel@collabora.com>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, bob.beckett@collabora.com
Date:   Wed, 11 Sep 2019 10:43:55 +0100
In-Reply-To: <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-09-10 at 09:49 -0700, Florian Fainelli wrote:
> +Ido, Jiri,
> 
> On 9/10/19 8:41 AM, Robert Beckett wrote:
> > This patch-set adds support for some features of the Marvell switch
> > chips that can be used to handle packet storms.
> > 
> > The rationale for this was a setup that requires the ability to
> > receive
> > traffic from one port, while a packet storm is occuring on another
> > port
> > (via an external switch with a deliberate loop). This is needed to
> > ensure vital data delivery from a specific port, while mitigating
> > any
> > loops or DoS that a user may introduce on another port (can't
> > guarantee
> > sensible users).
> 
> The use case is reasonable, but the implementation is not really. You
> are using Device Tree which is meant to describe hardware as a policy
> holder for setting up queue priorities and likewise for queue
> scheduling.
> 
> The tool that should be used for that purpose is tc and possibly an
> appropriately offloaded queue scheduler in order to map the desired
> scheduling class to what the hardware supports.

Thanks for the review and tip about tc. Im currently not familiar with
that tool. Ill investigate it as an alternative approach.

> 
> Jiri, Ido, how do you guys support this with mlxsw?
> 
> > 
> > [patch 1/7] configures auto negotiation for CPU ports connected
> > with
> > phys to enable pause frame propogation.
> > 
> > [patch 2/7] allows setting of port's default output queue priority
> > for
> > any ingressing packets on that port.
> > 
> > [patch 3/7] dt-bindings for patch 2.
> > 
> > [patch 4/7] allows setting of a port's queue scheduling so that it
> > can
> > prioritise egress of traffic routed from high priority ports.
> > 
> > [patch 5/7] dt-bindings for patch 4.
> > 
> > [patch 6/7] allows ports to rate limit their egress. This can be
> > used to
> > stop the host CPU from becoming swamped by packet delivery and
> > exhasting
> > descriptors.
> > 
> > [patch 7/7] dt-bindings for patch 6.
> > 
> > 
> > Robert Beckett (7):
> >   net/dsa: configure autoneg for CPU port
> >   net: dsa: mv88e6xxx: add ability to set default queue priorities
> > per
> >     port
> >   dt-bindings: mv88e6xxx: add ability to set default queue
> > priorities
> >     per port
> >   net: dsa: mv88e6xxx: add ability to set queue scheduling
> >   dt-bindings: mv88e6xxx: add ability to set queue scheduling
> >   net: dsa: mv88e6xxx: add egress rate limiting
> >   dt-bindings: mv88e6xxx: add egress rate limiting
> > 
> >  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
> >  drivers/net/dsa/mv88e6xxx/chip.c              | 122 ++++++++++++
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
> >  drivers/net/dsa/mv88e6xxx/port.c              | 140
> > +++++++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
> >  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
> >  net/dsa/port.c                                |  10 ++
> >  7 files changed, 327 insertions(+), 34 deletions(-)
> >  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> > 
> 
> 

