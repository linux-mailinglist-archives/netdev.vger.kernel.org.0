Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12762301EA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgG1Fid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgG1Fid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:38:33 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A4321D95;
        Tue, 28 Jul 2020 05:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914712;
        bh=kudBUbPYRIeiM4+47AqFUj+ZhdDE0WK7VWzk+AsvqF8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hInOE7+y5Fpi5W4zXMbOEdFfW83PX6I01vR1lHuhWtV+CXX7D9Kjff3zVl3NPo4Ow
         pO4FKUHUNTaE1+cMw7meKcSf8mlB2lmRP9ZS26X3ji69SxraAAwyfWIDOai5Luwni6
         FzuXKI2WJo7px1mwHCIMXYyJ7PCYW77eJHDvCHWg=
Received: by mail-lf1-f47.google.com with SMTP id y18so10286247lfh.11;
        Mon, 27 Jul 2020 22:38:32 -0700 (PDT)
X-Gm-Message-State: AOAM532A3U+nYJRL9ZgmB5jxUWVGk8Y9U9YN1d25ANRsbj1ELTqFv4uc
        UiCMm1MOmjOUYmpYMGyCo+Yj23edkdbTReLzIsE=
X-Google-Smtp-Source: ABdhPJyrFPzlDFJYgCalqg8Zv+yEzwKXrT9R4Ak9o5L/7YzejJFWLaYAllzlVJsHgsJ72RpZyKcn+mc+OPrltZ28u3E=
X-Received: by 2002:a19:7710:: with SMTP id s16mr13555854lfc.162.1595914710550;
 Mon, 27 Jul 2020 22:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-25-guro@fb.com>
In-Reply-To: <20200727184506.2279656-25-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:38:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW46PNAfmBThianVpWD-w+it107Zn7OtW6SA0sMW4J+cfQ@mail.gmail.com>
Message-ID: <CAPhsuW46PNAfmBThianVpWD-w+it107Zn7OtW6SA0sMW4J+cfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 24/35] bpf: eliminate rlimit-based memory
 accounting for stackmap maps
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

On Mon, Jul 27, 2020 at 12:22 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for stackmap maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/stackmap.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 5beb2f8c23da..9ac0f405beef 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -90,7 +90,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
>  {
>         u32 value_size = attr->value_size;
>         struct bpf_stack_map *smap;
> -       struct bpf_map_memory mem;
>         u64 cost, n_buckets;
>         int err;
>
> @@ -119,15 +118,9 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
>
>         cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
>         cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
> -       err = bpf_map_charge_init(&mem, cost);
> -       if (err)
> -               return ERR_PTR(err);
> -
>         smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
> -       if (!smap) {
> -               bpf_map_charge_finish(&mem);
> +       if (!smap)
>                 return ERR_PTR(-ENOMEM);
> -       }
>
>         bpf_map_init_from_attr(&smap->map, attr);
>         smap->map.value_size = value_size;
> @@ -135,20 +128,17 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
>
>         err = get_callchain_buffers(sysctl_perf_event_max_stack);
>         if (err)
> -               goto free_charge;
> +               goto free_smap;
>
>         err = prealloc_elems_and_freelist(smap);
>         if (err)
>                 goto put_buffers;
>
> -       bpf_map_charge_move(&smap->map.memory, &mem);
> -
>         return &smap->map;
>
>  put_buffers:
>         put_callchain_buffers();
> -free_charge:
> -       bpf_map_charge_finish(&mem);
> +free_smap:
>         bpf_map_area_free(smap);
>         return ERR_PTR(err);
>  }
> --
> 2.26.2
>
