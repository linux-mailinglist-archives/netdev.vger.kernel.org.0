Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABC2301CB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgG1Fcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG1Fct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:32:49 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B160F20829;
        Tue, 28 Jul 2020 05:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914369;
        bh=7fZc0YPRr1LmxCFj3GVuv6A1HWSBq66zW/yYIQ2J5L4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PtA8P4Yoa0OVOGlP0bitg0RsWdZ/LIoDqvRKl28qVvsl98gzzTApb/1M/8ciTXyhi
         BeWVvw4u4ENtrPrSPr0sNrqTpMr95ECsFIIdik7atAmz7gQBp6Rz/RnKHp/SZ9pZZ/
         mnVR9gzaB0Lq7z0Kh6j+vg/q3gEjACy3CdMoIZ1k=
Received: by mail-lf1-f44.google.com with SMTP id i80so10282402lfi.13;
        Mon, 27 Jul 2020 22:32:48 -0700 (PDT)
X-Gm-Message-State: AOAM531VjdBqNsprVktMtrDTxKVNBYGkYWBRObUPXXM0EaehYm4TJ+p/
        QzB9kcuEBmzGeCk0G3ZMdtCInQXBJzvqrpJCjas=
X-Google-Smtp-Source: ABdhPJztGfV9oT99CGVNx6+aNi1JjL45Huyn8q98Q66k9fJ0t4IRMC6rtA0cZWtyoAOrywThC9RSbd6QaOG1ENKHgkA=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr13215297lfr.69.1595914367019;
 Mon, 27 Jul 2020 22:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-20-guro@fb.com>
In-Reply-To: <20200727184506.2279656-20-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:32:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5VxGQfDRVU6hH6xj4qU7p0hpmupvLnpE9fgexdK8D+rQ@mail.gmail.com>
Message-ID: <CAPhsuW5VxGQfDRVU6hH6xj4qU7p0hpmupvLnpE9fgexdK8D+rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 19/35] bpf: eliminate rlimit-based memory
 accounting for lpm_trie maps
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
> Do not use rlimit-based memory accounting for lpm_trie maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/lpm_trie.c | 13 -------------
>  1 file changed, 13 deletions(-)
>
> diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
> index d85e0fc2cafc..c747f0835eb1 100644
> --- a/kernel/bpf/lpm_trie.c
> +++ b/kernel/bpf/lpm_trie.c
> @@ -540,8 +540,6 @@ static int trie_delete_elem(struct bpf_map *map, void *_key)
>  static struct bpf_map *trie_alloc(union bpf_attr *attr)
>  {
>         struct lpm_trie *trie;
> -       u64 cost = sizeof(*trie), cost_per_node;
> -       int ret;
>
>         if (!bpf_capable())
>                 return ERR_PTR(-EPERM);
> @@ -567,20 +565,9 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
>                           offsetof(struct bpf_lpm_trie_key, data);
>         trie->max_prefixlen = trie->data_size * 8;
>
> -       cost_per_node = sizeof(struct lpm_trie_node) +
> -                       attr->value_size + trie->data_size;
> -       cost += (u64) attr->max_entries * cost_per_node;
> -
> -       ret = bpf_map_charge_init(&trie->map.memory, cost);
> -       if (ret)
> -               goto out_err;
> -
>         spin_lock_init(&trie->lock);
>
>         return &trie->map;
> -out_err:
> -       kfree(trie);
> -       return ERR_PTR(ret);
>  }
>
>  static void trie_free(struct bpf_map *map)
> --
> 2.26.2
>
