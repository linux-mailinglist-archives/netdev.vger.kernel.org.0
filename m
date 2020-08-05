Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E2423D265
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHEUM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:12:26 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:57910 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgHEUMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 16:12:19 -0400
Date:   Wed, 05 Aug 2020 20:12:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596658335; bh=baSMOdW67bMowXwINOR0UbY6JzrwQUM2YVb/Ai/ihJU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=b6v83LemAeIIZmbIFJJ90F/J85Aimtey6ArPmkGFLn4zX/f+SPhZoYLT0DE4+0PXm
         fqu1CXNZtdE9zezb4ltX+/A4Sp2HzlYoxu280EiJvRniCv3I+xp4hd3hDZEE5F7d35
         0JJlvmPfjWmue0vrUwT62CNbEzxpCr8XPHE1jb1Ox7S8InF7Kcy3IlcK0ViRbgMVB9
         Yj6gUCDREEUbvL8SdVD21OvzWvcL5BF0ea4HKWsdexTRspRI+jd1pYEyQ7HFPmphO0
         eNDUid95UWybX1I6OiDiKzbtyH5j09nppACnRHtvhEerZJXAcgjA2cB5psXq8hLKCe
         HVQrxxJ9UoCRA==
To:     Andrew Lunn <andrew@lunn.ch>
From:   Swarm NameRedacted <thesw4rm@pm.me>
Cc:     netdev@vger.kernel.org
Reply-To: Swarm NameRedacted <thesw4rm@pm.me>
Subject: Re: Packet not rerouting via different bridge interface after modifying destination IP in TC ingress hook
Message-ID: <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain>
In-Reply-To: <20200805133922.GB1960434@lunn.ch>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain> <20200805133922.GB1960434@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


All fair points, I'll address them one by one.=20
1) The subnet size on everything is /16; everything is on the same
subnet (hence the bridge) except for the client which sends the initial
SYN packet. Modifying the destination MAC address was definitely
something I overlooked and that did get the packet running through the
correct interface. I got a bit thrown off that the bridge has it's own
MAC address that is identical to the LAN interface and couldn't
visualize it as an L2 switch. However, the packet is still being
dropped; I suspect it might be a checksum error but the only incorrect
checksum is TCP. Might have accidentally disabled checksum offloading. I'm =
not
sure

2) The destination IP address is being modified to 10.10.4.1 at L3. However=
, I
forgot to change the destination MAC to eth0 at L2 level as well, as you ju=
st
mentioned.=20

3) The eventual goal is to build my own modified version of the SYNPROXY
protocol that includes some security enhancements in the packet itself.
Therefore, my current plan is to skip conntrack on the gateway
(10.10.3.1) for the packet initially destined to the server (10.10.3.2)=20
and forward the packet to a separate server (10.10.4.1) (virtually configur=
ing it=20
so it is behind another transparent gateway (ip not relevant because the pa=
cket
should just pass right through) accessible via the current gateway). To mak=
e
things simple, I used a bridge on both gateways and am trying to route thro=
ugh
different interfaces on that bridge.=20

Hope that makes sense. Please let me know if there's something I didn't cla=
rify
fully that can be explained further!


On Wed, Aug 05, 2020 at 03:39:22PM +0200, Andrew Lunn wrote:
>=20
> On Wed, Aug 05, 2020 at 08:19:57AM +0000, Swarm NameRedacted wrote:
> > Hi,
> >
> > I am trying to build a quick script via TC direct action and eBPF to
> > modify the destination IP of a packet so that it is routed through a
> > different bridge interface. Made a quick network diagram below to
> > demonstrate it.
> >
> >       Packet (dst: 10.10.3.2)
> >                 |
> >                 |
> >     ingress - (change dst to 10.10.4.1)
> >                 |
> >                 |
> >                eth0
> >                 |
> >                 |
> >       br0 - (addr: 10.10.3.1)
> > __eth0______   ___ens19_______
> >      |                |
> >      |                |
> >      |                |
> >      |                |
> > host: 10.10.4.1  host: 10.10.3.2
> >
> >
> >
> > As shown, I send a packet from a separate client to eth0. eth0 is the
> > WAN interface of its machine and ens19 is the LAN interface; both are
> > connecting with bridge br0. Without modification, the packet goes
> > straight through ens19 to 10.10.3.2.
> >
> > Theoretically, by modifying the destination IP to 10.10.4.1 at ingress,
> > the packet should be rerouted to go back through eth0. However, in
> > practice, I find that the packet still goes through ens19 after
> > modification, and of course after that it never reaches anything.
> >
> > Why is it that ingress catches the packet before the bridging decision,
> > but the packet isn't rerouted? Is there a better way to do this?
>=20
> What is not clear is the subnet size. Is this all a /16 network? So
> that 10.10.4.1 and 10.10.3.2 are in the same subnet? Or are these
> different subnets, and you have a router somewhere you do not show in
> your diagram? Is this redirect happening at L2, or L3? Maybe you even
> have NAT involved, since you talk about WAN and LAN? Do you also need
> to be modifying the destination MAC address?
>=20
> You also need to think about at what layer in the stack is the IP
> address being modified? A bridge works on L2. Is the packet being
> bridges at L2 and sent out without an IP processing at L3? Do you
> actually want to be using ebtables to modify the packet at L2?
>=20
> But maybe take a step back. You are wanting to do something really
> odd. What is your real use case. Maybe there is a better way to do
> what you want. Please explain why you want to send a packet back out
> the way it came in, with a different IP address.
>=20
> =09 Andrew

