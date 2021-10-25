Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3DA439683
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhJYMp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhJYMp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:45:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC746C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 05:43:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mezK9-0005DQ-SC; Mon, 25 Oct 2021 14:43:33 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-d7c8-7df6-a4ac-55f0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d7c8:7df6:a4ac:55f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 04B1869D623;
        Mon, 25 Oct 2021 12:43:32 +0000 (UTC)
Date:   Mon, 25 Oct 2021 14:43:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can <linux-can@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <20211025124331.d7r7qbadkzfk7i4f@pengutronix.de>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
 <YXaimhlXkpBKRQin@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="imdhy7edj6aqhova"
Content-Disposition: inline
In-Reply-To: <YXaimhlXkpBKRQin@lunn.ch>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--imdhy7edj6aqhova
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 14:27:06, Andrew Lunn wrote:
> I would not consider it as two different modes, but as N modes. That
> way, we are prepared for CAN-3.0 which might need other ring
> parameters.

ACK - there's CAN-XL, but I haven't seen any HW, yet. Let's follow the
zero one infinity rule :)

> The netlink API is extensible, unlike the IOCTL interface. I would add
> an additional optional attribute, ETHTOOL_A_RINGS_MODE, with values like:
>=20
> ETHTOOL_A_RINGS_MODE_DEFAULT
> ETHTOOL_A_RINGS_MODE_CAN_2
> ETHTOOL_A_RINGS_MODE_CAN_FD
>=20
> The IOCTL would always be for mode _DEFAULT, and it would get/set the
> current used setting. If the optionally attribute is missing, then the
> calling into the driver would also use _DEFAULT. However, if it is
> present, the driver can store away the ring parameters for a
> particular mode, and maybe actually put them into use if the mode is
> currently active.
>=20
> You cannot change
>=20
> struct ethtool_ringparam {
> 	__u32	cmd;
> 	__u32	rx_max_pending;
> 	__u32	rx_mini_max_pending;
> 	__u32	rx_jumbo_max_pending;
> 	__u32	tx_max_pending;
> 	__u32	rx_pending;
> 	__u32	rx_mini_pending;
> 	__u32	rx_jumbo_pending;
> 	__u32	tx_pending;
> };
>=20
> Since that is ABI.

ACK

> But you can add an
>=20
> struct ethtool_kringparam {
> 	__u32	cmd;
> 	__u32   mode;
> 	__u32	rx_max_pending;
> 	__u32	rx_mini_max_pending;
> 	__u32	rx_jumbo_max_pending;
> 	__u32	tx_max_pending;
> 	__u32	rx_pending;
> 	__u32	rx_mini_pending;
> 	__u32	rx_jumbo_pending;
> 	__u32	tx_pending;
> };
>=20
> and use this structure between the ethtool core and the drivers. This
> has already been done at least once to allow extending the
> API. Semantic patches are good for making the needed changes to all
> the drivers.

What about the proposed "two new parameters ringparam_ext and extack for
=2Eget_ringparam and .set_ringparam to extend more ring params through
netlink." by Hao Chen/Guangbin Huang in:

https://lore.kernel.org/all/20211014113943.16231-5-huangguangbin2@huawei.co=
m/

I personally like the conversion of the in in-kernel API to struct
ethtool_kringparam better than adding ringparam_ext.


Thanks for you input, regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--imdhy7edj6aqhova
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2pnEACgkQqclaivrt
76l/YAf8D1zK6j84mt393GDZcHF2oNceo/IgUsND43nnlIbeirCaoiFSCEK+p351
WNTmZe47ikPK0zexdTRC2uK02pAvI5p4Atx5nyQRLmVwRI9EohSSbYh+dC84E6sW
R3wEUQIdL2VKZCy3d/3EWLlqoTlCWdviGRmxBYoLdqXLDmc9VKxNo/kT0vUAC8yk
ufxrni2YcVX0YziiBEApdpaDSt3jD1lOG9G4RvhhBA5P+GbS1rZ3mpcCHST146EX
yZh4OjgYTRAYZOt7HFKecxCXAan8q/NrCFrC/G4hhr3/aMAbf+/Errziv464B/vg
x9lw15sw4AYoqtlhredyl7mH3A/ysg==
=1Pwg
-----END PGP SIGNATURE-----

--imdhy7edj6aqhova--
