Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3C31A8BF
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBMAYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhBMAYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:24:06 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0219C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:23:25 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id q12so1167212ybm.8
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcJWxqqy7o4h7faRAD+/kVaukl57wU7Ig26/EiyGDro=;
        b=BbAu3TJ3DMzv97qyMlzj2mZrFpPe09KTJrw72ZjJpWt8/w9cotSPAnekDkWCGu/Bp9
         nZ3pbQN9+Pj4imrUVdLvwGKXjo2Pz8nuqFyyTff63drWJtClgRtOs9/pU/baosu7abyS
         1Eli9tJPsJCxqwvidPMl+BIGFTkoyexxzH1T3Gmca4Am/pzo5fwSyxTE/PY27c3Ja39m
         Dwc/0vE2R1994Tn2q1maVTwZWX+JxC5N4FzMWQyI70Y6H37mKxvCrK+LFGzGoMVVUmQ5
         1+bbSBPBnNrdUYv2lHMxvSX2uWSPih51z0gXek2s2uyLrbyReCFVg5OnIL9dL49e2eP0
         HXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcJWxqqy7o4h7faRAD+/kVaukl57wU7Ig26/EiyGDro=;
        b=DIB6dwdvSQkIik63/KSN2FRePO2BFpgRFgRatOiKQkyzTtjQtDLx9xo6gDAG86Gwc9
         9Ui45IunaWpW2XwzNYNxGyDlyDwgXvK+626/TfLXdPTLlnOYaQyI0Gf7SX9na8iI4de4
         ILSLUEvw7hgeBFA5pcGOUOJJmKEt5ftIJUdZZA8mxJxrF5dyfqNE3PabKhuFWedRFIkU
         Q2uqt1R3ChkIMmzv+nnqy8KIBeKGtWk4LF+5n8JCTLJMWg8/O1Q2y1gSB1Ss2r+Aeavc
         n/dMBm1XzeNPxrLN0c51f+UZjBlWm5F3fnLJlsRqeWndBWmgCxh1HLOV3Ex9QEntPFvO
         xaWg==
X-Gm-Message-State: AOAM533A1K9MYcAhDhy+ITrQXKGE/dkOPc6kaxeh+VeENQRYTPtJ/EMy
        Mt85dwWG8IpP9q+j+G1BImefgIyN0a/mP22eVtQRFXbciE0=
X-Google-Smtp-Source: ABdhPJxiIsi+P5ppcEHQ+1gAasF/c77pJKP78fdrfMto4HTZ6x3J3770fjY1ygBxnhM6XUriYX+SXJOIt1x12dzc1dg=
X-Received: by 2002:a25:2206:: with SMTP id i6mr7261333ybi.351.1613175804711;
 Fri, 12 Feb 2021 16:23:24 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com> <20210212232214.2869897-2-eric.dumazet@gmail.com>
In-Reply-To: <20210212232214.2869897-2-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 12 Feb 2021 16:23:13 -0800
Message-ID: <CAEA6p_Dhj+N7RDCXRX8-dVXU+9jfDeuedJ=iU9wQ8xAr5Wt_9g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tcp: fix SO_RCVLOWAT related hangs under mem pressure
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 3:22 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> While commit 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
> fixed an issue vs too small sk_rcvbuf for given sk_rcvlowat constraint,
> it missed to address issue caused by memory pressure.
>
> 1) If we are under memory pressure and socket receive queue is empty.
> First incoming packet is allowed to be queued, after commit
> 76dfa6082032 ("tcp: allow one skb to be received per socket under memory pressure")
>
> But we do not send EPOLLIN yet, in case tcp_data_ready() sees sk_rcvlowat
> is bigger than skb length.
>
> 2) Then, when next packet comes, it is dropped, and we directly
> call sk->sk_data_ready().
>
> 3) If application is using poll(), tcp_poll() will then use
> tcp_stream_is_readable() and decide the socket receive queue is
> not yet filled, so nothing will happen.
>
> Even when sender retransmits packets, phases 2) & 3) repeat
> and flow is effectively frozen, until memory pressure is off.
>
> Fix is to consider tcp_under_memory_pressure() to take care
> of global memory pressure or memcg pressure.
>
> Fixes: 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Arjun Roy <arjunroy@google.com>
> Suggested-by: Wei Wang <weiwan@google.com>
> ---
Nice description in the commit msg!

Reviewed-by: Wei Wang <weiwan@google.com>

>  include/net/tcp.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 25bbada379c46add16fb7239733bd6571f10f680..244208f6f6c2ace87920b633e469421f557427a6 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1431,8 +1431,13 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied);
>   */
>  static inline bool tcp_rmem_pressure(const struct sock *sk)
>  {
> -       int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
> -       int threshold = rcvbuf - (rcvbuf >> 3);
> +       int rcvbuf, threshold;
> +
> +       if (tcp_under_memory_pressure(sk))
> +               return true;
> +
> +       rcvbuf = READ_ONCE(sk->sk_rcvbuf);
> +       threshold = rcvbuf - (rcvbuf >> 3);
>
>         return atomic_read(&sk->sk_rmem_alloc) > threshold;
>  }
> --
> 2.30.0.478.g8a0d178c01-goog
>
