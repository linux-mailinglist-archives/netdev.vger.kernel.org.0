Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9908638BEB
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKYOOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKYOOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:14:02 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DEB209AB
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:14:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyZSY-0001ux-7X; Fri, 25 Nov 2022 15:13:42 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:339c:bb17:19c8:3a96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1EFA5129BF0;
        Fri, 25 Nov 2022 14:13:36 +0000 (UTC)
Date:   Fri, 25 Nov 2022 15:13:34 +0100
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
Subject: Re: [PATCH v2] can: sja1000: plx_pci: fix error handling path in
 plx_pci_add_card()
Message-ID: <20221125141334.yhnye7psko3pih5u@pengutronix.de>
References: <1669383975-17332-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mcxjcl67uddrktzz"
Content-Disposition: inline
In-Reply-To: <1669383975-17332-1-git-send-email-zhangchangzhong@huawei.com>
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


--mcxjcl67uddrktzz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.11.2022 21:46:14, Zhang Changzhong wrote:
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
> v1->v2: switch to goto style fix.
>=20
>  drivers/net/can/sja1000/plx_pci.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/=
plx_pci.c
> index 5de1ebb..134a8cb 100644
> --- a/drivers/net/can/sja1000/plx_pci.c
> +++ b/drivers/net/can/sja1000/plx_pci.c
> @@ -678,7 +678,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  		if (!addr) {
>  			err =3D -ENOMEM;
>  			dev_err(&pdev->dev, "Failed to remap BAR%d\n", cm->bar);
> -			goto failure_cleanup;
> +			goto failure_free_dev;
>  		}
> =20
>  		priv->reg_base =3D addr + cm->offset;
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> @@ -699,7 +699,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  			if (err) {
>  				dev_err(&pdev->dev, "Registering device failed "
>  					"(err=3D%d)\n", err);
> -				goto failure_cleanup;
> +				goto failure_iounmap;
>  			}
> =20
>  			card->channels++;
> @@ -710,6 +710,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  		} else {
>  			dev_err(&pdev->dev, "Channel #%d not detected\n",
>  				i + 1);
> +			pci_iounmap(pdev, priv->reg_base);
>  			free_sja1000dev(dev);
>  			card->net_dev[i] =3D NULL;
>  		}
> @@ -738,6 +739,11 @@ static int plx_pci_add_card(struct pci_dev *pdev,
>  	}
>  	return 0;
> =20
> +failure_iounmap:
> +	pci_iounmap(pdev, priv->reg_base);
                          ^^^^^^^^^^^^^^

reg_base it not that what has been mapped, but with an offset.

> +failure_free_dev:
> +	free_sja1000dev(dev);
> +	card->net_dev[i] =3D NULL;
>  failure_cleanup:
>  	dev_err(&pdev->dev, "Error: %d. Cleaning Up.\n", err);

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mcxjcl67uddrktzz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOAzYsACgkQrX5LkNig
013gVAf/eoxKhqdlLtB4JTg3JaizhFwwl41YUevHC7Dlat2okHGtUnykIt2vCHeF
EUAWo/MrsatxXMz7R/jtJvx5Qv+EzgI+uiqrjglnY1t/Ed0A2jG2iIR79prAicrq
/XBXa7pVa0fXABPh3JfFpRIpesAabSVodfqSzmCUCY4m6sERDo7IyrbCzr1ofobX
mNfquHUsph6/YtaGBThFngmW+7ocaCjqRJ8iqdZW5oH3ATzMX+7+8qbGJAdioFS4
PmxLkscOhMUZo3zGy8b8OiFEzGdDLqca1jCoXZjoui2/J6jQdfZK6fLkGIfFGff5
r1BWMocts1AFlB1KbK4p9kteDvnriw==
=K+FC
-----END PGP SIGNATURE-----

--mcxjcl67uddrktzz--
