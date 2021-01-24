Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD430301DC2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbhAXRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbhAXRCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:02:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07BAC061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:01:27 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 6so9932137wri.3
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+gv7vf0FDO27riaDuWjNeWfsYkWooszjL4cSVXPgYrU=;
        b=MxNZXMlXUOdhIIV1eMao02OiPD+TiGEssDMSgVi1ZhgpSMX+b2/0B2HkoCtWAj4b4N
         8eq4g0yT1hBHkE9WTuRrurFaYCXdpVsLHu1MkGfMUwULnBOP/AQ6w9be7ps2wUgWYtiu
         Q40nt7qwRRfSiUUvqAi46v9JmKT0MGDUsyGDhA1dOKNKFB++LW3IbhS7IGNRf+rVux/K
         4IDiTJgdSAwoYBN2WKnP0rfOHSvCFoCI1XR4ClW7KLGCL6SdUNAxtm+21YFDWFU7sL9O
         rhMclhncaZ1qzdHqWAPxL19NrHkoHopxJlt7xhuptzwGPA8674KR5PkUROc1meMQPlQA
         1Vyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+gv7vf0FDO27riaDuWjNeWfsYkWooszjL4cSVXPgYrU=;
        b=jp+fK6TQlxUVRDXasySVqywurxPkSOCuLpih1oIkmQIXr/LrIrNu5+xWgXThJbwqT7
         W4vD+t1pnciYYk4IKyodFrFU1B6DecncItyqlNrxdpKLHZEvFFVQ0+g3cY6sAKHjYyl4
         P5c5VLqeaTEoJ3Z7Pw/UdXbditMp5V8OZzEMXj9ImzLnq42eue781XtA2Sf5QY/laQdd
         3f4fQrGXqTpv726ga31nzst8GnnHmN2f6blwdODjppUXMGkFIyDWUBen0jBLMVWwacJB
         0BIU+whY2jWVeZac3yMrZq0cnpIgHHsZWh7VPECM+B1jKWU59vWshNxireoFM2zdZAgU
         GFmQ==
X-Gm-Message-State: AOAM533HzPNBSFyuNeQG6DNzgyDzM3Yg2NPCMyJqa5m01O9yqMLr3Bh/
        VVtMilwQzxWVcAWhLMAT6f+OHh2egZ2EuMouqg/MOw==
X-Google-Smtp-Source: ABdhPJwUJ2Qkia6ecGDZ/2JAbT6Szzp5VbEwa4TVyLVPDIujo2GXmO2QrHlJApKqtw9mQ/giZkLANSSV7va6+utWDks=
X-Received: by 2002:adf:e38d:: with SMTP id e13mr8905741wrm.231.1611507686109;
 Sun, 24 Jan 2021 09:01:26 -0800 (PST)
MIME-Version: 1.0
References: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Sun, 24 Jan 2021 09:00:49 -0800
Message-ID: <CAK6E8=c2WuvYWasZWYtP+9PCjFmrVCxCmCMVsvs566yG-ej5iQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp: fix TLP timer not set when CA_STATE changes
 from DISORDER to OPEN
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 9:11 PM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Upon receiving a cumulative ACK that changes the congestion state from
> Disorder to Open, the TLP timer is not set. If the sender is app-limited,
> it can only wait for the RTO timer to expire and retransmit.
>
> The reason for this is that the TLP timer is set before the congestion
> state changes in tcp_ack(), so we delay the time point of calling
> tcp_set_xmit_timer() until after tcp_fastretrans_alert() returns and
> remove the FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer
> is set.
>
> This commit has two additional benefits:
> 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> avoid spurious RTO caused by RTO timer early expires.
> 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> timer is set.
>
> Link: https://lore.kernel.org/netdev/1611311242-6675-1-git-send-email-yangpc@wangsu.com
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
thanks!
> Cc: Eric Dumazet <edumazet@google.com>
> ---
> v2:
>  - modify the commit message according to Yuchung's suggestion
>
>  include/net/tcp.h       |  2 +-
>  net/ipv4/tcp_input.c    | 10 ++++++----
>  net/ipv4/tcp_recovery.c |  5 +++--
>  3 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 78d13c8..67f7e52 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2060,7 +2060,7 @@ static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
>  void tcp_newreno_mark_lost(struct sock *sk, bool snd_una_advanced);
>  extern s32 tcp_rack_skb_timeout(struct tcp_sock *tp, struct sk_buff *skb,
>                                 u32 reo_wnd);
> -extern void tcp_rack_mark_lost(struct sock *sk);
> +extern bool tcp_rack_mark_lost(struct sock *sk);
>  extern void tcp_rack_advance(struct tcp_sock *tp, u8 sacked, u32 end_seq,
>                              u64 xmit_time);
>  extern void tcp_rack_reo_timeout(struct sock *sk);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index c7e16b0..d0a9588 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2859,7 +2859,8 @@ static void tcp_identify_packet_loss(struct sock *sk, int *ack_flag)
>         } else if (tcp_is_rack(sk)) {
>                 u32 prior_retrans = tp->retrans_out;
>
> -               tcp_rack_mark_lost(sk);
> +               if (tcp_rack_mark_lost(sk))
> +                       *ack_flag &= ~FLAG_SET_XMIT_TIMER;
>                 if (prior_retrans > tp->retrans_out)
>                         *ack_flag |= FLAG_LOST_RETRANS;
>         }
> @@ -3815,9 +3816,6 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
>
>         if (tp->tlp_high_seq)
>                 tcp_process_tlp_ack(sk, ack, flag);
> -       /* If needed, reset TLP/RTO timer; RACK may later override this. */
> -       if (flag & FLAG_SET_XMIT_TIMER)
> -               tcp_set_xmit_timer(sk);
>
>         if (tcp_ack_is_dubious(sk, flag)) {
>                 if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
> @@ -3830,6 +3828,10 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
>                                       &rexmit);
>         }
>
> +       /* If needed, reset TLP/RTO timer when RACK doesn't set. */
> +       if (flag & FLAG_SET_XMIT_TIMER)
> +               tcp_set_xmit_timer(sk);
> +
>         if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
>                 sk_dst_confirm(sk);
>
> diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
> index 177307a..6f1b4ac 100644
> --- a/net/ipv4/tcp_recovery.c
> +++ b/net/ipv4/tcp_recovery.c
> @@ -96,13 +96,13 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
>         }
>  }
>
> -void tcp_rack_mark_lost(struct sock *sk)
> +bool tcp_rack_mark_lost(struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         u32 timeout;
>
>         if (!tp->rack.advanced)
> -               return;
> +               return false;
>
>         /* Reset the advanced flag to avoid unnecessary queue scanning */
>         tp->rack.advanced = 0;
> @@ -112,6 +112,7 @@ void tcp_rack_mark_lost(struct sock *sk)
>                 inet_csk_reset_xmit_timer(sk, ICSK_TIME_REO_TIMEOUT,
>                                           timeout, inet_csk(sk)->icsk_rto);
>         }
> +       return !!timeout;
>  }
>
>  /* Record the most recently (re)sent time among the (s)acked packets
> --
> 1.8.3.1
>
