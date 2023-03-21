Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146046C3D62
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCUWHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCUWHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:07:23 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A58353D89
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:21 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id e12so6445609uaa.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 15:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/B1FYsSjdq9R/LF/3aBLyJQ6ewHgXKKrqoa1YhvMjM=;
        b=D1B+hN6xHgo1AhXfOsI4RZGPuCAzhKsR87DMmUJ/rcvgYh3M1JNcXtx6kOiQziQXAW
         eu/TU4WkM6NI1okj/NkDW6cX/Vr2zFpO9ogke3zjYZ3QbazBYJd4gJk+16tv/ChM/kEU
         uFOLAworMUP/Eh4HlPpPHb1/gqHomyRX37cJpkRS1/mhdh9a/8xtrs2V8Bjv/S0JDbgf
         ORdB8V/61pioRjPZaUbvJ4Y9koF4xTdEAJ6h36dSYAAuDDdWIGGgVgA22CEPINnDxZyD
         x26ytD75FiUpWZRnLgpxoty/YBptkakIKRdhsKeUZv0W2b+cM6IyL/zZHYnOtYtccDHI
         WHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/B1FYsSjdq9R/LF/3aBLyJQ6ewHgXKKrqoa1YhvMjM=;
        b=YG0vPWxWj6THt8eqgWf6uYleViSpKd4W7xXbPWuufGExTyQ22qgesaoT7aBgDrprmW
         6uK4KrmKVLJzVLjFOaMn/bV1lBzndDiuHMmIubtn6X8qlPlOs+HiiQReDVjdcX2+tWwz
         fk5NA8NWfqn5bifqbC0IrHViqpVQtND4lryQsv3oMc275jbAziZO3zd1NUmzTHxORh88
         ehEEASBfdDrLeuwjsT5aOBK6w7baiTR80DVDrh9gyuPBaZcQ8BewoqNi61Ac2gx+xAQs
         ABtvsMPJFaHrkldS9jnSBv7mqCqQUHzsAOLIn3QeKgFVEk5Uf/PWz3aokYKxXsjmG0gN
         CPxA==
X-Gm-Message-State: AO0yUKXQan1Oz1ZdMIen/k/nX2BP0ZOYSgzq8aAe/bMIPhtoDydHqAX2
        KV1+2HLGcWoGb8GANwz8CesOdGm3mlXVmpo/tR4aEQ==
X-Google-Smtp-Source: AK7set+ZOldU7WFmV4O8Scmr7RHuj7gIrxZq1xak+1/eIAeJprTomxYUF+ZCCpXNzRzU8RnwoB7I60i0eQfbAarG3Bc=
X-Received: by 2002:ab0:6ed0:0:b0:663:e17a:e5f6 with SMTP id
 c16-20020ab06ed0000000b00663e17ae5f6mr1688963uav.2.1679436440353; Tue, 21 Mar
 2023 15:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230321215212.525630-1-john.fastabend@gmail.com> <20230321215212.525630-6-john.fastabend@gmail.com>
In-Reply-To: <20230321215212.525630-6-john.fastabend@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 15:07:09 -0700
Message-ID: <CANn89iKFtrcbAtOZ9dppkm4AaqaQysh0r1suV9hQ5vg-zp3zZg@mail.gmail.com>
Subject: Re: [PATCH bpf 05/11] bpf: sockmap, TCP data stall on recv before accept
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 2:52=E2=80=AFPM John Fastabend <john.fastabend@gmai=
l.com> wrote:
>
> A common mechanism to put a TCP socket into the sockmap is to hook the
> BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program
> that can map the socket info to the correct BPF verdict parser. When
> the user adds the socket to the map the psock is created and the new
> ops are assigned to ensure the verdict program will 'see' the sk_buffs
> as they arrive.
>
> Part of this process hooks the sk_data_ready op with a BPF specific
> handler to wake up the BPF verdict program when data is ready to read.
> The logic is simple enough (posted here for easy reading)
>
>  static void sk_psock_verdict_data_ready(struct sock *sk)
>  {
>         struct socket *sock =3D sk->sk_socket;
>
>         if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
>                 return;
>         sock->ops->read_skb(sk, sk_psock_verdict_recv);
>  }
>
> The oversight here is sk->sk_socket is not assigned until the application
> accepts() the new socket. However, its entirely ok for the peer applicati=
on
> to do a connect() followed immediately by sends. The socket on the receiv=
er
> is sitting on the backlog queue of the listening socket until its accepte=
d
> and the data is queued up. If the peer never accepts the socket or is slo=
w
> it will eventually hit data limits and rate limit the session. But,
> important for BPF sockmap hooks when this data is received TCP stack does
> the sk_data_ready() call but the read_skb() for this data is never called
> because sk_socket is missing. The data sits on the sk_receive_queue.
>
> Then once the socket is accepted if we never receive more data from the
> peer there will be no further sk_data_ready calls and all the data
> is still on the sk_receive_queue(). Then user calls recvmsg after accept(=
)
> and for TCP sockets in sockmap we use the tcp_bpf_recvmsg_parser() handle=
r.
> The handler checks for data in the sk_msg ingress queue expecting that
> the BPF program has already run from the sk_data_ready hook and enqueued
> the data as needed. So we are stuck.
>
> To fix do an unlikely check in recvmsg handler for data on the
> sk_receive_queue and if it exists wake up data_ready. We have the sock
> locked in both read_skb and recvmsg so should avoid having multiple
> runners.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 3a0f43f3afd8..b1ba58be0c5a 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -209,6 +209,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>                 return tcp_recvmsg(sk, msg, len, flags, addr_len);
>
>         lock_sock(sk);
> +
> +       /* We may have received data on the sk_receive_queue pre-accept a=
nd
> +        * then we can not use read_skb in this context because we haven'=
t
> +        * assigned a sk_socket yet so have no link to the ops. The work-=
around
> +        * is to check the sk_receive_queue and in these cases read skbs =
off
> +        * queue again. The read_skb hook is not running at this point be=
cause
> +        * of lock_sock so we avoid having multiple runners in read_skb.
> +        */
> +       if (unlikely(!skb_queue_empty_lockless(&sk->sk_receive_queue))) {

socket is locked here, please use skb_queue_empty() ?

We shall reserve skb_queue_empty_lockless() for lockless contexts.

> +               tcp_data_ready(sk);
> +               /* This handles the ENOMEM errors if we both receive data
> +                * pre accept and are already under memory pressure. At l=
east
> +                * let user no to retry.
> +                */
> +               if (unlikely(!skb_queue_empty_lockless(&sk->sk_receive_qu=
eue))) {
> +                       copied =3D -EAGAIN;
> +                       goto out;
> +               }
> +       }
> +
>  msg_bytes_ready:
>         copied =3D sk_msg_recvmsg(sk, psock, msg, len, flags);
>         /* The typical case for EFAULT is the socket was gracefully
> --
> 2.33.0
>
