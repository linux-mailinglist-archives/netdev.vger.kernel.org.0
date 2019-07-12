Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D490A67288
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfGLPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:36:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35539 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGLPgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:36:35 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so8525829qto.2;
        Fri, 12 Jul 2019 08:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RrvS7bEh76/zJeNy/Nf4LO9s3z7qhZywLwmks5DUWmQ=;
        b=AhITGNctYGSoHOhZTcOK0YFmZWw1m7te6syOFq6juFeKFaiSIuAQgjp8Hzpng7XeRl
         qzy5pPUsu/hAJI99Kf/IJaD5k6LcsXl3Xzao88FHRgzYJV294893ffgJnyK0YZJRSNvy
         OGCVW/b1SbKAM9fUSRWwKkVyWPj3+rdSIN2lDAv+r3jxkpY/SDzq4eOhybwD/x3jcMZ9
         ALFIosAjSrEyN7p2IvoD56ojQ3YlGHv8K2gTvdBiJYTaiwnEBW2BIORLcNRI4Tqq+YfP
         Nfrf+rvTxZdHjA62ry3iVeFHsY5FcioJ/I+fqb844nqUgH38vG/RDtT/mTHmItSWsGYZ
         L5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RrvS7bEh76/zJeNy/Nf4LO9s3z7qhZywLwmks5DUWmQ=;
        b=YX/NY7JFkiFlXwSV8clzkOcJVCW2VNFDn2IUjE3N2zJ7TlNynA0U0MIkOxnL1o9jdb
         K6m3/a/rGesBKpxHNCXeBjm+VgcTR/Dt+4m3UyK6J4BBXZkAqlNC/AWcpwbufcXMFZ6a
         BVhvi4jr3OE88bgEP5dweNlFxa22kyNfu/h2n/v1oMmzrBzXDYzmegmWouVqdBrDqbhS
         CEvgYgl5o76LseBYG4DCU8c3ElXdxrNDKuWd74p/NYE2oZuf49fBXgijmiJTw9Krju4Q
         kk8eyUK7Qarmu0F4yHWzfQjLfjQRWW2nHC+V1e5gKKOE8+ca8RHoMhIrnOUWRaWHGBNj
         SX8Q==
X-Gm-Message-State: APjAAAWSN6JOX4UCCDBuXAuo7VSsWgE5Rie9foze35zJ8+oJ12QNYMDb
        yaR6lvmIPQey1IW1oPmgR9y4BVXq+OwCdC3b2pg=
X-Google-Smtp-Source: APXvYqzW96KoNS3t3yhDF4pqgpcOjFOFWrszWiWAD0q9GPUG/nXxM4Z0zP9F/WvDLVYTmQdMFR60zL55FTRR1swqTKE=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr7149946qvh.150.1562945794317;
 Fri, 12 Jul 2019 08:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190711065307.2425636-1-andriin@fb.com> <20190711065307.2425636-2-andriin@fb.com>
 <ad29872e-a127-f21e-5581-03df5a388a55@fb.com>
In-Reply-To: <ad29872e-a127-f21e-5581-03df5a388a55@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 08:36:23 -0700
Message-ID: <CAEf4Bzb4vzwRVPegF51Kv6oqTXUAWqnhK-jAVs8SESyh74+XTA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution logic
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 10:59 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/19 11:53 PM, Andrii Nakryiko wrote:
> > BTF verifier has a size resolution bug which in some circumstances leads to
> > invalid size resolution for, e.g., TYPEDEF modifier.  This happens if we have
> > [1] PTR -> [2] TYPEDEF -> [3] ARRAY, in which case due to being in pointer
> > context ARRAY size won't be resolved (because for pointer it doesn't matter, so
> > it's a sink in pointer context), but it will be permanently remembered as zero
> > for TYPEDEF and TYPEDEF will be marked as RESOLVED. Eventually ARRAY size will
> > be resolved correctly, but TYPEDEF resolved_size won't be updated anymore.
> > This, subsequently, will lead to erroneous map creation failure, if that
> > TYPEDEF is specified as either key or value, as key_size/value_size won't
> > correspond to resolved size of TYPEDEF (kernel will believe it's zero).
> >
> > Note, that if BTF was ordered as [1] ARRAY <- [2] TYPEDEF <- [3] PTR, this
> > won't be a problem, as by the time we get to TYPEDEF, ARRAY's size is already
> > calculated and stored.
> >
> > This bug manifests itself in rejecting BTF-defined maps that use array
> > typedef as a value type:
> >
> > typedef int array_t[16];
> >
> > struct {
> >      __uint(type, BPF_MAP_TYPE_ARRAY);
> >      __type(value, array_t); /* i.e., array_t *value; */
> > } test_map SEC(".maps");
> >
> > The fix consists on not relying on modifier's resolved_size and instead using
> > modifier's resolved_id (type ID for "concrete" type to which modifier
> > eventually resolves) and doing size determination for that resolved type. This
> > allow to preserve existing "early DFS termination" logic for PTR or
> > STRUCT_OR_ARRAY contexts, but still do correct size determination for modifier
> > types.
> >
> > Fixes: eb3f595dab40 ("bpf: btf: Validate type reference")
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   kernel/bpf/btf.c | 14 ++++++++++----
> >   1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index cad09858a5f2..22fe8b155e51 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -1073,11 +1073,18 @@ const struct btf_type *btf_type_id_size(const struct btf *btf,
> >                                !btf_type_is_var(size_type)))
> >                       return NULL;
> >
> > -             size = btf->resolved_sizes[size_type_id];
> >               size_type_id = btf->resolved_ids[size_type_id];
> >               size_type = btf_type_by_id(btf, size_type_id);
> >               if (btf_type_nosize_or_null(size_type))
> >                       return NULL;
> > +             else if (btf_type_has_size(size_type))
> > +                     size = size_type->size;
> > +             else if (btf_type_is_array(size_type))
> > +                     size = btf->resolved_sizes[size_type_id];
> > +             else if (btf_type_is_ptr(size_type))
> > +                     size = sizeof(void *);
> > +             else
> > +                     return NULL;
>
> Looks good to me. Not sure whether we need to do any adjustment for
> var kind or not. Maybe we can do similar change in btf_var_resolve()

I don't think btf_var_resolve() needs any change. btf_var_resolve
can't be referenced by modifier, so it doesn't have any problem. It's
similar to array in that it's size will be determined correctly.

But I think btf_type_id_size() doesn't handle var case correctly, I'll do

+             else if (btf_type_is_array(size_type) ||
btf_type_is_var(size_type))
+                     size = btf->resolved_sizes[size_type_id];

to fix that.

> to btf_modifier_resolve()? But I do not think it impacts correctness
> similar to btf_modifier_resolve() below as you changed
> btf_type_id_size() implementation in the above.
>
> >       }
> >
> >       *type_id = size_type_id;
> > @@ -1602,7 +1609,6 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >       const struct btf_type *next_type;
> >       u32 next_type_id = t->type;
> >       struct btf *btf = env->btf;
> > -     u32 next_type_size = 0;
> >
> >       next_type = btf_type_by_id(btf, next_type_id);
> >       if (!next_type || btf_type_is_resolve_source_only(next_type)) {
> > @@ -1620,7 +1626,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >        * save us a few type-following when we use it later (e.g. in
> >        * pretty print).
> >        */
> > -     if (!btf_type_id_size(btf, &next_type_id, &next_type_size)) {
> > +     if (!btf_type_id_size(btf, &next_type_id, NULL)) {
> >               if (env_type_is_resolved(env, next_type_id))
> >                       next_type = btf_type_id_resolve(btf, &next_type_id);
> >
> > @@ -1633,7 +1639,7 @@ static int btf_modifier_resolve(struct btf_verifier_env *env,
> >               }
> >       }
> >
> > -     env_stack_pop_resolved(env, next_type_id, next_type_size);
> > +     env_stack_pop_resolved(env, next_type_id, 0);
> >
> >       return 0;
> >   }
> >
