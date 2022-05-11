Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560A95235AB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244758AbiEKOga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbiEKOg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:36:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2BD403C1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:36:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nonRu-0002Lv-Bs; Wed, 11 May 2022 16:36:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D8B317BDD4;
        Wed, 11 May 2022 14:36:20 +0000 (UTC)
Date:   Wed, 11 May 2022 16:36:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ljoxgzahuknnbyf5"
Content-Disposition: inline
In-Reply-To: <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
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


--ljoxgzahuknnbyf5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
> On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
> > IMO this patch does not work as intended.
> >=20
> > You probably need to revisit every place where can_skb_reserve() is use=
d,
> > e.g. in raw_sendmsg().
>=20
> And the loopback for devices that don't support IFF_ECHO:
>=20
> | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257

BTW: There is a bug with interfaces that don't support IFF_ECHO.

Assume an invalid CAN frame is passed to can_send() on an interface that
doesn't support IFF_ECHO. The above mentioned code does happily generate
an echo frame and it's send, even if the driver drops it, due to
can_dropped_invalid_skb(dev, skb).

The echoed back CAN frame is treated in raw_rcv() as if the headroom is val=
id:

| https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138

But as far as I can see the can_skb_headroom_valid() check never has
been done. What about this patch?

index 1fb49d51b25d..fda4807ad165 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
                 */
=20
                if (!(skb->dev->flags & IFF_ECHO)) {
+                       if (can_dropped_invalid_skb(dev, skb))
+                               return -EINVAL;
+
                        /* If the interface is not capable to do loopback
                         * itself, we do it here.
                         */

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ljoxgzahuknnbyf5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7yeEACgkQrX5LkNig
013sQgf9GZiV+J8h1BBY78BuX+q12pFS6uA1Ocl8Xx+dHF//nkU2y9FuYXbn8+fi
fBFXw7jdhwMMfjSQPLHCbTXbLdrwEONAkQ1QQ6Db5M450W/8wisOgf+JqjDNM3iU
tvZ1x3l3U/xFkFTdCm2A3IE/UMG7kaxeb/5v3Fk283gZNZ6FBhymRrxxofTfUtRJ
G9Mn3Bhge8BFZ84kJZcYqhbAspY4MWoDKRDSysEjt0hxq37TxJw4M0JL4cPVH6s/
8/HjzP5MZBh4Ep+dp4g5Y/KjEoLTLvbCtVHXcnJaLYJwW0vDvAKMG6dA8dQnc8fl
9gmOJe5ZtenWSw87iMOsTEekkDFy2A==
=sDfU
-----END PGP SIGNATURE-----

--ljoxgzahuknnbyf5--
