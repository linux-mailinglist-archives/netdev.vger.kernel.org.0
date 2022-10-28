Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80BC610BEA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJ1IJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiJ1IJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:09:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AB62CDED
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:09:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooKQZ-0007ci-OX; Fri, 28 Oct 2022 10:09:19 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 386F510C7E3;
        Fri, 28 Oct 2022 07:46:39 +0000 (UTC)
Date:   Fri, 28 Oct 2022 09:46:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
Message-ID: <20221028074637.3havdrt37qsmbvll@pengutronix.de>
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
 <d1e728d2-b62f-3646-dd27-8cc36ba7c819@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2zfesnt5wdoyraqi"
Content-Disposition: inline
In-Reply-To: <d1e728d2-b62f-3646-dd27-8cc36ba7c819@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2zfesnt5wdoyraqi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 09:13:09, Oliver Hartkopp wrote:
> Hello,
>=20
> On 28.10.22 05:33, Zhengchao Shao wrote:
> > It causes NULL pointer dereference when testing as following:
> > (a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
> > (b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
> >      link device, and bind vxcan device to bond device (can also use
> >      ifenslave command to bind vxcan device to bond device).
> > (c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
> > (d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.
> >=20
> > The bond device invokes the can-raw protocol registration interface to
> > receive CAN packets. However, ml_priv is not allocated to the dev,
> > dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
> > it will occur the NULL pointer dereference issue.
>=20
> I can see the problem and see that the patch makes sense for
> can_rx_register().
>=20
> But for me the problem seems to be located in the bonding device.
>=20
> A CAN interface with dev->type =3D=3D ARPHRD_CAN *always* has the dev->ml=
_priv
> and dev->ml_priv_type set correctly.
>=20
> I'm not sure if a bonding device does the right thing by just 'claiming' =
to
> be a CAN device (by setting dev->type to ARPHRD_CAN) but not taking care =
of
> being a CAN device and taking care of ml_priv specifics.
>=20
> This might also be the case in other ml_priv use cases.
>=20
> Would it probably make sense to blacklist CAN devices in bonding devices?

NACK - We had this discussion 2.5 years ago:

| https://lore.kernel.org/all/00000000000030dddb059c562a3f@google.com
| https://lore.kernel.org/all/20200130133046.2047-1-socketcan@hartkopp.net

=2E..and davem pointed out:

| https://lore.kernel.org/all/20200226.202326.295871777946911500.davem@dave=
mloft.net

On 26.02.2020 20:23:26, David Miller wrote:
[...]
> What I don't get is why the PF_CAN is blindly dereferencing a device
> assuming what is behind bond_dev->ml_priv.
>=20
> If it assumes a device it access is CAN then it should check the
> device by comparing the netdev_ops or via some other means.
>=20
> This restriction seems arbitrary.

With the addition of struct net_device::ml_priv_type in 4e096a18867a
("net: introduce CAN specific pointer in the struct net_device"), what
davem requested is now possible.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2zfesnt5wdoyraqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNbiNsACgkQrX5LkNig
012+HQf/TW0iWNZeKwgY1obNhXWQaQCqXiIsFQbVqtbzTOQksER4kRyYjUL0ARPp
TFPjHENfdopdHRit3bGCn3n8Ync6586skXTOWjk5T8giX5W5/gbouA2J8Q2Qv6m+
U66PiORh1l02PbBTDD6AsGyvSCDjMv6rEGQzzqEBP15dRtumvIM3xZSFc0JEEkME
cd+7Dcs8t2RueCLAj8rYpJiswI+NuuSqyiof1vF6NP1rXHiBnts+6UgB+MKl1phI
r+W6WKm+jifileOL65j5JylwQPuQ1beFW+0YlHxHqH0J560Mjzz6eHLDTBrkYHFA
NZ8xUVf0/M3ESgj9E2lUOr/vZmuexQ==
=s7ha
-----END PGP SIGNATURE-----

--2zfesnt5wdoyraqi--
