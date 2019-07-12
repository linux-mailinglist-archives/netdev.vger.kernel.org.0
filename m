Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D6F66370
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 03:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfGLBqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 21:46:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59161 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbfGLBqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 21:46:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lG3V60j1z9sMQ;
        Fri, 12 Jul 2019 11:45:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562895960;
        bh=0W6npV2Kiu65/8q7sGtd68JHyVYyZcWbnkUBWyhmDYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WgShdzxOGy68a+Sd5OYoYK9XIP/UJqNVvkTNyYsa4rXN5RgjYJ2Ca8MngqgjbdMD3
         B6CsRfum5jqJhhIjjqGmpQChcrSSjqOiLyIllb3dmWXUJhxxoinRrregBrw0DuNZgU
         Phps/E2cAgW0sXaHM3PakgpuiGDt2Qucn7cUthohTP8YzLDIKwSd+rLHYFMXba7Vnv
         DKPx6Sp3l51lbHJ4xpgQHjNsYd9PNDonLb4Wc7ob3pzkdgrQ1mTD9+afCiw4G/RMOh
         uvTt9FqEaVQKMkUwbpyui15vUFsOVc9gPY8zPTymnLmNzH+HT4oIYEIBAITRNE4GJc
         ne7AzAI+Q3UTw==
Date:   Fri, 12 Jul 2019 11:45:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Bernard Metzler <BMT@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190712114557.2b094876@canb.auug.org.au>
In-Reply-To: <20190711143302.GH25821@mellanox.com>
References: <20190711115235.GA25821@mellanox.com>
 <20190710175212.GM2887@mellanox.com>
 <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
 <OF9A485648.9C7A28A3-ON00258434.00449B07-00258434.00449B14@notes.na.collabserv.com>
 <20190711143302.GH25821@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IUmAit71Bk+sk6PU6OW4=UR"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IUmAit71Bk+sk6PU6OW4=UR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Thu, 11 Jul 2019 14:33:07 +0000 Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> I've added this patch to the rdma tree to fix the missing locking.
>=20
> The merge resolution will be simply swapping
> for_ifa to in_dev_for_each_ifa_rtnl.

OK, I added the below merge resolution patch to the merge of the rdma
tree today (since Linus' has merged the net-next tree now).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Jul 2019 11:28:30 +1000
Subject: [PATCH] RDMA: fix for removal of for_ifa()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index 43f7f12e5f7f..cbea46ff6dd1 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1951,6 +1951,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 int siw_create_listen(struct iw_cm_id *id, int backlog)
 {
 	struct net_device *dev =3D to_siw_dev(id->device)->netdev;
+	const struct in_ifaddr *ifa;
 	int rv =3D 0, listeners =3D 0;
=20
 	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
@@ -1973,8 +1974,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
=20
 		rtnl_lock();
-		for_ifa(in_dev)
-		{
+		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
 			    s_laddr.sin_addr.s_addr =3D=3D ifa->ifa_address) {
 				s_laddr.sin_addr.s_addr =3D ifa->ifa_address;
@@ -1986,7 +1986,6 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 					listeners++;
 			}
 		}
-		endfor_ifa(in_dev);
 		rtnl_unlock();
 		in_dev_put(in_dev);
 	} else if (id->local_addr.ss_family =3D=3D AF_INET6) {
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/IUmAit71Bk+sk6PU6OW4=UR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0n5lUACgkQAVBC80lX
0GzltQf/bL3tGcP1XbyYwX3AxXlwt2ZXDwgJZYBwSuZXTdaUOqA2zCcdiBUAurlt
sW+IecoiTghsCXQEidmQ0UbdgpW3vTOJ79tVHMGqgKKvullNW1IbcDIfDwnrOe1b
Tz5euSKYy+KchcCvZl7XpQfksI9seKhqon1PC0qXT6WmpaTRXQKNcPUuPTnyxfvh
9IO6CJyXWcscwc41KNYbbXrQYQbsaaJ88INcw2L9EZ77sFhHcqWJID8y0XFcIqVm
sfRWuWfJ7Jfuh5mFFtc3PPtQxoKhaTg9YrORNgLv06O+a6sQ+w4FDsYaZEFbINyu
4qsIzrZRU/ud4AI+bj/0UcK/7UoMZA==
=aAIK
-----END PGP SIGNATURE-----

--Sig_/IUmAit71Bk+sk6PU6OW4=UR--
