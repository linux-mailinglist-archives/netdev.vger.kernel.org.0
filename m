Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09C1154B72
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgBFSs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:48:58 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39218 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 13:48:58 -0500
Received: by mail-oi1-f193.google.com with SMTP id z2so5657553oih.6;
        Thu, 06 Feb 2020 10:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mR5xQPBsCDP5sxHfwtSDwtS5A2L0vDKJavonjD70TJU=;
        b=TpdJll+C56zKh7PPU2Z9PRemfGcJuaV+HxsePNF3CtrwuLKdhSXYQDlC07yj2SeT5Y
         /ZkkIQLvDRXuCD9TtSrIyjM84nMTgERVzHKNmybz5n1TqKrLMthy3DaBKxrc+et3eAsj
         7MxJgONtAOgXCDMVkXN8IS2q4ZA6GoQ0V52PgKKuQGpuv5BJUZF9uMQtTStC2hBknGvM
         ykwW6ezm1EopaKRd21DULiLNHmdGstkC3z7G+pgwVCCB+glGuOgClZywrnlaSkPG1wOO
         DFWlcZZ0uK9i5P32bcnJ2O96/caCL5gxaGqvm0bfSe4hlseq5zH2MntxdywGCZZeGzqa
         a1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mR5xQPBsCDP5sxHfwtSDwtS5A2L0vDKJavonjD70TJU=;
        b=QrKLrVg24QbZtd3SSv/WWbuLk5psqx4xcGKMdoIZbtvkBnWx2OL2rcuEUO4Smje2wM
         8Rc+IPrShP9xgqF5yNRjINI5i8SC0W5o0qghckI7tMvdMONnJ/316tJc9m1MpQVEvl4C
         xO2UQ7o3e5zwDsKS193KMIM9RAa6pM+V7G5NSYq6x5xKut2G2XALWQdhJSUb7Apn724d
         cSuaMzi2rYvTrO4OZanCG/iDAlJPREm0HtJoEcjkZrBhGyJLC7tVWwXven7ZkTSshmxw
         +bLZHJzu7NwVj7AiUmnlxmCRu970s+Wk9bOBYKS8am8DnlI3XE+JS3M4kblnxSe2KvRL
         rTvw==
X-Gm-Message-State: APjAAAW1kEwhOahR4hRyNLhHGmGwLASFbod5AdZImg9UJh5GBaV2nIjx
        qqm0oRV5uYuE+s/XjbkCZQQZpAVbVhDcro5S5RoZPGoJ
X-Google-Smtp-Source: APXvYqy9+OJGPud4G5mhps2FWLlPdtJ11hMEBTCjZsUWCagAcqWJ1se//DAwDifae9MerLqI4eoOsE0MrFTMGC42UiA=
X-Received: by 2002:a05:6808:994:: with SMTP id a20mr7863815oic.67.1581014937407;
 Thu, 06 Feb 2020 10:48:57 -0800 (PST)
MIME-Version: 1.0
References: <20200206083515.10334-1-forrest0579@gmail.com> <20200206083515.10334-2-forrest0579@gmail.com>
In-Reply-To: <20200206083515.10334-2-forrest0579@gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Thu, 6 Feb 2020 10:48:46 -0800
Message-ID: <CAGdtWsQEvnOuZatftxmqp5iT_ac3jCjEV6q2gWaJRbP_TpDDcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add sock ops get netns helpers
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 12:36 AM Lingpeng Chen <forrest0579@gmail.com> wrote:
>
> Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
> uniq connection because there may be multi net namespace.
> For example, there may be a chance that netns a and netns b all
> listen on 127.0.0.1:8080 and the client with same port 40782
> connect to them. Without netns number, sock ops program
> can't distinguish them.
> Using bpf_sock_ops_get_netns helpers to get current connection
> netns number to distinguish connections.
>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> ---
>  include/uapi/linux/bpf.h |  8 +++++++-
>  net/core/filter.c        | 18 ++++++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f1d74a2bd234..b15a55051232 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2892,6 +2892,11 @@ union bpf_attr {
>   *             Obtain the 64bit jiffies
>   *     Return
>   *             The 64 bit jiffies
> + * u32 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)
Should this return u64 instead? Also, would it make sense here to add
a 'u64 flags' field to allow some extensibility of this helper
function, consistent with some other helpers. Initially, we can reject
any flags with:
if (unlikely(flags))
        return -EINVAL;

Last, I was hoping we could add a regression test for this helper.

Thanks,
Petar

> + *  Description
> + *      Obtain netns id of sock
> + * Return
> + *      The current netns inum
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3012,7 +3017,8 @@ union bpf_attr {
>         FN(probe_read_kernel_str),      \
>         FN(tcp_send_ack),               \
>         FN(send_signal_thread),         \
> -       FN(jiffies64),
> +       FN(jiffies64),          \
> +       FN(sock_ops_get_netns),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 792e3744b915..b7f33f20e8fb 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4421,6 +4421,22 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
>         .arg2_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_1(bpf_sock_ops_get_netns, struct bpf_sock_ops_kern *, bpf_sock)
> +{
> +       struct sock *sk = bpf_sock->sk;
> +
> +       if (!IS_ENABLED(CONFIG_NET_NS))
> +               return 0;
> +       return sk->sk_net.net->ns.inum;
> +}
> +
> +static const struct bpf_func_proto bpf_sock_ops_get_netns_proto = {
> +       .func           = bpf_sock_ops_get_netns,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +};
> +
>  const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
>  EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
>
> @@ -6218,6 +6234,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_tcp_sock:
>                 return &bpf_tcp_sock_proto;
>  #endif /* CONFIG_INET */
> +       case BPF_FUNC_sock_ops_get_netns:
> +               return &bpf_sock_ops_get_netns_proto;
>         default:
>                 return bpf_base_func_proto(func_id);
>         }
> --
> 2.17.1
>
