Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3979439239
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhJYJZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJYJZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:25:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F3AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 02:23:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mewCT-0005a4-AP; Mon, 25 Oct 2021 11:23:25 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-d7c8-7df6-a4ac-55f0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d7c8:7df6:a4ac:55f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5AB0969D3CD;
        Mon, 25 Oct 2021 09:21:10 +0000 (UTC)
Date:   Mon, 25 Oct 2021 11:21:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <20211025092109.tyapmi5naky7hmww@pengutronix.de>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
 <20211025090008.GD7834@x1.vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qfnavhxk2kntkswq"
Content-Disposition: inline
In-Reply-To: <20211025090008.GD7834@x1.vandijck-laurijssen.be>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qfnavhxk2kntkswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 11:00:08, Kurt Van Dijck wrote:
> On Sun, 24 Oct 2021 23:37:59 +0200, Marc Kleine-Budde wrote:
> > Hello,
> >=20
> > I'm currently working on runtime configurable RX/TX ring sizes for a the
> > mcp251xfd CAN driver.
> >=20
> > Unlike modern Ethernet cards with DMA support, most CAN IP cores come
> > with a fixed size on chip RAM that's used to store received CAN frames
> > and frames that should be sent.
> >=20
> > For CAN-2.0 only devices that can be directly supported via ethtools's
> > set/get_ringparam. A minor unaesthetic is, as the on chip RAM is usually
> > shared between RX and TX, the maximum values for RX and TX cannot be set
> > at the same time.
> >=20
> > The mcp251xfd chip I'm enhancing supports CAN-2.0 and CAN-FD mode. The
> > relevant difference of these modes is the size of the CAN frame. 8 vs 64
> > bytes of payload + 12 bytes of header. This means we have different
> > maximum values for both RX and TX for those modes.
> >=20
> > How do we want to deal with the configuration of the two different
> > modes? As the current set/get_ringparam interface can configure the
> > mini- and jumbo frames for RX, but has only a single TX value.
> >=20
> > Hao Chen and Guangbin Huang are laying the groundwork to extend the
> > ringparam interface via netlink:
> >=20
> > | https://lore.kernel.org/all/20211014113943.16231-1-huangguangbin2@hua=
wei.com
> >=20
> > I was thinking about adding rx/tx_pending for CAN-FD. The use case would
> > be to configure the ring parameters independent of the current active
> > CAN mode. For example in systemd the RX/TX ring parameters are
> > configured in the .link file, while the CAN FD mode is configured in a
> > .network file. When switching to the other CAN mode, the previously
> > configured ring configuration of that CAN mode will be applied to the
> > hardware.
> >=20
> > In my proof of concept implementation I'm misusing the struct
> > ethtool_ringparam's mini and jumbo values to pre-configure the CAN-2.0
> > and CAN-FD mode's RX ring size, but this is not mainlinable from my
> > point of view.
> >=20
> > I'm interested in your opinion and use cases.
>=20
> Isn't the simplest setup to stick to the current CAN mode (2.0 vs. FD).
>=20
> Certain values/combinations may be valid in 2.0 and not in FD. So what?
> This is true also for data-bittiming and what not.
>=20
> I see no advantage in putting your configuration in different files
> (.link and .network), since they influence each other.

That's the way systemd has chosen to put these values....

> I can imaging one network operating in FD, with certain rx/tx settings,
> and another network operating in 2.0, with different rx/tx settings.
> and a 3rd network operating in FD, with also different rx/tx settings.

ACK - the .link and .network files are per network interface, so that
should be no problem to have different settings for different CAN
interfaces.

> If that is a problem for systemd, then ... fix systemd?
> (systemd is really out of my scope, I'm not used to it)
>=20
> IMHO, you try to provide different default settings (rx/tx split) for FD
> and 2.0 mode.

ACK - the driver provides default settings for CAN-2.0 and CAN-FD mode
and I want to overwrite both default settings via ethtool ring settings.
So that these overwritten settings are used when switching from CAN to
CAN-FD mode an back.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qfnavhxk2kntkswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2dwEACgkQqclaivrt
76l4rwf/eeHWWcGFuyFbNhuSVFQHwW12Ov7Nwz8XVTIfmtmNRhY+5hRxYRi/WJ/E
Q5YZyeogqNuMEHXTCZfAvJSgUmpSGrkKiU7boTi0p+3xOvaYVFRFDGsCvumSjTxx
uN0QCRlkDHbZxN1oLhIwAeBWKBf0u1A70ejGMYLoHb2seF9SYCXb0G314MJZSZA+
HHt+JWMwHekAUo092anRhgtKvAGhpMzIKDk431PtQpmG0I/fjWLU5Jd4JsqsbFbf
QpNmPVvgkm8KCyXnNMeIiZ8GkyHFXYSOQvsrI6LscTyIQoGCz75WRx0A9+enLzcK
DrYqwiYYv/TIucEDA16Bh5a7OmQ5VA==
=+4Hy
-----END PGP SIGNATURE-----

--qfnavhxk2kntkswq--
