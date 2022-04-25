Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC69250D81B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 06:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbiDYELs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 00:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiDYELU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 00:11:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02343818F
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 21:07:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k23so27225914ejd.3
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 21:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sQ+O3/xP5eT1KZHSLryLJxyjoKpaxSWFkeWafy1wLPM=;
        b=UckCWFkT3SGx97eHbB2vUaEK6xtSvlO5EWCnKJVAop8ylYJWjbsXQW0EXiGieh2+Qs
         cs730flF7mTc1E3D4PouVL0I2FQvRUEJ1yKmtFZ7dnLgKt2251rE/sgtWcIgKej1aOnj
         vBEf7M7ml40h/V8koLyid7k05uv9yhWQh8fKoJBG3hbGgjXQ9II/zfkEkStg90jEs2OJ
         /+7KNspiR+Lrr0ic1rMLcQgjScYcIixQYbkRsf+QrU8HjwbOKCmu5uWcTf5ahB+og/+I
         IurYGewuadt6whITuutToI0kNLlU/9WjReQeppAbO1hCctCPxxIK+5Ggy6wJ3kjG4z1G
         2lZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sQ+O3/xP5eT1KZHSLryLJxyjoKpaxSWFkeWafy1wLPM=;
        b=14iOhyMlmNqlGRPNLWpro+2VLFtI41E+XLBaRcVVACiIkVPIliWpHlWBXsTtMfus79
         SRYYs3eK8rQF+tPq0QaOIag23wRnvna+JrDZVM8xo8IzwmB3SMK33jmgej78YvHTkx8v
         /gvUGgbcAP++j6MTAdXk6H7qpNm9DK/c+ROIBA+mQtQDskqGAEpByGKQVUvDZJ4EUrMY
         nFxCG4+rBAbOqSeAr1T2G8ZQksfNFa1wb2YDqKwQ7aUlRxgDNBxRHah1M/CelsOZcQEr
         wQsStbUn17LTVI0ZzSruA9cPTJTbYMlAfctCHJm2Moein8oMGb0R9jj8AfswbpD3xT9G
         0qmA==
X-Gm-Message-State: AOAM5320vcC1hOV+QckDum8cTZvQ/R5ZZPBK8IUvj4WBVoMG9UZ3PNvx
        s2QwnvM/nn/NiRA8rWlRix9cM4fLrJgSRHA8b3Uisf4XF76edcNH
X-Google-Smtp-Source: ABdhPJyWG+KROEqbyxdkUlQ1QsKPJV8Ta09Uxctpjpm8UVFgTCUBFVHSQC92xjDl3zxjSKwSl0d6EWXDoRoIbS+1wMI=
X-Received: by 2002:a17:907:1b19:b0:6f0:1022:1430 with SMTP id
 mp25-20020a1709071b1900b006f010221430mr14894056ejc.13.1650859654883; Sun, 24
 Apr 2022 21:07:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220425003407.3002429-1-eric.dumazet@gmail.com>
In-Reply-To: <20220425003407.3002429-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 25 Apr 2022 00:06:58 -0400
Message-ID: <CACSApvaOTp5AT-uFZ0qxQegYscq2x=d+cL23YuyrDHWUjdpvxQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Doug Porter <dsp@fb.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 8:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> I had this bug sitting for too long in my pile, it is time to fix it.
>
> Thanks to Doug Porter for reminding me of it!
>
> We had various attempts in the past, including commit
> 0cbe6a8f089e ("tcp: remove SOCK_QUEUE_SHRUNK"),
> but the issue is that TCP stack currently only generates
> EPOLLOUT from input path, when tp->snd_una has advanced
> and skb(s) cleaned from rtx queue.
>
> If a flow has a big RTT, and/or receives SACKs, it is possible
> that the notsent part (tp->write_seq - tp->snd_nxt) reaches 0
> and no more data can be sent until tp->snd_una finally advances.
>
> What is needed is to also check if POLLOUT needs to be generated
> whenever tp->snd_nxt is advanced, from output path.
>
> This bug triggers more often after an idle period, as
> we do not receive ACK for at least one RTT. tcp_notsent_lowat
> could be a fraction of what CWND and pacing rate would allow to
> send during this RTT.
>
> In a followup patch, I will remove the bogus call
> to tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED)
> from tcp_check_space(). Fact that we have decided to generate
> an EPOLLOUT does not mean the application has immediately
> refilled the transmit queue. This optimistic call
> might have been the reason the bug seemed not too serious.
>
> Tested:
>
> 200 ms rtt, 1% packet loss, 32 MB tcp_rmem[2] and tcp_wmem[2]
>
> $ echo 500000 >/proc/sys/net/ipv4/tcp_notsent_lowat
> $ cat bench_rr.sh
> SUM=0
> for i in {1..10}
> do
>  V=`netperf -H remote_host -l30 -t TCP_RR -- -r 10000000,10000 -o LOCAL_BYTES_SENT | egrep -v "MIGRATED|Bytes"`
>  echo $V
>  SUM=$(($SUM + $V))
> done
> echo SUM=$SUM
>
> Before patch:
> $ bench_rr.sh
> 130000000
> 80000000
> 140000000
> 140000000
> 140000000
> 140000000
> 130000000
> 40000000
> 90000000
> 110000000
> SUM=1140000000
>
> After patch:
> $ bench_rr.sh
> 430000000
> 590000000
> 530000000
> 450000000
> 450000000
> 350000000
> 450000000
> 490000000
> 480000000
> 460000000
> SUM=4680000000  # This is 410 % of the value before patch.
>
> Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Doug Porter <dsp@fb.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the fix!

> ---
>  include/net/tcp.h     |  1 +
>  net/ipv4/tcp_input.c  | 12 +++++++++++-
>  net/ipv4/tcp_output.c |  1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 9987b3fba9f202632916cc439af9d17f1e68bcd3..cc1295037533a7741e454f7c040f77a21deae02b 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -621,6 +621,7 @@ void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
>  void tcp_reset(struct sock *sk, struct sk_buff *skb);
>  void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
>  void tcp_fin(struct sock *sk);
> +void tcp_check_space(struct sock *sk);
>
>  /* tcp_timer.c */
>  void tcp_init_xmit_timers(struct sock *);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 2088f93fa37b5fb9110e7933242a27bd4009990e..48f6075228600896daa6507c4cd06acfc851a0fa 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5454,7 +5454,17 @@ static void tcp_new_space(struct sock *sk)
>         INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
>  }
>
> -static void tcp_check_space(struct sock *sk)
> +/* Caller made space either from:
> + * 1) Freeing skbs in rtx queues (after tp->snd_una has advanced)
> + * 2) Sent skbs from output queue (and thus advancing tp->snd_nxt)
> + *
> + * We might be able to generate EPOLLOUT to the application if:
> + * 1) Space consumed in output/rtx queues is below sk->sk_sndbuf/2
> + * 2) notsent amount (tp->write_seq - tp->snd_nxt) became
> + *    small enough that tcp_stream_memory_free() decides it
> + *    is time to generate EPOLLOUT.
> + */
> +void tcp_check_space(struct sock *sk)
>  {
>         /* pairs with tcp_poll() */
>         smp_mb();
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 9ede847f4199844c5884e3f62ea450562072a0a7..1ca2f28c9981018e6cfaee3435d711467af6048d 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -82,6 +82,7 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>
>         NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
>                       tcp_skb_pcount(skb));
> +       tcp_check_space(sk);
>  }
>
>  /* SND.NXT, if window was not shrunk or the amount of shrunk was less than one
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>
