Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3343F7773
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKPOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfKKPOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:14:45 -0500
Received: from localhost.localdomain (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75399206A3;
        Mon, 11 Nov 2019 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573485285;
        bh=AXe786mBXmzC6AAt1V++vDFNc8sZfXq4LE5voRgw2Hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RlV33XrN8IapoWFB3W9gWjpatHW8dVe44wiyVSh0W3fBGV/sPWtYkZPT66Yluq9/u
         XM9zg5J2B0k0YM+jhv+KjZGc9PL/fNkgJt79J/OTLH7+f8Tz8EAKz+/hbl8SjhAEo2
         i3emYvdT6eQvb81Ewt9p1/1mMBUc1n0YsfXkCCXQ=
Date:   Mon, 11 Nov 2019 17:14:36 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111151436.GC4197@localhost.localdomain>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143352.GA2698@apalos.home>
 <20191111150553.GC1105@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <20191111150553.GC1105@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Nov 11, Andrew Lunn wrote:
> On Mon, Nov 11, 2019 at 04:33:52PM +0200, Ilias Apalodimas wrote:
> > Hi Andrew,
> >=20
> > On Mon, Nov 11, 2019 at 02:46:15PM +0100, Andrew Lunn wrote:
> > > Hi Lorenzo, Jesper, Ilias
> > >=20
> > > I just found that the XDP patches to mvneta have caused a regression.
> > >=20
> > > This one breaks networking:
> >=20
> > Thaks for the report.
> > Looking at the DTS i can see 'buffer-manager' in it. The changes we mad=
e were
> > for the driver path software buffer manager.=20
> > Can you confirm which one your hardware uses?
>=20
> Hi Ilias
>=20
> Ah, interesting.
>=20
> # CONFIG_MVNETA_BM_ENABLE is not set
>=20
> So in fact it is not being compiled in, so should be falling back to
> software buffer manager.
>=20
> If i do enable it, then it works. So we are in a corner cases you
> probably never tested. Requested by DT, but not actually available.
>=20
> 	 Andrew

Maybe I got the issue. If mvneta_bm_port_init fails (e.g. if
CONFIG_MVNETA_BM_ENABLE is not set) rx_offset_correction will be set to a w=
rong
value. To bisect the issue, could you please test the following patch?

Regards,
Lorenzo

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 591d580c68b4..e476fb043379 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4944,7 +4944,6 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
=20
 	pp->id =3D global_port_id++;
-	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
=20
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
@@ -4969,6 +4968,9 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 	of_node_put(bm_node);
=20
+	if (!pp->bm_priv)
+		pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
+
 	err =3D mvneta_init(&pdev->dev, pp);
 	if (err < 0)
 		goto err_netdev;


--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXcl62QAKCRA6cBh0uS2t
rIHYAP48saZGw4j52/DK+QYAlySZ2fgcCrsr5Uz071euC5aWHAD/bHMo3cJZ/50+
Uq0JONgtT6DH0b7mjdJjI23ZbOwJrQs=
=937P
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
