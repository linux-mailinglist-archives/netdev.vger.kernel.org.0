Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977A2FBA21
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKMUmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:42:10 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:39259 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:42:10 -0500
Received: by mail-qv1-f65.google.com with SMTP id v16so1405851qvq.6;
        Wed, 13 Nov 2019 12:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0p/Zku2Fe6Xf0203pbYpXePzU0UqcIZJFyLyWzAtd8U=;
        b=WO8LGnSSKFNb7xtDa4D/331TSn0FP98zClgv7/BAnLYCVKEhPbr3hsHSKQCpjIaime
         7YrffqmFIq+N5hSpup6Hw8pw294vhVeKAKkymG6HUmTm/Ju22as0oeQKTIVnFubIBSsS
         E57ClAslrKukZ6/gCTKYRBt40UkcGGGChVY/KyzUV9Skmm6nw22SMVcupRZxy4vZ5Vu2
         7rHP4A5/62qPztT98IxJ3vWzwjMF2fbhnawwcUxjfbBJsTgYhvYjBeprhYw9v5DCHvKr
         5zqYEs903othZuW4hVfnvL/bKQz9HGhyoMNjFUQZVDuXpWr41gD/Wp3+EnMdeD8m3IBZ
         naOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0p/Zku2Fe6Xf0203pbYpXePzU0UqcIZJFyLyWzAtd8U=;
        b=BLtu030LnQ+TU3bH5ZH5JohtbBKZW63pU9hTPQgjO8Y3S9tyJY5XA1XXvSQlx6VK1A
         Kle9McNIsj4pRW34LCEQX2RULU6N+EboJ3lVy3ib7MNyagp8w5/pIuTA6VLNFWndswtG
         5terNrQ4t7V6g3Mc+upd3lHIoo7I7baRxOgkBx73P6UW+KaB9mhmipaolY5QdvGxOSPc
         bgAwCIXCtblQvSUmuENiAZTrH9oqdW7urBkPNJcNMkLy9M7/6Uz1SD5jckO8Q9DWXrz0
         AcwfLpUm3G5JiO6vKsyXJtufMG2KMmHpkUnXZOAKSGa30jGWRl1+pcMDltNhE0lno2vy
         LIWw==
X-Gm-Message-State: APjAAAWOsX05qluh1I3BCBuoutenUCt7bzHQ1sdyHqIDGc8/JJFTM62c
        zbpF0pgtYrJP/fWBYm3JQyGcGJjEsNGRwEbGvao=
X-Google-Smtp-Source: APXvYqwdhy/alra+1hhAbFaBT5dCHSukScQfHRRF1GTUcyVZqmmf41t3jjDg1bazp7i71kJ2B9y1CNlPJYxchzqr3uw=
X-Received: by 2002:ad4:558e:: with SMTP id e14mr4710345qvx.247.1573677729078;
 Wed, 13 Nov 2019 12:42:09 -0800 (PST)
MIME-Version: 1.0
References: <20191113031518.155618-1-andriin@fb.com> <20191113031518.155618-2-andriin@fb.com>
 <5dcc622873079_14082b1d9b77e5b420@john-XPS-13-9370.notmuch>
In-Reply-To: <5dcc622873079_14082b1d9b77e5b420@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Nov 2019 12:41:57 -0800
Message-ID: <CAEf4Bzb8NbudHzUoWTbbjpX9sauBjtN2TASQ6k7kuXueojsVWA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 12:06 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Add ability to memory-map contents of BPF array map. This is extremely useful
> > for working with BPF global data from userspace programs. It allows to avoid
> > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > and usability.
> >
> > There had to be special considerations for map freezing, to avoid having
> > writable memory view into a frozen map. To solve this issue, map freezing and
> > mmap-ing is happening under mutex now:
> >   - if map is already frozen, no writable mapping is allowed;
> >   - if map has writable memory mappings active (accounted in map->writecnt),
> >     map freezing will keep failing with -EBUSY;
> >   - once number of writable memory mappings drops to zero, map freezing can be
> >     performed again.
> >
> > Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> > can't be memory mapped either.
> >
> > For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> > to be mmap()'able. We also need to make sure that array data memory is
> > page-sized and page-aligned, so we over-allocate memory in such a way that
> > struct bpf_array is at the end of a single page of memory with array->value
> > being aligned with the start of the second page. On deallocation we need to
> > accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> >
> > Cc: Rik van Riel <riel@surriel.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> [...]
>
> > @@ -102,10 +106,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> >       }
> >
> >       array_size = sizeof(*array);
> > -     if (percpu)
> > +     if (percpu) {
> >               array_size += (u64) max_entries * sizeof(void *);
> > -     else
> > -             array_size += (u64) max_entries * elem_size;
> > +     } else {
> > +             /* rely on vmalloc() to return page-aligned memory and
> > +              * ensure array->value is exactly page-aligned
> > +              */
> > +             if (attr->map_flags & BPF_F_MMAPABLE) {
> > +                     array_size = round_up(array_size, PAGE_SIZE);
> > +                     array_size += (u64) max_entries * elem_size;
> > +                     array_size = round_up(array_size, PAGE_SIZE);
> > +             } else {
> > +                     array_size += (u64) max_entries * elem_size;
> > +             }
> > +     }
>
> Thought about this chunk for a bit, assuming we don't end up with lots of
> small mmap arrays it should be OK. So userspace will probably need to try and
> optimize this to create as few mmaps as possible.

I think typically most explicitly declared maps won't be
BPF_F_MMAPABLE, unless user really expects to mmap() it for use from
user-space. For global data, though, the benefits are really great
from being able to mmap(), which is why I'm defaulting them to
BPF_F_MMAPABLE by default, if possible.

>
> [...]
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
