Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54095220C8B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgGOL6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 07:58:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26248 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725852AbgGOL6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 07:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594814308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9n9lYmSeeo9J5ibHnaaSR5M7gWIEK+ZBT//pHz72J8=;
        b=J79Aizx3XmwUd2gh9R5cYe1FTzlcKRaIm24YSgaUlaXcGpKAAfJM7AL//xj0cPVYEVL3UZ
        tR1qTqC5yBaxXTp8WVW9JxtkT1To3fOzT9ov6cI/24z0cMbx+w8I9yilGDVOwYeMRszTYK
        F+tcy4R2qIAfcNT2Vreo+O606cM2ZH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-LgyUgG85PgCOGhdoRmr9JQ-1; Wed, 15 Jul 2020 07:58:25 -0400
X-MC-Unique: LgyUgG85PgCOGhdoRmr9JQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 074F518C63C0;
        Wed, 15 Jul 2020 11:58:24 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 378EE74F71;
        Wed, 15 Jul 2020 11:58:20 +0000 (UTC)
Date:   Wed, 15 Jul 2020 13:58:11 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     Numan Siddique <nusiddiq@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200715135811.079ccdb7@elisabeth>
In-Reply-To: <f7timepu916.fsf@dhcp-25.97.bos.redhat.com>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <20200713120158.665a6677@elisabeth>
        <CAH=CPzopMgQ=RU2jCSqDxM3ghtTMGZLBiPoh+3k4wXnGEeC+fw@mail.gmail.com>
        <f7timepu916.fsf@dhcp-25.97.bos.redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aaron,

On Tue, 14 Jul 2020 16:38:29 -0400
Aaron Conole <aconole@redhat.com> wrote:

> Numan Siddique <nusiddiq@redhat.com> writes:
>=20
> > On Mon, Jul 13, 2020 at 3:34 PM Stefano Brivio <sbrivio@redhat.com> wro=
te: =20
> >>
> >> On Mon, 13 Jul 2020 10:04:13 +0200
> >> Florian Westphal <fw@strlen.de> wrote:
> >> =20
> >> > Stefano Brivio <sbrivio@redhat.com> wrote: =20
> >> > > Hi,
> >> > >
> >> > > On Sun, 12 Jul 2020 22:07:03 +0200
> >> > > Florian Westphal <fw@strlen.de> wrote:
> >> > > =20
> >> > > > vxlan and geneve take the to-be-transmitted skb, prepend the
> >> > > > encapsulation header and send the result.
> >> > > >
> >> > > > Neither vxlan nor geneve can do anything about a lowered path mtu
> >> > > > except notifying the peer/upper dst entry. =20
> >> > >
> >> > > It could, and I think it should, update its MTU, though. I didn't
> >> > > include this in the original implementation of PMTU discovery for =
UDP
> >> > > tunnels as it worked just fine for locally generated and routed
> >> > > traffic, but here we go. =20
> >> >
> >> > I don't think its a good idea to muck with network config in response
> >> > to untrusted entity. =20
> >>
> >> I agree that this (changing MTU on VXLAN) looks like a further step,
> >> but the practical effect is zero: we can't send those packets already
> >> today.
> >>
> >> PMTU discovery has security impacts, and they are mentioned in the
> >> RFCs. Also here, we wouldn't increase the MTU as a result, and if the
> >> entity is considered untrusted, considerations from RFC 8201 and RFC
> >> 4890 cover that.
> >>
> >> In practice, we might have broken networks, but at a practical level, I
> >> guess it's enough to not make the situation any worse.
> >> =20
> >> > > As PMTU discovery happens, we have a route exception on the lower
> >> > > layer for the given path, and we know that VXLAN will use that pat=
h,
> >> > > so we also know there's no point in having a higher MTU on the VXL=
AN
> >> > > device, it's really the maximum packet size we can use. =20
> >> >
> >> > No, in the setup that prompted this series the route exception is wr=
ong.
> >> > The current "fix" is a shell script that flushes the exception as so=
on
> >> > as its added to keep the tunnel working... =20
> >>
> >> Oh, oops.
> >>
> >> Well, as I mentioned, if this is breaking setups and this series is the
> >> only way to fix things, I have nothing against it, we can still work on
> >> a more comprehensive solution (including the bridge) once we have it.
> >> =20
> >> > > > Some setups, however, will use vxlan as a bridge port (or openvs=
 vport). =20
> >> > >
> >> > > And, on top of that, I think what we're missing on the bridge is to
> >> > > update the MTU when a port lowers its MTU. The MTU is changed only=
 as
> >> > > interfaces are added, which feels like a bug. We could use the low=
er
> >> > > layer notifier to fix this. =20
> >> >
> >> > I will defer to someone who knows bridges better but I think that
> >> > in bridge case we 100% depend on a human to set everything. =20
> >>
> >> Not entirely, MTU is auto-adjusted when interfaces are added (unless
> >> the user set it explicitly), however:
> >> =20
> >> > bridge might be forwarding frames of non-ip protocol and I worry that
> >> > this is a self-induced DoS when we start to alter configuration behi=
nd
> >> > sysadmins back. =20
> >>
> >> ...yes, I agree that the matter with the bridge is different. And we
> >> don't know if that fixes anything else than the selftest I showed, so
> >> let's forget about the bridge for a moment.
> >> =20
> >> > > I tried to represent the issue you're hitting with a new test case=
 in
> >> > > the pmtu.sh selftest, also included in the diff. Would that work f=
or
> >> > > Open vSwitch? =20
> >> >
> >> > No idea, I don't understand how it can work at all, we can't 'chop
> >> > up'/mangle l2 frame in arbitrary fashion to somehow make them pass to
> >> > the output port.  We also can't influence MTU config of the links pe=
er. =20
> >>
> >> Sorry I didn't expand right away.
> >>
> >> In the test case I showed, it works because at that point sending
> >> packets to the bridge will result in an error, and the (local) sender
> >> fragments. Let's set this aside together with the bridge affair, thoug=
h.
> >>
> >> Back to VXLAN and OVS: OVS implements a "check_pkt_len" action, cf.
> >> commit 4d5ec89fc8d1 ("net: openvswitch: Add a new action
> >> check_pkt_len"), that should be used when packets exceed link MTUs:
> >>
> >>   With the help of this action, OVN will check the packet length
> >>   and if it is greater than the MTU size, it will generate an
> >>   ICMP packet (type 3, code 4) and includes the next hop mtu in it
> >>   so that the sender can fragment the packets.
> >>
> >> and my understanding is that this can only work if we reflect the
> >> effective MTU on the device itself (including VXLAN).
> >> =20
> >
> > check_pkt_len is OVS datapath action and the corresponding OVS action
> > is  check_pkt_larger.
> >
> > Logically It is expected to use this way in the OVS flows- >
> >     reg0[0] =3D check_pkt_larger(1500);
> >     if reg0[0[ =3D=3D 1; then take some action.
> >
> > In the case of OVN, if the register reg0[0] bit is set, then we
> > generate ICMP error packet (type 3, code 4).
> >
> > I don't know the requirements or the issue this patch is trying to
> > address. But I think for OVS, there has to be
> > a controller (like OVN) which makes use of the check_pkt_larger action
> > and takes necessary action by adding
> > appropriate OF flows based on the result of check_pkt_larger. =20
>=20
> Hi Numan,
>=20
> The issue is that a route exception might lower the MTU for the
> destination, and the controller would need to be made aware of that.
>=20
> In that case, it could update any check_packet_len rules.  But it's not
> desirable for this type of rules to be explicitly required at all, imo.
> And for setups where user wants to use action=3Dnormal, or no openflow
> controller is used (a large number of OvS deployments), I think it will
> still be broken.

I agree that the controller shouldn't deal with this, because it's not
a configuration topic, unless the user wants to set particular MTUs --
in which case sure, it's configuration.

Open vSwitch is responsible for forwarding packets, why can't it
relay/use the required ICMP messages?

> I've cooked up a change to OvS to correspond to this series:
>=20
> https://github.com/orgcandman/ovs/commit/0c063e4443dda1f62c9310bda7f54140=
b9dc9c31

=46rom the commit message:

> Some network topologies use vxlan/geneve tunnels in a non-routed setup,
> and the presence of a route exception would interfere with packet
> egress, causing unresolvable network conditions due to MTU mismatches.

Florian explained clearly why PMTU discovery is currently not working
*with a Linux bridge* connected to some type of tunnels (I haven't checked
IP tunnels yet), and proposed a solution fixing that problem. However,
he also mentioned that solution doesn't fix the issue with Open vSwitch,
because it's discarding the (additional) ICMP messages implemented there.

I proposed another solution that also works, only for a Linux bridge
though.

Open vSwitch, as far as I understand, doesn't use Linux bridges. What
is the actual problem with Open vSwitch? How does the route exception
"interfere with packet egress"? Why do you have "MTU mismatches"? The
route exception itself is correct. Can you elaborate?

> Some operating systems allow the user to choose the path MTU discovery
> strategy, whether it should ignore dst cache exception information, etc.

Linux does too, you can set /proc/sys/net/ipv4/ip_no_pmtu_disc to 1 and
PMTU discovery is disabled, for IPv4. I don't think that breaking PMTU
discovery only on some selected interfaces, that could be routed
between each other, is a sane option. I also wouldn't recommend
disabling it (for the reasons explained in RFC 1191), especially in a
complex networking environment.

For IPv6, it's "just" strongly recommended by RFC 8200 to implement it.
However, if a node doesn't implement it, it must restrict itself to the
minimum link MTU, 1280 bytes. By allowing to disable PMTU discovery on
IPv6 nodes and not enforcing that limit we introduce a significant
breakage.

--=20
Stefano

