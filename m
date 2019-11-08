Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4CF5BD9
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfKHXgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:36:09 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:45175 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfKHXgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:36:08 -0500
Received: by mail-qv1-f67.google.com with SMTP id g12so2887419qvy.12;
        Fri, 08 Nov 2019 15:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tcGQi1qeNTFl6Mm39lu2wcahDWsLQ+5ef1foC5rtSZQ=;
        b=oY3SwnNh0HS7qqdDGei0TfnSOLIFF/98lrlDCpbJ2tazDuBbWjjA8UiboYsJvnUFDd
         oNvqN9qLT9zlzsVF1KUjcvDdkKZk860jGgHCB1ZAm1Lf5b2VcYnHyOnqL2ghkeVreRnv
         Q2MaDlP5mflNX6YauMAopaFZlwfhe0BrOpn8rjRypQfg4IRA+V+0ArZ6wSqdyeNBEBV5
         ovoS1KZArOzB031VeVzfFeyOidMNiofu77RX3S9DTxC2IKP8L2eWSPoFW0+9+Jc5cJc2
         8j7lU+I2H1UbwTUB0GE2px82UWAFi9ZNv2ftR6CDlppkUGn2Vrswc3i9tyRFASHy7bKZ
         gQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tcGQi1qeNTFl6Mm39lu2wcahDWsLQ+5ef1foC5rtSZQ=;
        b=mzTcxdH6K3D1marQiQa0zcO5LGWpW5i5rCRTU88Xv/moyUFA79NfgR5Qo99h4cnmEO
         OldLztBiaj9IQXMcort9tebKC1mKjqmB2V83Pybccpi1mEbApefjNeYX2/ClGIZuthuS
         Lld0kN5qbrwYvUKyV1IePijRkelG04ydonLtJZ42n0QkySrtecc4xfAP1uwK5y5KCmOf
         61IhZiiNe8RqCpC7HvZQB+lni5cFDUNp9RuqaT1s0ZmSCLlrdvnnoTpcFsPhJJXM91Mk
         cwk0YpHy6QwE7ZJRVTb3r6MvIRY7RI6TGBCZjR+6KQt/CSSxKUVzjQ3IL+ADQLkikkTI
         BcUw==
X-Gm-Message-State: APjAAAWBejHuk8SNxeMpg8t75yD7pW8bVkEA6HiM88BDoOL7obbwi5Xl
        fbcuBHM7/Ej8dJg+3aeIcjAgjwLfV7Cq33rN4ZqK5mYg
X-Google-Smtp-Source: APXvYqzCb6DrP4h4BObvuG25S9OoYeZP2wPTcVlDksCoyph44gMsV1vIEp6xfSbbmK95uMsu6anl/u3IYKOSjRRxPMA=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr12310283qvb.224.1573256167193;
 Fri, 08 Nov 2019 15:36:07 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
 <157324878624.910124.5124587166846797199.stgit@toke.dk> <CAEf4BzbqwpxtDRkYZLNsM7POc9WHAVpM-vvMX5jnEtYUV2PQaA@mail.gmail.com>
 <87pni2q6yi.fsf@toke.dk>
In-Reply-To: <87pni2q6yi.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 15:35:56 -0800
Message-ID: <CAEf4BzZSfj98sd=16F4q5m5q0rYbVwsB2L96mmWdTJdAFhix3Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] libbpf: Unpin auto-pinned maps if loading fails
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 3:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> Since the automatic map-pinning happens during load, it will leave pin=
ned
> >> maps around if the load fails at a later stage. Fix this by unpinning =
any
> >> pinned maps on cleanup. To avoid unpinning pinned maps that were reuse=
d
> >> rather than newly pinned, add a new boolean property on struct bpf_map=
 to
> >> keep track of whether that map was reused or not; and only unpin those=
 maps
> >> that were not reused.
> >>
> >> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BP=
F objects")
> >> Acked-by: Song Liu <songliubraving@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c |   16 +++++++++++++---
> >>  1 file changed, 13 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index be4af95d5a2c..cea61b2ec9d3 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -229,6 +229,7 @@ struct bpf_map {
> >>         enum libbpf_map_type libbpf_type;
> >>         char *pin_path;
> >>         bool pinned;
> >> +       bool was_reused;
> >
> > nit: just reused, similar to pinned?
> >
> >>  };
> >>
> >>  struct bpf_secdata {
> >> @@ -1995,6 +1996,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int f=
d)
> >>         map->def.map_flags =3D info.map_flags;
> >>         map->btf_key_type_id =3D info.btf_key_type_id;
> >>         map->btf_value_type_id =3D info.btf_value_type_id;
> >> +       map->was_reused =3D true;
> >>
> >>         return 0;
> >>
> >> @@ -4007,15 +4009,18 @@ bpf_object__open_buffer(const void *obj_buf, s=
ize_t obj_buf_sz,
> >>         return bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
> >>  }
> >>
> >> -int bpf_object__unload(struct bpf_object *obj)
> >> +static int __bpf_object__unload(struct bpf_object *obj, bool unpin)
> >>  {
> >>         size_t i;
> >>
> >>         if (!obj)
> >>                 return -EINVAL;
> >>
> >> -       for (i =3D 0; i < obj->nr_maps; i++)
> >> +       for (i =3D 0; i < obj->nr_maps; i++) {
> >>                 zclose(obj->maps[i].fd);
> >> +               if (unpin && obj->maps[i].pinned && !obj->maps[i].was_=
reused)
> >> +                       bpf_map__unpin(&obj->maps[i], NULL);
> >> +       }
> >>
> >>         for (i =3D 0; i < obj->nr_programs; i++)
> >>                 bpf_program__unload(&obj->programs[i]);
> >> @@ -4023,6 +4028,11 @@ int bpf_object__unload(struct bpf_object *obj)
> >>         return 0;
> >>  }
> >>
> >> +int bpf_object__unload(struct bpf_object *obj)
> >> +{
> >> +       return __bpf_object__unload(obj, false);
> >> +}
> >> +
> >>  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
> >>  {
> >>         struct bpf_object *obj;
> >> @@ -4047,7 +4057,7 @@ int bpf_object__load_xattr(struct bpf_object_loa=
d_attr *attr)
> >>
> >>         return 0;
> >>  out:
> >> -       bpf_object__unload(obj);
> >> +       __bpf_object__unload(obj, true);
> >
> > giving this is the only (special) case of auto-unpinning auto-pinned
> > maps, why not do a trivial loop here, instead of having this extra
> > unpin flag and extra __bpf_object__unload function?
>
> Oh, you mean just do a loop in addition to the call to __unload? Sure, I
> guess we can do that instead...

I think that's cleaner, because it's custom clean up logic in one
place, rather than supported feature of unload.

>
> -Toke
