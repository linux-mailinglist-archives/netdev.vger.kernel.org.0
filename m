Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48E65B5888
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiILKiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiILKiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:38:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8372124B
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 03:38:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oXgpi-0007Ch-Fz; Mon, 12 Sep 2022 12:38:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:75e7:62d4:691e:2f47])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2F4DAE120B;
        Mon, 12 Sep 2022 10:38:27 +0000 (UTC)
Date:   Mon, 12 Sep 2022 12:38:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Bence =?utf-8?B?Q3PDs2vDoXM=?= <bence98@sch.bme.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>, kernel@pengutronix.de,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Subject: Re: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Message-ID: <20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bkeskyh3bgpjqw4a"
Content-Disposition: inline
In-Reply-To: <20220912073106.2544207-1-bence98@sch.bme.hu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bkeskyh3bgpjqw4a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.09.2022 07:31:04, Bence Cs=C3=B3k=C3=A1s wrote:
> From: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
>=20
> `clk_prepare_enable()` gets called in atomic context (holding a spinlock),
> which may sleep, causing a BUG on certain platforms.
>=20
> This reverts commit b353b241f1eb9b6265358ffbe2632fdcb563354f.
>=20
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutr=
onix.de/
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>

This is not a 100% revert.

In b353b241f1eb ("net: fec: Use a spinlock to guard `fep->ptp_clk_on`")
the "struct fec_enet_private *fep" was renamed to "struct
fec_enet_private *adapter" for no apparent reason. The driver uses "fep"
everywhere else. This revert doesn't restore the original state.

This leads to the following diff against a 100% revert.

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/etherne=
t/freescale/fec_ptp.c
index c99dff3c3422..c74d04f4b2fd 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp=
, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *=
ts)
 {
-       struct fec_enet_private *fep =3D
+       struct fec_enet_private *adapter =3D
            container_of(ptp, struct fec_enet_private, ptp_caps);
        u64 ns;
        unsigned long flags;
=20
-       mutex_lock(&fep->ptp_clk_mutex);
+       mutex_lock(&adapter->ptp_clk_mutex);
        /* Check the ptp clock */
-       if (!fep->ptp_clk_on) {
-               mutex_unlock(&fep->ptp_clk_mutex);
+       if (!adapter->ptp_clk_on) {
+               mutex_unlock(&adapter->ptp_clk_mutex);
                return -EINVAL;
        }
-       spin_lock_irqsave(&fep->tmreg_lock, flags);
-       ns =3D timecounter_read(&fep->tc);
-       spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-       mutex_unlock(&fep->ptp_clk_mutex);
+       spin_lock_irqsave(&adapter->tmreg_lock, flags);
+       ns =3D timecounter_read(&adapter->tc);
+       spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+       mutex_unlock(&adapter->ptp_clk_mutex);
=20
        *ts =3D ns_to_timespec64(ns);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bkeskyh3bgpjqw4a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMfDBcACgkQrX5LkNig
010Ywgf/f6P/2XH6p6BGMFzve/yJDWkBFEruig1JimoGDkRok897UmyDOewsveA4
nlFBwio6+u6S322ZJklup+pV0ea/iALtHYP1G/EEnpPFCjr1Y8MULNsm6r/OdLrN
DOlH/BPQmzPJrGk9uiSrnNCfXP7t7S280fuPn4UqMG53q0oIJus/mFWvNgwGx5qZ
1PUDPNQS+Ux4Xb60LyLZ3QpGSmejYIAsOKLyHAqUYLB7Z+CRIVW3p4OEb+tq/3kG
Gdd2EXUKuh7wE39sU8bymMO+Z7Np8l2XvXl5IHhbXBf6YvIcOYS3/RdGiTDW4Jat
2AOFiQjVJqVMNmsiIVNwl1WlJtCEGw==
=kR2t
-----END PGP SIGNATURE-----

--bkeskyh3bgpjqw4a--
