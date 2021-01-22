Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A4300258
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbhAVMCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbhAVKyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:54:39 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DE7C061786
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 02:53:58 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id x21so10096421iog.10
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 02:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vse2orAIc61P3ZfRdF2aUXRbMcJ34GBbNbDziqUJ0uQ=;
        b=hNYKJh4ivtbOelmKTPNNlDrpjd4LiR6vLaN8zGQIGVw5uJowZQNlig1JmKIovkmUgI
         WtS2u52/xgGmEwKp34ITbvHXKDvthuqsdrwCImR8z/x4ckudS3UoapkbatrCprjAsFQ6
         RHAHNVGO1FUOHjusMxJTyiIMH/jV0o9MgjioEEe1pn4fhThKhXHAA3AqQdksHnfI2HLJ
         Raf1gGERmmwY3o7G3Hx3PJGybqsghi0jX21awDfQZgpTXWqhID2kNOB6Hl/fNn17ZYCU
         cn3dDla7oEhjggN1kDAs+FmNlPAX3K7lEkMCuFSFPR/MMYXmrs7a32Cp7Hfn17KZk4p9
         1Xyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vse2orAIc61P3ZfRdF2aUXRbMcJ34GBbNbDziqUJ0uQ=;
        b=a1qkdG3zKZGKTZ1kGRcZAVePEwHthcLhhcxIzjqvwCb1wnggm6wLFiZF+5GrWSEaoq
         ErHDjoinqtDWZljR24yx9M9M/WNCoVwY9ot5wV6MSitYtH0DDrUa1WFApHuvFHRhyWNF
         Fj/OFSApLugrnlPo+N/EdTqUVQASFwtHizabEoXOJrJ+NOAbvJOy12StS/hlu0wHWhZe
         t9v/hWt/0c62yhA8fqIMstpBg8M5zsgpWpkJlRwzHTdyin32TbMhvtfVZLahHggyGjHJ
         pHvo93ky5sJyqOkUrWFCe+U/INbG7i0J0c7PYFuv3hECuv6RTXfI1XjtEL/ZsK3d1sjz
         Oczw==
X-Gm-Message-State: AOAM533zbWj1uC9yLHKDASuFuwaz2h+6Lq/lTlN0flXm7gddKGMn8h7U
        vix5Rv0GR7+hazofp7/Lz0bgkYE8W4svM90JpjyJIVOVYZ0=
X-Google-Smtp-Source: ABdhPJzoPVZX3Ue+z4i8ATR91e2c/Yi8gF8IO8hGlxOTjBKq2UtNJs1btT/txFdL5wdCjaxK34lIKiUHYBfGOZ7cuog=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr504017ili.205.1611312837888;
 Fri, 22 Jan 2021 02:53:57 -0800 (PST)
MIME-Version: 1.0
References: <1611311242-6675-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611311242-6675-1-git-send-email-yangpc@wangsu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jan 2021 11:53:46 +0100
Message-ID: <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> change from DISORDER to OPEN. If the sender is app-limited, it can only
> wait for the RTO timer to expire and retransmit.
>
> The reason for this is that the TLP timer is set before CA_STATE changes
> in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> until after tcp_fastretrans_alert() returns and remove the
> FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
>
> This commit has two additional benefits:
> 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> avoid spurious RTO caused by RTO timer early expires.
> 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> timer is set.
>
> Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

This looks like a very nice patch, let me run packetdrill tests on it.

By any chance, have you cooked a packetdrill test showing the issue
(failing on unpatched kernel) ?

Thanks.

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
