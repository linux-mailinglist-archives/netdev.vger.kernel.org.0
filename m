Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9549B6E39D6
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjDPPgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 11:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDPPgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 11:36:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88522716
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 08:35:58 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1po4Pk-00089D-DO; Sun, 16 Apr 2023 17:35:40 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 67CEB1AFF88;
        Sun, 16 Apr 2023 15:35:36 +0000 (UTC)
Date:   Sun, 16 Apr 2023 17:35:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="howza2ulvftzwff5"
Content-Disposition: inline
In-Reply-To: <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--howza2ulvftzwff5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.04.2023 14:33:11, Oliver Hartkopp wrote:
>=20
>=20
> On 4/14/23 20:20, Marc Kleine-Budde wrote:
> > On 13.04.2023 17:30:51, Judith Mendez wrote:
> > > Add a hrtimer to MCAN struct. Each MCAN will have its own
> > > hrtimer instantiated if there is no hardware interrupt found.
> > >=20
> > > The hrtimer will generate a software interrupt every 1 ms. In
> >=20
> > Are you sure about the 1ms?

I had the 5ms that are actually used in the code in mind. But this is a
good calculation.

> The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC =
=3D 0
> and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit =3D> ~50
> usecs
>=20
> So it should be something about
>=20
>     50 usecs * (FIFO queue len - 2)

Where does the "2" come from?

> if there is some FIFO involved, right?

Yes, the mcan core has a FIFO. In the current driver the FIFO
configuration is done via device tree and fixed after that. And I don't
know the size of the available RAM in the mcan IP core on that TI SoC.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--howza2ulvftzwff5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ8FcAACgkQvlAcSiqK
BOiz7Qf9GVU38YyuModIpIhfmJ2wG+iWBhXzfO/pbD4ifYxknz+DcL1zgpTBGCrX
wWjHojZuQQPU9AE9UT7vjKfQOcJs90kMFOmI87bEHQLUl8fO40PekZradALAVEII
GEIFnU8ArKzXjaaUJxCmahRP/7cHPjctxRdn10RWkeFW5lITOiiO3rwOrLVogeVe
9KX17fQQ2GbRiIT2e6GNWjngkAgsWo77hqtrSdJr8wvJQZ82Xkct9BCr14dJeoz1
bgMiqIiELi+8hG0Sx2G+hdY+/30pXllBV4LFYluPY4JUjS9GeEWC6r7wGF0HqGe9
FW2ZiemY+PGYXCB67pbf+f8SPAiQvg==
=QN1Y
-----END PGP SIGNATURE-----

--howza2ulvftzwff5--
