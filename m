Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F35B1101DD
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLCQJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:09:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38708 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfLCQJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:09:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so4120920wmi.3
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 08:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DslYZl0bmfQYYrUws1Ml7tdfPrQRt9DxJDqUv4/ThqQ=;
        b=pqKgqygMsoN2UrVDsGqGtG0SfSYVkVmXBJgM6UhqijBfA/iR8rInK/5281fWCPlrbB
         KrReJZ+3LmfSbKiK8fQBodZ3TjYs3imN66QogI4VMncK6ED/O1Tam7xg9ni0NYKDbusx
         kEPLS8Mv5AjcX8lg492a1TCYW6o28WZdnS/svyp0oS81GVSr9IlgRF/AjNhW+3hDQVYr
         i3s+GXpdno0O4SPTscgjxb4sROMg2GxHd9up4r5T0Oysg3jBOdj5crykPvesSGWG3hs1
         Mv+3orlvGksAQofq/+YI5heUI9rOn6omLBK+8oU1QErVvWdi1xhWV5AiJlpVQjsJKyup
         1gCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DslYZl0bmfQYYrUws1Ml7tdfPrQRt9DxJDqUv4/ThqQ=;
        b=j+YNqy3Wmy1O/xCmiCdtjYGtc6GQMRr3RHd+xF+HYDgmX9UpMisnFAR01PDOSECWOe
         JdOe/pSPrYQIppp51g7dL1NZfkP5BGEpu2913h28FFGTxa+lB9kJ8W6VVj7mK+Td4E1v
         NvSJaIfFru0rmlbNpKcBo3zfkdzrXiocfTEWJ1nzNHmrwLYhTMXSjuUNtduKkSCREfy3
         AJBqBOADelI2RikhuytSp5A0icHAPW1mV9riFSEoYwfwSAf5RkAQ5/xQc6UTbouT9H2E
         dA5trs0naVRMgHAtpSHA4UfSpAhvOGRd4qlb7FbJyeSKt2Vk+E988YrYwHW3wjsdR6IY
         zt2g==
X-Gm-Message-State: APjAAAVH1UfIFQCxD/3KUOz06BdbxlLePx/vlqCVLsYYbzIcVmr87Jb0
        vJEq3pHwHtsi0i2kKjYIHv2KVEZKYfrStsS+0o82jA==
X-Google-Smtp-Source: APXvYqyylDSYdxIC0QR89x6smfSQwfGtmR62lHYLz8rMRPVdCasnRgTUIP+dBeWCYx14veziROrA0mBuZQ7P7H+cUjs=
X-Received: by 2002:a7b:c318:: with SMTP id k24mr22422300wmj.54.1575389338454;
 Tue, 03 Dec 2019 08:08:58 -0800 (PST)
MIME-Version: 1.0
References: <20191203160552.31071-1-edumazet@google.com>
In-Reply-To: <20191203160552.31071-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 3 Dec 2019 11:08:21 -0500
Message-ID: <CACSApvZ5GTrWLkR-i1YcAw608=xSOST_6uVsooafFo6P5Z6z=g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 11:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> It appears linux-4.14 stable needs a backport of commit
> 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
>
> Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
>
> I will provide to stable teams the squashed patches.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thanks, Eric!

> ---
>  net/ipv4/tcp_timer.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index dd5a6317a8018a45ad609f832ced6df2937ad453..1097b438befe14ae3f375f3dbcc1f2d375a93879 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -434,6 +434,7 @@ void tcp_retransmit_timer(struct sock *sk)
>         struct net *net = sock_net(sk);
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct request_sock *req;
> +       struct sk_buff *skb;
>
>         req = rcu_dereference_protected(tp->fastopen_rsk,
>                                         lockdep_sock_is_held(sk));
> @@ -446,7 +447,12 @@ void tcp_retransmit_timer(struct sock *sk)
>                  */
>                 return;
>         }
> -       if (!tp->packets_out || WARN_ON_ONCE(tcp_rtx_queue_empty(sk)))
> +
> +       if (!tp->packets_out)
> +               return;
> +
> +       skb = tcp_rtx_queue_head(sk);
> +       if (WARN_ON_ONCE(!skb))
>                 return;
>
>         tp->tlp_high_seq = 0;
> @@ -480,7 +486,7 @@ void tcp_retransmit_timer(struct sock *sk)
>                         goto out;
>                 }
>                 tcp_enter_loss(sk);
> -               tcp_retransmit_skb(sk, tcp_rtx_queue_head(sk), 1);
> +               tcp_retransmit_skb(sk, skb, 1);
>                 __sk_dst_reset(sk);
>                 goto out_reset_timer;
>         }
> --
> 2.24.0.393.g34dc348eaf-goog
>
