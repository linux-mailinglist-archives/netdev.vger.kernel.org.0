Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5013546AED7
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353905AbhLGAPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:15:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351463AbhLGAPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F84N0HoTUZ+u5yuRo7uZLxocDWFVFcBsv1IEqZCqmjA=; b=AxjT3qSnP9vpfboVg1kN3/nSZN
        6HNVSntDAnIdtYDfvtyb7L3eY188CE48NrwhJzuINHyNUjQK+rVI7rATwtrvjSepfHRBytdAuBcbr
        zx2aSZ+zu03cRfakS/PQFP7zcY3FxJa4J6uEqXYZKNxYqYHsXNkcnidEybOBwmeebXxM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muO5W-00FinB-S4; Tue, 07 Dec 2021 01:12:06 +0100
Date:   Tue, 7 Dec 2021 01:12:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount
 tracking
Message-ID: <Ya6m1kIqVo52FkLV@lunn.ch>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch>
 <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch>
 <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:04:19PM -0800, Eric Dumazet wrote:
> On Mon, Dec 6, 2021 at 4:00 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Mon, Dec 06, 2021 at 03:44:57PM -0800, Eric Dumazet wrote:
> > > On Mon, Dec 6, 2021 at 3:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > On Sat, Dec 04, 2021 at 08:21:54PM -0800, Eric Dumazet wrote:
> > > > > From: Eric Dumazet <edumazet@google.com>
> > > > >
> > > > > Two first patches add a generic infrastructure, that will be used
> > > > > to get tracking of refcount increments/decrements.
> > > >
> > > > Hi Eric
> > > >
> > > > Using this i found:
> > > >
> > > > [  774.108901] unregister_netdevice: waiting for eth0 to become free. Usage count = 4
> > > > [  774.110864] leaked reference.
> > > > [  774.110874]  dst_alloc+0x7a/0x180
> > > > [  774.110887]  ip6_dst_alloc+0x27/0x90
> > > > [  774.110894]  ip6_pol_route+0x257/0x430
> > > > [  774.110900]  ip6_pol_route_output+0x19/0x20
> > > > [  774.110905]  fib6_rule_lookup+0x18b/0x270
> > > > [  774.110914]  ip6_route_output_flags_noref+0xaa/0x110
> > > > [  774.110918]  ip6_route_output_flags+0x32/0xa0
> > > > [  774.110922]  ip6_dst_lookup_tail.constprop.0+0x181/0x240
> > > > [  774.110929]  ip6_dst_lookup_flow+0x43/0xa0
> > > > [  774.110934]  inet6_csk_route_socket+0x166/0x200
> > > > [  774.110943]  inet6_csk_xmit+0x56/0x130
> > > > [  774.110946]  __tcp_transmit_skb+0x53b/0xc30
> > > > [  774.110953]  __tcp_send_ack.part.0+0xc6/0x1a0
> > > > [  774.110958]  tcp_send_ack+0x1c/0x20
> > > > [  774.110964]  __tcp_ack_snd_check+0x42/0x200
> > > > [  774.110968]  tcp_rcv_established+0x27a/0x6f0
> > > > [  774.110973] leaked reference.
> > > > [  774.110975]  ipv6_add_dev+0x13e/0x4f0
> > > > [  774.110982]  addrconf_notify+0x2ca/0x950
> > > > [  774.110989]  raw_notifier_call_chain+0x49/0x60
> > > > [  774.111000]  call_netdevice_notifiers_info+0x50/0x90
> > > > [  774.111007]  __dev_change_net_namespace+0x30d/0x6c0
> > > > [  774.111016]  do_setlink+0xdc/0x10b0
> > > > [  774.111024]  __rtnl_newlink+0x608/0xa10
> > > > [  774.111031]  rtnl_newlink+0x49/0x70
> > > > [  774.111038]  rtnetlink_rcv_msg+0x14f/0x380
> > > > [  774.111046]  netlink_rcv_skb+0x55/0x100
> > > > [  774.111053]  rtnetlink_rcv+0x15/0x20
> > > > [  774.111059]  netlink_unicast+0x230/0x340
> > > > [  774.111064]  netlink_sendmsg+0x252/0x4b0
> > > > [  774.111075]  sock_sendmsg+0x65/0x70
> > > > [  774.111080]  ____sys_sendmsg+0x24e/0x290
> > > > [  774.111084]  ___sys_sendmsg+0x81/0xc0
> > > >
> > > > I'm using GNS3 to simulate a network topology. So a collection of veth
> > > > pairs, bridges and tap interfaces spread over a few namespaces. The
> > > > network being simulated uses Segment Routing. And traceroute might also
> > > > involved in this somehow. I have 3 patches applied, to make traceroute
> > > > actually work when SRv6 is being used. You can find v3 here:
> > > >
> > > > https://lore.kernel.org/netdev/20211203162926.3680281-3-andrew@lunn.ch/T/
> > > >
> > > > I'm not sure if these patches are part of the problem or not. None of
> > > > the traces i've seen are directly on the ICMP path. traceroute is
> > > > using udp, and one of the traces above is for tcp, and the other looks
> > > > like it is moving an interface into a different namespace?
> > > >
> > > > This is net-next from today.
> > >
> > > I do not understand, net-next does not contain this stuff yet ?
> >
> > Hi Eric
> >
> > I'm getting warnings like:
> >
> > unregister_netdevice: waiting for eth0 to become free. Usage count = 4
> >
> > which is what your patchset is supposed to help fix. So i applied what
> > has been posted so far, in the hope it would find the issue. It is
> > reporting something...
> 
> I thought you were telling me that you got these new reports after the
> patch set being applied ?

Hi Eric

No. I applied them.

> Or were they happening because of your other changes ?

Hard to say. It looks like some sort of race condition. Sometimes when
i shut down the GNS3 simulation, i get the issues, sometimes not. I
don't have a good enough feeling to say either way, is it an existing
problem, or it is my code which is triggering it.

> > > I have other patches, this work is still in progress.
> >
> > Is what is currently posted usable? Do these traces above point at the
> > real problem i have, or because there are more patches, i should not
> > trust the output?
> 
> I think I have not worked yet on the XFRM side in patch set 1.
> Are you using XFRM ?

I don't think SRv6 uses XFRM.

  Andrew
