Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D177A2C5E3F
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 00:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392018AbgKZXgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 18:36:39 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:59447 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732167AbgKZXgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 18:36:38 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChvKY2zW3z1qskn;
        Fri, 27 Nov 2020 00:36:32 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChvKW71Z2z1sh3R;
        Fri, 27 Nov 2020 00:36:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id TExvVxqt6aay; Fri, 27 Nov 2020 00:36:29 +0100 (CET)
X-Auth-Info: /KImQciEhjbmBIgiLvM79DbQY7tUf4akdutrOlw6e1E=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Nov 2020 00:36:28 +0100 (CET)
Date:   Fri, 27 Nov 2020 00:35:49 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201127003549.3753d64a@jawa>
In-Reply-To: <20201126123027.ocsykutucnhpmqbt@skbuf>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/gacppz5A.ZWWtZ7gJFa2=fh"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gacppz5A.ZWWtZ7gJFa2=fh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> Hi Lukasz,
>=20
> On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote:
> > This is the first attempt to add support for L2 switch available on
> > some NXP devices - i.e. iMX287 or VF610. This patch set uses common
> > FEC and DSA code.
> >
> > This code provides _very_ basic switch functionality (packets are
> > passed between lan1 and lan2 ports and it is possible to send
> > packets via eth0), at its main purpose is to establish the way of
> > reusing the FEC driver. When this is done, one can add more
> > advanced features to the switch (like vlan or port separation).
> >
> > I also do have a request for testing on e.g. VF610 if this driver
> > works on it too.
> > The L2 switch documentation is very scant on NXP's User Manual [0]
> > and most understanding of how it really works comes from old
> > (2.6.35) NXP driver [1]. The aforementioned old driver [1] was
> > monolitic and now this patch set tries to mix FEC and DSA.
> >
> > Open issues:
> > - I do have a hard time on understanding how to "disable"
> > ENET-MAC{01} ports in DSA (via port_disable callback in
> > dsa_switch_ops). When I disable L2 switch port1,2 or the
> > ENET-MAC{01} in control register, I cannot simply re-enable it with
> > enabling this bit again. The old driver reset (and setup again) the
> > whole switch. =20
>=20
> You don't have to disable the ports if that does more harm than good,
> of course.

Ok.

>=20
> > - The L2 switch is part of the SoC silicon, so we cannot follow the
> > "normal" DSA pattern with "attaching" it via mdio device. The
> > switch reuses already well defined ENET-MAC{01}. For that reason
> > the MoreThanIP switch driver is registered as platform device =20
>=20
> That is not a problem. Also, I would not say that the "normal" DSA
> pattern is to have an MDIO-attached switch. Maybe that was true 10
> years ago. But now, we have DSA switches registered as platform
> devices, I2C devices, SPI devices, PCI devices. That is not an issue
> under any circumstance.

Ok. The MTIP switch now registers as platform device.

>=20
> > - The question regarding power management - at least for my use
> > case there is no need for runtime power management. The L2 switch
> > shall work always at it connects other devices.
> >
> > - The FEC clock is also used for L2 switch management and
> > configuration (as the L2 switch is just in the same, large IP
> > block). For now I just keep it enabled so DSA code can use it. It
> > looks a bit problematic to export fec_enet_clk_enable() to be
> > reused on DSA code.
> >
> > Links:
> > [0] - "i.MX28 Applications Processor Reference Manual, Rev. 2,
> > 08/2013" [1] -
> > https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab73401=
e021aef0070e1935a0dba84fb5
> > =20
>=20
> Disclaimer: I don't know the details of imx28, it's just now that I
> downloaded the reference manual to see what it's about.
>=20
> I would push back and say that the switch offers bridge acceleration
> for the FEC.=20

Am I correct, that the "bridge acceleration" means in-hardware support
for L2 packet bridging?=20

And without the switch IP block enabled one shall be able to have
software bridging in Linux in those two interfaces?

> The fact that the bridge acceleration is provided by a
> different vendor and requires access to an extra set of register
> blocks is immaterial.=20

Am I correct that you mean not important above (i.e. immaterial =3D=3D not
important)?

> To qualify as a DSA switch, you need to have
> indirect networking I/O through a different network interface. You do
> not have that.

I do have eth0 (DMA0) -> MoreThanIP switch port 0 input
			 |
			 |----> switch port1 -> ENET-MAC0
			 |
			 |----> switch port2 -> ENET-MAC1

> What I would do is I would expand the fec driver into
> something that, on capable SoCs, detects bridging of the ENET_MAC0
> and ENETC_MAC1 ports and configures the switch accordingly to offload
> that in a seamless manner for the user.=20

Do you propose to catch some kind of notification when user calls:

ip link add name br0 type bridge; ip link set br0 up;
ip link set lan1 up; ip link set lan2 up;
ip link set lan1 master br0; ip link set lan2 master br0;
bridge link

And then configure the FEC driver to use this L2 switch driver?

> This would also solve your
> power management issues, since the entire Ethernet block would be
> handled by a single driver. DSA is a complication you do not need.
> Convince me otherwise.

=46rom what I see the MoreThanIP IP block looks like a "typical" L2 switch
(like lan9xxx), with VLAN tagging support, static and dynamic tables,
forcing the packet to be passed to port [*], congestion management,
switch input buffer, priority of packets/queues, broadcast, multicast,
port snooping, and even IEEE1588 timestamps.

Seems like a lot of useful features.

The differences from "normal" DSA switches:

1. It uses mapped memory (for its register space) for
configuration/statistics gathering (instead of e.g. SPI, I2C)

2. The TAG is not appended to the frame outgoing from the "master" FEC
port - it can be setup when DMA transfers packet to MTIP switch internal
buffer.

Note:

[*] - The same situation is in the VF610 and IMX28:
The ESW_FFEN register - Bit 0 -> FEN=20

"When set, the next frame received from port 0 (the local DMA port) is
forwarded to the ports defined in FD. The bit resets to zero
automatically when one frame from port 0 has been processed by the
switch (i.e. has been read from the port 0 input buffer; see Figure
32-1). Therefore, the bit must be set again as necessary. See also
Section 32.5.8.2, "Forced Forwarding" for a description."

(Of course the "Section 32.5.8.2" is not available)


According to above the "tag" (engress port) is set when DMA transfers
the packet to input MTIP buffer. This shall allow force forwarding as
we can setup this bit when we normally append tag in the network stack.

I will investigate this issue - and check the port separation. If it
works then DSA (or switchdev) shall be used?

(A side question - DSA uses switchdev, so when one shall use switchdev
standalone?)


>=20
> Also, side note.
> Please, please, please, stop calling it "l2 switch" and use something
> more specific. If everybody writing a driver for the Linux kernel
> called their L2 switch "L2 switch", we would go crazy. The kernel is
> not a deep silo like the hardware team that integrated this MTIP
> switching IP into imx28, and for whom this L2 switch is the only
> switch that exists, and therefore for whom no further qualification
> was necessary.

The "l2 switch" name indeed was taken from the NXP's legacy driver :-)

> Andy, Peng or Fabio might be able to give you a
> reference to an internal code name that you can use, or something.

I would prefer to obtain some kind of manual/doc/spec for MTIP IP
block.=20

> Otherwise, I don't care if you need to invent a name yourself - be as
> creative as you feel like. mtip-fec-switch, charlie, matilda,
> brunhild, all fine by me.

I think that "mtip-fec-switch" is the most reasonable name.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/gacppz5A.ZWWtZ7gJFa2=fh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/AO9YACgkQAR8vZIA0
zr2UoggA1Xv8TmA/9LmYCqXtdtH7CpAP0EU0pvXLzk+0Uo5zWyIA+DdmFf7xZnNe
eNwOm8holJNx8kik6pqp05R5X08Th+65V0IV/KIws+NF6YCiQllS+HAVbapjsS3V
ohuQs77cj8iVk2YY7agBwqXfSQSxAWEC4YBEV5DdwvxqccEUbsLAvQKkBFnGd56i
7qjI8S/n6CukD12mHCYqIYc9PoVY1BcajQe2V/60DM2werXtHUen8ionrXj45spg
WszdQq1Fkel6eL3U6rfhgAQb9l4bKnuLVelCdCuPABenBQsYOEOWPu48PVfMYtb8
1qKZrpQ8Xlug1tqN44o7nnrnc1R+fw==
=vBuh
-----END PGP SIGNATURE-----

--Sig_/gacppz5A.ZWWtZ7gJFa2=fh--
