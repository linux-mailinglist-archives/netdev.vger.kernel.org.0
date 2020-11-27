Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A472C5E65
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 01:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388684AbgK0AD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 19:03:59 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60483 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgK0AD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 19:03:59 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Chvx85kW4z1qsbb;
        Fri, 27 Nov 2020 01:03:55 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Chvx73rCDz1tw7Q;
        Fri, 27 Nov 2020 01:03:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id nkfY3urtl9Ut; Fri, 27 Nov 2020 01:03:53 +0100 (CET)
X-Auth-Info: w/AIwljvO5wRb6uUR6m8k1KWAhfud0ug1INt3CjFse4=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Nov 2020 01:03:53 +0100 (CET)
Date:   Fri, 27 Nov 2020 01:03:25 +0100
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
Message-ID: <20201127010325.5d929362@jawa>
In-Reply-To: <20201126144546.GN2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126000049.GL2073444@lunn.ch>
        <c717666c-8357-60a2-7c66-5d9e9f18d250@gmail.com>
        <20201126031021.GK2075216@lunn.ch>
        <20201126111014.5a6a2049@jawa>
        <20201126144546.GN2075216@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/FdLy3aP3LgVUNklxQHOQ5Ay"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FdLy3aP3LgVUNklxQHOQ5Ay
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > What is not yet clear to me is how you direct frames out specific
> > > interfaces. This is where i think we hit problems. I don't see a
> > > generic mechanism, which is probably why Lukasz put tagger as
> > > None.  =20
> >=20
> > I've put the "None" tag just to share the "testable" RFC code. =20
>=20
> Tagging is a core feature of DSA. Without being able to direct a
> packet out a specific port, it is not really a DSA driver.  It is also
> core requirement of integrating a switch into Linux. A DSA driver, or
> a pure switchdev driver expects to be able to forward frames out
> specific ports.

Please find my answer, which I gave to Vladimir in the other mail (you
were CC'ed).

As a backup plan - the vlan tagging may be worth to investigate.

>=20
> > It is possible to "tag" frames - at least from the manual [0]:
> > Chapter: "29.4.9.2 Forced Forwarding".
> >=20
> > With using register HW_ENET_SWI_FORCE_FWD_P0
> > 29.9.34 ENET SWI Enable forced forwarding for a frame processed
> > from port 0 (HW_ENET_SWI_FORCE_FWD_P0)
> >=20
> > One can "tag" the packet going from port0 (internal one from SoC)
> > to be forwarded to port1 (ENET-MAC0) or port2 (ENET-MAC1).
> >=20
> > According to the legacy driver [1]:
> > "* It only replace the MAC lookup function,
> >  * all other filtering(eg.VLAN verification) act as normal" =20
>=20
> This might solve your outgoing frame problems. But you need to dive
> deep into how the FEC driver works, especially in a DSA like
> setup.=20

Agree.

> The normal path would be, the slave interface passes a frame to
> the tagger driver, living in net/dsa/tag_*.c. Normally, it adds a
> header/trailer which the switch looks at. It then hands to packet over
> to the master Ethernet driver, which at some point will send the
> frame. Because the frame is self contained, we don't care what that
> ethernet driver actually does. It can add it to a queue and send it
> later. It can look at the QoS tags and send it with low priority after
> other frames, or could put it to the head of the queue and send it
> before other frames etc.
>=20

Thanks for the explanation.

> Since you don't have self contained frames, this is a problem. After
> writing to this register, you need to ensure what is transmitted next
> is the specific frame you intend. It cannot be added to an existing
> queue etc. You need to know when the frame has been sent, so you can
> re-write this register for the next frame.

This needs to be assessed as the documentation is very vague. I'm
wondering how MTIP/NXP recommends usage of ESW_FFEN register.

>=20
> This is why i said i don't know if the DSA architecture will work. You
> need a close coupling between the tagger setting the force bits, and
> the DMA engine sending the frame.

Maybe it would be just enough to program the ESW_FFEN register when ENET
descriptor is programmed for DMA? Earlier we would append the
superfluous tag in the tag_*.c ?

>=20
> The other option is you totally ignore most of this and statically
> assign VLANs. Frames sent with VLAN 1 are forwarded out port 1. Frames
> sent with VLAN 2 are sent out port 2. You need the port to
> append/strip these VLAN tags for ingress/egress. tag_8021q.c gives you
> some code to help with this. But can you still use the hardware to
> switch frames between ports 1 and 2 without them going via the CPU?

Yes, it is possible to switch frames between ENET-MAC{01} ports without
any interaction from CPU.

>=20
>        Andrew.




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/FdLy3aP3LgVUNklxQHOQ5Ay
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/AQk0ACgkQAR8vZIA0
zr2ooAf9FWuBH85pjbUd2qGgJB64pBsMMQaZ5zrchOozm0aNKEC2tK9dRYhYtV66
6F2vIL1dxnpCAWQyDP6L01HgsW0IjH23J9RWmeNQVv+wZzwXdsFyercQ063qVfKK
gWXvdOTmBKG/mTLxkrhIkkuVz+P//uTsOXtmMS0GmpAZ5SWV8YbLIANEmm010ISg
M6KMOi8LIvDXdrj/XCGxnLQu4yWEClMcha70GnvuWsHOyGUtnJHeSS1l6OgOUfHI
BxxfDffF517G2BPQBtJCAjpNUTEtqeKnhLZPtbs3h0I1mKO3AB71o9fGYJk5/H+t
EVwhvFDG9/wN83w/4kYhalzqUGPgaA==
=yAuL
-----END PGP SIGNATURE-----

--Sig_/FdLy3aP3LgVUNklxQHOQ5Ay--
