Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EAAB7A97
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390197AbfISNeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:34:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388898AbfISNeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 09:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CHA1o9QHSaj0gdYXnG4ciDjlyuqP5uOfjD5O4CFDhCE=; b=iMV3YdH5qzr/hDvbMXnzNEVEzE
        sh28BNFGe4dWrkFMtV5XgTcCH47jVUHPibbEDnZaw9K7Fa2MzVi31DzATE+n2kihkvfJw6K+xqcBb
        clbf0vi+Z766KgMMqshZpDd+FkBgdlNefU7wgQOsexQrKrK4zW2dkpC4OnDIvqrnBfmg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAwZX-00065Y-Qu; Thu, 19 Sep 2019 15:34:11 +0200
Date:   Thu, 19 Sep 2019 15:34:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Subject: Re: dsa traffic priorization
Message-ID: <20190919133411.GA22556@lunn.ch>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 10:00:51AM +0200, Sascha Hauer wrote:
> Hi Vladimir,
> 
> On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> > Hi Sascha,
> > 
> > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > >
> > > Hi All,
> > >
> > > We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> > > regular network traffic on another port. The customer wants to configure two things
> > > on the switch: First Ethercat traffic shall be priorized over other network traffic
> > > (effectively prioritizing traffic based on port). Second the ethernet controller
> > > in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> > > port shall be rate limited.
> > >
> > 
> > You probably already know this, but egress shaping will not drop
> > frames, just let them accumulate in the egress queue until something
> > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > tail dropping is enabled, etc). Is this what you want?
> 
> If I understand correctly then the switch has multiple output queues per
> port.

There are 4 egress queues per port.

> The Ethercat traffic will go to a higher priority queue and on
> congestion on other queues, frames designated for that queue will be
> dropped.

On ingress, there are various ways to add a priority to a frame, which
then determines which egress queue it lands in. This can be static,
all frames which ingress port X have priority Y. It can look at the
802.1p header and map the l2 priority to an queue priority. It can
look at the IPv4 TOS/DSCP value and map it to a queue priority. And
you can also use the TCAM, when it matches on a frame, it can specify
the frame priority.

If the egress queue, as selected by the queue priority is full, the
frame will be dropped.

> I just talked to our customer and he verified that their
> Ethercat traffic still goes through even when the ports with the general
> traffic are jammed with packets. So yes, I think this is what I want.

Taking frames out of the port egress queues and passing them out the
interface is then determined by the scheduler. There are two different
configurations which can be used

1) Strict priority. Frames are taken from the highest priority queue,
until it is empty. If the highest priority queue is empty, frames are
taken from the second highest priority queue. And if the second
priority is empty, the third priority queue is used, etc. This can
lead to starvation, when the lower priority queue never get serviced
because the higher priority queue have sufficient frames to keep the
line busy.

2) Weighted round robin. It takes up to 8 frames from the highest
priority queue, then up to 4 frames from the second highest priority
queue, then up to 2 frames from the 3rd highest priority queue, and
then 1 frame from the lower priority frame. And then it starts the
cycle again. This scheduler ensure there is no starvation of the
queues, but you do loose more high priority frames when congested.

> The bottleneck here is in the CPU interface. The SoC simply can't handle
> all frames coming into a fully occupied link, so we indeed have to limit
> the number of packets coming into the SoC which speaks for egress rate
> limiting. We could of course limit the ingress packets on the other
> ports, but that would mean we have to rate limit each port to the total
> desired rate divided by the number of ports to be safe, not very
> optimal.

Pause frames then start playing a role, maybe instead of, or in
combination with, egress traffic shaping.

If the SoC is overloaded, it can send a pause frame. The Switch will
then pause the scheduler. No packets are sent to the SoC, until it
unpauses. What i don't know is if the switch itself will send out
pause frames downstream, when egress queues are getting full. That
could have bad effects on overall network bandwidth, for frames which
are not destined for the SoC.

If you use egress shaping, you have to make a guess at how many bits
per second the SoC can handle, and configure the egress shaping to
that. The scheduler will then take frames from the queues at that
rate. At least for the older generation of switches, egress shaping
was rather course grained at the higher speed. Something like 500Mbps,
256Mbps, 128Mbps, 64Mbps, etc. So it might not do what you want. And
older generation switches, ingress shaping is very course grained,
mostly designed to limit broadcast storms.

There are lots of options here, how you solve your problem. But you
cannot look at just the SoC and switch combination. You need to look
at your whole network design. If you are using 802.1p, who is setting
the priority bits? If you are using TOS/DSCP, who is setting those
bits? Is there policing going on in the network edge to ensure other
traffic in the network is using the lower priority settings? Do you
really want Ethercat to take the highest priority? I would put it at
second priority, and make my SSH and SNMP client/server use the
highest priority, so when it all goes wrong, i can login and take a
look around to see what happened.

Once you have a network design, and know what you want the SoC/switch
combination to do, we can then figure out the correct API to configure
this. It might be TC with offloads, it might be ethtool with offloads,
etc.

	Andrew
