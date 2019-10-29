Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733E3E8F12
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfJ2SNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:13:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39312 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730417AbfJ2SNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:13:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id t8so21585101qtc.6;
        Tue, 29 Oct 2019 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wOUGHyZJSqHSdDOp6Oe0hXLgA63blFUIb0ipoUBNEmg=;
        b=J5jgWLEW8NrsY4XZo+ZHNhe2TD3BMlshfH/IDTMp5h2j+a0lK8GLUnyaNBvYGkD0X2
         Xaa/ZWZqU7N6s/ushVas7qwq+2QbskTYFMJi7HcoVWVK2TMepHG8sfDSFcyx+XcJw8fh
         V66yZbZdjFbHnm72WJdu77WhsYopBOjJGCG2u4CchZBBO/2nhkFYwA411kL5gLWgCnnY
         np27h9ceQ3xlF1aL8a6/9YRcXGWxZpQ0l/sMrmYWVh2F7gUTdPcElszuWIOMvPOcfG+S
         +cQyVRRRAgi6lKR+/tIhbuss+QlFIEQ9ezUspyfgyK8IUMd0TRc8uO9Q54K91Yhv8Z7A
         2yUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wOUGHyZJSqHSdDOp6Oe0hXLgA63blFUIb0ipoUBNEmg=;
        b=IMOuJ0KpfphvfJYvDujiRwpNtE9r4ciVBUfPi68FpTQ0kyjTs7v2ilIrCoAS9mrl++
         a0H0NmpSCgmcQztkfQ4JPRcLap4Ui2ywCu92Ti4+CbIZfMy+XgW/OgYk0f5NMBsn3bXD
         lNxVtQ8uabTcxuzl/BmssOUkZGeDbq9qDalEyRM09w9kGu468OXpW3E6E8+zUYbjgaAJ
         Xsdc4/e7nQ7EQZzsdbwBG3NMOf35SXLsbhbrEKqD3WYxQSWN0Qqqe5/2hrjGJjoKLJ9o
         zeI9inSMXeG5IDK1OBjFtlXhaMSP7ijmnbw8Cig2woe5oSTseiZ4VW/rQbwAskaK6SSU
         x9WQ==
X-Gm-Message-State: APjAAAX23lhcHbqGKlLYMMN2y6QmleoKWGjlYYhPlsz5hzYA/6jc5lId
        maUiyJCc8DxorXn3V4psDvKeamPg59Nm5PrADzY=
X-Google-Smtp-Source: APXvYqxn+aNwQhNzlP5TYj078aonMbgx7dDcB4vzU63NP/PXlYLijV3g0UDzo+3f0hGqnzWkWzuKRnK4qA2errbxGgM=
X-Received: by 2002:ad4:4e4a:: with SMTP id eb10mr16456355qvb.228.1572372795743;
 Tue, 29 Oct 2019 11:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959873.48922.4763375792594816553.stgit@toke.dk> <CAEf4BzYoEPKNFnzOEAhhE2w=U11cYfTN4o_23kjzY4ByEt5y-g@mail.gmail.com>
 <877e4nsxth.fsf@toke.dk>
In-Reply-To: <877e4nsxth.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Oct 2019 11:13:04 -0700
Message-ID: <CAEf4BzZe6h=0KN+uWdKcGU5VoRDDsvjNzyqh0=aT1u+EvT1x_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/4] libbpf: Add auto-pinning of maps when
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

On Tue, Oct 29, 2019 at 2:30 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sun, Oct 27, 2019 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> This adds support to libbpf for setting map pinning information as par=
t of
> >> the BTF map declaration, to get automatic map pinning (and reuse) on l=
oad.
> >> The pinning type currently only supports a single PIN_BY_NAME mode, wh=
ere
> >> each map will be pinned by its name in a path that can be overridden, =
but
> >> defaults to /sys/fs/bpf.
> >>
> >> Since auto-pinning only does something if any maps actually have a
> >> 'pinning' BTF attribute set, we default the new option to enabled, on =
the
> >> assumption that seamless pinning is what most callers want.
> >>
> >> When a map has a pin_path set at load time, libbpf will compare the ma=
p
> >> pinned at that location (if any), and if the attributes match, will re=
-use
> >> that map instead of creating a new one. If no existing map is found, t=
he
> >> newly created map will instead be pinned at the location.
> >>
> >> Programs wanting to customise the pinning can override the pinning pat=
hs
> >> using bpf_map__set_pin_path() before calling bpf_object__load() (inclu=
ding
> >> setting it to NULL to disable pinning of a particular map).
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/lib/bpf/bpf_helpers.h |    6 ++
> >>  tools/lib/bpf/libbpf.c      |  142 ++++++++++++++++++++++++++++++++++=
++++++++-
> >>  tools/lib/bpf/libbpf.h      |   11 +++
> >>  3 files changed, 154 insertions(+), 5 deletions(-)
> >>
> >
> > [...]
> >
> >>
> >> -static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed=
_maps)
> >> +static int bpf_object__build_map_pin_paths(struct bpf_object *obj,
> >> +                                          const char *path)
> >> +{
> >> +       struct bpf_map *map;
> >> +
> >> +       if (!path)
> >> +               path =3D "/sys/fs/bpf";
> >> +
> >> +       bpf_object__for_each_map(map, obj) {
> >> +               char buf[PATH_MAX];
> >> +               int err, len;
> >> +
> >> +               if (map->pinning !=3D LIBBPF_PIN_BY_NAME)
> >> +                       continue;
> >
> > still think it's better be done from map definition parsing code
> > instead of a separate path, which will ignore most of maps anyways (of
> > course by extracting this whole buffer creation logic into a
> > function).
>
> Hmm, okay, can do that. I think we should still store the actual value
> of the 'pinning' attribute, though; and even have a getter for it. The
> app may want to do something with that information instead of having to
> infer it from map->pin_path. Certainly when we add other values of the
> pinning attribute, but we may as well add the API to get the value
> now...

Let's now expose more stuff than what we need to expose. If we really
will have a need for that, it's really easy to add. Right now you
won't even need to store pinning attribute in bpf_map, because you'll
be just setting proper pin_path in init_user_maps(), as suggested
above.

>
> >> +
> >> +               len =3D snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map=
__name(map));
> >> +               if (len < 0)
> >> +                       return -EINVAL;
> >> +               else if (len >=3D PATH_MAX)
> >
> > [...]
> >
> >>         return 0;
> >>  }
> >>
> >> +static bool map_is_reuse_compat(const struct bpf_map *map,
> >> +                               int map_fd)
> >
> > nit: this should fit on single line?
> >
> >> +{
> >> +       struct bpf_map_info map_info =3D {};
> >> +       char msg[STRERR_BUFSIZE];
> >> +       __u32 map_info_len;
> >> +
> >> +       map_info_len =3D sizeof(map_info);
> >> +
> >> +       if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len)) =
{
> >> +               pr_warn("failed to get map info for map FD %d: %s\n",
> >> +                       map_fd, libbpf_strerror_r(errno, msg, sizeof(m=
sg)));
> >> +               return false;
> >> +       }
> >> +
> >> +       return (map_info.type =3D=3D map->def.type &&
> >> +               map_info.key_size =3D=3D map->def.key_size &&
> >> +               map_info.value_size =3D=3D map->def.value_size &&
> >> +               map_info.max_entries =3D=3D map->def.max_entries &&
> >> +               map_info.map_flags =3D=3D map->def.map_flags &&
> >> +               map_info.btf_key_type_id =3D=3D map->btf_key_type_id &=
&
> >> +               map_info.btf_value_type_id =3D=3D map->btf_value_type_=
id);
> >
> > If map was pinned by older version of the same app, key and value type
> > id are probably gonna be different, even if the type definition itself
> > it correct. We probably shouldn't check that?
>
> Oh, I thought the type IDs would stay relatively stable. If not then I
> agree that we shouldn't be checking them here. Will fix.

type IDs are just an ordered index of a type, as generated by Clang.
No stability guarantees. Just adding extra typedef somewhere in
unrelated type might shift all the type IDs around.

>
> >> +}
> >> +
> >> +static int
> >> +bpf_object__reuse_map(struct bpf_map *map)
> >> +{
> >> +       char *cp, errmsg[STRERR_BUFSIZE];
> >> +       int err, pin_fd;
> >> +
> >> +       pin_fd =3D bpf_obj_get(map->pin_path);
> >> +       if (pin_fd < 0) {
> >> +               if (errno =3D=3D ENOENT) {
> >> +                       pr_debug("found no pinned map to reuse at '%s'=
\n",
> >> +                                map->pin_path);
> >> +                       return 0;
> >> +               }
> >> +
> >> +               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg)=
);
> >> +               pr_warn("couldn't retrieve pinned map '%s': %s\n",
> >> +                       map->pin_path, cp);
> >> +               return -errno;
> >
> > store errno locally
>
> *shrugs* okay, if you insist...

I guess I do insist on correct handling of errno, instead of
potentially returning garbage value from some unrelated syscall from
inside of pr_warn's user-provided callback.

Even libbpf_strerror_r can garble errno (e.g., through its strerror_r
call), so make sure you store it before passing into
libbpf_strerror_r().

>
> >> +       }
> >> +
> >> +       if (!map_is_reuse_compat(map, pin_fd)) {
> >> +               pr_warn("couldn't reuse pinned map at '%s': "
> >> +                       "parameter mismatch\n", map->pin_path);
> >> +               close(pin_fd);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       err =3D bpf_map__reuse_fd(map, pin_fd);
> >> +       if (err) {
> >> +               close(pin_fd);
> >> +               return err;
> >> +       }
> >> +       map->pinned =3D true;
> >> +       pr_debug("reused pinned map at '%s'\n", map->pin_path);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >
> > [...]
> >
> >> +enum libbpf_pin_type {
> >> +       LIBBPF_PIN_NONE,
> >> +       /* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) *=
/
> >> +       LIBBPF_PIN_BY_NAME,
> >> +};
> >> +
> >>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const cha=
r *path);
> >
> > pin_maps should take into account opts->auto_pin_path, shouldn't it?
> >
> > Which is why I also think that auto_pin_path is bad name, because it's
> > not only for auto-pinning, it's a pinning root path, so something like
> > pin_root_path or just pin_root is better and less misleading name.
>
> I view auto_pin_path as something that is used specifically for the
> automatic pinning based on the 'pinning' attribute. Any other use of
> pinning is for custom use and the user can pass a custom pin path to
> those functions.

What's the benefit of restricting it to just this use case? If app
wants to use something other than /sys/fs/bpf as a default root path,
why would that be restricted only to auto-pinned maps? It seems to me
that having set this on bpf_object__open() and then calling
bpf_object__pin_maps(NULL) should just take this overridden root path
into account. Isn't that a logical behavior?
