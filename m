Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE53ED07C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhHPInO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbhHPInN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:43:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC78C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 01:42:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFYCd-0007Bz-18; Mon, 16 Aug 2021 10:42:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 587C1668068;
        Mon, 16 Aug 2021 08:42:37 +0000 (UTC)
Date:   Mon, 16 Aug 2021 10:42:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qprdy2lzjeysr5w5"
Content-Disposition: inline
In-Reply-To: <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qprdy2lzjeysr5w5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.08.2021 12:32:43, Vincent Mailhol wrote:
> ISO 11898-1 specifies in section 11.3.3 "Transmitter delay
> compensation" that "the configuration range for [the] SSP position
> shall be at least 0 to 63 minimum time quanta."
>=20
> Because SSP =3D TDCV + TDCO, it means that we should allow both TDCV and
> TDCO to hold zero value in order to honor SSP's minimum possible
> value.
>=20
> However, current implementation assigned special meaning to TDCV and
> TDCO's zero values:
>   * TDCV =3D 0 -> TDCV is automatically measured by the transceiver.
>   * TDCO =3D 0 -> TDC is off.
>=20
> In order to allow for those values to really be zero and to maintain
> current features, we introduce two new flags:
>   * CAN_CTRLMODE_TDC_AUTO indicates that the controller support
>     automatic measurement of TDCV.
>   * CAN_CTRLMODE_TDC_MANUAL indicates that the controller support
>     manual configuration of TDCV. N.B.: current implementation failed
>     to provide an option for the driver to indicate that only manual
>     mode was supported.
>=20
> TDC is disabled if both CAN_CTRLMODE_TDC_AUTO and
> CAN_CTRLMODE_TDC_MANUAL flags are off, c.f. the helper function
> can_tdc_is_enabled() which is also introduced in this patch.

Nitpick: We can only say that TDC is disabled, if the driver supports
the TDC interface at all, which is the case if tdc_const is set.

> Also, this patch adds three fields: tdcv_min, tdco_min and tdcf_min to
> struct can_tdc_const. While we are not convinced that those three
> fields could be anything else than zero, we can imagine that some
> controllers might specify a lower bound on these. Thus, those minimums
> are really added "just in case".

I'm not sure, if we talked about the mcp251xfd's tcdo, valid values are
-64...63.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qprdy2lzjeysr5w5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaJPkACgkQqclaivrt
76l28wf/ZljL35oamfKggJEeY/5PhnAwWEa5xIh52ICfNuefGYMqgBvQ9mpiUeMh
CQJSQbLA/bWmFvkHGRp2RS5AWYizMl2EcxwUQYdt/9FZXsotnBg7O+ogzCPGs3Pn
7isZJD1a/8vbWBLga7li7W97HyOd2aQa+qC2hF1uFl365E3vGhL59wAfXeRb6YCG
uc0CRYwl3nr7uFHiKDjeYbg6QYqovar6pgWCNktmx0uuphwuTXF056GGZM35/iZ+
NE/u3C4n4TkjjYLdlSvI3fzwkP1i8ckXsRF9QZLK/dvcKbdl2Sttwh0Rt/46QPsQ
i+wKejuZk0SaG7jy1FkU7cI3icnVDw==
=Deyf
-----END PGP SIGNATURE-----

--qprdy2lzjeysr5w5--
