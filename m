Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181187B66A
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 01:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfG3Xzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 19:55:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43357 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfG3Xzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 19:55:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so20468020qto.10;
        Tue, 30 Jul 2019 16:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAS1jR9kQ+jEv6874mbWddUX6IcIjaF90D5mmnAcTdI=;
        b=gdhtLJ0wPb0aImm55wIJI4nBZspTFRnuQ0LeH7l2JGMXAuTJLYJB9B/XIKpyWQwfkz
         LGx1kqbLtNfxxKPrDmirf5vg+0avq1++vqTAemgyDeHD1w2I+KQ55/NAiIDvRGz1eiAw
         dLfLrBtFO8glVswLHEom3i8zq78shvyyUX4KgqQej1us4oWrRWCMhx3yWCCge6yawtHk
         WWuaMRKeeW/BPk8Y+860BPmMET6+nlp4JU4pT5/SKF5JnV8IWTADnJMwASHf1LRFz02v
         P919toyIG2TvLl+/QxAstmuFegYTnTlviBXm3E1yAmyyErosqlRLV7FvCuO5cgWBkBe2
         3iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAS1jR9kQ+jEv6874mbWddUX6IcIjaF90D5mmnAcTdI=;
        b=Ik4MQlVSkyrN242AaPGpJJO/Y5E5rWNUHcXIUw6SphY5IcB6hcGij4dFdgRYVeqthM
         8qtlxMZYnVFbj4R9klNgaJvzpngQmf0kYOq1JXiwgYvtyjmqSbroXIRvnEqbZm2f198K
         I7vfjUot+7PFNhW/90kh1a+BFZrVj7E8SptmZuLU6C+QlCSvarDmbtH4PwsPCj6Ex444
         /4dUfY2BiXr24WfQSvUuCHLvMYKr1HFguQNa0vUfQVb3uf2j+rbcgiIFgtqD3DQuIBqI
         kOzb63P6AbJJBQhGZb2dJpNVvlhnD+q7ma57GWJqhvg0nEik3hf2j6ltKcCMV78EVoP6
         Ms8g==
X-Gm-Message-State: APjAAAUPjNdscg+cV9j3/M3dj4fjZZnyv6HDqhDHU6fRBzuiMN+Q7saj
        B1TRegPmG3JloO+pUChDOQ1Nbpxp+fzoH864+aI=
X-Google-Smtp-Source: APXvYqwflKyCUa/RbF7eUC4qlIg5/U7e5e2aHpbvXfuF/UWaUZJAGAzAwRAfDrUxnQK/dqwdmaeCcGbZuKh/d6HLPaE=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr80988932qty.141.1564530953721;
 Tue, 30 Jul 2019 16:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190730195408.670063-1-andriin@fb.com> <20190730195408.670063-3-andriin@fb.com>
 <9C1CFF6F-F661-46F4-B6EB-B42D7F4204F0@fb.com>
In-Reply-To: <9C1CFF6F-F661-46F4-B6EB-B42D7F4204F0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jul 2019 16:55:42 -0700
Message-ID: <CAEf4BzZpcP1aBwrz8DbToQ=nVUukPwiG-PBCFGZNb2wXg_msnA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 4:44 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch implements the core logic for BPF CO-RE offsets relocations.
> > Every instruction that needs to be relocated has corresponding
> > bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> > to match recorded "local" relocation spec against potentially many
> > compatible "target" types, creating corresponding spec. Details of the
> > algorithm are noted in corresponding comments in the code.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 915 ++++++++++++++++++++++++++++++++++++++++-
> > tools/lib/bpf/libbpf.h |   1 +
> > 2 files changed, 909 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ead915aec349..75da90928257 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -38,6 +38,7 @@

[...]

> >
> > -static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > -                                                  __u32 id)
> > +static const struct btf_type *
> > +skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
> > {
> >       const struct btf_type *t = btf__type_by_id(btf, id);
> >
> > +     if (res_id)
> > +             *res_id = id;
> > +
> >       while (true) {
> >               switch (BTF_INFO_KIND(t->info)) {
> >               case BTF_KIND_VOLATILE:
> >               case BTF_KIND_CONST:
> >               case BTF_KIND_RESTRICT:
> >               case BTF_KIND_TYPEDEF:
> > +                     if (res_id)
> > +                             *res_id = t->type;
> >                       t = btf__type_by_id(btf, t->type);
>
> So btf->types[*res_id] == retval, right? Then with retval and btf, we can
> calculate *res_id without this change?

Unless I'm missing something very clever here, no. btf->types is array
of pointers (it's an index into a variable-sized types). This function
returns `struct btf_type *`, which is one of the **values** stored in
that array. You are claiming that by having value of one of array
elements you can easily find element's index? If it was possible to do
in O(1), we wouldn't have so many algorithms and data structures for
search and indexing. You can do that only with linear search, not some
clever pointer arithmetic or at least binary search. So I'm not sure
what you are proposing here...

The way BTF is defined, struct btf_type doesn't know its own type ID,
which is often inconvenient and requires to keep track of that ID, if
it's necessary, but that's how it is.

But then again, what are we trying to achieve here? Eliminate
returning id and pointer? I could always return id and easily look up
pointer, but having both is super convenient and makes code simpler
and shorter, so I'd like to keep it.

>
> >                       break;
> >               default:
> > @@ -1044,7 +1051,7 @@ static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > static bool get_map_field_int(const char *map_name, const struct btf *btf,
> >                             const struct btf_type *def,
> >                             const struct btf_member *m, __u32 *res) {

[...]
