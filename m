Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6022316B94B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBYFrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgBYFrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 00:47:48 -0500
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCB224653;
        Tue, 25 Feb 2020 05:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582609667;
        bh=duyNHjgByXZVG87dP9HIV45bmOzoLQ0it8vIfQQRtRU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gj6/gNO4WgFmVsxHx/WWITfhwQAeyuWj907s+0E0M2q9uHKyjJ5mj3H/nzgo1Ics9
         x0jbvYCFNyr+c+jaTeofu/SlUKVNkLVhzQeyxfLuuV9H93/9LSkc99q/5JqLFI3VoL
         K9sBzXku+lxe/XPwU+IB3yAacs7BpAsPxEWPWJyM=
Received: by mail-lj1-f178.google.com with SMTP id o15so12655239ljg.6;
        Mon, 24 Feb 2020 21:47:46 -0800 (PST)
X-Gm-Message-State: APjAAAUQOpsVrx+DGG3JRlMjm5liH2hn3M5mVBUR72ZM+v6uAHMVyF3f
        F118rXhpLdtgNdGfc1NRFmznuNv+g0nE9RbkMJ0=
X-Google-Smtp-Source: APXvYqwyY2+QaeFPPyhjvAJ/Cg9HwJbuO351k3iyVdXlfSULP7VZxmpJHlSQ5zppYhuMHnMGTGGxduGBNHyiC/p0P9s=
X-Received: by 2002:a2e:b017:: with SMTP id y23mr13148038ljk.229.1582609664995;
 Mon, 24 Feb 2020 21:47:44 -0800 (PST)
MIME-Version: 1.0
References: <20200221184650.21920-1-kafai@fb.com> <20200221184715.24186-1-kafai@fb.com>
In-Reply-To: <20200221184715.24186-1-kafai@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 21:47:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4BuGQP8+QGG+E9A+n=8DV0Gg=UmWzeScrbFxBp7O_ojw@mail.gmail.com>
Message-ID: <CAPhsuW4BuGQP8+QGG+E9A+n=8DV0Gg=UmWzeScrbFxBp7O_ojw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 10:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch will dump out the bpf_sk_storages of a sk
> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
>
> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
[...]

> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/inet_diag.h      |  4 ++
>  include/linux/netlink.h        |  4 +-
>  include/uapi/linux/inet_diag.h |  2 +
>  net/ipv4/inet_diag.c           | 71 ++++++++++++++++++++++++++++++++++
>  4 files changed, 79 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index 1bb94cac265f..e4ba25d63913 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -38,9 +38,13 @@ struct inet_diag_handler {
>         __u16           idiag_info_size;
>  };
>
> +struct bpf_sk_storage_diag;
>  struct inet_diag_dump_data {
>         struct nlattr *req_nlas[__INET_DIAG_REQ_MAX];
>  #define inet_diag_nla_bc req_nlas[INET_DIAG_REQ_BYTECODE]
> +#define inet_diag_nla_bpf_stgs req_nlas[INET_DIAG_REQ_SK_BPF_STORAGES]
> +
> +       struct bpf_sk_storage_diag *bpf_stg_diag;
>  };
>
>  struct inet_connection_sock;
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 205fa7b1f07a..788969ccbbde 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -188,10 +188,10 @@ struct netlink_callback {
>         struct module           *module;
>         struct netlink_ext_ack  *extack;
>         u16                     family;
> -       u16                     min_dump_alloc;
> -       bool                    strict_check;
>         u16                     answer_flags;
> +       u32                     min_dump_alloc;

Maybe highlight this change in the commit log?

>         unsigned int            prev_seq, seq;
> +       bool                    strict_check;
>         union {
>                 u8              ctx[48];
>
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index bab9a9f8da12..75dffd78363a 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -64,6 +64,7 @@ struct inet_diag_req_raw {
>  enum {
>         INET_DIAG_REQ_NONE,
>         INET_DIAG_REQ_BYTECODE,
> +       INET_DIAG_REQ_SK_BPF_STORAGES,
>         __INET_DIAG_REQ_MAX,
>  };
>
> @@ -155,6 +156,7 @@ enum {
>         INET_DIAG_CLASS_ID,     /* request as INET_DIAG_TCLASS */
>         INET_DIAG_MD5SIG,
>         INET_DIAG_ULP_INFO,
> +       INET_DIAG_SK_BPF_STORAGES,
>         __INET_DIAG_MAX,
>  };
>
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 4bce8a477699..8ca4d54d7c5a 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -23,6 +23,7 @@
>  #include <net/inet_hashtables.h>
>  #include <net/inet_timewait_sock.h>
>  #include <net/inet6_hashtables.h>
> +#include <net/bpf_sk_storage.h>
>  #include <net/netlink.h>
>
>  #include <linux/inet.h>
> @@ -156,6 +157,8 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
>
> +#define MAX_DUMP_ALLOC_SIZE (KMALLOC_MAX_SIZE - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +
>  int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
>                       struct sk_buff *skb, struct netlink_callback *cb,
>                       const struct inet_diag_req_v2 *req,
> @@ -163,12 +166,14 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
>  {
>         const struct tcp_congestion_ops *ca_ops;
>         const struct inet_diag_handler *handler;
> +       struct inet_diag_dump_data *cb_data;
>         int ext = req->idiag_ext;
>         struct inet_diag_msg *r;
>         struct nlmsghdr  *nlh;
>         struct nlattr *attr;
>         void *info = NULL;
>
> +       cb_data = cb->data;
>         handler = inet_diag_table[req->sdiag_protocol];
>         BUG_ON(!handler);
>
> @@ -302,6 +307,48 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
>                         goto errout;
>         }
>
> +       /* Keep it at the end for potential retry with a larger skb,
> +        * or else do best-effort fitting, which is only done for the
> +        * first_nlmsg.
> +        */
> +       if (cb_data->bpf_stg_diag) {
> +               bool first_nlmsg = ((unsigned char *)nlh == skb->data);
> +               unsigned int prev_min_dump_alloc;
> +               unsigned int total_nla_size = 0;
> +               unsigned int msg_len;
> +               int err;
> +
> +               msg_len = skb_tail_pointer(skb) - (unsigned char *)nlh;
> +               err = bpf_sk_storage_diag_put(cb_data->bpf_stg_diag, sk, skb,
> +                                             INET_DIAG_SK_BPF_STORAGES,
> +                                             &total_nla_size);
> +
> +               if (!err)
> +                       goto out;
> +
> +               total_nla_size += msg_len;
> +               prev_min_dump_alloc = cb->min_dump_alloc;
> +               if (total_nla_size > prev_min_dump_alloc)
> +                       cb->min_dump_alloc = min_t(u32, total_nla_size,
> +                                                  MAX_DUMP_ALLOC_SIZE);
> +
> +               if (!first_nlmsg)
> +                       goto errout;
> +
> +               if (cb->min_dump_alloc > prev_min_dump_alloc)
> +                       /* Retry with pskb_expand_head() with
> +                        * __GFP_DIRECT_RECLAIM
> +                        */
> +                       goto errout;
> +
> +               WARN_ON_ONCE(total_nla_size <= prev_min_dump_alloc);
> +
> +               /* Send what we have for this sk
> +                * and move on to the next sk in the following
> +                * dump()
> +                */
> +       }
> +
>  out:
>         nlmsg_end(skb, nlh);
>         return 0;
> @@ -1022,8 +1069,11 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
>                             const struct inet_diag_req_v2 *r)
>  {
>         const struct inet_diag_handler *handler;
> +       u32 prev_min_dump_alloc;
>         int err = 0;
>
> +again:
> +       prev_min_dump_alloc = cb->min_dump_alloc;
>         handler = inet_diag_lock_handler(r->sdiag_protocol);
>         if (!IS_ERR(handler))
>                 handler->dump(skb, cb, r);
> @@ -1031,6 +1081,12 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
>                 err = PTR_ERR(handler);
>         inet_diag_unlock_handler(handler);
>
> +       if (!skb->len && cb->min_dump_alloc > prev_min_dump_alloc) {

Why do we check for !skb->len here?

> +               err = pskb_expand_head(skb, 0, cb->min_dump_alloc, GFP_KERNEL);
> +               if (!err)
> +                       goto again;
> +       }
> +
>         return err ? : skb->len;
>  }
>
> @@ -1068,6 +1124,18 @@ static int __inet_diag_dump_start(struct netlink_callback *cb, int hdrlen)
>                 }
>         }
>
> +       nla = cb_data->inet_diag_nla_bpf_stgs;
> +       if (nla) {
> +               struct bpf_sk_storage_diag *bpf_stg_diag;
> +
> +               bpf_stg_diag = bpf_sk_storage_diag_alloc(nla);
> +               if (IS_ERR(bpf_stg_diag)) {
> +                       kfree(cb_data);
> +                       return PTR_ERR(bpf_stg_diag);
> +               }
> +               cb_data->bpf_stg_diag = bpf_stg_diag;
> +       }
> +
>         cb->data = cb_data;
>         return 0;
>  }
> @@ -1084,6 +1152,9 @@ static int inet_diag_dump_start_compat(struct netlink_callback *cb)
>
>  static int inet_diag_dump_done(struct netlink_callback *cb)
>  {
> +       struct inet_diag_dump_data *cb_data = cb->data;
> +
> +       bpf_sk_storage_diag_free(cb_data->bpf_stg_diag);
>         kfree(cb->data);
>
>         return 0;
> --
> 2.17.1
>
