Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047BA5234C4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiEKNzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbiEKNze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:55:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE0737016
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:55:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nomoF-0004ZM-Uv; Wed, 11 May 2022 15:55:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AFAD17BD65;
        Wed, 11 May 2022 13:55:22 +0000 (UTC)
Date:   Wed, 11 May 2022 15:55:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220511135522.2qvhtokb4j5qvr3j@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511130540.yowjdvzftq2jutiw@pengutronix.de>
 <6f541d66-f52e-13e0-bfe9-91918af11503@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="khciasqr7ullk2e4"
Content-Disposition: inline
In-Reply-To: <6f541d66-f52e-13e0-bfe9-91918af11503@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--khciasqr7ullk2e4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2022 15:24:00, Oliver Hartkopp wrote:
> > Another use where skb->sk breaks is sending CAN frames with SO_TXTIME
> > with the sched_etf.
> >=20
> > I have a patched version of cangen that uses SO_TXTIME. It attaches a
> > time to transmit to a CAN frame when sending it. If you send 10 frames,
> > each 100ms after the other and then exit the program, the first CAN
> > frames show up as TX'ed while the others (after closing the socket) show
> > up as RX'ed CAN frames in candump.
>=20
> Hm, this could be an argument for the origin flag.
>=20
> But I'm more scared about your described behaviour. What happens if
> the socket is still open?

SO_TXTIME makes an existing race window really, really, really wide.

The race window is between sendmsg() returning to user space and
can_put_echo_skb() -> can_create_echo_skb() -> can_skb_set_owner(). In
can_skb_set_owner() a reference to the socket is taken, if the socket is
not closed:

| https://elixir.bootlin.com/linux/v5.17.6/source/include/linux/can/skb.h#L=
75

If the socket closes _after_ sendmsg(), but _before_ the driver calls
can_put_echo_skb() the CAN frame will have no socket reference and show
up as RX'ed.

> There obviously must be some instance removing the sk reference, right??

No. That's all fine. We fixes that in:

| https://lore.kernel.org/all/20210226092456.27126-1-o.rempel@pengutronix.d=
e/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--khciasqr7ullk2e4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7wEcACgkQrX5LkNig
0105rAf/QPg7zb8QkTDLqj1iZbifsl8tCH6+c1va4al8KU+2e3N/+c+3RnUDWMdv
ZoQuH7xMhwp2EbWkz7dWtuJa3TCwUk6YdLrBeQrUM5hHJP9KPR9tSolTgdBQTNaS
U54XE/8kTB+aeMqVwuUlql0GhoRbEPTXPeLEdM1R7cHDhgM0y/O++na6w+DkeFgD
WwJvKuCjCdpL+spbYr1hhk87BC66ScPkLu0amIlfyRalf2sPFXxfWQ0VjVTbKjeO
4ltvGceoZi+SIXIgTHiys5rXcjlQTr++CnUf2/6LWyYwgZJeBCeIznn15VEDEoqB
Ha4GZtxGwjAOpMAsevwZDsOt/27uwQ==
=PeBy
-----END PGP SIGNATURE-----

--khciasqr7ullk2e4--
