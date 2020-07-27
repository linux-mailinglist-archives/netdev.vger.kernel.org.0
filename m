Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5A422FE36
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgG0X4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0X4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:56:41 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21CC820679;
        Mon, 27 Jul 2020 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595894200;
        bh=pIvFrotDaXLQ53fI6ndW8jI8DT1JK2t5D5sC0WCfGr8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jwF1CbD0GAuxK4wrdhWzcn+JPtunKxSvvFDxv5qAMwsY5AqtVnLIKyzChwRUJk+ET
         BE14SahExuO3hIHqCFE1pgPACnIuaKaomfxpyf++C4hRYBSDYmaeUauI8Btk74+lqA
         vCBR5Rtfhgo628/xVYhZZqeuhK8xu8QxK6183ZYw=
Received: by mail-lj1-f170.google.com with SMTP id x9so19173325ljc.5;
        Mon, 27 Jul 2020 16:56:40 -0700 (PDT)
X-Gm-Message-State: AOAM533yHzAPkZCsK4PrudF5qxalH64OMNw9u+wycKBeuDpirpZBcCEC
        8j56Q9RUACjym5fHkg6F1IxlJt1YMRwV7cgvxeg=
X-Google-Smtp-Source: ABdhPJzU25QM6X7+NjrWASkQh6IbY/CuZrlfdu20GW08qB6Rm4g8RyXQjMZLEQ/1KX7I6CI0cW0kBqTdI8Zotm1w+nE=
X-Received: by 2002:a2e:81c2:: with SMTP id s2mr2781767ljg.10.1595894198520;
 Mon, 27 Jul 2020 16:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-10-guro@fb.com>
In-Reply-To: <20200727184506.2279656-10-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 16:56:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5W5TJUEcSH-q3Q2-YmJsPZ2PxvgKcAmYVO0xut3MD+sg@mail.gmail.com>
Message-ID: <CAPhsuW5W5TJUEcSH-q3Q2-YmJsPZ2PxvgKcAmYVO0xut3MD+sg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 09/35] bpf: memcg-based memory accounting for
 bpf ringbuffer
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
> Enable the memcg-based memory accounting for the memory used by
> the bpf ringbuffer.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/ringbuf.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 002f8a5c9e51..e8e2c39cbdc9 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -60,8 +60,8 @@ struct bpf_ringbuf_hdr {
>
>  static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
>  {
> -       const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
> -                           __GFP_ZERO;
> +       const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
> +                           __GFP_NOWARN | __GFP_ZERO;
>         int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
>         int nr_data_pages = data_sz >> PAGE_SHIFT;
>         int nr_pages = nr_meta_pages + nr_data_pages;
> @@ -89,7 +89,8 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
>          */
>         array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
>         if (array_size > PAGE_SIZE)
> -               pages = vmalloc_node(array_size, numa_node);
> +               pages = __vmalloc_node(array_size, 1, GFP_KERNEL_ACCOUNT,
> +                                      numa_node, __builtin_return_address(0));
>         else
>                 pages = kmalloc_node(array_size, flags, numa_node);
>         if (!pages)
> @@ -167,7 +168,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
>                 return ERR_PTR(-E2BIG);
>  #endif
>
> -       rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> +       rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_ACCOUNT);
>         if (!rb_map)
>                 return ERR_PTR(-ENOMEM);
>
> --
> 2.26.2
>
