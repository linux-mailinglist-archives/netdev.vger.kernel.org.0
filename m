Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302E132C4A6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450105AbhCDAPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbhCCVRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:17:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7341C06175F
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 13:17:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHYrb-0004UO-Dx; Wed, 03 Mar 2021 22:16:59 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:a20d:2fb6:f2cb:982e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5843B5ED14D;
        Wed,  3 Mar 2021 21:16:58 +0000 (UTC)
Date:   Wed, 3 Mar 2021 22:16:57 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Martin Willi <martin@strongswan.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: dev: Move device back to init netns on owning
 netns delete
Message-ID: <20210303211657.gyampnzyhqjaim5i@pengutronix.de>
References: <20210302122423.872326-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6acdq5udxfxzzwp3"
Content-Disposition: inline
In-Reply-To: <20210302122423.872326-1-martin@strongswan.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6acdq5udxfxzzwp3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.03.2021 13:24:23, Martin Willi wrote:
> When a non-initial netns is destroyed, the usual policy is to delete
> all virtual network interfaces contained, but move physical interfaces
> back to the initial netns. This keeps the physical interface visible
> on the system.
>=20
> CAN devices are somewhat special, as they define rtnl_link_ops even
> if they are physical devices. If a CAN interface is moved into a
> non-initial netns, destroying that netns lets the interface vanish
> instead of moving it back to the initial netns. default_device_exit()
> skips CAN interfaces due to having rtnl_link_ops set. Reproducer:
>=20
>   ip netns add foo
>   ip link set can0 netns foo
>   ip netns delete foo
>=20
> WARNING: CPU: 1 PID: 84 at net/core/dev.c:11030 ops_exit_list+0x38/0x60
> CPU: 1 PID: 84 Comm: kworker/u4:2 Not tainted 5.10.19 #1
> Workqueue: netns cleanup_net
> [<c010e700>] (unwind_backtrace) from [<c010a1d8>] (show_stack+0x10/0x14)
> [<c010a1d8>] (show_stack) from [<c086dc10>] (dump_stack+0x94/0xa8)
> [<c086dc10>] (dump_stack) from [<c086b938>] (__warn+0xb8/0x114)
> [<c086b938>] (__warn) from [<c086ba10>] (warn_slowpath_fmt+0x7c/0xac)
> [<c086ba10>] (warn_slowpath_fmt) from [<c0629f20>] (ops_exit_list+0x38/0x=
60)
> [<c0629f20>] (ops_exit_list) from [<c062a5c4>] (cleanup_net+0x230/0x380)
> [<c062a5c4>] (cleanup_net) from [<c0142c20>] (process_one_work+0x1d8/0x43=
8)
> [<c0142c20>] (process_one_work) from [<c0142ee4>] (worker_thread+0x64/0x5=
a8)
> [<c0142ee4>] (worker_thread) from [<c0148a98>] (kthread+0x148/0x14c)
> [<c0148a98>] (kthread) from [<c0100148>] (ret_from_fork+0x14/0x2c)
>=20
> To properly restore physical CAN devices to the initial netns on owning
> netns exit, introduce a flag on rtnl_link_ops that can be set by drivers.
> For CAN devices setting this flag, default_device_exit() considers them
> non-virtual, applying the usual namespace move.
>=20
> The issue was introduced in the commit mentioned below, as at that time
> CAN devices did not have a dellink() operation.
>=20
> Fixes: e008b5fc8dc7 ("net: Simplfy default_device_exit and improve batchi=
ng.")
> Signed-off-by: Martin Willi <martin@strongswan.org>

applied to linux-can/testing

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6acdq5udxfxzzwp3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA//MYACgkQqclaivrt
76lIYAf8DP4XvSvvYRwlxr544JULhXG1eiAqe9qWOVa2jHInXr4ApQIJIMjavAO9
d6mWqROiFWYTL8JzagyYAdVk6+6iqM/Y9rs+IvaQdd+qw9MkTw8faelMwNVC0+My
gpuVO0Hkq45efpDa4X/Dua9tfMeKgQ/fJ1hD7CKOgCEDyYX847Og9nG9Skv423x1
2uGKvLPB7KlGeuX/7BZZbi54/yj4xGDfSjKc5ws9dY4/Xsq8DTAjQ4eoa5nWw4eZ
HxFco+kMu/L+3cU7ZTmCRPlb2aIqnhkhKhfWtesLDNFpdWk2sDwuGT76SsfuRAjw
bkR4UR/BHpGv8p8ilX/+VrNAouPTYw==
=i8Hc
-----END PGP SIGNATURE-----

--6acdq5udxfxzzwp3--
