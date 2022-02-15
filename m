Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8C4B60CE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiBOCJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:09:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiBOCJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:09:14 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E5FB0EB1
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 18:09:05 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JyPf345gTz4xmx;
        Tue, 15 Feb 2022 13:08:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644890941;
        bh=jNVBosbQbGGAchN+rgYcERAl9WqcOR3uLr69A+zy5Vw=;
        h=Date:From:To:Cc:Subject:From;
        b=LKfag+YMqlOwzH6TUmJnMzGQokV8tnqYLKfdQ/vhj85yeTJ8+IZOEwnIvtZWBDS+O
         1ph+5DR1zdvoS59EOnWjyd35+cDC505I4kaT0snsvJDeNNneTAiPUbvRhT438rX8rM
         MRIvtr2LmVeUC1dNF2iLOzfFDtIB2nnf9kXX8QmNzQe4cCY750xWZUcPQoWDqLLe1R
         PI0/UeomabEDBjuGdlBi0/sn8CqOmYFpzPPtquV5MDuK9Os46krUIKZ6aOCdRLzgXr
         oJHCs3NUU9xAm1DpZ8arAeuMprWgm9jDcmztjJMG5avr7OdelDcdVLkPkPWHEU33lz
         y/TFSmgOVi1xQ==
Date:   Tue, 15 Feb 2022 13:08:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Mark Brown <broonie@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Joseph CHAMG <josright123@gmail.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the spi tree
Message-ID: <20220215130858.2b821de7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gDr2hkWEpFU5xfCtpNz2eX1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gDr2hkWEpFU5xfCtpNz2eX1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/ethernet/davicom/dm9051.c:1253:19: error: initialization of 'vo=
id (*)(struct spi_device *)' from incompatible pointer type 'int (*)(struct=
 spi_device *)' [-Werror=3Dincompatible-pointer-types]
 1253 |         .remove =3D dm9051_drv_remove,
      |                   ^~~~~~~~~~~~~~~~~
drivers/net/ethernet/davicom/dm9051.c:1253:19: note: (near initialization f=
or 'dm9051_driver.remove')

Caused by commit

  a0386bba7093 ("spi: make remove callback a void function")

interacting with commit

  2dc95a4d30ed ("net: Add dm9051 driver")

from the net-next tree.

I applied the following merge resolution and can carry it until the
trees are merged.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Feb 2022 13:05:41 +1100
Subject: [PATCH] fix up for "pi: make remove callback a void function"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/d=
avicom/dm9051.c
index cee3ff499fd4..d2513c97f83e 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -1223,15 +1223,13 @@ static int dm9051_probe(struct spi_device *spi)
 	return 0;
 }
=20
-static int dm9051_drv_remove(struct spi_device *spi)
+static void dm9051_drv_remove(struct spi_device *spi)
 {
 	struct device *dev =3D &spi->dev;
 	struct net_device *ndev =3D dev_get_drvdata(dev);
 	struct board_info *db =3D to_dm9051_board(ndev);
=20
 	phy_disconnect(db->phydev);
-
-	return 0;
 }
=20
 static const struct of_device_id dm9051_match_table[] =3D {
--=20
2.34.1

--=20
Cheers,
Stephen Rothwell

--Sig_/gDr2hkWEpFU5xfCtpNz2eX1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmILCzoACgkQAVBC80lX
0Gw2+wf/RruQmrxu7OQjwDYcKbHPKocQg3GRROdxtfSyFo8zE7F7+FeQKocnF+HX
TQt3yWTX/3DGQ2cLHE7l3UE9S+tG4dqpcPIf/Fs+RegEVXdmWUGX9L0++3w1Hw0C
DD18gXGI4+mQ2cnliD1735iymQpKY/Y3lREaKeRvbm/CoGD2SQZR5pTNkxCc2Rf2
Y1lAQbKKhNdSon/mUA7CW0mymNEt/4uRVd3/2ZEDDY1G6I7ifgxOtVUGM4sLXbsP
6F9eB1gIUDfpqUK/Hjz1mGJLx14ACpVdI8tU6Wg8biTJwMBhhcSRkeWCdcE/FkHz
Cz3C0iUFG0RAD1yyO0D76U/7UnknGg==
=F5YH
-----END PGP SIGNATURE-----

--Sig_/gDr2hkWEpFU5xfCtpNz2eX1--
