Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B132C3FD
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354726AbhCDAJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842938AbhCCKWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:22:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC86C061D7D
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 01:01:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHNN5-0001kz-U1; Wed, 03 Mar 2021 10:00:44 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:a20d:2fb6:f2cb:982e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5D5DC5ECAB8;
        Wed,  3 Mar 2021 09:00:37 +0000 (UTC)
Date:   Wed, 3 Mar 2021 10:00:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210303090036.aocqk6gp3vqnzaku@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210302184901.GD26930@x1.vandijck-laurijssen.be>
 <91394876.26757.1614759793793@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="chi2fdx3hgvidome"
Content-Disposition: inline
In-Reply-To: <91394876.26757.1614759793793@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--chi2fdx3hgvidome
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.03.2021 09:23:13, Dario Binacchi wrote:
[...]
> > > @@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
> > >  	return 0;
> > >  }
> > > =20
> > > -struct net_device *alloc_c_can_dev(void)
> > > +struct net_device *alloc_c_can_dev(int msg_obj_num)
> > >  {
> > >  	struct net_device *dev;
> > >  	struct c_can_priv *priv;
> > > +	int msg_obj_tx_num =3D msg_obj_num / 2;
> >=20
> > IMO, a bigger tx queue is not usefull.
> > A bigger rx queue however is.
>=20
> This would not be good for my application. I think it really depends
> on the type of application. We can probably say that being able to
> size rx/tx queue would be a useful feature.

Ok. There is an ethtool interface to configure the size of the RX and TX
queues. In ethtool it's called the RX/TX "ring" size and you can get it
via the -g parameter, e.g. here for by Ethernet interface:

| $ ethtool -g enp0s25
| Ring parameters for enp0s25:
| Pre-set maximums:
| RX:		4096
| RX Mini:	n/a
| RX Jumbo:	n/a
| TX:		4096
| Current hardware settings:
| RX:		256
| RX Mini:	n/a
| RX Jumbo:	n/a
| TX:		256

If I understand correctly patch 6 has some assumptions that RX and TX
are max 32. To support up to 64 RX objects, you have to convert:
- u32 -> u64
- BIT() -> BIT_ULL()
- GENMASK() -> GENMASK_ULL()

The register access has to be converted, too. For performance reasons
you want to do as least as possible. Which is probably the most
complicated.

In the flexcan driver I have a similar problem. The driver keeps masks,
which mailboxes are RX and which TX and I added wrapper functions to
minimize IO access:

https://elixir.bootlin.com/linux/v5.11/source/drivers/net/can/flexcan.c#L904

This should to IMHO into patch 6.

Adding the ethtool support and making the rings configurable would be a
separate patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--chi2fdx3hgvidome
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA/UDIACgkQqclaivrt
76kC3AgAtJ3JQNxw4L/+OzOaLHFaUh7ws8JUSJaAFPe3N0+kd7lmWDgBWWH5cDTE
Yg7w6S05G+6G9QDI+St3fH1UsOSvBLtN5DPF08e3Vh43bxusvYQ9/mpibYu69hw5
C+nkONomqysTM3umXC+Zo+DmlkPPU3VCMPnvLYWGs8ihDxsOFB6VzRgs9g7CPZm+
UExOHqUQIp2CXglXt/UXywnTuVItEQm6R7HJRfVxfO1j3F2QXe5kH0aNugRciDtp
cwG9NQq2r2D8Z0eJdWAoKeIxqVoxJvMTjtqnHjy+JswGfEYKEsBzA+s9yBkHNUJr
9KfHhcqds95Y6ZG6xLcaBPSvcLoqKA==
=8a5M
-----END PGP SIGNATURE-----

--chi2fdx3hgvidome--
