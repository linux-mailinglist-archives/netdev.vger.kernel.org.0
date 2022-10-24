Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91F760BBD9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiJXVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJXVQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:16:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AADE2D20F6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:22:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1omzWE-0007KN-4k; Mon, 24 Oct 2022 17:37:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1bbf:91f6:fcf3:6f78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DEF08108A71;
        Mon, 24 Oct 2022 15:37:34 +0000 (UTC)
Date:   Mon, 24 Oct 2022 17:37:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Message-ID: <20221024153726.72avg6xbgzwyboms@pengutronix.de>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pp2dauigdnxmzpha"
Content-Disposition: inline
In-Reply-To: <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
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


--pp2dauigdnxmzpha
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.10.2022 09:15:01, Biju Das wrote:
> We are seeing IRQ storm on global receive IRQ line under heavy CAN
> bus load conditions with both CAN channels are enabled.
>=20
> Conditions:
>   The global receive IRQ line is shared between can0 and can1, either
>   of the channels can trigger interrupt while the other channel irq
>   line is disabled(rfie).
>   When global receive IRQ interrupt occurs, we mask the interrupt in
>   irqhandler. Clearing and unmasking of the interrupt is happening in
>   rx_poll(). There is a race condition where rx_poll unmask the
>   interrupt, but the next irq handler does not mask the irq due to
>   NAPIF_STATE_MISSED flag.

Why does this happen? Is it a problem that you call
rcar_canfd_handle_global_receive() for a channel that has the IRQs
actually disabled in hardware?

>   (for eg: can0 rx fifo interrupt enable is
>   disabled and can1 is triggering rx interrupt, the delay in rx_poll()
>   processing results in setting NAPIF_STATE_MISSED flag) leading to IRQ
>   storm.
>=20
> This patch fixes the issue by checking irq is masked or not in
> irq handler and it masks the interrupt if it is unmasked.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pp2dauigdnxmzpha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNWsTMACgkQrX5LkNig
012EJgf/TJuBlGVYoPZqvkLueDAZ6s8nJzeI8sB5zxTsvDBoWpHaFk+gHd2PO9ai
X4yfVczOEQfJBcT1yho2dWMoADFmAVWFTizWsblTTxYQd7cwhN/Y/itcXf6+rAqv
1ej8FTyWI0gyguG1/IaN6LHpCzkHpxhzZaV1kkMpWPuutYsLPCYGSt1NH7j0d0ih
GDcUVfprkzyNmUJb/SjYLsi23e5kLe+y7B+T6RZLc83+1tTZujjkn/tOkGjBGEQ2
aZd6QviFmC7I/BmOVcVDWs7IIi/nDDSqsJx+57DgrjCVaPRHuJDoQZ23102H6izP
HcXRZw9IKKbUqhIpqFNboYy8f32C7g==
=3yl4
-----END PGP SIGNATURE-----

--pp2dauigdnxmzpha--
