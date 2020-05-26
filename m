Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F91F1E19BF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 05:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbgEZDMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 23:12:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37779 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388460AbgEZDMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 23:12:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49WJtQ6Mthz9sRW;
        Tue, 26 May 2020 13:12:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590462768;
        bh=ibjYOJ+mjGcTQ7SK0V45i01JnzyGkUrx46Df39/IMCM=;
        h=Date:From:To:Cc:Subject:From;
        b=Qt5OhoU57GhRKI5+nV9xTdZiUCDsydy1/brpQKpbkAWDkZmxifs59xK7MWvqHTVUV
         Uyg5LBXVAmnHMPr+/iZluxJobEjwErOwTO2GftS1zxy8UiiRWQHAyGLArvgFIyXxPI
         /dX7Bx9ORysmevIB9gH6Kq0HapKaBkO5mKmVbF/lXK7rXD6+CTls/UT9inGJ2k0Zfc
         et/uiTHbeTA6/cX6CLSjmLnGu1Xz376Lsd+vNsum9vBmlkBTyd7GOqvEZTu0nragW6
         UkHRmzCIybbZSdjQwLVcaThDSIt/ECzPqnQLzCqz/hlZS8lGTB1d0hCl3DqNoL5erT
         GGv2IDBwGh3DA==
Date:   Tue, 26 May 2020 13:12:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20200526131243.0915e58c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hcL6WG8dNvQARE_6wapKFfn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hcL6WG8dNvQARE_6wapKFfn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/xdp/xdp_umem.c

between commit:

  b16a87d0aef7 ("xsk: Add overflow check for u64 division, stored into u32")

from the bpf tree and commit:

  2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")

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

diff --cc net/xdp/xdp_umem.c
index 3889bd9aec46,19e59d1a5e9f..000000000000
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@@ -389,13 -349,10 +353,10 @@@ static int xdp_umem_reg(struct xdp_ume
  	if (headroom >=3D chunk_size - XDP_PACKET_HEADROOM)
  		return -EINVAL;
 =20
- 	umem->address =3D (unsigned long)addr;
- 	umem->chunk_mask =3D unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
- 					    : ~((u64)chunk_size - 1);
  	umem->size =3D size;
  	umem->headroom =3D headroom;
- 	umem->chunk_size_nohr =3D chunk_size - headroom;
+ 	umem->chunk_size =3D chunk_size;
 -	umem->npgs =3D size / PAGE_SIZE;
 +	umem->npgs =3D (u32)npgs;
  	umem->pgs =3D NULL;
  	umem->user =3D NULL;
  	umem->flags =3D mr->flags;

--Sig_/hcL6WG8dNvQARE_6wapKFfn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7MiSsACgkQAVBC80lX
0GzFOgf8DouWICsguEs8Ast+8L7nS6YDM+TWtX6ZH+95i3RHscLa0clIZ3dcBqoq
YwPG6GVT5/8buiMD+GvcJfoyssMsSMcy2L81QEs/OJDnI225g/i7IE7HnAXNQOAD
0C+D8lfzCcl8vdjp2EJ5VMHsqxzhEzc0dsma3gmH2wDaBfir/O6ZiXQaT1I4BuB1
9zZs9KdM+A5JfKGZkAG26JTUFXyqcTXlURVv5E+bqiUftlxJnX9vUQ7K4KS7kJPt
Fg/oR8kayjBCZjxWaWO4rBFYx4Nt9uvwTRGooT2EPkvNrqWgy9i3AJqCT4ULD5LT
Ah9TZlb1tz2I8SHxSfphISmXK9hofQ==
=v5to
-----END PGP SIGNATURE-----

--Sig_/hcL6WG8dNvQARE_6wapKFfn--
