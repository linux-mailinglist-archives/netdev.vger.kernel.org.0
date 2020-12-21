Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E8D2E0274
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgLUWXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgLUWXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 17:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D363022B51;
        Mon, 21 Dec 2020 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608589375;
        bh=wSTS1iM6COo1UdMxbHJ3UBiJe70N63Ows1UGlNnH/Dw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S/5hOKJPG7S4zcKSsQzfJiFYoLsM4pgcRlRfmHD96qeeSGeWj2VB//RQJuF2lZqd1
         xSkVMaqoIVu+V5BEMJmpTimlQEZYSBCY9oK7jjsMZxfeytOWJ1cEXmo88fEgc2cfDS
         P1HIXpBJ8k5RcrgZtw79vlBOCoc+J1MhTrrpV9GdGb26oq+xAUk1wBCU47yxYj+BfM
         RL7K3Gb/LUAqhDKB9PFIKClvNgfESdmOulwfPpCf5I1ENMMzDEYaq1vWMKxCbUQVpq
         5jnID2movrjg9UdZx0MNgHXC2gOkK/Gzr8l1ffU6JXw3omGLm/B+rBRwxhw4c3fTX7
         O5Qx6JZAm+FIw==
Received: by mail-lf1-f43.google.com with SMTP id a12so27388985lfl.6;
        Mon, 21 Dec 2020 14:22:54 -0800 (PST)
X-Gm-Message-State: AOAM532vfwOA3KOqKa99GtXKJIvpTChn3tuDQdfhReDQ1sKUcCXHUf6I
        Kj0WZmbpB83pK7LegXG8uyX4U7VSf1dAEwKBzjg=
X-Google-Smtp-Source: ABdhPJyWO9hDk64mqqF3Q8RTzsYsMisjarmRUCb98vAX0wpQ5REmJXvhoDdY96DI72HMZpxX3p/fSIYMAUuaogJfeQc=
X-Received: by 2002:a19:8316:: with SMTP id f22mr8135175lfd.10.1608589373052;
 Mon, 21 Dec 2020 14:22:53 -0800 (PST)
MIME-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
In-Reply-To: <20201217172324.2121488-2-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Dec 2020 14:22:41 -0800
X-Gmail-Original-Message-ID: <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com>
Message-ID: <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> syscall starts incurring kzalloc/kfree cost. While, in general, it's
> not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> fastpath for incoming TCP, we don't want to have extra allocations in
> there.
>
> Let add a small buffer on the stack and use it for small (majority)
> {s,g}etsockopt values. I've started with 128 bytes to cover
> the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> currently, with some planned extension to 64 + some headroom
> for the future).

I don't really know the rule of thumb, but 128 bytes on stack feels too big to
me. I would like to hear others' opinions on this. Can we solve the problem
with some other mechanisms, e.g. a mempool?

[...]

>
> +static void *sockopt_export_buf(struct bpf_sockopt_kern *ctx)
> +{
> +       void *p;
> +
> +       if (ctx->optval != ctx->buf)
> +               return ctx->optval;
> +
> +       /* We've used bpf_sockopt_kern->buf as an intermediary storage,
> +        * but the BPF program indicates that we need to pass this
> +        * data to the kernel setsockopt handler. No way to export
> +        * on-stack buf, have to allocate a new buffer. The caller
> +        * is responsible for the kfree().
> +        */
> +       p = kzalloc(ctx->optlen, GFP_USER);
> +       if (!p)
> +               return ERR_PTR(-ENOMEM);
> +       memcpy(p, ctx->optval, ctx->optlen);
> +       return p;
> +}
> +
>  int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>                                        int *optname, char __user *optval,
>                                        int *optlen, char **kernel_optval)
> @@ -1389,8 +1420,14 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>                  * use original userspace data.
>                  */
>                 if (ctx.optlen != 0) {
> -                       *optlen = ctx.optlen;
> -                       *kernel_optval = ctx.optval;
> +                       void *buf = sockopt_export_buf(&ctx);

I found it is hard to follow the logic here (when to allocate memory, how to
fail over, etc.). Do we have plan to reuse sockopt_export_buf()? If not, it is
probably cleaner to put the logic in __cgroup_bpf_run_filter_setsockopt()?

Thanks,
Song

[...]
