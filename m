Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FEB6CB91B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjC1INY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjC1INW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:13:22 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E3B1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:13:21 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y85so5020849iof.13
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 01:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679991201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UllKSXpClfzRh6etv67Dn7QqTZmFbEtwqH7NwKr6ZkM=;
        b=jOCfCax2JpMqg2Mtv8IaqZb7fjUoiB8+13RaESKewVHyNZ7U3yZqzpfQlEQL0AiTR1
         UvWfk3eNFMO8J1XiHYr4YJFjsmgcwn0sxYkotkXfbh7XxbkB94n+46wlfO5FaTff/p+N
         i0QRtRIfWO76KXHYh7YkcDzt/K8ppR1QAHbN+Ii6LjYQI/S7RrBJoyFYZWY/QRfqjN+b
         Xs9whEnMpXHPwnjH2Oq0bLpjLM2wGBQboJq8LTC2MC4AvzOqWV+SWsZe6jmMX9JqiYPi
         gaXnTQmdWFPX9u4bv7IRxMI/jGRptuGqmR6rzmeKct3Iv2KHvIxAQArY+6XzQW5pU909
         cCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679991201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UllKSXpClfzRh6etv67Dn7QqTZmFbEtwqH7NwKr6ZkM=;
        b=deEOfUE4GZM2OQH9lOm0no7Qvhx+CvBvbJ6YkZWmKd5TTrq1eZAjacSLwblsgvccMI
         U39V1BC+PRsJR3KyqGp+ZVqGdF+HQyJVh2feQIOsBoJQx6Guu6c7xjTAr0DviNwldxkH
         iyMUTv9D+HEOvvwmtzkYwSJ5J9zMj10/Pgx3BigBVX8FAE+NaCd0VFs66BPWqVA2ZZUD
         biJwcyzvy4Qkm9Wp/L7sjxVF1jnwEg49/zNFeFsa0dG8p5H9EMIWUNFZC17M50OJrn3o
         W+29W0ZTL6amuHaof5y+I+3bcj/bxAuEBV+daUhnn0KuEHbkdWla63V6xBxyWi9PZY4x
         mCSA==
X-Gm-Message-State: AO0yUKUC0B3ioS5wo/TqOUh/sEZV2qUlzi5nQJrP6ezyl44wVmL+461y
        w7YcPNDcMyeyfMyVc16hmMy9D8Js3/hnMighRmN6lVapWWKRSZ59psVK0MKG
X-Google-Smtp-Source: AK7set+TMdRrk31zYY86vjJoPyvsN2RIqC/JzGBGu368q5ZJvMQMK+1LbytiVyEpivlfej6xr3yT0i41ZcyvLLcuoO4=
X-Received: by 2002:a02:95a1:0:b0:3ec:dc1f:12dd with SMTP id
 b30-20020a0295a1000000b003ecdc1f12ddmr5488368jai.6.1679991200578; Tue, 28 Mar
 2023 01:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230327230628.45660-1-kuniyu@amazon.com>
In-Reply-To: <20230327230628.45660-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 01:13:09 -0700
Message-ID: <CANn89iLF6_iUd6DSbrqALSvowPfNKqnOrX27GpVPLSCG-FipCA@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp: Refine SYN handling for PAWS.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 4:06=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> Our Network Load Balancer (NLB) [0] has multiple nodes with different
> IP addresses, and each node forwards TCP flows from clients to backend
> targets.  NLB has an option to preserve the client's source IP address
> and port when routing packets to backend targets.
>
> When a client connects to two different NLB nodes, they may select the
> same backend target.  Then, if the client has used the same source IP
> and port, the two flows at the backend side will have the same 4-tuple.
>
> While testing around such cases, I saw these sequences on the backend
> target.
>
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62=
727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length=
 0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2=
819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 102981=
6180,nop,wscale 7], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, option=
s [nop,nop,TS val 1029816181 ecr 1224784076], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62=
727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length =
0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, option=
s [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156=
821005}], length 0
>
> It seems to be working correctly, but the last ACK was generated by
> tcp_send_dupack() and PAWSEstab was increased.  This is because the
> second connection has a smaller timestamp than the first one.
>
> In this case, we should send a challenge ACK instead of a dup ACK and
> increase the correct counter to rate-limit it properly.

OK, but this seems about the same thing to me. A challenge ACK is a dup ACK=
 ?

It is not clear why it matters, because most probably both ACK make no
sense for the sender ?

>
> Let's check the SYN bit after the PAWS tests to avoid adding unnecessary
> overhead for most packets.
>
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/int=
roduction.html [0]
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/loa=
d-balancer-target-groups.html#client-ip-preservation [1]
> Fixes: 0c24604b68fc ("tcp: implement RFC 5961 4.2")

The core of the change was to not send an RST anymore.
I did not change part of the code which was not sending an RST :)



> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/tcp_input.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc072d2cfcd8..89fca4c18530 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5714,6 +5714,8 @@ static bool tcp_validate_incoming(struct sock *sk, =
struct sk_buff *skb,
>             tp->rx_opt.saw_tstamp &&
>             tcp_paws_discard(sk, skb)) {
>                 if (!th->rst) {
> +                       if (unlikely(th->syn))
> +                               goto syn_challenge;
>                         NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABRE=
JECTED);
>                         if (!tcp_oow_rate_limited(sock_net(sk), skb,
>                                                   LINUX_MIB_TCPACKSKIPPED=
PAWS,
> --
> 2.30.2
>
