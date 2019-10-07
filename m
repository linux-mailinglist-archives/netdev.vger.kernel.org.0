Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95F3CEE9F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfJGVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:51:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34719 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfJGVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:51:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id 3so21600810qta.1;
        Mon, 07 Oct 2019 14:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pqsi1G2S6slzrLepH9uMCQvxopMIQCHLk0pCryMosGY=;
        b=M2p7970rrF+HsYIApS/yOv4+MIwZ/vihJpA0vc2JanFz6mYFxmC4d/jjRZWQR8qNpL
         5SnNHq4PW56VAF4lSn4vcESHhsXbeSYVzvGoLTFaZtWP/9DA0RKi9E1eynmgn5ux8u1q
         4eP/Ul+2Ozloai7+YUqT14FkHajaVRG1rRY5DuB2HP11A7oQi7LGhmjPOZsdI08jKuJD
         hlZJbvaW4GzkAQfZbP8bnLuQiJ4VodTaFPydkD9xQ2eHMkmtva1QgeV8oGMkMATG/hri
         FFBR05Cag4q6w/ddfgqpB3vCuP+j+t+Mqh5zCaoPP6J/KFlqG3bKRDtqdChWzDvYZ7mV
         Y15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pqsi1G2S6slzrLepH9uMCQvxopMIQCHLk0pCryMosGY=;
        b=sYJnSJrHvLagfv7nnLWrJPclvLZadTJmcHSpLYvUWkLfgP08LzKxtQyacPvOOpYOPx
         aJBTXFJkn48cPJfLZgPG9TWkCb0CTB//KfQ7W+pMQaafxO4hIwSDXR01+gPBn733YDB3
         rSUNJ/X3RduGVFBzZxvi/Wt58cG5TvpGBpJTks7uFGOElBnV0xc4YBffG/Wa5dwsCcNU
         +Wd3U1JFtDaef29NX7iBuGfM+gMVY5kRt1iL3kFwheMiErehT9vVC8AY83kkwZwF8fCE
         cXWqCUjdi9hdXiVnQDxgM1vfGin4spWkMhDUEfPmZKGC2D2jnG3jpRMI+YwCyQkZ5QK0
         OHQg==
X-Gm-Message-State: APjAAAUKtz0EupaGNoFLxvfVwCVI2eN4cfc6GaNkWUWZh68TvxJTrjxo
        jvJPXAGoF7t8tgCKSVKLYPS5gf660E9V9ozxD6c=
X-Google-Smtp-Source: APXvYqzBzD2y/IwbzzyUS7Z+g7NivW1xfuNgeV2DyQXI0dRKEFR+AKx4dYpI3LQx16V86PkunHN8jxflG4rQI8t0uNM=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr32319071qtn.117.1570485061591;
 Mon, 07 Oct 2019 14:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191007212237.1704211-1-andriin@fb.com> <20191007214650.GC2096@mini-arch>
In-Reply-To: <20191007214650.GC2096@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 14:50:50 -0700
Message-ID: <CAEf4Bzba7S=hUkxTvL3Y+QYxAxZ-am5w-mzk8Aks7csx-g0FPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 2:46 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/07, Andrii Nakryiko wrote:
> > As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
> > populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
> > was removed from libbpf.h header. This broke bpftool, which relied on
> > that function. This patch fixes the build by switching to newly added
> > bpf_object__open_file() which provides the same capabilities, but is
> > official and future-proof API.
> >
> > Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
> > Reported-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/main.c |  4 ++--
> >  tools/bpf/bpftool/main.h |  2 +-
> >  tools/bpf/bpftool/prog.c | 22 ++++++++++++----------
> >  3 files changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > index 93d008687020..4764581ff9ea 100644
> > --- a/tools/bpf/bpftool/main.c
> > +++ b/tools/bpf/bpftool/main.c
> > @@ -27,7 +27,7 @@ bool json_output;
> >  bool show_pinned;
> >  bool block_mount;
> >  bool verifier_logs;
> > -int bpf_flags;
> > +bool relaxed_maps;
> >  struct pinned_obj_table prog_table;
> >  struct pinned_obj_table map_table;
> >
> > @@ -396,7 +396,7 @@ int main(int argc, char **argv)
> >                       show_pinned = true;
> >                       break;
> >               case 'm':
> > -                     bpf_flags = MAPS_RELAX_COMPAT;
> > +                     relaxed_maps = true;
> >                       break;
> >               case 'n':
> >                       block_mount = true;
> > diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> > index af9ad56c303a..2899095f8254 100644
> > --- a/tools/bpf/bpftool/main.h
> > +++ b/tools/bpf/bpftool/main.h
> > @@ -94,7 +94,7 @@ extern bool json_output;
> >  extern bool show_pinned;
> >  extern bool block_mount;
> >  extern bool verifier_logs;
> > -extern int bpf_flags;
> > +extern bool relaxed_maps;
> >  extern struct pinned_obj_table prog_table;
> >  extern struct pinned_obj_table map_table;
> >
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index 43fdbbfe41bb..8191cd595963 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> >  {
> >       struct bpf_object_load_attr load_attr = { 0 };
> > -     struct bpf_object_open_attr open_attr = {
> > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > -     };
> > +     enum bpf_prog_type prog_type = BPF_PROG_TYPE_UNSPEC;
> >       enum bpf_attach_type expected_attach_type;
> >       struct map_replace *map_replace = NULL;
> >       struct bpf_program *prog = NULL, *pos;
> > @@ -1105,11 +1103,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >       const char *pinfile;
> >       unsigned int i, j;
> >       __u32 ifindex = 0;
> > +     const char *file;
> >       int idx, err;
> >
> > +     LIBBPF_OPTS(bpf_object_open_opts, open_opts,
> > +             .relaxed_maps = relaxed_maps,
> > +     );
> > +
> >       if (!REQ_ARGS(2))
> >               return -1;
> > -     open_attr.file = GET_ARG();
> > +     file = GET_ARG();
> >       pinfile = GET_ARG();
> >
> >       while (argc) {
> > @@ -1118,7 +1121,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >
> >                       NEXT_ARG();
> >
> > -                     if (open_attr.prog_type != BPF_PROG_TYPE_UNSPEC) {
> > +                     if (prog_type != BPF_PROG_TYPE_UNSPEC) {
> >                               p_err("program type already specified");
> >                               goto err_free_reuse_maps;
> >                       }
> > @@ -1135,8 +1138,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >                       strcat(type, *argv);
> >                       strcat(type, "/");
> >
> > -                     err = libbpf_prog_type_by_name(type,
> > -                                                    &open_attr.prog_type,
> > +                     err = libbpf_prog_type_by_name(type, &prog_type,
> >                                                      &expected_attach_type);
> >                       free(type);
> >                       if (err < 0)
> > @@ -1224,16 +1226,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >
> >       set_max_rlimit();
> >
> > -     obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
> > +     obj = bpf_object__open_file(file, &open_opts);
> >       if (IS_ERR_OR_NULL(obj)) {
> >               p_err("failed to open object file");
> >               goto err_free_reuse_maps;
> >       }
> >
> >       bpf_object__for_each_program(pos, obj) {
> > -             enum bpf_prog_type prog_type = open_attr.prog_type;
> > +             enum bpf_prog_type prog_type = prog_type;
> Are you sure it works that way?

Oh, I did this pretty mechanically, didn't notice I'm shadowing. In
either case I'd like to avoid shadowing, so I'll rename one of them,
good catch!

>
> $ cat tmp.c
> #include <stdio.h>
>
> int main()
> {
>         int x = 1;
>         printf("outer x=%d\n", x);
>
>         {
>                 int x = x;
>                 printf("inner x=%d\n", x);
>         }
>
>         return 0;
> }
>
> $ gcc tmp.c && ./a.out
> outer x=1
> inner x=0
>
> Other than that:
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>
> >
> > -             if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
> > +             if (prog_type == BPF_PROG_TYPE_UNSPEC) {
> >                       const char *sec_name = bpf_program__title(pos, false);
> >
> >                       err = libbpf_prog_type_by_name(sec_name, &prog_type,
> > --
> > 2.17.1
> >
