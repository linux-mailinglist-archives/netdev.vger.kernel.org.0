Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6ED22FE3E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgG0X6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0X6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:58:37 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D91920729;
        Mon, 27 Jul 2020 23:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595894316;
        bh=KOHL4dqqOgt80ENeUP3fboWfrZ4Es2kGP47CsCXbxcc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aYLfTp63EvOY7mzzhG3YX+3lCzRVUC/99sTt3Kzg6B7o1mRawcxxXeAzPgkFayaGb
         CtzdbutF1yLSPKl9jqguggzLu+kvTJ3tlhfvsSEdQEpRmXgdcLzM2yQkM9wkD4T5M5
         P/0wVHxukuXpUMIQv/O9iXuJYx8tVa9Sqt6Ne5EA=
Received: by mail-lj1-f178.google.com with SMTP id s16so3947607ljc.8;
        Mon, 27 Jul 2020 16:58:36 -0700 (PDT)
X-Gm-Message-State: AOAM5326Np0b4C1fDMHNEP0wMRbyVzd1Lran4EkIpVTnUH35UlHu9tvg
        aSSmexu/xEpQkaQwryyHHkA8BciZnm+iYqBPBIE=
X-Google-Smtp-Source: ABdhPJyv4OWF5To6eW9anQABnbVH7sCiHCLi4jX2RUv1HVc5jxz2Gscx3ylyxBMeO5DNTJGjoZiX9w8flGdoziNTeDY=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr11178609ljk.27.1595894314926;
 Mon, 27 Jul 2020 16:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-12-guro@fb.com>
In-Reply-To: <20200727184506.2279656-12-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 16:58:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW70Tzw=V7+N9Y=rzKSyihtiHHv03B_=Murr+GyepUTtpA@mail.gmail.com>
Message-ID: <CAPhsuW70Tzw=V7+N9Y=rzKSyihtiHHv03B_=Murr+GyepUTtpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/35] bpf: refine memcg-based memory
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

On Mon, Jul 27, 2020 at 12:27 PM Roman Gushchin <guro@fb.com> wrote:
>
> Include internal metadata into the memcg-based memory accounting.
> Also include the memory allocated on updating an element.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/core/sock_map.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 119f52a99dc1..bc797adca44c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -38,7 +38,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
>             attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
>                 return ERR_PTR(-EINVAL);
>
> -       stab = kzalloc(sizeof(*stab), GFP_USER);
> +       stab = kzalloc(sizeof(*stab), GFP_USER | __GFP_ACCOUNT);
>         if (!stab)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -829,7 +829,8 @@ static struct bpf_shtab_elem *sock_hash_alloc_elem(struct bpf_shtab *htab,
>                 }
>         }
>
> -       new = kmalloc_node(htab->elem_size, GFP_ATOMIC | __GFP_NOWARN,
> +       new = kmalloc_node(htab->elem_size,
> +                          GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
>                            htab->map.numa_node);
>         if (!new) {
>                 atomic_dec(&htab->count);
> @@ -1011,7 +1012,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
>         if (attr->key_size > MAX_BPF_STACK)
>                 return ERR_PTR(-E2BIG);
>
> -       htab = kzalloc(sizeof(*htab), GFP_USER);
> +       htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
>         if (!htab)
>                 return ERR_PTR(-ENOMEM);
>
> --
> 2.26.2
>
