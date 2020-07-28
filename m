Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9522301C8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgG1Fcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG1Fcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:32:33 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE45D21D95;
        Tue, 28 Jul 2020 05:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914352;
        bh=SjP3OhxJM4KR5LPl+D64JmqvXI73XHO2Y8ZSVez5psY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hBXGz0cHx5wyT53ywCcD0oe/PaUMXLhXm9PxYciIeycMN/N1F8/SypnySQuBUqXVU
         s6iSXMK9n51S+9zse+A+y4ohRBRwvnSt9sGj/bUUHVGyzvOfh4oONUwDUztkbBfKvc
         QMvunRhUEvDKSUefG98Dslp1MsZU6qrqsI96hfA8=
Received: by mail-lf1-f42.google.com with SMTP id i80so10282090lfi.13;
        Mon, 27 Jul 2020 22:32:31 -0700 (PDT)
X-Gm-Message-State: AOAM533fHrNNDd8JRhC8gFEOBjHm6axw72h3n4bKpOQa7nAIvdkB+o9s
        lPsYcmdKsmAoMy/ptNdau0vUC7GJVlNRRab4RqA=
X-Google-Smtp-Source: ABdhPJwi26yq612N370yndwXmjvcClKqs7mQKPmd3mY7tvi7kkqYvBqZsCgkaOEuFu0g6ZciE7UvaurIrNpDUahjOeQ=
X-Received: by 2002:a19:ec12:: with SMTP id b18mr13527150lfa.52.1595914350086;
 Mon, 27 Jul 2020 22:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-19-guro@fb.com>
In-Reply-To: <20200727184506.2279656-19-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:32:18 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4xooQEup9twRHcYNRn=JRuRO-VWxkz7SSKfi8ozLc9Yg@mail.gmail.com>
Message-ID: <CAPhsuW4xooQEup9twRHcYNRn=JRuRO-VWxkz7SSKfi8ozLc9Yg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 18/35] bpf: eliminate rlimit-based memory
 accounting for hashtab maps
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
> Do not use rlimit-based memory accounting for hashtab maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/hashtab.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 9d0432170812..9372b559b4e7 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -422,7 +422,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>         bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
>         bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
>         struct bpf_htab *htab;
> -       u64 cost;
>         int err;
>
>         htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
> @@ -459,26 +458,12 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>             htab->n_buckets > U32_MAX / sizeof(struct bucket))
>                 goto free_htab;
>
> -       cost = (u64) htab->n_buckets * sizeof(struct bucket) +
> -              (u64) htab->elem_size * htab->map.max_entries;
> -
> -       if (percpu)
> -               cost += (u64) round_up(htab->map.value_size, 8) *
> -                       num_possible_cpus() * htab->map.max_entries;
> -       else
> -              cost += (u64) htab->elem_size * num_possible_cpus();
> -
> -       /* if map size is larger than memlock limit, reject it */
> -       err = bpf_map_charge_init(&htab->map.memory, cost);
> -       if (err)
> -               goto free_htab;
> -
>         err = -ENOMEM;
>         htab->buckets = bpf_map_area_alloc(htab->n_buckets *
>                                            sizeof(struct bucket),
>                                            htab->map.numa_node);
>         if (!htab->buckets)
> -               goto free_charge;
> +               goto free_htab;
>
>         if (htab->map.map_flags & BPF_F_ZERO_SEED)
>                 htab->hashrnd = 0;
> @@ -508,8 +493,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>         prealloc_destroy(htab);
>  free_buckets:
>         bpf_map_area_free(htab->buckets);
> -free_charge:
> -       bpf_map_charge_finish(&htab->map.memory);
>  free_htab:
>         kfree(htab);
>         return ERR_PTR(err);
> --
> 2.26.2
>
