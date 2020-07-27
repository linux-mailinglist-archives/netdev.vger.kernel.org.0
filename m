Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67C122FC7E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgG0Wsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgG0Wsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:48:38 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E45B20829;
        Mon, 27 Jul 2020 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595890117;
        bh=TOhQZKza90iwMIAs1uYyFDZuUVL2WSyMrGnwMcLOZ68=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xzCYleq179jMpqUj+riUZvWtokCxNkLGyi9QUytLv1xmdPD/hOdWJ+5dp6WDB9IX5
         F0jnkjsbo4xfmVuhILvt8logioUQ3m5wRQMs13xvXZkG1A1phJTads/zOkLkZKQ75g
         PO8oFuvRJkWgxZuw5oVGkdI8JpKsUY/Pg8jNKfYs=
Received: by mail-lj1-f179.google.com with SMTP id q6so19031826ljp.4;
        Mon, 27 Jul 2020 15:48:37 -0700 (PDT)
X-Gm-Message-State: AOAM531oUZjFBmZvfAEwbgtJeG6tt+DbydJfkczr6Ydgyc3tiaDO4pmu
        2I97ogRtGPXpdZWJa0Gnh/t1SvMgiSXFAs6IwSA=
X-Google-Smtp-Source: ABdhPJw1tm9z/uKaNtSzGme1cn0f8J3ABRl2w1A8eu3JzfJ4qeg0L+Neo9FfePMBPYm42hbGDW6d+L1YxrMoGW+Izt4=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr2693713ljg.10.1595890115575;
 Mon, 27 Jul 2020 15:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-5-guro@fb.com>
In-Reply-To: <20200727184506.2279656-5-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 15:48:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4gJ_3xJxmMuj+2yiPff1a1GiosjcNdaLG_VS6F=E+O1g@mail.gmail.com>
Message-ID: <CAPhsuW4gJ_3xJxmMuj+2yiPff1a1GiosjcNdaLG_VS6F=E+O1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/35] bpf: refine memcg-based memory
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

On Mon, Jul 27, 2020 at 12:23 PM Roman Gushchin <guro@fb.com> wrote:
>
> Include metadata and percpu data into the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/cpumap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index f1c46529929b..74ae9fcbe82e 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -99,7 +99,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>             attr->map_flags & ~BPF_F_NUMA_NODE)
>                 return ERR_PTR(-EINVAL);
>
> -       cmap = kzalloc(sizeof(*cmap), GFP_USER);
> +       cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_ACCOUNT);
>         if (!cmap)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -418,7 +418,7 @@ static struct bpf_cpu_map_entry *
>  __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
>  {
>         int numa, err, i, fd = value->bpf_prog.fd;
> -       gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
> +       gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_NOWARN;
>         struct bpf_cpu_map_entry *rcpu;
>         struct xdp_bulk_queue *bq;
>
> --
> 2.26.2
>
