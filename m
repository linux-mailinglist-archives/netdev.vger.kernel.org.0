Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E474716B603
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgBXXsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXXsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 18:48:43 -0500
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 461692176D;
        Mon, 24 Feb 2020 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582588121;
        bh=sWuV+tY7NBdsxuvlffWMhtvuK7q965UTmPAGjrcfTY8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A2bE7lGh8yiNxE/+dtRlL/Cp2ve6xG4jgg+q/YHjxMYv+CzAaWwpiIVsrRatXcn0M
         Z70q6p8Jk818yqtNd2Nw8D2xt/339IbN4sGhqF2VrOiG8P9Xmch2Nv/22Wi4UU+fCh
         TZHV3d08sFJu2kEU2GQ2lyMfMmXfPLrBX3yEzgVM=
Received: by mail-lf1-f51.google.com with SMTP id z5so8137847lfd.12;
        Mon, 24 Feb 2020 15:48:41 -0800 (PST)
X-Gm-Message-State: APjAAAUzj5v9eHrO8xqoZbB4+yu9ic2GVQgf77W9vM/cq+s6sLubDGvJ
        GW0sQ2nPNSMsE0tn5N83bWX+5/2Jifkfs++5kbM=
X-Google-Smtp-Source: APXvYqz8CTpsWczVVJwlaLuyzGgJQTb7tfUbWnugWaj1DPCDAAChGoXIZY5zMT0hQYD26/0N7Qo967nxgYmsidDoDyM=
X-Received: by 2002:ac2:58f1:: with SMTP id v17mr5230477lfo.52.1582588119422;
 Mon, 24 Feb 2020 15:48:39 -0800 (PST)
MIME-Version: 1.0
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
 <20200220071054.12499-1-forrest0579@gmail.com> <20200220071054.12499-2-forrest0579@gmail.com>
In-Reply-To: <20200220071054.12499-2-forrest0579@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 15:48:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
Message-ID: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: Add get_netns_id helper function for sock_ops
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 11:11 PM Lingpeng Chen <forrest0579@gmail.com> wrote:
>
> Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
> uniq connection because there may be multi net namespace.
> For example, there may be a chance that netns a and netns b all
> listen on 127.0.0.1:8080 and the client with same port 40782
> connect to them. Without netns number, sock ops program
> can't distinguish them.
> Using bpf_get_netns_id helper to get current connection
> netns id to distinguish connections.
>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> ---
>  include/uapi/linux/bpf.h |  9 ++++++++-
>  net/core/filter.c        | 20 ++++++++++++++++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f1d74a2bd234..e79082f78b74 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2892,6 +2892,12 @@ union bpf_attr {
>   *             Obtain the 64bit jiffies
>   *     Return
>   *             The 64 bit jiffies
> + *
> + * u64 bpf_get_netns_id(struct bpf_sock_ops *bpf_socket)
> + *  Description
> + *      Obtain netns id of sock
> + * Return
> + *      The current netns inum
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3012,7 +3018,8 @@ union bpf_attr {
>         FN(probe_read_kernel_str),      \
>         FN(tcp_send_ack),               \
>         FN(send_signal_thread),         \
> -       FN(jiffies64),
> +       FN(jiffies64),                  \
> +       FN(get_netns_id),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c180871e606d..5302ec9f7c0d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4421,6 +4421,24 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
>         .arg2_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_1(bpf_get_netns_id_sock_ops, struct bpf_sock_ops_kern *, bpf_sock)

I guess we only need bpf_get_netns_id,

> +{
> +#ifdef CONFIG_NET_NS
> +       struct sock *sk = bpf_sock->sk;
> +
> +       return (u64)sk->sk_net.net->ns.inum;
> +#else
> +       return 0;
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_get_netns_id_sock_ops_proto = {
and bpf_get_netns_id_proto.

> +       .func           = bpf_get_netns_id_sock_ops,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +};
> +
>  const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
>  EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
>
> @@ -6218,6 +6236,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_tcp_sock:
>                 return &bpf_tcp_sock_proto;
>  #endif /* CONFIG_INET */
> +       case BPF_FUNC_get_netns_id:
> +               return &bpf_get_netns_id_sock_ops_proto;
>         default:
>                 return bpf_base_func_proto(func_id);
>         }
> --
> 2.20.1
>
