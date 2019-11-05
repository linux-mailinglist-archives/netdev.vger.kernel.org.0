Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32F9EF78C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfKEIxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:53:48 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:57387 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfKEIxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 03:53:48 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476k3W4vLmz9sNx;
        Tue,  5 Nov 2019 19:53:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572944025;
        bh=Byc9rQnfxiA5JnnLv+Dzgtshi/MUHIx44On/TB7/lGU=;
        h=Date:From:To:Cc:Subject:From;
        b=RJ7fkk+B2k36Rn88ome+EKeioWpuXpXoXGP/VZKDWVsFYBI0arBINM5anITqy4Cih
         pWOoC5CF48D59m8D+H0gF42doAFDbq30FDX+m8kHMMf0xZjsUn6dvdtO6afBfJfqFr
         BstWSMfU4nA8mT+b28ZNwxg4NmHKhZoi4Lx/0+6tx3R3yWgoXsJ+bbf3gAbTuMqbjj
         SSuKlJZSftcWkiB/FwVMXyihoq9f5hUeCDLTBtba+VP9MiPkO98LYFW/Wp1ie7ohlG
         GVNGkbM/ieWB+e0zBCFSfQfnohsmtLckhbXVj2xrL63odkRhJ4L98xMo8MgKCWUBBH
         KOKomtUXomgcA==
Date:   Tue, 5 Nov 2019 19:53:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20191105195341.666c4a3a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/arx3n.gxM6WsfhNW37scjjC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/arx3n.gxM6WsfhNW37scjjC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powepc
ppc44x_defconfig) failed like this:


Caused by commit

  0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warning=
s")

I applied the following patch, but there is probably a nicer and more
complete way to fix this.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Nov 2019 19:49:55 +1100
Subject: [PATCH] fix up for "net: of_get_phy_mode: Change API to solve int/=
unit warnings"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/ibm/emac/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ib=
m/emac/core.c
index 2e40425d8a34..8cb682754bd4 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2850,6 +2850,7 @@ static int emac_init_config(struct emac_instance *dev)
 	struct device_node *np =3D dev->ofdev->dev.of_node;
 	const void *p;
 	int err;
+	phy_interface_t phy_mode;
=20
 	/* Read config from device-tree */
 	if (emac_read_uint_prop(np, "mal-device", &dev->mal_ph, 1))
@@ -2898,9 +2899,11 @@ static int emac_init_config(struct emac_instance *de=
v)
 		dev->mal_burst_size =3D 256;
=20
 	/* PHY mode needs some decoding */
-	err =3D of_get_phy_mode(np, &dev->phy_mode);
+	err =3D of_get_phy_mode(np, &phy_mode);
 	if (err)
 		dev->phy_mode =3D PHY_INTERFACE_MODE_NA;
+	else
+		dev->phy_mode =3D phy_mode;
=20
 	/* Check EMAC version */
 	if (of_device_is_compatible(np, "ibm,emac4sync")) {
--=20
2.23.0

--=20
Cheers,
Stephen Rothwell

--Sig_/arx3n.gxM6WsfhNW37scjjC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3BOJUACgkQAVBC80lX
0GyfZwf9GxFOkkmcb9/xlaKblh/NNTDQMT28dfOWwerEFAh5jjTEuU47fEBuZk+3
WPo3BjPptw+ZPLGKCX2wdXoVFERlbRZvVA8Wy7iaVBXNB2TaalnAPkSi7yhnJ5BF
agyzMTQd1jTiWC7me4LqPH0IYmgJWcfCvPRa61VXIAdENgqxeRGh4NSm2IYTkw0V
Gch7CW0S6yu63A4lZjJHO37bgpWF3v2n5xfzvsghISD+mgARjP6VJHSBuYTrXhdZ
57/qZiQ/A4A6B1fte2/OZVTVepBhi+xq5tYat57Z1YJWQxCllzf0Ifo05Nd0k61o
lJsfExepi0/YHkX1E/5XeVR+LbgzWQ==
=hNXb
-----END PGP SIGNATURE-----

--Sig_/arx3n.gxM6WsfhNW37scjjC--
