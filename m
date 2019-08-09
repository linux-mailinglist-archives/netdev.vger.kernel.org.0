Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5154587AD4
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406739AbfHINJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:09:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35226 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfHINJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:09:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so5587944wmg.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/fnCoI0maadSEbgFkw64JuyIT5P+u09qAKU5VD0YmdE=;
        b=fZfoh/5Dm9cRvAicbzT6MfB35RoEtAbK/bDhpM1Kgb4txBzHdXowDfk0eZVL3h7HlZ
         bPE9rBTxkJ9ujBX/ceWKId4bdZyZFycEf+cH/VmJ+gN5O3myUBONkdnV2+NNx08HsZez
         YpyF81cIjXVl4tOk/gxhkztiaPhsO4ERKbuxdJyyqnL+DKpNeaDODRhpLVUAjX9Rw5HV
         fT4UjHTGPf3JL5hfphfaiqnW/pUYZVMmO67vrh1KYvMVhxXfs5/IrT8R/iV1Nx8nBHbw
         +bOr1pNezX+/RyazPlnD8etXKNJgIcEUomFiELSNoMygGZE8t9eX4+pwBpCoogUkNIgN
         OWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/fnCoI0maadSEbgFkw64JuyIT5P+u09qAKU5VD0YmdE=;
        b=kYXy6ZvywtFUI6A69KFFJuhnfLpW3B9b83A2PT75rBXWFZqiPSNTvQhfdDaDOkHXIc
         fFY/9ymiehMC/HQFeXkWel9MsV8rf8bl2h7fUIDzmeEEwgC+4eEU1rkOfL8YaoiNqzoj
         /JwdRy2GbaPRVOHWSKHMGiQChXK62Rm6pq0t8YIXywjr1dBq1zaCBA2Cu6DJVnXYHQVx
         knRLad4Co9O8MJgUyPqHnvxjuRN6BIuYykr3DwTZhTxZdPKshqKLZiqEDWP6tOHPqLl6
         Tno8J5CH0LCceoduidQCQRj3Z0STLhn51U658U2tdYDakzrmzP6VXm/mSGkZlfVRil9s
         6GFg==
X-Gm-Message-State: APjAAAVDTBLN0cdULkapv6t9w3V76/0GhpmQjKa8xzi6oL3kdYvfSzrT
        gTW7600ZD14RCqlfwkx89Zn54aV9FYIuruiIeAYOMA==
X-Google-Smtp-Source: APXvYqwfP2polDvDLdIXeVBlLWKsZ3tuE9c7fnhbcD5AEM4FvpgfwA0Hrcti55Rbh0ra3OSYtC+Ea9Tt7gBiWhMEWTw=
X-Received: by 2002:a1c:be19:: with SMTP id o25mr10477830wmf.54.1565356155898;
 Fri, 09 Aug 2019 06:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190809120447.93591-1-edumazet@google.com>
In-Reply-To: <20190809120447.93591-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 9 Aug 2019 09:08:38 -0400
Message-ID: <CACSApvYPHU2WeAm7kL+RHmeu-Cu1VfVVsLfLUAQHL0-X7BGZFA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: batch calls to sk_flush_backlog()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 8:04 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Starting from commit d41a69f1d390 ("tcp: make tcp_sendmsg() aware of socket backlog")
> loopback flows got hurt, because for each skb sent, the socket receives an
> immediate ACK and sk_flush_backlog() causes extra work.
>
> Intent was to not let the backlog grow too much, but we went a bit too far.
>
> We can check the backlog every 16 skbs (about 1MB chunks)
> to increase TCP over loopback performance by about 15 %
>
> Note that the call to sk_flush_backlog() handles a single ACK,
> thanks to coalescing done on backlog, but cleans the 16 skbs
> found in rtx rb-tree.
>
> Reported-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you very much, Eric!

> ---
>  net/ipv4/tcp.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index a0a66321c0ee99918b2080219dbaefcf3c398e13..f8fa1686f7f3e64f5d4ea8163e7f87538cc0d672 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1162,7 +1162,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>         struct sockcm_cookie sockc;
>         int flags, err, copied = 0;
>         int mss_now = 0, size_goal, copied_syn = 0;
> -       bool process_backlog = false;
> +       int process_backlog = 0;
>         bool zc = false;
>         long timeo;
>
> @@ -1254,9 +1254,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                         if (!sk_stream_memory_free(sk))
>                                 goto wait_for_sndbuf;
>
> -                       if (process_backlog && sk_flush_backlog(sk)) {
> -                               process_backlog = false;
> -                               goto restart;
> +                       if (unlikely(process_backlog >= 16)) {
> +                               process_backlog = 0;
> +                               if (sk_flush_backlog(sk))
> +                                       goto restart;
>                         }
>                         first_skb = tcp_rtx_and_write_queues_empty(sk);
>                         skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> @@ -1264,7 +1265,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                         if (!skb)
>                                 goto wait_for_memory;
>
> -                       process_backlog = true;
> +                       process_backlog++;
>                         skb->ip_summed = CHECKSUM_PARTIAL;
>
>                         skb_entail(sk, skb);
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
