Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A552301D2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG1Ffd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1Ffd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:35:33 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF0621744;
        Tue, 28 Jul 2020 05:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914532;
        bh=zx7VWFCJ2PMJ/+Cqt+H06tQgYu2lqiv9yLovQHJzjWc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EcNitXg0qAG43LHfC4hLtq2qjsXiNcwJ37LNAH2i28lHZQiKtccWWISbiFDTy05B0
         DxpHe/EqHY4Fh9nQHhfrEQ6BftNnz550fn9s29BLdA7dX48j+F+uwrssFK3Cwu2tZE
         xfzsVTFU7XC+ANnbiZK1S45s3hacJhEUCZtAV0Ac=
Received: by mail-lj1-f177.google.com with SMTP id d17so19754172ljl.3;
        Mon, 27 Jul 2020 22:35:32 -0700 (PDT)
X-Gm-Message-State: AOAM532Wf0Iwv2Pq8t2aqy6VvObMWZrrY5skadQDuyOZCu5H52ZSIGWE
        I3IyIabtUJdln29C+gyWR+mUmBXqpSKsjLm4Nwo=
X-Google-Smtp-Source: ABdhPJzNdIVe4pMmZ2SNpqATz5OzkbzGqNa6+7VuTuASEOw5Ysa7o+rKpcNz69Vw4cj6ppOHaukqWELMwLlCQCzV6U4=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr3272036ljg.10.1595914530748;
 Mon, 27 Jul 2020 22:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-21-guro@fb.com>
In-Reply-To: <20200727184506.2279656-21-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:35:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51GXsn=d8=OmOz3OR9ziK+UG+GBJvFOMtHH2HnN9QBCg@mail.gmail.com>
Message-ID: <CAPhsuW51GXsn=d8=OmOz3OR9ziK+UG+GBJvFOMtHH2HnN9QBCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 20/35] bpf: eliminate rlimit-based memory
 accounting for queue_stack_maps maps
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

On Mon, Jul 27, 2020 at 12:25 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for queue_stack maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/queue_stack_maps.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
> index 44184f82916a..92e73c35a34a 100644
> --- a/kernel/bpf/queue_stack_maps.c
> +++ b/kernel/bpf/queue_stack_maps.c
> @@ -66,29 +66,21 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
>
>  static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
>  {
> -       int ret, numa_node = bpf_map_attr_numa_node(attr);
> -       struct bpf_map_memory mem = {0};
> +       int numa_node = bpf_map_attr_numa_node(attr);
>         struct bpf_queue_stack *qs;
> -       u64 size, queue_size, cost;
> +       u64 size, queue_size;
>
>         size = (u64) attr->max_entries + 1;
> -       cost = queue_size = sizeof(*qs) + size * attr->value_size;
> -
> -       ret = bpf_map_charge_init(&mem, cost);
> -       if (ret < 0)
> -               return ERR_PTR(ret);
> +       queue_size = sizeof(*qs) + size * attr->value_size;
>
>         qs = bpf_map_area_alloc(queue_size, numa_node);
> -       if (!qs) {
> -               bpf_map_charge_finish(&mem);
> +       if (!qs)
>                 return ERR_PTR(-ENOMEM);
> -       }
>
>         memset(qs, 0, sizeof(*qs));
>
>         bpf_map_init_from_attr(&qs->map, attr);
>
> -       bpf_map_charge_move(&qs->map.memory, &mem);
>         qs->size = size;
>
>         raw_spin_lock_init(&qs->lock);
> --
> 2.26.2
>
