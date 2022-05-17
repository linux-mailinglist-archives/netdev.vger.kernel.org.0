Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC12252994B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiEQGId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbiEQGI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:08:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BDD37017
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 23:08:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqqNc-0006wY-Km; Tue, 17 May 2022 08:08:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 80C417FF92;
        Tue, 17 May 2022 06:08:22 +0000 (UTC)
Date:   Tue, 17 May 2022 08:08:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3brhaeolxdtxpqfu"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
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


--3brhaeolxdtxpqfu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2022 10:50:16, Vincent MAILHOL wrote:
> > would it probably make sense to
> > introduce a new can-skb module that could be used by all CAN
> > virtual/software interfaces?
> >
> > Or some other split-up ... any idea?
>=20
> My concern is: what would be the merrit? If we do not split, the users
> of slcan and v(x)can would have to load the can-dev module which will
> be slightly bloated for their use, but is this really an issue?

If you use modprobe all required modules are loaded automatically.

> I do
> not see how this can become a performance bottleneck, so what is the
> problem?
> I could also argue that most of the devices do not depend on
> rx-offload.o. So should we also split this one out of can-dev on the
> same basis and add another module dependency?

We can add a non user visible Kconfig symbol for rx-offload and let the
drivers that need it do a "select" on it. If selected the rx-offload
would be compiled into to can-dev module.

> The benefit (not having to load a bloated module for three drivers)
> does not outweigh the added complexity: all hardware modules will have
> one additional modprobe dependency on the tiny can-skb module.
>
> But as said above, I am not fully opposed to the split, I am just
> strongly divided. If we go for the split, creating a can-skb module is
> the natural and only option I see.
> If the above argument does not convince you, I will send a v3 with that s=
plit.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3brhaeolxdtxpqfu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKDO9MACgkQrX5LkNig
013nNQgAs6sXnBTJ3oYKGxGuF0zVVmtQc7oenY5YfI2tsw0mDOYsyaPSrvt5hSwV
MYGVyp3pFx5D6wQJlmZnjK3ZLStPm6nw9wuHcrZDcSazZVOGwTm6+DNI0neUfjI1
kjEXywoc5taDm47he6CnHSc0dvXzgXQLuCrJRsi7P2zUcPdmhgQL1L+0QmuC6dJD
biLKlIt5LxE2iiGB87k1r5qak8x3qO9EpomYM68Od0wfIKEQo+ivpFYFClBROxbT
HdQcAKxpH8D8oYR967690GN9lbpJgzrOfTy+sgeSfb/MnirmJOUFppTd+TJat1tW
LWPcfpQ6aXMwU5eD6+W7iMLMOpN9HA==
=ZwuT
-----END PGP SIGNATURE-----

--3brhaeolxdtxpqfu--
