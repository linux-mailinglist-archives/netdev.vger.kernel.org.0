Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532D222FE4E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgG1AEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG1AEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 20:04:44 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5511D20809;
        Tue, 28 Jul 2020 00:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595894683;
        bh=l/v3wxr7DfRlZSAwzqZ2d8rPdbvhZ52OfzYMf5im19w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LT14dCnc1/2/BhPrwC2GaEYdAEUfwpckWQwNNZmrYd1UXPw2yzn2NtdRQGmSpi5yQ
         r+CiXsRFIjw9+3ty1J9Y3nBMxnpau3EPpKug7F2k7ob8bhCZeWjaIv/lTseJa9hBj1
         /6gavrtdP/Y+6SY/+ZSJWu2x6dZ6flvgWN0BNc34=
Received: by mail-lj1-f181.google.com with SMTP id x9so19189193ljc.5;
        Mon, 27 Jul 2020 17:04:43 -0700 (PDT)
X-Gm-Message-State: AOAM531aIcqMEVH9V2vcRQCyJM4xYVab+wY2WpmodBZX8SQIhyqPes5p
        W1apEbEAMJztmsKEXVozCle4QvOcRPm81qEd7/w=
X-Google-Smtp-Source: ABdhPJywBaWaNyTbBa1fvtoF/CLlNClslEFItXukOgo/V9ZcR7ZM8F1IJI51ZDjboRD8YEPHMvhctm6PqsfzWPMQ4xo=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr2792328ljg.10.1595894681673;
 Mon, 27 Jul 2020 17:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-14-guro@fb.com>
In-Reply-To: <20200727184506.2279656-14-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 17:04:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7xabhuHeGOv81WNsWmiFC_pDVj1qwyxe-DE-Q7_hzHHA@mail.gmail.com>
Message-ID: <CAPhsuW7xabhuHeGOv81WNsWmiFC_pDVj1qwyxe-DE-Q7_hzHHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 13/35] bpf: eliminate rlimit-based memory
 accounting for arraymap maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for arraymap maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/arraymap.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
>
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 9597fecff8da..41581c38b31d 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -75,11 +75,10 @@ int array_map_alloc_check(union bpf_attr *attr)
>  static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>  {
>         bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
> -       int ret, numa_node = bpf_map_attr_numa_node(attr);
> +       int numa_node = bpf_map_attr_numa_node(attr);
>         u32 elem_size, index_mask, max_entries;
>         bool bypass_spec_v1 = bpf_bypass_spec_v1();
> -       u64 cost, array_size, mask64;
> -       struct bpf_map_memory mem;
> +       u64 array_size, mask64;
>         struct bpf_array *array;
>
>         elem_size = round_up(attr->value_size, 8);
> @@ -120,44 +119,29 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>                 }
>         }
>
> -       /* make sure there is no u32 overflow later in round_up() */
> -       cost = array_size;
> -       if (percpu)
> -               cost += (u64)attr->max_entries * elem_size * num_possible_cpus();
> -
> -       ret = bpf_map_charge_init(&mem, cost);
> -       if (ret < 0)
> -               return ERR_PTR(ret);
> -
>         /* allocate all map elements and zero-initialize them */
>         if (attr->map_flags & BPF_F_MMAPABLE) {
>                 void *data;
>
>                 /* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
>                 data = bpf_map_area_mmapable_alloc(array_size, numa_node);
> -               if (!data) {
> -                       bpf_map_charge_finish(&mem);
> +               if (!data)
>                         return ERR_PTR(-ENOMEM);
> -               }
>                 array = data + PAGE_ALIGN(sizeof(struct bpf_array))
>                         - offsetof(struct bpf_array, value);
>         } else {
>                 array = bpf_map_area_alloc(array_size, numa_node);
>         }
> -       if (!array) {
> -               bpf_map_charge_finish(&mem);
> +       if (!array)
>                 return ERR_PTR(-ENOMEM);
> -       }
>         array->index_mask = index_mask;
>         array->map.bypass_spec_v1 = bypass_spec_v1;
>
>         /* copy mandatory map attributes */
>         bpf_map_init_from_attr(&array->map, attr);
> -       bpf_map_charge_move(&array->map.memory, &mem);
>         array->elem_size = elem_size;
>
>         if (percpu && bpf_array_alloc_percpu(array)) {
> -               bpf_map_charge_finish(&array->map.memory);
>                 bpf_map_area_free(array);
>                 return ERR_PTR(-ENOMEM);
>         }
> --
> 2.26.2
>
