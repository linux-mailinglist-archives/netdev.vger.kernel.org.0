Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6FA438C29
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 23:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhJXVmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 17:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJXVmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 17:42:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D3C061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 14:40:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1melDs-0003ih-7V; Sun, 24 Oct 2021 23:40:08 +0200
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3821B69C6F9;
        Sun, 24 Oct 2021 21:38:30 +0000 (UTC)
Date:   Sun, 24 Oct 2021 23:37:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can <linux-can@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: ethtool: ring configuration for CAN devices
Message-ID: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k6qgxznwttbrrlr2"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k6qgxznwttbrrlr2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm currently working on runtime configurable RX/TX ring sizes for a the
mcp251xfd CAN driver.

Unlike modern Ethernet cards with DMA support, most CAN IP cores come
with a fixed size on chip RAM that's used to store received CAN frames
and frames that should be sent.

For CAN-2.0 only devices that can be directly supported via ethtools's
set/get_ringparam. A minor unaesthetic is, as the on chip RAM is usually
shared between RX and TX, the maximum values for RX and TX cannot be set
at the same time.

The mcp251xfd chip I'm enhancing supports CAN-2.0 and CAN-FD mode. The
relevant difference of these modes is the size of the CAN frame. 8 vs 64
bytes of payload + 12 bytes of header. This means we have different
maximum values for both RX and TX for those modes.

How do we want to deal with the configuration of the two different
modes? As the current set/get_ringparam interface can configure the
mini- and jumbo frames for RX, but has only a single TX value.

Hao Chen and Guangbin Huang are laying the groundwork to extend the
ringparam interface via netlink:

| https://lore.kernel.org/all/20211014113943.16231-1-huangguangbin2@huawei.=
com

I was thinking about adding rx/tx_pending for CAN-FD. The use case would
be to configure the ring parameters independent of the current active
CAN mode. For example in systemd the RX/TX ring parameters are
configured in the .link file, while the CAN FD mode is configured in a
=2Enetwork file. When switching to the other CAN mode, the previously
configured ring configuration of that CAN mode will be applied to the
hardware.

In my proof of concept implementation I'm misusing the struct
ethtool_ringparam's mini and jumbo values to pre-configure the CAN-2.0
and CAN-FD mode's RX ring size, but this is not mainlinable from my
point of view.

I'm interested in your opinion and use cases.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--k6qgxznwttbrrlr2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF10jQACgkQqclaivrt
76kKMAf/QqxTFD6/g6hOCAsmJsLhJc74APW89HWaHdI4Zq7eupmc/S0wdNwJmkIz
mzodDbwtU8ivZ6QutoHdHJ8pqt4yHDCtC6j8qeb6ETGNA6BjjsKnRLaeM9f5teus
QnnmZEHssArArafijZEV+Qs28ItB/KTk9rHhk21wgSM5djjos7pOwSPQ1y1R+TcE
sX1TjbwhIdQf53CPUtc3E04qq5aNjNjFmTmXei4ms2KAp1YpZjXHIWDzkuco7Jf/
k+HPF4CZy28MsvdubkTMRcAxHTQfQokcP/B7zLyP0OjggJK43YM6RzVWmWhVGAY0
GcGgO0zm1Y/pHnetI1bFXBVwUOQrvw==
=xnsg
-----END PGP SIGNATURE-----

--k6qgxznwttbrrlr2--
