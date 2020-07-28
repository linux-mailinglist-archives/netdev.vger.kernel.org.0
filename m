Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC20B2301C2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgG1Fbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1Fbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:31:44 -0400
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4017020759;
        Tue, 28 Jul 2020 05:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914303;
        bh=od/RCpjZlut+DufU7AUtCgtcIwiD7Wkz1u7tIAU5B18=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HzVtgdXu8pyQzsyMgso5zVW010L3JKVa6orIbKHDyqBgj/tUU3RX4ZjKlyIXvJWcQ
         zMYGbvMKjJUJpeDbbKhouWAPPJSCE8P28XvvPHgpzB+t00R9nePfDhdAh+KX+YQJCa
         JeieJAnVP7eGoQVilPsrSq1GP7qjbr9e4fTmLaeE=
Received: by mail-lj1-f174.google.com with SMTP id t6so6804449ljk.9;
        Mon, 27 Jul 2020 22:31:43 -0700 (PDT)
X-Gm-Message-State: AOAM530tQfY7VFmGJPYlUJCXj/0V3Uu69D+u10earRYit55BkJ0P9SUF
        VED4Zlq3xbdMAN0pQtKmFdFbqe9i4yyObl6dKz4=
X-Google-Smtp-Source: ABdhPJxPFAwM4vHp8fXkcbBn8ym9tVik/Z/CSWO5TQJLnjFjfLQCku9v9RAT2Z0BCx4cKwftt16naz1II5o1SQRopDs=
X-Received: by 2002:a2e:8707:: with SMTP id m7mr11068133lji.350.1595914301588;
 Mon, 27 Jul 2020 22:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-18-guro@fb.com>
In-Reply-To: <20200727184506.2279656-18-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:31:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4BD52Nes02qvaxjuHQ1SWhmjeq+J3C4ZCftT4aJyqVmw@mail.gmail.com>
Message-ID: <CAPhsuW4BD52Nes02qvaxjuHQ1SWhmjeq+J3C4ZCftT4aJyqVmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 17/35] bpf: eliminate rlimit-based memory
 accounting for devmap maps
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

On Mon, Jul 27, 2020 at 12:20 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for devmap maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/devmap.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 05bf93088063..8148c7260a54 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -109,8 +109,6 @@ static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
>  static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>  {
>         u32 valsize = attr->value_size;
> -       u64 cost = 0;
> -       int err;
>
>         /* check sanity of attributes. 2 value sizes supported:
>          * 4 bytes: ifindex
> @@ -135,21 +133,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>
>                 if (!dtab->n_buckets) /* Overflow check */
>                         return -EINVAL;
> -               cost += (u64) sizeof(struct hlist_head) * dtab->n_buckets;
> -       } else {
> -               cost += (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
>         }
>
> -       /* if map size is larger than memlock limit, reject it */
> -       err = bpf_map_charge_init(&dtab->map.memory, cost);
> -       if (err)
> -               return -EINVAL;
> -
>         if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
>                 dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
>                                                            dtab->map.numa_node);
>                 if (!dtab->dev_index_head)
> -                       goto free_charge;
> +                       return -ENOMEM;
>
>                 spin_lock_init(&dtab->index_lock);
>         } else {
> @@ -157,14 +147,10 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>                                                       sizeof(struct bpf_dtab_netdev *),
>                                                       dtab->map.numa_node);
>                 if (!dtab->netdev_map)
> -                       goto free_charge;
> +                       return -ENOMEM;
>         }
>
>         return 0;
> -
> -free_charge:
> -       bpf_map_charge_finish(&dtab->map.memory);
> -       return -ENOMEM;
>  }
>
>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
> --
> 2.26.2
>
