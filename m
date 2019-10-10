Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF7CD278C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbfJJKvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:51:49 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:15547 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfJJKvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:51:49 -0400
Received: from smtp2.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 440F9A1FC8;
        Thu, 10 Oct 2019 12:51:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id GeryTYYEjkCd; Thu, 10 Oct 2019 12:51:40 +0200 (CEST)
Date:   Thu, 10 Oct 2019 21:51:32 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] bpf: use copy_struct_from_user() in bpf() syscall
Message-ID: <20191010105131.oxxjyzwcxaawq7gc@yavin.dot.cyphar.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191009160907.10981-4-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ktftpmdo5nnmxrkc"
Content-Disposition: inline
In-Reply-To: <20191009160907.10981-4-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ktftpmdo5nnmxrkc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-09, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
> This helper is intended for all codepaths that copy structs from
> userspace that are versioned by size. The bpf() syscall does exactly
> what copy_struct_from_user() is doing.
> Note that copy_struct_from_user() is calling min() already. So
> technically, the min_t() call could go. But the size is used further
> below so leave it.
>=20
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Acked-by: Aleksa Sarai <cyphar@cyphar.com>

> ---
>  kernel/bpf/syscall.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 6f4f9097b1fe..6fdcbdb27501 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2819,14 +2819,11 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __u=
ser *, uattr, unsigned int, siz
>  	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> =20
> -	err =3D bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
> -	if (err)
> -		return err;
>  	size =3D min_t(u32, size, sizeof(attr));
> -
>  	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
> -	if (copy_from_user(&attr, uattr, size) !=3D 0)
> -		return -EFAULT;
> +	err =3D copy_struct_from_user(&attr, sizeof(attr), uattr, size);
> +	if (err)
> +		return err;
> =20
>  	err =3D security_bpf(cmd, &attr, size);
>  	if (err < 0)
> --=20
> 2.23.0

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ktftpmdo5nnmxrkc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXZ8NMAAKCRCdlLljIbnQ
EooLAQCk0iL0ngT5RY975QbaIkHib7QvjcaMWqv4+UB9OL68JQEA1d1QaTuCsAmu
L6vK4cjRbZXEGJ2sMlB3KZArnz4OJAY=
=jtYU
-----END PGP SIGNATURE-----

--ktftpmdo5nnmxrkc--
