Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8514470F5
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 00:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhKFXVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 19:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhKFXVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 19:21:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0525C061714
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 16:18:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjUxS-00009t-J8; Sun, 07 Nov 2021 00:18:46 +0100
Received: from pengutronix.de (dialin-80-228-153-084.ewe-ip-backbone.de [80.228.153.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CB31A6A6018;
        Sat,  6 Nov 2021 23:18:41 +0000 (UTC)
Date:   Sun, 7 Nov 2021 00:18:39 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Matt Kline <matt@bitbashing.io>,
        Sean Nyekjaer <sean@geanix.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Subject: Re: [RFC PATCH v1] can: m_can: m_can_read_fifo: fix memory leak in
 error branch
Message-ID: <20211106231839.7zcmtxpidemu4owa@pengutronix.de>
References: <20211026180909.1953355-1-mailhol.vincent@wanadoo.fr>
 <20211029113405.hbqcu6chf5e3olrm@pengutronix.de>
 <CAMZ6RqJ1CtphrUxRDWOKEsJF_uzoPbYD2mPiD56VvJ9qB7oxow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="34ah5prvwlomu2j5"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ1CtphrUxRDWOKEsJF_uzoPbYD2mPiD56VvJ9qB7oxow@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--34ah5prvwlomu2j5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.10.2021 01:35:01, Vincent MAILHOL wrote:
> On Fri. 29 Oct 2021 at 20:34, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 27.10.2021 03:09:09, Vincent Mailhol wrote:
> > > In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
> > > the function jump to the out_fail label and returns without calling
> > > m_can_receive_skb(). This means that the skb previously allocated by
> > > alloc_can_skb() is not freed. In other terms, this is a memory leak.
> > >
> > > This patch adds a new goto statement: out_receive_skb and do some
> > > small code refactoring to fix the issue.
> >
> > This means we pass a skb to the user space, which contains wrong data.
> > Probably 0x0, but if the CAN frame doesn't contain 0x0, it's wrong. That
> > doesn't look like a good idea. If the CAN frame broke due to a CRC issue
> > on the wire it is not received. IMHO it's best to discard the skb and
> > return the error.
>=20
> Arg... Guess I made the right choice to tag the patch as RFC...
>=20
> Just one question, what is the correct function to discard the
> skb? The driver uses the napi polling system (which I am not
> entirely familiar with). Does it mean that the rx is not done in
> IRQ context and that we can simply use kfree_skb() instead of
> dev_kfree_skb_irq()?

The m_can driver is a bit more complicated. It uses NAPI for mmio
devices, but threaded IRQs for SPI devices. Looking at
dev_kfree_skb_any(), it checks for hard IRQs or IRQs disabled, I think
this is not the case for both threaded IRQs and NAPI.

https://elixir.bootlin.com/linux/v5.15/source/net/core/dev.c#L3108

So I think kfree_skb() should be OK.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--34ah5prvwlomu2j5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGHDU0ACgkQqclaivrt
76nZXwf/a7+FU0/i5iAebuEHJK4kAC72+mXiRsd5KL37AS5zpvzdkwzuHe7UJdGh
clzOZO6CNhzUlqbzeo1q5kT42cMJEkiKRcUcID6NNwXMlIz0fPv80w3Uh18dHk0A
QXiQlwi51iQWBE3/YUDH1sTYtsoQxeqtvKaURW509QbKoCVqzn9G7mWqmQwol9v6
j5S6jRPso/i8bQA9Ye9IcIx5nhUz+mVEaQ2I+NSGL1Kq0cfKgUYJBHQ8XHGkjID8
MJauoS4vvVqsxarQGfeGCs3O5uPR2OE5utIfvB2d9Ph1oLEgmmUrxH4kG4xwXcJ6
HWCndadx1//5xbD3pTzSS3a4X3IEjg==
=3/22
-----END PGP SIGNATURE-----

--34ah5prvwlomu2j5--
