Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912511EB8BC
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFBJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:45:22 -0400
Received: from ozlabs.org ([203.11.71.1]:55375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgFBJpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 05:45:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bnG64V5gz9sSd;
        Tue,  2 Jun 2020 19:45:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591091119;
        bh=rHjqg8VL9elDAD+ADMU7zcoO0BfnTLBhxa1QCKEro0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QKUWUqo3Fv/vI5c1uNnRJ9QlC0H2ktwI9O1cDwcxgxH2PZGGXLoABmBfxKUqj8qkU
         uLfME3bB+wT+VMI1SXSR+g2k4eqL5+gCjhEZY6/qBc2/qWTBARUlXIgHC5of38SRRZ
         Alu0wQ38Tfap5GLBXxifKV9H7/JhOsGCeMt/KgmirhPSMiADBXHUKbhxOTeaA4JLv3
         NsgmGZsgeG16evRaVVXoMZx+0WdYAyuQH36rZlVkBt4iO0sjXZiueeHKsrCna3FiZ5
         CsMvTknXimFFCPeibRsM00XlntEN0qa5Ss50/j/jmDNd8xVEY5wg2JX6p2DUdSLPSh
         X6/20NgjIixXg==
Date:   Tue, 2 Jun 2020 19:45:17 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: linux-next: manual merge of the akpm tree with the net-next
 tree
Message-ID: <20200602194517.18b5db39@canb.auug.org.au>
In-Reply-To: <20200602193048.6ab63e72@canb.auug.org.au>
References: <20200602193048.6ab63e72@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vMZU3oBdpIxQNjcBV0cV9fi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vMZU3oBdpIxQNjcBV0cV9fi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 2 Jun 2020 19:30:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the akpm tree got a conflict in:
>=20
>   kernel/trace/bpf_trace.c
>=20
> between commit:
>=20
>   b36e62eb8521 ("bpf: Use strncpy_from_unsafe_strict() in bpf_seq_printf(=
) helper")
>=20
> from the net-next tree and patch:
>=20
>   "bpf:bpf_seq_printf(): handle potentially unsafe format string better"
>=20
> from the akpm tree.
>=20
> I fixed it up (I just dropped the akpm tree patch (and its fix) for now)
> and can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.

I also had to ad the below patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Jun 2020 19:40:42 +1000
Subject: [PATCH] fix up for strncpy_from_unsafe_strict rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index af4bca8343ad..0d88e9b24928 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -619,7 +619,7 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *=
, fmt, u32, fmt_size,
 				goto out;
 			}
=20
-			err =3D strncpy_from_unsafe_strict(bufs->buf[memcpy_cnt],
+			err =3D strncpy_from_kernel_nofault(bufs->buf[memcpy_cnt],
 							 (void *) (long) args[fmt_cnt],
 							 MAX_SEQ_PRINTF_STR_LEN);
 			if (err < 0)
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/vMZU3oBdpIxQNjcBV0cV9fi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7WH60ACgkQAVBC80lX
0GxFOgf8CcFAy5477Uv/joO+eVX6m7DuApgeVrpyfPC7UU7QbK/YkeqZI+ROAY4i
Z8ovJ3NQ0p4FJXSwPANhq09COdxYQeWgK8c7QpfP7aiRtEsmuizbCCBmKGhHlUhO
DUd1hICRLLMVk0bxVvXCbaOyzb2AAgkUty1MSEV4ZyMPACuwPqXcbLYeRnCe08Bl
Z+Z3xXYFsr3W6co/lnNPV0A82DdMSXM02qZ8CZdYJ4+EU72Br1ft/Q8FC/pYXA/G
JTdjNDDWTwYkwelB4R0F74qYs/XbirZzLs4CmPQwUQhSE2VlJL/yEHfQRla9JGKU
RHqj1feHymc+OUiylH2Z02h4Rg4pCw==
=WI8s
-----END PGP SIGNATURE-----

--Sig_/vMZU3oBdpIxQNjcBV0cV9fi--
