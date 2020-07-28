Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8722301BB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgG1Fat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1Fas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:30:48 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0085A20759;
        Tue, 28 Jul 2020 05:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914248;
        bh=gBdRHY3hhfymtWLH0XkstzchGZQpmabzhAQ4I9TsFBM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P1WNNLpPb3cs+ClJdI7wYuPqxXAiahL4fPF1oTNP7mzfvH0VaQOuG1ZkDZpPuiLxO
         EzdcdxoVUHBEAdng1ayEsW3bM1x5HZrlb0mxzwN1ykDGsIOzkDXyGA8Nxv+VmyxQhh
         80CLXBQaivSLe8VkuP6IMrvO9JItEL/Qi726MDJs=
Received: by mail-lj1-f169.google.com with SMTP id s16so4516967ljc.8;
        Mon, 27 Jul 2020 22:30:47 -0700 (PDT)
X-Gm-Message-State: AOAM530au6S5MK3W8/IwOIu+GOtTJFIste2zvpSd/Pf+uE2hDKAC2wNM
        DyybHVtFwWm0A+w+UJxlYfXOf/ugZUkeLi9a23Y=
X-Google-Smtp-Source: ABdhPJwqr+9HGhDkGzGcMpNBfNt4mSJT54CLjVbdqvvXmAmGhUQ4Q46CRg3c2k9ejnLXNu6aWl3vT8oVVVZlgjVM0Bo=
X-Received: by 2002:a2e:3003:: with SMTP id w3mr11841791ljw.273.1595914246316;
 Mon, 27 Jul 2020 22:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-16-guro@fb.com>
In-Reply-To: <20200727184506.2279656-16-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:30:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4-ubo3iz=-0=yQOEkQKFVpkChycUwGBV-gdsgoAOybnw@mail.gmail.com>
Message-ID: <CAPhsuW4-ubo3iz=-0=yQOEkQKFVpkChycUwGBV-gdsgoAOybnw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 15/35] bpf: eliminate rlimit-based memory
 accounting for cpumap maps
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
> Do not use rlimit-based memory accounting for cpumap maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/cpumap.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 74ae9fcbe82e..50f3444a3301 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -86,8 +86,6 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>         u32 value_size = attr->value_size;
>         struct bpf_cpu_map *cmap;
>         int err = -ENOMEM;
> -       u64 cost;
> -       int ret;
>
>         if (!bpf_capable())
>                 return ERR_PTR(-EPERM);
> @@ -111,26 +109,14 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>                 goto free_cmap;
>         }
>
> -       /* make sure page count doesn't overflow */
> -       cost = (u64) cmap->map.max_entries * sizeof(struct bpf_cpu_map_entry *);
> -
> -       /* Notice returns -EPERM on if map size is larger than memlock limit */
> -       ret = bpf_map_charge_init(&cmap->map.memory, cost);
> -       if (ret) {
> -               err = ret;
> -               goto free_cmap;
> -       }
> -
>         /* Alloc array for possible remote "destination" CPUs */
>         cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
>                                            sizeof(struct bpf_cpu_map_entry *),
>                                            cmap->map.numa_node);
>         if (!cmap->cpu_map)
> -               goto free_charge;
> +               goto free_cmap;
>
>         return &cmap->map;
> -free_charge:
> -       bpf_map_charge_finish(&cmap->map.memory);
>  free_cmap:
>         kfree(cmap);
>         return ERR_PTR(err);
> --
> 2.26.2
>
