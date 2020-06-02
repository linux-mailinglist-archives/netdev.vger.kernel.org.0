Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25161EB3DE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 05:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgFBDoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 23:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFBDoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 23:44:06 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40208C061A0E;
        Mon,  1 Jun 2020 20:44:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bdFG5hnFz9sSd;
        Tue,  2 Jun 2020 13:44:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591069444;
        bh=IkHBSWOk4xtC0dkcZ7o1RZslpqdZBMj0Kw2jYCO1qUY=;
        h=Date:From:To:Cc:Subject:From;
        b=jV4XNwn4hXf7JpW1qLzUOSoj5vr2KfFwGy6Oe3cyz1LJC6NTZ/yR7fbZ/pWZCZQ+7
         bOCV56ih0dnjkkZt2dueTgHHocPa4k/KrC9ifuWJiHOOJekWuLkNaMcuJDi03RC7Ej
         t1GU+1T+xmcCxlxRs24N5maYbIRjpBwKvIbcpLZxnPnmNoL177JwaJMYIhJL0kBx0z
         inaF9GtdQm7SrWp54bH0HTJddnheXB9emXcljRbje2zC2MBx8dG/58oxGbNXtRi5Tv
         jaZwaQs9K8EIO2MVLuwSNSjIszHOcfyFhkdnQQSupyZgrcvJ9ka3xCs6/a2eTP/1nX
         hv6zLwGpTpEkg==
Date:   Tue, 2 Jun 2020 13:44:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: linux-next: build failure after merge of the mmc tree
Message-ID: <20200602134402.24c19488@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6oBASpyjlxKneHsRjZJ2Yie";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6oBASpyjlxKneHsRjZJ2Yie
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the mmc tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c: In function 'brc=
mf_sdiod_probe':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:915:7: error: 'SD=
IO_DEVICE_ID_CYPRESS_4373' undeclared (first use in this function); did you=
 mean 'SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373'?
  915 |  case SDIO_DEVICE_ID_CYPRESS_4373:
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |       SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373
drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:915:7: note: each=
 undeclared identifier is reported only once for each function it appears in

Caused by commit

  1eb911258805 ("mmc: sdio: Fix Cypress SDIO IDs macros in common include f=
ile")

interacting with commit

  2a7621ded321 ("brcmfmac: set F2 blocksize for 4373")

from the net-next tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Jun 2020 13:41:04 +1000
Subject: [PATCH] mmc: sdio: merge fix for "brcmfmac: set F2 blocksize for
 4373"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index e718bd466830..46346cb3bc84 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -912,7 +912,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdi=
odev)
 		goto out;
 	}
 	switch (sdiodev->func2->device) {
-	case SDIO_DEVICE_ID_CYPRESS_4373:
+	case SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373:
 		f2_blksz =3D SDIO_4373_FUNC2_BLOCKSIZE;
 		break;
 	case SDIO_DEVICE_ID_BROADCOM_4359:
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/6oBASpyjlxKneHsRjZJ2Yie
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7VywIACgkQAVBC80lX
0Gx1jQf4h3jixfTBJdfoXrWTH62gOFe/BoWtLIWdHCyfMtA7Sf1zbF17/OLvqYVF
h4bLdXofoSq3oo73r0hX+9H8yTHS/2pv+AtdRsVfEHIA83y90c9LV/5pcwBvKK2P
pSlogXUr3ci6q6a03PmbPxTalftLoJJsImp+FRIKJWaYS1nBTVfHx0Ncv6T80Fk9
mMICIPOt7HFMQ+quaQcSul0u/fAh3RF5VQ2hbMO/BRddnOh3dUv9b/sU7bhut+ki
Pxh0KGjw4Zsfct1VvyOiZtfM2kOTD0cBA8bQXZzNxMIQovKB650m2X9viVu0r26A
otvqF2cwQf/H4whVvSZe5f+7tV0+
=C2bh
-----END PGP SIGNATURE-----

--Sig_/6oBASpyjlxKneHsRjZJ2Yie--
