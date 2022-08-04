Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5EA58994A
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbiHDI2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239362AbiHDI2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:28:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7F665828
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:28:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJWD7-0006bS-EP; Thu, 04 Aug 2022 10:28:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 719DCC28ED;
        Thu,  4 Aug 2022 08:28:02 +0000 (UTC)
Date:   Thu, 4 Aug 2022 10:28:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] can: mcp251x: Fix race condition on receive interrupt
Message-ID: <20220804082801.prjdwdindpe3alk3@pengutronix.de>
References: <20220804081411.68567-1-sebastian.wuerl@ororatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qwd6lmx2fq4bhe5q"
Content-Disposition: inline
In-Reply-To: <20220804081411.68567-1-sebastian.wuerl@ororatech.com>
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


--qwd6lmx2fq4bhe5q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.08.2022 10:14:11, Sebastian W=C3=BCrl wrote:
> The mcp251x driver uses both receiving mailboxes of the CAN controller
> chips. For retrieving the CAN frames from the controller via SPI, it chec=
ks
> once per interrupt which mailboxes have been filled and will retrieve the
> messages accordingly.
>=20
> This introduces a race condition, as another CAN frame can enter mailbox 1
> while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 unt=
il
> the interrupt handler is called next, mailbox 0 is emptied before
> mailbox 1, leading to out-of-order CAN frames in the network device.
>=20
> This is fixed by checking the interrupt flags once again after freeing
> mailbox 0, to correctly also empty mailbox 1 before leaving the handler.
>=20
> For reproducing the bug I created the following setup:
>  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
>  - Setup CAN to 1 MHz
>  - Spam bursts of 5 CAN-messages with increasing CAN-ids
>  - Continue sending the bursts while sleeping a second between the bursts
>  - Check on the RPi whether the received messages have increasing CAN-ids
>  - Without this patch, every burst of messages will contain a flipped pair
>=20
> Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead o=
f workqueues.")
> Signed-off-by: Sebastian W=C3=BCrl <sebastian.wuerl@ororatech.com>

I've reduced the scope of intf1, eflag1 while applying the patch to
can-next/master.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qwd6lmx2fq4bhe5q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLrgw4ACgkQrX5LkNig
0105lQgAsm+Bkp2do8C0S2QsVI8ZhY+9fLBsoaF/xT63CdKufAbDA6tDFMI6sCEC
5krLrMRxtRogbpx8nJkPcWhIULA8vAs26KCuSEJO4xcOqsfZxeq0YF4DnFjZzmdA
IYKPer7wB78gBgdBQiJlad44enwtcfVREGHDfd3PhZ34AMFUrKMEOGZ+ATleK1QB
ryXUSa8i3SDTfKBWQx86/ns8i42JdnBTHcsNSkuPDvPf1DBWe9hWZabP0yky1ck9
XCvbL3kNGepG0TBBRXSMTADNGj3DXgA7QvsMq38ZVE2EX4i5oia56dauC2X4H2E5
2hPZiEAgghwGJMHb8dx+5uUSEqNNaw==
=G5re
-----END PGP SIGNATURE-----

--qwd6lmx2fq4bhe5q--
