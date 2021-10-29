Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508A643FB72
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhJ2Lgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhJ2Lgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:36:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F92C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 04:34:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mgQ9B-0004ym-Nn; Fri, 29 Oct 2021 13:34:09 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e533-710f-3fbf-10c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e533:710f:3fbf:10c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 339986A0970;
        Fri, 29 Oct 2021 11:34:06 +0000 (UTC)
Date:   Fri, 29 Oct 2021 13:34:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Sean Nyekjaer <sean@geanix.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Subject: Re: [RFC PATCH v1] can: m_can: m_can_read_fifo: fix memory leak in
 error branch
Message-ID: <20211029113405.hbqcu6chf5e3olrm@pengutronix.de>
References: <20211026180909.1953355-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lmadwv6kox6viphu"
Content-Disposition: inline
In-Reply-To: <20211026180909.1953355-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lmadwv6kox6viphu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.10.2021 03:09:09, Vincent Mailhol wrote:
> In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
> the function jump to the out_fail label and returns without calling
> m_can_receive_skb(). This means that the skb previously allocated by
> alloc_can_skb() is not freed. In other terms, this is a memory leak.
>=20
> This patch adds a new goto statement: out_receive_skb and do some
> small code refactoring to fix the issue.

This means we pass a skb to the user space, which contains wrong data.
Probably 0x0, but if the CAN frame doesn't contain 0x0, it's wrong. That
doesn't look like a good idea. If the CAN frame broke due to a CRC issue
on the wire it is not received. IMHO it's best to discard the skb and
return the error.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lmadwv6kox6viphu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF73CoACgkQqclaivrt
76lx8Af/dk/tZ39vAPhTsRy6i6hVimJK8nwFFk43d98GcPjGHyb2tqrRO9ePCB2p
ekFqT90SzuqplPNhMm/Up9t8NnAAHYzymBXgwcldv/tT+Cm61AAz08ku9NH9tpe2
hX/STgDOwxJYnKSPc2XkDjm4ZQr7Hu9gTeCbZR9RFGIg/mgha2nJvOkYOPyQj+6X
HdOvSBNCumahuAAQB881jdbVc5FPbC9TIkKdZDy2WPJWDJA2DN5QfXZpzCte6xDU
9fYwBWQSMX88o9IREvoYfUieuf5uw4g4xKVRCJYHHfAjreyy8g0dS7N6MqeFzVk6
LK7/lDDNFL+WdGkPGpC4liom4wpe4Q==
=vVSG
-----END PGP SIGNATURE-----

--lmadwv6kox6viphu--
