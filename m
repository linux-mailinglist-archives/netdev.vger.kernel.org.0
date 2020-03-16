Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A521874AF
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbgCPV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:26:01 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37092 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732621AbgCPVZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:25:59 -0400
Received: by mail-oi1-f194.google.com with SMTP id w13so19507902oih.4
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7jm6R1lI66fN9dOATmAhH/neJJRs+NMkuLfeIMHpr8=;
        b=fw+Fzk5Nm5NC9Jjvn8y+I4rt14Z5Txz55IHQeV31ArJE88uELShhqpnkObRE5QZtmD
         jYMj0aYW4UFoNXmQYdsS7keXHF7J8MPwMX0fqG/DLhwfR4JW1s2tbnlFC2Ox7c0faXxJ
         b4K3YRyFMGS85VJnlMqBlqbcjmhoGhEjqw/5iwJkh2GA5Kli9USgQhTUXHtX/PDrI/kA
         Ro1G92+6c6x/dfMwER6p7Vg/PWNh201KOudDxPtz46mvigy08VngVUd4a9UkkBaXkNmM
         uS2lXIgqwdnUp2rhhr9ii9uFKVJFxThazdVykMUW+Cpqux+603zJr9aaHk0o6jfMw2Dv
         pzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7jm6R1lI66fN9dOATmAhH/neJJRs+NMkuLfeIMHpr8=;
        b=GyAA05GFOpmi4bDSekgsHYFQqdZSHaGQymUCjUK2TvXxyzgz9fI3rW07ZRm+5Ytq4/
         oHIS/R1AOnwt2AUSt6AhQloQRCk3IT7xZxvn4DfcVxAWhgM6VSBjLqqX/21S/C3SRRgf
         0QBJHmmh38Cs36l07HofrJBjjoW5x6X0IWmVt8u4J9a49lcCxV19OFUdnTDGVFU4IQOe
         WOMN4fFS2B94hQSDKfLbiojJPMvzheoqlhpt9Y6U1Ckz08In7V7EmaFlmwGmY+I9ePNg
         ho/nUnGtcOiJ2DF8SMnxWPnDGmsUVXJV4No2MWdG/WpkHDwIAvx2PzEw0eLodz2Zdf8T
         /lHg==
X-Gm-Message-State: ANhLgQ0jSxtSEfPOjKQNV4i0mzX+xplndlxUVRemnjfq8juClnyeakGO
        0cD1OOtqxgX97Z2HGMcmKhJHmJpVA877WF49ub6Nfw==
X-Google-Smtp-Source: ADFU+vvkxg9Ial7cYzV1SowN5+eIGc432CbfznEyhKHlbm/HUvs/rzGh+lWYhOHIHg7xIx54UQ3VntghxWyXsT5IU5o=
X-Received: by 2002:aca:aa12:: with SMTP id t18mr1157072oie.95.1584393957751;
 Mon, 16 Mar 2020 14:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com> <1584340511-9870-3-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1584340511-9870-3-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 16 Mar 2020 17:25:41 -0400
Message-ID: <CADVnQy=nhaKY8Ub84TvFH4cFtW92_TU72OxXnV32FzdEGtDCvw@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v2 2/5] tcp: fix stretch ACK bugs in Scalable
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 2:37 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Change Scalable to properly handle stretch ACKs in additive
> increase mode by passing in the count of ACKed packets to
> tcp_cong_avoid_ai().
>
> In addition, because we are now precisely accounting for
> stretch ACKs, including delayed ACKs, we can now change
> TCP_SCALABLE_AI_CNT to 100.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_scalable.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/tcp_scalable.c b/net/ipv4/tcp_scalable.c
> index 471571e..6cebf41 100644
> --- a/net/ipv4/tcp_scalable.c
> +++ b/net/ipv4/tcp_scalable.c
> @@ -10,10 +10,9 @@
>  #include <net/tcp.h>
>
>  /* These factors derived from the recommended values in the aer:
> - * .01 and and 7/8. We use 50 instead of 100 to account for
> - * delayed ack.
> + * .01 and and 7/8.
>   */
> -#define TCP_SCALABLE_AI_CNT    50U
> +#define TCP_SCALABLE_AI_CNT    100U
>  #define TCP_SCALABLE_MD_SCALE  3
>
>  static void tcp_scalable_cong_avoid(struct sock *sk, u32 ack, u32 acked)
> @@ -23,11 +22,13 @@ static void tcp_scalable_cong_avoid(struct sock *sk, u32 ack, u32 acked)
>         if (!tcp_is_cwnd_limited(sk))
>                 return;
>
> -       if (tcp_in_slow_start(tp))
> -               tcp_slow_start(tp, acked);
> -       else
> -               tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
> -                                 1);
> +       if (tcp_in_slow_start(tp)) {
> +               acked = tcp_slow_start(tp, acked);
> +               if (!acked)
> +                       return;
> +       }
> +       tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
> +                         acked);
>  }
>
>  static u32 tcp_scalable_ssthresh(struct sock *sk)
> --

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
