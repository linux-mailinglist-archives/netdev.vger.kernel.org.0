Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8C2301E6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgG1FiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgG1FiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:38:12 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D07C21883;
        Tue, 28 Jul 2020 05:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914691;
        bh=zQfvL6mXPDvArmEZLKk1wPWEFI4+SrGpgZSDfVmZNFs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Tcuyzm+2cHo8cqzgn5IkjaRedCAa+xOOR37u2+WM4RzbRDE15DgjXIFXKTcAMSwbk
         0qT5pZkgRi6oftYCYDhCjzLK9BlDa3lZnHMDgLDaWE3w9+7qBgQM7M5DYXsdMOu24y
         3GadVfWBSnrowvG6sBN+LbnUvEB3ivgJJveMv1t8=
Received: by mail-lj1-f179.google.com with SMTP id g6so7140451ljn.11;
        Mon, 27 Jul 2020 22:38:11 -0700 (PDT)
X-Gm-Message-State: AOAM5329Bnz9KAXPT1LS4BWXV2P9tOQIW4dhm10FozQSDE+AVsAMHzH5
        6hDFUgwi3gKdLhKlYKiRE0kK9MQV1nKtGNEaYWA=
X-Google-Smtp-Source: ABdhPJw07JDlW+o4d8dnIhWF8L0WADQia7KOFXNcY2Knuvb+TUQbme9FYRDibTMNoCm7dHODimUOFP9/hEjsjBuC30M=
X-Received: by 2002:a05:651c:1349:: with SMTP id j9mr4580894ljb.392.1595914689684;
 Mon, 27 Jul 2020 22:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-24-guro@fb.com>
In-Reply-To: <20200727184506.2279656-24-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:37:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW502g1M9oJ2PSMUSwKHrD7UJmbwdBXZxt7KjU0UtAXSrw@mail.gmail.com>
Message-ID: <CAPhsuW502g1M9oJ2PSMUSwKHrD7UJmbwdBXZxt7KjU0UtAXSrw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 23/35] bpf: eliminate rlimit-based memory
 accounting for sockmap and sockhash maps
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
> Do not use rlimit-based memory accounting for sockmap and sockhash maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/core/sock_map.c | 33 ++++++---------------------------
>  1 file changed, 6 insertions(+), 27 deletions(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index bc797adca44c..07c90baf8db1 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -26,8 +26,6 @@ struct bpf_stab {
>  static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
>  {
>         struct bpf_stab *stab;
> -       u64 cost;
> -       int err;
>
>         if (!capable(CAP_NET_ADMIN))
>                 return ERR_PTR(-EPERM);
> @@ -45,22 +43,15 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
>         bpf_map_init_from_attr(&stab->map, attr);
>         raw_spin_lock_init(&stab->lock);
>
> -       /* Make sure page count doesn't overflow. */
> -       cost = (u64) stab->map.max_entries * sizeof(struct sock *);
> -       err = bpf_map_charge_init(&stab->map.memory, cost);
> -       if (err)
> -               goto free_stab;
> -
>         stab->sks = bpf_map_area_alloc(stab->map.max_entries *
>                                        sizeof(struct sock *),
>                                        stab->map.numa_node);
> -       if (stab->sks)
> -               return &stab->map;
> -       err = -ENOMEM;
> -       bpf_map_charge_finish(&stab->map.memory);
> -free_stab:
> -       kfree(stab);
> -       return ERR_PTR(err);
> +       if (!stab->sks) {
> +               kfree(stab);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       return &stab->map;
>  }
>
>  int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog)
> @@ -999,7 +990,6 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
>  {
>         struct bpf_shtab *htab;
>         int i, err;
> -       u64 cost;
>
>         if (!capable(CAP_NET_ADMIN))
>                 return ERR_PTR(-EPERM);
> @@ -1027,21 +1017,10 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
>                 goto free_htab;
>         }
>
> -       cost = (u64) htab->buckets_num * sizeof(struct bpf_shtab_bucket) +
> -              (u64) htab->elem_size * htab->map.max_entries;
> -       if (cost >= U32_MAX - PAGE_SIZE) {
> -               err = -EINVAL;
> -               goto free_htab;
> -       }
> -       err = bpf_map_charge_init(&htab->map.memory, cost);
> -       if (err)
> -               goto free_htab;
> -
>         htab->buckets = bpf_map_area_alloc(htab->buckets_num *
>                                            sizeof(struct bpf_shtab_bucket),
>                                            htab->map.numa_node);
>         if (!htab->buckets) {
> -               bpf_map_charge_finish(&htab->map.memory);
>                 err = -ENOMEM;
>                 goto free_htab;
>         }
> --
> 2.26.2
>
