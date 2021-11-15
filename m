Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31B451D84
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349393AbhKPAaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346139AbhKOT36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF678C04C353
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:16:19 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso674014pjo.3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tYHdmtIMWSVV5HHi5v+leUs3g5lQajgFM9xLbqiXLgU=;
        b=MnVF/OI4x7XT9JrjN93Zdszyf9LVVIieP/KgyGUIpgRbgGrvTqRQuS5xadKF7y8Gpo
         caR7YNX+TElILmcJ92+4BMocHmsNqW/VpRtPr60ljsIGpNzUmKfrzuPFkp89/gLLqoOq
         Q0Od8wHiAq6ZpYjxs+YHEU85Jv9p7mULWnllvAREG/3bfE+4TD6zKwLkDz170W6N7FfY
         mWoQnnpmE7fE7z0BqbL5NxY4f9VEtbq57RQqksHSIm0yFbRxwDpNxhhRz1N4a0n+N1GY
         vQ0AHekrDGnTKW8ygxMcMf0KP5lCqZ8Sjz6a0bnipIfZYwwYrvkj3Eok9Air+8/+LPVG
         I58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tYHdmtIMWSVV5HHi5v+leUs3g5lQajgFM9xLbqiXLgU=;
        b=z220HgxzgR/fighPptfe3noUntzrucUIwsPYxhPtwb+1vvqXvljpmQRvkmM2sm/508
         DqoIkn46voL9vgeO+f/z8NdhEWo2MSduiqiMfcLiMUc17oJQYqgn3WuSYuhCxtN+g4km
         S8oSvqR+3ASP2/uXXF7MrjG78VdZkJoEOPdOldIP1VGCiMBp3sYQsNq82bI68d0185R6
         Oki0OnvzxITctR5zKHXAPmiI0pWz6Iku5fkYwFTq1GZhlUn6mlpOiFXCaBW5y/YKvpmo
         h/Cwt08KCHzvA8+QCuHE0hHRe9zUrIwPUKFjnhGyRWPI35S045NFbe9G2ap1+xA3QcYI
         ppCw==
X-Gm-Message-State: AOAM531c53JEQRCpgdH71ZriwLaegqbG9WLaDg6WTHzQjjS0VLss4pit
        TRD/XJABxGaJAFe1lkoq8rWOpg01e7ni9ykKR4lGBA==
X-Google-Smtp-Source: ABdhPJw+lVd2zHcBPZ+FvbAPI1JGJ+NN1dErXXm3fs2m8Ezt/KPXt5EQqHW7pZdkIcTtAGYGoHDQVqcQoSbvkbs9Pm8=
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr1095726pjb.105.1637003778996;
 Mon, 15 Nov 2021 11:16:18 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com> <20211115190249.3936899-17-eric.dumazet@gmail.com>
In-Reply-To: <20211115190249.3936899-17-eric.dumazet@gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Mon, 15 Nov 2021 11:16:08 -0800
Message-ID: <CAOFY-A2BquMuZOO=Fj+sQEGDyAyurh2_JAseV6MU0=7iAbF5Zw@mail.gmail.com>
Subject: Re: [PATCH net-next 16/20] tcp: avoid indirect calls to sock_rfree
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:03 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> TCP uses sk_eat_skb() when skbs can be removed from receive queue.
> However, the call so skb_orphan() from __kfree_skb() incurs
> an indirect call so sock_rfee(), which is more expensive than

Possible typo : s/so/to/g ?

-Arjun

> a direct call, especially for CONFIG_RETPOLINE=y.
>
> Add tcp_eat_recv_skb() function to make the call before
> __kfree_skb().
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9175e0d729f5e65b5fa39acadc5bf9de715854ad..4e7011672aa9a04370b7a03b972fe19cd48ea232 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1580,6 +1580,16 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
>                 tcp_send_ack(sk);
>  }
>
> +static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +       if (likely(skb->destructor == sock_rfree)) {
> +               sock_rfree(skb);
> +               skb->destructor = NULL;
> +               skb->sk = NULL;
> +       }
> +       sk_eat_skb(sk, skb);
> +}
> +
>  static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
>  {
>         struct sk_buff *skb;
> @@ -1599,7 +1609,7 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
>                  * splitted a fat GRO packet, while we released socket lock
>                  * in skb_splice_bits()
>                  */
> -               sk_eat_skb(sk, skb);
> +               tcp_eat_recv_skb(sk, skb);
>         }
>         return NULL;
>  }
> @@ -1665,11 +1675,11 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>                                 continue;
>                 }
>                 if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> -                       sk_eat_skb(sk, skb);
> +                       tcp_eat_recv_skb(sk, skb);
>                         ++seq;
>                         break;
>                 }
> -               sk_eat_skb(sk, skb);
> +               tcp_eat_recv_skb(sk, skb);
>                 if (!desc->count)
>                         break;
>                 WRITE_ONCE(tp->copied_seq, seq);
> @@ -2481,14 +2491,14 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
>                 if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
>                         goto found_fin_ok;
>                 if (!(flags & MSG_PEEK))
> -                       sk_eat_skb(sk, skb);
> +                       tcp_eat_recv_skb(sk, skb);
>                 continue;
>
>  found_fin_ok:
>                 /* Process the FIN. */
>                 WRITE_ONCE(*seq, *seq + 1);
>                 if (!(flags & MSG_PEEK))
> -                       sk_eat_skb(sk, skb);
> +                       tcp_eat_recv_skb(sk, skb);
>                 break;
>         } while (len > 0);
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
