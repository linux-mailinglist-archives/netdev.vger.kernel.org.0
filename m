Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7D02301F5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgG1FmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgG1FmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:42:12 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6526721883;
        Tue, 28 Jul 2020 05:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914931;
        bh=vZYUADPnamCQAhCKTU043kC1heWmZ4ILNRVZg14V7Ns=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iODAxcjceP7CCd/lyOoJ3iPcDLhQnhB+VjJNdZvkG1pqG3ACqZBihGPcMGjj6sOsQ
         LESg75WWFGpLDI0cFzHwMuhe2DwhOANXNrZKZgUC1nq4gOz23RDie4Js3ntYqTHj1x
         1+kA3oo9BAEIWp7axkLzQFeaW8/kb2E16it6Igys=
Received: by mail-lf1-f53.google.com with SMTP id i80so10292565lfi.13;
        Mon, 27 Jul 2020 22:42:11 -0700 (PDT)
X-Gm-Message-State: AOAM5320w0VQGi1fhxglI0VLIEebhGnCWmdl1epDIyaj7EZOy4RcvVnn
        JqrNANloXaUxETqq9r612BrxacX6usOTUSHN44w=
X-Google-Smtp-Source: ABdhPJxP6WPCD0JD9n5+iqlXW2uMERAt/Hk+sWRmGcX1wbKKxRzC84IpaQxpwg9uLLWSzaXMYYzzrW1meOG+I8Ckyj8=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr13234373lfr.69.1595914929714;
 Mon, 27 Jul 2020 22:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-26-guro@fb.com>
In-Reply-To: <20200727184506.2279656-26-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:41:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4jBU973ZzouXuxnueBoNEGnnyvt4M5CusmcWyTyttJAg@mail.gmail.com>
Message-ID: <CAPhsuW4jBU973ZzouXuxnueBoNEGnnyvt4M5CusmcWyTyttJAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 25/35] bpf: eliminate rlimit-based memory
 accounting for socket storage maps
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
> Do not use rlimit-based memory accounting for socket storage maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/core/bpf_sk_storage.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index fbcd03cd00d3..c0a35b6368af 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -676,8 +676,6 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
>         struct bpf_sk_storage_map *smap;
>         unsigned int i;
>         u32 nbuckets;
> -       u64 cost;
> -       int ret;
>
>         smap = kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
>         if (!smap)
> @@ -688,18 +686,9 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
>         /* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
>         nbuckets = max_t(u32, 2, nbuckets);
>         smap->bucket_log = ilog2(nbuckets);
> -       cost = sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
> -
> -       ret = bpf_map_charge_init(&smap->map.memory, cost);
> -       if (ret < 0) {
> -               kfree(smap);
> -               return ERR_PTR(ret);
> -       }
> -
>         smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
>                                  GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
>         if (!smap->buckets) {
> -               bpf_map_charge_finish(&smap->map.memory);
>                 kfree(smap);
>                 return ERR_PTR(-ENOMEM);
>         }
> --
> 2.26.2
>
