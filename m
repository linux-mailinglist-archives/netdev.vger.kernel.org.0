Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE38B11D9B5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfLLWyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:54:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40746 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbfLLWyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:54:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so4439617wmi.5
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TR14xQQo4P+GdVaPvc3bcU+nYv8hdJZTKf/ZUAYkexE=;
        b=dl6Mrawq2KWSAp9y67cAa2UZp70alyqo4NX/IF7WG4oGK6Zr37ISxOd3Dc9LkjnyDb
         Z0iTXHGiJX/gc91HLfSK3uwgOT01cf9d56FHMCfUn11k3EL7pzMMtFLZzJ7DtrZmyPNr
         9WV8z7lNhJkfHvgUAFi3r0cssVgpYYxttsh8VTPD2+TcfhMQroUKYblO2X6BRxmMT/5x
         Uq0Gto2Xt6iyl0bDf/XxeXrjx/oBl85a4EtGRQa6AjOhsVGfyyvNSEggl7rGxxY6CfDL
         eZCcElrLanNyNdhkBXSII6ujH+7jt+vSYBK6F2u41lYvuzwJlwrPzQJBDrR5I0rUgx91
         b4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TR14xQQo4P+GdVaPvc3bcU+nYv8hdJZTKf/ZUAYkexE=;
        b=rxx5fw8VQliMFiZFlgtueCubtVAaO8QaFpxmDBBAVligEMC+UsJ2Y1h45RGjgV/JJq
         zvWEkuwhnr09d3A2CPoR1iYAR73JZqtT2ge6NXY8Jk4ce0e5zUAPoE1ChoKO89UC19iY
         sTt77nton72X71ZhVpMsq0UqkZrNY3ilkuSWCCUp4Z3/lopwhpNbr3NjEa8B1PduwvJa
         UHEvLF6pDKMoqy3Vue6BldYC8xf6hqlh2xrnbfHwBQWJrHDWJVlxDyCcJCBJZe/1EIwN
         8zinpGrpxJichj+WCsxF84gD09CvBXk73/N1wHJ+3fRWcU9DdS3Nf2lvSrYGibpwbyET
         ffzw==
X-Gm-Message-State: APjAAAXFwVETibptXQuzvJTVfjtdKse9kEcVZ6e/Hkty2XoedQsrvE17
        yv4ZCuX+nsGyyMsSnBKjcx8KFxjUstF4oKvkD2CeSw==
X-Google-Smtp-Source: APXvYqwwrNpFArxn5i+hLtu++m2uwFDlzJfbl+PZzqJ+KkfbzhSp44QH5y6WESoQLHstYc73jXZ8edyThMMFAGOQidk=
X-Received: by 2002:a1c:81c9:: with SMTP id c192mr9448828wmd.44.1576191287748;
 Thu, 12 Dec 2019 14:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com> <20191212205531.213908-3-edumazet@google.com>
In-Reply-To: <20191212205531.213908-3-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 12 Dec 2019 17:54:10 -0500
Message-ID: <CACSApvZg-3bD39nxWWRF1H6B9NNpt+pD0foYavDNzyZWeYQLLQ@mail.gmail.com>
Subject: Re: [PATCH net 2/3] tcp: refine tcp_write_queue_empty() implementation
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 3:55 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Due to how tcp_sendmsg() is implemented, we can have an empty
> skb at the tail of the write queue.
>
> Most [1] tcp_write_queue_empty() callers want to know if there is
> anything to send (payload and/or FIN)
>
> Instead of checking if the sk_write_queue is empty, we need
> to test if tp->write_seq == tp->snd_nxt
>
> [1] tcp_send_fin() was the only caller that expected to
>  see if an skb was in the write queue, I have changed the code
>  to reuse the tcp_write_queue_tail() result.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch!
> ---
>  include/net/tcp.h     | 11 ++++++++++-
>  net/ipv4/tcp_output.c |  5 +++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 86b9a8766648824c0f122f6c01f55d59bd0d7d72..e460ea7f767ba627972a63a974cae80357808366 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1766,9 +1766,18 @@ static inline bool tcp_skb_is_last(const struct sock *sk,
>         return skb_queue_is_last(&sk->sk_write_queue, skb);
>  }
>
> +/**
> + * tcp_write_queue_empty - test if any payload (or FIN) is available in write queue
> + * @sk: socket
> + *
> + * Since the write queue can have a temporary empty skb in it,
> + * we must not use "return skb_queue_empty(&sk->sk_write_queue)"
> + */
>  static inline bool tcp_write_queue_empty(const struct sock *sk)
>  {
> -       return skb_queue_empty(&sk->sk_write_queue);
> +       const struct tcp_sock *tp = tcp_sk(sk);
> +
> +       return tp->write_seq == tp->snd_nxt;
>  }
>
>  static inline bool tcp_rtx_queue_empty(const struct sock *sk)
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 57f434a8e41ffd6bc584cb4d9e87703491a378c1..36902d08473ec7e45a654234b407217ee6c65fb1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3129,7 +3129,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
>   */
>  void tcp_send_fin(struct sock *sk)
>  {
> -       struct sk_buff *skb, *tskb = tcp_write_queue_tail(sk);
> +       struct sk_buff *skb, *tskb, *tail = tcp_write_queue_tail(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>
>         /* Optimization, tack on the FIN if we have one skb in write queue and
> @@ -3137,6 +3137,7 @@ void tcp_send_fin(struct sock *sk)
>          * Note: in the latter case, FIN packet will be sent after a timeout,
>          * as TCP stack thinks it has already been transmitted.
>          */
> +       tskb = tail;
>         if (!tskb && tcp_under_memory_pressure(sk))
>                 tskb = skb_rb_last(&sk->tcp_rtx_queue);
>
> @@ -3144,7 +3145,7 @@ void tcp_send_fin(struct sock *sk)
>                 TCP_SKB_CB(tskb)->tcp_flags |= TCPHDR_FIN;
>                 TCP_SKB_CB(tskb)->end_seq++;
>                 tp->write_seq++;
> -               if (tcp_write_queue_empty(sk)) {
> +               if (!tail) {
>                         /* This means tskb was already sent.
>                          * Pretend we included the FIN on previous transmit.
>                          * We need to set tp->snd_nxt to the value it would have
> --
> 2.24.1.735.g03f4e72817-goog
>
