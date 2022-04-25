Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3D50E15E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiDYNTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241748AbiDYNTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:19:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC6D1FA5F
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:16:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l18so2927800ejc.7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=psZ34ByDUdDpSza3GKwO42k6y0wsWNQJsTjX0bVciic=;
        b=T67kJSY/gZiIpNQ9HWzunwXivBmhqu3aa0oqcFMeOHMiaIKuW4dTWce5RPl68N6ode
         Mx+DeBXOxbWAh5+nlS8YbLX7HXGVlxmSrVc5C5hPzFAgYcVDFjFU1WmKY1VdAjy+Qouu
         EKRcxR92ncu+br9BaOUk6+O7RmNkQFztg1CGkpYO7dAQDc3wLjJFnJlLQzj9535O9Cii
         j1RsfuyC3ETWVOr831lq/tCzMTniKojP2FnP7R2NP8VrzWvy8oirH8LtD88wEW2EHPOJ
         Jzbi7IWx+QXAkanyQoq2JTUEMKIBjaAPHo4nmwJ4+5yF9NzhY7C8j9qUv+n2qcSFycMn
         le1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=psZ34ByDUdDpSza3GKwO42k6y0wsWNQJsTjX0bVciic=;
        b=A4+IbfzKF5fJoUCxk7k2ahZxWSsP087g3llDpfAtM3vdyJrYpy7x3DmoQ575VeZrni
         /Rs2ToTJSEv9+QpAlBvhqAoVcfwhDCl1P6j15qpbpPOHSKgtkrwmspqvchgwiPpnkJJp
         J1EDDN/NqIE2nzQBwB8c2boyrUPvvY52Kv7PhDKX5c4rLwlPLC2KJyBzTwi4oGxtfglW
         QZXTzee3QAvWRKJfuKU16cn83zV0lJOy7YvyNX+4HBdaeDBVRVI+iaXKV6uLl40DT5Xs
         iIOzW8rPoileLNcLZ/KPKGpQHhgMyA/kUvGKI0DKdBplzIQ05lKmrSaH3kGm6zmJukJH
         T77A==
X-Gm-Message-State: AOAM533zUYWrgaj6dzLYDLtetxmt4pYz2Xfic3eTz4yTorkZplxdy7OH
        98uWEuBAQhCIbe2g07v58Wrt//z0ND4Dz0ATY/I=
X-Google-Smtp-Source: ABdhPJyuj9FQhUsfOMIS1tI2yZnag7xgxZPIPrAZCdxrnAnDSfUP9Z4zKsOQGPi0SnbYvXIZ+wYf9jyJyXiwqjPu5qs=
X-Received: by 2002:a17:906:1692:b0:6e8:7641:c620 with SMTP id
 s18-20020a170906169200b006e87641c620mr15973969ejd.183.1650892574230; Mon, 25
 Apr 2022 06:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220425003407.3002429-1-eric.dumazet@gmail.com>
In-Reply-To: <20220425003407.3002429-1-eric.dumazet@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 25 Apr 2022 06:16:02 -0700
Message-ID: <CAA93jw7uoMCWT9oF52NhgozgCTJ4TAxpgNMNAZTaKqCpMR7uOg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Doug Porter <dsp@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 7:00 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
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
> SUM=3D0
> for i in {1..10}
> do
>  V=3D`netperf -H remote_host -l30 -t TCP_RR -- -r 10000000,10000 -o LOCAL=
_BYTES_SENT | egrep -v "MIGRATED|Bytes"`
>  echo $V
>  SUM=3D$(($SUM + $V))
> done
> echo SUM=3D$SUM
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
> SUM=3D1140000000
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
> SUM=3D4680000000  # This is 410 % of the value before patch.
>
> Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Doug Porter <dsp@fb.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  include/net/tcp.h     |  1 +
>  net/ipv4/tcp_input.c  | 12 +++++++++++-
>  net/ipv4/tcp_output.c |  1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 9987b3fba9f202632916cc439af9d17f1e68bcd3..cc1295037533a7741e454f7c0=
40f77a21deae02b 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -621,6 +621,7 @@ void tcp_synack_rtt_meas(struct sock *sk, struct requ=
est_sock *req);
>  void tcp_reset(struct sock *sk, struct sk_buff *skb);
>  void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff=
 *skb);
>  void tcp_fin(struct sock *sk);
> +void tcp_check_space(struct sock *sk);
>
>  /* tcp_timer.c */
>  void tcp_init_xmit_timers(struct sock *);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 2088f93fa37b5fb9110e7933242a27bd4009990e..48f6075228600896daa6507c4=
cd06acfc851a0fa 100644
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
> index 9ede847f4199844c5884e3f62ea450562072a0a7..1ca2f28c9981018e6cfaee343=
5d711467af6048d 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -82,6 +82,7 @@ static void tcp_event_new_data_sent(struct sock *sk, st=
ruct sk_buff *skb)
>
>         NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
>                       tcp_skb_pcount(skb));
> +       tcp_check_space(sk);
>  }
>
>  /* SND.NXT, if window was not shrunk or the amount of shrunk was less th=
an one
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>

Thx! We have been having very good results with TCP_NOTSENT_LOWAT set
to 32k or less behind an apache traffic server... and had some really
puzzling ones at geosync RTTs. Now I gotta go retest.

Side question: Is there a guide/set of recommendations to setting this
value more appropriately, under what circumstances? Could it
autoconfigure?

net.ipv4.tcp_notsent_lowat =3D 32768

--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
