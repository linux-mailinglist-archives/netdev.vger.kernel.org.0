Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD64443988F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhJYOar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:30:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhJYOar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635172104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k7IUYS+f6cJM8vxxwfG/IWeLPkNjwZZO8VH5ibyjQ68=;
        b=BguOD2cBdOypkcS2ZVbBOfWprdJveKxG3z/e4QVKI/uJjGkvz4Nn1QxZP54Nzl+G9H+4uD
        nF1KicLgSwQUKd5I22mz9vncwin4vsn+34ys5VRQmERSlYWkq5tfOBXvlWcXVUwTcmE34l
        iBw3pvW+/FTmK5rrn3f8TYt7w+LOgwM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-5sgWa7WXMDe7ZxyvvbRfkQ-1; Mon, 25 Oct 2021 10:28:23 -0400
X-MC-Unique: 5sgWa7WXMDe7ZxyvvbRfkQ-1
Received: by mail-ed1-f71.google.com with SMTP id s18-20020a056402521200b003dd5902f4f3so3064798edd.23
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7IUYS+f6cJM8vxxwfG/IWeLPkNjwZZO8VH5ibyjQ68=;
        b=SUmWdZsFapLmhJzNX3+ZO2crUQ373sjVGjp7pkDzGsLt/WfzPNwFvXPGCXjJxvc0Lh
         4NudCjgracddA29hz42GMCKnBZr51Z/dGL/npdrieY3FRbzDtMgS1UhhEpgK/9hforlt
         o+onGYvfxDHhyLlcu1SZ8W/DhK2DLK2wE/na7g7RBsKElGBokbxcTRrKx+2AtIPiykjj
         LVGO/v7GkkL5fOrIqDWeuNMG4PBSNQGd0KJthwFnfuE1cYE+22Xx0OTmOPmRxxMEK0hF
         oUExkxwc7BDdbCINyA/WeaS4EoIzjUuPsFulCsrqohl5hXkEBHbRAs0gx1fkV3c8EDDk
         rs0g==
X-Gm-Message-State: AOAM53388Xnis5EptSRG6cNOkq5Zsauh+2x8joTZexrPyjnynaiO+fOx
        dj31l1g5p0Isv9wgSLxQJkKG4sPqjFJ0bOMF81ZtsiTm8V/nCtJRv6/ypYWepxxowHpzeaDWZZZ
        Oh9xjJOEZRACrKazv
X-Received: by 2002:aa7:da16:: with SMTP id r22mr27670452eds.75.1635172101927;
        Mon, 25 Oct 2021 07:28:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBbd0UnAYep8TAzxItm6d0m4Bumk2iELW55O6GSqYsdIa7q88RNhWC9AWyse3t7cTx7fCi7w==
X-Received: by 2002:aa7:da16:: with SMTP id r22mr27670395eds.75.1635172101567;
        Mon, 25 Oct 2021 07:28:21 -0700 (PDT)
Received: from localhost (net-130-25-199-50.cust.vodafonedsl.it. [130.25.199.50])
        by smtp.gmail.com with ESMTPSA id p22sm7730436ejl.90.2021.10.25.07.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:28:20 -0700 (PDT)
Date:   Mon, 25 Oct 2021 16:28:19 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2] bpf: fix potential race in tail call
 compatibility check
Message-ID: <YXa/A4eQhlPPsn+n@lore-desk>
References: <20211025130809.314707-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D6B0LZMOnHg+idi6"
Content-Disposition: inline
In-Reply-To: <20211025130809.314707-1-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--D6B0LZMOnHg+idi6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo noticed that the code testing for program type compatibility of
> tail call maps is potentially racy in that two threads could encounter a
> map with an unset type simultaneously and both return true even though th=
ey
> are inserting incompatible programs.
>=20
> The race window is quite small, but artificially enlarging it by adding a
> usleep_range() inside the check in bpf_prog_array_compatible() makes it
> trivial to trigger from userspace with a program that does, essentially:
>=20
>         map_fd =3D bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, 4, 4, 2, 0);
>         pid =3D fork();
>         if (pid) {
>                 key =3D 0;
>                 value =3D xdp_fd;
>         } else {
>                 key =3D 1;
>                 value =3D tc_fd;
>         }
>         err =3D bpf_map_update_elem(map_fd, &key, &value, 0);
>=20
> While the race window is small, it has potentially serious ramifications =
in
> that triggering it would allow a BPF program to tail call to a program of=
 a
> different type. So let's get rid of it by protecting the update with a
> spinlock. The commit in the Fixes tag is the last commit that touches the
> code in question.
>=20
> v2:
> - Use a spinlock instead of an atomic variable and cmpxchg() (Alexei)
>=20
> Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
> Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h   |  1 +
>  kernel/bpf/arraymap.c |  1 +
>  kernel/bpf/core.c     | 14 ++++++++++----
>  kernel/bpf/syscall.c  |  2 ++
>  4 files changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 020a7d5bf470..98d906176d89 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -929,6 +929,7 @@ struct bpf_array_aux {
>  	 * stored in the map to make sure that all callers and callees have
>  	 * the same prog type and JITed flag.
>  	 */
> +	spinlock_t type_check_lock;

I was wondering if we can use a mutex instead of a spinlock here since it is
run from a syscall AFAIU. The only downside is mutex_lock is run inside
aux->used_maps_mutex critical section. Am I missing something?

Regards,
Lorenzo

>  	enum bpf_prog_type type;
>  	bool jited;
>  	/* Programs with direct jumps into programs part of this array. */
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index cebd4fb06d19..da9b1e96cadc 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -1072,6 +1072,7 @@ static struct bpf_map *prog_array_map_alloc(union b=
pf_attr *attr)
>  	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
>  	INIT_LIST_HEAD(&aux->poke_progs);
>  	mutex_init(&aux->poke_mutex);
> +	spin_lock_init(&aux->type_check_lock);
> =20
>  	map =3D array_map_alloc(attr);
>  	if (IS_ERR(map)) {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c1e7eb3f1876..9439c839d279 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1823,20 +1823,26 @@ static unsigned int __bpf_prog_ret0_warn(const vo=
id *ctx,
>  bool bpf_prog_array_compatible(struct bpf_array *array,
>  			       const struct bpf_prog *fp)
>  {
> +	bool ret;
> +
>  	if (fp->kprobe_override)
>  		return false;
> =20
> +	spin_lock(&array->aux->type_check_lock);
> +
>  	if (!array->aux->type) {
>  		/* There's no owner yet where we could check for
>  		 * compatibility.
>  		 */
>  		array->aux->type  =3D fp->type;
>  		array->aux->jited =3D fp->jited;
> -		return true;
> +		ret =3D true;
> +	} else {
> +		ret =3D array->aux->type  =3D=3D fp->type &&
> +		      array->aux->jited =3D=3D fp->jited;
>  	}
> -
> -	return array->aux->type  =3D=3D fp->type &&
> -	       array->aux->jited =3D=3D fp->jited;
> +	spin_unlock(&array->aux->type_check_lock);
> +	return ret;
>  }
> =20
>  static int bpf_check_tail_call(const struct bpf_prog *fp)
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4e50c0bfdb7d..955011c7df29 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct seq_file *m, =
struct file *filp)
> =20
>  	if (map->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY) {
>  		array =3D container_of(map, struct bpf_array, map);
> +		spin_lock(&array->aux->type_check_lock);
>  		type  =3D array->aux->type;
>  		jited =3D array->aux->jited;
> +		spin_unlock(&array->aux->type_check_lock);
>  	}
> =20
>  	seq_printf(m,
> --=20
> 2.33.0
>=20

--D6B0LZMOnHg+idi6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYXa/AwAKCRA6cBh0uS2t
rCM5AQDxfTZymJ5Ta564wVZPo2Dr1sCZhRZNh7YIXvMMEAk+OwD/TXAyE+KiwNUR
gc/mN84p4kO1SMez8NVhqnCoX0BTNAU=
=cYbp
-----END PGP SIGNATURE-----

--D6B0LZMOnHg+idi6--

