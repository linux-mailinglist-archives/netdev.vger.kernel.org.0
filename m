Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAFBD2783
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbfJJKus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:50:48 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:31951 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfJJKur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:50:47 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 21E47A1A7B;
        Thu, 10 Oct 2019 12:50:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id oW1bKVSmI81Q; Thu, 10 Oct 2019 12:50:41 +0200 (CEST)
Date:   Thu, 10 Oct 2019 21:50:31 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] bpf: use check_zeroed_user() in
 bpf_check_uarg_tail_zero()
Message-ID: <20191010105031.eadc7baldnnufxjf@yavin.dot.cyphar.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191009160907.10981-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrlewcij3x6slscb"
Content-Disposition: inline
In-Reply-To: <20191009160907.10981-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrlewcij3x6slscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-09, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> In v5.4-rc2 we added a new helper (cf. [1]) check_zeroed_user() which
> does what bpf_check_uarg_tail_zero() is doing generically. We're slowly
> switching such codepaths over to use check_zeroed_user() instead of
> using their own hand-rolled version.
>=20
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Acked-by: Aleksa Sarai <cyphar@cyphar.com>

> ---
>  kernel/bpf/syscall.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
>=20
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 82eabd4e38ad..78790778f101 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -63,30 +63,22 @@ int bpf_check_uarg_tail_zero(void __user *uaddr,
>  			     size_t expected_size,
>  			     size_t actual_size)
>  {
> -	unsigned char __user *addr;
> -	unsigned char __user *end;
> -	unsigned char val;
> +	size_t size =3D min(expected_size, actual_size);
> +	size_t rest =3D max(expected_size, actual_size) - size;
>  	int err;
> =20
>  	if (unlikely(actual_size > PAGE_SIZE))	/* silly large */
>  		return -E2BIG;
> =20
> -	if (unlikely(!access_ok(uaddr, actual_size)))
> -		return -EFAULT;
> -
>  	if (actual_size <=3D expected_size)
>  		return 0;
> =20
> -	addr =3D uaddr + expected_size;
> -	end  =3D uaddr + actual_size;
> +	err =3D check_zeroed_user(uaddr + expected_size, rest);
> +	if (err < 0)
> +		return err;
> =20
> -	for (; addr < end; addr++) {
> -		err =3D get_user(val, addr);
> -		if (err)
> -			return err;
> -		if (val)
> -			return -E2BIG;
> -	}
> +	if (err)
> +		return -E2BIG;
> =20
>  	return 0;
>  }

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--yrlewcij3x6slscb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXZ8M9AAKCRCdlLljIbnQ
Epr/AQCyrkQQbHuqCW5VkNaIJxIvHI5/ShmQM9ev+h5OCSYKvwEAhqXnMkhCZMnZ
6Y4CZGrZrNvytbxMMC7EDJEagjZPLQo=
=MUrF
-----END PGP SIGNATURE-----

--yrlewcij3x6slscb--
