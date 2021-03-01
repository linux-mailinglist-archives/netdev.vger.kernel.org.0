Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17070328F7F
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbhCATw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241905AbhCATuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:50:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F2DC06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:49:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGoXf-0000Ju-Vi; Mon, 01 Mar 2021 20:49:20 +0100
Received: from [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd] (unknown [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B6F6D5EB936;
        Mon,  1 Mar 2021 14:26:13 +0000 (UTC)
Subject: Re: [PATCH] can: c_can_pci: fix use-after-free
To:     Tong Zhang <ztong0001@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210301024512.539039-1-ztong0001@gmail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <67230006-7532-3dbf-7f12-875de7db8312@pengutronix.de>
Date:   Mon, 1 Mar 2021 15:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210301024512.539039-1-ztong0001@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="PmtfA6Sb8jN5aVr8Wcm84GravbXgwGHQf"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PmtfA6Sb8jN5aVr8Wcm84GravbXgwGHQf
Content-Type: multipart/mixed; boundary="xh56eLPtC3LeoguRa3Qj92NHLr6AhXFaD";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Tong Zhang <ztong0001@gmail.com>, Wolfgang Grandegger
 <wg@grandegger.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <67230006-7532-3dbf-7f12-875de7db8312@pengutronix.de>
Subject: Re: [PATCH] can: c_can_pci: fix use-after-free
References: <20210301024512.539039-1-ztong0001@gmail.com>
In-Reply-To: <20210301024512.539039-1-ztong0001@gmail.com>

--xh56eLPtC3LeoguRa3Qj92NHLr6AhXFaD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/1/21 3:45 AM, Tong Zhang wrote:
> There is a UAF in c_can_pci_remove().
> dev is released by free_c_can_dev() and is used by
> pci_iounmap(pdev, priv->base) later.
> To fix this issue, save the mmio address before releasing dev.
>=20
> [ 1795.746699] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1795.747093] BUG: KASAN: use-after-free in c_can_pci_remove+0x34/0x70=
 [c_can_pci]
> [ 1795.747503] Read of size 8 at addr ffff888103db0be8 by task modprobe=
/98
> [ 1795.747867]
> [ 1795.747957] CPU: 0 PID: 98 Comm: modprobe Not tainted 5.11.0-11746-g=
06d5d309a3f1-dirty #56
> [ 1795.748410] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.13.0-48-gd9c812dda519-4
> [ 1795.749025] Call Trace:
> [ 1795.749176]  dump_stack+0x8a/0xb5
> [ 1795.749385]  print_address_description.constprop.0+0x1a/0x140
> [ 1795.749713]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
> [ 1795.750001]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
> [ 1795.750285]  kasan_report.cold+0x7f/0x111
> [ 1795.750513]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
> [ 1795.750797]  c_can_pci_remove+0x34/0x70 [c_can_pci]
> [ 1795.751071]  pci_device_remove+0x62/0xe0
> [ 1795.751308]  device_release_driver_internal+0x148/0x270
> [ 1795.751609]  driver_detach+0x76/0xe0
> [ 1795.751812]  bus_remove_driver+0x7e/0x100
> [ 1795.752051]  pci_unregister_driver+0x28/0xf0
> [ 1795.752286]  __x64_sys_delete_module+0x268/0x300
> [ 1795.752547]  ? __ia32_sys_delete_module+0x300/0x300
> [ 1795.752815]  ? call_rcu+0x3e4/0x580
> [ 1795.753014]  ? fpregs_assert_state_consistent+0x4d/0x60
> [ 1795.753305]  ? exit_to_user_mode_prepare+0x2f/0x130
> [ 1795.753574]  do_syscall_64+0x33/0x40
> [ 1795.753782]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1795.754060] RIP: 0033:0x7f033332dcf7
> [ 1795.754257] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00=
 48 89 f8 48 89 f7 48 89 d6 41
> [ 1795.755248] RSP: 002b:00007ffd06037208 EFLAGS: 00000202 ORIG_RAX: 00=
000000000000b0
> [ 1795.755655] RAX: ffffffffffffffda RBX: 00007f03333ab690 RCX: 00007f0=
33332dcf7
> [ 1795.756038] RDX: 00000000ffffffff RSI: 0000000000000080 RDI: 0000000=
000d20b10
> [ 1795.756420] RBP: 0000000000d20ac0 R08: 2f2f2f2f2f2f2f2f R09: 0000000=
000d20ac0
> [ 1795.756801] R10: fefefefefefefeff R11: 0000000000000202 R12: 0000000=
000d20ac0
> [ 1795.757183] R13: 0000000000d2abf0 R14: 0000000000000000 R15: 0000000=
000000001
> [ 1795.757565]
> [ 1795.757651] The buggy address belongs to the page:
> [ 1795.757912] page:(____ptrval____) refcount:0 mapcount:-128 mapping:0=
000000000000000 index:0x0 pfn0
> [ 1795.758427] flags: 0x200000000000000()
> [ 1795.758633] raw: 0200000000000000 ffffea00040f7608 ffff88817fffab18 =
0000000000000000
> [ 1795.759047] raw: 0000000000000000 0000000000000003 00000000ffffff7f =
0000000000000000
> [ 1795.759460] page dumped because: kasan: bad access detected
> [ 1795.759759]
> [ 1795.759845] Memory state around the buggy address:
> [ 1795.760104]  ffff888103db0a80: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff
> [ 1795.760490]  ffff888103db0b00: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff
> [ 1795.760878] >ffff888103db0b80: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff
> [ 1795.761264]                                                         =
  ^
> [ 1795.761618]  ffff888103db0c00: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff
> [ 1795.762007]  ffff888103db0c80: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff
> [ 1795.762392] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I've removed the kasan report, as your problem description is sufficient.=


>=20
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/net/can/c_can/c_can_pci.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/=
c_can_pci.c
> index 406b4847e5dc..a378383a99fb 100644
> --- a/drivers/net/can/c_can/c_can_pci.c
> +++ b/drivers/net/can/c_can/c_can_pci.c
> @@ -239,12 +239,13 @@ static void c_can_pci_remove(struct pci_dev *pdev=
)
>  {
>  	struct net_device *dev =3D pci_get_drvdata(pdev);
>  	struct c_can_priv *priv =3D netdev_priv(dev);
> -
> +	void __iomem *addr =3D priv->base;
> + =20

Please don't add trailing whitespace.

I've removed them while applying.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--xh56eLPtC3LeoguRa3Qj92NHLr6AhXFaD--

--PmtfA6Sb8jN5aVr8Wcm84GravbXgwGHQf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA8+YEACgkQqclaivrt
76nneQf/V9R7b2HYNdVEUIYFIdpNoxU3nnNpk0vFhFyEfGMrG/x3giR6V8WH4whM
tQ2VuXctmC1S4UsZOkEZKmOSZQjoKcau1umPlhxllT1YL7tku1uqS0Hxj4jLW012
LIbDJowZJa9v322juRLHV59cDm39c2ZoA4aIsj/gPYnT8ZdW4AMOkprl7ZNLZQgm
B7ZhRuyRjljigCqoia/S3EzsCUP/qzCyoJUj1ikSu+vyGb3n6xB4dLRTxxzIuQ+0
6vSbXt4Rx9l5TfD75NGNk85x+ZE7JX8sWVXTncBMpL+wunDlOYwoK5fABqkYJG1R
mOoVreN4u+ugWOrwTzltC2OWZroKPw==
=+olP
-----END PGP SIGNATURE-----

--PmtfA6Sb8jN5aVr8Wcm84GravbXgwGHQf--
