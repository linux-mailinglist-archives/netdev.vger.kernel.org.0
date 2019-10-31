Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BDDEB661
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfJaRw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:52:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36754 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaRw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:52:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id y10so2904959qto.3;
        Thu, 31 Oct 2019 10:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hfk+K9qrWDpBqH3RfKPkhH1YRZ8SGtePqAqPB9mEUPw=;
        b=ZkeKVTwjZkq/UXu8i8FooOCY/KTaDD0T2susibFEABV8dIhn0YUicvQJNG+nu3OwYV
         0aasa0K44LIWvMxeXnO4bXiAC9WJqbWGIE/vms9GALjH1sY4nMdDTOcmGDEbnAeYAdJj
         PZvqy2LCok+PAiFq0O+8wSc4CCcg2UdjRXEHvYe/Y2wxl5NXGJitdDvjmRfO+RUNGCtJ
         0N1Z9LLpd1NxOc8oEoHrYw7qJ20dlVv8PaGx+XCTZaM8ab/g+pbIa2Z7lgZjmbR8SkXb
         OPOdFZhOy/nvQNlEb44y7NplIORlLGjl1AjfBNIFHs/Sc0Zbwj3lbezAhDZgLO8SvqyM
         bFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hfk+K9qrWDpBqH3RfKPkhH1YRZ8SGtePqAqPB9mEUPw=;
        b=avcPnHv8AeRYqb/HCTp/uhKQSJVITKTicf39NP2aw7lXTGuIEvrXsrNRN5lMZFkTEn
         jcysZBt5lvVruJuY57pIVdGv0HVJ1bwZHxekqYpwyGGzTur3fqciEnsCKzW4oEVdYRQz
         J2R+IT0rBxwmgu95yuRBvL6ePPPyRoeX8Nv3KSSfJzarCiKap/98sXD4yWSJm5v4G9ZM
         EQgP7GEjk9Rz8akU+2EunRQ5LHBRq0UBbQYH/nT4keBan1VlZYyTs5JxkxXHiPQ0fw/x
         +hF4g5NmDtnOkBQ8fsejaRc8yOe4Ef6Y5pjC9dgox2fUDwofLYZuWLdW4dx716NxxXDx
         OdMw==
X-Gm-Message-State: APjAAAXfxFent76a18xN8a63O1bZNLtOQRgenk5mj9azoWPgJJVUq9q9
        16IVQ7xFeHlwJ4rFiQzQUsJyg5ihsnBnIfc/hLE=
X-Google-Smtp-Source: APXvYqx8/ZhgVKIxm5NYIUVpL6fc6RKZvqb8MXAWYiAPrz8KKhRVnUuFx2lZy6DSamiGBD6vJUceIJom5N9L7pEd9xw=
X-Received: by 2002:ad4:558e:: with SMTP id e14mr5831258qvx.247.1572544344770;
 Thu, 31 Oct 2019 10:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk>
 <157237796671.169521.11697832576102917566.stgit@toke.dk> <CAEf4BzYsFGm4BzFxcN37KVtjS0Zw0Zgw8on9OsP4_=Stew72Nw@mail.gmail.com>
In-Reply-To: <CAEf4BzYsFGm4BzFxcN37KVtjS0Zw0Zgw8on9OsP4_=Stew72Nw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:52:13 -0700
Message-ID: <CAEf4BzZ3Yf4fvM2bo0ES9_NzBgVdhXBkV-u4wbPGrSej+uB4Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/5] libbpf: Add auto-pinning of maps when
 loading BPF objects
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

On Thu, Oct 31, 2019 at 10:37 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > This adds support to libbpf for setting map pinning information as part=
 of
> > the BTF map declaration, to get automatic map pinning (and reuse) on lo=
ad.
> > The pinning type currently only supports a single PIN_BY_NAME mode, whe=
re
> > each map will be pinned by its name in a path that can be overridden, b=
ut
> > defaults to /sys/fs/bpf.
> >
> > Since auto-pinning only does something if any maps actually have a
> > 'pinning' BTF attribute set, we default the new option to enabled, on t=
he
> > assumption that seamless pinning is what most callers want.
> >
> > When a map has a pin_path set at load time, libbpf will compare the map
> > pinned at that location (if any), and if the attributes match, will re-=
use
> > that map instead of creating a new one. If no existing map is found, th=
e
> > newly created map will instead be pinned at the location.
> >
> > Programs wanting to customise the pinning can override the pinning path=
s
> > using bpf_map__set_pin_path() before calling bpf_object__load() (includ=
ing
> > setting it to NULL to disable pinning of a particular map).
> >
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
>
> Please fix unconditional pin_path setting, with that:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  tools/lib/bpf/bpf_helpers.h |    6 ++
> >  tools/lib/bpf/libbpf.c      |  144 +++++++++++++++++++++++++++++++++++=
++++++--
> >  tools/lib/bpf/libbpf.h      |   13 ++++
> >  3 files changed, 154 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 2203595f38c3..0c7d28292898 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -38,4 +38,10 @@ struct bpf_map_def {
> >         unsigned int map_flags;
> >  };
> >
>
> [...]
>
> > @@ -1270,6 +1292,28 @@ static int bpf_object__init_user_btf_map(struct =
bpf_object *obj,
> >                         }
> >                         map->def.value_size =3D sz;
> >                         map->btf_value_type_id =3D t->type;
> > +               } else if (strcmp(name, "pinning") =3D=3D 0) {
> > +                       __u32 val;
> > +                       int err;
> > +
> > +                       if (!get_map_field_int(map_name, obj->btf, def,=
 m,
> > +                                              &val))
> > +                               return -EINVAL;
> > +                       pr_debug("map '%s': found pinning =3D %u.\n",
> > +                                map_name, val);
> > +
> > +                       if (val !=3D LIBBPF_PIN_NONE &&
> > +                           val !=3D LIBBPF_PIN_BY_NAME) {
> > +                               pr_warn("map '%s': invalid pinning valu=
e %u.\n",
> > +                                       map_name, val);
> > +                               return -EINVAL;
> > +                       }
> > +                       err =3D build_map_pin_path(map, pin_root_path);
>
> uhm... only if (val =3D=3D LIBBPF_PIN_BY_NAME)?.. maybe extend tests with
> a mix if auto-pinned and never pinned map to catch issue like this?

I was wondering why your selftest didn't catch this, got puzzled for a
bit. It's because this code path will be executed only when map
defintion has __uint(pinning, LIBBPF_PIN_NONE), can you please add
that to selftest as well?

>
> > +                       if (err) {
> > +                               pr_warn("map '%s': couldn't build pin p=
ath.\n",
> > +                                       map_name);
> > +                               return err;
> > +                       }
> >                 } else {
> >                         if (strict) {
> >                                 pr_warn("map '%s': unknown field '%s'.\=
n",
> > @@ -1289,7 +1333,8 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
> >         return 0;
> >  }
> >
>
> [...]
