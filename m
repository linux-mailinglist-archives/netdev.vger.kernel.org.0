Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8989468817A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjBBPQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjBBPQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:16:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71925EB60
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:16:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNbKB-0001Tw-HK; Thu, 02 Feb 2023 16:16:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:fff9:bfd9:c514:9ad9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BF50816D6E0;
        Thu,  2 Feb 2023 15:16:30 +0000 (UTC)
Date:   Thu, 2 Feb 2023 16:16:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] can: etas_es58x: do not send disable channel command if
 device is unplugged
Message-ID: <20230202151622.sotqfwmgwwtgv4dl@pengutronix.de>
References: <20230128133815.1796221-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dx67jpnx5gharsn4"
Content-Disposition: inline
In-Reply-To: <20230128133815.1796221-1-mailhol.vincent@wanadoo.fr>
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


--dx67jpnx5gharsn4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.01.2023 22:38:15, Vincent Mailhol wrote:
> When turning the network interface down, es58x_stop() is called and
> will send a command to the ES58x device to disable the channel
> c.f. es58x_ops::disable_channel().
>=20
> However, if the device gets unplugged while the network interface is
> still up, es58x_ops::disable_channel() will obviously fail to send the
> URB command and the driver emits below error message:
>=20
>   es58x_submit_urb: USB send urb failure: -ENODEV
>=20
> Check the usb device state before sending the disable channel command
> in order to silence above error message.
>=20
> Update the documentation of es58x_stop() accordingly.
>=20
> The check being added in es58x_stop() is:
>=20
>   	if (es58x_dev->udev->state >=3D USB_STATE_UNAUTHENTICATED)
>=20
> This is just the negation of the check done in usb_submit_urb()[1].
>=20
> [1] usb_submit_urb(), verify usb device's state.
> Link: https://elixir.bootlin.com/linux/v6.1/source/drivers/usb/core/urb.c=
#L384
>=20
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CA=
N USB interfaces")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> As far as I know, there doesn't seem to be an helper function to check
> udev->state values. If anyone is aware of such helper function, let me
> know..

The constant USB_STATE_UNAUTHENTICATED is not used very often in the
kernel. Maybe Greg can point out what is best to do here.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dx67jpnx5gharsn4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPb08MACgkQvlAcSiqK
BOjCpwgAjw8g9utZ42KMZ79CdoaOnCDfcQfMxkEIPxf71Vom6bhzkdFGkMgZdycL
NkZxwkaPqQ/dRFvsiJJdmyyPzhwLym93UyThnmCwtaiySPXcuoD7YrXXBykybd4E
MAh8cPf3filJ9e+XOLv+dJizaS5dmcDWLpgAXPjWsroerYqkBBKs2BxqxllNamII
LlTvFfGnPBRDOEEwCGJO6QL7UzFBJlb0SmxKzTlq0vUWOKce+SBqssIQrlb/1bFD
YHXoB5uZAU6R+YSjzBpSgCKJPHMWQBU1MTxCQw9oK0UYUP0nJyNwTwb+PRP4/h5M
03Sc24BnP7tkL4s9yklOVZnCTtJN7A==
=Xohv
-----END PGP SIGNATURE-----

--dx67jpnx5gharsn4--
