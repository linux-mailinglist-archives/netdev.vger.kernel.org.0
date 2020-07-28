Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B712301D8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgG1FgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgG1FgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:36:14 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8185A20829;
        Tue, 28 Jul 2020 05:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914573;
        bh=NYliXhNE0Ikas7TdF7KFQr01kN+9oP3XTP/30kkz19w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wbztQyAGOFzqAtc/JfZCe7NjR+kFf/xrcivW+Rf6ATDHzAHDJHz7KevjKh/J0Gnag
         tONn7WYm2he40dDt6DtuCGgGkzIYS7INuV2XA8tkcy3by3lWchpA5ujXqbuSfDMhN/
         JBB9v1zQB7bOQCUs6X2PMChaSCZ1UbqY15AmqnsQ=
Received: by mail-lj1-f180.google.com with SMTP id s16so4527693ljc.8;
        Mon, 27 Jul 2020 22:36:13 -0700 (PDT)
X-Gm-Message-State: AOAM533mXh2AdzPGkvH2KrSjICoq+DTnNIDmdmvcIEkn/BYNn5AfVExc
        0XZjS7RCckPw+f8wj64AnDVVsqUbthlzmqv8AhE=
X-Google-Smtp-Source: ABdhPJyGh4UrKdt7qfL+twrB0EwMccKcWZiAyohVHLCTylQYv/wFvhzzysM6k+sDmLl9pXWQakqvfaMYzdF0JY5KORw=
X-Received: by 2002:a2e:3003:: with SMTP id w3mr11851266ljw.273.1595914571828;
 Mon, 27 Jul 2020 22:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-22-guro@fb.com>
In-Reply-To: <20200727184506.2279656-22-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:36:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5-SK0GyvpDzEWf4SW+fJ3PpoT8q0GmamRDjydPqNk_ew@mail.gmail.com>
Message-ID: <CAPhsuW5-SK0GyvpDzEWf4SW+fJ3PpoT8q0GmamRDjydPqNk_ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 21/35] bpf: eliminate rlimit-based memory
 accounting for reuseport_array maps
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

On Mon, Jul 27, 2020 at 12:23 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for reuseport_array maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/reuseport_array.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index 90b29c5b1da7..9d0161fdfec7 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -150,9 +150,8 @@ static void reuseport_array_free(struct bpf_map *map)
>
>  static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
>  {
> -       int err, numa_node = bpf_map_attr_numa_node(attr);
> +       int numa_node = bpf_map_attr_numa_node(attr);
>         struct reuseport_array *array;
> -       struct bpf_map_memory mem;
>         u64 array_size;
>
>         if (!bpf_capable())
> @@ -161,20 +160,13 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
>         array_size = sizeof(*array);
>         array_size += (u64)attr->max_entries * sizeof(struct sock *);
>
> -       err = bpf_map_charge_init(&mem, array_size);
> -       if (err)
> -               return ERR_PTR(err);
> -
>         /* allocate all map elements and zero-initialize them */
>         array = bpf_map_area_alloc(array_size, numa_node);
> -       if (!array) {
> -               bpf_map_charge_finish(&mem);
> +       if (!array)
>                 return ERR_PTR(-ENOMEM);
> -       }
>
>         /* copy mandatory map attributes */
>         bpf_map_init_from_attr(&array->map, attr);
> -       bpf_map_charge_move(&array->map.memory, &mem);
>
>         return &array->map;
>  }
> --
> 2.26.2
>
