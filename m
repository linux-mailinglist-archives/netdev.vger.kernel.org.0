Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87833F924D
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbhH0CXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 22:23:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36781 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231613AbhH0CXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 22:23:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gwk5V1JX3z9sPf;
        Fri, 27 Aug 2021 12:22:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630030974;
        bh=5OKZbg1/z7zbffHv9CDZilC29dWz0b3Vl0KH7ueFMi4=;
        h=Date:From:To:Cc:Subject:From;
        b=pTKMbFJ4Af62VbdkHiwrTvTh9SRTTbg9+Q1hmnVurSUUq9ce9ZfeN4XsB5hCbVHJl
         J+x4947BxyEJ7PFtgumvcsLSW0IxjDJmeXDuzqT4KGOqxQY8svIWJ1kAbOkfULyCXR
         evWDNbUUgRBOblU/pmCs83lWTLD22OEhja1akd9hbKuat7GQSNIUa9VlC+D93cVDEb
         5ysALepnsfLbNRZA/dbfkaCmIV6CmM/de+wotD0t2GzrS4SAY68pHXN6GlVH7+SGvm
         ky67y/KT0VTDG8+oamN1sx4U0O5mJQCXMAYyC4GovgPHnaH6Oe2fZ97pJs8ls1nNIW
         mpTFeExxNb5oQ==
Date:   Fri, 27 Aug 2021 12:22:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210827122252.3d310dca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EQLn5xMvkGnCKxYXAb2gN3x";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EQLn5xMvkGnCKxYXAb2gN3x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wwan/mhi_wwan_mbim.c: In function 'mhi_mbim_probe':
drivers/net/wwan/mhi_wwan_mbim.c:612:8: error: too many arguments to functi=
on 'mhi_prepare_for_transfer'
  612 |  err =3D mhi_prepare_for_transfer(mhi_dev, 0);
      |        ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/wwan/mhi_wwan_mbim.c:18:
include/linux/mhi.h:725:5: note: declared here
  725 | int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~

Caused by commits

  aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
  ab996c420508 ("wwan: mhi: Fix build.")
  a85b99ab6abb ("Revert "wwan: mhi: Fix build."")
  0ca8d3ca4561 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev=
/net")

interacting with commit

  9ebc2758d0bb ("Revert "net: really fix the build..."")

from Linus' tree.

I have applied the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Aug 2021 12:02:29 +1000
Subject: [PATCH] fix for commit 9ebc2758d0bb "Revert "net: really fix the b=
uild...""

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_m=
bim.c
index 377529bbf124..71bf9b4f769f 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -609,7 +609,7 @@ static int mhi_mbim_probe(struct mhi_device *mhi_dev, c=
onst struct mhi_device_id
 	INIT_DELAYED_WORK(&mbim->rx_refill, mhi_net_rx_refill_work);
=20
 	/* Start MHI channels */
-	err =3D mhi_prepare_for_transfer(mhi_dev, 0);
+	err =3D mhi_prepare_for_transfer(mhi_dev);
 	if (err)
 		return err;
=20
--=20
2.32.0

--=20
Cheers,
Stephen Rothwell

--Sig_/EQLn5xMvkGnCKxYXAb2gN3x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEoTHwACgkQAVBC80lX
0Gx5bQf/cKqHRFJmPeU3iAS7ttQmIIWKeTCihN35XPyBlZuJmK04BLTgfbISNIFF
PeH2dTzqyi1olhsWCCJDB5QguuD1pzyA9O1FYlGofZGso6iU3EcpgEosJKXxU92J
dI6SuOLYciOzbli4tdpZSzmhF+AEW5oy6wz/300WF3MeSq6GLxHmryI3X4ro2kzv
Y7A7XNstTHi1erolZPKYqZ7uz5BWhn8H1xdoXJtaVaRLeOkLazfKzD/8Qu7fJRga
Ng4XPLrkXwNGHBdyfPMC5KLvfYddllL7g3tOBa6JsDWYhWCDSV9Ze8Esb9eYgV8P
3vHiIrSHcuqFT9O46GnWMJu/v0deYw==
=DxBy
-----END PGP SIGNATURE-----

--Sig_/EQLn5xMvkGnCKxYXAb2gN3x--
