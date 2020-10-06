Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D08284A33
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJFKNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:13:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35616 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJFKNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 06:13:10 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601979186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xK10pf8BI/tkaWDMdVBd8g1AATp8QkJf894bXYXVCY4=;
        b=kpEJZUTqwBp6zymYg2LzNdzKoph29ec1DSY3eLk3c5AA/O7cPw/4tb4f4NhZFzsWlCY6xB
        FLwNTuECmHSzMtejqNUGQvDpPS4y6rDuyPkBB37mbNS1A0Q4bHxRu8qKZiuf11ljQc5xUR
        q96G7O5QKOm02DprW6d+bSp5235R7ImCOHrrxLk3fd7a+coN5018kxS65Rl5R9PDtRlvxn
        F78a7Vm5chm/kt5OUDyN+IXk7gIdxbO0j/vY12npKnyOJb5MNeC9wHIw/RnAF82CFUZ7qj
        04OiY+WqJa0GCmf3iVeZXC/7ryrUE+o/BXFPZFVYyxaHvgVe7JGx/4yB31LXhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601979186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xK10pf8BI/tkaWDMdVBd8g1AATp8QkJf894bXYXVCY4=;
        b=Izn2xt6cMBqeSM6Ukq+09MoNkM3bWivAW+sKGwzsX7FTUGhUKu0yqCjfGbSNJ+1Juu8QDy
        Ki0HP796p1tw0+Bg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201006092017.znfuwvye25vsu4z7@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf>
Date:   Tue, 06 Oct 2020 12:13:04 +0200
Message-ID: <878scj8xxr.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 08:09:39AM +0200, Kurt Kanzenbach wrote:
>> On Sun Oct 04 2020, Vladimir Oltean wrote:
>> > I don't think this works.
>> >
>> > ip link add br0 type bridge vlan_filtering 1
>> > ip link set swp0 master br0
>> > bridge vlan add dev swp0 vid 100
>> > ip link set br0 type bridge vlan_filtering 0
>> > bridge vlan del dev swp0 vid 100
>> > ip link set br0 type bridge vlan_filtering 1
>> >
>> > The expectation would be that swp0 blocks vid 100 now, but with your
>> > scheme it doesn't (it is not unapplied, and not unqueued either, becau=
se
>> > it was never queued in the first place).
>>=20
>> Yes, that's correct. So, I think we have to queue not only the addition
>> of VLANs, but rather the "action" itself such as add or del. And then
>> apply all pending actions whenever vlan_filtering is set.
>
> Please remind me why you have to queue a VLAN addition/removal and can't
> do it straight away? Is it because of private VID 2 and 3, which need to
> be deleted first then re-added from the bridge VLAN group?

It's because of the private VLANs 2 and 3 which shouldn't be tampered
with. Isn't it? You said:

> If you need caching of VLANs installed by the bridge and/or by the 8021q
> module, then you can add those to a list, and restore them in the
> .port_vlan_filtering callback by yourself. You can look at how sja1105
> does that.
[...]
> If your driver makes private use of VLAN tags beyond what the upper
> layers ask for, then it should keep track of them.

That's what I did.

At the end of the day the driver needs to port separation
somehow. Otherwise it doesn't match the DSA model, right? Again there is
no port forwarding matrix which would make things easy. It has to be
solved in software.

If the private VLAN stuff isn't working, because all of the different
corner cases, then what's the alternative?

>
>> >> +static int hellcreek_port_bridge_join(struct dsa_switch *ds, int por=
t,
>> >> +				      struct net_device *br)
>> >> +{
>> >> +	struct hellcreek *hellcreek =3D ds->priv;
>> >> +	int i;
>> >> +
>> >> +	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
>> >> +
>> >> +	/* Configure port's vid to all other ports as egress untagged */
>> >> +	for (i =3D 0; i < ds->num_ports; ++i) {
>> >> +		if (!dsa_is_user_port(ds, i))
>> >> +			continue;
>> >> +
>> >> +		if (i =3D=3D port)
>> >> +			continue;
>> >> +
>> >> +		hellcreek_apply_vlan(hellcreek, i, port, false, true);
>> >> +	}
>> >
>> > I think this is buggy when joining a VLAN filtering bridge. Your ports
>> > will pass frames with VID=3D2 with no problem, even without the user
>> > specifying 'bridge vlan add dev swp0 vid 2', and that's an issue. My
>> > understanding is that VLANs 1, 2, 3 stop having any sort of special
>> > meaning when the upper bridge has vlan_filtering=3D1.
>>=20
>> Yes, that understanding is correct. So, what happens is when a port is
>> joining a VLAN filtering bridge is:
>>=20
>> |root@tsn:~# ip link add name br0 type bridge
>> |root@tsn:~# ip link set dev br0 type bridge vlan_filtering 1
>> |root@tsn:~# ip link set dev lan0 master br0
>> |[  209.375055] br0: port 1(lan0) entered blocking state
>> |[  209.380073] br0: port 1(lan0) entered disabled state
>> |[  209.385340] hellcreek ff240000.switch: Port 2 joins a bridge
>> |[  209.391584] hellcreek ff240000.switch: Apply VLAN: port=3D3 vid=3D2 =
pvid=3D0 untagged=3D1
>> |[  209.399439] device lan0 entered promiscuous mode
>> |[  209.404043] device eth0 entered promiscuous mode
>> |[  209.409204] hellcreek ff240000.switch: Enable VLAN filtering on port=
 2
>> |[  209.415716] hellcreek ff240000.switch: Unapply VLAN: port=3D2 vid=3D2
>> |[  209.421840] hellcreek ff240000.switch: Unapply VLAN: port=3D0 vid=3D2
>
> Now I understand even less. If the entire purpose of
> hellcreek_setup_vlan_membership is to isolate lan0 from lan1

Yes.

> , then why do you even bother to install vid 2 to port=3D3 (lan1) when
> joining a bridge, be it vlan_filtering or not?

So, that traffic is actually switched between the ports.

> In bridged mode, they don't need a unique pvid, it only complicates
> the implementation. They can have the pvid from the bridge VLAN group.

Meaning rely on the fact that VLAN 1 is programmed automatically? Maybe
just unapply the private VLAN in bridge_join()?

>
>> |[  209.428170] hellcreek ff240000.switch: Apply queued VLANs: port2
>> |[  209.434158] hellcreek ff240000.switch: Apply VLAN: port=3D2 vid=3D0 =
pvid=3D0 untagged=3D0
>> |[  209.441649] hellcreek ff240000.switch: Clear queued VLANs: port2
>> |[  209.447920] hellcreek ff240000.switch: Apply queued VLANs: port0
>> |[  209.453910] hellcreek ff240000.switch: Apply VLAN: port=3D0 vid=3D0 =
pvid=3D0 untagged=3D0
>> |[  209.461402] hellcreek ff240000.switch: Clear queued VLANs: port0
>> |[  209.467620] hellcreek ff240000.switch: VLAN prepare for port 2
>> |[  209.473476] hellcreek ff240000.switch: VLAN prepare for port 0
>> |[  209.479534] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 2,=
 untagged, PVID
>> |[  209.487164] hellcreek ff240000.switch: Apply VLAN: port=3D2 vid=3D1 =
pvid=3D1 untagged=3D1
>> |[  209.494659] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 0,=
 untagged, no PVID
>> |[  209.502794] hellcreek ff240000.switch: Apply VLAN: port=3D0 vid=3D1 =
pvid=3D0 untagged=3D1
>> |root@tsn:~# bridge vlan show
>
> This is by no means a good indicator for anything. It shows the bridge
> VLAN groups, not the hardware database.
>
>> |port    vlan ids
>> |lan0     1 PVID Egress Untagged
>> |
>> |br0      1 PVID Egress Untagged
>>=20
>> ... which looks correct to me. The VLAN 2 is unapplied as expected. Or?
>
> Ok, it gets applied in .port_bridge_join and unapplied in .port_vlan_filt=
ering,
> which is a convoluted way of doing nothing.
>
>> >
>> > And how do you deal with the case where swp1 and swp2 are bridged and
>> > have the VLAN 3 installed via 'bridge vlan', but swp3 isn't bridged?
>> > Will swp1/swp2 communicate with swp3? If yes, that's a problem.
>>=20
>> There is no swp3. Currently there are only two ports and either they are
>> bridged or not.
>
> So this answers my question of whether the tunnel port is a user port or
> not, ok.
>
> How about other hardware revisions? Is this going to be a 2-port switch
> forever?

At the moment, yes. It's meant to be used for switched endpoints. More
port devices may come in the future.

> Your solution will indeed work for 2 ports (as long as you
> address the other feedback from v5 w.r.t. declaring the ports as "always
> filtering" and rejecting invalid 8021q uppers, which I don't see
> here),

I've checked that property with ethtool and it's set to the value you
suggested. And yes, the same VLAN on top of single ports will break
separation with the current solution.

> but it will not scale for 3 ports, due to the fact that the bridge can
> install a VLAN on a lan2 port, without knowing that it is in fact the
> private pvid of lan1 or lan0.

Yes, that's also a limitation of the VLAN approach.

>
>> >> +static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
>> >> +			       const struct hellcreek_fdb_entry *entry)
>> >> +{
>> >> +	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=3D%pM!\n", entry->ma=
c);
>> >> +
>> >
>> > Do these dev_dbg statements bring much value at all, even to you?
>>=20
>> Yes, they do. See the log snippet above.
>>=20
>
> If you want to dump the hardware database you can look at the devlink
> regions that Andrew added very recently. Much more reliable than
> following the order of operations in the log.

I saw the patches and it's really useful. However, I won't implement any
new features to this drivers unless that port separation problem is
sorted out.

>
>> >> +static const struct hellcreek_platform_data de1soc_r1_pdata =3D {
>> >> +	.num_ports	 =3D 4,
>> >> +	.is_100_mbits	 =3D 1,
>> >> +	.qbv_support	 =3D 1,
>> >> +	.qbv_on_cpu_port =3D 1,
>> >
>> > Why does this matter?
>>=20
>> Because Qbv on the CPU port is a feature and not all switch variants
>> have that. It will matter as soon as TAPRIO is implemented.
>
> How do you plan to install a tc-taprio qdisc on the CPU port?

That's an issue to be sorted out.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98QzAACgkQeSpbgcuY
8KYdmg//VozsCRd3dfovBIAzeczZEpyo4+FweXZdaZcaF6fwPZnyxe3W/FyVKSGw
EPkoXf7TRrlFSwtZ63RVcyloC7Pb89xK1IJOsrTOkcASS7TF9SqSzCC0vTZrYtSI
pIUu6w8Fu9mCB0WTocG9ue9cr9Y0eovDY6eK5ypsowuOg8iCqzQ1PDtYo8ONmPQy
lGLh6c5iMwFen9xkz5/WdXV9vPIbTCtzOSzhrDDdtxdojcERM/3Q0D5eVekZfZfk
iVyZhdAdL6Rl006hh9OQ5BrCx/g2YUcXsUOTpAoHgnbj6uH32gRAi+Y85x6SjDcv
YadOTTArV1yaVsqG6yYiCUQ/2otcyQxD9kQ67Y0S3mrn8aZqXSvGzZrOCd8FKAim
7gEPTTBNK7KJrlDpLjs6beNwwf1wd/iFGaK3MSL4naUNaFct3zFOvc03XV91y+0C
ypGUtdKqK9C4vGkhAbGrGA3JiNiYugkkcJa8Kp0teyx5VV2KtNi1OT9YNvf8+r9l
RvYimlW2QBxtYkazb7WNpNs7RDGS19DrBa2kJa4zRlI3SqxMHTl873wTYvkyUZXO
d+2KBsJChujiBOY29Jvgbmw20qvURsYIx3OagvG8cMoWedC+ZmEYjYmgnCpeoWjh
4tu/ORcY7sHArzi1I65tHxzm+9icsfGXlCoZyO1iYuDuFENMlr0=
=ZxDb
-----END PGP SIGNATURE-----
--=-=-=--
