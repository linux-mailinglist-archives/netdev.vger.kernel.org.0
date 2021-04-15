Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB37361483
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbhDOWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOWFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:05:39 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0501C061574;
        Thu, 15 Apr 2021 15:05:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FLtgV5j0vz9sW4;
        Fri, 16 Apr 2021 08:05:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618524313;
        bh=N0kmpCXfYvJVThMK+hIA7oKPDTMnMe87Yd9++GHP6TI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qiyk3M/6v4coSUg+Q14EFk0ZjXI9ltV1+1gjoe1FVnKJNJdaiIXKI3AaJx+zLpdLe
         7XVlmuTgJPa/S4BrNwWpiKuHTorG4JHKHxX9HuinebEQ6MY+6IsEB+U1BTQxpqxGfs
         1Ze9IU3yszZ4xdBp4Zi7BeebcZ7TdzijnG/4OBfcCmAy0g8030q+klNXOKb8OrXPN1
         YkJnKOWhI/xeKXhVSw1/MllsPIWz8q1Qbx1PXSmjHydod9ymkdCjnstNcIyvKcQRGo
         tptboQN6Mh4iWz4M1oosa7DEt2LfZKeRb6qSE+ckmG0aTJPKCZyz1LWGmkwsuyA/MC
         0Ng1bg9iTkyKw==
Date:   Fri, 16 Apr 2021 08:05:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210416080508.25030590@canb.auug.org.au>
In-Reply-To: <DM6PR11MB2780C0D45E70297CC5CE5423CA4D9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210415121713.28af219a@canb.auug.org.au>
        <DM6PR11MB2780C0D45E70297CC5CE5423CA4D9@DM6PR11MB2780.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/26TA7tHlp29Th/NRAfnKn8r";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/26TA7tHlp29Th/NRAfnKn8r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 15 Apr 2021 14:00:16 +0000 "Ong, Boon Leong" <boon.leong.ong@intel.=
com> wrote:
>
> I check linux-next merge fix above and spotted an additional fix needed.
> Please see below.=20
>=20
> >+ /**
> >+  * dma_recycle_rx_skbufs - recycle RX dma buffers
> >+  * @priv: private structure
> >+  * @queue: RX queue index
> >+  */
> >+ static void dma_recycle_rx_skbufs(struct stmmac_priv *priv, u32 queue)
> >+ {
> >+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
> >+ 	int i;
> >+
> >+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
> >+ 		struct stmmac_rx_buffer *buf =3D &rx_q->buf_pool[i];
> >+
> >+ 		if (buf->page) {
> >+ 			page_pool_recycle_direct(rx_q->page_pool, buf- =20
> >>page); =20
> >+ 			buf->page =3D NULL;
> >+ 		}
> >+
> >+ 		if (priv->sph && buf->sec_page) {
> >+ 			page_pool_recycle_direct(rx_q->page_pool, buf- =20
> >>sec_page); =20
> >+ 			buf->sec_page =3D NULL;
> >+ 		}
> >+ 	}
> >+ } =20
>=20
> With https://git.kernel.org/netdev/net/c/00423969d806 that reverts
> stmmac_reinit_rx_buffers(), then the above dma_recycle_rx_skbufs()
> is no longer needed when net-next is sent for merge.=20

Thanks.  I have added removal of that (now unused) function to my merge
resolution.

--=20
Cheers,
Stephen Rothwell

--Sig_/26TA7tHlp29Th/NRAfnKn8r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB4uJQACgkQAVBC80lX
0GyAqgf5AZ531eJDllZim2FFQuyNW3MYW7Wnn4dbP9pXm0SQeUNrvk3Ccag9LS9O
ks1aEIXe2V+HMd3G9GQvJwOMaHGx4Axytkp3f55ZERlLF1Pea4JYuo4bZpQfD4FO
S1C9v7Dlh8LON8urt4BfUATcegFisE2k8GCkwWxI8ecWaOinuWqfOqlVic7M38fx
DuOkymPFqJd0jP+yAIFoRUVwWtUV5nP3nwlAYNSjAJeIShjJ4u8V+Bqf8ZK/mPSx
v214RMI540mIq317Wo+qQfWYMz+xgszwlO1jZRPsQy3OPj/+YHFMoXz0KZSh0WD8
E7z5Eq+PrItLCy9ucDvQ/IlZxv6GYA==
=dk52
-----END PGP SIGNATURE-----

--Sig_/26TA7tHlp29Th/NRAfnKn8r--
