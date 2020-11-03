Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7F12A3C70
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKCGCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCGCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:02:07 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6A5C0617A6;
        Mon,  2 Nov 2020 22:02:07 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id b138so13841627yba.5;
        Mon, 02 Nov 2020 22:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vuE3QTFrfiF4wmbxx6OC7jkMNtwYpYqyuEMzDotBH8g=;
        b=PYTNwirRFbE1EMXyt564E0wg4gtcTGU/k8L5QAOH1eF5l0dNtzwbi0Q5Xq62aTDQ7G
         2jJQ+FAR4YZ5hif5KgZ9L52CZ6FHJZzg2wqY58JsC1awW4iajh6qRM/I0InC+ChL5OJ4
         80O8qf8t8SvkNO348LVT/ruB9NH0636urUqH6gIhSc4+objhCE/vQ7KLUQq/I7wI3dgO
         B4yRV54vozKpz3C696R8tI2RnvsKMeBen3w+jpZlv2I+LaBRcG88bLfVRjo4g/1858Mm
         1N7CRB664YWC4C8JAinDYlxSyWkA7qKLNZoH+xwPh4U2S49RJpx3keyZf8Bkdqcd6M6q
         Pw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vuE3QTFrfiF4wmbxx6OC7jkMNtwYpYqyuEMzDotBH8g=;
        b=LGZYWio7nCQOTXHE/yhF9jIyfbxbYrmVu5kqXqSyILLRyCkqL0vN1FX52j0M4OYrz/
         pV4jGtCe6epnyyDt8YXXKmuV9WJliOAAQANh0nI2s47OUtLw5GG+jy4Ee48tJF9aJwc5
         pTlt0VXOAg0uTsfdrMNAY/Sy2tL0VtzdZhk3ogiRdLUYRfzUkL8FZfp9e5mbG7MUSYtA
         U+nknUQ5/xKGeJLSiYEcy4QLa+pTaXJiSMEJlTOFpfODNkDXj+jOj5KPZo831HJAB1bD
         YiCnT7qNI+2VO2SSQ7LaSpS1QLoMw5y0f/44P4/GahLbFaIj0adQfawLx7vgH2d8locF
         CUYA==
X-Gm-Message-State: AOAM532WCkgKpQj3PeD7opQMHn3H+j/ariFYBz3DpO2rvVnDOKjkQAze
        u0i6ppLdboL8TljU8ca/psLWFxU/wR8hXJFib1k=
X-Google-Smtp-Source: ABdhPJwxmc7ZykPF1nffF3uR/zWoH/oLi+zZA3bJA2nabwFFCe538AlFbGmT3jJO2ALBjeZd9kV9LgAA4Rww/WpwJ58=
X-Received: by 2002:a25:25c2:: with SMTP id l185mr23664805ybl.230.1604383326714;
 Mon, 02 Nov 2020 22:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-4-andrii@kernel.org>
 <20201103045936.hh7p7mmpf4vffkun@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103045936.hh7p7mmpf4vffkun@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 22:01:55 -0800
Message-ID: <CAEf4BzYD0dJgBVim6errjoNQx-4HnOc1Gc7U57HeYwV2QC_nfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/11] libbpf: unify and speed up BTF string deduplication
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 8:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 28, 2020 at 05:58:54PM -0700, Andrii Nakryiko wrote:
> > From: Andrii Nakryiko <andriin@fb.com>
> >
> > Revamp BTF dedup's string deduplication to match the approach of writable BTF
> > string management. This allows to transfer deduplicated strings index back to
> > BTF object after deduplication without expensive extra memory copying and hash
> > map re-construction. It also simplifies the code and speeds it up, because
> > hashmap-based string deduplication is faster than sort + unique approach.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/btf.c | 265 +++++++++++++++++---------------------------
> >  1 file changed, 99 insertions(+), 166 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 89fecfe5cb2b..db9331fea672 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -90,6 +90,14 @@ struct btf {
> >       struct hashmap *strs_hash;
> >       /* whether strings are already deduplicated */
> >       bool strs_deduped;
> > +     /* extra indirection layer to make strings hashmap work with stable
> > +      * string offsets and ability to transparently choose between
> > +      * btf->strs_data or btf_dedup->strs_data as a source of strings.
> > +      * This is used for BTF strings dedup to transfer deduplicated strings
> > +      * data back to struct btf without re-building strings index.
> > +      */
> > +     void **strs_data_ptr;
>
> I thought one of the ideas of dedup algo was that strings were deduped first,
> so there is no need to rebuild them.

Ugh.. many things to unpack here. Let's try.

Yes, the idea of dedup is to have only unique strings. But we always
were rebuilding strings during dedup, here we are just changing the
algorithm for string dedup from sort+uniq to hash table. We were
deduping strings unconditionally because we don't know how the BTF
strings section was created in the first place and if it's already
deduplicated or not. So we had to always do it before.

With BTF write APIs the situation became a bit more nuanced. If we
create BTF programmatically from scratch (btf_new_empty()), then
libbpf guarantees (by construction) that all added strings are
auto-deduped. In such a case btf->strs_deduped will be set to true and
during btf_dedup() we'll skip string deduplication. It's purely a
performance improvement and it benefits the main btf_dedup workflow in
pahole.

But if ready-built BTF was loaded from somewhere first and then
modified with BTF write APIs, then it's a bit different. For existing
strings, when we transition from read-only BTF to writable BTF, we
build string lookup hashmap, but we don't deduplicate and remap string
offsets. So if loaded BTF had string duplicates, it will continue
having string duplicates. The string lookup index will pick arbitrary
instance of duplicated string as a unique key, but strings data will
still have duplicates and there will be types that still reference
duplicated string. Until (and if) we do btf_dedup(). At that time
we'll create another unique hash table *and* will remap all string
offsets across all types.

I did it this way intentionally (not remapping strings when doing
read-only -> writable BTF transition) to not accidentally corrupt
.BTF.ext strings. If I were to do full string dedup for r/o ->
writable transition, I'd need to add APIs to "link" struct btf_ext to
struct btf, so that libbpf could remap .BTF.ext strings transparently.
But I didn't want to add those APIs (yet) and didn't want to deal with
mutable struct btf_ext (yet).

So, in short, for strings dedup fundamentally nothing changed at all.

> Then split BTF cannot touch base BTF strings and they're immutable.

This is exactly the case right now. Nothing in base BTF changes, ever.

> But the commit log is talking about transfer of strings and
> hash map re-construction? Why split BTF would reconstruct anything?

This transfer of strings is for split BTF's strings data only. In
general case, we have some unknown strings data in split BTF. When we
do dedup, we need to make sure that split BTF strings are deduplicated
(we don't touch base BTF strings at all). For that we need to
construct a new hashmap. Once we constructed it, we have new strings
data with deduplicated strings, so to avoid creating another big copy
for struct btf, we just "transfer" that data to struct btf from struct
btf_dedup. void **strs_data_ptr just allows reusing the same (already
constructed) hashmap, same underlying blog of deduplicated string
data, same hashing and equality functions.

> It either finds a string in a base BTF or adds to its own strings section.
> Is it all due to switch to hash? The speedup motivation is clear, but then
> it sounds like that the speedup is causing all these issues.
> The strings could have stayed as-is. Just a bit slower ?

Previously we were able to rewrite strings in-place and strings data
was never reallocated (because BTF was read-only always). So it was
all a bit simpler. By using double-indirection we don't have to build
a third hashmap once we are done with strings dedup, we just replace
struct btf's own string lookup hashmap and string data memory.
Alternative is another expensive memory allocation and potentially
pretty big hashmap copy.

Apart from double indirection, the algorithm is much simpler now. If I
were writing original BTF dedup in C++, I'd use a hashmap approach
back then. But we didn't have hashmap in libbpf yet, so sort + uniq
was chosen.
