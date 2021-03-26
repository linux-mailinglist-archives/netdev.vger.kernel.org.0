Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5128B34AFF7
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCZUOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhCZUOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:14:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 948BC61A13;
        Fri, 26 Mar 2021 20:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616789639;
        bh=P6XgJfeaLV4l6Mrox/PZ2zqyTqkqyBaQLnc6TpMQ0bo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J+Eq6HPJ/8KHwp68/AvhXuXl85ZEDSgadfsGKLgXiDFfGZqzqF6XjBgLALAwh1rhP
         jLOMqX+O4hHr2IDtCHX85Ph1fiatD4KsDwyvtm/naX03X20tyuD0DGXNXk1P/bGpW8
         tYtd92Hvd1Oam5JiopVgBNtzimnZs5uMsiV1y1XLtH1axCVv2UC6rc1fA2iJLLdqa/
         oqQH06Nlas/COX+BUwjtLymqP6ozp3nsbBy7uKf5Zk08v8sU+YB9YAP17h6hMRcOYG
         eLvXIkNDkzbG4AiaaHmjymJtC98zcRRbAoJEoiEm9p45sDaOqv7bLJvj2ttOQ2Te7D
         MdKgLb5c5AaWg==
Received: by mail-lj1-f180.google.com with SMTP id u9so8757528ljd.11;
        Fri, 26 Mar 2021 13:13:59 -0700 (PDT)
X-Gm-Message-State: AOAM5338QqsKADWKeB1qdXbBkw/BdbDGi7kve1Ex7fRuGB69XnL6ATgJ
        TmBEhqxntzoFg1VRwOoeoO4i2Z2jDzbx+HukFFA=
X-Google-Smtp-Source: ABdhPJySRIwdKRkC7GQqzpYUbk6+eBfuY9zsiLwz31UjXB4dLAXAeuZemHXN9dnG0Ubispt1fhNh3tmpyZkFahL4vig=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr10026401lji.270.1616789637881;
 Fri, 26 Mar 2021 13:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com> <20210326160501.46234-2-lmb@cloudflare.com>
In-Reply-To: <20210326160501.46234-2-lmb@cloudflare.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Mar 2021 13:13:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
Message-ID: <CAPhsuW7E4bhEGcboKQ5O=1o0iVNPLpJB1nrAgxweiZqGhZm-JQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf: program: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 9:07 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> As for bpf_link, refuse creating a non-O_RDWR fd. Since program fds
> currently don't allow modifications this is a precaution, not a
> straight up bug fix.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  kernel/bpf/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index dc56237d6960..d2de2abec35b 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
>                 return PTR_ERR(raw);

For both patches, shall we do the check before bpf_obj_do_get(), which is a few
lines above?

Thanks,
Song

>
>         if (type == BPF_TYPE_PROG)
> -               ret = bpf_prog_new_fd(raw);
> +               ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
>         else if (type == BPF_TYPE_MAP)
>                 ret = bpf_map_new_fd(raw, f_flags);
>         else if (type == BPF_TYPE_LINK)
> --
> 2.27.0
>
