Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5D0527C9F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiEPEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiEPEWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:22:34 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774CF17064
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:22:32 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7c57ee6feso139945857b3.2
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nkqESAv6tMpbSBRO1BLmU1vakhvFx4KIbE/32MqTVs=;
        b=Qf9df+8RRK2Pn8h98xUxCwoGP3oZdUkBILZoKZCUc5v9mJWXPsOGZTBHcpOXzYl86+
         vO5cqI+sfF7l5ZuF9bTU6rXGWv0fVellRa807AG2Xr/mmXdC3FwDKX4poy6Ua9sEiKl6
         TPU1It0iwZGT9Nrw+dKJzPNFTJ1NV/Ncya4AWuf9K55P/eVKB6t1hDS/xkggUb4ZAfzA
         l1M3exmmML+deks8FOGq7A8UHaFIPDK5ZxtNSI11jjBUn/wx8qp0Po1EO+8AwjjdDnAQ
         5/QKNklzSwjqE514VdpnhXxJ2D5ghiy4q4T30Fj/7awfhE9goh2WkGJhxzXCGlCVINFt
         CTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nkqESAv6tMpbSBRO1BLmU1vakhvFx4KIbE/32MqTVs=;
        b=dFe6XNfKEzV2ekKMDVlxV2p/+twOV509s6Oh5teuGviZScVfnOlipymQWbOrySzD98
         goSBaVjwwcC9PJpf06/5ZurcV65H7yFbBdyZDBMeU3QMNrh1RXx58OCRZJ0Cj8oDuVqB
         BDEcfSrxOw4vyW1J95jtm1Zl15Gpybbq+SNwE5o0hijVLzbbfGR1Ex2rO6DAMU/Cpoz8
         7MeTWW5bW5QuXC6F0Jpj+LL29xUuM3H3+/Au1qivoA54MNOBTL4AIYNpUyCUdBWcdDJf
         iwIKdMSDa+YXqSx/KEkPY0BKmU1MEDPjhBg7qWX2r0mFrJ3xZ4m+YTpE7a+HJpQAAfoi
         M8Rw==
X-Gm-Message-State: AOAM530Fij5sTrvK39wd2koTPOcLwq77T8VEyJIz8CnIGVhnhodo+jxi
        ri0Aov3LD5xByB0AMItyFp2V8x3xD22iJxXqmZIHmw==
X-Google-Smtp-Source: ABdhPJyJ8PN61ClxGsP8yTSb8wOvxHtQ5ucJxa02GXPGWd5/GA7yYOq5QFkoCc7NAfpauhLEAy2ENwTJacOOGUBIbY0=
X-Received: by 2002:a81:1408:0:b0:2ff:43c:b777 with SMTP id
 8-20020a811408000000b002ff043cb777mr1552095ywu.55.1652674951381; Sun, 15 May
 2022 21:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220516034519.184876-1-imagedong@tencent.com> <20220516034519.184876-9-imagedong@tencent.com>
In-Reply-To: <20220516034519.184876-9-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 15 May 2022 21:22:20 -0700
Message-ID: <CANn89iLxVgZfBA98DcAphxV1_scH2dx2Upc=XZ7+t0DWj8WNdg@mail.gmail.com>
Subject: Re: [PATCH net-next 8/9] net: tcp: add skb drop reasons to tcp tw
 code path
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Sun, May 15, 2022 at 8:46 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In order to get the reasons of skb drops, add a function argument of
> type 'enum skb_drop_reason *reason' to tcp_timewait_state_process().
>
> In the origin code, all packets to time-wait socket are treated as
> dropping with kfree_skb(), which can make users confused. Therefore,
> we use consume_skb() for the skbs that are 'good'. We can check the
> value of 'reason' to decide use kfree_skb() or consume_skb().
>
> The new reason 'TIMEWAIT' is added for the case that the skb is dropped
> as the socket in time-wait state.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h   |  5 +++++
>  include/net/tcp.h        |  7 ++++---
>  net/ipv4/tcp_ipv4.c      | 11 +++++++++--
>  net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++----
>  net/ipv6/tcp_ipv6.c      | 10 ++++++++--
>  5 files changed, 46 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4578bbab5a3e..8d18fc5a5af6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -560,6 +560,10 @@ struct sk_buff;
>   * SKB_DROP_REASON_TCP_REQQFULLDROP
>   *     request queue of the listen socket is full, corresponding to
>   *     LINUX_MIB_TCPREQQFULLDROP
> + *
> + * SKB_DROP_REASON_TIMEWAIT
> + *     socket is in time-wait state and all packet that received will
> + *     be treated as 'drop', except a good 'SYN' packet
>   */
>  #define __DEFINE_SKB_DROP_REASON(FN)   \
>         FN(NOT_SPECIFIED)               \
> @@ -631,6 +635,7 @@ struct sk_buff;
>         FN(TCP_ABORTONDATA)             \
>         FN(LISTENOVERFLOWS)             \
>         FN(TCP_REQQFULLDROP)            \
> +       FN(TIMEWAIT)                    \
>         FN(MAX)
>
>  /* The reason of skb drop, which is used in kfree_skb_reason().
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 082dd0627e2e..88217b8d95ac 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -380,9 +380,10 @@ enum tcp_tw_status {
>  };
>
>
> -enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
> -                                             struct sk_buff *skb,
> -                                             const struct tcphdr *th);
> +enum tcp_tw_status
> +tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> +                          const struct tcphdr *th,
> +                          enum skb_drop_reason *reason);
>  struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>                            struct request_sock *req, bool fastopen,
>                            bool *lost_race);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 708f92b03f42..9174ee162633 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2134,7 +2134,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
>                 inet_twsk_put(inet_twsk(sk));
>                 goto csum_error;
>         }
> -       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
> +       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
> +                                          &drop_reason)) {
>         case TCP_TW_SYN: {
>                 struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
>                                                         &tcp_hashinfo, skb,
> @@ -2150,12 +2151,18 @@ int tcp_v4_rcv(struct sk_buff *skb)
>                         refcounted = false;
>                         goto process;
>                 }
> +               /* TCP_FLAGS or NO_SOCKET? */
> +               SKB_DR_SET(drop_reason, TCP_FLAGS);
>         }
>                 /* to ACK */
>                 fallthrough;
>         case TCP_TW_ACK:
>                 tcp_v4_timewait_ack(sk, skb);
> -               break;
> +               refcounted = false;
> +               if (drop_reason)
> +                       goto discard_it;
> +               else
> +                       goto put_and_return;
>         case TCP_TW_RST:
>                 tcp_v4_send_reset(sk, skb);
>                 inet_twsk_deschedule_put(inet_twsk(sk));
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 1a21018f6f64..329724118b7f 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -83,13 +83,15 @@ tcp_timewait_check_oow_rate_limit(struct inet_timewait_sock *tw,
>   */
>  enum tcp_tw_status
>  tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
> -                          const struct tcphdr *th)
> +                          const struct tcphdr *th,
> +                          enum skb_drop_reason *reason)
>  {
>         struct tcp_options_received tmp_opt;
>         struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
>         bool paws_reject = false;
>
>         tmp_opt.saw_tstamp = 0;
> +       *reason = SKB_DROP_REASON_NOT_SPECIFIED;
>         if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
>                 tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
>
> @@ -113,11 +115,16 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
>                         return tcp_timewait_check_oow_rate_limit(
>                                 tw, skb, LINUX_MIB_TCPACKSKIPPEDFINWAIT2);
>
> -               if (th->rst)
> +               if (th->rst) {
> +                       SKB_DR_SET(*reason, TCP_RESET);
>                         goto kill;
> +               }
>
> -               if (th->syn && !before(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt))
> +               if (th->syn && !before(TCP_SKB_CB(skb)->seq,
> +                                      tcptw->tw_rcv_nxt)) {
> +                       SKB_DR_SET(*reason, TCP_FLAGS);
>                         return TCP_TW_RST;
> +               }
>
>                 /* Dup ACK? */
>                 if (!th->ack ||
> @@ -143,6 +150,9 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
>                 }
>
>                 inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
> +
> +               /* skb should be free normally on this case. */
> +               *reason = SKB_NOT_DROPPED_YET;
>                 return TCP_TW_ACK;
>         }
>
> @@ -174,6 +184,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
>                          * protocol bug yet.
>                          */
>                         if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
> +                               SKB_DR_SET(*reason, TCP_RESET);
>  kill:
>                                 inet_twsk_deschedule_put(tw);
>                                 return TCP_TW_SUCCESS;
> @@ -216,11 +227,14 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
>                 if (isn == 0)
>                         isn++;
>                 TCP_SKB_CB(skb)->tcp_tw_isn = isn;
> +               *reason = SKB_NOT_DROPPED_YET;
>                 return TCP_TW_SYN;
>         }
>
> -       if (paws_reject)
> +       if (paws_reject) {
> +               SKB_DR_SET(*reason, TCP_RFC7323_PAWS);
>                 __NET_INC_STATS(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
> +       }
>
>         if (!th->rst) {
>                 /* In this case we must reset the TIMEWAIT timer.
> @@ -232,9 +246,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
>                 if (paws_reject || th->ack)
>                         inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
>
> +               SKB_DR_OR(*reason, TIMEWAIT);
>                 return tcp_timewait_check_oow_rate_limit(
>                         tw, skb, LINUX_MIB_TCPACKSKIPPEDTIMEWAIT);
>         }
> +       SKB_DR_SET(*reason, TCP_RESET);
>         inet_twsk_put(tw);
>         return TCP_TW_SUCCESS;
>  }
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 27c51991bd54..5c777006de3d 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1795,7 +1795,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
>                 goto csum_error;
>         }
>
> -       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
> +       switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
> +                                          &drop_reason)) {
>         case TCP_TW_SYN:
>         {
>                 struct sock *sk2;
> @@ -1815,12 +1816,17 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
>                         refcounted = false;
>                         goto process;
>                 }
> +               SKB_DR_SET(drop_reason, TCP_FLAGS);
>         }
>                 /* to ACK */
>                 fallthrough;
>         case TCP_TW_ACK:
>                 tcp_v6_timewait_ack(sk, skb);
> -               break;
> +               refcounted = false;
> +               if (drop_reason)
> +                       goto discard_it;
> +               else
> +                       goto put_and_return;

My brain exploded.
I guarantee you that whoever is going to look at this code in one year
will be completely lost.
Adding so much complexity is crazy.

About: refcounted = false ;

This is not going to be used id "goto discard_it;" is taken.

If the "goto put_and_return;" is taken, this boils down to:

return ret ? -1 : 0;

Are you sure ret is even initialized at this point ?

Why are we doing this ? We were doing "return 0;"

Also, where is skb freed ?

Are you calling tcp_v6_timewait_ack(sk, skb) after skb has been freed ???




>         case TCP_TW_RST:
>                 tcp_v6_send_reset(sk, skb);
>                 inet_twsk_deschedule_put(inet_twsk(sk));
> --
> 2.36.1
>
