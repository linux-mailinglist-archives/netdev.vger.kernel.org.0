Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02EA3B317A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhFXOiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:38:11 -0400
Received: from phobos.denx.de ([85.214.62.61]:43270 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhFXOiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 10:38:10 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 10E51829F8;
        Thu, 24 Jun 2021 16:35:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624545349;
        bh=CpQwkbSEIB8lD8jjL0qfbD/TUnWJKGdixkzy6c8IDqA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HF99tVxBE2NZY/xmUk4/ydyNF3m+vXKPfRH+gavT/qU2xqco4s3NyFj5kHT41dOCc
         A6dJGIJRkH0eTsWqUQyjL1NddsXF51Qh6qrgLiA5obCy0cAMDaAvkpbiJxPoVzmNZl
         KGQX59rzsoKgtICePRHooP8O/g+eKKr85kisKv86Ix0o154IYUo7+IOn1fnu431PtZ
         D8VRq/b7u0G2NjzmFgqceWvlro+fgTtEQgrRVbGSRQjdGIGx6f3d0/6uB45lMQK5a4
         M+HTMERgJCvA3IpSpPQz60wDxABODE35/qEuxX1gXziqQ0ETKZiZ7kB6aetpBrkZCn
         jxojtTfzLbh4g==
Date:   Thu, 24 Jun 2021 16:35:42 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210624163542.5b6d87ee@ktm>
In-Reply-To: <YNSJyf5vN4YuTUGb@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-3-lukma@denx.de>
        <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/VCwptMsYzcXqoWJCZpGxJJf"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VCwptMsYzcXqoWJCZpGxJJf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > I'm not sure if the imx28 switch is similar to one from TI (cpsw-3g)
> > - it looks to me that the bypass mode for both seems to be very
> > different. For example, on NXP when switch is disabled we need to
> > handle two DMA[01]. When it is enabled, only one is used. The
> > approach with two DMAs is best handled with FEC driver
> > instantiation. =20
>=20
> I don't know if it applies to the FEC, but switches often have
> registers which control which egress port an ingress port can send
> packets to. So by default, you allow CPU to port0, CPU to port1, but
> block between port0 to port1. This would give you two independent
> interface, the switch enabled, and using one DMA. When the bridge is
> configured, you simply allow port0 and send/receive packets to/from
> port1. No change to the DMA setup, etc.

Please correct me if I misunderstood this concept - but it seems like
you refer to the use case where the switch is enabled, and by changing
it's "allowed internal port's" mapping it decides if frames are passed
between engress ports (port1 and port2).

	----------
DMA0 ->	|P0    P1| -> ENET-MAC (PHY control) -> eth0 (lan1)
	|L2 SW	 |
	|      P2| -> ENET-MAC (PHY control) -> eth1 (lan2)
	----------

DMA1 (not used)

We can use this approach when we keep always enabled L2 switch.

However now in FEC we use the "bypass" mode, where:
DMA0 -> ENET-MAC (FEC instance driver 1) -> eth0
DMA1 -> ENET-MAC (FEC instance driver 2) -> eth1

And the "bypass" mode is the default one.


I'm just concerned how we are going to gracefully "switch" between L2
switch and bypass configuration? In this patch series - I used the
"hook" corresponding to 'ip link set eth[01] master br0' command.

In other words - how we want to manage DMA0 and DMA1 when switch is
enabled and disabled (in "bypass mode").

>=20
> > The code from [2] needs some vendor ioctl based tool (or hardcode)
> > to configure the switch.  =20
>=20
> This would not be allowed. You configure switches in Linux using the
> existing user space tools. No vendor tools are used.

Exactly - that was the rationale to bring support for L2 switch to
mainline kernel.

>=20
> > > and how well future features can be added. Do you have
> > > support for VLANS? Adding and removing entries to the lookup
> > > tables? How will IGMP snooping work? How will STP work? =20
> >=20
> > This can be easily added with serving netstack hooks (as it is
> > already done with cpsw_new) in the new switchdev based version [3]
> > (based on v5.12). =20
>=20
> Here i'm less convinced. I expect a fully functioning switch driver is
> going to need switch specific versions of some of the netdev ops
> functions, maybe the ethtool ops as well.=20

Definately, the current L2 switch driver would need more work.

> It is going to want to add
> devlink ops. By hacking around with the FEC driver=20

I believe that I will not touch fec_main.[hc] files more than I did in
the=20
"[RFC 3/3] net: imx: Adjust fec_main.c to provide support for L2
switch"

as the switch management (and hooks) are going to be added solely to=20
drivers/net/ethernet/freescale/mtipsw/fec_mtip.[hc]. [*]

This would separate L2 switch driver from the current FEC driver.

> in the way you are,
> you might get very basic switch operation working.=20

Yes, this is the current status - only simple L2 switching works.

> But as we have seen
> with cpsw, going from very basic to a fully functioning switchdev
> driver required a new driver, cpsw_new.

The new driver for L2 switch has been introduced in [*]. The legacy FEC
driver will also work without it.

> It was getting more and more
> difficult to add features because its structure was just wrong. We
> don't want to add code to the kernel which is probably a dead end.
>=20

I cannot say for sure, but all the switch/bridge related hooks can be
added to [*], so fec_main will not bloat.

>       Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/VCwptMsYzcXqoWJCZpGxJJf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDUmD4ACgkQAR8vZIA0
zr0RpggAq3mRIME2Sk0x29hDTFLm0+MlnZYCDVrjHK2frdhNdfnQe85cA8aUWNil
H6WBMrYiAmimAaw5pUFPavJiAfgMETFH0tXZJ0U4BOdcNibW1yuOY32X+KyvvYpO
z4u8N/VLAQtRJx2ZbrblxWg/9DLbKwT5h68ozH25qfn981ab7ttOeEyXNEE/RMTn
hK2Ahx0Zbmvnd8NnR3IhJLwkSLH0C7n/BfJhG52c2DapN6BFLDHkJouAQIILATgM
kErvq9hfruV2hqLK0Pl/nds9kHgUEwzE7VwCENbe4mkU1J0WVmEc5p+YS8AD9sxq
fXcT+1LzO8FDZ4cMBIIQUhhw2CDskA==
=6EYZ
-----END PGP SIGNATURE-----

--Sig_/VCwptMsYzcXqoWJCZpGxJJf--
