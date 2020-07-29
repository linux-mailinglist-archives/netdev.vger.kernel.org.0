Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631C9232798
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgG2WZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgG2WZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 18:25:59 -0400
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBEDA20829;
        Wed, 29 Jul 2020 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596061558;
        bh=7n0clHuije8j3f6dXF+0gUhWx1igJqnZtHwZQjMQ2ss=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tzO3vD3q25SFVEB/DepYN6C97y7J7eaxncePrV8JgcTzalSmbSPtyUp/4HZbpCBdX
         7RvsCR0WuCrKfZewX0HQPwpWwG6PRi8AOBDrvrEXFXL3CFpiTbR7j3hK671zNI76UT
         mNz3cxN7TQLS8BRatRHXlMZ5sZC98aikoa750pIU=
Received: by mail-lj1-f175.google.com with SMTP id 185so16544547ljj.7;
        Wed, 29 Jul 2020 15:25:57 -0700 (PDT)
X-Gm-Message-State: AOAM5305Bi2YW9fpl0VfwiNeymr2Rtl53G0Ctrry/eTNUsPK9fHHy2sc
        /Au8M+cY/xWb3OiZ/NL2tndDepITuCaS6O8HpOQ=
X-Google-Smtp-Source: ABdhPJwrG1N3kwpd9NMuEaVqD9fVy9dPruQalJRFMJMND+mwflCcvi5OUa1Xewgm9Xw8Cmr46yfTyvlHa50ChkHn3R0=
X-Received: by 2002:a2e:3003:: with SMTP id w3mr4768ljw.273.1596061556251;
 Wed, 29 Jul 2020 15:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200724203830.81531-1-alexei.starovoitov@gmail.com> <20200724203830.81531-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20200724203830.81531-2-alexei.starovoitov@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 15:25:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51PCaza9yu-SRVvjaAOU3_fxCEsY9Jjq8zzCFwS8oDpg@mail.gmail.com>
Message-ID: <CAPhsuW51PCaza9yu-SRVvjaAOU3_fxCEsY9Jjq8zzCFwS8oDpg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/4] bpf: Factor out bpf_link_get_by_id() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 1:39 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Refactor the code a bit to extract bpf_link_get_by_id() helper.

The commit log doesn't match the code: bpf_link_get_by_id() vs.
bpf_link_by_id().

> It's similar to existing bpf_prog_by_id().
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Other than that,

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  include/linux/bpf.h  |  1 +
>  kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
>  2 files changed, 29 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8357be349133..d5c4e2cc24a0 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1355,6 +1355,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
>                          struct btf *btf, const struct btf_type *t);
>
>  struct bpf_prog *bpf_prog_by_id(u32 id);
> +struct bpf_link *bpf_link_by_id(u32 id);
>
>  const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
>  #else /* !CONFIG_BPF_SYSCALL */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index ee290b1f2d9e..42eb0d622980 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3984,40 +3984,50 @@ static int link_update(union bpf_attr *attr)
>         return ret;
>  }
>
> -static int bpf_link_inc_not_zero(struct bpf_link *link)
> +static struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
>  {
> -       return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? 0 : -ENOENT;
> +       return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? link : ERR_PTR(-ENOENT);
>  }
>
> -#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
> -
> -static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
> +struct bpf_link *bpf_link_by_id(u32 id)
>  {
>         struct bpf_link *link;
> -       u32 id = attr->link_id;
> -       int fd, err;
>
> -       if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
> -               return -EINVAL;
> -
> -       if (!capable(CAP_SYS_ADMIN))
> -               return -EPERM;
> +       if (!id)
> +               return ERR_PTR(-ENOENT);
>
>         spin_lock_bh(&link_idr_lock);
> -       link = idr_find(&link_idr, id);
>         /* before link is "settled", ID is 0, pretend it doesn't exist yet */
> +       link = idr_find(&link_idr, id);
>         if (link) {
>                 if (link->id)
> -                       err = bpf_link_inc_not_zero(link);
> +                       link = bpf_link_inc_not_zero(link);
>                 else
> -                       err = -EAGAIN;
> +                       link = ERR_PTR(-EAGAIN);
>         } else {
> -               err = -ENOENT;
> +               link = ERR_PTR(-ENOENT);
>         }
>         spin_unlock_bh(&link_idr_lock);
> +       return link;
> +}
>
> -       if (err)
> -               return err;
> +#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
> +
> +static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
> +{
> +       struct bpf_link *link;
> +       u32 id = attr->link_id;
> +       int fd;
> +
> +       if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
> +               return -EINVAL;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       link = bpf_link_by_id(id);
> +       if (IS_ERR(link))
> +               return PTR_ERR(link);
>
>         fd = bpf_link_new_fd(link);
>         if (fd < 0)
> --
> 2.23.0
>
