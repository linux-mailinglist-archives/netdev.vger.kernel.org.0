Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7CA60F1D7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiJ0IGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbiJ0IGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:06:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE3816A4CE
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:06:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onxuM-0005F1-7m; Thu, 27 Oct 2022 10:06:34 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7973B10AF68;
        Thu, 27 Oct 2022 08:06:30 +0000 (UTC)
Date:   Thu, 27 Oct 2022 10:06:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net
Subject: Re: [PATCH] can: j1939: transport: replace kfree_skb() with
 dev_kfree_skb_irq()
Message-ID: <20221027080629.mn6hhdg56d4achwl@pengutronix.de>
References: <20221026125354.911575-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="devnwdik7riyhej2"
Content-Disposition: inline
In-Reply-To: <20221026125354.911575-1-yangyingliang@huawei.com>
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


--devnwdik7riyhej2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2022 20:53:54, Yang Yingliang wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So replace kfree_skb()
> with dev_kfree_skb_irq() under spin_lock_irqsave().
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/can/j1939/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index d7d86c944d76..b95fb759c49d 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -343,7 +343,7 @@ static void j1939_session_skb_drop_old(struct j1939_s=
ession *session)
>  		/* drop ref taken in j1939_session_skb_queue() */
>  		skb_unref(do_skb);
> =20
> -		kfree_skb(do_skb);
> +		dev_kfree_skb_irq(do_skb);

Can you call spin_unlock_irqrestore() before the kfree_skb()? Does that
fix the problem?

>  	}
>  	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
>  }

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--devnwdik7riyhej2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNaPAIACgkQrX5LkNig
0138/Af/eVgLesJa2+ifRizhBglTbRcfkmKIYspFxN1K4GpG6klk4ZTCnVZ+M36N
cODS9Z0nRQrVE+mjiO0FEPYOG2K9FED9+zopswmYvwyyuqmhL9Y0m9zWptKDCeJ+
tlfOLvGiGci1SJ0rTQJqJG/9ByHCjYx8AaqymkQrOunCu4uZe87QDcwc7Oxjp2hn
nKdmWDH3j4MAlxo7hWyYQIzet4NfvxUDq/792PlV3h+EOFcEEDdwFzmhE0uZ8yPN
Ikv4OzoT4fdPwKHOE14H3z2Ae68RvaVj2lXuabU7/bxsTMxwbjszBKVCc1747F4I
TgxRO0jn1Nfu+nF3TsrhOutfwjOZ+w==
=XtAk
-----END PGP SIGNATURE-----

--devnwdik7riyhej2--
