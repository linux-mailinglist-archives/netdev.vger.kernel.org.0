Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6153F0A88
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhHRRuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhHRRt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1079D6113E;
        Wed, 18 Aug 2021 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629308963;
        bh=FTA7NBlPmQ87b+/3ICG0beyJjC2nFsi1xUEgFApxbCk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sJ+2FQYrQ2bCno+p1yrzBV22IHyy1wsBrYDN2TOX82UgfhPi/kuV4tzntrSj1zF0f
         /+PVBLr6pDw2jeArkD9lFCI2R9mjQJBPeiLHhA+oggIrhjHEhYCGsiXwwrJMA43U/t
         OSgq8qPcmVrpMN+zA80Ow0PUfGm2MV8swg8i73PmgX6NgARU+7amPi4smieqYmkxQ+
         DsSMI41E1JyojsihUwtUBoo8Sfe+deE0UrDHRTMRpH3F7XYgWa0uZ9DMaW3vsYM6kj
         E8m12Pfqa9G7hCOHM/Fnh6QyoZi58tJfFJE5MhR7tlJC5/dPRISdwNQdRXWcauXOB/
         f/sPLIByLW/ng==
Received: by mail-lf1-f45.google.com with SMTP id i28so6374445lfl.2;
        Wed, 18 Aug 2021 10:49:22 -0700 (PDT)
X-Gm-Message-State: AOAM532NR2r2QLrk7BPUJgoAlZguFH4jNeYuW2Guw/oyVskBmuA3vRJ1
        86VcryyeR4xldWrQqDC0YoJPL9iHTtVekGq0xnU=
X-Google-Smtp-Source: ABdhPJyr26jMxYrTHiFpFCDUSjRFmvUpCeny2WhWgTXDg2Js7gy+27A++K/xBDl1I2VKah3afE/arklNAjwI3oLLvBg=
X-Received: by 2002:a05:6512:169d:: with SMTP id bu29mr7216860lfb.160.1629308961316;
 Wed, 18 Aug 2021 10:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210818105820.91894-1-liuxu623@gmail.com> <20210818105820.91894-2-liuxu623@gmail.com>
In-Reply-To: <20210818105820.91894-2-liuxu623@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 18 Aug 2021 10:49:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7N320YMpgyomJt+E1wPpxBFjezus5R7H+SHmbxhBzAEQ@mail.gmail.com>
Message-ID: <CAPhsuW7N320YMpgyomJt+E1wPpxBFjezus5R7H+SHmbxhBzAEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
To:     Xu Liu <liuxu623@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 4:00 AM Xu Liu <liuxu623@gmail.com> wrote:
>
> We'd like to be able to identify netns from sockops hooks
> to accelerate local process communication form different netns.
>
> Signed-off-by: Xu Liu <liuxu623@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/core/filter.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index d70187ce851b..34938a537931 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4664,6 +4664,18 @@ static const struct bpf_func_proto bpf_get_netns_cookie_sock_addr_proto = {
>         .arg1_type      = ARG_PTR_TO_CTX_OR_NULL,
>  };
>
> +BPF_CALL_1(bpf_get_netns_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
> +{
> +       return __bpf_get_netns_cookie(ctx ? ctx->sk : NULL);
> +}
> +
> +static const struct bpf_func_proto bpf_get_netns_cookie_sock_ops_proto = {
> +       .func           = bpf_get_netns_cookie_sock_ops,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX_OR_NULL,
> +};
> +
>  BPF_CALL_1(bpf_get_socket_uid, struct sk_buff *, skb)
>  {
>         struct sock *sk = sk_to_full_sk(skb->sk);
> @@ -7445,6 +7457,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_sk_storage_get_proto;
>         case BPF_FUNC_sk_storage_delete:
>                 return &bpf_sk_storage_delete_proto;
> +       case BPF_FUNC_get_netns_cookie:
> +               return &bpf_get_netns_cookie_sock_ops_proto;
>  #ifdef CONFIG_INET
>         case BPF_FUNC_load_hdr_opt:
>                 return &bpf_sock_ops_load_hdr_opt_proto;
> --
> 2.28.0
>
