Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128B522FBEC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgG0WL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:11:56 -0400
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61CC62075D;
        Mon, 27 Jul 2020 22:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595887915;
        bh=YW8G5VIksYVlmPs2UYgjtPkt8iVM6SF5lgGo16m/L+s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VEg/hiXbEvSHn7tT7/JVBAirYrXZkHYmk4kdcPNa/scCSdEmq7h+lM4JGHAH9d+zw
         myLFxqOizViKGdWaCDv7NE2V+mRVuFha62/JUGkXl3qDEvwOLMqlZv7vSmZ3tN28/1
         u2l0pzq8mz4u4nTf90pIJxGzq8WgUS3lr2j2ZlDM=
Received: by mail-lj1-f176.google.com with SMTP id d17so18969873ljl.3;
        Mon, 27 Jul 2020 15:11:55 -0700 (PDT)
X-Gm-Message-State: AOAM532Ps1eGbC+nJDrGtIBsymc1JQe2vBDMjwEC+JjY5LGVXnTYknuw
        p5fVCKfE5U3Zn9Z+oCUKbpUlKGuI7lJiPND1Eno=
X-Google-Smtp-Source: ABdhPJyZ6t063En8urXrZJrupJ8Ja4mHFNI8fGTOXCFR2l6OXfdWbkzRLIN2bX2+ImzTYbrrLG7ml3lTI3tqrwiy9JY=
X-Received: by 2002:a2e:9996:: with SMTP id w22mr12043567lji.446.1595887913748;
 Mon, 27 Jul 2020 15:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-2-guro@fb.com>
In-Reply-To: <20200727184506.2279656-2-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 15:11:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW49mOQYCx77jucJ_NkeYhoSxOZ_cCujBUjgMdJBy3keeg@mail.gmail.com>
Message-ID: <CAPhsuW49mOQYCx77jucJ_NkeYhoSxOZ_cCujBUjgMdJBy3keeg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/35] bpf: memcg-based memory accounting for
 bpf progs
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

On Mon, Jul 27, 2020 at 12:20 PM Roman Gushchin <guro@fb.com> wrote:
>
> Include memory used by bpf programs into the memcg-based accounting.
> This includes the memory used by programs itself, auxiliary data
> and statistics.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  kernel/bpf/core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index bde93344164d..daab8dcafbd4 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
>
>  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog_aux *aux;
>         struct bpf_prog *fp;
>
> @@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>         if (fp == NULL)
>                 return NULL;
>
> -       aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
> +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
>         if (aux == NULL) {
>                 vfree(fp);
>                 return NULL;
> @@ -104,7 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>
>  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog *prog;
>         int cpu;
>
> @@ -217,7 +217,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
>  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>                                   gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog *fp;
>         u32 pages, delta;
>         int ret;
> --

Do we need similar changes in

bpf_prog_array_copy()
bpf_prog_alloc_jited_linfo()
bpf_prog_clone_create()

and maybe a few more?

Thanks,
Song
