Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AFB3EAE1C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 03:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbhHMBZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 21:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhHMBZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 21:25:07 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F732C061756;
        Thu, 12 Aug 2021 18:24:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gm5Sh1Bwxz9sWc;
        Fri, 13 Aug 2021 11:24:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628817876;
        bh=eMs3ptdq9UyugAHdDJt8wv8D3zogP2gKf9SdJuEW8IU=;
        h=Date:From:To:Cc:Subject:From;
        b=AfgJ49lAj8zegj8CkfBe+JGJgIKJ9ArDGzdw5bhKiU+cUOMHb7PYxg+sjeYHWusSr
         vGQTNIHpBSLvKlGkPVYp5l7a3l8QUxZz4YlEdhf9xgrT8luzhK6WZa4ABy7HkOxEgx
         d59+Lv0xk5eR31I3kYptPdoNVm9QE+f76nCoTLIUi4/KjD3ASjP5drIPoGmD0Z67zy
         /etVLAyywPJjEatPvNP/wG3HpGEC/tmCp/VjH6F1+nY2KAhMxZO2B9AeTwlpJRDpk/
         qc70WCih+WpWV3hJSBOfxtQt3zXszCa4NaVz1/mn10Bbhgv5qgU9S9xtsHR/h7JMjh
         lzqmbfc7UBDPw==
Date:   Fri, 13 Aug 2021 11:24:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210813112432.07a6de8b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5ZEM9E+bDKf2fYF.W7mhSOQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5ZEM9E+bDKf2fYF.W7mhSOQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c

between commit:

  5957cc557dc5 ("net/mlx5: Set all field of mlx5_irq before inserting it to=
 the xarray")

from the net tree and commit:

  2d0b41a37679 ("net/mlx5: Refcount mlx5_irq with integer")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 3465b363fc2f,60bfcad1873c..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@@ -214,8 -234,7 +234,8 @@@ static struct mlx5_irq *irq_request(str
  		err =3D -ENOMEM;
  		goto err_cpumask;
  	}
 +	irq->pool =3D pool;
- 	kref_init(&irq->kref);
+ 	irq->refcount =3D 1;
  	irq->index =3D i;
  	err =3D xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
  	if (err) {
@@@ -459,10 -475,13 +478,14 @@@ static void irq_pool_free(struct mlx5_i
  	struct mlx5_irq *irq;
  	unsigned long index;
 =20
+ 	/* There are cases in which we are destrying the irq_table before
+ 	 * freeing all the IRQs, fast teardown for example. Hence, free the irqs
+ 	 * which might not have been freed.
+ 	 */
  	xa_for_each(&pool->irqs, index, irq)
- 		irq_release(&irq->kref);
+ 		irq_release(irq);
  	xa_destroy(&pool->irqs);
 +	mutex_destroy(&pool->lock);
  	kvfree(pool);
  }
 =20

--Sig_/5ZEM9E+bDKf2fYF.W7mhSOQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEVydEACgkQAVBC80lX
0GyZ9gf/Q4g9AyLnZPeMzb1M7wl05yPwA0hyLLyMey1EFFZprgHJmaQn6q2cCf+z
cJ3XBcDsDs6wZPOU5cYSLKQ5n7JUzpNL7klOcYKBxrD59QIRPrb7oXf807P0U95R
clvI+w7wLmAR42AZwRMn0PqKWOmRxdU6/wNGOQ6h1hw2SqacT+P1eoCGDMMCPtM8
Gpnm4YOeh8pUL+LZ+JE15kx85uBxL4XENhq7j6cjbHEX+vRSMJ7Sk+4CH/VXbKo3
iJMvnaYMJMGVdjGsZI6x0Nsz/WSteTOgw7tl/FA+hmY3xiCJRD7SdLSepCBZf5y9
kXhRnGOrdmhRshXcLpbvX0OjfdMvUw==
=P/FL
-----END PGP SIGNATURE-----

--Sig_/5ZEM9E+bDKf2fYF.W7mhSOQ--
