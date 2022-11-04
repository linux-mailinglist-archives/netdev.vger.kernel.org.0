Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BA56195F1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiKDMLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiKDMLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:11:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9007B2CE3F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:11:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqvXJ-0000GJ-F2; Fri, 04 Nov 2022 13:11:01 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 518B9112E30;
        Fri,  4 Nov 2022 12:11:00 +0000 (UTC)
Date:   Fri, 4 Nov 2022 13:10:59 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] can: isotp: fix tx state handling for echo tx processing
Message-ID: <20221104121059.kbhrpwbumuc6q3iv@pengutronix.de>
References: <20221101212902.10702-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ez5os5lwkdehxyfw"
Content-Disposition: inline
In-Reply-To: <20221101212902.10702-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ez5os5lwkdehxyfw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.11.2022 22:29:02, Oliver Hartkopp wrote:
> In commit 4b7fe92c0690 ("can: isotp: add local echo tx processing for
> consecutive frames") the data flow for consecutive frames (CF) has been
> reworked to improve the reliability of long data transfers.
>=20
> This rework did not touch the transmission and the tx state changes of
> single frame (SF) transfers which likely led to the WARN in the
> isotp_tx_timer_handler() catching a wrong tx state. This patch makes use
> of the improved frame processing for SF frames and sets the ISOTP_SENDING
> state in isotp_sendmsg() within the cmpxchg() condition handling.
>=20
> A review of the state machine and the timer handling additionally revealed
> a missing echo timeout handling in the case of the burst mode in
> isotp_rcv_echo() and removes a potential timer configuration uncertainty
> in isotp_rcv_fc() when the receiver requests consecutive frames.
>=20
> Fixes: 4b7fe92c0690 ("can: isotp: add local echo tx processing for consec=
utive frames")
> Link: https://lore.kernel.org/linux-can/CAO4mrfe3dG7cMP1V5FLUkw7s+50c9vic=
higUMQwsxX4M=3D45QEw@mail.gmail.com/T/#u
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> Cc: stable@vger.kernel.org # v6.0
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

[...]

> @@ -905,10 +915,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(=
struct hrtimer *hrtimer)
>  		so->tx.state =3D ISOTP_IDLE;
>  		wake_up_interruptible(&so->wait);
>  		break;
> =20
>  	default:
> +		pr_notice_once("can-isotp: tx timer state %X\n", so->tx.state);
>  		WARN_ON_ONCE(1);

Can you use WARN_ONCE() instead of pr_notice_once() + WARN_ON_ONCE() here?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ez5os5lwkdehxyfw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNlAVAACgkQrX5LkNig
012E4Qf+L9/1ppXiOY0OZZiHyavf/wrgwC6CkuDWmTLlQucnNPE8Tn/uKUpvt6c3
1kKOkNDS5Vnm9EgxPjplBjZtE1Ya3SKII1gAEF02jJf0x+KADpzhU/pu5D5jUvmm
IGEdeQPR+pCvaxsMBpR4pG8k8ZFT/a+yeY7vn/hiETyuTbmLIWtvNI8mKu7zN+8A
xFww/B+Hx60GW5fAWIoV/RH8jfvAQhn+j/DFAmgGe1SkWVKZvZ/0BJ+TJhnFrVzn
+c8fzetn6xXSiyUpt3WF+jHMCUEM3Cp9hPuRK2cJ0K+prF6PrU23Oj88YR8oEQ1Y
JNXyRLimTPEVA6hTBF34qDXVYQ+G8w==
=Xiux
-----END PGP SIGNATURE-----

--ez5os5lwkdehxyfw--
