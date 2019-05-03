Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5290912B46
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfECKIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:08:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54085 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfECKIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:08:19 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id B2436802D6; Fri,  3 May 2019 12:08:06 +0200 (CEST)
Date:   Fri, 3 May 2019 12:08:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Yang <wen.yang99@zte.com.cn>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: Re: [PATCH 4.19 46/72] net: xilinx: fix possible object reference
 leak
Message-ID: <20190503100816.GD5834@amd>
References: <20190502143333.437607839@linuxfoundation.org>
 <20190502143337.107638265@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <20190502143337.107638265@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-05-02 17:21:08, Greg Kroah-Hartman wrote:
> [ Upstream commit fa3a419d2f674b431d38748cb58fb7da17ee8949 ]
>=20
> The call to of_parse_phandle returns a node pointer with refcount
> incremented thus it must be explicitly decremented after the last
> usage.
>=20
> Detected by coccinelle with the following warnings:
> ./drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1624:1-7: ERROR: miss=
ing of_node_put; acquired a node pointer with refcount incremented on line =
1569, but without a corresponding object release within this function.
>=20
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> Cc: Anirudha Sarangi <anirudh@xilinx.com>
> Cc: John Linn <John.Linn@xilinx.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>

Bug is real, but fix is horrible. This already uses gotos for error
handling, so use them....

This fixes it up.

Plus... I do not think these "of_node_put" fixes belong in
stable. They are theoretical bugs; so we hold reference to device tree
structure. a) it is small, b) it stays in memory, anyway. This does
not fix any real problem.

								Pavel


diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/ne=
t/ethernet/xilinx/xilinx_axienet_main.c
index 4041c75..490d440 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1575,15 +1575,13 @@ static int axienet_probe(struct platform_device *pd=
ev)
 	ret =3D of_address_to_resource(np, 0, &dmares);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to get DMA resource\n");
-		of_node_put(np);
-		goto free_netdev;
+		goto free_netdev_put;
 	}
 	lp->dma_regs =3D devm_ioremap_resource(&pdev->dev, &dmares);
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
 		ret =3D PTR_ERR(lp->dma_regs);
-		of_node_put(np);
-		goto free_netdev;
+		goto free_netdev_put;
 	}
 	lp->rx_irq =3D irq_of_parse_and_map(np, 1);
 	lp->tx_irq =3D irq_of_parse_and_map(np, 0);
@@ -1620,6 +1618,8 @@ static int axienet_probe(struct platform_device *pdev)
=20
 	return 0;
=20
+free_netdev_put:
+	of_node_put(np);
 free_netdev:
 	free_netdev(ndev);
=20


> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/=
net/ethernet/xilinx/xilinx_axienet_main.c
> index f24f48f33802..7cfd7ff38e86 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1574,12 +1574,14 @@ static int axienet_probe(struct platform_device *=
pdev)
>  	ret =3D of_address_to_resource(np, 0, &dmares);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to get DMA resource\n");
> +		of_node_put(np);
>  		goto free_netdev;
>  	}
>  	lp->dma_regs =3D devm_ioremap_resource(&pdev->dev, &dmares);
>  	if (IS_ERR(lp->dma_regs)) {
>  		dev_err(&pdev->dev, "could not map DMA regs\n");
>  		ret =3D PTR_ERR(lp->dma_regs);
> +		of_node_put(np);
>  		goto free_netdev;
>  	}
>  	lp->rx_irq =3D irq_of_parse_and_map(np, 1);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzMExAACgkQMOfwapXb+vIrQACfRGO7B7c76iqFSkLanh93OYhc
YB8AnjX80JqCdvKDKa6YoJRJg3pTE41w
=GJN0
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
