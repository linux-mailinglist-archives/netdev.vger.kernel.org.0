Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D85983C9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiHRNIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiHRNIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:08:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068AB357EE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:08:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oOfG1-0000TO-Va; Thu, 18 Aug 2022 15:08:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AD3B1CD860;
        Thu, 18 Aug 2022 13:08:14 +0000 (UTC)
Date:   Thu, 18 Aug 2022 15:08:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com, Dario Binacchi <dariobin@libero.it>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] can: bxcan: add support for ST bxCAN controller
Message-ID: <20220818130814.z7b4rvmld6wvk4fg@pengutronix.de>
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
 <20220817143529.257908-5-dario.binacchi@amarulasolutions.com>
 <20220818103031.m7bl6gbzcc76etig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dtkjkszqd6mas3zd"
Content-Disposition: inline
In-Reply-To: <20220818103031.m7bl6gbzcc76etig@pengutronix.de>
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


--dtkjkszqd6mas3zd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2022 12:30:31, Marc Kleine-Budde wrote:
> One step at a time, let's look at the TX path:
>=20
> On 17.08.2022 16:35:29, Dario Binacchi wrote:
> > +static netdev_tx_t bxcan_start_xmit(struct sk_buff *skb,
> > +				    struct net_device *ndev)
> > +{
> > +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> > +	struct can_frame *cf =3D (struct can_frame *)skb->data;
> > +	struct bxcan_regs *regs =3D priv->regs;
> > +	struct bxcan_mb *mb_regs;
>=20
> __iomem?
>=20
> > +	unsigned int mb_id;
> > +	u32 id, tsr;
> > +	int i, j;
> > +
> > +	if (can_dropped_invalid_skb(ndev, skb))
> > +		return NETDEV_TX_OK;
> > +
> > +	tsr =3D readl(&regs->tsr);
> > +	mb_id =3D ffs((tsr & BXCAN_TSR_TME) >> BXCAN_TSR_TME_SHIFT);
>=20
> We want to send the CAN frames in the exact order they are pushed into
> the driver, so don't pick the first free mailbox you find. How a
                                                                 are
> priorities for the TX mailboxes handled?
>=20
> Is the mailbox with the lowest number send first? Is there a priority
> field in the mailbox?

I just had a look into the data sheet and it says that the TX mailboxes
are handled in transmit request order. This is good.

[...]

> The mcp251xfd has a proper hardware FIFO ring buffer for TX, the bxcan
> probably doesn't. The get_tx_free() check is a bit different. Look at
> c_can_get_tx_free() in:

This means you can use the simpler get_tx_free from the mcp251xfd driver.
>=20
> | https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D28e86e9ab522e65b08545e5008d0f1ac5b19dad1
>=20
> This patch is a good example for the relevant changes.

This patch is non the less a good example for the TX path.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dtkjkszqd6mas3zd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL+OboACgkQrX5LkNig
0111dwgAsKHBnsZaWy6rH4/lkSd7m7BsivcwGcyfFO0SqgkUt/hKtV9luwypGM5y
0EpYLPJJDxJyZHtcv9Xc65ceMWYAu/KrodPF9gYvHdPusZLer42UZX7OSCZjRKg/
rg5QNEmMSFGsaXuOV13F2vkdUgCHqO+RMQzA1QkrCWXfGBfP8KEOBEyGkWRBWV3B
EOiXp+XK1KLoHTD7cCCh0usmj+OqTc98mntbSq92UUB6UQph0PecyrNYU07PIvAW
bZ9zoUdVC/0aAEGLHWY3pUXj7/nj8GxUiLCQiPH+Vvv+xYT2pe1kHpMWL7qp03WH
NIfB5M8Vu2g7sAF39XW6q0VdHXTu0g==
=JlUx
-----END PGP SIGNATURE-----

--dtkjkszqd6mas3zd--
