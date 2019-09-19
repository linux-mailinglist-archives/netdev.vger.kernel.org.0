Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAF0B7D1F
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbfISOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:44:47 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52605 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389504AbfISOoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:44:46 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1iAxfo-0007px-Q8; Thu, 19 Sep 2019 16:44:44 +0200
Message-ID: <46dfe90236042c9e9c62a74584fc99931982e5fb.camel@pengutronix.de>
Subject: Re: dsa traffic priorization
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date:   Thu, 19 Sep 2019 16:44:43 +0200
In-Reply-To: <20190919133411.GA22556@lunn.ch>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
         <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
         <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
         <20190919133411.GA22556@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

thanks for your detail explanation!

On Thu, 2019-09-19 at 15:34 +0200, Andrew Lunn wrote:
> On Thu, Sep 19, 2019 at 10:00:51AM +0200, Sascha Hauer wrote:
> > Hi Vladimir,
> > 
> > On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> > > Hi Sascha,
> > > 
> > > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > > > Hi All,
> > > > 
> > > > We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> > > > regular network traffic on another port. The customer wants to configure two things
> > > > on the switch: First Ethercat traffic shall be priorized over other network traffic
> > > > (effectively prioritizing traffic based on port). Second the ethernet controller
> > > > in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> > > > port shall be rate limited.
> > > > 
> > > 
> > > You probably already know this, but egress shaping will not drop
> > > frames, just let them accumulate in the egress queue until something
> > > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > > tail dropping is enabled, etc). Is this what you want?
> > 
> > If I understand correctly then the switch has multiple output queues per
> > port.
> 
> There are 4 egress queues per port.
> 
> > The Ethercat traffic will go to a higher priority queue and on
> > congestion on other queues, frames designated for that queue will be
> > dropped.
> 
> On ingress, there are various ways to add a priority to a frame, which
> then determines which egress queue it lands in. This can be static,
> all frames which ingress port X have priority Y. It can look at the
> 802.1p header and map the l2 priority to an queue priority. It can
> look at the IPv4 TOS/DSCP value and map it to a queue priority. And
> you can also use the TCAM, when it matches on a frame, it can specify
> the frame priority.
> 
> If the egress queue, as selected by the queue priority is full, the
> frame will be dropped.

In our case, it's a static configuration (ethercat prio 3, others 2).

> > I just talked to our customer and he verified that their
> > Ethercat traffic still goes through even when the ports with the general
> > traffic are jammed with packets. So yes, I think this is what I want.
> 
> Taking frames out of the port egress queues and passing them out the
> interface is then determined by the scheduler. There are two different
> configurations which can be used
> 
> 1) Strict priority. Frames are taken from the highest priority queue,
> until it is empty. If the highest priority queue is empty, frames are
> taken from the second highest priority queue. And if the second
> priority is empty, the third priority queue is used, etc. This can
> lead to starvation, when the lower priority queue never get serviced
> because the higher priority queue have sufficient frames to keep the
> line busy.

This is configured in our case, and also limits the queuing latency for
the ethercat traffic (to at most on MTU sized packet when other traffic
is already being transmitted).

> 2) Weighted round robin. It takes up to 8 frames from the highest
> priority queue, then up to 4 frames from the second highest priority
> queue, then up to 2 frames from the 3rd highest priority queue, and
> then 1 frame from the lower priority frame. And then it starts the
> cycle again. This scheduler ensure there is no starvation of the
> queues, but you do loose more high priority frames when congested.
> 
> > The bottleneck here is in the CPU interface. The SoC simply can't handle
> > all frames coming into a fully occupied link, so we indeed have to limit
> > the number of packets coming into the SoC which speaks for egress rate
> > limiting. We could of course limit the ingress packets on the other
> > ports, but that would mean we have to rate limit each port to the total
> > desired rate divided by the number of ports to be safe, not very
> > optimal.
> 
> Pause frames then start playing a role, maybe instead of, or in
> combination with, egress traffic shaping.
> 
> If the SoC is overloaded, it can send a pause frame. The Switch will
> then pause the scheduler. No packets are sent to the SoC, until it
> unpauses. What i don't know is if the switch itself will send out
> pause frames downstream, when egress queues are getting full. That
> could have bad effects on overall network bandwidth, for frames which
> are not destined for the SoC.

I'm not confident that relying on pause frames on the i.MX6 would be
enough to avoid dropping frames later. The system should also do other
things besides running the network stack. ;)

> If you use egress shaping, you have to make a guess at how many bits
> per second the SoC can handle, and configure the egress shaping to
> that. The scheduler will then take frames from the queues at that
> rate. At least for the older generation of switches, egress shaping
> was rather course grained at the higher speed. Something like 500Mbps,
> 256Mbps, 128Mbps, 64Mbps, etc. So it might not do what you want. And
> older generation switches, ingress shaping is very course grained,
> mostly designed to limit broadcast storms.

I think it's configured for a frame limit in this case, at benchmarks
were done do ensure that this limit is low enough to avoid overload
while also being high enough for the expected ethercat traffic.

> There are lots of options here, how you solve your problem. But you
> cannot look at just the SoC and switch combination. You need to look
> at your whole network design. If you are using 802.1p, who is setting
> the priority bits? If you are using TOS/DSCP, who is setting those
> bits? Is there policing going on in the network edge to ensure other
> traffic in the network is using the lower priority settings? Do you
> really want Ethercat to take the highest priority? I would put it at
> second priority, and make my SSH and SNMP client/server use the
> highest priority, so when it all goes wrong, i can login and take a
> look around to see what happened.

We're currently trying to keep it as simple as possible. :)

The system (consisting of switch and SoC) sets the priority and limits
statically only based on external ports. The ethercat port is trusted
and should have priority over all other ports (where untrusted might
send any amount of traffic).

If that could be configured, I'd of course appreciate a way to pass a
limited amount of SSH/SNMP traffic in a even higher priority. That
seems to be the next step though...

> Once you have a network design, and know what you want the SoC/switch
> combination to do, we can then figure out the correct API to configure
> this. It might be TC with offloads, it might be ethtool with offloads,
> etc.

The system already works with the static configuration in the driver,
but we'd like to find out how to handle this better (in mainline) in
the future (also for updates for this device).

Regards,
Jan


