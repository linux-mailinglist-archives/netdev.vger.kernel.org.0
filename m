Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D48CCC0B
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbfJESeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:34:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38445 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387477AbfJESeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:34:31 -0400
Received: by mail-qt1-f196.google.com with SMTP id j31so13420553qta.5;
        Sat, 05 Oct 2019 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ksqVgIF+SM2gZfS9CWMA0X8H5Vcm34bV3v2VXjvaHa4=;
        b=jh4Qv8vvVX0Gss11wy6WyaV4IrEkHYkc5j61U9dUAi4hvX5xulokXixM2CoazHIU1P
         ZmcuvR2Cv0R+723nxc9kMMuAkLD+CuwpQ0yT4Vl4Baeu1c9u504sIoy6JR+zXEpnN6hu
         oHg6QbhnC0QTV0hLD4TT8qzmxEEKXucgWpq8QKCyIAwyxQQbER1OqlzjzurKEuZozcdI
         8ojh5u4X4MxjmqcRwTpTW0OYmLJibFa7m61SDsila6aQeOpHmJwujXAThXqUZv1Rz0hb
         MDVzykpakNCqisNJECqKX9L0a4zjSu4Wae6wVnejxj24Qa7GIK63p3CK+cK88yeozBlp
         amHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ksqVgIF+SM2gZfS9CWMA0X8H5Vcm34bV3v2VXjvaHa4=;
        b=Tt88FG15jalSK8Flk0ux5qOgbjXAQ7tpZKj2MthqAivbFvXT4jolWO5fA4MwmeNmHd
         ZX+5PqtZvRRX5tEh0SmHKyCkueWYGbwGYRVJKcyhQVwAwta3t7MSrCvwk/opJ7YtJoYE
         C1ZxmF/L26oXUek4MfMZOqc5oqsBLgw0jcOHx6LhlcbkDliySr6fizL0sF8InOU1NkhT
         stoXZcpX6o/lX13lj2kEulGrGu6dHtX4zv6JfbLb7mLk5n+MYbYCyLtpzG489dgeCYCQ
         6jIlPacDy+hpXfcMrv2cmCKvyRxqtxqOtl/bjXS+NhU/pgNLze31UkgBNB5MlcP/qAHr
         Hv4g==
X-Gm-Message-State: APjAAAXR5f+b+i8eUns6GGJhX1M0LJ30/fxhvQDsa5qY/b4wWqoi1gse
        IYtEfwDexRSk3nXL7l+dp0c5ogLT5UNCCiuFZ2A=
X-Google-Smtp-Source: APXvYqxydQEiOJdB0ksYu0MhPKfFaJYN+r01XYByln0Ugou/VqO4F/ifq31v1D7ySvNb6l/g/92uyx8gIpRASgqANc8=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr22135943qtq.141.1570300469931;
 Sat, 05 Oct 2019 11:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191004155615.95469-1-sdf@google.com> <20191004155615.95469-2-sdf@google.com>
In-Reply-To: <20191004155615.95469-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 11:34:18 -0700
Message-ID: <CAEf4BzYVGYsYZn7EVfSSy0UCx6B_w4hk2y6O6cP3qqbJYi8Pzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 8:58 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Always use init_net flow dissector BPF program if it's attached and fall
> back to the per-net namespace one. Also, deny installing new programs if
> there is already one attached to the root namespace.
> Users can still detach their BPF programs, but can't attach any
> new ones (-EEXIST).
>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Looks good, but see my note below. Regardless:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  Documentation/bpf/prog_flow_dissector.rst |  3 ++
>  net/core/flow_dissector.c                 | 42 ++++++++++++++++++++---
>  2 files changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> index a78bf036cadd..4d86780ab0f1 100644
> --- a/Documentation/bpf/prog_flow_dissector.rst
> +++ b/Documentation/bpf/prog_flow_dissector.rst
> @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
>  C-based implementation can export. Notable example is single VLAN (802.1Q)
>  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
>  for a set of information that's currently can be exported from the BPF context.
> +
> +When BPF flow dissector is attached to the root network namespace (machine-wide
> +policy), users can't override it in their child network namespaces.
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 7c09d87d3269..9821e730fc70 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -114,19 +114,50 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
>  {
>         struct bpf_prog *attached;
>         struct net *net;
> +       int ret = 0;
>
>         net = current->nsproxy->net_ns;
>         mutex_lock(&flow_dissector_mutex);
> +
> +       if (net == &init_net) {
> +               /* BPF flow dissector in the root namespace overrides
> +                * any per-net-namespace one. When attaching to root,
> +                * make sure we don't have any BPF program attached
> +                * to the non-root namespaces.
> +                */
> +               struct net *ns;
> +
> +               for_each_net(ns) {
> +                       if (net == &init_net)
> +                               continue;

You don't need this condition, if something is attached to init_net,
you will return -EEXIST anyway. Or is this a performance optimization?

> +
> +                       if (rcu_access_pointer(ns->flow_dissector_prog)) {
> +                               ret = -EEXIST;
> +                               goto out;
> +                       }
> +               }
> +       } else {
> +               /* Make sure root flow dissector is not attached
> +                * when attaching to the non-root namespace.
> +                */
> +

nit: extra empty line

> +               if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> +                       ret = -EEXIST;
> +                       goto out;
> +               }
> +       }
> +
>         attached = rcu_dereference_protected(net->flow_dissector_prog,
>                                              lockdep_is_held(&flow_dissector_mutex));
>         if (attached) {
>                 /* Only one BPF program can be attached at a time */
> -               mutex_unlock(&flow_dissector_mutex);
> -               return -EEXIST;
> +               ret = -EEXIST;
> +               goto out;
>         }
>         rcu_assign_pointer(net->flow_dissector_prog, prog);
> +out:
>         mutex_unlock(&flow_dissector_mutex);
> -       return 0;
> +       return ret;
>  }
>
>  int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
> @@ -910,7 +941,10 @@ bool __skb_flow_dissect(const struct net *net,
>         WARN_ON_ONCE(!net);
>         if (net) {
>                 rcu_read_lock();
> -               attached = rcu_dereference(net->flow_dissector_prog);
> +               attached = rcu_dereference(init_net.flow_dissector_prog);
> +
> +               if (!attached)
> +                       attached = rcu_dereference(net->flow_dissector_prog);
>
>                 if (attached) {
>                         struct bpf_flow_keys flow_keys;
> --
> 2.23.0.581.g78d2f28ef7-goog
>
