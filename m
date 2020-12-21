Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBF2E0297
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLUWlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLUWlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 17:41:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231AA22D2A;
        Mon, 21 Dec 2020 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608590458;
        bh=eroVDsgkwPE0p23aSdWQOoS+rJ1sqpmZb2dMjFjGBdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h9olFuwF/LtHR5EurtJsEvuU6YhRe1WduPf4zsjb3u7g5gI/wFBBP4n0G+Ys5UGzS
         yMf7A18d81RkqpCdcMedAQAwW1tNdLoeQlLh217Ynrx9nnNidHMgm30UYXhliwxVdr
         dAXgrkuUCku24C/eR8GQkXEqkD2r5M4S/wuUEGDeTxo9LgkentE1JA4EyuWGB7O3KN
         ZHC0uGDLRnSIooTm+G1mc7eHbPxy9rqcEeDTRxPhYEbaB/k/tL5smkC+rphvO2eISt
         weMBL9Y43C7phgcjtZNtODChlY97QbwTRf5yt9Atkx8qxM4RTraAt/Ejraxd05Ql/C
         XDAPWE5ZJUiSg==
Received: by mail-lf1-f47.google.com with SMTP id x20so27397002lfe.12;
        Mon, 21 Dec 2020 14:40:58 -0800 (PST)
X-Gm-Message-State: AOAM531qAVpIQCKVEzere3tEVwi0avHBJOi9NU5+x8+C2kILuqmGFXff
        ZaE3HHe5GuEkclQcYjfz6xuE5LfKiReIGQ+JB/c=
X-Google-Smtp-Source: ABdhPJyLbjGZqPCK7a9fWx4OfY3BhYhoL2BLeHIqZSn2zS47ujTqMiTvUwHZkEWquhgwz8ACTKkXhrr6O6lOdtmWMEc=
X-Received: by 2002:ac2:5199:: with SMTP id u25mr7241662lfi.438.1608590456361;
 Mon, 21 Dec 2020 14:40:56 -0800 (PST)
MIME-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-3-sdf@google.com>
In-Reply-To: <20201217172324.2121488-3-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Dec 2020 14:40:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW63um6NL6QF4E=iYpCeCiavuqYahO1h39Eu=agQU8LL5g@mail.gmail.com>
Message-ID: <CAPhsuW63um6NL6QF4E=iYpCeCiavuqYahO1h39Eu=agQU8LL5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: split cgroup_bpf_enabled per attach type
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 9:26 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> When we attach any cgroup hook, the rest (even if unused/unattached) start
> to contribute small overhead. In particular, the one we want to avoid is
> __cgroup_bpf_run_filter_skb which does two redirections to get to
> the cgroup and pushes/pulls skb.
>
> Let's split cgroup_bpf_enabled to be per-attach to make sure
> only used attach types trigger.
>
> I've dropped some existing high-level cgroup_bpf_enabled in some
> places because BPF_PROG_CGROUP_XXX_RUN macros usually have another
> cgroup_bpf_enabled check.
>
> I also had to copy-paste BPF_CGROUP_RUN_SA_PROG_LOCK for
> GETPEERNAME/GETSOCKNAME because type for cgroup_bpf_enabled[type]
> has to be constant and known at compile time.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

[...]

> @@ -252,8 +252,10 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  #define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)                        \
>         BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
>
> -#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
> -                                           sk->sk_prot->pre_connect)
> +#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)                                    \
> +       ((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||                      \
> +         cgroup_bpf_enabled(BPF_CGROUP_INET6_CONNECT)) &&                     \
> +        sk->sk_prot->pre_connect)

Patchworks highlighted the following (from checkpatch.pl I guess):

CHECK: Macro argument 'sk' may be better as '(sk)' to avoid precedence issues
#99: FILE: include/linux/bpf-cgroup.h:255:
+#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)       \
+ ((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||       \
+  cgroup_bpf_enabled(BPF_CGROUP_INET6_CONNECT)) &&       \
+ sk->sk_prot->pre_connect)

Other than, looks good to me.

Acked-by: Song Liu <songliubraving@fb.com>
