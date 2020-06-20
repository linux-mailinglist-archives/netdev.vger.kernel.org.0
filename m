Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB4202602
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgFTSmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 14:42:10 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:12220 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgFTSmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 14:42:09 -0400
Received: (qmail 42983 invoked by uid 89); 20 Jun 2020 18:42:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 20 Jun 2020 18:42:06 -0000
Date:   Sat, 20 Jun 2020 11:42:02 -0700
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
Message-ID: <20200620184202.q2a6hdsttssb55t4@bsd-mbp>
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon>
 <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
 <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com>
 <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
 <CAHApi-kMwnvRwJO8LT2UtrixVSd_bDgWybOP6H_eLTBmSFsd4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHApi-kMwnvRwJO8LT2UtrixVSd_bDgWybOP6H_eLTBmSFsd4A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 12:42:36PM +0200, Kal Cutter Conley wrote:
> On Thu, Jun 18, 2020 at 5:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Sun, Jun 14, 2020 at 10:55:30AM +0200, Kal Cutter Conley wrote:
> > > Hi Saeed,
> > > Thanks for explaining the reasoning behind the special mlx5 queue
> > > numbering with XDP zerocopy.
> > >
> > > We have a process using AF_XDP that also shares the network interface
> > > with other processes on the system. ethtool rx flow classification
> > > rules are used to route the traffic to the appropriate XSK queue
> > > N..(2N-1). The issue is these queues are only valid as long they are
> > > active (as far as I can tell). This means if my AF_XDP process dies
> > > other processes no longer receive ingress traffic routed over queues
> > > N..(2N-1) even though my XDP program is still loaded and would happily
> > > always return XDP_PASS. Other drivers do not have this usability issue
> > > because they use queues that are always valid. Is there a simple
> > > workaround for this issue? It seems to me queues N..(2N-1) should
> > > simply map to 0..(N-1) when they are not active?
> >
> > If your XDP program returns XDP_PASS, the packet should be delivered to
> > the xsk socket.  If the application isn't running, where would it go?
> >
> > I do agree that the usability of this can be improved.  What if the flow
> > rules are inserted and removed along with queue creatioin/destruction?
> 
> I think I misunderstood your suggestion here. Do you mean the rules
> should be inserted / removed on the hardware level but still show in
> ethtool even if they are not active in the hardware? In this case the
> rules always occupy a "location" but just never apply if the
> respective queues are not "enabled". I think this would be the best
> possible solution.

No, that wasn't what I was suggesting.  I would think that having
ethtool return something that isn't true woulld be really confusing -
either the rules are enabled and active, or they should not be there.

I was thinking more along the lines of having the flow rules inserted
and removed when the queue is created/destroyed, so the steering rule is
a property of the queue itself rather than maintained externally through
ethtool.
-- 
Jonathan
