Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022C850490C
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 20:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiDQSyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 14:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiDQSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 14:54:51 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED892F024
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:52:15 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id o18so8933706qtk.7
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gy3F7iMrRPJy/O7P7d09GUwGk1CjHZO6obKcbkpomQc=;
        b=MuUZGI/LFhpMErUUavBSD7UvwHxLpqXIMa1ToijkhPoLxc4l47Y5s3YmL0YxeHi3/8
         mGExztr6AN8VAjC3cICryF3gefEE/Y52thtEQiDvuz6ag57T0XTQIVPcjf8sI8r59xcF
         qzZt7b42/ajVigFA8ClKH4oiUbDruxE6ZeptZIYP0Scb2MUx5VWJ+uzIQjqDINLX52PG
         KyjaP4iIQ7iH+3fgt/PJsMe/UNu6QVwcMGqB1oiWCIzxJHEJO8ZGy+52wOOcoUj51TtT
         6FNsyMRON1zrc7M2gHgm0yP7J2mmGEvu+Zq80J4kJJzFErN3OIK1mbjc3jTRtJU8nW/L
         Nrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gy3F7iMrRPJy/O7P7d09GUwGk1CjHZO6obKcbkpomQc=;
        b=2VE3v0DtmsbqPmVzsSf5/qNbqUzPw07JqSyElo3A6lpVHgDHezPHd0E1dR1tz7HWiK
         QifvjdS3EnLG2OQy65Gu2+2Hk5Sh9eFGUsWi/35T0sdwRhh68yt1eoLJ/nelEQGRCzSN
         g+3wes5GqnHBOdm7ALnYGX9jVFN5haYME38M0rq32YdmA1N0LAwoNW1Fw8DkkeRmYgzW
         4AsREx9YzZHIFxAymFxg5bd0nFG2pg9kA8zLVDKPIWZcnQP9tuh1HnYr0KJCZtDXLgoW
         buBpgzkBhJw+j0eUwSkx/I82XgDYY3KA78Kx/ZfzB2sfqIebFxSmYapjFgL4ERY3XasL
         m5EQ==
X-Gm-Message-State: AOAM5331lN3eiMjkCnVhIr69wckV+uFO+hzwx5+dSJLPAiEnmji4SYbA
        jLVONlRLAkmbUWq+7oKfLBgz0I4C9cuSIBhqF223Qg==
X-Google-Smtp-Source: ABdhPJzkeM789aXRVbQVfPa7Ip1JW3WBpuR/lK/LtF/OxDkBJ7RplhElAcZM7hqck5GodgR5fzcVcbKdAESSJYV9u2A=
X-Received: by 2002:ac8:578a:0:b0:2e1:a0d2:c3a with SMTP id
 v10-20020ac8578a000000b002e1a0d20c3amr5132830qta.261.1650221534609; Sun, 17
 Apr 2022 11:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com> <1650100749-10072-2-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1650100749-10072-2-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sun, 17 Apr 2022 14:51:58 -0400
Message-ID: <CADVnQymGad1=tvLocBCrGK5vtVDKv8m-dYP83VsZfmE-WFcL3w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] tcp: ensure to use the most recently sent
 skb when filling the rate sample
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 5:20 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> If an ACK (s)acks multiple skbs, we favor the information
> from the most recently sent skb by choosing the skb with
> the highest prior_delivered count. But in the interval
> between receiving ACKs, we send multiple skbs with the same
> prior_delivered, because the tp->delivered only changes
> when we receive an ACK.
>
> We used RACK's solution, copying tcp_rack_sent_after() as
> tcp_skb_sent_after() helper to determine "which packet was
> sent last?". Later, we will use tcp_skb_sent_after() instead
> in RACK.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  include/net/tcp.h   |  6 ++++++
>  net/ipv4/tcp_rate.c | 11 ++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 6d50a66..fcd69fc 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1042,6 +1042,7 @@ struct rate_sample {
>         int  losses;            /* number of packets marked lost upon ACK */
>         u32  acked_sacked;      /* number of packets newly (S)ACKed upon ACK */
>         u32  prior_in_flight;   /* in flight before this ACK */
> +       u32  last_end_seq;      /* end_seq of most recently ACKed packet */
>         bool is_app_limited;    /* is sample from packet with bubble in pipe? */
>         bool is_retrans;        /* is sample from retransmission? */
>         bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> @@ -1158,6 +1159,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
>                   bool is_sack_reneg, struct rate_sample *rs);
>  void tcp_rate_check_app_limited(struct sock *sk);
>
> +static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
> +{
> +       return t1 > t2 || (t1 == t2 && after(seq1, seq2));
> +}
> +
>  /* These functions determine how the current flow behaves in respect of SACK
>   * handling. SACK is negotiated with the peer, and therefore it can vary
>   * between different flows.
> diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
> index 617b818..a8f6d9d 100644
> --- a/net/ipv4/tcp_rate.c
> +++ b/net/ipv4/tcp_rate.c
> @@ -74,27 +74,32 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
>   *
>   * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
>   * called multiple times. We favor the information from the most recently
> - * sent skb, i.e., the skb with the highest prior_delivered count.
> + * sent skb, i.e., the skb with the most recently sent time and the highest
> + * sequence.
>   */
>  void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
>                             struct rate_sample *rs)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
> +       u64 tx_tstamp;
>
>         if (!scb->tx.delivered_mstamp)
>                 return;
>
> +       tx_tstamp = tcp_skb_timestamp_us(skb);
>         if (!rs->prior_delivered ||
> -           after(scb->tx.delivered, rs->prior_delivered)) {
> +           tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
> +                              scb->end_seq, rs->last_end_seq)) {
>                 rs->prior_delivered_ce  = scb->tx.delivered_ce;
>                 rs->prior_delivered  = scb->tx.delivered;
>                 rs->prior_mstamp     = scb->tx.delivered_mstamp;
>                 rs->is_app_limited   = scb->tx.is_app_limited;
>                 rs->is_retrans       = scb->sacked & TCPCB_RETRANS;
> +               rs->last_end_seq     = scb->end_seq;
>
>                 /* Record send time of most recently ACKed packet: */
> -               tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
> +               tp->first_tx_mstamp  = tx_tstamp;
>                 /* Find the duration of the "send phase" of this window: */
>                 rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
>                                                      scb->tx.first_tx_mstamp);
> --

Thanks for the patch! The change looks good to me, and it passes our
team's packetdrill tests.

One suggestion: currently this patch seems to be targeted to the
net-next branch. However, since it's a bug fix my sense is that it
would be best to target this to the net branch, so that it gets
backported to stable releases.

One complication is that the follow-on patch in this series ("tcp: use
tcp_skb_sent_after() instead in RACK") is a pure re-factor/cleanup,
which is more appropriate for net-next. So the plan I was trying to
describe in the previous thread was that this series could be
implemented as:

(1) first, submit "tcp: ensure to use the most recently sent skb when
filling the rate sample" to the net branch
(2) wait for the fix in the net branch to be merged into the net-next branch
(3) second, submit "tcp: use tcp_skb_sent_after() instead in RACK" to
the net-next branch

What do folks think?

thanks,
neal
