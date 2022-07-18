Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FCA578032
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiGRKvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiGRKvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:51:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BAA20182
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:51:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDOLb-0001mK-73; Mon, 18 Jul 2022 12:51:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F11F8B301D;
        Mon, 18 Jul 2022 10:51:29 +0000 (UTC)
Date:   Mon, 18 Jul 2022 12:51:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Vikram Garhwal <fnu.vikram@xilinx.com>
Subject: Re: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Message-ID: <20220718105128.s22vp5hx4somy64f@pengutronix.de>
References: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
 <20220718083312.4izyuf7iawfbhlnf@pengutronix.de>
 <202207181220.06765.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i4qfmohhwbabeeil"
Content-Disposition: inline
In-Reply-To: <202207181220.06765.pisa@cmp.felk.cvut.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--i4qfmohhwbabeeil
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.07.2022 12:20:06, Pavel Pisa wrote:
> Hello Marc,
>=20
> On Monday 18 of July 2022 10:33:12 Marc Kleine-Budde wrote:
> > On 16.07.2022 14:04:09, Matej Vasilevski wrote:
> > > This patch adds support for hardware RX timestamps from Xilinx Zynq C=
AN
> > > controllers. The timestamp is calculated against a timepoint reference
> > > stored when the first CAN message is received.
> > >
> > > When CAN bus traffic does not contain long idle pauses (so that
> > > the clocks would drift by a multiple of the counter rollover time),
> > > then the hardware timestamps provide precise relative time between
> > > received messages. This can be used e.g. for latency testing.
> >
> > Please make use of the existing cyclecounter/timecounter framework. Is
> > there a way to read the current time from a register? If so, please
> > setup a worker that does that regularly.
> >
> > Have a look at the mcp251xfd driver as an example:
>=20
> Matej Vasilevski has looked at the example. But there is problem
> that we know no method how to read actual counter value at least for
> Xilinx Zynq 7000. May be we overlooked something or there
> is hidden test register.

I haven't found a documented register in the TRM. I've added Michal
Simek into the loop, maybe Michal has some connection to the HW
designers.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--i4qfmohhwbabeeil
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLVOy0ACgkQrX5LkNig
011bzQf+M+TZm39JcDKTeDMjAFYuuJwFOOd8PfCqsuOWaGzohZMqKfDcWOZkrc+c
J0WEHXYGeUe1DybHt2iHR+jf/fE3HSlzzPn4rFxWbdbIjwW8QUMBZ8XhPQSEiN0r
UXcOw6L04U7HjEyBH+ceVMvP44ny4yHlaozpEkE9sJ04lVojTasxa1H0rGX2lEyZ
/EOp5SXZJHhfa/IXQ2pro0BirwgHiPkJDDpC/R/aQFy+bdD23gnGPI5AKN8nmrk/
GN3MblYE3TZVErafYsfGFC5ZGzdkDu8PAZxUoBMi2nOis4BZvINtB+/KLRSun1F5
PIqsr37/zd5tUEGK0BlxFHSHp/A10g==
=vJup
-----END PGP SIGNATURE-----

--i4qfmohhwbabeeil--
