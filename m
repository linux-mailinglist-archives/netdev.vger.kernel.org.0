Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB522C51D2
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 11:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbgKZKKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 05:10:46 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57821 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgKZKKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 05:10:45 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChYRk162Dz1qt3d;
        Thu, 26 Nov 2020 11:10:41 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChYRj3dXwz1tTZC;
        Thu, 26 Nov 2020 11:10:41 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id oA5g7oF2f3su; Thu, 26 Nov 2020 11:10:38 +0100 (CET)
X-Auth-Info: eelqe7hB93hzxjN0Q1yceCv73mttuPF1pF1tmko+Exo=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 11:10:38 +0100 (CET)
Date:   Thu, 26 Nov 2020 11:10:14 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Peng Fan <peng.fan@nxp.com>, Fugang Duan <fugang.duan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, stefan.agner@toradex.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzk@kernel.org, "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201126111014.5a6a2049@jawa>
In-Reply-To: <20201126031021.GK2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126000049.GL2073444@lunn.ch>
        <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
        <20201126031021.GK2075216@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/pVwO0Cmh1OVyaGVvC901_rO"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/pVwO0Cmh1OVyaGVvC901_rO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Florian,

> On Wed, Nov 25, 2020 at 05:30:04PM -0800, Florian Fainelli wrote:
> >=20
> >=20
> > On 11/25/2020 4:00 PM, Andrew Lunn wrote: =20
> > > On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote: =20
> > >> This is the first attempt to add support for L2 switch available
> > >> on some NXP devices - i.e. iMX287 or VF610. This patch set uses
> > >> common FEC and DSA code. =20
> > >=20
> > > Interesting. I need to take another look at the Vybrid manual.
> > > Last time i looked, i was more thinking of a pure switchdev
> > > driver, not a DSA driver. So i'm not sure this is the correct
> > > architecture. But has been a while since i looked at the
> > > datasheet. =20
> >=20
> > Agreed the block diagram shows one DMA for each "switch port" which
> > definitively fits more within the switchdev model than the DSA model
> > that re-purposes an existing Ethernet MAC controller as-is and
> > bolts on an integrated or external switch IC. =20
>=20
> Hi Florian
>=20
> I'm not sure it is that simple. I'm looking at the Vybrid
> datasheet. There are two major configurations.
>=20
> 1) The switch is pass through, and does nothing. Then two DMA channels
> are used, one per external port.

This is the "default" state (at least for imx28) - Chapter 29.3.2 on
User Manual [0].

Then you use DMA0 and DMA1 to read/write data to ENET-MAC{01}.

> You basically just have two Ethernet
> interfaces

If I may add important note - on the imx28 the ENET-MAC1 is configured
via ENET-MAC0 (it has FEC_QUIRK_SINGLE_MDIO set in fec_main.c). On this
device it is clearly stated that ENET-MAC1 block functionality is
reduced and its main purpose is to be used with L2 switch.

On the contrary, this flag is not set for vf610 in fec_main.c

>=20
> 2) The switch is active. You then have a 3 port switch, 2 ports for
> the external interfaces, and one port connected to a single DMA
> channel.

+1 (Only DMA0 is used)

>=20
> So when in an active mode, it does look more like a DSA switch.

It also looked like this for me.

>=20
> What is not yet clear to me is how you direct frames out specific
> interfaces. This is where i think we hit problems. I don't see a
> generic mechanism, which is probably why Lukasz put tagger as None.=20

I've put the "None" tag just to share the "testable" RFC code.

It is possible to "tag" frames - at least from the manual [0]:
Chapter: "29.4.9.2 Forced Forwarding".

With using register HW_ENET_SWI_FORCE_FWD_P0
29.9.34 ENET SWI Enable forced forwarding for a frame processed
from port 0 (HW_ENET_SWI_FORCE_FWD_P0)

One can "tag" the packet going from port0 (internal one from SoC) to be
forwarded to port1 (ENET-MAC0) or port2 (ENET-MAC1).

According to the legacy driver [1]:
"* It only replace the MAC lookup function,
 * all other filtering(eg.VLAN verification) act as normal"

> It
> does appear you can control the output of BPDUs, but it is not very
> friendly. You write a register with the port you would like the next
> BPDU to go out, queue the frame up on the DMA, and then poll a bit in
> the register which flips when the frame is actually processed in the
> switch. I don't see how you determine what port a BPDU came in on!
> Maybe you have to use the learning interface?

The learning interface works with the legacy NXP driver (2.6.35) which
copy can be found here[1].

>=20
> Ah, the ESW_FFEN register can be used to send a frame out a specific
> port. Write this register with the destination port, DMA a frame, and
> it goes out the specific port. You then need to write the register
> again for the next frame.

It seems like the description of HW_ENET_SWI_FORCE_FWD_P0 described
above for imx28.

>=20
> I get the feeling this is going to need a very close relationship
> between the 'tagger' and the DMA engine. I don't see how this can be
> done using the DSA architecture, the coupling is too loose.

My first impression was that it could be possible to set this
register in the DSA callback (which normally append the tag to the
frame).

This would work if we can assure that after calling this callback this
frame is transmitted (wait and poll?). Have I correctly understood
your above concern?

I do know that L2 switch has some kind of buffer from DMA0 (port0 - its
input port). However, I don't have access so such detailed manual.

>=20
> It seems like the HW design assumes frames from the CPU will be
> switched using the switch internal FDB, making Linux integration
> "interesting"

The MoreThanIP L2 switch (on imx28) has 2K entries for setting FDB. It
also uses some hash function to speed up access/presence assessment.

>=20
> It does not look like this is a classic DSA switch with a tagging
> protocol.=20

This whole L2 switch implementation available on NXP's SoCs is a bit
odd. It is very highly coupled with FEC, ENET and DMA.

The original driver (2.6.35) was just a copy of FEC driver with some
switch adjustments.

Do you have any idea how to proceed?=20

The vf610 and imx28 are still produced and widely used, so this is
still "actual" topic.

> It might be possible to do VLAN per port, in order to direct
> frames out a specific port?

The old driver had code to support VLANs.

=46rom the manual[0] (29.1):
" Programmable Ingress and Egress VLAN tag addition, removal and
manipulation supporting single and double-tagged VLAN frames"

Also the "29.4.10 Frame Forwarding Tasks" from [0] sheds some more
light on it.

=46rom the manual (29.4.10.2) it looks like the VLAN tag can be appended.
However, I don't know if it will work with VLAN built with L2 switch output=
 ports.

>=20
>        Andrew

Links:

[0] - "i.MX28 Applications Processor Reference Manual, Rev. 2, 08/2013"
[1] -
https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab73401e021=
aef0070e1935a0dba84fb5

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/pVwO0Cmh1OVyaGVvC901_rO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl+/fwYACgkQAR8vZIA0
zr0ymggA4vcElv9I6ZnNL8N4EssoUiXM/9YY4pfPVLYUKZN4zZp55tcleGY5f/cG
LgvU5bVCiElYzSvBqcFQ/6sjVr0BdBfEcbgiq7NB+X2obkpay9OsnJgq7u0fJWxi
OX5Rlef75O/4a1oDkNJZqSFRGsrDZzHG6bhl5dI+Z9pempc5nrlFDrTzsu2EhT1u
jaLZBg3KYnMrL7RJ5+fQcXqImIZcoz+DKjoo5dXZEvhKaQsrb6/KWxjD/oJO+FEF
ZLGHgk0RO4ljK0cKMxXaqVPphqvJ1efcFp/sJG/rNWWg4txgStIp+dfSotWE0u2a
f+DdtMcU+pEXeKA7+hprqIIkpnUg3A==
=2/xW
-----END PGP SIGNATURE-----

--Sig_/pVwO0Cmh1OVyaGVvC901_rO--
