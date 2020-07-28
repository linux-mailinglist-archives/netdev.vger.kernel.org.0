Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D837B2301BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgG1FbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1FbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:31:18 -0400
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D9720829;
        Tue, 28 Jul 2020 05:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914277;
        bh=6x8MUuK0n5i+nMzM9RSSqu6BN4eCFJOFvves+xYZvm0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T/oqn96LkOtGxLmb91EJO9WeJhX2ViQt6R6fB83CI/B7PZsyhUsDTLpJg26BIUJkb
         pUGOOplXZceKgbAScDNE/z9o+1M02GLjGM5AvK/Y9pt628aLKQs7fmrcGKa2tEnLWf
         WgRnxL9XHxt2n0Bh2jkgKMhTdMzQotz9+P6HrE8o=
Received: by mail-lf1-f52.google.com with SMTP id i19so10288002lfj.8;
        Mon, 27 Jul 2020 22:31:17 -0700 (PDT)
X-Gm-Message-State: AOAM533kfS/ft9w+KLBUA7Tx7lyQxJG46yJg/a9TwZygfWXHgCNEWuXX
        HYs2A8tELZJx3leXC+L62cpn7fnD0rovmYX1Fv4=
X-Google-Smtp-Source: ABdhPJwHdCWsC2R++rrxwGiPfxHc0ceeQcQGmq8Yto0legWBbPMv7nv/N4l9Hn4SKoSfunv4Aa0lgz8aIIlxhbxi11k=
X-Received: by 2002:a19:830a:: with SMTP id f10mr7063479lfd.28.1595914275710;
 Mon, 27 Jul 2020 22:31:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-17-guro@fb.com>
In-Reply-To: <20200727184506.2279656-17-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:31:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5EVOgL4Xhb1LDcF8EH4hUqY=-rFBRRnuGMSRfoviZnMA@mail.gmail.com>
Message-ID: <CAPhsuW5EVOgL4Xhb1LDcF8EH4hUqY=-rFBRRnuGMSRfoviZnMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 16/35] bpf: eliminate rlimit-based memory
 accounting for cgroup storage maps
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

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for cgroup storage maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/local_storage.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
>
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 117acb2e80fb..5f29a420849c 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -288,8 +288,6 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>  {
>         int numa_node = bpf_map_attr_numa_node(attr);
>         struct bpf_cgroup_storage_map *map;
> -       struct bpf_map_memory mem;
> -       int ret;
>
>         if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
>             attr->key_size != sizeof(__u64))
> @@ -309,18 +307,10 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>                 /* max_entries is not used and enforced to be 0 */
>                 return ERR_PTR(-EINVAL);
>
> -       ret = bpf_map_charge_init(&mem, sizeof(struct bpf_cgroup_storage_map));
> -       if (ret < 0)
> -               return ERR_PTR(ret);
> -
>         map = kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
>                            __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
> -       if (!map) {
> -               bpf_map_charge_finish(&mem);
> +       if (!map)
>                 return ERR_PTR(-ENOMEM);
> -       }
> -
> -       bpf_map_charge_move(&map->map.memory, &mem);
>
>         /* copy mandatory map attributes */
>         bpf_map_init_from_attr(&map->map, attr);
> @@ -509,9 +499,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(struct bpf_prog *prog,
>
>         size = bpf_cgroup_storage_calculate_size(map, &pages);
>
> -       if (bpf_map_charge_memlock(map, pages))
> -               return ERR_PTR(-EPERM);
> -
>         storage = kmalloc_node(sizeof(struct bpf_cgroup_storage), gfp,
>                                map->numa_node);
>         if (!storage)
> @@ -533,7 +520,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(struct bpf_prog *prog,
>         return storage;
>
>  enomem:
> -       bpf_map_uncharge_memlock(map, pages);
>         kfree(storage);
>         return ERR_PTR(-ENOMEM);
>  }
> @@ -560,16 +546,11 @@ void bpf_cgroup_storage_free(struct bpf_cgroup_storage *storage)
>  {
>         enum bpf_cgroup_storage_type stype;
>         struct bpf_map *map;
> -       u32 pages;
>
>         if (!storage)
>                 return;
>
>         map = &storage->map->map;
> -
> -       bpf_cgroup_storage_calculate_size(map, &pages);
> -       bpf_map_uncharge_memlock(map, pages);
> -
>         stype = cgroup_storage_type(map);
>         if (stype == BPF_CGROUP_STORAGE_SHARED)
>                 call_rcu(&storage->rcu, free_shared_cgroup_storage_rcu);
> --
> 2.26.2
>
