Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F474B3623
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiBLP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:57:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbiBLP5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:57:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16CD197
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:57:43 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nIumI-00036C-9A; Sat, 12 Feb 2022 16:57:38 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9D0DB31CE4;
        Sat, 12 Feb 2022 15:57:36 +0000 (UTC)
Date:   Sat, 12 Feb 2022 16:57:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] can: etas_es58x: change opened_channel_cnt's type from
 atomic_t to u8
Message-ID: <20220212155733.gfwkcs7xcwlqzi6r@pengutronix.de>
References: <20220212112713.577957-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="or7bahfvzj2pyh3l"
Content-Disposition: inline
In-Reply-To: <20220212112713.577957-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--or7bahfvzj2pyh3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.02.2022 20:27:13, Vincent Mailhol wrote:
> The driver uses an atomic_t variable: es58x_device:opened_channel_cnt
> to keep track of the number of opened channels in order to only
> allocate memory for the URBs when this count changes from zero to one.
>=20
> While the intent was to prevent race conditions, the choice of an
> atomic_t turns out to be a bad idea for several reasons:
>=20
>   - implementation is incorrect and fails to decrement
>     opened_channel_cnt when the URB allocation fails as reported in
>     [1].
>=20
>   - even if opened_channel_cnt were to be correctly decremented,
>     atomic_t is insufficient to cover edge cases: there can be a race
>     condition in which 1/ a first process fails to allocate URBs
>     memory 2/ a second process enters es58x_open() before the first
>     process does its cleanup and decrements opened_channed_cnt. In
>     which case, the second process would successfully return despite
>     the URBs memory not being allocated.
>=20
>   - actually, any kind of locking mechanism was useless here because
>     it is redundant with the network stack big kernel lock
>     (a.k.a. rtnl_lock) which is being hold by all the callers of
>     net_device_ops:ndo_open() and net_device_ops:ndo_close(). c.f. the
>     ASSERST_RTNL() calls in __dev_open() [2] and __dev_close_many()
>     [3].
>=20
> The atmomic_t is thus replaced by a simple u8 type and the logic to
> increment and decrement es58x_device:opened_channel_cnt is simplified
> accordingly fixing the bug reported in [1]. We do not check again for
> ASSERST_RTNL() as this is already done by the callers.
>=20
> [1] https://lore.kernel.org/linux-can/20220201140351.GA2548@kili/T/#u
> [2] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1463
> [3] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1541
>=20
> Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X
> CAN USB interfaces")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Applied to can/testing.

I you (or someone else) wants to increase their patch count feel free to
convert the other USB CAN drivers from atomic_t to u8, too.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--or7bahfvzj2pyh3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIH2OoACgkQrX5LkNig
010rfQf/Ypr0HCUdEvv9P+qkSUewRSnI68KG9s7/aL3RUX3UJIbUXufDK0Ktgx9h
sMjEqlxMXT+6ED6FRSVo90sIdnAla4QY9+qmYkXSr7UeWBmFWGk1ctjg6ZOFeXCb
5rxy1S+bM9IGoicut5gJQkg981C+Bh2P99FQsZ7sKWrlQUUEdv3HIFAB7PrMVMTG
il5dE+QAk1HwFR0DXk7lyKmYtM7pvdSAhdzhIx8ndUPwHx0xP1ZhzSrGfK0rQN+d
ccma9L/1AejOf9IRJPI0jxbKtVElfyiMRQAKsVSgrIRb9uJ+I2jBC56j8khgdQUm
Nag0SzvYY4jMrQwJ4zywAxwd0qq95g==
=1A7l
-----END PGP SIGNATURE-----

--or7bahfvzj2pyh3l--
