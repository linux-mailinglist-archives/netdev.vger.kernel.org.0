Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB61530D
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 19:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEFRss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 13:48:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51119 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFRss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 13:48:48 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 3E6AD80179; Mon,  6 May 2019 19:48:35 +0200 (CEST)
Date:   Mon, 6 May 2019 19:48:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     wen.yang99@zte.com.cn
Cc:     pavel@denx.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        anirudh@xilinx.com, John.Linn@xilinx.com, davem@davemloft.net,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sashal@kernel.org
Subject: Re: [PATCH 4.19 46/72] net: xilinx: fix possible object referenceleak
Message-ID: <20190506174846.GA13326@amd>
References: <20190503100816.GD5834@amd>
 <201905051417486865228@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <201905051417486865228@zte.com.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> > > [ Upstream commit fa3a419d2f674b431d38748cb58fb7da17ee8949 ]
> > >
> > > The call to of_parse_phandle returns a node pointer with refcount
> > > incremented thus it must be explicitly decremented after the last
> > > usage.
> > >
> > > Detected by coccinelle with the following warnings:
> > > ./drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1624:1-7: ERROR: =
missing of_node_put; acquired a node pointer with refcount incremented on l=
ine 1569, but without a corresponding object release within this function.
> >=20
> > Bug is real, but fix is horrible. This already uses gotos for error
> > handling, so use them....
> >=20
> > This fixes it up.
> >=20
> > Plus... I do not think these "of_node_put" fixes belong in
> > stable. They are theoretical bugs; so we hold reference to device tree
> > structure. a) it is small, b) it stays in memory, anyway. This does
> > not fix any real problem.
> >=20
>=20
> Thank you very much for your comments.
> We developed the following coccinelle SmPL to look for places where
> there is an of_node_put on some path but not on others.

I agree that the fix is good. Thanks for doing coccinelle work.

> We use it to detect drivers/net/ethernet/xilinx/xilinx_axienet_main.c and=
 found the following issue:
>=20
> static int axienet_probe(struct platform_device *pdev)
> {
> ...
>         struct device_node *np;
> ...
>         if (ret) {
>                 dev_err(&pdev->dev, "unable to get DMA resource\n");
>                 goto free_netdev;  ---> leaked here
>         }
> ...
>         if (IS_ERR(lp->dma_regs)) {
>                 dev_err(&pdev->dev, "could not map DMA regs\n");
>                 ret =3D PTR_ERR(lp->dma_regs);
>                 goto free_netdev; ---> leaked here
>         }
> ...
>          of_node_put(np);   --->    released here
> ...
> free_netdev:
>         free_netdev(ndev);
>=20
>         return ret;
> }
>=20
> If we insmod/rmmod xilinx_emaclite.ko multiple times,=20
> axienet_probe() may be called multiple times, then a resource leak
> may occur.

Yeah, well. I agree the bug is real. But how much memory will it leak
during each insmod? Kilobyte? (Is it actually anything at all? I'd
expect just reference counter to be increaed.) How often do you
usually insmod?

> At the same time, we also checked the code for handling resource leaks in=
 the current kernel
> and found that the regular of_node_put mode is commonly used in
> addition to the goto target mode.

Ok, so this uglyness happens elsewhere. But I'd really prefer to use
goto if it is already used in the function.

Thanks,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzQc34ACgkQMOfwapXb+vKjLQCfR30gJwbflpVIZMeXq9XtoP1X
bpMAn0gYdpIGkf2vx98ZqTyzLuMecomn
=Ekqr
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
