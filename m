Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8444443ADE0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 10:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhJZIUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 04:20:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233740AbhJZIUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 04:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635236303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nX6P2vPwnb96lf0y4PA5FIFAX54BW+MBp9F/NDzRo+Q=;
        b=XUQ2Cn1TBRoRWZBri8PcslOHOfKSLL4fIYo2/3qqI+be/L46Q1P0Cx7QBCR35EN17da6lq
        UxwG+Avuhq88UM2aEEVfHJvIZB9FZtvSRxtGVvi5Kznp4x3WO5sLRG2Vlvp6hX8jROyna3
        13DFAR2fT97qWlsxbTmzC/c548uv63c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-Y4P77qk-OROsfe274839Uw-1; Tue, 26 Oct 2021 04:18:22 -0400
X-MC-Unique: Y4P77qk-OROsfe274839Uw-1
Received: by mail-ed1-f72.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso9617817edb.7
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 01:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nX6P2vPwnb96lf0y4PA5FIFAX54BW+MBp9F/NDzRo+Q=;
        b=Tl45dkhO1TTE7om4vn/UjD3yVHbTDaVk/knLbI7VZBwXnZKQjLVKf4WCfdJ8ib3SSV
         e5bVc9STwmeU0SQQY9ggAPhxrq59ZHB1LFq8HWx4aZ6zra9Yk0bh3aAXHM0cLpIJxCrU
         f3JoJb10GqaSG6xI4hX4igcXmA99AdQlBjOPA7vf761TNIf/FWi5EcXuhFIi71mAJNhx
         xr7TnOLdNMQ4EM+2JjGBSDGYyuirc5OBNT1ZkZn7kPex61tm7aprC81DrgQ0J1mCEAEP
         0cd3N6F9DT4tatLqigxr/iccsF81oJ13b3IX7P92GZNXzW3xecNUmIyL2nW651TNgUP1
         7l+Q==
X-Gm-Message-State: AOAM530lk2kAWC2bwX399uzq/LT3Oc70oeKufguLJ+n59s/uaBNF+3UM
        kYBXiiPSTvWq2xwd61amQxE8/SlnasugIHwKhzlWBbSqDg9OCiGLiqu230gh8KZWvsrtIJumvl5
        oSOp8TxbkeH+WoRQl
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr35356738edw.379.1635236300789;
        Tue, 26 Oct 2021 01:18:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGIRmVkJxzy0xEsKSVcpzQIfnthJICe2xCttVtJhF+kOEgP+VhujoYdKt/HLRNKev62xrZJQ==
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr35356710edw.379.1635236300504;
        Tue, 26 Oct 2021 01:18:20 -0700 (PDT)
Received: from localhost (net-130-25-199-50.cust.vodafonedsl.it. [130.25.199.50])
        by smtp.gmail.com with ESMTPSA id u23sm10309408edr.97.2021.10.26.01.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 01:18:20 -0700 (PDT)
Date:   Tue, 26 Oct 2021 10:18:18 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2] bpf: fix potential race in tail call
 compatibility check
Message-ID: <YXe5yg1G635STsHE@lore-desk>
References: <20211025130809.314707-1-toke@redhat.com>
 <YXa/A4eQhlPPsn+n@lore-desk>
 <c1244c73-bc61-89b8-dca3-f06dca85f64e@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dya8FXOfIi726Ldv"
Content-Disposition: inline
In-Reply-To: <c1244c73-bc61-89b8-dca3-f06dca85f64e@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dya8FXOfIi726Ldv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 10/25/21 4:28 PM, Lorenzo Bianconi wrote:
> > > Lorenzo noticed that the code testing for program type compatibility =
of
> > > tail call maps is potentially racy in that two threads could encounte=
r a
> > > map with an unset type simultaneously and both return true even thoug=
h they
> > > are inserting incompatible programs.
> > >=20
> > > The race window is quite small, but artificially enlarging it by addi=
ng a
> > > usleep_range() inside the check in bpf_prog_array_compatible() makes =
it
> > > trivial to trigger from userspace with a program that does, essential=
ly:
> > >=20
> > >          map_fd =3D bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, 4, 4, 2, =
0);
> > >          pid =3D fork();
> > >          if (pid) {
> > >                  key =3D 0;
> > >                  value =3D xdp_fd;
> > >          } else {
> > >                  key =3D 1;
> > >                  value =3D tc_fd;
> > >          }
> > >          err =3D bpf_map_update_elem(map_fd, &key, &value, 0);
> > >=20
> > > While the race window is small, it has potentially serious ramificati=
ons in
> > > that triggering it would allow a BPF program to tail call to a progra=
m of a
> > > different type. So let's get rid of it by protecting the update with a
> > > spinlock. The commit in the Fixes tag is the last commit that touches=
 the
> > > code in question.
> > >=20
> > > v2:
> > > - Use a spinlock instead of an atomic variable and cmpxchg() (Alexei)
> > >=20
> > > Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
> > > Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> > > ---
> > >   include/linux/bpf.h   |  1 +
> > >   kernel/bpf/arraymap.c |  1 +
> > >   kernel/bpf/core.c     | 14 ++++++++++----
> > >   kernel/bpf/syscall.c  |  2 ++
> > >   4 files changed, 14 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 020a7d5bf470..98d906176d89 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -929,6 +929,7 @@ struct bpf_array_aux {
> > >   	 * stored in the map to make sure that all callers and callees have
> > >   	 * the same prog type and JITed flag.
> > >   	 */
> > > +	spinlock_t type_check_lock;
> >=20
> > I was wondering if we can use a mutex instead of a spinlock here since =
it is
> > run from a syscall AFAIU. The only downside is mutex_lock is run inside
> > aux->used_maps_mutex critical section. Am I missing something?
>=20
> Hm, potentially it could work, but then it's also 32 vs 4 extra bytes. Th=
ere's
> also poke_mutex or freeze_mutex, but feels to hacky to 'generalize for re=
use',
> so I think the spinlock in bpf_array_aux is fine.

I was wondering if in the future we would need to protect something not sup=
ported
by a spinlock but it is probably not the case. I am fine with the spinlock =
:)

Regards,
Lorenzo

>=20
> > >   	enum bpf_prog_type type;
> > >   	bool jited;
> > >   	/* Programs with direct jumps into programs part of this array. */
> > > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > > index cebd4fb06d19..da9b1e96cadc 100644
> > > --- a/kernel/bpf/arraymap.c
> > > +++ b/kernel/bpf/arraymap.c
> > > @@ -1072,6 +1072,7 @@ static struct bpf_map *prog_array_map_alloc(uni=
on bpf_attr *attr)
> > >   	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
> > >   	INIT_LIST_HEAD(&aux->poke_progs);
> > >   	mutex_init(&aux->poke_mutex);
> > > +	spin_lock_init(&aux->type_check_lock);
>=20
> Just as a tiny nit, I would probably name it slightly different, since ty=
pe_check_lock
> mainly refers to the type property but there's also jit vs non-jit and as=
 pointed out
> there could be other extensions that need checking in future as well. May=
be 'compat_lock'
> would be a more generic one or just:
>=20
>         struct {
>                 enum bpf_prog_type type;
>                 bool jited;
>                 spinlock_t lock;
>         } owner;
>=20
> > >   	map =3D array_map_alloc(attr);
> > >   	if (IS_ERR(map)) {
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index c1e7eb3f1876..9439c839d279 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -1823,20 +1823,26 @@ static unsigned int __bpf_prog_ret0_warn(cons=
t void *ctx,
> > >   bool bpf_prog_array_compatible(struct bpf_array *array,
> > >   			       const struct bpf_prog *fp)
> > >   {
> > > +	bool ret;
> > > +
> > >   	if (fp->kprobe_override)
> > >   		return false;
> > > +	spin_lock(&array->aux->type_check_lock);
> > > +
> > >   	if (!array->aux->type) {
> > >   		/* There's no owner yet where we could check for
> > >   		 * compatibility.
> > >   		 */
> > >   		array->aux->type  =3D fp->type;
> > >   		array->aux->jited =3D fp->jited;
> > > -		return true;
> > > +		ret =3D true;
> > > +	} else {
> > > +		ret =3D array->aux->type  =3D=3D fp->type &&
> > > +		      array->aux->jited =3D=3D fp->jited;
> > >   	}
> > > -
> > > -	return array->aux->type  =3D=3D fp->type &&
> > > -	       array->aux->jited =3D=3D fp->jited;
> > > +	spin_unlock(&array->aux->type_check_lock);
> > > +	return ret;
> > >   }
> > >   static int bpf_check_tail_call(const struct bpf_prog *fp)
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index 4e50c0bfdb7d..955011c7df29 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct seq_file =
*m, struct file *filp)
> > >   	if (map->map_type =3D=3D BPF_MAP_TYPE_PROG_ARRAY) {
> > >   		array =3D container_of(map, struct bpf_array, map);
> > > +		spin_lock(&array->aux->type_check_lock);
> > >   		type  =3D array->aux->type;
> > >   		jited =3D array->aux->jited;
> > > +		spin_unlock(&array->aux->type_check_lock);
> > >   	}
> > >   	seq_printf(m,
> > > --=20
> > > 2.33.0
> > >=20
>=20

--Dya8FXOfIi726Ldv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYXe5ygAKCRA6cBh0uS2t
rJxGAP4/Xo5iLd3UqhBPmWl2/MEEBCblfgzISPU3P5dGd9QpXQEAt1zDgk5We2W3
h/07h5te16s1hfg3MD3rubwBgCEAMwg=
=Wfkl
-----END PGP SIGNATURE-----

--Dya8FXOfIi726Ldv--

