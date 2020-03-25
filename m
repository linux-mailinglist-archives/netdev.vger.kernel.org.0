Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B59192591
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYK3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:29:20 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33673 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCYK3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:29:20 -0400
Received: by mail-oi1-f195.google.com with SMTP id m14so1639786oic.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 03:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ArGaL1h7B+uizWByH2ecHPkkaz+ufkoL2A1NpiYZMWw=;
        b=MGkrp3crCz02Zou4Kbw+IeWIplHO9B4i6uKlT8FrlMU4GzWqDFXTGDsSQgObcmMKhX
         QK5DDYDhCQZYgpQBR2d099djotzniKhg3QjN/rG86K4vN5xvAG67qpIl+fZthQGotEV0
         nRWa5gAglWtUiLxdWNcwjdTyGond4/ZGvrbWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ArGaL1h7B+uizWByH2ecHPkkaz+ufkoL2A1NpiYZMWw=;
        b=UfWpGBGqcTaAj2mO+Pua5BvqCS3v+/1a2eyymUnxwVb+5P2IEbuVgyNIBtk3N5A/tw
         NQ8ww5G0nOKMdOy+sIF8v5Tq3ZNz7SgGv9F7SN1AeQELHwNsrRnUY+S2KZUO70UJH7na
         WUzsbvJ5b+Z69GTRvof6Pcy54WHe4V9/Lq+ND2iXzEBZeUs9cfCEzoyfr+sGqfp5AmyH
         +bdM5E/lylHrrtCXwP8xELhsbAy6dJFQgnRbyhl5QONPw9YNi1YJT3VP1nU9KqiJ7MVZ
         lGULnYyMj7esWnLHZvsUhLSkMy6P4Dv+ktptBVWmD2FOZcGrZwCAmadUCUi09l0ejZyd
         Otkg==
X-Gm-Message-State: ANhLgQ1qeNUoM+x0SRpS8wMpFM0i5rM9BBe+zOolTPWNQnAeaaCR5LAH
        hajyYS9LEOg5tnBYeMktfzuOAHYt588YVkFnNj+Anw==
X-Google-Smtp-Source: ADFU+vvSQ7A6GMcAmlm90Ozjh9afhgk93UcE4xmlJOSTqKDnyupqvozm0dz2MpJOdS2RG+jb0vQ7OOZE6/AwPcNbsxM=
X-Received: by 2002:a05:6808:8f:: with SMTP id s15mr2028349oic.110.1585132159276;
 Wed, 25 Mar 2020 03:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-5-joe@wand.net.nz>
In-Reply-To: <20200325055745.10710-5-joe@wand.net.nz>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 25 Mar 2020 10:29:08 +0000
Message-ID: <CACAyw9_17E3TNCFsnXzQ4K2zSmwn8J+BcZqbjiK==WQH=zNzvg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/5] bpf: Don't refcount LISTEN sockets in sk_assign()
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
>
> Avoid taking a reference on listen sockets by checking the socket type
> in the sk_assign and in the corresponding skb_steal_sock() code in the
> the transport layer, and by ensuring that the prefetch free (sock_pfree)
> function uses the same logic to check whether the socket is refcounted.
>
> Suggested-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
> v2: Initial version
> ---
>  include/net/sock.h | 25 +++++++++++++++++--------
>  net/core/filter.c  |  6 +++---
>  net/core/sock.c    |  3 ++-
>  3 files changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 1ca2e808cb8e..3ec1865f173e 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2533,6 +2533,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
>         return skb->destructor == sock_pfree;
>  }
>
> +/* This helper checks if a socket is a full socket,
> + * ie _not_ a timewait or request socket.
> + */
> +static inline bool sk_fullsock(const struct sock *sk)
> +{
> +       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> +}
> +
> +static inline bool
> +sk_is_refcounted(struct sock *sk)
> +{
> +       /* Only full sockets have sk->sk_flags. */
> +       return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
> +}
> +
>  /**
>   * skb_steal_sock
>   * @skb to steal the socket from
> @@ -2545,6 +2560,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
>                 struct sock *sk = skb->sk;
>
>                 *refcounted = true;
> +               if (skb_sk_is_prefetched(skb))
> +                       *refcounted = sk_is_refcounted(sk);
>                 skb->destructor = NULL;
>                 skb->sk = NULL;
>                 return sk;
> @@ -2553,14 +2570,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
>         return NULL;
>  }
>
> -/* This helper checks if a socket is a full socket,
> - * ie _not_ a timewait or request socket.
> - */
> -static inline bool sk_fullsock(const struct sock *sk)
> -{
> -       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> -}
> -
>  /* Checks if this SKB belongs to an HW offloaded socket
>   * and whether any SW fallbacks are required based on dev.
>   * Check decrypted mark in case skb_orphan() cleared socket.
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 0fada7fe9b75..997b8606167e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5343,8 +5343,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
>
>  BPF_CALL_1(bpf_sk_release, struct sock *, sk)
>  {
> -       /* Only full sockets have sk->sk_flags. */
> -       if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
> +       if (sk_is_refcounted(sk))
>                 sock_gen_put(sk);
>         return 0;
>  }
> @@ -5870,7 +5869,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
>                 return -ESOCKTNOSUPPORT;
>         if (unlikely(dev_net(skb->dev) != sock_net(sk)))
>                 return -ENETUNREACH;
> -       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> +       if (sk_is_refcounted(sk) &&
> +           unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
>                 return -ENOENT;
>
>         skb_orphan(skb);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index cfaf60267360..a2ab79446f59 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
>   */
>  void sock_pfree(struct sk_buff *skb)
>  {
> -       sock_edemux(skb);
> +       if (sk_is_refcounted(skb->sk))
> +               sock_edemux(skb);

sock_edemux calls sock_gen_put, which is also called by
bpf_sk_release. Is it worth teaching sock_gen_put about
sk_fullsock, and dropping the other helpers? I was considering this
when fixing up sk_release, but then forgot
about it.

>  }
>  EXPORT_SYMBOL(sock_pfree);
>
> --
> 2.20.1
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
