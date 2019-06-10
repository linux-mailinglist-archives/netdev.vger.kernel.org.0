Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FCF3BF7E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390305AbfFJW10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:27:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45986 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbfFJW10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:27:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so10753632wre.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ttS4wlDzG89MZEY9puhRqhhJqlVbyTnWYQlFeTODqxk=;
        b=RYRo+8/JxL+pVkTLEvlB7T2cw7k3MoZFvOMI2tWhR3ivR0UEV3aWjVZUamd8m0tcAQ
         c6Mm6Sa5r8ZnLYwoaMTFSV3e3Mzt9CVff1OYEpnNG0/FG2Y4VZN+UW/K5sKiDqH238S/
         E6phRzQTOQoW8rMsGK7Ir0xMBVMrxfRgLYWHbRUrN1GVLbQBoHFqNg+PwuEg/Ntua9bn
         7ns0GHy1Vqc5hQHPIDX3TvzBFXgRaEhSpeYrUqJcuYIjsZoGy+8Z2ipuPAdcRx0Gltkf
         JydH2/G6NaSj2zCFEDqrDCS87ryrELigqf6J8Zru2bE1/innaILZwXF1BFc/riKMSRQI
         TA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ttS4wlDzG89MZEY9puhRqhhJqlVbyTnWYQlFeTODqxk=;
        b=jWC+U+/q3fx6pbz8SlVpKvJ1KnV9WJkNe27OOZz2sybx1+l/oPOtAOapz1AxDdhd7Z
         Ph0/jXLOBISbOyZvc3lll1/2O8wpKMlM+oj31OIWYBI4jIhcANQ8OR2wa8EKf2t1Zlwu
         sZz6b4iKI7XG5iObw9n9qmHyIUVEupFDzK0Se+JqJQzwyOGjRtULEvV1WxxGxMZRQ7hB
         PHcChYLk9fUhstDQi0tGdLwE6K5pPkS/AJVDQT2Gl7t3kj+vHDgam6ZmxxC7nF39+ods
         wO6nZGagAzum+Q2oxiri62YZ0x/WFqecWUuYljrUAglu32Zfgknwk7jyFSxZUd7nXjvU
         YF8Q==
X-Gm-Message-State: APjAAAVJgGHU8tFmIg8/v1U4wM+zWqJJlAvmUftKGUmAT/V7X00tk/4m
        eCf49phQTD4qSCQQPN3BGDgm/HjeZzpM304qsEw=
X-Google-Smtp-Source: APXvYqzRJM8/udkUVJ74hXN207gGYIQV8OWcY7XplwMplbLV4cLwIuBsXFdxNpZd1MZh5+wWNcE958juMHUkCdw1p4g=
X-Received: by 2002:a5d:4141:: with SMTP id c1mr32174078wrq.159.1560205644491;
 Mon, 10 Jun 2019 15:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190610214543.92576-1-edumazet@google.com>
In-Reply-To: <20190610214543.92576-1-edumazet@google.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Tue, 11 Jun 2019 08:26:48 +1000
Message-ID: <CAGHK07A7QuGpcfNGv0h3hdMj8U1GVkrmRyuwWRMRyrOwJWCOAQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for fixing that Eric.

On Tue, Jun 11, 2019 at 7:45 AM Eric Dumazet <edumazet@google.com> wrote:
>
> TCP can send ACK packets on behalf of SYN_RECV sockets.
>
> tcp_v4_send_ack() and tcp_v6_send_response() incorrectly
> dereference sk->sk_mark for non TIME_WAIT sockets.
>
> This field is not defined for SYN_RECV sockets.
>
> Using sk_to_full_sk() should get back to the listener socket.
>
> Note that this also provides a socket pointer to sock_net_uid() calls.
>
> Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  net/ipv4/tcp_ipv4.c | 6 ++++--
>  net/ipv6/tcp_ipv6.c | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index f059fbd81a84314ae6fef37f600b0cf28bd2ad30..2bb27d5eae78efdff52a741904d7526a234595d8 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -856,12 +856,14 @@ static void tcp_v4_send_ack(const struct sock *sk,
>         if (oif)
>                 arg.bound_dev_if = oif;
>         arg.tos = tos;
> -       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
>         local_bh_disable();
>         ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
> -       if (sk)
> +       if (sk) {
> +               sk = sk_to_full_sk(sk);
>                 ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
>                                    inet_twsk(sk)->tw_mark : sk->sk_mark;
> +       }
> +       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
>         ip_send_unicast_reply(ctl_sk,
>                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
>                               ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index ad7039137a20f9ad8581d9ca01347c67aa8a8433..ea4dd988bc7f9a90e0d95283e10db5a517a59027 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -884,6 +884,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>         }
>
>         if (sk) {
> +               sk = sk_to_full_sk(sk);
>                 if (sk->sk_state == TCP_TIME_WAIT) {
>                         mark = inet_twsk(sk)->tw_mark;
>                         /* autoflowlabel relies on buff->hash */
> --
> 2.22.0.rc2.383.gf4fbbf30c2-goog
>
