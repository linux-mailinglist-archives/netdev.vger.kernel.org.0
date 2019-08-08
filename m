Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD986053
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 12:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbfHHKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 06:45:54 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45182 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731755AbfHHKpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 06:45:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id x21so23394066otq.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 03:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YLgu/31KIHI7QEmn1xuZtlFQdfVxrMlqOe7ysJTjxbQ=;
        b=rW0DG4KWYRW7RQ7ezHS5PFII+WT1ohtek4K8vpyJvwcFVv52KokGtWv6Tqj4IEFDtv
         DP+U/sJJPVnCdaYNHgSoeta00d6j32QjA2RrNIXabZ5KPiL+KjO4NClRs0yexnZM+Bn6
         vr0qK8OoC6qkDWhVitDme/tYRdiMYQnIC7fiyU/jIiNGfp9TrBt9egKPbV3bSWdd+UlF
         S/N+Pt2tYMpTpUhCcZn6Q4wcYL55YRMMRVogHI7Y6LX+nMvb8vjMWzvV8nCe1NrR8I0v
         FQd0YbgWBT10A2+3DtWJcwv87LoxzZdz8RIe0dvzz6IxQ7fVXXhkJ/TscWFbZdNiy/np
         opZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YLgu/31KIHI7QEmn1xuZtlFQdfVxrMlqOe7ysJTjxbQ=;
        b=sQSLdFHR1APPSM4OiWH31Tg5TUQaf3ppQzZBfXPIY/lEOeCWZvgm5+WtmliGt3N0iS
         QGZP8r2sX0Uly4KMST0YbBA0drbKZR0GqgLojyeJ5+Ma8z5eampIiXd6a3dsBiszYjxe
         Sp1T4irAWhkaOfbvb8JeBdxj9bcxChsyGXsDL1nrTCk/pVHxeB29CWXc0Qa8ANMUjhT4
         tcjebo3H4sqsjElSnNugJrPWcp3dLIluSCwAAqw0JvHPWYE+qdSTqW1sN6BDyPv/jMX+
         rWFRrjL3kkKzS+NzxCUvaiuWJShzBDVgvv2AWUcrwde3Q3JZpvK9dp/6Ue5Cufv9GTv5
         ji3Q==
X-Gm-Message-State: APjAAAXAnHKW3QFUejBproTONI0aPDN9AnJiYz/sDNFjBYxaR1ue7IkM
        RYCONJISspf0ImXUmwanXG57ArZYdNdPsQY455V72g==
X-Google-Smtp-Source: APXvYqyc5e8BqYB7BKbbpzVm7tPxFH0fXAPSyJAVqQ5Rhsje0QSJ7WVpwDqaYn5IWZNSHcstsCOdXYO8+tymrmRZzJs=
X-Received: by 2002:a6b:f008:: with SMTP id w8mr9418235ioc.60.1565261152766;
 Thu, 08 Aug 2019 03:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190808094937.26918-1-daniel@iogearbox.net> <20190808094937.26918-2-daniel@iogearbox.net>
In-Reply-To: <20190808094937.26918-2-daniel@iogearbox.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Aug 2019 12:45:40 +0200
Message-ID: <CANn89iKzaxxyC=6s45PEnTsKfz7GN4HHOw3wtpb6-ozrJSRP=g@mail.gmail.com>
Subject: Re: [PATCH net 1/2] sock: make cookie generation global instead of
 per netns
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        m@lambda.lt, Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 11:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>

> Socket cookie consumers must assume the value as opqaue in any case.
> The cookie does not guarantee an always unique identifier since it
> could wrap in fabricated corner cases where two sockets could end up
> holding the same cookie,

What do you mean by this ?

Cookie is guaranteed to be unique, it is from a 64bit counter...

There should be no collision.

> but is good enough to be used as a hint for
> many use cases; not every socket must have a cookie generated hence
> knowledge of the counter value does not provide much value either way.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Martynas Pumputis <m@lambda.lt>
> ---
>  include/net/net_namespace.h | 1 -
>  include/uapi/linux/bpf.h    | 4 ++--
>  net/core/sock_diag.c        | 3 ++-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 4a9da951a794..cb668bc2692d 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -61,7 +61,6 @@ struct net {
>         spinlock_t              rules_mod_lock;
>
>         u32                     hash_mix;
> -       atomic64_t              cookie_gen;
>
>         struct list_head        list;           /* list of network namespaces */
>         struct list_head        exit_list;      /* To linked to call pernet exit
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fa1c753dcdbc..a5aa7d3ac6a1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1466,8 +1466,8 @@ union bpf_attr {
>   *             If no cookie has been set yet, generate a new cookie. Once
>   *             generated, the socket cookie remains stable for the life of the
>   *             socket. This helper can be useful for monitoring per socket
> - *             networking traffic statistics as it provides a unique socket
> - *             identifier per namespace.
> + *             networking traffic statistics as it provides a global socket
> + *             identifier that can be assumed unique.
>   *     Return
>   *             A 8-byte long non-decreasing number on success, or 0 if the
>   *             socket field is missing inside *skb*.
> diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
> index 3312a5849a97..c13ffbd33d8d 100644
> --- a/net/core/sock_diag.c
> +++ b/net/core/sock_diag.c
> @@ -19,6 +19,7 @@ static const struct sock_diag_handler *sock_diag_handlers[AF_MAX];
>  static int (*inet_rcv_compat)(struct sk_buff *skb, struct nlmsghdr *nlh);
>  static DEFINE_MUTEX(sock_diag_table_mutex);
>  static struct workqueue_struct *broadcast_wq;
> +static atomic64_t cookie_gen;
>
>  u64 sock_gen_cookie(struct sock *sk)
>  {
> @@ -27,7 +28,7 @@ u64 sock_gen_cookie(struct sock *sk)
>
>                 if (res)
>                         return res;
> -               res = atomic64_inc_return(&sock_net(sk)->cookie_gen);
> +               res = atomic64_inc_return(&cookie_gen);
>                 atomic64_cmpxchg(&sk->sk_cookie, 0, res);
>         }
>  }
> --
> 2.17.1
>
