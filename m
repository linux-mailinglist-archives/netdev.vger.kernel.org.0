Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBF327A9C6
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgI1Img (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:42:36 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49243 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1Img (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:42:36 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C0GHF5fTzz9sSn;
        Mon, 28 Sep 2020 18:42:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601282554;
        bh=oI89Ok1pseC6DVJOwSzBhIBoDATWkXUIOB5Dgi05l6E=;
        h=Date:From:To:Cc:Subject:From;
        b=TPWRamYioOmIiF2O7SuBLVjQ/uj1oOwAD0vtRXE5lU6yYuCMrwgLEp5/rcSC2HpMQ
         TS4k6Mucm4mNdQLuOE1+OY8mIvzBL7Nxy3V3nWO5A6EOCPo5UneRc0iiHqgnOa9yrp
         rJ/5MC65agUws46+DMAL+nIxVFjvDH+MIYwgBFgsB2NHZ2NlH7gAUOMSLP/4nX0CON
         Yu9KX49u9ALq7Hgnk1pHLeMKKzHgegBeHlaJwY72i/aDWdKVH5loOZ2t1Qp8/Y3y6O
         6VNB6ObSHIZh2CZur0DkNBms+3s4XDnv5Nrn6kCad1+OtpcSf2b/C4dY8sm13Pnb/h
         vV/AdlPrgeXwQ==
Date:   Mon, 28 Sep 2020 18:42:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Govind Singh <govinds@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the mhi tree
Message-ID: <20200928184230.2d973291@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i6Wf7hQDPy.T5c6zB_97gG0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/i6Wf7hQDPy.T5c6zB_97gG0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the mhi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/wireless/ath/ath11k/mhi.c:27:4: error: 'struct mhi_channel_conf=
ig' has no member named 'auto_start'
   27 |   .auto_start =3D false,
      |    ^~~~~~~~~~
drivers/net/wireless/ath/ath11k/mhi.c:42:4: error: 'struct mhi_channel_conf=
ig' has no member named 'auto_start'
   42 |   .auto_start =3D false,
      |    ^~~~~~~~~~
drivers/net/wireless/ath/ath11k/mhi.c:57:4: error: 'struct mhi_channel_conf=
ig' has no member named 'auto_start'
   57 |   .auto_start =3D true,
      |    ^~~~~~~~~~
drivers/net/wireless/ath/ath11k/mhi.c:72:4: error: 'struct mhi_channel_conf=
ig' has no member named 'auto_start'
   72 |   .auto_start =3D true,
      |    ^~~~~~~~~~

Caused by commit

  ed39d7816885 ("bus: mhi: Remove auto-start option")

interacting with commit

  1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")

from the net-next tree.

I applied the following merge fix patch, but maybe more is required.
Even if so, this could be fixed now in the net-next tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 28 Sep 2020 18:39:41 +1000
Subject: [PATCH] fix up for "ath11k: register MHI controller device for QCA=
6390"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/a=
th/ath11k/mhi.c
index aded9a719d51..47a1ce1bee4f 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -24,7 +24,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] =
=3D {
 		.offload_channel =3D false,
 		.doorbell_mode_switch =3D false,
 		.auto_queue =3D false,
-		.auto_start =3D false,
 	},
 	{
 		.num =3D 1,
@@ -39,7 +38,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] =
=3D {
 		.offload_channel =3D false,
 		.doorbell_mode_switch =3D false,
 		.auto_queue =3D false,
-		.auto_start =3D false,
 	},
 	{
 		.num =3D 20,
@@ -54,7 +52,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] =
=3D {
 		.offload_channel =3D false,
 		.doorbell_mode_switch =3D false,
 		.auto_queue =3D false,
-		.auto_start =3D true,
 	},
 	{
 		.num =3D 21,
@@ -69,7 +66,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] =
=3D {
 		.offload_channel =3D false,
 		.doorbell_mode_switch =3D false,
 		.auto_queue =3D true,
-		.auto_start =3D true,
 	},
 };
=20
--=20
2.28.0

--=20
Cheers,
Stephen Rothwell

--Sig_/i6Wf7hQDPy.T5c6zB_97gG0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9xofYACgkQAVBC80lX
0GwTHAf/SY2NVQB4kwhkZTJT4WfGpnwjWkM4e51tclPXvdpvKwXsC/PXjAl/LLC+
r3EK0rO8c0Nb0ayekvdoFGSaBB5R4vkLollsUGi8NswJIvI0Dd/dit52zDpy7HZm
u1aa619f81+UHOTQv2F8PoBFCP2++ukZzEPfZlxOQjyz6D6tqCimg+5Mn1bX4XHY
7rjX5tqwVcx4P/EsuL66xso5gjT98umL1m5/YEgOqc6sIk+ol/asvUiYs2ii75eP
3UZfSOPlcVj6CznNssOiKKHUP0w8rf9xrvNCd04mXNJVUlEn96CaKjbe8B/G25e4
V6myiieVWgaOws74+8Xqazs19UkhZQ==
=aHba
-----END PGP SIGNATURE-----

--Sig_/i6Wf7hQDPy.T5c6zB_97gG0--
