Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0071589296
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 21:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiHCTIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 15:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbiHCTIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 15:08:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51285A897
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 12:08:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJJiy-0004kG-3b; Wed, 03 Aug 2022 21:08:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3035FC2431;
        Wed,  3 Aug 2022 19:08:06 +0000 (UTC)
Date:   Wed, 3 Aug 2022 21:08:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Sebastian =?utf-8?B?V8O8cmw=?= <sebastian.wuerl@ororatech.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/can/spi/mcp251x.c: Fix race condition on
 receive interrupt
Message-ID: <20220803190804.b3p4iugcz3yp6mtc@pengutronix.de>
References: <20220803153300.58732-1-sebastian.wuerl@ororatech.com>
 <CAHp75VdCH2tJQq3v_-iNP27oWFGF7EtKc-w299tLhDV85WbroQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5gaiw5anvnre55n2"
Content-Disposition: inline
In-Reply-To: <CAHp75VdCH2tJQq3v_-iNP27oWFGF7EtKc-w299tLhDV85WbroQ@mail.gmail.com>
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


--5gaiw5anvnre55n2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.08.2022 18:48:57, Andy Shevchenko wrote:
> On Wed, Aug 3, 2022 at 5:36 PM Sebastian W=C3=BCrl
> <sebastian.wuerl@ororatech.com> wrote:
> >
> > The mcp251x driver uses both receiving mailboxes of the can controller
>=20
> CAN
>=20
> > chips. For retrieving the CAN frames from the controller via SPI, it ch=
ecks
> > once per interrupt which mailboxes have been filled, an will retrieve t=
he
> > messages accordingly.
> >
> > This introduces a race condition, as another CAN frame can enter mailbo=
x 1
> > while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 u=
ntil
> > the interrupt handler is called next, mailbox 0 is emptied before
> > mailbox 1, leading to out-of-order CAN frames in the network device.
> >
> > This is fixed by checking the interrupt flags once again after freeing
> > mailbox 0, to correctly also empty mailbox 1 before leaving the handler.
> >
> > For reproducing the bug I created the following setup:
> >  - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
> >  - Setup CAN to 1 MHz
> >  - Spam bursts of 5 CAN-messages with increasing CAN-ids
> >  - Continue sending the bursts while sleeping a second between the burs=
ts
> >  - Check on the RPi whether the received messages have increasing CAN-i=
ds
> >  - Without this patch, every burst of messages will contain a flipped p=
air
>=20
> Fixes tag?

Should be:
Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead of =
workqueues.")

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5gaiw5anvnre55n2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLqx5EACgkQrX5LkNig
010VYwf8CT/rSWhjeFgmdbbQt7DoVCZ8YkGWUSwHEcJX+j4cd2w1kBnpIeSLmOof
BxT4dt/Oj4YLbeNRZV3ftD1zRPQX9Z9PqOjDvwstYKgvCOreIayI+ZR95jOZLH38
FZ3moRFD2m2uCPl+N4pC8wPd1MgVQVgwjSKzIiIR5KVp0cWuv8StMTbfnTHV8rDH
+lROx4fwmYQk5iCSqWsMbtmfhEZtKmNXQpf3VGt95kLo51ManyG4A8ENIERT++vs
2ZkzfW7h5L0TRs48mbPBTyN0fZnr1MLFSGEQGETAF1W0LrHg2QVl4wIPUaebRjgS
mDXRac1avL8frKzPTMp/b2dVWFx09A==
=bst2
-----END PGP SIGNATURE-----

--5gaiw5anvnre55n2--
