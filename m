Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4817FFBA3D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKMUug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:50:36 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33593 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:50:36 -0500
Received: by mail-qk1-f196.google.com with SMTP id 71so3063719qkl.0;
        Wed, 13 Nov 2019 12:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXD2j268aHAVSFRv+OPm2My3othkJ91VOi9l+SSNAPM=;
        b=Crv8ovI7ekGxEaDGL3HpRMJ1leZSeJtq3sfS9y1YbCGRHQE5KnAIL0Idyy3Ay1OvE0
         YP4Q7LMYWNLpboB4UHMGjs9xfxY0aLEieKobdGtb/XppLKPgIbg9ODZ4U8G9VTRXZQvQ
         g/YURmwwjyxxePilWpSxx2URHfbd+IZD6xX6mq81icCB+XwQUeMlua27+lKw4iSu3DxB
         I9ZY6pPLON90flfvqxrHpkZJp1sdjsp59r3e1BGhhpYIods6z0mIBHC7rTVWM1jEVjlB
         YEfQ3CFI9tua4lwsqrzA3KVFfGunyT2SfDVyRYW+pXQ0103QmXNlQfoJz3Sjso61MJlH
         BZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXD2j268aHAVSFRv+OPm2My3othkJ91VOi9l+SSNAPM=;
        b=NVDTt6BKh4woxId7yx4AQGWw/3nivvOvCMQwhADpotf05CTXiWzRiRdoA+NhLgDosV
         i5nhdfVFfvBPLSYVLekGb25zIA0YjnXd09J2M1vmCNCINAl86ULFpm59wqUssh7yeoLQ
         Vkz3brlChJxatmsNd3cEpqpXX+E+CmeSndSkSVyJ6ICHyiCGJ6CngSR5j/wBYrn2GR2x
         hAN/j7v2JX6QwMr/ZXNWPVpgVWbmpiDgeEOl+kPUWheEFbMt5njUxuGwqLf//moLDjpm
         AtZqQX1LRoOnlXBzt90s2iphNRHY9mnkxZ3CUrVKpOwyZLgihdMyuF9co0ilM7tgcbfr
         iA4g==
X-Gm-Message-State: APjAAAWwqpwRn8ir4d02qtXnLxGvdQVn76juHixTMUeab6VL979CIupG
        fQk7ydZa9GSAE0lIklrjOYBIn3mrPgEZXTHB7LA=
X-Google-Smtp-Source: APXvYqzJBW3Nio6yq4GBt6nF+QGmd51lqFjqoHENwTFjtCzWkPVr6nEAfpXqGRga92H86aPXIymb8z+FDAIZCTZc8GA=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr4372090qke.92.1573678234394;
 Wed, 13 Nov 2019 12:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20191113031518.155618-1-andriin@fb.com> <20191113031518.155618-2-andriin@fb.com>
 <4460626d-93e6-6566-9909-68b15e515f4e@iogearbox.net>
In-Reply-To: <4460626d-93e6-6566-9909-68b15e515f4e@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Nov 2019 12:50:23 -0800
Message-ID: <CAEf4BzYEY7akdcVxnziaEKESJjuhV8TPguYEhH_5b960gbO7TQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 12:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/13/19 4:15 AM, Andrii Nakryiko wrote:
> > Add ability to memory-map contents of BPF array map. This is extremely useful
> > for working with BPF global data from userspace programs. It allows to avoid
> > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > and usability.
> >
> > There had to be special considerations for map freezing, to avoid having
> > writable memory view into a frozen map. To solve this issue, map freezing and
> > mmap-ing is happening under mutex now:
> >    - if map is already frozen, no writable mapping is allowed;
> >    - if map has writable memory mappings active (accounted in map->writecnt),
> >      map freezing will keep failing with -EBUSY;
> >    - once number of writable memory mappings drops to zero, map freezing can be
> >      performed again.
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
> Overall set looks good to me! One comment below:
>
> [...]
> > @@ -117,7 +131,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> >               return ERR_PTR(ret);
> >
> >       /* allocate all map elements and zero-initialize them */
> > -     array = bpf_map_area_alloc(array_size, numa_node);
> > +     if (attr->map_flags & BPF_F_MMAPABLE) {
> > +             void *data;
> > +
> > +             /* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
> > +             data = vzalloc_node(array_size, numa_node);
> > +             if (!data) {
> > +                     bpf_map_charge_finish(&mem);
> > +                     return ERR_PTR(-ENOMEM);
> > +             }
> > +             array = data + round_up(sizeof(struct bpf_array), PAGE_SIZE)
> > +                     - offsetof(struct bpf_array, value);
> > +     } else {
> > +             array = bpf_map_area_alloc(array_size, numa_node);
> > +     }
>
> Can't we place/extend all this logic inside bpf_map_area_alloc() and
> bpf_map_area_free() API instead of hard-coding it here?
>
> Given this is a generic feature of which global data is just one consumer,
> my concern is that this reintroduces similar issues that mentioned API was
> trying to solve already meaning failing early instead of trying hard and
> triggering OOM if the array is large.
>
> Consolidating this into bpf_map_area_alloc()/bpf_map_area_free() would
> make sure all the rest has same semantics.

So a bunch of this (e.g, array pointer adjustment in mmapable case)
depends on specific layout of bpf_array, while bpf_map_area_alloc() is
called for multitude of different maps. What we can generalize,
though, is this enforcement of vmalloc() for mmapable case: enforce
size is multiple of PAGE_SIZE, bypass kmalloc, etc. I can do that part
easily, I refrained because it would require extra bool mmapable flag
to bpf_map_area_alloc() and (trivial) update to 13 call sites passing
false, I wasn't sure people would like code churn.

As for bpf_map_areas_free(), again, adjustment is specific to
bpf_array and its memory layout w.r.t. data placement, so I don't
think we can generalize it that much.

After talking with Johannes, I'm also adding new
vmalloc_user_node_flags() API and will specify same RETRY_MAYFAIL and
NOWARN flags, so behavior will stay the same.

Let me know if you want `bool mmapable` added to bpf_map_area_alloc().
And also if I'm missing how you wanted to generalize other parts,
please explain in more details.

>
> >       if (!array) {
> >               bpf_map_charge_finish(&mem);
> >               return ERR_PTR(-ENOMEM);
> > @@ -365,7 +392,10 @@ static void array_map_free(struct bpf_map *map)
> >       if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
> >               bpf_array_free_percpu(array);
> >
> > -     bpf_map_area_free(array);
> > +     if (array->map.map_flags & BPF_F_MMAPABLE)
> > +             bpf_map_area_free((void *)round_down((long)array, PAGE_SIZE));
> > +     else
> > +             bpf_map_area_free(array);
> >   }
> >
> >   static void array_map_seq_show_elem(struct bpf_map *map, void *key,
> [...]
