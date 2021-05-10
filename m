Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D63796EB
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhEJSTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhEJSTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 14:19:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F12C06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 11:18:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lgATp-0002mZ-NH; Mon, 10 May 2021 20:18:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5dca:2b47:47f4:4cec])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AD244621A30;
        Mon, 10 May 2021 18:18:08 +0000 (UTC)
Date:   Mon, 10 May 2021 20:18:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Torin Cooper-Bennun <torin@maxiluxsystems.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: CAN: TX frames marked as RX after the sending socket is closed
Message-ID: <20210510181807.sel6igxglzwqoi44@pengutronix.de>
References: <20210510142302.ijbwowv4usoiqkxq@bigthink>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w5jclh3gdbvuvry7"
Content-Disposition: inline
In-Reply-To: <20210510142302.ijbwowv4usoiqkxq@bigthink>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w5jclh3gdbvuvry7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.05.2021 15:23:02, Torin Cooper-Bennun wrote:
> Why?
>=20
> candump.c prints 'RX' if the received frame has no MSG_DONTROUTE flag.
>=20
> |	if (msg.msg_flags & MSG_DONTROUTE)
> |		printf ("  TX %s", extra_m_info[frame.flags & 3]);
> |	else
> |		printf ("  RX %s", extra_m_info[frame.flags & 3]);
>=20
> In turn, MSG_DONTROUTE is set in net/can/raw.c: raw_rcv():
>=20
> |	/* add CAN specific message flags for raw_recvmsg() */
> |	pflags =3D raw_flags(skb);
> |	*pflags =3D 0;
> |	if (oskb->sk)
> |		*pflags |=3D MSG_DONTROUTE;
> |	if (oskb->sk =3D=3D sk)
> |		*pflags |=3D MSG_CONFIRM;

Without testing, I think you're right here, the MSG_DONTROUTE isn't set
here anymore.

> So, I'm guessing, some 100 ms after my application begins to request
> that the socket be closed, the socket's pointer becomes NULL in further
> TX skbs in the queue, so the raw CAN layer can no longer differentiate
> these skbs as TX. (Sorry if my pathways are a bit mixed up.)

I have a git feeling that I've found the problem. Can you revert
e940e0895a82 ("can: skb: can_skb_set_owner(): fix ref counting if socket
was closed before setting skb ownership") and check if that fixes your
problem? This might trigger the problem described in the patch:

| WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x11=
4/0x134
| refcount_t: addition on 0; use-after-free.
| Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa=
(E)
| CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-0457=
7-gf8ff6603c617 #203
| Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
| Backtrace:
| [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7=
:00000000 r6:600f0113 r5:00000000 r4:81441220
| [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
| [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:000000=
19 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
| [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:=
83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
| [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturat=
e+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
| [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.c=
onstprop.0+0x4c/0x50)
| [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo=
_skb+0xb0/0x13c)
| [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1=
c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:83=
4e5600
| [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x=
44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82a=
b1f00
| [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0=
x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:=
834e5600
| [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xc=
c/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:83=
4e5600 r4:83f27400
| [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)

Can you give me feedback if
1. the revert "fixes" your problem
2. the revert triggers the above backtrace

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--w5jclh3gdbvuvry7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCZeN0ACgkQqclaivrt
76nhigf6AtEkH/kzq+whT0TYcjAQ9giTCQVVqlAStCXFsG7/RC/3RdsyDL09fDhL
CTuASs1uM3YhDiCkTjm/3EFsE2yWVcRNjiBV+V36pjB4TZI2R+UJpysaVtLEH8pn
C5BzxrZWWdR0Zu1SkysWsOqqV+NSXTqc6hdD3ydOqWyl7vgNNyMn0kErN3DRc7B5
y2+fd8Aj7XfUuqmVBnJ5vEtzB5yrmpo4b/kqg7yi4bCsWat70eeyhXNLCitQAqwr
7WPW92v7uAGfRkIPfbFVAaEC0Sgo3R3SLHBl99ouj1IRx1uuE0l5MEccHHY3wut4
ubPe7sFeUj4KivL1PzD1XdoY8JuSUQ==
=B8Ml
-----END PGP SIGNATURE-----

--w5jclh3gdbvuvry7--
