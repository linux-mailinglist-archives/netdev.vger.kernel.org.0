Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A60C482C1B
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiABQeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiABQeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:34:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F425C061761
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 08:34:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n43o1-0001dT-4Y; Sun, 02 Jan 2022 17:34:01 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-19ab-6bce-1341-f825.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:19ab:6bce:1341:f825])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A98DC6CFE8D;
        Sun,  2 Jan 2022 16:33:58 +0000 (UTC)
Date:   Sun, 2 Jan 2022 17:33:57 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Michael Nazzareno Trimarchi <michael@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: switch the i.MX series to timestamp based
 rx-offload
Message-ID: <20220102163357.x5n2jmhvujc4m2xa@pengutronix.de>
References: <20220102155813.1646746-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="casjbuybefz3uc73"
Content-Disposition: inline
In-Reply-To: <20220102155813.1646746-1-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--casjbuybefz3uc73
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.01.2022 16:58:13, Dario Binacchi wrote:
> As explained by commit b3cf53e988ce ("can: flexcan: add support for
> timestamp based rx-offload"), the controller has 64 message buffers but
> it uses only 6 for reception. Enabling timestamp mode, instead of FIFO,
> allows you to use the maximum number of messages for reception.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Signed-off-by: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>

NACK - according to the data sheet these controllers cannot receive RTR
messages via mailboxes.

See Section "26.4.8.1 Remote Frames" of the mx25 rev. 2 data sheet:

| When a remote request frame is received by FlexCAN, its ID is compared
| to the IDs of the transmit message buffers with CODE field 0b1010. If
| there is a matching ID, then this message buffer frame is transmitted.
| If the matching message buffer has the RTR bit set, then FlexCAN
| transmits a remote frame as a response.
|=20
| A received remote request frame is not stored in a receive buffer. It is
| only used to trigger a transmission of a frame in response. The mask
| registers are not used in remote frame matching, and all ID bits (except
| RTR) of the incoming received frame must match.
|=20
| In the case that a remote request frame is received and matches a
| message buffer, this message buffer immediately enters the internal
| arbitration process, but is considered as normal Tx message buffer, with
| no higher priority. The data length of this frame is independent of the
| DLC field in the remote frame that initiated its transmission.
|=20
| If the Rx FIFO is enabled (the FEN bit in the MCR is set to 1), FlexCAN
| does not generate an automatic response for remote request frames that
| match the FIFO filtering criteria. If the remote frame matches one of
| the target IDs, it is stored in the FIFO and presented to the ARM. For
| filtering formats A and B, it is possible to select whether remote
| frames are accepted or not. For format C, remote frames are always
| accepted (if they match the ID).

This is in general not acceptable for all users. If you can live with
this limitation, please make it runtime configurable, e.g. via the
ethtool interface.

Not sure which ethtool callback to use, yet, but we can figure this out
together. Please create an RFC patch, where you put the struct
devtype_data into the priv instead of a pointer to it. In a second patch
we can add the ethtool code to change the struct
devtype_data::devtype_data::quirks.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--casjbuybefz3uc73
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHR0/IACgkQqclaivrt
76lFZAf+JOX0DhYZ03HQ6M0mkBErIv8lCgL4K/hwJ6vGBYT/Mavbne5mge7EZIKJ
LdgxrGDir7vo7Ezej3WH3kiFhPej8h3aS8cFMBQ2N85rXjbve7kFuGTLE8NLkhZa
yW1MqNA3giBMuhLnwMisxTDutH3IWB602UEjiLO3ShQDj07M4syN5Q+X9mxgvMN6
ZXp8BOBLy5lWzmANWnVk7McgCAa2ewxsYyfx+o6/coeLtgpcsCmUrRy1oxKcIS1e
SNJyUe2Hc7sSBgzkR9NgSAgaAbNGn3mUWHuZ3tMIZmqEYxrz3APYaeZv05bDEnHS
CzU3yn7MRcQMBvFmasVJ2Zr47cOJ/w==
=tnd8
-----END PGP SIGNATURE-----

--casjbuybefz3uc73--
