Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA964AEB68
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiBIHsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiBIHsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:48:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D64C0613CB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 23:48:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHhiB-0002SV-23; Wed, 09 Feb 2022 08:48:23 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 16E202EEDF;
        Wed,  9 Feb 2022 07:48:22 +0000 (UTC)
Date:   Wed, 9 Feb 2022 08:48:18 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        william.xuanziyang@huawei.com,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: Re: [PATCH] can: isotp: fix potential CAN frame reception race in
 isotp_rcv()
Message-ID: <20220209074818.3ylfz4zmuhit7orc@pengutronix.de>
References: <20220208200026.13783-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rexb2yr6bmwt6uqi"
Content-Disposition: inline
In-Reply-To: <20220208200026.13783-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rexb2yr6bmwt6uqi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.02.2022 21:00:26, Oliver Hartkopp wrote:
> When receiving a CAN frame the current code logic does not consider
> concurrently receiving processes which do not show up in real world
> usage.
>=20
> Ziyang Xuan writes:
>=20
> The following syz problem is one of the scenarios. so->rx.len is
> changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
> 0 before alloc_skb() and equals 4096 after alloc_skb(). That will
> trigger skb_over_panic() in skb_put().
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
> RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
> Call Trace:
>  <TASK>
>  skb_over_panic net/core/skbuff.c:118 [inline]
>  skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
>  isotp_rcv_cf net/can/isotp.c:570 [inline]
>  isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
>  deliver net/can/af_can.c:574 [inline]
>  can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
>  can_receive+0x31d/0x580 net/can/af_can.c:665
>  can_rcv+0x120/0x1c0 net/can/af_can.c:696
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
>  __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579
>=20
> Therefore we make sure the state changes and data structures stay
> consistent at CAN frame reception time by adding a spin_lock in
> isotp_rcv(). This fixes the issue reported by syzkaller but does not
> affect real world operation.
>=20
> Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a=
8e8@huawei.com/T/
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
> Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied to linux-can/testing. Added stable on Cc.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rexb2yr6bmwt6uqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDccAACgkQrX5LkNig
011IBgf9HQJEQ5wWQRR4V2r/q7tXxFCkYSVQ/xQg0atUbm63au9gHepwA8rY+o0X
S4Dpt+ARgRxrTxtAEo4OWSY38QyWNO+7Ib/sHw5HPjxKhXjWYZijFaB1akHD489l
YG4lU9n7y+KOquwaExYPugKrVSnkoDkgq4WhpRqmCNs23Afed/U3SBVQnkIKxsrA
jhNNnDChvB00qNR8ZT/JHK292HeR/iApyhsvxvXjZb61u964GGeCjUTBlmwN06Za
NYU/7sca0iL0zTyAq1hAjthN6RWjYk/28mBglsUxhrmraqG6pTN5bqYz48EqNztj
11E40w7mPDLf9YogWLbGw79tVkjgUw==
=dXjQ
-----END PGP SIGNATURE-----

--rexb2yr6bmwt6uqi--
