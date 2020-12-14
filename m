Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF72DA18F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503328AbgLNUaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:30:35 -0500
Received: from ozlabs.org ([203.11.71.1]:60493 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388483AbgLNUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:30:28 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CvtKc0wX8z9sS8;
        Tue, 15 Dec 2020 07:29:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607977781;
        bh=oCRoJqFc/+FmU+nNV9clfFzmex118Yv1qsU3bjLcBnE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i6tne6tcJtRXZHFQLpAsZA1tPQ67yQhTER+d7zEcSRu4Ik2ZD+QIAxp0KrpPTbOd8
         GRhrL8rD2aU3rzmEUxuzHjQBpOqT0rvfgTJZQ1BYmr1z/2ibmzt0AL+2Oa6Wvas64f
         ww6QnzzqpZqwpuquovArQqST/2uSVTJcvLlSFfayirl2UYD3/EJDEU9YbhXNL+kIJd
         Q9TXTKDIBkVgpLc7CrzTkaqEH9g6MTTqXqs4ZHU25Wu4JKdiF72xvL/TbNIinF1PJe
         EuMcRCpQ4lln0p65Td8AI3bH8YezsBRORyMjIsrLY8A75kZHzEdyAZru6H3QYFO8SX
         0gRAYte5g/FZA==
Date:   Tue, 15 Dec 2020 07:29:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jens Axboe <axboe@kernel.dk>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Florent Revest <revest@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20201215072939.6a665cf3@canb.auug.org.au>
In-Reply-To: <20201207140951.4c04f26f@canb.auug.org.au>
References: <20201207140951.4c04f26f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T3rfAfpL0zH0ZZAbOzmD5q/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/T3rfAfpL0zH0ZZAbOzmD5q/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 7 Dec 2020 14:09:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> fs/io_uring.c: In function 'io_shutdown':
> fs/io_uring.c:3782:9: error: too many arguments to function 'sock_from_fi=
le'
>  3782 |  sock =3D sock_from_file(req->file, &ret);
>       |         ^~~~~~~~~~~~~~
> In file included from fs/io_uring.c:63:
> include/linux/net.h:243:16: note: declared here
>   243 | struct socket *sock_from_file(struct file *file);
>       |                ^~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   36f4fa6886a8 ("io_uring: add support for shutdown(2)")
>=20
> interacting with commit
>=20
>   dba4a9256bb4 ("net: Remove the err argument from sock_from_file")
>=20
> from the bpf-next tree.
>=20
> I have applied the following merge fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 7 Dec 2020 14:04:10 +1100
> Subject: [PATCH] fixup for "net: Remove the err argument from sock_from_f=
ile"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cd997264dbab..91d08408f1fe 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3779,9 +3779,9 @@ static int io_shutdown(struct io_kiocb *req, bool f=
orce_nonblock)
>  	if (force_nonblock)
>  		return -EAGAIN;
> =20
> -	sock =3D sock_from_file(req->file, &ret);
> +	sock =3D sock_from_file(req->file);
>  	if (unlikely(!sock))
> -		return ret;
> +		return -ENOTSOCK;
> =20
>  	ret =3D __sys_shutdown_sock(sock, req->shutdown.how);
>  	io_req_complete(req, ret);

Just a reminder that I am still applying this merge fix.

--=20
Cheers,
Stephen Rothwell

--Sig_/T3rfAfpL0zH0ZZAbOzmD5q/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XyzMACgkQAVBC80lX
0GwWUggAn7ql1hC2UGt+piu1oNbFBTkKpQNJI+21jK5WrWX/d+g5vSUIY8irk49Z
8amRkh7n+b8Bk1IIpIjsYswk431MWYaXJ4s2iQ+/GW8PFZz2aTpVlMWmvyhh8uV3
F6IwGPSB3q7Kcq3AH0/eRQQf8J3HB11r+l0CJzZ6TMMiFZMSIIHvKaUertWbHK0w
2Z8tXXwJjr4uVQjl90T0HLWlRsorAf6BMfDQ8/mfgcJrVS+1O55/MzTOZ7VobJGu
NbBtxK1WVCC5zWY04CjWDVVhlYTsE9sb5jfW43mu7sH3GQ8TLZUiaONaIuqqqfQc
6Gg1Q6c4ZYL55G2rL9zr/e/u4fmNhg==
=RpZP
-----END PGP SIGNATURE-----

--Sig_/T3rfAfpL0zH0ZZAbOzmD5q/--
