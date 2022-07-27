Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704965832C2
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiG0TEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiG0TD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:03:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9532A944
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:24:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGlhi-0007n7-7T; Wed, 27 Jul 2022 20:24:18 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3747CBC532;
        Wed, 27 Jul 2022 18:24:16 +0000 (UTC)
Date:   Wed, 27 Jul 2022 20:24:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j5a7w3uipafkmwfr"
Content-Disposition: inline
In-Reply-To: <20220727192839.707a3453.max@enpas.org>
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


--j5a7w3uipafkmwfr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2022 19:28:39, Max Staudt wrote:
> On Wed, 27 Jul 2022 13:30:54 +0200
> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>=20
> > As far as I understand, setting the btr is an alternative way to set the
> > bitrate, right? I don't like the idea of poking arbitrary values into a
> > hardware from user space.
>=20
> I agree with Marc here.
>=20
> This is a modification across the whole stack, specific to a single
> device, when there are ways around.
>=20
> If I understand correctly, the CAN232 "S" command sets one of the fixed
> bitrates, whereas "s" sets the two BTR registers. Now the question is,
> what do BTR0/BTR1 mean, and what are they? If they are merely a divider
> in a CAN controller's master clock, like in ELM327, then you could
>=20
>   a) Calculate the BTR values from the bitrate userspace requests, or

Most of the other CAN drivers write the BTR values into the register of
the hardware. How are these BTR values transported into the driver?

There are 2 ways:

1) - user space configures a bitrate
   - the kernel calculates with the "struct can_bittiming_const" [1] given
     by driver and the CAN clock rate the low level timing parameters.

     [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/c=
an/netlink.h#L47

2) - user space configures low level bit timing parameter
     (Sample point in one-tenth of a percent, Time quanta (TQ) in
      nanoseconds, Propagation segment in TQs, Phase buffer segment 1 in
      TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
      TQs)
    - the kernel calculates the Bit-rate prescaler from the given TQ and
      CAN clock rate

Both ways result in a fully calculated "struct can_bittiming" [2]. The
driver translates this into the hardware specific BTR values and writes
the into the registers.

If you know the CAN clock and the bit timing const parameters of the
slcan's BTR register you can make use of the automatic BTR calculation,
too. Maybe the framework needs some tweaking if the driver supports both
fixed CAN bit rate _and_ "struct can_bittiming_const".

[2] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/ne=
tlink.h#L31

>   b) pre-calculate a huge table of possible bitrates and present them
>      all to userspace. Sounds horrible, but that's what I did in can327,
>      haha. Maybe I should have reigned them in a little, to the most
>      useful values.

If your adapter only supports fixed values, then that's the only way to
go.

>   c) just limit the bitrates to whatever seems most useful (like the
>      "S" command's table), and let users complain if they really need
>      something else. In the meantime, they are still free to slcand or
>      minicom to their heart's content before attaching slcan, thanks to
>      your backwards compatibility efforts.

In the early stages of the non-mainline CAN framework we had tables for
BTR values for some fixed bit rates, but that turned out to be not
scaleable.

> In short, to me, this isn't a deal breaker for your patch series.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--j5a7w3uipafkmwfr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLhgssACgkQrX5LkNig
01016gf/ZRRMvoB/gGzSsmrEKOpsdLDEh6uPZxPh0LTnGQ2KyUa2HzyKWSgP9xsk
BXu1c2T4jSf2KLDvFUnVSKd+bXIPQ4cMEF7BXE8neYoXuTht9bPKvKOh37SXl8DN
Hi29mngtdk3SXgSUBBNvE91LfJoMZdGoSty2CXZkr5fm/RCDkHW2jCCb7JntBCso
7NGfFbSUG0T2tbhfmVZI32OwOTlxFhNNtWutFd7kHjvs0v4FpgW811mT+pAyGSLX
8LldzpDCvlp2MYkNLLlu+uiaTxNQmOpI2UYSCioNkGkIpGyeGw3S489Y5NCGjPGz
7A+0/8hiKSYxaUHeE+qcEjiAnEWgYQ==
=Ric7
-----END PGP SIGNATURE-----

--j5a7w3uipafkmwfr--
