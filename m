Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F749202C25
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgFUTUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 15:20:45 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:56191 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgFUTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 15:20:45 -0400
Received: (qmail 13676 invoked by uid 89); 21 Jun 2020 19:20:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 21 Jun 2020 19:20:44 -0000
Date:   Sun, 21 Jun 2020 12:20:40 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Message-ID: <20200621192040.wrwbbcvfycqvr23p@bsd-mbp>
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon>
 <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
 <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com>
 <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
 <CAHApi-kMwnvRwJO8LT2UtrixVSd_bDgWybOP6H_eLTBmSFsd4A@mail.gmail.com>
 <20200620184202.q2a6hdsttssb55t4@bsd-mbp>
 <CAHApi-=5uHyRu54QHCWzFr1XpFuAhbRiy1QWFjudXuFOLC5dKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHApi-=5uHyRu54QHCWzFr1XpFuAhbRiy1QWFjudXuFOLC5dKA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 12:03:14PM +0200, Kal Cutter Conley wrote:
> On Sat, Jun 20, 2020 at 8:42 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Sat, Jun 20, 2020 at 12:42:36PM +0200, Kal Cutter Conley wrote:
> > > On Thu, Jun 18, 2020 at 5:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > >
> > > > On Sun, Jun 14, 2020 at 10:55:30AM +0200, Kal Cutter Conley wrote:
> > > > > Hi Saeed,
> > > > > Thanks for explaining the reasoning behind the special mlx5 queue
> > > > > numbering with XDP zerocopy.
> > > > >
> > > > > We have a process using AF_XDP that also shares the network interface
> > > > > with other processes on the system. ethtool rx flow classification
> > > > > rules are used to route the traffic to the appropriate XSK queue
> > > > > N..(2N-1). The issue is these queues are only valid as long they are
> > > > > active (as far as I can tell). This means if my AF_XDP process dies
> > > > > other processes no longer receive ingress traffic routed over queues
> > > > > N..(2N-1) even though my XDP program is still loaded and would happily
> > > > > always return XDP_PASS. Other drivers do not have this usability issue
> > > > > because they use queues that are always valid. Is there a simple
> > > > > workaround for this issue? It seems to me queues N..(2N-1) should
> > > > > simply map to 0..(N-1) when they are not active?
> > > >
> > > > If your XDP program returns XDP_PASS, the packet should be delivered to
> > > > the xsk socket.  If the application isn't running, where would it go?
> > > >
> > > > I do agree that the usability of this can be improved.  What if the flow
> > > > rules are inserted and removed along with queue creatioin/destruction?
> > >
> > > I think I misunderstood your suggestion here. Do you mean the rules
> > > should be inserted / removed on the hardware level but still show in
> > > ethtool even if they are not active in the hardware? In this case the
> > > rules always occupy a "location" but just never apply if the
> > > respective queues are not "enabled". I think this would be the best
> > > possible solution.
> >
> > No, that wasn't what I was suggesting.  I would think that having
> > ethtool return something that isn't true woulld be really confusing -
> > either the rules are enabled and active, or they should not be there.
> 
> I think how Mellanox handles XDP ZC queue numbering is confusing no
> matter what (at least given the current ethtool interface). However,
> in its current form, it is not only confusing, it is also problematic.
> 
> If they changed the behavior so that the rules no longer apply when
> the respective queues are inactive, then at least it would be less
> _problematic_.
> 
> Would it really be more confusing if they made this change? Consider
> what ethtool currently shows. For example, if I have 8 RX channels
> configured and a RX classification rule for (XSK) queue 15:
> 
> [root@localhost ~]# ethtool -n eth0
> 8 RX rings available
> Total 1 rules
> 
> Filter: 0
>         Rule Type: UDP over IPv4
>         Src IP addr: 0.0.0.0 mask: 255.255.255.255
>         Dest IP addr: 169.254.116.10 mask: 0.0.0.0
>         TOS: 0x0 mask: 0xff
>         Src port: 0 mask: 0xffff
>         Dest port: 0 mask: 0xffff
>         Action: Direct to queue 15
> 
> ethtool prints 8 available queues and at the same time filter 0
> directs traffic to queue 15. So it's already apparent here that queue
> 15 is special (since it says only 8 are available).

True.  The issue is that ZC queues /are/ special, they are bound to an
application which provides the packet memory, and are not truly general
purpose queues for use by the system.


> > I was thinking more along the lines of having the flow rules inserted
> > and removed when the queue is created/destroyed, so the steering rule is
> > a property of the queue itself rather than maintained externally through
> > ethtool.
> 
> I think presenting the flow rules as a property of the interface makes
> more sense (as they are now). Since:
>     (1) Flow rules affect all traffic for the interface.

Queues are a property of the interface, in that adding or removing a queue
changes the interface behavior.  It would seem reasonable that these
queue changes would also change interface properties.


>     (2) Since flow rules are ordered (the first rule that matches is
> used), a rule's "location" (priority) has to be global to the
> interface anyway.

The ordering of flow rules is an issue, I don't have an answer for that.


>     (3) Flow rules can be used to discard traffic. In this case, there
> is no queue to be a property of.

I'm only advocating adding rules which are specific for the queue.


>     (4) What if you wanted to support more complicated rules that
> apply to multiple queues? E.g. Say all 10.0.0.0/8 traffic should use
> queues 0-3 (which particular queue is used for a flow depends on
> rxhash).

Today, this could be done with the 'context' parameter to -X and -N.
However, I don't think that -X accepts N..(2N-1) numbering, so only
flow_steering to a specific queue is available.


It might be nice to have:

  ethtool -X eth0 context new empty         <--- empty context
  ethtool -N eth0 flow-type ... context 1
  ethtool -X eth0 context 1 queue 15        <--- add member

Where the RSS context starts out empty (drop packets), and queues are
explicitly added to them, intead of starting with a default context.
This way flow rules don't change, just the RSS membership.  This does
change the flow_hash steering as queues are added/removed, which could
be an issue.  If the queue doesn't exist, then the packet is dropped.
-- 
Jonathan
