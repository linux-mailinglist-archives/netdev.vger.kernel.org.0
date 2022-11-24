Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABDE637BB3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKXOrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiKXOrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:47:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A590F1D91
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:47:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDUy-0003Ef-R8; Thu, 24 Nov 2022 15:46:44 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5954E128683;
        Thu, 24 Nov 2022 14:46:40 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:46:38 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Julia Lawall <julia@diku.dk>,
        Pavel Cheblakov <P.B.Cheblakov@inp.nsk.su>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: sja1000: plx_pci: fix error handling path in
 plx_pci_add_card()
Message-ID: <20221124144638.kqbmksqntn2dugal@pengutronix.de>
References: <1669029031-7743-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tmghqpq6vksktj2h"
Content-Disposition: inline
In-Reply-To: <1669029031-7743-1-git-send-email-zhangchangzhong@huawei.com>
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


--tmghqpq6vksktj2h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.11.2022 19:10:30, Zhang Changzhong wrote:
> If pci_iomap() or register_sja1000dev() fails, netdev will not be
> registered, but plx_pci_del_card() still deregisters the netdev.
>=20
> To avoid this, let's free the netdev and clear card->net_dev[i] before
> calling plx_pci_del_card(). In addition, add the missing pci_iounmap()
> when the channel does not exist.
>=20
> Compile tested only.
>=20
> Fixes: 951f2f960e5b ("drivers/net/can/sja1000/plx_pci.c: eliminate double=
 free")
> Fixes: 24c4a3b29255 ("can: add support for CAN interface cards based on t=
he PLX90xx PCI bridge")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/can/sja1000/plx_pci.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/=
plx_pci.c
> index 5de1ebb..1158f5a 100644
> --- a/drivers/net/can/sja1000/plx_pci.c
> +++ b/drivers/net/can/sja1000/plx_pci.c
> @@ -678,6 +678,8 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  		if (!addr) {
>  			err =3D -ENOMEM;
>  			dev_err(&pdev->dev, "Failed to remap BAR%d\n", cm->bar);
> +			free_sja1000dev(dev);
> +			card->net_dev[i] =3D NULL;
>  			goto failure_cleanup;
>  		}
> =20
> @@ -699,6 +701,9 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  			if (err) {
>  				dev_err(&pdev->dev, "Registering device failed "
>  					"(err=3D%d)\n", err);
> +				pci_iounmap(pdev, priv->reg_base);
> +				free_sja1000dev(dev);
> +				card->net_dev[i] =3D NULL;
>  				goto failure_cleanup;
>  			}
> =20
> @@ -710,6 +715,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  		} else {
>  			dev_err(&pdev->dev, "Channel #%d not detected\n",
>  				i + 1);
> +			pci_iounmap(pdev, priv->reg_base);
>  			free_sja1000dev(dev);
>  			card->net_dev[i] =3D NULL;

There's quite some cleanup code doubling. Can you introduce a goto style
cleanup?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tmghqpq6vksktj2h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/g8sACgkQrX5LkNig
012OdggAidool+qqDwTekBy/iCF1TC+g5wMOQarizPkFhwhIqvbp4sHYIFrxeH47
TCVRnRHc98EZMje55mobnc2SL/Y1PAv1BqYdIHSQU/Xr82ZlkCxnKrh1ZmsOCkTr
S3zAeFGxYBE1oOQkW3kFYBZeVbYSfUzpVSvlDZ3nRl+cd/9p3nq2OScbdaBsXOR1
M2F7lUKQ0LZ+6ysayU5PIndgIEaQkW0H8PyvM4N1U4XDEnV6oGhaiE1vUEq0/1tk
Du7/YmH8oMbH+kpGJx6k1fpae+piZ8VQnThZeoCAZl3PUYbz4ERFIK6f2UxCkUuy
JAdlf2L8kfjAcZZ5v7EA7X8wBmSVgA==
=K6MZ
-----END PGP SIGNATURE-----

--tmghqpq6vksktj2h--
