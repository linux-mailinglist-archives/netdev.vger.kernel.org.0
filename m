Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5605BD2785
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbfJJKvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:51:23 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:62561 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfJJKvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 06:51:23 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 90FA2A1F82;
        Thu, 10 Oct 2019 12:51:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 3dvx6dB1mQAU; Thu, 10 Oct 2019 12:51:15 +0200 (CEST)
Date:   Thu, 10 Oct 2019 21:51:06 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] bpf: use copy_struct_from_user() in
 bpf_prog_get_info_by_fd()
Message-ID: <20191010105106.ou3pacpi5xbordf3@yavin.dot.cyphar.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191009160907.10981-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="duilzbpzuql66o4r"
Content-Disposition: inline
In-Reply-To: <20191009160907.10981-3-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--duilzbpzuql66o4r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-09, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
> This helper is intended for all codepaths that copy structs from
> userspace that are versioned by size. bpf_prog_get_info_by_fd() does
> exactly what copy_struct_from_user() is doing.
> Note that copy_struct_from_user() is calling min() already. So
> technically, the min_t() call could go. But the info_len is used further
> below so leave it.
>=20
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Acked-by: Aleksa Sarai <cyphar@cyphar.com>

> ---
>  kernel/bpf/syscall.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 78790778f101..6f4f9097b1fe 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2312,13 +2312,10 @@ static int bpf_prog_get_info_by_fd(struct bpf_pro=
g *prog,
>  	u32 ulen;
>  	int err;
> =20
> -	err =3D bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
> +	info_len =3D min_t(u32, sizeof(info), info_len);
> +	err =3D copy_struct_from_user(&info, sizeof(info), uinfo, info_len);
>  	if (err)
>  		return err;
> -	info_len =3D min_t(u32, sizeof(info), info_len);
> -
> -	if (copy_from_user(&info, uinfo, info_len))
> -		return -EFAULT;
> =20
>  	info.type =3D prog->type;
>  	info.id =3D prog->aux->id;
> --=20
> 2.23.0

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--duilzbpzuql66o4r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXZ8NFgAKCRCdlLljIbnQ
Ei5dAQDNXxmGHfpnOPRmPwrgnRNukfKQnwpJmvCTGLcteNGW1AEAwsmOuOot6/I8
S4hzjZb0TeKgP517ksBG1Sa0M8k/HQQ=
=xqTG
-----END PGP SIGNATURE-----

--duilzbpzuql66o4r--
