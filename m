Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC22F2D14E2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgLGPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGPiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:38:19 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF03C061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 07:37:38 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i9so13786607ioo.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 07:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tpDIaohNT6b4VE5Dcv8hS0dg+lL8nZ1wsZRCzXntD3s=;
        b=Km4FK5m046Nsnan16mf4I3CZam0c5jO2AUjrI8pNXfk1Q4BR+RQwdSU62PtkpgKB4z
         5UTtMz6s2hC0wE73pQjM9tPwELfGtBem+P0Ut/WlUPWOFAZ1eZtEpZMzDJP6oegg13Kd
         0/bqeDGxIaq86h9zE/Nyfv+7W2JhMwLn6d9UX3IrUUy9RjkEMWFZk+HBTD2YWx/4oeAy
         Mxu2LjDgMWeS2FwhX3vmcy8Y2L4gDM5baYbALsgwBsAlOh8ahWjFxhl9emn+o+lh1onf
         Q9WTYdhQpIpyHyDvMz0jSg2keC0/PmKbL5HlqmbsO7dGiQXI4u0YRIWwOS9jwSS+qpac
         sWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tpDIaohNT6b4VE5Dcv8hS0dg+lL8nZ1wsZRCzXntD3s=;
        b=pFuyU1PmgNcYIMD1B/WI/UzFy4WtGXhf9/DPxCHT+2xiVj7JKSBbToyDCThprMPwqk
         rtUC+5Hres8D7i4gkWEBopGOVgqd6PtRt326vLtyotRxRxmnBj/T9X3qSbxAO6yRr5gP
         OexRUcoEfdShGMSzhKTWD7/R4arBSsZx5Rix4BkIXXGULbzA0c+O7sL9Ja1bucinf6Jb
         8UIqzbDnMoJD+Go7Ou83dcoH9hXdbgdtRED0ppykVD3qAxvV6Adz1BiGRs0kw88BsNG9
         H3FhEZ+Caw6Q3A39fNT5kv1EmubAfUQi/nsFf5tCtGkS93JvNBzpwwQg8SmDm9MZR9ig
         aJXg==
X-Gm-Message-State: AOAM533hBl7aI8WJAXc5HL2QPkglyw2uNUTTIgUhS1kmCSusEgCmLyH2
        WB1F8EcONRo1i2hILHt6XvQOksyQ5pRyKsKYAbciRlSldV0wEA==
X-Google-Smtp-Source: ABdhPJwLi8qPl5EPKUMQwL4rMuDHrM57DMl05W2+q/fckwjCGx1efddfNzqdg3JP9oqyPGcyNKLAmoEfRRxXAo4PhCk=
X-Received: by 2002:a6b:c8c1:: with SMTP id y184mr20385847iof.99.1607355458079;
 Mon, 07 Dec 2020 07:37:38 -0800 (PST)
MIME-Version: 1.0
References: <4ABEB85B-262F-4657-BB69-4F37ABC0AE3D@amazon.com> <20201207114049.7634-1-abuehaze@amazon.com>
In-Reply-To: <20201207114049.7634-1-abuehaze@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 16:37:26 +0100
Message-ID: <CANn89iJb6snL7xCK=x=du_nH_4cCVyNz7zgPNm9AgZWW5m1ZJg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix receive buffer autotuning to trigger for any
 valid advertised MSS
To:     Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Wei Wang <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 12:41 PM Hazem Mohamed Abuelfotoh
<abuehaze@amazon.com> wrote:
>
>     Previously receiver buffer auto-tuning starts after receiving
>     one advertised window amount of data.After the initial
>     receiver buffer was raised by
>     commit a337531b942b ("tcp: up initial rmem to 128KB
>     and SYN rwin to around 64KB"),the receiver buffer may
>     take too long for TCP autotuning to start raising
>     the receiver buffer size.
>     commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>     tried to decrease the threshold at which TCP auto-tuning starts
>     but it's doesn't work well in some environments
>     where the receiver has large MTU (9001) especially with high RTT
>     connections as in these environments rcvq_space.space will be the same
>     as rcv_wnd so TCP autotuning will never start because
>     sender can't send more than rcv_wnd size in one round trip.
>     To address this issue this patch is decreasing the initial
>     rcvq_space.space so TCP autotuning kicks in whenever the sender is
>     able to send more than 5360 bytes in one round trip regardless the
>     receiver's configured MTU.
>
>     Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
>     Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>
> Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 389d1b340248..f0ffac9e937b 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
>  static void tcp_init_buffer_space(struct sock *sk)
>  {
>         int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         int maxwin;
>
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>
> -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
> +       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * icsk->icsk_ack.rcv_mss);

I find using icsk->icsk_ack.rcv_mss misleading.

I would either use TCP_MSS_DEFAULT , or maybe simply 0, since we had
no samples yet, there is little point to use a magic value.

Note that if a driver uses 16KB of memory to hold a 1500 bytes packet,
then a 10 MSS GRO packet is consuming 160 KB of memory,
which is bigger than tcp_rmem[1]. TCP could decide to drop these fat packets.

I wonder if your patch does not work around a more fundamental issue,
I am still unable to reproduce the issue.
