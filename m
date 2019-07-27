Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087AC77729
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 08:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfG0GL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 02:11:29 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35063 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG0GL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 02:11:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so54834534qto.2;
        Fri, 26 Jul 2019 23:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wluhtSKubNCYINHo+nmcEwn0OtULGh8UQPT/LTCB80k=;
        b=SgZu/RUy/6wDvqwfCyy8YEiQoWDu6k1gGYEgjmiXhsyaUhBUguFwM6Yj5EOMUBantJ
         5P+WPXVfQ6Y5/Tl2WaqSzcY8d+8lbigcpjcijvWvYftKSAmXSH23Nt59cntNrDmKuk95
         VzrpT28GrR1k6YMe+Jcg7rnVsR7dw8IQUmTd3kTcALyN4vr1HaZQirAPg2Yn18eXkGzI
         E4lDI0JtovjtGBuUMJCI8X63CxklGkf5QYS+py67CLmPXiduvlnWafd+2X20VDdbaovC
         g+45yetBbTfKL1lxaVj8wKlzOKr8VySWUtRTi9iNJA8dzOzUeN37ycL9e+wvK46R94Qh
         L/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wluhtSKubNCYINHo+nmcEwn0OtULGh8UQPT/LTCB80k=;
        b=oP7Og55FoXTC7h5sSWtVG6KiHJovX/5OhRK9PkPPsJg1k9+v4VY8mG/CCB+iyDWOnG
         IzE1e59Uus4PmPHdQ7QuFdjMjYho+Q3t3zPHoixyMiLWcIuP4Pg5qjfFqY1qriig1+48
         4LvM3vQq8xpCNpzpnLwKGDAx2+QuTAMgHkEyTviTfh+JXeUaMktdPJVco2Ob/DKtKIiD
         YeKjyUoaKFD2V2EMbyGMiN1EZreAylx2y2CC3BeFSQmlAnpvHidWBMFPl+C7zBm1AKRX
         /n3y8p0VPHi/nONcSf5C61zCYBkYp49MhP0KkTBloA08YC62WOQOoneXei4c1ETANOxP
         G2wQ==
X-Gm-Message-State: APjAAAXdRnO7BeCUDeMYvUL8q94uk6cGhpG3lUkBoHGC8FDYiuXPAgxT
        Eq8z3r+OAH8nw2rpTDwDodIv+h/JClOf6JFHQHA=
X-Google-Smtp-Source: APXvYqyzCYaFfrtrRb4laNhb4JTJzbl6h5n8c0qD2YL4MquiqZTk+Lzv698HrKywjyDKuIYW7OoCB76/sUVDF3kHvpQ=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr72392547qvv.38.1564207887714;
 Fri, 26 Jul 2019 23:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-3-andriin@fb.com>
 <2D563869-72E5-4623-B239-173EE2313084@fb.com>
In-Reply-To: <2D563869-72E5-4623-B239-173EE2313084@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 23:11:16 -0700
Message-ID: <CAEf4BzZKA29xudKC8WWEXJq+egTCgX4bV9KaE0Y+_u50=D70iQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 12:32 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch implements the core logic for BPF CO-RE offsets relocations.
> > All the details are described in code comments.
>
> Some description in the change log is still useful. Please at least
> copy-paste key comments here.

OK, will add some more.

>
> And, this is looooong. I think it is totally possible to split it into
> multiple smaller patches.

I don't really know how to split it further without hurting reviewing
by artificially splitting related code into separate patches. Remove
any single function and algorithm will be incomplete.

Let me give you some high-level overview of how pieces are put
together. There are 9 non-trivial functions, let's go over their
purpose in the orderd in which they are defined in file:

1. bpf_core_spec_parse()

This one take bpf_offset_reloc's type_id and accessor string
("0:1:2:3") and parses it into more convenient bpf_core_spec
datastructure, which has calculated offset and high-level spec
"steps": either named field or array access.

2. bpf_core_find_cands()

Given local type name, finds all possible target BTF types with same
name (modulo "flavor" differences, ___flavor suffix is just ignored).

3. bpf_core_fields_are_compat()

Given local and target field match, checks that their types are
compatible (so that we don't accidentally match, e.g., int against
struct).

4. bpf_core_match_member()

Given named local field, find corresponding field in target struct. To
understand why it's not trivial, here's an example:

Local type:

struct s___local {
  int a;
};

Target type:

struct s___target {
  struct {
    union {
      int a;
    };
  };
};

For both cases you can access a as s.a, but in local case, field a is
immediately inside s___local, while for s___target, you have to
traverse two levels deeper into anonymous fields to get to an `a`
inside anonymous union.

So this function find that `a` by doing exhaustive search across all
named field and anonymous struct/unions. But otherwise it's pretty
straightforward recursive function.

bpf_core_spec_match()

Just goes over high-level spec steps in local spec and tries to figure
out both high-level and low-level steps for targe type. Consider the
above example. For both structs accessing s.a is one high-level step,
but for s___local it's single low-level step (just another :0 in spec
string), while for s___target it's three low-level steps: ":0:0:0",
one step for each BTF type we need to traverse.

Array access is simpler, it's always one high-level and one low-level step.

bpf_core_reloc_insn()

Once we match local and target specs and have local and target
offsets, do the relocations - check that instruction has expected
local offset and replace it with target offset.

bpf_core_find_kernel_btf()

This is the only function that can be moved into separate patch, but
it's also very simple. It just iterates over few known possible
locations for vmlinux image and once found, tries to parse .BTF out of
it, to be used as target BTF.

bpf_core_reloc_offset()

It combines all the above functions to perform single relocation.
Parse spec, get candidates, for each candidate try to find matching
target spec. All candidates that matched are cached for given local
root type.

bpf_core_reloc_offsets()

High-level coordination. Iterate over all per-program .BTF.ext offset
reloc sections, each relocation within them. Find corresponding
program and try to apply relocations one by one.


I think the only non-obvious part here is to understand that
relocation records local raw spec with every single anonymous type
traversal, which is not that useful when we try to match it against
target type, which can have very different composition, but still the
same field access pattern, from C language standpoint (which hides all
those anonymous type traversals from programmer).

But it should be pretty clear now, plus also check tests, they have
lots of cases showing what's compatible and what's not.


>
> I haven't finished all of it. Please see my comments below of parts I
> have covered.
>
> Thanks,
> Song
>
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 866 ++++++++++++++++++++++++++++++++++++++++-
> > tools/lib/bpf/libbpf.h |   1 +
> > 2 files changed, 861 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 8741c39adb1c..86d87bf10d46 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -38,6 +38,7 @@
> > #include <sys/stat.h>
> > #include <sys/types.h>
> > #include <sys/vfs.h>
> > +#include <sys/utsname.h>
> > #include <tools/libc_compat.h>
> > #include <libelf.h>
> > #include <gelf.h>
> > @@ -47,6 +48,7 @@
> > #include "btf.h"
> > #include "str_error.h"
> > #include "libbpf_internal.h"
> > +#include "hashmap.h"
> >
> > #ifndef EM_BPF
> > #define EM_BPF 247
> > @@ -1013,16 +1015,22 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
> > }
> >
> > static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > -                                                  __u32 id)
> > +                                                  __u32 id,
> > +                                                  __u32 *res_id)
> > {
> >       const struct btf_type *t = btf__type_by_id(btf, id);
>
> Maybe have a local "__u32 rid;"
>
> >
> > +     if (res_id)
> > +             *res_id = id;
> > +
>
> and do "rid = id;" here
>
> >       while (true) {
> >               switch (BTF_INFO_KIND(t->info)) {
> >               case BTF_KIND_VOLATILE:
> >               case BTF_KIND_CONST:
> >               case BTF_KIND_RESTRICT:
> >               case BTF_KIND_TYPEDEF:
> > +                     if (res_id)
> > +                             *res_id = t->type;
> and here
>
> >                       t = btf__type_by_id(btf, t->type);
> >                       break;
> >               default:
> and "*res_id = rid;" right before return?

Sure, but why?

>
> > @@ -1041,7 +1049,7 @@ static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > static bool get_map_field_int(const char *map_name, const struct btf *btf,
> >                             const struct btf_type *def,
> >                             const struct btf_member *m, __u32 *res) {

[...]

> > +struct bpf_core_spec {
> > +     const struct btf *btf;
> > +     /* high-level spec: named fields and array indicies only */
>
> typo: indices

thanks!

>
> > +     struct bpf_core_accessor spec[BPF_CORE_SPEC_MAX_LEN];
> > +     /* high-level spec length */
> > +     int len;
> > +     /* raw, low-level spec: 1-to-1 with accessor spec string */
> > +     int raw_spec[BPF_CORE_SPEC_MAX_LEN];
> > +     /* raw spec length */
> > +     int raw_len;
> > +     /* field byte offset represented by spec */
> > +     __u32 offset;
> > +};

[...]

> > + *
> > + *   int x = &s->a[3]; // access string = '0:1:2:3'
> > + *
> > + * Low-level spec has 1:1 mapping with each element of access string (it's
> > + * just a parsed access string representation): [0, 1, 2, 3].
> > + *
> > + * High-level spec will capture only 3 points:
> > + *   - intial zero-index access by pointer (&s->... is the same as &s[0]...);
> > + *   - field 'a' access (corresponds to '2' in low-level spec);
> > + *   - array element #3 access (corresponds to '3' in low-level spec).
> > + *
> > + */
>
> IIUC, high-level points are subset of low-level points. How about we introduce
> "anonymous" high-level points, so that high-level points and low-level points
> are 1:1 mapping?

No, that will just hurt and complicate things. See above explanation
about why we need high-level points (it's what you as C programmer try
to achieve vs low-level spec is what C-language does in reality, with
all the anonymous struct/union traversal).

What's wrong with this separation? Think about it as recording
"intent" (high-level spec) vs "mechanics" (low-level spec, how exactly
to achieve that intent, in excruciating details).

>
> > +static int bpf_core_spec_parse(const struct btf *btf,
> > +                            __u32 type_id,
> > +                            const char *spec_str,
> > +                            struct bpf_core_spec *spec)
> > +{
> > +     int access_idx, parsed_len, i;
> > +     const struct btf_type *t;
> > +     __u32 id = type_id;
> > +     const char *name;
> > +     __s64 sz;
> > +
> > +     if (str_is_empty(spec_str) || *spec_str == ':')
> > +             return -EINVAL;
> > +
> > +     memset(spec, 0, sizeof(*spec));
> > +     spec->btf = btf;
> > +
> > +     /* parse spec_str="0:1:2:3:4" into array raw_spec=[0, 1, 2, 3, 4] */
> > +     while (*spec_str) {
> > +             if (*spec_str == ':')
> > +                     ++spec_str;
> > +             if (sscanf(spec_str, "%d%n", &access_idx, &parsed_len) != 1)
> > +                     return -EINVAL;
> > +             if (spec->raw_len == BPF_CORE_SPEC_MAX_LEN)
> > +                     return -E2BIG;
> > +             spec_str += parsed_len;
> > +             spec->raw_spec[spec->raw_len++] = access_idx;
> > +     }
> > +
> > +     if (spec->raw_len == 0)
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < spec->raw_len; i++) {
> > +             t = skip_mods_and_typedefs(btf, id, &id);
> > +             if (!t)
> > +                     return -EINVAL;
> > +
> > +             access_idx = spec->raw_spec[i];
> > +
> > +             if (i == 0) {
> > +                     /* first spec value is always reloc type array index */
> > +                     spec->spec[spec->len].type_id = id;
> > +                     spec->spec[spec->len].idx = access_idx;
> > +                     spec->len++;
> > +
> > +                     sz = btf__resolve_size(btf, id);
> > +                     if (sz < 0)
> > +                             return sz;
> > +                     spec->offset += access_idx * sz;
>           spec->offset = access_idx * sz;  should be enough

No. spec->offset is carefully maintained across multiple low-level
steps, as we traverse down embedded structs/unions.

Think about, e.g.:

struct s {
    int a;
    struct {
        int b;
    };
};

Imagine you are trying to match s.b access. With what you propose
you'll end up with offset 0, but it should be 4.

>
> > +                     continue;
> > +             }
>
> Maybe pull i == 0 case out of the for loop?
>
> > +
> > +             if (btf_is_composite(t)) {

[...]

> > +
> > +     if (spec->len == 0)
> > +             return -EINVAL;
>
> Can this ever happen?

Not really, because I already check raw_len == 0 and exit with error.
I'll remove.

>
> > +
> > +     return 0;
> > +}
> > +

[...]

> > +
> > +/*
> > + * Given single high-level accessor (either named field or array index) in
> > + * local type, find corresponding high-level accessor for a target type. Along
> > + * the way, maintain low-level spec for target as well. Also keep updating
> > + * target offset.
> > + */
>
> Please describe the recursive algorithm here. I am kinda lost.

Explained above. I'll extend description a bit. But it's just
recursive exhaustive search:
1. if struct field is anonymous and is struct/union, go one level
deeper and try to find field with given name inside those.
2. if field has name and it matched what we are searching - check type
compatibility. It has to be compatible, so if it's not, then it's not
a match.

> Also, please document the meaning of zero, positive, negative return values.

Ok. It's standard <0 - error, 0 - false, 1 - true.

>
> > +static int bpf_core_match_member(const struct btf *local_btf,
> > +                              const struct bpf_core_accessor *local_acc,
> > +                              const struct btf *targ_btf,
> > +                              __u32 targ_id,
> > +                              struct bpf_core_spec *spec,
> > +                              __u32 *next_targ_id)
> > +{

[...]

> > +
> > +/*
> > + * Try to match local spec to a target type and, if successful, produce full
> > + * target spec (high-level, low-level + offset).
> > + */
> > +static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
> > +                            const struct btf *targ_btf, __u32 targ_id,
> > +                            struct bpf_core_spec *targ_spec)
> > +{
> > +     const struct btf_type *targ_type;
> > +     const struct bpf_core_accessor *local_acc;
> > +     struct bpf_core_accessor *targ_acc;
> > +     int i, sz, matched;
> > +
> > +     memset(targ_spec, 0, sizeof(*targ_spec));
> > +     targ_spec->btf = targ_btf;
> > +
> > +     local_acc = &local_spec->spec[0];
> > +     targ_acc = &targ_spec->spec[0];
> > +
> > +     for (i = 0; i < local_spec->len; i++, local_acc++, targ_acc++) {
> > +             targ_type = skip_mods_and_typedefs(targ_spec->btf, targ_id,
> > +                                                &targ_id);
> > +             if (!targ_type)
> > +                     return -EINVAL;
> > +
> > +             if (local_acc->name) {
> > +                     if (!btf_is_composite(targ_type))
> > +                             return 0;
> > +
> > +                     matched = bpf_core_match_member(local_spec->btf,
> > +                                                     local_acc,
> > +                                                     targ_btf, targ_id,
> > +                                                     targ_spec, &targ_id);
> > +                     if (matched <= 0)
> > +                             return matched;
> > +             } else {
> > +                     /* for i=0, targ_id is already treated as array element
> > +                      * type (because it's the original struct), for others
> > +                      * we should find array element type first
> > +                      */
> > +                     if (i > 0) {
>
> i == 0 case would go into "if (local_acc->name)" branch, no?

No, i == 0 is always an array access. s->a.b.c is the same as
s[0].a.b.c, so relocation's first spec element is always either zero
for pointer access or any non-negative index for array access. But it
is always array access.

>
> > +                             const struct btf_array *a;
> > +
> > +                             if (!btf_is_array(targ_type))
> > +                                     return 0;
> > +
> > +                             a = (void *)(targ_type + 1);

[...]
