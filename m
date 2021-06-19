Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3F3ADB9B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhFSUPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 16:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFSUPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 16:15:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A8EC061574
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 13:12:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luhKc-0004Y7-Nf; Sat, 19 Jun 2021 22:12:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:8352:71b5:153f:5f88])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 149D363F78A;
        Sat, 19 Jun 2021 20:12:38 +0000 (UTC)
Date:   Sat, 19 Jun 2021 22:12:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>
Subject: Re: [PATCH] can: bcm: delay release of struct bcm_op after
 synchronize_rcu
Message-ID: <20210619201238.isat2vojezfkfndf@pengutronix.de>
References: <20210619161813.2098382-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mgigocquvvi3aw7a"
Content-Disposition: inline
In-Reply-To: <20210619161813.2098382-1-cascardo@canonical.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mgigocquvvi3aw7a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.06.2021 13:18:13, Thadeu Lima de Souza Cascardo wrote:
> can_rx_register callbacks may be called concurrently to the call to
> can_rx_unregister. The callbacks and callback data, though, are protected=
 by
> RCU and the struct sock reference count.
>=20
> So the callback data is really attached to the life of sk, meaning that it
> should be released on sk_destruct. However, bcm_remove_op calls tasklet_k=
ill,
> and RCU callbacks may be called under RCU softirq, so that cannot be used=
 on
> kernels before the introduction of HRTIMER_MODE_SOFT.
>=20
> However, bcm_rx_handler is called under RCU protection, so after calling
> can_rx_unregister, we may call synchronize_rcu in order to wait for any R=
CU
> read-side critical sections to finish. That is, bcm_rx_handler won't be c=
alled
> anymore for those ops. So, we only free them, after we do that synchroniz=
e_rcu.
>=20
> Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
> Reported-by: Norbert Slusarek <nslusarek@gmx.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Added to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mgigocquvvi3aw7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDOT7MACgkQqclaivrt
76lDQAf/aep/tGDob6DaLHc5aJhktFcJfqkXx1PwdEIQEve0WIEdLxHu9uYlFK4H
T+Yg/I1A2dtovq+SeWsRkKFDwNpQKRUQ78RjTozr0gs7dIQNNb2NwAb4d5Hywtux
rfbN1YaNOJYisLLqlLTARr9kez16pWnahuJIM8kS/HFkwCOn/pzuzWJDC6oYFfBQ
o3pMRgeZ0FWJH1RkfPbcRGCrdN+UX9dZ04F5muCLOUjqsP1r5mO47iRbkD+qTwKv
OoyhQrZedww2TZlyb/4P5j3aY6kGLGL/wAEA3EMBB9dWVHsgxjqwfH+ohIXbgiAw
nwkdGXDVHtB3SJEsgBxcux9U8dQ8pw==
=56Ct
-----END PGP SIGNATURE-----

--mgigocquvvi3aw7a--
