Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34A2301DF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgG1FhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgG1FhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:37:21 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA7C21883;
        Tue, 28 Jul 2020 05:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914640;
        bh=5/1hGHRcRs8noQyW4y70zKajX2QRb/KbTYQH/XkqGLo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AU0TgowGCR0CGpCzEHB+dK+d4zlq0wxcjxrklzhtxM8DoXiTtbye/9bDoyfr3rYw3
         Cpc1spQE+8O4v5okj/HKLrFf1+69Fh6U+xm8Q6kCcBZbAdu8t8XWKuOnhxt86B5pmp
         XQl8F+nIPJvQ1s/GB0+WKoPK8RFppmSKjvnQFIGU=
Received: by mail-lj1-f179.google.com with SMTP id s16so4529907ljc.8;
        Mon, 27 Jul 2020 22:37:20 -0700 (PDT)
X-Gm-Message-State: AOAM530iSG+NgNzIIf9/W7o4WuZUVcLJKFMjlTd+TZjxY1n8qTskCNhR
        PfJ4yq/sLcvIKQ9J8pEvjhqrgKUPFJiyEZ6SGRk=
X-Google-Smtp-Source: ABdhPJw9Ihhk/7GIolHzsLcYxMM4WNd7zYLn9IMxzaHwG1XeTcrzGpvyiU4MB+PKJp5ng8tFB7HU7flbEtWk1o+l8DI=
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr11794649ljc.41.1595914638725;
 Mon, 27 Jul 2020 22:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-23-guro@fb.com>
In-Reply-To: <20200727184506.2279656-23-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:37:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7nHNaf9Cgjwr_3zLVae4yBiLsvd7+tVkpS6EaiGRZ4tA@mail.gmail.com>
Message-ID: <CAPhsuW7nHNaf9Cgjwr_3zLVae4yBiLsvd7+tVkpS6EaiGRZ4tA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 22/35] bpf: eliminate rlimit-based memory
 accounting for bpf ringbuffer
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
> Do not use rlimit-based memory accounting for bpf ringbuffer.
> It has been replaced with the memcg-based memory accounting.
>
> bpf_ringbuf_alloc() can't return anything except ERR_PTR(-ENOMEM)
> and a valid pointer, so to simplify the code make it return NULL
> in the first case. This allows to drop a couple of lines in
> ringbuf_map_alloc() and also makes it look similar to other memory
> allocating function like kmalloc().
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/ringbuf.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
>
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index e8e2c39cbdc9..e687b798d097 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -48,7 +48,6 @@ struct bpf_ringbuf {
>
>  struct bpf_ringbuf_map {
>         struct bpf_map map;
> -       struct bpf_map_memory memory;
>         struct bpf_ringbuf *rb;
>  };
>
> @@ -135,7 +134,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
>
>         rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
>         if (!rb)
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>
>         spin_lock_init(&rb->spinlock);
>         init_waitqueue_head(&rb->waitq);
> @@ -151,8 +150,6 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
>  static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
>  {
>         struct bpf_ringbuf_map *rb_map;
> -       u64 cost;
> -       int err;
>
>         if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
>                 return ERR_PTR(-EINVAL);
> @@ -174,26 +171,13 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
>
>         bpf_map_init_from_attr(&rb_map->map, attr);
>
> -       cost = sizeof(struct bpf_ringbuf_map) +
> -              sizeof(struct bpf_ringbuf) +
> -              attr->max_entries;
> -       err = bpf_map_charge_init(&rb_map->map.memory, cost);
> -       if (err)
> -               goto err_free_map;
> -
>         rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
> -       if (IS_ERR(rb_map->rb)) {
> -               err = PTR_ERR(rb_map->rb);
> -               goto err_uncharge;
> +       if (!rb_map->rb) {
> +               kfree(rb_map);
> +               return ERR_PTR(-ENOMEM);
>         }
>
>         return &rb_map->map;
> -
> -err_uncharge:
> -       bpf_map_charge_finish(&rb_map->map.memory);
> -err_free_map:
> -       kfree(rb_map);
> -       return ERR_PTR(err);
>  }
>
>  static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
> --
> 2.26.2
>
