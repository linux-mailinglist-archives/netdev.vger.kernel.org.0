Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166760B60D
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiJXSrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiJXSqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:46:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E3107AA3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:28:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1omzlx-000262-5m; Mon, 24 Oct 2022 17:53:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1bbf:91f6:fcf3:6f78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5B06C108AC7;
        Mon, 24 Oct 2022 15:53:51 +0000 (UTC)
Date:   Mon, 24 Oct 2022 17:53:42 +0200
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
Message-ID: <20221024155342.bz2opygr62253646@pengutronix.de>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kozunwnd76j34c2h"
Content-Disposition: inline
In-Reply-To: <20221024153726.72avg6xbgzwyboms@pengutronix.de>
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


--kozunwnd76j34c2h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.10.2022 17:37:35, Marc Kleine-Budde wrote:
> On 22.10.2022 09:15:01, Biju Das wrote:
> > We are seeing IRQ storm on global receive IRQ line under heavy CAN
> > bus load conditions with both CAN channels are enabled.
> >=20
> > Conditions:
> >   The global receive IRQ line is shared between can0 and can1, either
> >   of the channels can trigger interrupt while the other channel irq
> >   line is disabled(rfie).
> >   When global receive IRQ interrupt occurs, we mask the interrupt in
> >   irqhandler. Clearing and unmasking of the interrupt is happening in
> >   rx_poll(). There is a race condition where rx_poll unmask the
> >   interrupt, but the next irq handler does not mask the irq due to
> >   NAPIF_STATE_MISSED flag.
>=20
> Why does this happen? Is it a problem that you call
> rcar_canfd_handle_global_receive() for a channel that has the IRQs
> actually disabled in hardware?

Can you check if the IRQ is active _and_ enabled before handling the IRQ
on a particular channel?

A more clearer approach would be to get rid of the global interrupt
handlers at all. If the hardware only given 1 IRQ line for more than 1
channel, the driver would register an IRQ handler for each channel (with
the shared attribute). The IRQ handler must check, if the IRQ is pending
and enabled. If not return IRQ_NONE, otherwise handle and return IRQ_HANDLE=
D.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kozunwnd76j34c2h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNWtQQACgkQrX5LkNig
011q8Qf+K1pnzvd+OD7MhsWgBJMyKv41coaIMpa8lD2tm2nc4tXo50F0dImc6OG1
52vodwFbY1xOFvuG5EJi9vRG8xX9b8nKchaBolckcifvV0mjs2w9hS3R4I8OvxCC
mawXx9fMs5I/4LXLZ3uiogdpMhR33A3wIsVHYEJeKhGBpDi3F5N38nDPTsWv7PdO
r1BCMomBaXI68G0E5mr2kP6uxK/RMxs8WpLjPL9FVL62yCWdtgGyVxCAKVJtp9wa
2c7VSF93qXJsOGfpgnJpjr0nWpn7617bNSju7heQk5fiAh54Nvg4l+b5wwOqZG12
ShLbqfxFDYUawsKadnHr24Zc/OcS5g==
=cuLt
-----END PGP SIGNATURE-----

--kozunwnd76j34c2h--
