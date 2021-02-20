Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CAD320322
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 03:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBTCZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 21:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhBTCZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 21:25:20 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CB9C061574
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 18:24:39 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a4so9118379wro.8
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 18:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UoU4tpvF69vvvt1X/oNX9U45MXD4nIA/xhwKBjIoiM4=;
        b=i5SvSNPxpFV0SP2RexUvRcZ/V7GJjPefhgRTAdSd7hi7rrqDZo3+Jj3PWDpN4BTFVb
         SjPzPSlFjWYV7c6OqI1CKT9+z7W8/GwQaPnPIek1oftL6HSoNkAmesC4x/uKWbJttSpc
         lXfuIMSZ5mV0VW1TXXv6n63ksw+XB60a29pxX8z6j3uLz07hQhw5BAsCbHRlV2Vml2Ym
         LXjbYM1bWgOcQjEMyFmXKPM5Yr96AAsfx1ZLKHl/kAmzE/zplATkvYeuZAQiMXIUPnVH
         pwtkbEhF+t8PKSXE3GxRA0H9Ff8K4WV5AwzPcO93FfwuCw4Vh0+AFM46zruBv+K6BVCA
         RFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UoU4tpvF69vvvt1X/oNX9U45MXD4nIA/xhwKBjIoiM4=;
        b=MSF9n2upkcmMPnOOOXaT9LhGUTOrRrk0qhgIdTUM4xcmamXIbQTCCl3twgEXAPMiiJ
         GuVujntuCmjf+6ge65lxTNQpRyAuaagPTjJ08abYrk9zj9dlXpFpEu4+pcvtp3JFvndf
         4a+JyxDUOokxqEZzVPasa8+U7BF/3+wL5S7zyHqFtqBaf3D6xuBkuIzIEP2rkxbtCCgX
         qoybzxMqYT5TCz1tH0WTy2t+8yaZlAw91rAxuPow6oUu7z2II2gBpv6BtF4Nq2oseQ0q
         lIMj5FpY1JoB3AmFm+mTQynLijwLwKs472ddX06KT2cyCswJb6FG9V21PAfjz4g3S4t8
         Im1w==
X-Gm-Message-State: AOAM532mLp4O0tjFdCUXwQVAHIR5SmQGGyNAmWsCezTxYoTLvdPfGpLc
        PiHPcQNrtwuK/g3qiCm/ZgHxUM4s7NkDLr/JQZRPrQ==
X-Google-Smtp-Source: ABdhPJwPefi9vd6ur48vMAuvT3Pa4HeV3aINqGAtBbKyOpINYpGVueoIWtPxI8ksetdYneRMByBl8PnmUCHmxyswaqQ=
X-Received: by 2002:adf:8084:: with SMTP id 4mr11637816wrl.49.1613787878514;
 Fri, 19 Feb 2021 18:24:38 -0800 (PST)
MIME-Version: 1.0
References: <20210220005447.GA93678@localhost.localdomain>
In-Reply-To: <20210220005447.GA93678@localhost.localdomain>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 19 Feb 2021 18:24:00 -0800
Message-ID: <CAK6E8=err50_ob6r99eXw++0D84yJe66Lzsz6F7KWbU5=ii_ew@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix keepalive when data remain undelivered
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmai.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 4:54 PM Enke Chen <enkechen2020@gmail.com> wrote:
>
> From: Enke Chen <enchen@paloaltonetworks.com>
>
> TCP keepalive does not timeout under the condition that network connection
> is lost and data remain undelivered (incl. retransmit). A very simple
> scenarios of the failure is to write data to a tcp socket after the network
> connection is lost.

AFAIK current Linux TCP KA implementation does not violate the
RFC793bis (Section 3.7.4 Keep-Alives)
https://tools.ietf.org/html/draft-ietf-tcpm-rfc793bis-20#section-3.7.4

We have even raised that in IETF tcpm list to get more clarity
https://mailarchive.ietf.org/arch/msg/tcpm/KxcEsLtDuDNhcP8UjbyPkJqpzsE/

I believe you interpret the keep-alive differently -- so this is
arguably a subjective "bug-fix". As Neal and I have expressed in our
private communications, current Linux KA has been implemented for more
than a decade. Changing this behavior may break many existing
applications even if it may benefit certain.

>
> Under the specified condition the keepalive timeout is not evaluated in
> the keepalive timer. That is the primary cause of the failure. In addition,
> the keepalive probe is not sent out in the keepalive timer. Although packet
> retransmit or 0-window probe can serve a similar purpose, they have their
> own timers and backoffs that are generally not aligned with the keepalive
> parameters for probes and timeout.
>
> As the timing and conditions of the events involved are random, the tcp
> keepalive can fail randomly. Given the randomness of the failures, fixing
> the issue would not cause any backward compatibility issues. As was well
> said, "Determinism is a special case of randomness".
>
> The fix in this patch consists of the following:
>
>   a. Always evaluate the keepalive timeout in the keepalive timer.
>
>   b. Always send out the keepalive probe in the keepalive timer (post the
>      keepalive idle time). Given that the keepalive intervals are usually
>      in the range of 30 - 60 seconds, there is no need for an optimization
>      to further reduce the number of keepalive probes in the presence of
>      packet retransmit.
>
>   c. Use the elapsed time (instead of the 0-window probe counter) in
>      evaluating tcp keepalive timeout.
>
> Thanks to Eric Dumazet, Neal Cardwell, and Yuchung Cheng for helpful
> discussions about the issue and options for fixing it.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2 Initial git repository build")
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> ---
>  net/ipv4/tcp_timer.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 4ef08079ccfa..16a044da20db 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -708,29 +708,23 @@ static void tcp_keepalive_timer (struct timer_list *t)
>             ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)))
>                 goto out;
>
> -       elapsed = keepalive_time_when(tp);
> -
> -       /* It is alive without keepalive 8) */
> -       if (tp->packets_out || !tcp_write_queue_empty(sk))
> -               goto resched;
> -
>         elapsed = keepalive_time_elapsed(tp);
>
>         if (elapsed >= keepalive_time_when(tp)) {
>                 /* If the TCP_USER_TIMEOUT option is enabled, use that
>                  * to determine when to timeout instead.
>                  */
> -               if ((icsk->icsk_user_timeout != 0 &&
> -                   elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout) &&
> -                   icsk->icsk_probes_out > 0) ||
> -                   (icsk->icsk_user_timeout == 0 &&
> -                   icsk->icsk_probes_out >= keepalive_probes(tp))) {
> +               u32 timeout = icsk->icsk_user_timeout ?
> +                 msecs_to_jiffies(icsk->icsk_user_timeout) :
> +                 keepalive_intvl_when(tp) * keepalive_probes(tp) +
> +                 keepalive_time_when(tp);
> +
> +               if (elapsed >= timeout) {
>                         tcp_send_active_reset(sk, GFP_ATOMIC);
>                         tcp_write_err(sk);
>                         goto out;
>                 }
>                 if (tcp_write_wakeup(sk, LINUX_MIB_TCPKEEPALIVE) <= 0) {
> -                       icsk->icsk_probes_out++;
>                         elapsed = keepalive_intvl_when(tp);
>                 } else {
>                         /* If keepalive was lost due to local congestion,
> @@ -744,8 +738,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
>         }
>
>         sk_mem_reclaim(sk);
> -
> -resched:
>         inet_csk_reset_keepalive_timer (sk, elapsed);
>         goto out;
>
> --
> 2.29.2
>
