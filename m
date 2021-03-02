Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9951632B399
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449811AbhCCEDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835117AbhCBQhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 11:37:33 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640B7C061223
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 08:22:30 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id a17so24695550ljq.2
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 08:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9F+lO983HafQm131zMNtA2M5vN7jjQ4sPO1miVVqoZQ=;
        b=rkoJZCKrXUgso9jhDO9Ntv+yPsXPftMJkfH6Ln/fdlC3w6AAhsqvJddr6Pni8EEbHn
         QbVxAjZqbarunY1iqfUi30tqCHf/6H3W19GSltFqHiKzrpEyJOb+CqW6LcXT8d+NZ6jR
         2uIcIXtbl23HrnE0SKS48l+A0pZ17mOGYPU4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9F+lO983HafQm131zMNtA2M5vN7jjQ4sPO1miVVqoZQ=;
        b=HVM55CsoqOE5w9ox0ze4yjIju4cbOHR4LTEAV7lGa6YovJBFWb+x/BR736/V49fu4D
         odXCoUhmYXGUgpDGIqsCx6Yy2yve3XMVM5b3Mmi8l8OsD5PggaL4RvTm2x6WbYiy7C7z
         2DUhNwWU8WYR1iBDZlmg4e6BQlv8fx07/P2mZzyeMHfxTsN+d/j7u0GexxNCogBMFTdu
         fXr9ZP0KigMAswLbeVEexTK/BFBOPqKV17/W2KibOXjrpRqixSAq9GeyfHY9bUT1DIdh
         n/PRvsVP7YtNRbmz7QBKJQAiymIAeMp5BqW4EMFJFnfAVkj3EL3K0xSal5DXw2zdJbZ0
         zvRg==
X-Gm-Message-State: AOAM530ZHa5mn+qFZNxTwQrB6RzyVGX1Pxg+qAGluD4I6K+an7O3wux5
        NH+UcBS9DHH33cS+OSvM6yVbV9NuY7nXINxlYrGxsw==
X-Google-Smtp-Source: ABdhPJzvRrHUiMLHVor8XFBpxH5az13yVi5Sx+2gdr1u4tI1Nwtw0JQOP8iEFA9pA6sqBWUhl6nS0lFRyFoHz1j0aH4=
X-Received: by 2002:a2e:9310:: with SMTP id e16mr12720926ljh.226.1614702148827;
 Tue, 02 Mar 2021 08:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com> <20210302023743.24123-3-xiyou.wangcong@gmail.com>
In-Reply-To: <20210302023743.24123-3-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Mar 2021 16:22:17 +0000
Message-ID: <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:

...

> @@ -350,25 +351,12 @@ static inline void sk_psock_cork_free(struct sk_psock *psock)
>         }
>  }
>
> -static inline void sk_psock_update_proto(struct sock *sk,
> -                                        struct sk_psock *psock,
> -                                        struct proto *ops)
> -{
> -       /* Pairs with lockless read in sk_clone_lock() */
> -       WRITE_ONCE(sk->sk_prot, ops);
> -}
> -
>  static inline void sk_psock_restore_proto(struct sock *sk,
>                                           struct sk_psock *psock)
>  {
>         sk->sk_prot->unhash = psock->saved_unhash;

Not related to your patch set, but why do an extra restore of
sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
/ udp_bpf protos, so overwriting that seems wrong?

> -       if (inet_csk_has_ulp(sk)) {
> -               tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> -       } else {
> -               sk->sk_write_space = psock->saved_write_space;
> -               /* Pairs with lockless read in sk_clone_lock() */
> -               WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> -       }
> +       if (psock->saved_update_proto)
> +               psock->saved_update_proto(sk, true);
>  }
>
>  static inline void sk_psock_set_state(struct sk_psock *psock,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 636810ddcd9b..0e8577c917e8 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1184,6 +1184,9 @@ struct proto {
>         void                    (*unhash)(struct sock *sk);
>         void                    (*rehash)(struct sock *sk);
>         int                     (*get_port)(struct sock *sk, unsigned short snum);
> +#ifdef CONFIG_BPF_SYSCALL
> +       int                     (*update_proto)(struct sock *sk, bool restore);

Kind of a nit, but this name suggests that the callback is a lot more
generic than it really is. The only thing you can use it for is to
prep the socket to be sockmap ready since we hardwire sockmap_unhash,
etc. It's also not at all clear that this only works if sk has an
sk_psock associated with it. Calling it without one would crash the
kernel since the update_proto functions don't check for !sk_psock.

Might as well call it install_sockmap_hooks or something and have a
valid sk_psock be passed in to the callback. Additionally, I'd prefer
if the function returned a struct proto * like it does at the moment.
That way we keep sk->sk_prot manipulation confined to the sockmap code
and don't have to copy paste it into every proto.

> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 3bddd9dd2da2..13d2af5bb81c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -184,26 +184,10 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
>
>  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
>  {
> -       struct proto *prot;
> -
> -       switch (sk->sk_type) {
> -       case SOCK_STREAM:
> -               prot = tcp_bpf_get_proto(sk, psock);
> -               break;
> -
> -       case SOCK_DGRAM:
> -               prot = udp_bpf_get_proto(sk, psock);
> -               break;
> -
> -       default:
> +       if (!sk->sk_prot->update_proto)
>                 return -EINVAL;
> -       }
> -
> -       if (IS_ERR(prot))
> -               return PTR_ERR(prot);
> -
> -       sk_psock_update_proto(sk, psock, prot);
> -       return 0;
> +       psock->saved_update_proto = sk->sk_prot->update_proto;
> +       return sk->sk_prot->update_proto(sk, false);

I think reads / writes from sk_prot need READ_ONCE / WRITE_ONCE. We've
not been diligent about this so far, but I think it makes sense to be
careful in new code.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
