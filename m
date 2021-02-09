Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB50314E68
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBILps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhBILfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:35:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9ABC061797
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 03:32:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l9RF9-0004S2-Pu; Tue, 09 Feb 2021 12:31:43 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:655a:4660:2120:638])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 264185DB349;
        Tue,  9 Feb 2021 11:28:16 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:28:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: ucan: fix alignment constraints
Message-ID: <20210209112815.hqndd7qonsygvv4n@hardanger.blackshift.org>
References: <20210204162625.3099392-1-arnd@kernel.org>
 <20210208131624.y5ro74e4fibpg6rk@hardanger.blackshift.org>
 <bd7e6497b3f64fb5bb839dc9a9d51d6a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="djjdhxlhmqm3zy7h"
Content-Disposition: inline
In-Reply-To: <bd7e6497b3f64fb5bb839dc9a9d51d6a@AcuMS.aculab.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--djjdhxlhmqm3zy7h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2021 10:34:42, David Laight wrote:
> From: Marc Kleine-Budde
> > Sent: 08 February 2021 13:16
> >=20
> > On 04.02.2021 17:26:13, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > struct ucan_message_in contains member with 4-byte alignment
> > > but is itself marked as unaligned, which triggers a warning:
> > >
> > > drivers/net/can/usb/ucan.c:249:1: warning: alignment 1 of 'struct uca=
n_message_in' is less than 4 [-
> > Wpacked-not-aligned]
> > >
> > > Mark the outer structure to have the same alignment as the inner
> > > one.
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >=20
> > Applied to linux-can-next/testing.
>=20
> I've just had a look at that file.
>=20
> Are any of the __packed or __aligned actually required at all.
>=20
> AFAICT there is one structure that would have end-padding.
> But I didn't actually spot anything validating it's length.
> Which may well mean that it is possible to read off the end
> of the USB receive buffer - plausibly into unmapped addresses.

In ucan_read_bulk_callback() there is a check of the urb's length,
as well as the length information inside the rx'ed data:

https://elixir.bootlin.com/linux/v5.10.14/source/drivers/net/can/usb/ucan.c=
#L734

| static void ucan_read_bulk_callback(struct urb *urb)
| [...]
| 		/* check sanity (length of header) */
| 		if ((urb->actual_length - pos) < UCAN_IN_HDR_SIZE) {
| 			netdev_warn(up->netdev,
| 				    "invalid message (short; no hdr; l:%d)\n",
| 				    urb->actual_length);
| 			goto resubmit;
| 		}
|=20
| 		/* setup the message address */
| 		m =3D (struct ucan_message_in *)
| 			((u8 *)urb->transfer_buffer + pos);
| 		len =3D le16_to_cpu(m->len);
|=20
| 		/* check sanity (length of content) */
| 		if (urb->actual_length - pos < len) {
| 			netdev_warn(up->netdev,
| 				    "invalid message (short; no data; l:%d)\n",
| 				    urb->actual_length);
| 			print_hex_dump(KERN_WARNING,
| 				       "raw data: ",
| 				       DUMP_PREFIX_ADDRESS,
| 				       16,
| 				       1,
| 				       urb->transfer_buffer,
| 				       urb->actual_length,
| 				       true);
|=20
| 			goto resubmit;
| 		}


> I looked because all the patches to 'fix' the compiler warning
> are dubious.
> Once you've changed the outer alignment (eg of a union) then
> the compiler will assume that any pointer to that union is aligned.
> So any _packed() attributes that are required for mis-aligned
> accesses get ignored - because the compiler knows the pointer
> must be aligned.

Here the packed attribute is not to tell the compiler, that a pointer
to the struct ucan_message_in may be unaligned. Rather is tells the
compiler to not add any holes into the struct.

| struct ucan_message_in {
| 	__le16 len; /* Length of the content include header */
| 	u8 type;    /* UCAN_IN_RX and friends */
| 	u8 subtype; /* command sub type */
|=20
| 	union {
| 		/* CAN Frame received
| 		 * (type =3D=3D UCAN_IN_RX)
| 		 * && ((msg.can_msg.id & CAN_RTR_FLAG) =3D=3D 0)
| 		 */
| 		struct ucan_can_msg can_msg;
|=20
| 		/* CAN transmission complete
| 		 * (type =3D=3D UCAN_IN_TX_COMPLETE)
| 		 */
| 		struct ucan_tx_complete_entry_t can_tx_complete_msg[0];
| 	} __aligned(0x4) msg;
| } __packed;

> So while the changes remove the warning, they may be removing
> support for misaligned addresses.

There won't be any misaligned access on the struct, the USB device
will send it aligned and the driver will enforce the alignment:

| 		/* proceed to next message */
| 		pos +=3D len;
| 		/* align to 4 byte boundary */
| 		pos =3D round_up(pos, 4);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--djjdhxlhmqm3zy7h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAiccwACgkQqclaivrt
76kTRQf/VhGlpKxtfkAF8AWG10yA3INg9/1yq2i1yWV3QzCKTiWm0uaVgUSv77Lm
Jg4zGGkjEnEDcxHUoVaFB2JmJ4uhRgm83c21ZpYyvkuGjVFixTwsnILELh2hCS6w
Ltn3CSxJFXBCLQ/CNDL/xcyNhLKJcICOfs8BRHF7OAjbERrjIRBY9d+ZluZ+LGFo
J1SkCiaRl3MjwJJKfsX6rdSEl5ohYu+BQtg9zRITbLyeEX/kx7XkVSV3wJmA50aM
bjfc3rWhrLonsGRok0PJOkHuj7qxpwMruJCM160ywliiB+Lh4REgoV4NVfAsNKMd
7GCF/fw9PSW/7b5o/3qDxoB/31HoqA==
=MGWN
-----END PGP SIGNATURE-----

--djjdhxlhmqm3zy7h--
